-- LIMPIEZA DE TRIGGERS EXISTENTES

DROP TRIGGER IF EXISTS disponibilidad_vehiculo;
DROP TRIGGER IF EXISTS restriccion_fecha_devolucion;
DROP TRIGGER IF EXISTS penalizacion_combustible;
DROP TRIGGER IF EXISTS penalizacion_cancelacion;
DROP TRIGGER IF EXISTS seguro_obligatorio;
DROP TRIGGER IF EXISTS antiguedad_carnet;
DROP TRIGGER IF EXISTS oferta_fidelidad;
DROP TRIGGER IF EXISTS vehiculo_a_mantenimiento;

-- BLOQUE 1: REGLAS DE NEGOCIO (RN-001 a RN-008)

-- RN-001: Un vehículo no puede ser reservado si está en mantenimiento o alquilado
DELIMITER //
CREATE TRIGGER disponibilidad_vehiculo
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_estado VARCHAR(50);

    SELECT tipo_estado INTO v_estado
    FROM Vehiculos
    WHERE id = NEW.vehiculoId;

    IF v_estado IN ('en_mantenimiento', 'alquilado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RN-001: El vehículo no está disponible (en mantenimiento o ya alquilado).';
    END IF;
END //
DELIMITER ;

-- RN-002: Un vehículo no puede ser devuelto más tarde de la fecha de devolución pactada
DELIMITER //
CREATE TRIGGER restriccion_fecha_devolucion
BEFORE UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'finalizada' AND OLD.estado != 'finalizada' THEN
        IF NEW.fecha_devolucion_real > NEW.fecha_devolucion THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN-002: Un vehículo no puede ser devuelto más tarde de la fecha pactada.';
        END IF;
    END IF;
END //
DELIMITER ;

-- RN-003: Si combustible_final < combustible_inicial, se suma penalización (2.00€ por litro faltante)
DELIMITER //
CREATE TRIGGER penalizacion_combustible
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_multa_combustible DECIMAL(10,2) DEFAULT 0.00;

    IF NEW.estado = 'finalizada' AND OLD.estado != 'finalizada' THEN
        IF NEW.combustible_final IS NOT NULL AND NEW.combustible_final < NEW.combustible_inicial THEN
            SET v_multa_combustible = (NEW.combustible_inicial - NEW.combustible_final) * 2.00;
            
            UPDATE facturas
            SET penalizacion_combustible = COALESCE(penalizacion_combustible, 0.00) + v_multa_combustible,
                importe_total = importe_total + v_multa_combustible
            WHERE reservaId = NEW.id;
        END IF;
    END IF;
END //
DELIMITER ;

-- RN-004: Si se cancela después de la fecha_limite, penalización de 50.00€
DELIMITER //
CREATE TRIGGER penalizacion_cancelacion
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_multa_cancelacion DECIMAL(10,2) DEFAULT 50.00;

    IF NEW.estado = 'cancelada' AND OLD.estado != 'cancelada' THEN
        IF CURDATE() > NEW.fecha_limite THEN
            UPDATE facturas
            SET penalizacion_cancelacion = COALESCE(penalizacion_cancelacion, 0.00) + v_multa_cancelacion,
                importe_total = importe_total + v_multa_cancelacion
            WHERE reservaId = NEW.id;
        END IF;
    END IF;
END //
DELIMITER ;

-- RN-005: Es obligatorio tener al menos un tipo de seguro (básico o premium)
DELIMITER //
CREATE TRIGGER seguro_obligatorio
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_basico BOOLEAN;
    DECLARE v_premium BOOLEAN;

    SELECT seguro_basico, seguro_premium 
    INTO v_basico, v_premium
    FROM Seguros
    WHERE id = NEW.seguroId;

    IF (v_basico IS NOT TRUE AND v_premium IS NOT TRUE) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RN-005: Es obligatorio contratar seguro básico o premium.';
    END IF;
END //
DELIMITER ;

-- RN-006: Los clientes deben tener una antigüedad mínima de un año de carnet
DELIMITER //
CREATE TRIGGER antiguedad_carnet
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_fecha_carnet DATE;

    SELECT fecha_carnet INTO v_fecha_carnet
    FROM Clientes
    WHERE id = NEW.clienteRealizaId;

    IF TIMESTAMPDIFF(YEAR, v_fecha_carnet, NEW.fecha_recogida) < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'RN-006: El cliente debe tener una antigüedad mínima de carnet de un año.';
    END IF;
END //
DELIMITER ;

-- RN-007: La oferta de fidelidad se aplica cada 5 reservas de un mismo cliente
DELIMITER //
CREATE TRIGGER oferta_fidelidad
AFTER INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_num_reservas INT;

    SELECT COUNT(*) INTO v_num_reservas
    FROM Reservas
    WHERE clienteRealizaId = NEW.clienteRealizaId;

    IF (v_num_reservas % 5) = 0 THEN
        INSERT INTO ofertas (reservaId, descuento_total, oferta_mes, oferta_fidelidad)
        VALUES (NEW.id, 15.00, 0.00, 15.00);
    END IF;
END //
DELIMITER ;

-- RN-008: Es obligatorio que cada vehículo pase una revisión después de cada cliente
DELIMITER //
CREATE TRIGGER vehiculo_a_mantenimiento
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'finalizada' AND OLD.estado != 'finalizada' THEN
        UPDATE Vehiculos
        SET tipo_estado = 'en_mantenimiento'
        WHERE id = NEW.vehiculoId;
    END IF;
END //
DELIMITER ;

-- LIMPIEZA DE TRIGGERS DEL BLOQUE 2

DROP TRIGGER IF EXISTS calculo_precio_reserva_insert;
DROP TRIGGER IF EXISTS calculo_precio_reserva_update;
DROP TRIGGER IF EXISTS estado_vehiculo_alquilado;
DROP TRIGGER IF EXISTS estado_vehiculo_cancelado;
DROP TRIGGER IF EXISTS estado_vehiculo_revision;
DROP TRIGGER IF EXISTS generar_factura_reserva;
DROP TRIGGER IF EXISTS actualizar_factura_cancelacion;


-- BLOQUE 2: CÁLCULOS Y CAMBIOS AUTOMÁTICOS ENTRE TABLAS

-- 1A. Cálculo automático de precio_total al CREAR la reserva
DELIMITER //
CREATE TRIGGER calculo_precio_reserva_insert
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_precio_dia DECIMAL(10,2);
    DECLARE v_dias INT;

    SELECT precio_dia INTO v_precio_dia
    FROM Vehiculos
    WHERE id = NEW.vehiculoId;

    SET v_dias = GREATEST(1, DATEDIFF(NEW.fecha_devolucion, NEW.fecha_recogida));
    SET NEW.precio_total = v_precio_dia * v_dias;
END //
DELIMITER ;

-- 1B. Recálculo automático de precio_total si se MODIFICAN fechas o vehículo
DELIMITER //
CREATE TRIGGER calculo_precio_reserva_update
BEFORE UPDATE ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_precio_dia DECIMAL(10,2);
    DECLARE v_dias INT;

    IF NEW.fecha_recogida != OLD.fecha_recogida 
       OR NEW.fecha_devolucion != OLD.fecha_devolucion 
       OR NEW.vehiculoId != OLD.vehiculoId THEN

        SELECT precio_dia INTO v_precio_dia
        FROM Vehiculos
        WHERE id = NEW.vehiculoId;

        SET v_dias = GREATEST(1, DATEDIFF(NEW.fecha_devolucion, NEW.fecha_recogida));
        SET NEW.precio_total = v_precio_dia * v_dias;
    END IF;
END //
DELIMITER ;

-- 2A. Cambiar estado del vehículo a 'alquilado' al confirmar reserva
DELIMITER //
CREATE TRIGGER estado_vehiculo_alquilado
AFTER INSERT ON Reservas
FOR EACH ROW
BEGIN
    UPDATE Vehiculos
    SET tipo_estado = 'alquilado'
    WHERE id = NEW.vehiculoId;
END //
DELIMITER ;

-- 2B. Devolver el vehículo a 'disponible' si la reserva se cancela
DELIMITER //
CREATE TRIGGER estado_vehiculo_cancelado
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'cancelada' AND OLD.estado != 'cancelada' THEN
        UPDATE Vehiculos
        SET tipo_estado = 'disponible'
        WHERE id = NEW.vehiculoId;
    END IF;
END //
DELIMITER ;

-- 2C. Devolver el vehículo a 'disponible' tras pasar una revisión (cierra ciclo RN-008)
DELIMITER //
CREATE TRIGGER estado_vehiculo_revision
AFTER INSERT ON Revision
FOR EACH ROW
BEGIN
    UPDATE Vehiculos
    SET tipo_estado = 'disponible'
    WHERE id = NEW.vehiculoId;
END //
DELIMITER ;

-- 3A. Generar factura automáticamente al crear la reserva (Vehículo + Seguro + Extra - Oferta)
DELIMITER //
CREATE TRIGGER generar_factura_reserva
AFTER INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_dias INT;
    DECLARE v_precio_seguro DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_precio_extra DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_descuento DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_total DECIMAL(10,2) DEFAULT 0.00;

    SET v_dias = GREATEST(1, DATEDIFF(NEW.fecha_devolucion, NEW.fecha_recogida));

    -- Obtener precio diario del seguro
    SELECT COALESCE(precio, 0.00) INTO v_precio_seguro
    FROM Seguros
    WHERE id = NEW.seguroId;

    -- Obtener precio diario del extra (si tiene)
    IF NEW.extraId IS NOT NULL THEN
        SELECT COALESCE(precio_extra, 0.00) INTO v_precio_extra
        FROM Extra
        WHERE id = NEW.extraId;
    END IF;

    -- Obtener descuento si se le aplicó oferta de fidelidad (RN-007)
    SELECT COALESCE(descuento_total, 0.00) INTO v_descuento
    FROM ofertas
    WHERE reservaId = NEW.id
    LIMIT 1;

    SET v_total = GREATEST(0.00, NEW.precio_total + v_precio_seguro + v_precio_extra  - v_descuento);

    INSERT INTO facturas (reservaId, importe_total, penalizacion_cancelacion, penalizacion_combustible)
    VALUES (NEW.id, v_total, 0.00, 0.00);
END //
DELIMITER ;

-- 3B. Ajustar factura si se cancela la reserva (anula alquiler base y deja solo posible penalización RN-004)
DELIMITER //
CREATE TRIGGER actualizar_factura_cancelacion
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.estado = 'cancelada' AND OLD.estado != 'cancelada' THEN
        UPDATE facturas
        SET importe_total = COALESCE(penalizacion_cancelacion, 0.00)
        WHERE reservaId = NEW.id;
    END IF;
END //
DELIMITER ;
