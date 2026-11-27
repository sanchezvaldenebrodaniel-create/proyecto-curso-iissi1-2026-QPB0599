#TRIGGERS

#RN 001 
DELIMITER //
CREATE TRIGGER Restriccion_disponibilidad BEFORE INSERT ON reservas 
FOR EACH ROW
BEGIN 
	
	DECLARE estado_vehiculo VARCHAR(255);
	
	SELECT tipo_estado INTO estado_vehiculo
	FROM vehiculos 
	WHERE id = NEW.vehiculoId;
	
	IF estado_vehiculo IN ('en_mantenimiento', 'alquilado') THEN 
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'El vehículo no está disponible esta en mantenimiento o ya alquilado.';
	END IF;
END //
DELIMITER ;

#FALTA EL 1B PARA ACTUALIZAR LA DISPONIBILIDAD
DELIMITER //
CREATE TRIGGER Actualizar_disponibilidad_alquilado
AFTER INSERT ON Reservas
FOR EACH ROW
BEGIN
    UPDATE Vehiculos
    SET tipo_estado = 'alquilado'
    WHERE id = NEW.vehiculoId;
END //
DELIMITER ;

#RN 002 - ERROR
DELIMITER //
CREATE TRIGGER Restriccion_fecha BEFORE UPDATE ON reservas
FOR EACH ROW
BEGIN 
	IF NEW.estado = 'finalizada' AND OLD.estado != 'finalizada' THEN 
		IF NEW.fecha_devolucion_real > NEW.fecha_devolucion THEN 
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Un vehiculo no puede ser devuelto más tarde de la fecha pactada';
		END IF;
	END IF;
END //
DELIMITER ;	

#RN 003
DELIMITER //
CREATE TRIGGER Penalizacion_combustible
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_cargo DECIMAL(10,2) DEFAULT 50.00;

    IF NEW.estado = 'finalizada' AND OLD.estado != 'finalizada' THEN
        IF NEW.combustible_final < NEW.combustible_inicial THEN
            UPDATE facturas
            SET penalizacion_combustible = COALESCE(penalizacion_combustible, 0) + v_cargo,
                importe_total = importe_total + v_cargo
            WHERE reservaId = NEW.id;
        END IF;
    END IF;
END //
DELIMITER ;

#RN 004
DELIMITER //
CREATE TRIGGER Penalizacion_cancelacion
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_multa DECIMAL(10,2) DEFAULT 50.00;

    IF (NEW.estado = 'cancelada' AND OLD.estado != 'cancelada') 
       OR (NEW.clienteCancelaId IS NOT NULL AND OLD.clienteCancelaId IS NULL) THEN
        
        IF CURDATE() > NEW.fecha_limite THEN
            UPDATE facturas
            SET penalizacion_cancelacion = COALESCE(penalizacion_cancelacion, 0) + v_multa,
                importe_total = importe_total + v_multa
            WHERE reservaId = NEW.id;
        END IF;
    END IF;
END //
DELIMITER ;

#RN 005 
DELIMITER //
CREATE TRIGGER Seguro_obligatorio
BEFORE UPDATE ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_basico BOOLEAN DEFAULT FALSE;
    DECLARE v_premium BOOLEAN DEFAULT FALSE;

    IF NEW.estado = 'finalizada' AND OLD.estado != 'finalizada' THEN
        IF NEW.seguroId IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN-005: Ninguna reserva podrá ser finalizada sin haber seleccionado un seguro.';
        END IF;

        SELECT seguro_basico, seguro_premium 
        INTO v_basico, v_premium
        FROM Seguros
        WHERE id = NEW.seguroId;

        IF (v_basico IS NOT TRUE AND v_premium IS NOT TRUE) THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'RN-005: Debe seleccionar seguro básico o seguro premium antes de finalizar.';
        END IF;
    END IF;
END //
DELIMITER ;

#RN 006
DELIMITER //
CREATE TRIGGER Antiguedad_carnet
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

#RN 007
DELIMITER //
CREATE TRIGGER Oferta_Fidelidad
AFTER INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE v_num_reservas INT;

    SELECT COUNT(*) INTO v_num_reservas
    FROM Reservas
    WHERE clienteRealizaId = NEW.clienteRealizaId;

    IF (v_num_reservas % 5) = 0 THEN
        INSERT INTO ofertas (reservaId, descuento_total, oferta_mes, oferta_fidelidad)
        VALUES (NEW.id, 15, 0, 15);
    END IF;
END //
DELIMITER ;

#RN 008
DELIMITER //
CREATE TRIGGER Mantenimiento_vehiculos
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
