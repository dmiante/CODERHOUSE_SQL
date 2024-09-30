USE cine_independiente;

# 5 VISTAS

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












# 2 FUNCIONES

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








# 2 PROCEDIMIENTOS ALMACENADOS

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


-- Ver disponibilidad de asientos
DELIMITER $$
CREATE PROCEDURE disponibilidad_asientos(
  IN p_id_funcion BIGINT
)
BEGIN
  SELECT a.id_asiento, a.nombre 
  FROM ASIENTO a
  LEFT JOIN BOLETO b ON a.id_asiento = b.fk_id_asiento AND b.fk_id_funcion = p_id_funcion
  WHERE b.id_boleto IS NULL;
END $$
DELIMITER ;

-- Ver asientos ocupados
DELIMITER $$
CREATE PROCEDURE asientos_ocupados(
  IN p_id_funcion BIGINT
)
BEGIN
  SELECT a.id_asiento, a.nombre 
  FROM ASIENTO a
  LEFT JOIN BOLETO b ON a.id_asiento = b.fk_id_asiento AND b.fk_id_funcion = p_id_funcion
  WHERE b.id_boleto IS NOT NULL;
END $$
DELIMITER ;









# 2 TRIGGERS

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

-- actualizar el total de la venta al agregar un boleto
DELIMITER //
CREATE TRIGGER actualizar_total_venta
AFTER INSERT ON BOLETO
FOR EACH ROW
BEGIN
  UPDATE VENTA
  SET total_venta = total_venta + NEW.precio
  WHERE id_venta = NEW.fk_id_venta;
END //
DELIMITER ;









