USE CINE_INDEPENDIENTE;

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









