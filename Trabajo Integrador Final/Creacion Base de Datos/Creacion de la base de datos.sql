CREATE DATABASE ViajesTuristicos
COLLATE Latin1_General_CI_AI
GO
USE ViajesTuristicos

GO
CREATE TABLE Personas(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
dni VARCHAR(8) NOT NULL UNIQUE,
nombre VARCHAR(30) NOT NULL, 
apellido VARCHAR(30) NOT NULL,
edad TINYINT NOT NULL CHECK (edad>=0 AND edad <=120  ),
telefono VARCHAR(10) 
)
GO
CREATE TABLE  Licencias(
id INT NOT NULL PRIMARY KEY IDENTITY(1000,1),
dni VARCHAR(8) NOT NULL,
fecha_emision DATE NOT NULL,
fecha_caducidad DATE NOT NULL,
FOREIGN KEY (dni) REFERENCES Personas(dni)
)
GO
ALTER TABLE Licencias
ADD CONSTRAINT chk_licencias_fechas
CHECK (fecha_caducidad>fecha_emision)
GO
CREATE TABLE Lanchas(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
capacidad TINYINT NOT NULL CHECK(capacidad>0),
matricula VARCHAR(6) NOT NULL,
nombre VARCHAR(30)
)
GO
CREATE TABLE Destinos(
id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
zona VARCHAR(30) NOT NULL, 
muelle VARCHAR(30) NOT NULL,
duracion TIME NOT NULL CHECK(duracion>'00:00:00' AND duracion<'10:00:00')
)
GO
CREATE TABLE Categorias_Pasajero(
id TINYINT NOT NULL PRIMARY KEY IDENTITY(1,1),
nombre VARCHAR(20) NOT NULL,
descripcion VARCHAR(50) NOT NULL,
edad_minima TINYINT NOT NULL CHECK(edad_minima>=0),
edad_maxima TINYINT NOT NULL,
porcentaje_tarifa DECIMAL(5,2) NOT NULL CHECK (porcentaje_tarifa>=0 AND porcentaje_tarifa<=1)
)
GO
ALTER TABLE Categorias_Pasajero
ADD CONSTRAINT chk_edades_categoria
CHECK(edad_maxima>edad_minima)
GO
CREATE TABLE Metodo_Pago(
id SMALLINT NOT NULL PRIMARY KEY IDENTITY(1,1),
descripcion VARCHAR(50) NOT NULL,
activo BIT DEFAULT 1
)
GO
CREATE TABLE Descuentos(
id INT PRIMARY KEY IDENTITY(1,1),
descripcion VARCHAR(150) NOT NULL,
porcentaje DECIMAL(5,2) NOT NULL CHECK(porcentaje>0 AND porcentaje<1),
fecha_inicio DATE ,
fecha_fin DATE ,
activo BIT DEFAULT 1,
tipo VARCHAR(50) NOT NULL,
)
GO
ALTER TABLE Descuentos
ADD CONSTRAINT chk_fecha_descuento
CHECK(fecha_fin>fecha_inicio)
GO
CREATE TABLE Conductor(
id INT PRIMARY KEY IDENTITY (1,1),
id_persona INT NOT NULL,
estado BIT DEFAULT 1,
id_licencia INT NOT NULL, 
FOREIGN KEY (id_persona) REFERENCES Personas(id),
FOREIGN KEY (id_licencia) REFERENCES Licencias(id)
)
GO
CREATE TABLE Turnos(
id INT PRIMARY KEY IDENTITY (1,1),
id_lancha INT NOT NULL,
id_destino INT NOT NULL,
horario TIME NOT NULL,
fecha DATE NOT NULL CHECK (fecha >= CAST(GETDATE() AS DATE)),
precio_base DECIMAL(8,2) NOT NULL CHECK(precio_base >0),
cantidad_reservado TINYINT NOT NULL,
FOREIGN KEY (id_lancha) REFERENCES Lanchas(id),
FOREIGN KEY (id_destino) REFERENCES Destinos(id)
)
GO
CREATE TABLE Lanchas_Conductores(
id_lancha INT NOT NULL,
id_conductor INT NOT NULL,
PRIMARY KEY(id_lancha, id_conductor),
FOREIGN KEY(id_lancha) REFERENCES Lanchas(id),
FOREIGN KEY(id_conductor) REFERENCES Conductor(id)
)
GO
CREATE TABLE Reservas(
id INT PRIMARY KEY IDENTITY(1,1),
id_turno INT NOT NULL,
id_persona INT NOT NULL,
id_categoria_pasajero TINYINT, 
id_metodo_pago SMALLINT NOT NULL,
monto_base DECIMAL(10,2) NOT NULL DEFAULT 0.0 CHECK(monto_base >= 0),
descuento_aplicado DECIMAL(10,2) DEFAULT 0.0 CHECK(descuento_aplicado>=0),
monto_final DECIMAL(10,2) NOT NULL DEFAULT 0.0 CHECK(monto_final>=0),
estado VARCHAR(20) NOT NULL DEFAULT 'pendiente',
fecha_creacion DATETIME DEFAULT GETDATE(),
fecha_modificacion DATETIME DEFAULT GETDATE(),
FOREIGN KEY(id_turno) REFERENCES Turnos(id),
FOREIGN KEY(id_persona) REFERENCES Personas(id),
FOREIGN KEY(id_categoria_pasajero) REFERENCES Categorias_Pasajero(id),
FOREIGN KEY(id_metodo_pago) REFERENCES Metodo_Pago(id)
)
GO
CREATE TABLE Reservas_Descuentos(
id_reserva INT NOT NULL,
id_descuento INT NOT NULL,
monto_descuento DECIMAL(10,2) NOT NULL DEFAULT 0.0,
PRIMARY KEY(id_reserva,id_descuento),
FOREIGN KEY(id_reserva) REFERENCES Reservas(id),
FOREIGN KEY(id_descuento) REFERENCES Descuentos(id)
)
GO