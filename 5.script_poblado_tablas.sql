/*POBLADO DE TABLAS*/

/*USUARIOS (12 usuarios: 5 Clientes, 3 Administradores, 4 Mecánicos)*/
INSERT INTO Usuarios (nombre, correo, contraseña) VALUES
('Juan Pérez', 'juanperez@gmail.com', '12345678'),
('Lucía Morales', 'luciamorales@gmail.com', '87654321'),
('Carlos Herrera', 'carlosherrera@gmail.com', '11223344'),
('Elena Domínguez', 'elenadominguez@gmail.com', '44556677'),
('Álvaro Romero', 'alvaroromero@gmail.com', '55667788'),
('Marta Castro', 'martacastro@gmail.com', '22334455'),
('Sofía Navarro', 'sofianavarro@gmail.com', '66778899'),
('Pablo Ruiz', 'pabloruiz@gmail.com', '77889900'),
('Diego Vargas', 'diegovargas@gmail.com', '33445566'),
('Raúl Jiménez', 'rauljimenez@gmail.com', '88990011'),
('Carmen Delgado', 'carmendelgado@gmail.com', '99001122'),
('Andrés Molina', 'andresmolina@gmail.com', '10111213');

/*SUBTIPOS DE USUARIO*/
INSERT INTO Clientes (DNI, telefono, fecha_carnet, UsuarioId) VALUES
('0957896H', 668889578, '1999-02-20', 1),
('12345678A', 611223344, '2018-05-14', 2),
('87654321B', 622334455, '2020-09-22', 3),
('45678912C', 633445566, '2016-04-08', 4),
('78912345D', 644556677, '2021-11-12', 5);


INSERT INTO Administradores (id_trabajador, UsuarioId) VALUES
(10000123, 6),
(10000125, 7),
(10000126, 8);

INSERT INTO Mecanicos (id_trabajador, UsuarioId) VALUES
(10000124, 9),
(10000127, 10),
(10000128, 11),
(10000129, 12);

/*OFICINAS*/
INSERT INTO Oficinas (ubicacion_recogida, ubicacion_devolucion, horario, telefono) VALUES
('Sevilla', 'Sevilla', '2026-11-01 08:00:00', '657 897 897'),
('Sevilla - Santa Justa', 'Sevilla - Santa Justa', '2026-11-01 08:00:00', '+34 954 100 101'),
('Sevilla - Aeropuerto SVQ', 'Sevilla - Aeropuerto SVQ', '2026-11-01 07:30:00', '+34 954 100 102'),
('Málaga - Centro Vialia', 'Málaga - Centro Vialia', '2026-11-01 09:00:00', '+34 952 200 201'),
('Córdoba - Estación AVE', 'Córdoba - Estación AVE', '2026-11-01 08:30:00', '+34 957 300 301'),
('Cádiz - Puerto', 'Cádiz - Puerto', '2026-11-01 09:00:00', '+34 956 400 401');

/*SEGUROS Y EXTRAS*/
INSERT INTO Seguros (seguro_basico, seguro_premium, precio) VALUES
(TRUE, FALSE, 50.00),
(FALSE, TRUE, 150.00);

INSERT INTO Extra (tipo, precio_extra) VALUES
('GPS', 20.00),
('sillita_bebe', 20.00),
('conductor_extra', 25.00);

/*VEHÍCULOS*/
INSERT INTO Vehiculos (matricula, tipo_vehiculo, precio_dia, marca, modelo, tipo_estado) VALUES
('1234 LMN', 'SUV', 95.00, 'toyota', 'RAV4', 'disponible'),
('5678 NPR', 'economico', 40.00, 'seat', 'Ibiza', 'disponible'),
('9012 STV', 'automatico', 60.00, 'volkswagen', 'Golf', 'disponible'),
('3456 WXY', 'furgoneta', 75.00, 'ford', 'Transit', 'disponible'),
('7890 BCD', 'economico', 40.00, 'toyota', 'Yaris', 'disponible'),
('2468 FGH', 'SUV', 95.00, 'hyundai', 'Tucson', 'disponible');

/*RESERVAS */
INSERT INTO Reservas (
	fecha_recogida, fecha_devolucion, fecha_devolucion_real, estado,
	combustible_inicial, combustible_final, fecha_limite, numero_reserva,
	clienteRealizaId, clienteCancelaId, vehiculoId, seguroId, oficinaRecogidaId, oficinaDevolucionId, extraId
) VALUES
('2026-11-10', '2026-11-15', '2026-11-15', 'finalizada',
 40, 20, '2026-11-08', 6,
 1, NULL, 1, 1, 1, 1, 1),

('2026-11-25', '2026-11-28', NULL, 'activa',
 100, NULL, '2026-11-24', 7,
 2, NULL, 2, 1, 2, 2, NULL),

('2026-11-18', '2026-11-20', NULL, 'cancelada',
 100, NULL, '2026-11-17', 8,
 3, 3, 3, 2, 3, 3, 2),

('2026-11-12', '2026-11-16', '2026-11-16', 'finalizada',
 100, 100, '2026-11-11', 9,
 4, NULL, 4, 2, 4, 5, 3),

('2026-11-26', '2026-11-29', NULL, 'activa',
 100, NULL, '2026-11-25', 10,
 5, NULL, 5, 1, 5, 6, 1);

/*REVISIONES*/
INSERT INTO Revision (fecha, observaciones, nivel_combustible, vehiculoId, mecanicoId) VALUES
('2026-11-16 10:00:00', 'el coche llego en peor estado al inicial', 20, 1, 1),
('2026-11-17 11:30:00', 'Revisión obligatoria tras devolución de reserva 9. Todo correcto.', 100, 4, 2),
('2026-11-22 09:00:00', 'Chequeo preventivo general en vehículo 6.', 90, 6, 3);

/*OFERTAS*/
INSERT INTO ofertas (reservaId, descuento_total, oferta_mes, oferta_fidelidad) VALUES
(1, 15.00, 0.00, 1.00),
(4, 20.00, 1.00, 0.00);


/*si el script hiciera INSERT INTO Reservas y además INSERT INTO facturas para los mismos reservaId, 
el trigger insertaría una factura y el INSERT manual insertaría una segunda factura para la misma reserva*/


