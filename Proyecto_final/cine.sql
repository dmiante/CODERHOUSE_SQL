-- DROP DATABASE CINE_INDEPENDIENTE;
CREATE DATABASE IF NOT EXISTS CINE_INDEPENDIENTE;

USE CINE_INDEPENDIENTE;

CREATE TABLE CLIENTE (
  id_cliente BIGINT NOT NULL AUTO_INCREMENT,
  dni VARCHAR(10) NOT NULL UNIQUE,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  email VARCHAR(45) DEFAULT NULL UNIQUE,
  PRIMARY KEY(id_cliente)
);

CREATE TABLE CALIFICACION(
  id_calificacion INT NOT NULL,
  nombre CHAR(5) NOT NULL, 
  PRIMARY KEY(id_calificacion)
);

CREATE TABLE PAIS(
  id_pais INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  PRIMARY KEY(id_pais)
);

CREATE TABLE CINE(
  id_cine BIGINT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  ciudad VARCHAR(45) NOT NULL,
  PRIMARY KEY(id_cine)
);

CREATE TABLE METODO_PAGO (
  id_metodo_pago BIGINT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  PRIMARY KEY(id_metodo_pago)
);

CREATE TABLE EMPLEADO(
  id_empleado BIGINT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  dni VARCHAR(10) NOT NULL UNIQUE,
  email VARCHAR(45) DEFAULT NULL UNIQUE,
  cargo VARCHAR(45) NOT NULL,
  fecha_contratacion DATE NOT NULL,
  sueldo DECIMAL(10, 0) NOT NULL,
  fk_cine BIGINT NOT NULL,
  PRIMARY KEY(id_empleado),
  FOREIGN KEY(fk_cine) REFERENCES CINE(id_cine)
);

CREATE TABLE SALA(
  id_sala INT NOT NULL AUTO_INCREMENT,
  capacidad INT NOT NULL,
  fk_cine BIGINT NOT NULL,
  PRIMARY KEY(id_sala),
  FOREIGN KEY(fk_cine) REFERENCES CINE(id_cine)
);

CREATE TABLE ASIENTO(
  id_asiento BIGINT NOT NULL AUTO_INCREMENT,
  nombre CHAR(5) NOT NULL,
  fk_sala INT NOT NULL,
  PRIMARY KEY(id_asiento),
  FOREIGN KEY(fk_sala) REFERENCES SALA(id_sala)
);

CREATE TABLE CARTELERA(
  id_cartelera BIGINT NOT NULL AUTO_INCREMENT,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  fk_cine BIGINT NOT NULL,
  PRIMARY KEY(id_cartelera),
  FOREIGN KEY(fk_cine) REFERENCES CINE(id_cine)
);

CREATE TABLE PELICULA(
  id_pelicula BIGINT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(45) NOT NULL,
  anio_estreno YEAR NOT NULL,
  duracion INT NOT NULL,
  genero VARCHAR(100) DEFAULT NULL,
  fk_calificacion INT NOT NULL,
  fk_pais INT NOT NULL, 
  sinopsis TEXT DEFAULT NULL,
  PRIMARY KEY(id_pelicula),
  FOREIGN KEY(fk_calificacion) REFERENCES CALIFICACION(id_calificacion),
  FOREIGN KEY(fk_pais) REFERENCES PAIS(id_pais)
);

CREATE TABLE CARTELERA_PELICULA(
  id_cartelera_pelicula BIGINT NOT NULL AUTO_INCREMENT,
  fk_cartelera BIGINT NOT NULL,
  fk_pelicula BIGINT NOT NULL,
  PRIMARY KEY(id_cartelera_pelicula),
  FOREIGN KEY(fk_cartelera) REFERENCES CARTELERA(id_cartelera),
  FOREIGN KEY(fk_pelicula) REFERENCES PELICULA(id_pelicula) 
);

CREATE TABLE FUNCION(
  id_funcion BIGINT NOT NULL AUTO_INCREMENT,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  fk_pelicula BIGINT NOT NULL,
  fk_sala INT NOT NULL,
  PRIMARY KEY(id_funcion),
  FOREIGN KEY(fk_pelicula) REFERENCES PELICULA(id_pelicula),
  FOREIGN KEY(fk_sala) REFERENCES SALA(id_sala)
);

CREATE TABLE CARTELERA_FUNCION(
  id_cartelera_pelicula BIGINT NOT NULL AUTO_INCREMENT,
  fk_cartelera BIGINT NOT NULL,
  fk_funcion BIGINT NOT NULL,
  PRIMARY KEY(id_cartelera_pelicula),
  FOREIGN KEY(fk_cartelera) REFERENCES CARTELERA(id_cartelera),
  FOREIGN KEY(fk_funcion) REFERENCES FUNCION(id_funcion) 
);

CREATE TABLE VENTA(
  id_venta BIGINT NOT NULL AUTO_INCREMENT,
  fecha_venta DATE NOT NULL,
  hora_venta TIME NOT NULL,
  total_venta DECIMAL(10, 0) NOT NULL,
  fk_metodo_pago BIGINT NOT NULL,
  fk_cliente BIGINT NOT NULL,
  PRIMARY KEY(id_venta),
  FOREIGN KEY(fk_metodo_pago) REFERENCES METODO_PAGO(id_metodo_pago),
  FOREIGN KEY(fk_cliente) REFERENCES CLIENTE(id_cliente)
);

CREATE TABLE BOLETO(
  id_boleto BIGINT NOT NULL AUTO_INCREMENT,
  precio DECIMAL(10, 0) NOT NULL,
  fk_venta BIGINT NOT NULL,
  fk_funcion BIGINT NOT NULL,
  fk_asiento BIGINT NOT NULL,
  PRIMARY KEY(id_boleto),
  FOREIGN KEY(fk_venta) REFERENCES VENTA(id_venta),
  FOREIGN KEY(fk_funcion) REFERENCES FUNCION(id_funcion),
  FOREIGN KEY(fk_asiento) REFERENCES ASIENTO(id_asiento)
);

-- Agregar indice UNIQUE a los atributos asiento y id_funcion, para que ninguna funcion tenga el mismo asiento
ALTER TABLE BOLETO
ADD CONSTRAINT unique_asiento UNIQUE (fk_asiento, fk_funcion);


