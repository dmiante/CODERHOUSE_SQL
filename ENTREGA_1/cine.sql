CREATE DATABASE IF NOT EXISTS CINE_INDEPENDIENTE;

USE CINE_INDEPENDIENTE;

CREATE TABLE CLIENTE (
  id_cliente BIGINT NOT NULL AUTO_INCREMENT,
  dni INT(11) NOT NULL,
  nombre VARCHAR(45) NOT NULL,
  apellido VARCHAR(45) NOT NULL,
  email VARCHAR(45) DEFAULT NULL,
  PRIMARY KEY(id_cliente)
);

CREATE TABLE CINE(
  id_cine BIGINT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(45) NOT NULL,
  direccion VARCHAR(100) NOT NULL,
  ciudad VARCHAR(45) NOT NULL,
  PRIMARY KEY(id_cine)
);

CREATE TABLE SALA(
  id_sala INT(11) NOT NULL AUTO_INCREMENT,
  capacidad INT(11) NOT NULL,
  fk_id_cine BIGINT NOT NULL,
  PRIMARY KEY(id_sala),
  FOREIGN KEY(fk_id_cine) REFERENCES CINE(id_cine)
);

CREATE TABLE CARTELERA(
  id_cartelera BIGINT NOT NULL AUTO_INCREMENT,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  fk_id_cine BIGINT NOT NULL,
  PRIMARY KEY(id_cartelera),
  FOREIGN KEY(fk_id_cine) REFERENCES CINE(id_cine)
);

CREATE TABLE PELICULA(
  id_pelicula BIGINT NOT NULL AUTO_INCREMENT,
  titulo VARCHAR(45) NOT NULL,
  fecha_de_estreno DATE NOT NULL,
  genero VARCHAR(100) DEFAULT NULL,
  clasificacion VARCHAR(50) DEFAULT NULL,
  duracion INT(11) NOT NULL,
  idioma VARCHAR(45) DEFAULT NULL,
  sinopsis TEXT DEFAULT NULL,
  fk_id_cartelera BIGINT DEFAULT NULL,
  PRIMARY KEY(id_pelicula),
  FOREIGN KEY(fk_id_cartelera) REFERENCES CARTELERA(id_cartelera)
);

CREATE TABLE FUNCION(
  id_funcion BIGINT NOT NULL AUTO_INCREMENT,
  hora TIME NOT NULL,
  fecha DATE NOT NULL,
  fk_id_pelicula BIGINT NOT NULL,
  fk_id_sala INT(11) NOT NULL,
  PRIMARY KEY(id_funcion),
  FOREIGN KEY(fk_id_pelicula) REFERENCES PELICULA(id_pelicula),
  FOREIGN KEY(fk_id_sala) REFERENCES SALA(id_sala)
);

CREATE TABLE BOLETO(
  id_boleto BIGINT NOT NULL AUTO_INCREMENT,
  cantidad INT(11) NOT NULL,
  precio NUMERIC(10, 2) NOT NULL,
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  tipo_de_pago VARCHAR(45) NOT NULL,
  asiento INT(11) NOT NULL,
  fk_id_cliente BIGINT DEFAULT NULL,
  fk_id_funcion BIGINT NOT NULL,
  PRIMARY KEY(id_boleto),
  FOREIGN KEY(fk_id_cliente) REFERENCES CLIENTE(id_cliente),
  FOREIGN KEY(fk_id_funcion) REFERENCES FUNCION(id_funcion)
);

CREATE TABLE CARTELERA_PELICULA(
  id_cartelera_pelicula BIGINT NOT NULL AUTO_INCREMENT,
  fk_id_cartelera BIGINT NOT NULL,
  fk_id_pelicula BIGINT NOT NULL,
  PRIMARY KEY(id_cartelera_pelicula),
  FOREIGN KEY(fk_id_cartelera) REFERENCES CARTELERA(id_cartelera),
  FOREIGN KEY(fk_id_pelicula) REFERENCES PELICULA(id_pelicula)
);