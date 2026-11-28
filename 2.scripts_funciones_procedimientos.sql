-- ============================================================================
--                                  FUNCIONES
-- ============================================================================

-- 1. RN-007 (Oferta de fidelidad): Cuenta el total de reservas acumuladas por un cliente para comprobar si alcanza el múltiplo de 5 y le corresponde el descuento.
DELIMITER //
CREATE OR REPLACE FUNCTION fTotalReservasCliente(p_clienteId INT) RETURNS INT
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total 
    FROM Reservas 
    WHERE clienteRealizaId = p_clienteId;
    RETURN total;
END //
DELIMITER ;

-- 2. RN-006 (Antigüedad mínima de carnet): Calcula los años transcurridos desde la fecha de expedición del carnet de un cliente para verificar que cumple el mínimo de 1 año.
DELIMITER //
CREATE OR REPLACE FUNCTION fAntiguedadCarnet(p_clienteId INT) RETURNS INT
BEGIN
    DECLARE anios INT;
    SELECT TIMESTAMPDIFF(YEAR, fecha_carnet, CURDATE()) INTO anios 
    FROM Clientes 
    WHERE id = p_clienteId;
    RETURN anios;
END //
DELIMITER ;

-- 3. RF-006 (Añadir extras): Obtiene el precio del extra contratado en una reserva concreta (GPS, sillita de bebé o conductor extra), devolviendo 0.00 si no tiene ninguno.
DELIMITER //
CREATE OR REPLACE FUNCTION fCosteExtraReserva(p_reservaId INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE costeExtra DECIMAL(10,2);
    SELECT IFNULL(e.precio_extra, 0.00) INTO costeExtra 
    FROM Reservas r
    LEFT JOIN Extra e ON r.extraId = e.id
    WHERE r.id = p_reservaId;
    RETURN costeExtra;
END //
DELIMITER ;

-- 4. RN-003 (Penalización por combustible): Compara el combustible inicial y final de una reserva y calcula el cargo adicional (2.00€ por unidad faltante) si se devuelve con menos nivel.
DELIMITER //
CREATE OR REPLACE FUNCTION fCalculaPenalizacionCombustible(p_reservaId INT) RETURNS DECIMAL(10,2)
BEGIN
    DECLARE cInicial INT;
    DECLARE cFinal INT;
    DECLARE penalizacion DECIMAL(10,2) DEFAULT 0.00;

    SELECT combustible_inicial, combustible_final INTO cInicial, cFinal 
    FROM Reservas 
    WHERE id = p_reservaId;

    IF cFinal IS NOT NULL AND cFinal < cInicial THEN
        SET penalizacion = (cInicial - cFinal) * 2.00;
    END IF;

    RETURN penalizacion;
END //
DELIMITER ;

-- 5. RN-001 (Restricción de disponibilidad): Cuenta cuántos vehículos de una categoría concreta se encuentran en estado 'disponible', excluyendo los alquilados o en mantenimiento.
DELIMITER //
CREATE OR REPLACE FUNCTION fVehiculosDisponiblesCategoria(p_tipo VARCHAR(30)) RETURNS INT
BEGIN
    DECLARE disponibles INT;
    SELECT COUNT(*) INTO disponibles 
    FROM Vehiculos 
    WHERE tipo_vehiculo = p_tipo AND tipo_estado = 'disponible';
    RETURN disponibles;
END //
DELIMITER ;


-- ============================================================================
--                               PROCEDIMIENTOS
-- ============================================================================

-- 1. RF-005 (Búsqueda filtrada): Muestra un listado de los vehículos disponibles filtrados por una categoría concreta (económico, SUV, furgoneta o automático).
DELIMITER //
CREATE OR REPLACE PROCEDURE pBuscarVehiculosPorCategoria(p_tipo VARCHAR(30))
BEGIN
    SELECT id, matricula, marca, modelo, precio_dia, tipo_vehiculo
    FROM Vehiculos 
    WHERE tipo_vehiculo = p_tipo AND tipo_estado = 'disponible';
END //
DELIMITER ;

-- 2. RF-010 (Consultar vehículos pendientes de revisión): Muestra todos los vehículos cuyo estado actual es 'en_mantenimiento' para que los mecánicos organicen las revisiones.
DELIMITER //
CREATE OR REPLACE PROCEDURE pVehiculosPendientesRevision()
BEGIN
    SELECT id, matricula, marca, modelo, tipo_vehiculo
    FROM Vehiculos 
    WHERE tipo_estado = 'en_mantenimiento';
END //
DELIMITER ;

-- 3. RF-003 (Cambiar el estado de un vehículo): Actualiza el estado de un vehículo concreto ('en_mantenimiento', 'disponible' o 'alquilado') para reflejar la disponibilidad real.
DELIMITER //
CREATE OR REPLACE PROCEDURE pActualizarEstadoVehiculo(p_vehiculoId INT, p_nuevoEstado VARCHAR(30))
BEGIN
    UPDATE Vehiculos 
    SET tipo_estado = p_nuevoEstado 
    WHERE id = p_vehiculoId;
END //
DELIMITER ;

-- 4. RF-008 (Registrar devolución y nivel de combustible): Registra el combustible final, la fecha real de entrega y finaliza la reserva (disparando automáticamente los triggers de penalización y mantenimiento).
DELIMITER //
CREATE OR REPLACE PROCEDURE pRegistrarDevolucion(p_reservaId INT, p_combustibleFinal INT)
BEGIN
    UPDATE Reservas 
    SET combustible_final = p_combustibleFinal,
        fecha_devolucion_real = CURDATE(),
        estado = 'finalizada'
    WHERE id = p_reservaId;
END //
DELIMITER ;

-- 5. RF-002 (Cancelar una reserva): Marca la reserva como 'cancelada' indicando el cliente que cancela (disparando el trigger de penalización si procede) y devuelve el vehículo al estado 'disponible'.
DELIMITER //
CREATE OR REPLACE PROCEDURE pCancelarReserva(p_reservaId INT, p_clienteCancelaId INT)
BEGIN
    DECLARE idVehiculo INT;

    SELECT vehiculoId INTO idVehiculo
    FROM Reservas 
    WHERE id = p_reservaId;

    UPDATE Reservas 
    SET estado = 'cancelada',
        clienteCancelaId = p_clienteCancelaId
    WHERE id = p_reservaId;

    UPDATE Vehiculos 
    SET tipo_estado = 'disponible' 
    WHERE id = idVehiculo;
END //
DELIMITER ;
