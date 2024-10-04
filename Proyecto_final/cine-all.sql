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




# 5 VISTAS

    
-- Muestra el total de boletos vendidos y el monto recaudado por cada película.
CREATE OR REPLACE VIEW ventas_por_pelicula AS
SELECT 
	P.titulo AS pelicula,
	COUNT(B.id_boleto) AS boletos_vendidos,
    SUM(B.precio) AS total_recaudado
FROM BOLETO B
JOIN FUNCION F ON B.fk_funcion = F.id_funcion
JOIN PELICULA P ON F.fk_pelicula = P.id_pelicula
GROUP BY P.titulo;

-- Muestra los boletos vendidos de cada funcion
CREATE OR REPLACE VIEW boletos_por_funcion AS
SELECT 
    f.id_funcion AS funcion_id,
    p.titulo AS pelicula_titulo,
    f.fecha AS funcion_fecha,
    f.hora AS funcion_hora,
    COUNT(b.id_boleto) AS boletos_vendidos
FROM BOLETO b
JOIN FUNCION f ON b.fk_funcion = f.id_funcion
JOIN PELICULA p ON f.fk_pelicula = p.id_pelicula
GROUP BY f.id_funcion, p.titulo, f.fecha, f.hora;


-- Muestras las peliculas que se proyectan en el dia.
CREATE VIEW peliculas_del_dia AS
SELECT 
    p.titulo AS pelicula_titulo,
    p.anio_estreno AS anio_estreno,
    p.duracion AS duracion_minutos,
    p.genero AS genero,
    c.nombre AS cine_nombre,
    ca.fecha_inicio AS cartelera_inicio,
    ca.fecha_fin AS cartelera_fin
FROM PELICULA p
JOIN CARTELERA_PELICULA cp ON p.id_pelicula = cp.fk_pelicula
JOIN CARTELERA ca ON cp.fk_cartelera = ca.id_cartelera
JOIN CINE c ON ca.fk_cine = c.id_cine
WHERE CURDATE() BETWEEN ca.fecha_inicio AND ca.fecha_fin;
    
-- Muestra las funciones disponibles de una cartelera semanal.
CREATE VIEW funciones_disponibles AS
SELECT 
    c.nombre AS cine_nombre,
    p.titulo AS pelicula_titulo,
    f.fecha AS funcion_fecha,
    f.hora AS funcion_hora,
    s.id_sala AS sala_id,
    s.capacidad AS sala_capacidad
FROM FUNCION f
JOIN SALA s ON f.fk_sala = s.id_sala
JOIN CINE c ON s.fk_cine = c.id_cine
JOIN PELICULA p ON f.fk_pelicula = p.id_pelicula
JOIN CARTELERA_FUNCION cf ON cf.fk_funcion = f.id_funcion
JOIN CARTELERA ca ON cf.fk_cartelera = ca.id_cartelera
WHERE f.fecha >= CURDATE()
AND ca.fecha_fin >= CURDATE(); 

-- Muestra las ventas mensuales del cine
CREATE OR REPLACE VIEW ventas_mensuales AS
SELECT 
    YEAR(v.fecha_venta) AS anio,
    MONTH(v.fecha_venta) AS mes,
    COUNT(v.id_venta) AS total_ventas,
    SUM(v.total_venta) AS total_recaudado
FROM VENTA v
GROUP BY YEAR(v.fecha_venta), MONTH(v.fecha_venta)
ORDER BY anio DESC, mes DESC;


# 5 PROCEDIMIENTOS ALMACENADOS

-- Agrega una pelicula nueva a la tabla pelicula
DELIMITER //
CREATE PROCEDURE agregar_pelicula(
  IN Titulo VARCHAR(45), 
  IN Anio_de_estreno INT, 
  IN Duracion INT, 
  IN Genero VARCHAR(100), 
  IN Calificacion INT, 
  IN Pais INT,
  IN Sinopsis TEXT
)
BEGIN
  INSERT INTO PELICULA (titulo, anio_estreno, duracion, genero, fk_calificacion, fk_pais, sinopsis)
  VALUES (Titulo, Anio_de_estreno, Duracion, Genero, Calificacion, Pais, Sinopsis);
END //
DELIMITER ;

-- Actualiza el precio de un boleto
DELIMITER //
CREATE PROCEDURE actualizar_precio_boleto(
    IN numero_boleto BIGINT,
    IN nuevo_precio DECIMAL(10, 0)
)
BEGIN
    UPDATE BOLETO
    SET precio = nuevo_precio
    WHERE id_boleto = numero_boleto;
    SELECT * FROM BOLETO WHERE id_boleto = numero_boleto;
END //
DELIMITER ;


-- Ver disponibilidad de asientos de una funcion
DELIMITER //
CREATE PROCEDURE disponibilidad_asientos(
  IN p_id_funcion BIGINT
)
BEGIN
	SELECT 
		a.id_asiento, 
		a.nombre AS Asientos_disponibles,
		f.fecha AS Fecha_funcion,
		f.hora AS Hora_funcion
	FROM ASIENTO a
	LEFT JOIN BOLETO b ON a.id_asiento = b.fk_asiento AND b.fk_funcion = p_id_funcion
	JOIN FUNCION f ON f.id_funcion = p_id_funcion
	WHERE b.id_boleto IS NULL;
END //
DELIMITER ;

-- Ver asientos ocupados
DELIMITER //
CREATE PROCEDURE asientos_ocupados(
  IN p_id_funcion BIGINT
)
BEGIN
  SELECT 
	f.fecha as fecha_funcion,
    f.hora as Hora_funcion,
    a.id_asiento, 
    a.nombre as Asiento_ocupado,
    c.nombre as Nombre_cliente,
    c.apellido as Apellido_cliente
  FROM ASIENTO a
  JOIN BOLETO b ON a.id_asiento = b.fk_asiento AND b.fk_funcion = p_id_funcion
  JOIN FUNCION F ON b.fk_funcion = f.id_funcion
  JOIN VENTA v ON b.fk_venta = v.id_venta
  JOIN CLIENTE c ON v.fk_cliente = c.id_cliente
  WHERE b.id_boleto IS NOT NULL;
END //
DELIMITER ;


-- Inserta boletos de acuerdo al total de la venta
DELIMITER //
CREATE PROCEDURE vender_boletos(
    IN p_cliente_id BIGINT,
    IN p_metodo_pago_id BIGINT,
    IN p_funcion_id BIGINT,
    IN p_asiento_inicial BIGINT,
    IN p_total_venta DECIMAL(10, 0),
    OUT p_venta_id BIGINT
)
BEGIN
    DECLARE boletos_a_generar INT;
    DECLARE asiento_actual BIGINT;
    DECLARE asiento_disponible BOOLEAN;
    DECLARE i INT DEFAULT 0;
    DECLARE precio_boletos DECIMAL(10, 0) DEFAULT 4000; 

	SET boletos_a_generar = p_total_venta / precio_boletos;
    SET asiento_actual = p_asiento_inicial;

    START TRANSACTION;
    INSERT INTO VENTA(fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente)
    VALUES (CURDATE(), CURTIME(), p_total_venta, p_metodo_pago_id, p_cliente_id);
    
    SET p_venta_id = LAST_INSERT_ID();

    -- Bucle para generar boletos en función de la cantidad calculada
    WHILE i < boletos_a_generar DO
        SELECT COUNT(*) INTO asiento_disponible
        FROM BOLETO
        WHERE fk_asiento = asiento_actual AND fk_funcion = p_funcion_id;
        
        IF asiento_disponible > 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Un asiento ya está ocupado para esta función';
        ELSE
            INSERT INTO BOLETO(precio, fk_venta, fk_funcion, fk_asiento)
            VALUES (precio_boletos, p_venta_id, p_funcion_id, asiento_actual);
            SET asiento_actual = asiento_actual + 1;
        END IF;
        SET i = i + 1;
    END WHILE;
    COMMIT;
END //
DELIMITER ;



# 2 FUNCIONES

-- Devuelve el total recaudado por una función específica.
DELIMITER //
CREATE FUNCTION calcular_recaudacion_funcion(id_funcion BIGINT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10, 2);
  SELECT SUM(precio) INTO total
  FROM BOLETO WHERE fk_funcion = id_funcion;
  RETURN IFNULL(total, 0); -- Si no es nulo retorna total, de lo contrario retorna 0
END //
DELIMITER ;


-- Cuenta cuántos boletos se han vendido para una función específica.
DELIMITER //
CREATE FUNCTION contar_boletos_por_funcion(id_funcion BIGINT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE total_boletos INT;
  
  SELECT COUNT(*) INTO total_boletos
  FROM BOLETO
  WHERE fk_funcion = id_funcion;

  RETURN total_boletos;
END //
DELIMITER ;




# 3 TRIGGERS

-- Previene la inserción de películas con duración menor a 30 minutos.
DELIMITER //
CREATE TRIGGER validar_duracion_pelicula
BEFORE INSERT ON PELICULA
FOR EACH ROW
BEGIN
  IF NEW.duracion < 50 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La duración de la película no puede ser menor a 50 minutos.';
  END IF;
END //
DELIMITER ;

-- Evitar ingresar fechas pasadas en una funcion
DELIMITER //
CREATE TRIGGER verificar_fecha_funcion
BEFORE INSERT ON FUNCION
FOR EACH ROW
BEGIN
  IF NEW.fecha < CURDATE() THEN
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'No se puede programar una función en una fecha pasada.';
  END IF;
END //
DELIMITER ;


-- Actualizar la tabla venta al agregar un boleto, incluyendo el total_venta
DELIMITER //
CREATE TRIGGER actualizar_total_venta
AFTER INSERT ON BOLETO
FOR EACH ROW
BEGIN
  UPDATE VENTA
  SET total_venta = total_venta + NEW.precio,
  fecha_venta = curdate(),
  hora_venta = curtime()
  WHERE id_venta = NEW.fk_venta;
END //
DELIMITER ;




-- INSERT CLIENTES
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('12345678-5', 'Juan', 'Pérez', 'juan.perez@gmail.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('18765432-1', 'María', 'González', 'maria.gonzalez@yahoo.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('5234567-8', 'Carlos', 'Rodríguez', 'carlos.rodriguez@hotmail.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('8543210-3', 'Ana', 'López', 'ana.lopez@gmail.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('2543219-4', 'Luis', 'Fernández', 'luis.fernandez@outlook.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('27654323-5', 'Elena', 'Martínez', 'elena.martinez@yahoo.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('9988776-9', 'José', 'García', 'jose.garcia@hotmail.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('16732145-8', 'Laura', 'Hernández', 'laura.hernandez@gmail.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('8765432-4', 'Pedro', 'Ruiz', 'pedro.ruiz@yahoo.com');
INSERT INTO CLIENTE (dni, nombre, apellido, email) VALUES ('25674321-2', 'Sofía', 'Jiménez', 'sofia.jimenez@gmail.com');

-- INSERT CALIFICACIONES
INSERT INTO CALIFICACION (id_calificacion, nombre) VALUES (1,'+14');
INSERT INTO CALIFICACION (id_calificacion, nombre) VALUES (2,'+18');
INSERT INTO CALIFICACION (id_calificacion, nombre) VALUES (3,'TE');
INSERT INTO CALIFICACION (id_calificacion, nombre) VALUES (4,'TE+7');

-- INSERT PAIS
INSERT INTO PAIS (id_pais, nombre) VALUES (1,'Chile');
INSERT INTO PAIS (id_pais, nombre) VALUES (2,'Argentina');
INSERT INTO PAIS (id_pais, nombre) VALUES (3,'México');
INSERT INTO PAIS (id_pais, nombre) VALUES (4,'Guatemala');
INSERT INTO PAIS (id_pais, nombre) VALUES (5,'Francia');
INSERT INTO PAIS (id_pais, nombre) VALUES (6,'Japón');
INSERT INTO PAIS (id_pais, nombre) VALUES (7,'Corea del Sur');
INSERT INTO PAIS (id_pais, nombre) VALUES (10,'Hungría');
INSERT INTO PAIS (id_pais, nombre) VALUES (11,'Polonia');
INSERT INTO PAIS (id_pais, nombre) VALUES (12,'Suecia');
INSERT INTO PAIS (id_pais, nombre) VALUES (13,'Dinamarca');
INSERT INTO PAIS (id_pais, nombre) VALUES (14,'Noruega');
INSERT INTO PAIS (id_pais, nombre) VALUES (15,'Líbano');

-- INSERT CINE
INSERT INTO CINE (id_cine, nombre, direccion, ciudad) VALUES (1, 'Cine El biografo', 'Jose Victorino Lastarria 181', 'Santiago');

-- INSERT METODOS DE PAGO
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (1, 'transferencia bancaria');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (2, 'efectivo');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (3, 'tarjeta de credito');
INSERT INTO METODO_PAGO (id_metodo_pago, nombre) VALUES (4, 'tarjeta de debito');

-- INSERT EMPLEADOS
INSERT INTO EMPLEADO (id_empleado, nombre, apellido, dni, email, cargo, fecha_contratacion, sueldo, fk_cine) 
VALUES 
(1, 'Esteban', 'López', '15234867-5', 'elopez0@gmail.com', 'acomodador', '2022-08-29', 800000, 1),
(2, 'Carlos', 'Gómez', '16843257-3', 'cgomez1@yahoo.com', 'acomodador', '2023-09-11', 800000, 1),
(3, 'Tamara', 'Soto', '25984712-8', 'tsoto2@outlook.com', 'acomodador', '2022-05-23', 800000, 1),
(4, 'Bruno', 'Fernández', '12563479-1', 'bfernandez3@gmail.com', 'boletista', '2023-06-20', 600000, 1),
(5, 'Eduardo', 'Pérez', '19234875-9', 'eperez4@hotmail.com', 'acomodador', '2020-03-21', 800000, 1),
(6, 'Rodrigo', 'Olivares', '21193456-7', 'rolivares5@live.com', 'acomodador', '2023-05-30', 800000, 1),
(7, 'Sebastián', 'Molina', '17893456-4', 'smolina6@gmail.com', 'acomodador', '2023-01-14', 800000, 1),
(8, 'Javier', 'Acuña', '29457234-6', 'jacuna7@outlook.com', 'proyeccionista', '2021-07-13', 1000000, 1),
(9, 'Cristina', 'Torres', '23679456-2', 'ctorres8@gmail.com', 'proyeccionista', '2020-05-05', 1000000, 1),
(10, 'Hugo', 'Martínez', '29568712-0', 'hmartinez9@gmail.com', 'acomodador', '2022-01-01', 800000, 1);

-- INSERT SALAS
INSERT INTO SALA (capacidad, fk_cine) VALUES (140, 1);

-- INSERT ASIENTOS
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (1, 'A1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (2, 'A2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (3, 'A3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (4, 'A4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (5, 'A5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (6, 'A6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (7, 'A7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (8, 'A8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (9, 'A9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (10, 'A10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (11, 'A11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (12, 'A12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (13, 'A13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (14, 'A14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (15, 'B1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (16, 'B2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (17, 'B3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (18, 'B4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (19, 'B5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (20, 'B6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (21, 'B7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (22, 'B8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (23, 'B9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (24, 'B10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (25, 'B11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (26, 'B12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (27, 'B13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (28, 'B14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (29, 'C1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (30, 'C2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (31, 'C3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (32, 'C4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (33, 'C5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (34, 'C6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (35, 'C7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (36, 'C8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (37, 'C9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (38, 'C10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (39, 'C11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (40, 'C12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (41, 'C13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (42, 'C14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (43, 'D1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (44, 'D2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (45, 'D3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (46, 'D4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (47, 'D5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (48, 'D6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (49, 'D7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (50, 'D8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (51, 'D9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (52, 'D10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (53, 'D11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (54, 'D12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (55, 'D13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (56, 'D14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (57, 'E1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (58, 'E2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (59, 'E3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (60, 'E4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (61, 'E5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (62, 'E6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (63, 'E7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (64, 'E8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (65, 'E9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (66, 'E10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (67, 'E11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (68, 'E12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (69, 'E13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (70, 'E14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (71, 'F1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (72, 'F2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (73, 'F3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (74, 'F4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (75, 'F5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (76, 'F6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (77, 'F7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (78, 'F8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (79, 'F9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (80, 'F10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (81, 'F11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (82, 'F12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (83, 'F13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (84, 'F14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (85, 'G1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (86, 'G2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (87, 'G3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (88, 'G4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (89, 'G5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (90, 'G6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (91, 'G7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (92, 'G8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (93, 'G9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (94, 'G10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (95, 'G11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (96, 'G12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (97, 'G13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (98, 'G14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (99, 'H1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (100, 'H2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (101, 'H3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (102, 'H4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (103, 'H5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (104, 'H6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (105, 'H7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (106, 'H8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (107, 'H9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (108, 'H10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (109, 'H11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (110, 'H12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (111, 'H13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (112, 'H14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (113, 'I1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (114, 'I2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (115, 'I3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (116, 'I4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (117, 'I5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (118, 'I6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (119, 'I7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (120, 'I8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (121, 'I9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (122, 'I10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (123, 'I11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (124, 'I12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (125, 'I13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (126, 'I14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (127, 'J1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (128, 'J2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (129, 'J3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (130, 'J4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (131, 'J5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (132, 'J6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (133, 'J7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (134, 'J8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (135, 'J9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (136, 'J10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (137, 'J11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (138, 'J12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (139, 'J13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_sala) VALUES (140, 'J14', 1);

-- INSERT CARTELERAS
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_cine) VALUES ('2024-09-19', '2024-09-25', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_cine) VALUES ('2024-09-26', '2024-10-02', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_cine) VALUES ('2024-10-03', '2024-10-09', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_cine) VALUES ('2024-10-10', '2024-10-16', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_cine) VALUES ('2024-10-17', '2024-10-23', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_cine) VALUES ('2024-10-24', '2024-10-30', 1);

-- INSERT PELICULAS
INSERT INTO PELICULA (id_pelicula,titulo, anio_estreno, duracion, genero, fk_calificacion, fk_pais, sinopsis)
VALUES
(1, 'El Conde', 2023, 112, 'Comedia/Drama', 1, 1, 'Una sátira donde Augusto Pinochet es representado como un vampiro centenario.'),
(2, 'Blanquita', 2022, 94, 'Drama', 2, 1, 'Una joven involucrada en un escándalo de abuso sexual que sacude a la elite política.'),
(3, 'Argentina, 1985', 2022, 140, 'Drama/Historia', 1, 2, 'Relato sobre el juicio a las juntas militares tras la dictadura en Argentina.'),
(4, 'Huesera', 2022, 97, 'Terror', 2, 3, 'Una mujer embarazada se enfrenta a una aterradora entidad sobrenatural.'),
(5, 'Los Lobos', 2020, 95, 'Drama', 4, 3, 'Dos niños inmigrantes aprenden a adaptarse a una nueva vida mientras esperan a su madre.'),
(6, 'Ema', 2019, 107, 'Drama', 2, 1, 'Una joven bailarina explora el caos en su vida personal y sus relaciones en Valparaíso.'),
(7, 'La Ciénaga', 2001, 103, 'Drama', 2, 2, 'Un relato de tensiones familiares en un caluroso y húmedo verano en el norte argentino.'),
(8, 'La Llorona', 2019, 97, 'Terror/Drama', 1, 4, 'Un dictador retirado es acosado por los fantasmas de las víctimas de su genocidio.'),
(9, 'Chicuarotes', 2019, 95, 'Drama', 1, 3, 'Dos adolescentes de un barrio pobre en Ciudad de México intentan escapar de la violencia y la pobreza.'),
(10, 'The Square', 2017, 151, 'Drama/Comedia', 1, 12, 'Un curador de arte contemporáneo se enfrenta a una serie de eventos surrealistas. Ganadora de la Palma de Oro en Cannes.'),
(11, 'Parasite', 2019, 132, 'Thriller/Drama', 1, 7, 'Una familia pobre se infiltra en una rica familia con consecuencias inesperadas. Ganadora del Oscar a Mejor Película y la Palma de Oro en Cannes.'),
(12, 'El Baile de la Gacela', 2018, 91, 'Comedia/Drama', 3, 3, 'Un hombre mayor compite en un concurso de baile para lidiar con su pasado.'),
(13, 'Son of Saul', 2015, 107, 'Drama', 2, 10, 'Un prisionero judío en Auschwitz intenta darle un entierro digno a un niño que cree que es su hijo. Ganadora del Gran Premio del Jurado en Cannes y el Oscar a Mejor Película Extranjera.'),
(14, 'Titane', 2021, 108, 'Drama/Horror', 2, 5, 'Una mujer con una placa de titanio en la cabeza tras un accidente de coche desencadena una serie de eventos violentos y extraños. Ganadora de la Palma de Oro en Cannes.'),
(15, 'The Worst Person in the World', 2021, 128, 'Drama/Comedia Romántica', 1, 14, 'Una joven navega entre sus relaciones y aspiraciones mientras enfrenta los dilemas de la adultez. Ganadora de Mejor Actriz en Cannes.'),
(16, 'Shoplifters', 2018, 121, 'Drama', 1, 6, 'Una familia pobre sobrevive a través de pequeños robos hasta que un incidente cambia sus vidas. Ganadora de la Palma de Oro en Cannes.'),
(17, 'Ida', 2013, 82, 'Drama', 1, 11, 'Una joven monja descubre oscuros secretos familiares antes de tomar sus votos. Ganadora del Oscar a Mejor Película Extranjera.'),
(18, 'Another Round', 2020, 117, 'Drama/Comedia', 1, 13, 'Cuatro profesores prueban un experimento para beber alcohol constantemente y ver cómo afecta sus vidas. Ganadora del Oscar a Mejor Película Internacional.'),
(19, 'The Handmaiden', 2016, 145, 'Thriller/Drama', 2, 7, 'Una historia de engaño, amor y traición ambientada en Corea durante la ocupación japonesa. Ganadora del BAFTA a Mejor Película de Habla No Inglesa.'),
(20, 'Capernaum', 2018, 126, 'Drama', 1, 15, 'Un niño refugiado demanda a sus padres por darle una vida de sufrimiento. Ganadora del Premio del Jurado en Cannes.');


-- INSERT CARTELERA_PELICULA
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (1, 1, 1);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (2, 2, 1);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (3, 3, 1);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (4, 4, 2);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (5, 5, 2);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (6, 6, 2);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (7, 7, 3);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (8, 8, 3);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_pelicula, fk_cartelera) VALUES (9, 9, 3);


-- INSERT FUNCIONES
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (1, '2024-09-19', '15:00', 1, 1); -- El conde
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (2, '2024-09-19', '18:00', 2, 1); -- Blanquita
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (3, '2024-09-19', '20:00', 3, 1); -- Argentina, 1985

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (4, '2024-09-20', '15:00', 1, 1); -- El conde
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (5, '2024-09-20', '18:00', 2, 1); -- Blanquita  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (6, '2024-09-20', '20:00', 3, 1); -- Argentina, 1985

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (7, '2024-09-21', '15:00', 1, 1); -- El conde
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (8, '2024-09-21', '18:00', 2, 1); -- Blanquita
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (9, '2024-09-21', '20:00', 3, 1); -- Argentina, 1985

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (10, '2024-09-22', '15:00', 1, 1); -- El conde
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (11, '2024-09-22', '18:00', 2, 1); -- Blanquita
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (12, '2024-09-22', '20:00', 3, 1); -- Argentina, 1985

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (13, '2024-09-23', '15:00', 1, 1); -- El conde
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (14, '2024-09-23', '18:00', 2, 1); -- Blanquita
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (15, '2024-09-23', '20:00', 3, 1); -- Argentina, 1985

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (16, '2024-09-24', '15:00', 1, 1); -- El conde
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (17, '2024-09-24', '18:00', 2, 1); -- Blanquita
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (18, '2024-09-24', '20:00', 3, 1); -- Argentina, 1985

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (19, '2024-09-25', '15:00', 1, 1); -- El conde
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (20, '2024-09-25', '18:00', 2, 1); -- Blanquita
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (21, '2024-09-25', '20:00', 3, 1); -- Argentina, 1985

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (22, '2024-09-26', '15:00', 4, 1); -- Huesera
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (23, '2024-09-26', '18:00', 5, 1); -- Los Lobos
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (24, '2024-09-26', '20:00', 6, 1); -- Ema

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (25, '2024-09-27', '15:00', 4, 1); -- Huesera
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (26, '2024-09-27', '18:00', 5, 1); -- Los Lobos
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (27, '2024-09-27', '20:00', 6, 1); -- Ema

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (28, '2024-09-28', '15:00', 4, 1); -- Huesera
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (29, '2024-09-28', '18:00', 5, 1); -- Los Lobos  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (30, '2024-09-28', '20:00', 6, 1); -- Ema

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (31, '2024-09-29', '15:00', 4, 1); -- Huesera
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (32, '2024-09-29', '18:00', 5, 1); -- Los Lobos
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (33, '2024-09-29', '20:00', 6, 1); -- Ema

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (34, '2024-09-30', '15:00', 4, 1); -- Huesera
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (35, '2024-09-30', '18:00', 5, 1); -- Los Lobos 
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (36, '2024-09-30', '20:00', 6, 1); -- Ema

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (37, '2024-10-01', '15:00', 4, 1); -- Huesera
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (38, '2024-10-01', '18:00', 5, 1); -- Los Lobos
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (39, '2024-10-01', '20:00', 6, 1); -- Ema

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (40, '2024-10-02', '15:00', 4, 1); -- Huesera
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (41, '2024-10-02', '18:00', 5, 1); -- Los Lobos
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (42, '2024-10-02', '20:00', 6, 1); -- Ema

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (43, '2024-10-03', '15:00', 7, 1); -- La ciénaga
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (44, '2024-10-03', '18:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (45, '2024-10-03', '20:00', 9, 1); -- Chicuarotes

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (46, '2024-10-04', '15:00', 7, 1); -- La ciénaga
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (47, '2024-10-04', '18:00', 8, 1); -- La Llorona  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (48, '2024-10-04', '20:00', 9, 1); -- Chicuarotes

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (49, '2024-10-05', '15:00', 7, 1); -- La ciénaga
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (50, '2024-10-05', '18:00', 8, 1); -- La Llorona  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (51, '2024-10-05', '20:00', 9, 1); -- Chicuarotes

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (52, '2024-10-06', '15:00', 7, 1); -- La ciénaga
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (53, '2024-10-06', '18:00', 8, 1); -- La Llorona  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (54, '2024-10-06', '20:00', 9, 1); -- Chicuarotes

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (55, '2024-10-07', '15:00', 7, 1); -- La ciénaga
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (56, '2024-10-07', '18:00', 8, 1); -- La Llorona  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (57, '2024-10-07', '20:00', 9, 1); -- Chicuarotes

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (58, '2024-10-08', '15:00', 7, 1); -- La ciénaga  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (59, '2024-10-08', '18:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (60, '2024-10-08', '20:00', 9, 1); -- Chicuarotes

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (61, '2024-10-09', '15:00', 7, 1); -- La ciénaga
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (62, '2024-10-09', '18:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_pelicula, fk_sala) VALUES (63, '2024-10-09', '20:00', 9, 1); -- Chicuarotes



-- INSERT CARTELERAS-FUNCIONES
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (1, 1, 1);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (2, 1, 2);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (3, 1, 3);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (4, 1, 4);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (5, 1, 5);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (6, 1, 6);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (7, 1, 7);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (8, 1, 8);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (9, 1, 9);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (10, 1, 10);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (11, 1, 11);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (12, 1, 12);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (13, 1, 13);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (14, 1, 14);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (15, 1, 15);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (16, 1, 16);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (17, 1, 17);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (18, 1, 18);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (19, 1, 19);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (20, 1, 20);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (21, 1, 21);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (22, 2, 22);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (23, 2, 23);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (24, 2, 24);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (25, 2, 25);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (26, 2, 26);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (27, 2, 27);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (28, 2, 28);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (29, 2, 29);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (30, 2, 30);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (31, 2, 31);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (32, 2, 32);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (33, 2, 33);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (34, 2, 34);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (35, 2, 35); 
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (36, 2, 36);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (37, 2, 37);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (38, 2, 38);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (39, 2, 39);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (40, 2, 40);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (41, 2, 41);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (42, 3, 42);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (43, 3, 43);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (44, 3, 44);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (45, 3, 45);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (46, 3, 46);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (47, 3, 47);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (48, 3, 48);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (49, 3, 49);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (50, 3, 50); 
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (51, 3, 51);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (52, 3, 52);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (53, 3, 53);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (54, 3, 54);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (55, 3, 55);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (56, 3, 56);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (57, 3, 57);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (58, 3, 58);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (59, 3, 59);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (60, 3, 60);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (61, 3, 61);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (62, 3, 62);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_cartelera, fk_funcion) VALUES (63, 3, 63);

-- INSERT VENTAS
-- INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (1, '2024-09-20', '19:54', 4000, 1, 1);
-- INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (2, '2024-09-20', '14:12', 8000, 3, 10);
-- INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (3, '2024-09-28', '14:18', 8000, 2, 3);
-- INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (4, '2024-09-29', '17:47', 8000, 2, 5);
-- INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (5, '2024-09-30', '17:42', 12000, 1, 6);

INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (1, '2024-09-20', '11:30', 16000, 2, 8);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (2, '2024-09-20', '9:24', 12000, 2, 6);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (3, '2024-09-20', '17:31', 4000, 2, 10);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (4, '2024-09-21', '17:43', 8000, 2, 1);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (5, '2024-09-21', '11:52', 16000, 3, 9);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (6, '2024-09-21', '13:38', 12000, 1, 8);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (7, '2024-09-22', '16:53', 4000, 2, 7);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (8, '2024-09-22', '11:49', 8000, 1, 3);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (9, '2024-09-22', '16:27', 12000, 4, 6);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (10, '2024-09-22', '21:38', 4000, 1, 5);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (11, '2024-09-25', '8:04', 8000, 2, 6);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (12, '2024-09-25', '8:08', 12000, 1, 4);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (13, '2024-09-25', '19:47', 4000, 2, 6);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (14, '2024-09-26', '8:12', 16000, 1, 1);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (15, '2024-09-26', '11:53', 12000, 4, 4);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (16, '2024-09-26', '17:23', 4000, 4, 4);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (17, '2024-09-26', '20:18', 12000, 3, 8);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (18, '2024-09-27', '11:49', 8000, 3, 10);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (19, '2024-09-28', '9:20', 12000, 1, 6);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (20, '2024-09-28', '10:06', 8000, 2, 10);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (21, '2024-09-28', '14:42', 4000, 1, 8);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (22, '2024-09-29', '8:51', 8000, 4, 8);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (23, '2024-09-29', '20:07', 8000, 1, 5);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (24, '2024-09-30', '8:44', 12000, 2, 4);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (25, '2024-10-01', '19:58', 12000, 4, 6);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (26, '2024-10-02', '13:31', 4000, 4, 10);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (27, '2024-10-02', '14:14', 12000, 1, 5);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (28, '2024-10-02', '14:24', 4000, 1, 1);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (29, '2024-10-02', '16:14', 4000, 3, 8);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_cliente) VALUES (30, '2024-10-03', '8:58', 12000, 1, 6);


-- INSERT BOLETOS
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (1, 4000, 1, 11, 44);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (2, 4000, 1, 11, 45);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (3, 4000, 1, 11, 46);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (4, 4000, 1, 11, 47);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (5, 4000, 2, 11, 10);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (6, 4000, 2, 11, 11);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (7, 4000, 2, 11, 12);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (8, 4000, 3, 11, 20);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (9, 4000, 4, 8, 4);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (10, 4000, 4, 8, 5);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (11, 4000, 5, 7, 29);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (12, 4000, 5, 7, 30);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (13, 4000, 5, 7, 31);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (14, 4000, 5, 7, 32);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (15, 4000, 6, 15, 99);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (16, 4000, 6, 15, 100);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (17, 4000, 6, 15, 101);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (18, 4000, 7, 15, 14);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (19, 4000, 8, 19, 77);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (20, 4000, 8, 19, 78);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (21, 4000, 9, 18, 60);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (22, 4000, 9, 18, 61);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (23, 4000, 9, 18, 62);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (24, 4000, 10, 20, 15);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (25, 4000, 11, 24, 36);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (26, 4000, 11, 24, 37);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (27, 4000, 12, 26, 57);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (28, 4000, 12, 26, 58);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (29, 4000, 12, 26, 59);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (30, 4000, 13, 26, 100);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (31, 4000, 14, 22, 92);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (32, 4000, 14, 22, 93);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (33, 4000, 14, 22, 94);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (34, 4000, 14, 22, 95);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (35, 4000, 15, 25, 41);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (36, 4000, 15, 25, 42);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (37, 4000, 15, 25, 43);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (38, 4000, 16, 23, 82);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (39, 4000, 17, 27, 49);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (40, 4000, 17, 27, 50);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (41, 4000, 17, 27, 51);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (42, 4000, 18, 28, 23);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (43, 4000, 18, 28, 24);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (44, 4000, 19, 28, 74);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (45, 4000, 19, 28, 75);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (46, 4000, 19, 28, 76);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (47, 4000, 20, 31, 96);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (48, 4000, 20, 31, 97);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (49, 4000, 21, 29, 38);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (50, 4000, 21, 29, 39);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (51, 4000, 21, 29, 40);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (52, 4000, 22, 32, 31);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (53, 4000, 22, 32, 32);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (54, 4000, 23, 36, 83);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (55, 4000, 23, 36, 84);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (56, 4000, 23, 36, 85);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (57, 4000, 23, 36, 86);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (58, 4000, 24, 34, 33);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (59, 4000, 24, 34, 34);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (60, 4000, 25, 39, 91);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (61, 4000, 25, 39, 90);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (62, 4000, 25, 39, 89);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (63, 4000, 26, 37, 88);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (64, 4000, 26, 37, 87);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (65, 4000, 27, 40, 46);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (66, 4000, 28, 40, 96);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (67, 4000, 28, 40, 97);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (68, 4000, 29, 41, 67);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (69, 4000, 30, 43, 24); 
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (70, 4000, 30, 43, 25);
INSERT INTO BOLETO (id_boleto, precio, fk_venta, fk_funcion, fk_asiento) VALUES (71, 4000, 30, 43, 26);




