-- He creado una estructura de tablas relacionales para ver el ejemplo funcionamiento
-- en MYSQL y para realizar consultas en 2 tablas.
-- La cuota figura en la tabla cuotas relacionada con la tabla socios gracias a InnoDB.
 
-- ZONA DE DEFINICION 
 
DROP database mi_club;
CREATE DATABASE mi_club;
USE mi_club;
CREATE TABLE socios
(
id_socio INT NOT NULL AUTO_INCREMENT,
nombre VARCHAR(15),
apellidos VARCHAR(25),
dni VARCHAR(9),
domicilio VARCHAR(50),
localidad VARCHAR(30),
tipo_socio ENUM('A','B','C'),
fecha_alta DATE,
fecha_baja DATE,
-- importe_cuota Decimal (8,2),
paga_ult_recibo SET ('S','N'),
anotaciones BLOB,
PRIMARY KEY (id_socio)
-- Usamos el motor InnoDB en vez de MyISAM para el sistema relacional
) ENGINE=InnoDB;
 
-- Existen diversas formas de indexar, esta me resulta más facil.
ALTER TABLE socios
ADD INDEX dni(dni),
ADD INDEX apellidos(apellidos);
 
CREATE TABLE cuotas
(
id_cuota INT NOT NULL AUTO_INCREMENT ,
id_socio INT,
fecha_pago DATE,
importe_cuota Decimal(8,2),
anotaciones TEXT,
-- OJO, ejemplo de cómo crear la relación entre tablas.
PRIMARY KEY(id_cuota),
FOREIGN KEY (id_socio) REFERENCES socios(id_socio)
) ENGINE=InnoDB;
 
-- ZONA DE EJEMPLO DE INSERCION
 
-- Inserción de datos en la base, tabla socios.
 
INSERT INTO socios VALUES (1,'Oscar','De la Cuesta ','12660481','La direcion', 'Palencia','A','2010-11-25','2010-12-20','S','Este cliente soy yo');
INSERT INTO socios VALUES (2,'Joel', 'Morta','78546754','C\ Gandia','Valencia','C', '2010-11-25',NULL,'N','Este cliente es un moroso');
INSERT INTO socios VALUES (3,'Pedro','Anero','124342340','C\ Buenos aires','Barcelona','B','2010-12-01','2010-12-20','S','Cliente habitual');
INSERT INTO socios VALUES (4,'Ana','Rodriguez','34343444','C\ Serrano','Madrid','B','2010-12-01','2010-12-20','S','Solo veranos');
INSERT INTO socios VALUES (5,'Luis','Serrit','12776043','C\ Las brisas','Santander','C','2010-11-25','2010-12-25','S','Invierno');
INSERT INTO socios VALUES (6,'Maria','Arcona','33176043','C\ Asador','Santander','C',NULL,NULL,'S','Epoca de Verano');
INSERT INTO socios VALUES (7,'Jose','Coma','12773343','C\ Valverde','Palencia','A','2010-11-25','2010-12-25','S','No es un cliente habitual');
INSERT INTO socios VALUES (8,'Marcos','Garcia','12224343','C\ Los pedernales','Palencia','A','2010-11-25','2010-12-25','S','Le gusta el senderismo');
INSERT INTO socios VALUES (9,'Beatriz','Arconada','12324343','C\ Los Girasoles','Palencia','B','2010-11-25','2010-12-25','S','Posee tarjeta de descuento');
INSERT INTO socios VALUES (10,'Veronica','Artea','54124343','C\ lobro','Palencia','A','2010-11-25','2010-12-25','S','Cliente bastante formal');
 
-- Inserción de datos en la base, tabla cuotas.
INSERT INTO cuotas VALUES(1,1,'2010-12-25', 100,' El cliente tiene las cuentas saldadas');
INSERT INTO cuotas VALUES(2,2,NULL, 0,' El cliente no paga');
INSERT INTO cuotas VALUES(3,3,'2010-12-25', 50,' El cliente tiene las cuentas saldadas');
INSERT INTO cuotas VALUES(4,4,'2010-12-25', 40,' El cliente tiene las cuentas saldadas');
INSERT INTO cuotas VALUES(5,5,'2010-12-25', 30,' El cliente tiene las cuentas saldadas');
INSERT INTO cuotas VALUES(6,6,'2010-12-25', 5,' El cliente debe dinero');
INSERT INTO cuotas VALUES(7,7,'2010-12-25', 4,' El cliente debe dinero');
INSERT INTO cuotas VALUES(8,8,'2010-12-25', 2,' El cliente debe dinero');
INSERT INTO cuotas VALUES(9,1,'2010-12-25', 15,'El cliente tiene dinero');
INSERT INTO cuotas VALUES(10,10,'2010-12-25',120,'Cliente solvente');
 
-- ZONA DE CONSULTAS
-- en función de los datos introducidos. Siete ejemplos.
 
-- 1 - Todos los campos de todos los registros de la tabla “socios”.
SELECT * FROM SOCIOS;
 
-- 2 - Los campos nombre, apellidos, fecha_alta y localidad sólo de los socios de tipo "A" o "C"
SELECT nombre, apellidos, fecha_alta, localidad FROM socios WHERE tipo_socio = 'A' or tipo_socio='C';
 
-- 3 - Los campos dni, id_socio, tipo_socio y fecha_baja sólo de los socios cuyo campo paga_ult_recibo contenga "N".
SELECT dni, id_socio, tipo_socio, fecha_baja FROM socios WHERE paga_ult_recibo = 'N';
 
-- 4 - Todos los campos de los registros de la tabla “cuotas” de aquellos socios que tengan vacío el campo fecha_baja.
SELECT cuotas.* FROM cuotas RIGHT JOIN socios ON cuotas.id_socio=socios.id_socio WHERE socios.fecha_baja IS NULL;
 
-- 5 - La suma de todas las cuotas pagadas por un determinado socio (esto es el importe acumulado), por ejemplo id_socio igual a 3.
SELECT SUM(cuotas.importe_cuota) FROM cuotas WHERE cuotas.id_socio=1;
 
-- 6 - Los campos nombre y importe_acumulado (campo calculado que contendrá, en euros,
-- la cantidad acumulada que ha pagado el socio en todas las cuotas. Es decir, es la suma
-- de todas las cuotas para un socio dado.) de los socios cuyo importe_acumulado exceda
-- de una determinada cantidad, por ejemplo 10,00 €.
SELECT nombre, sum(c.importe_cuota) FROM cuotas c INNER JOIN socios s ON c.id_socio=s.id_socio WHERE c.importe_cuota &gt;= 10 GROUP BY nombre;
 
-- 7 - Lo mismo, pero cuyo importe_cuota no sobrepase esa misma cantidad.
SELECT nombre, sum(c.importe_cuota) FROM cuotas c INNER JOIN socios s ON c.id_socio=s.id_socio WHERE c.importe_cuota &lt; 10 GROUP BY nombre;