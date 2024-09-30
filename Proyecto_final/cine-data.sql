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
INSERT INTO EMPLEADO (id_empleado, nombre, apellido, dni, email, cargo, fecha_contratacion, sueldo, fk_id_cine) 
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
INSERT INTO SALA (capacidad, fk_id_cine) VALUES (140, 1);

-- INSERT ASIENTOS
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (1, 'A1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (2, 'A2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (3, 'A3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (4, 'A4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (5, 'A5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (6, 'A6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (7, 'A7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (8, 'A8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (9, 'A9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (10, 'A10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (11, 'A11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (12, 'A12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (13, 'A13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (14, 'A14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (15, 'B1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (16, 'B2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (17, 'B3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (18, 'B4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (19, 'B5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (20, 'B6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (21, 'B7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (22, 'B8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (23, 'B9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (24, 'B10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (25, 'B11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (26, 'B12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (27, 'B13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (28, 'B14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (29, 'C1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (30, 'C2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (31, 'C3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (32, 'C4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (33, 'C5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (34, 'C6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (35, 'C7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (36, 'C8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (37, 'C9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (38, 'C10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (39, 'C11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (40, 'C12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (41, 'C13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (42, 'C14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (43, 'D1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (44, 'D2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (45, 'D3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (46, 'D4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (47, 'D5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (48, 'D6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (49, 'D7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (50, 'D8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (51, 'D9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (52, 'D10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (53, 'D11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (54, 'D12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (55, 'D13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (56, 'D14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (57, 'E1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (58, 'E2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (59, 'E3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (60, 'E4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (61, 'E5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (62, 'E6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (63, 'E7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (64, 'E8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (65, 'E9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (66, 'E10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (67, 'E11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (68, 'E12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (69, 'E13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (70, 'E14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (71, 'F1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (72, 'F2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (73, 'F3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (74, 'F4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (75, 'F5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (76, 'F6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (77, 'F7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (78, 'F8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (79, 'F9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (80, 'F10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (81, 'F11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (82, 'F12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (83, 'F13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (84, 'F14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (85, 'G1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (86, 'G2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (87, 'G3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (88, 'G4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (89, 'G5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (90, 'G6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (91, 'G7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (92, 'G8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (93, 'G9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (94, 'G10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (95, 'G11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (96, 'G12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (97, 'G13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (98, 'G14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (99, 'H1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (100, 'H2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (101, 'H3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (102, 'H4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (103, 'H5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (104, 'H6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (105, 'H7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (106, 'H8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (107, 'H9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (108, 'H10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (109, 'H11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (110, 'H12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (111, 'H13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (112, 'H14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (113, 'I1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (114, 'I2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (115, 'I3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (116, 'I4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (117, 'I5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (118, 'I6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (119, 'I7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (120, 'I8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (121, 'I9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (122, 'I10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (123, 'I11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (124, 'I12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (125, 'I13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (126, 'I14', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (127, 'J1', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (128, 'J2', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (129, 'J3', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (130, 'J4', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (131, 'J5', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (132, 'J6', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (133, 'J7', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (134, 'J8', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (135, 'J9', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (136, 'J10', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (137, 'J11', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (138, 'J12', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (139, 'J13', 1);
INSERT INTO ASIENTO (id_asiento, nombre, fk_id_sala) VALUES (140, 'J14', 1);

-- INSERT CARTELERAS
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_id_cine) VALUES ('2024-09-19', '2024-09-25', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_id_cine) VALUES ('2024-09-26', '2024-10-02', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_id_cine) VALUES ('2024-10-03', '2024-10-09', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_id_cine) VALUES ('2024-10-10', '2024-10-16', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_id_cine) VALUES ('2024-10-17', '2024-10-23', 1);
INSERT INTO CARTELERA (fecha_inicio, fecha_fin, fk_id_cine) VALUES ('2024-10-24', '2024-10-30', 1);

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
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (1, 1, 1);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (2, 2, 1);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (3, 3, 1);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (4, 4, 2);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (5, 5, 2);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (6, 6, 2);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (7, 7, 3);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (8, 8, 3);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (9, 9, 3);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (10, 10, 4);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (11, 11, 4);
INSERT INTO CARTELERA_PELICULA (id_cartelera_pelicula, fk_id_pelicula, fk_id_cartelera) VALUES (12, 12, 4);


-- INSERT FUNCIONES
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (1, '2024-09-19', '15:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (2, '2024-09-19', '18:00', 11, 1); -- Parasite
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (3, '2024-09-19', '20:00', 7, 1); -- La ciénaga

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (4, '2024-09-20', '15:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (5, '2024-09-20', '18:00', 11, 1); -- Parasite
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (6, '2024-09-20', '20:00', 7, 1); -- La ciénaga

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (7, '2024-09-21', '15:00', 8, 1); -- La Llorona  
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (8, '2024-09-21', '18:00', 11, 1); -- Parasite
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (9, '2024-09-21', '20:00', 7, 1); -- La ciénaga

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (10, '2024-09-22', '15:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (11, '2024-09-22', '18:00', 11, 1); -- Parasite
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (12, '2024-09-22', '20:00', 7, 1); -- La ciénaga

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (13, '2024-09-23', '15:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (14, '2024-09-23', '18:00', 11, 1); -- Parasite
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (15, '2024-09-23', '20:00', 7, 1); -- La ciénaga

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (16, '2024-09-24', '15:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (17, '2024-09-24', '18:00', 11, 1); -- Parasite
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (18, '2024-09-24', '20:00', 7, 1); -- La ciénaga

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (19, '2024-09-25', '15:00', 8, 1); -- La Llorona
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (20, '2024-09-25', '18:00', 11, 1); -- Parasite
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (21, '2024-09-25', '20:00', 7, 1); -- La ciénaga

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (22, '2024-09-26', '15:00', 10, 1); -- The Square
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (23, '2024-09-26', '18:00', 15, 1); -- The Worst Person in the World
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (24, '2024-09-26', '20:00', 2, 1); -- Blanquita

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (25, '2024-09-27', '15:00', 10, 1); -- The Square
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (26, '2024-09-27', '18:00', 15, 1); -- The Worst Person in the World
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (27, '2024-09-27', '20:00', 2, 1); -- Blanquita

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (28, '2024-09-28', '15:00', 10, 1); -- The Square
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (29, '2024-09-28', '18:00', 15, 1); -- The Worst Person in the World
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (30, '2024-09-28', '20:00', 2, 1); -- Blanquita

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (31, '2024-09-29', '15:00', 10, 1); -- The Square
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (32, '2024-09-29', '18:00', 15, 1); -- The Worst Person in the World
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (33, '2024-09-29', '20:00', 2, 1); -- Blanquita

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (34, '2024-09-30', '15:00', 10, 1); -- The Square
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (35, '2024-09-30', '18:00', 15, 1); -- The Worst Person in the World 
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (36, '2024-09-30', '20:00', 2, 1); -- Blanquita

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (37, '2024-10-01', '15:00', 10, 1); -- The Square
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (38, '2024-10-01', '18:00', 15, 1); -- The Worst Person in the World
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (39, '2024-10-01', '20:00', 2, 1); -- Blanquita

INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (40, '2024-10-02', '15:00', 10, 1); -- The Square
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (41, '2024-10-02', '18:00', 15, 1); -- The Worst Person in the World
INSERT INTO FUNCION (id_funcion, fecha, hora, fk_id_pelicula, fk_id_sala) VALUES (42, '2024-10-02', '20:00', 2, 1); -- Blanquita


-- INSERT CARTELERAS-FUNCIONES
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (1, 1, 1);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (2, 1, 2);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (3, 1, 3);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (4, 1, 4);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (5, 1, 5);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (6, 1, 6);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (7, 1, 7);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (8, 1, 8);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (9, 1, 9);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (10, 1, 10);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (11, 1, 11);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (12, 1, 12);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (13, 1, 13);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (14, 1, 14);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (15, 1, 15);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (16, 1, 16);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (17, 1, 17);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (18, 1, 18);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (19, 1, 19);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (20, 1, 20);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (21, 1, 21);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (22, 2, 22);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (23, 2, 23);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (24, 2, 24);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (25, 2, 25);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (26, 2, 26);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (27, 2, 27);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (28, 2, 28);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (29, 2, 29);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (30, 2, 30);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (31, 2, 31);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (32, 2, 32);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (33, 2, 33);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (34, 2, 34);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (35, 2, 35); 
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (36, 2, 36);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (37, 2, 37);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (38, 2, 38);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (39, 2, 39);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (40, 2, 40);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (41, 2, 41);
INSERT INTO CARTELERA_FUNCION (id_cartelera_pelicula, fk_id_cartelera, fk_id_funcion) VALUES (42, 2, 42);

-- INSERT VENTAS
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_id_cliente) VALUES (1, '2024-09-20', '19:54', 4000, 1, 1);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_id_cliente) VALUES (2, '2024-09-28', '14:12', 8000, 3, 10);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_id_cliente) VALUES (3, '2024-09-20', '14:18', 8000, 2, 3);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_id_cliente) VALUES (4, '2024-09-19', '17:47', 8000, 2, 5);
INSERT INTO VENTA (id_venta, fecha_venta, hora_venta, total_venta, fk_metodo_pago, fk_id_cliente) VALUES (5, '2024-09-21', '17:42', 12000, 1, 6);

-- INSERT BOLETOS
INSERT INTO BOLETO (id_boleto, precio, fk_id_venta, fk_id_funcion, fk_id_asiento) VALUES (1, 4000, 1, 1, 1);
INSERT INTO BOLETO (id_boleto, precio, fk_id_venta, fk_id_funcion, fk_id_asiento) VALUES (2, 4000, 2, 28, 37);
INSERT INTO BOLETO (id_boleto, precio, fk_id_venta, fk_id_funcion, fk_id_asiento) VALUES (3, 4000, 2, 28, 38);
INSERT INTO BOLETO (id_boleto, precio, fk_id_venta, fk_id_funcion, fk_id_asiento) VALUES (4, 4000, 3, 20, 4);
INSERT INTO BOLETO (id_boleto, precio, fk_id_venta, fk_id_funcion, fk_id_asiento) VALUES (5, 4000, 3, 20, 5);

