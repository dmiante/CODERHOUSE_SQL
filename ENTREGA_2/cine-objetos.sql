USE cine_independiente;

# VISTAS

-- Muestra el total de boletos vendidos y el monto recaudado por cada cine.
CREATE OR REPLACE VIEW ventas_por_cine AS
SELECT C.nombre AS cine,
       COUNT(B.id_boleto) AS boletos_vendidos,
       SUM(B.precio) AS total_recaudado
FROM BOLETO B
JOIN FUNCION F ON B.fk_id_funcion = F.id_funcion
JOIN SALA S ON F.fk_id_sala = S.id_sala
JOIN CINE C ON S.fk_id_cine = C.id_cine
GROUP BY C.nombre;

-- Muestra las funciones de peliculas con fecha y hora dentro de una cartelera activa
CREATE OR REPLACE VIEW funciones_disponibles AS
SELECT F.fecha, F.hora, P.titulo, C.nombre AS cine
FROM FUNCION F
JOIN PELICULA P ON F.fk_id_pelicula = P.id_pelicula
JOIN SALA S ON F.fk_id_sala = S.id_sala
JOIN CINE C ON S.fk_id_cine = C.id_cine
JOIN CARTELERA_FUNCION CF ON F.id_funcion = CF.fk_id_funcion
JOIN CARTELERA CA ON CF.fk_id_cartelera = CA.id_cartelera
WHERE CURDATE() BETWEEN CA.fecha_inicio AND CA.fecha_fin;

-- Muestra el total de boletos vendidos y el monto recaudado por cada película.
CREATE OR REPLACE VIEW ventas_por_pelicula AS
SELECT P.titulo AS pelicula,
       COUNT(B.id_boleto) AS boletos_vendidos,
       SUM(B.precio) AS total_recaudado
FROM BOLETO B
JOIN FUNCION F ON B.fk_id_funcion = F.id_funcion
JOIN PELICULA P ON F.fk_id_pelicula = P.id_pelicula
GROUP BY P.titulo;

# FUNCIONES

-- Devuelve el total recaudado por una función específica.
DELIMITER //
CREATE FUNCTION calcular_recaudacion_funcion(id_funcion BIGINT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(10, 2);
  SELECT SUM(precio) INTO total 
  FROM BOLETO WHERE fk_id_funcion = id_funcion;
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
  WHERE fk_id_funcion = id_funcion;

  RETURN total_boletos;
END //
DELIMITER ;


# PROCEDIMIENTOS ALMACENADOS

-- Agrega una pelicula nueva a la tabla pelicula
DELIMITER //
CREATE PROCEDURE agregar_pelicula(
  IN titulo VARCHAR(45), 
  IN anio INT, 
  IN duracion INT, 
  IN genero VARCHAR(100), 
  IN calificacion INT, 
  IN pais INT,
  IN sinopsis TEXT
)
BEGIN
  INSERT INTO PELICULA (titulo, anio_estreno, duracion, genero, fk_calificacion, fk_pais, sinopsis)
  VALUES (titulo, anio, duracion, genero, calificacion, pais, sinopsis);
END //
DELIMITER ;

-- Actualiza el precio de una funcion
DELIMITER //
CREATE PROCEDURE actualizar_precio_boletos(
    IN id_funcion BIGINT,
    IN nuevo_precio DECIMAL(10, 0)
)
BEGIN
    UPDATE BOLETO
    SET precio = nuevo_precio
    WHERE fk_id_funcion = id_funcion;
END //
DELIMITER ;

# TRIGGERS

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

-- Evitar boletos duplicados
DELIMITER //
CREATE TRIGGER evitar_boletos_duplicados
BEFORE INSERT ON BOLETO
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM BOLETO WHERE fk_id_cliente = NEW.fk_id_cliente AND fk_id_funcion = NEW.fk_id_funcion) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente ya ha comprado un boleto para esta función.';
    END IF;
END //
DELIMITER ;







