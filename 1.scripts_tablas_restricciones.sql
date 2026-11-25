DROP TABLE IF EXISTS Usuarios;
DROP TABLE IF EXISTS Clientes;
DROP TABLE IF EXISTS Administradores;
DROP TABLE IF EXISTS Mecanicos;
DROP TABLE IF EXISTS oficinas;
DROP TABLE IF EXISTS Seguros;
DROP TABLE IF EXISTS Extra;
DROP TABLE IF EXISTS vehiculos;
DROP TABLE if EXISTS revision;
DROP TABLE if EXISTS reservas;
DROP TABLE if EXISTS ofertas;
DROP TABLE if EXISTS facturas;

CREATE TABLE Usuarios(
	id INT PRIMARY KEY AUTO_INCREMENT,
	nombre VARCHAR(255) NOT NULL,
	correo VARCHAR(255) UNIQUE NOT NULL,
	contraseña VARCHAR(255) NOT NULL
);


CREATE TABLE Clientes(
	id INT PRIMARY KEY AUTO_INCREMENT,
	DNI VARCHAR(255) UNIQUE NOT NULL,
	telefono INT UNIQUE NOT NULL,
	fecha_carnet DATE NOT NULL,
	UsuarioId INT NOT NULL,
	FOREIGN KEY (UsuarioId) REFERENCES Usuarios(id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);


CREATE TABLE Administradores(
	id INT PRIMARY KEY AUTO_INCREMENT,
	id_trabajador INT NOT NULL UNIQUE,
	UsuarioId INT NOT NULL,
	FOREIGN KEY (UsuarioId) REFERENCES Usuarios(id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
		
);

CREATE TABLE Mecanicos(
	id INT PRIMARY KEY AUTO_INCREMENT,
	id_trabajador INT NOT NULL UNIQUE,
	UsuarioId INT NOT NULL,
	FOREIGN KEY (UsuarioId) REFERENCES Usuarios(id) 
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);


CREATE TABLE Oficinas(
	id INT PRIMARY KEY AUTO_INCREMENT,
	ubicacion_recogida VARCHAR(255) NOT NULL,
	ubicacion_devolucion VARCHAR(255) NOT NULL,
	horario DATETIME NOT NULL,
	telefono VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE Seguros(
	id INT PRIMARY KEY AUTO_INCREMENT,
	seguro_basico BOOLEAN ,
	seguro_premium BOOLEAN,
	precio DECIMAL (10,2)
	
	
);


CREATE TABLE Extra(
	id INT PRIMARY KEY AUTO_INCREMENT,
	tipo ENUM('GPS', 'sillita_bebe', 'conductor_extra')
);


CREATE TABLE Vehiculos(
	id INT PRIMARY KEY AUTO_INCREMENT,
	matricula VARCHAR(255) UNIQUE NOT NULL,
	tipo_vehiculo ENUM('economico', 'SUV', 'furgoneta', 'automatico') NOT NULL,
	precio DECIMAL (10,2) NOT NULL,
	marca VARCHAR(255) NOT NULL,
	modelo VARCHAR(255) NOT NULL,
	tipo_estado ENUM('en_mantenimiento', 'disponible', 'alquilado') NOT NULL
	 
	
);

CREATE TABLE Revision(
	id INT PRIMARY KEY AUTO_INCREMENT,
	fecha DATETIME NOT NULL,
	observaciones TEXT NOT NULL,
	nivel_combustible INT NOT NULL,
	vehiculoId INT NOT NULL, 
	mecanicoId INT NOT NULL, 
	FOREIGN KEY (vehiculoId) REFERENCES vehiculos(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (mecanicoId) REFERENCES mecanicos(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE  
);

CREATE TABLE Reservas(
	id INT PRIMARY KEY AUTO_INCREMENT,
	fecha_recogida DATE NOT NULL,
	fecha_devolucion DATE NOT NULL,
	combustible_inicial INT NOT NULL,
	combustible_final INT NOT NULL,
	fecha_limite DATE NOT NULL,
	numero_reserva INT UNIQUE NOT NULL,
	clienteRealizaId INT NOT NULL,
	clienteCancelaId INT NOT NULL,
	vehiculoId INT NOT NULL,
	seguroId INT NOT NULL,
	oficinaId INT NOT NULL,
	extraId INT,
	FOREIGN KEY (clienteRealizaId) REFERENCES clientes(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (clienteCancelaId) REFERENCES clientes(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (vehiculoId) REFERENCES vehiculos(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (seguroId) REFERENCES seguros(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (oficinaId) REFERENCES oficinas(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE,
	FOREIGN KEY (extraId) REFERENCES extra(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
	
);

CREATE TABLE facturas(
	id INT PRIMARY KEY AUTO_INCREMENT,
	reservaId INT NOT NULL,
	importe_total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
	penalizacion_cancelacion DECIMAL(10,2) DEFAULT 0.00,
	penalizacion_combustible DECIMAL(10,2) DEFAULT 0.00,
	FOREIGN KEY (reservaId) REFERENCES reservas(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE

);

CREATE TABLE ofertas(
	id INT PRIMARY KEY AUTO_INCREMENT,
	reservaId INT NOT NULL,
	descuento_total INT DEFAULT 0,
	oferta_mes INT DEFAULT 0,
	oferta_fidelidad INT DEFAULT 0,
	FOREIGN KEY (reservaId) REFERENCES reservas(id)
		ON DELETE CASCADE 
		ON UPDATE CASCADE
);
