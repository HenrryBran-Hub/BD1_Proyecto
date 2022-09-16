#CREACION DE TABLAS AUXILIARES
#COMO SON VARIAS TABLAS Y SOLO SON PARA CARGAR DATOS
#NO PONDRE LLAVES PRIAMRIAS NI FORANEAS 
#TAMBIEN CREARE VISTAS PARA LA AYUDA DE INGRESO DE DATOS

#-------------------------------------------------------------------------
#USAMOS LA BASE DE DATOS
#-------------------------------------------------------------------------
USE EBS;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA AUXILIAR DE CATEGORIA
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AuxCategoria(
	Id_Categoria INT,
    Descripcion VARCHAR(100)
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A LA TABLA AUXILIAR DE CATEGORIA
#-------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/Henrr/OneDrive/Documentos/Bases de Datos 1/[BD1]P1_201314439/BD1_Proyecto/Archivos CSV/DB_Excel_CSV.csv' 
INTO TABLE AuxCategoria 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(Id_Categoria,Descripcion);

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA CATEGORIA Y CATEGORIA
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Categoria
AS SELECT Id_Categoria,Descripcion
FROM AuxCategoria
WHERE Descripcion NOT LIKE '' AND
Id_Categoria NOT LIKE ''
GROUP BY Id_Categoria,Descripcion;

INSERT INTO Categoria(Descripcion)
SELECT Descripcion
FROM V_Categoria;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA AUXILIAR DE PAIS
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AuxPais(
	Id_Pais INT,
    Nombre VARCHAR(50)
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A LA TABLA AUXILIAR DE CATEGORIA
#-------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/Henrr/OneDrive/Documentos/Bases de Datos 1/[BD1]P1_201314439/BD1_Proyecto/Archivos CSV/DB_Excel_CSV_4.csv' 
INTO TABLE AuxPais 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(Id_Pais,Nombre);

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA PAIS Y PAIS
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Pais
AS SELECT Id_Pais,Nombre
FROM AuxPais
WHERE Nombre NOT LIKE '' AND
Id_Pais NOT LIKE ''
GROUP BY Id_Pais,Nombre;

INSERT INTO Pais(Nombre)
SELECT Nombre
FROM V_Pais;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA AUXILIAR DE PRODUCTO
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AuxProducto(
    Id_Producto INT,
    Nombre VARCHAR(100),
    Precio DECIMAL(12,2),
    Id_Categoria INT
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A LA TABLA AUXILIAR DE PRODUCTO
#-------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/Henrr/OneDrive/Documentos/Bases de Datos 1/[BD1]P1_201314439/BD1_Proyecto/Archivos CSV/DB_Excel_CSV_5.csv' 
INTO TABLE AuxProducto 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(Id_Producto,Nombre,Precio,Id_Categoria);

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA PRODUCTO
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Producto
AS SELECT Id_Producto,Nombre,Precio,Id_Categoria
FROM AuxProducto
WHERE Id_Producto NOT LIKE '' AND
Nombre IS NOT NULL AND
 Precio IS NOT NULL AND
 Id_Categoria IS NOT NULL
GROUP BY Id_Producto,Nombre,Precio,Id_Categoria;

INSERT INTO Producto(Nombre,Precio,Id_Categoria)
SELECT Nombre,Precio,Id_Categoria
FROM V_Producto;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA AUXILIAR DE CLIENTE
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AuxCliente(
    Id_Cliente INT,
    Nombre VARCHAR(50),
    Apellido VARCHAR(50),
    Direccion VARCHAR(150),
    Telefono BIGINT,
    Tarjeta BIGINT,
    Edad INT,
    Salario DECIMAL(10,2),
    Genero VARCHAR(1),
    Id_Pais INT
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A LA TABLA AUXILIAR DE CLIENTE
#-------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/Henrr/OneDrive/Documentos/Bases de Datos 1/[BD1]P1_201314439/BD1_Proyecto/Archivos CSV/DB_Excel_CSV_2.csv' 
INTO TABLE AuxCliente 
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(Id_Cliente,Nombre,Apellido,Direccion,Telefono,Tarjeta,Edad,Salario,Genero,Id_Pais);

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA GENERO
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Genero
AS SELECT Genero
FROM AuxCliente
WHERE Genero NOT LIKE '' 
GROUP BY Genero;

INSERT INTO Genero(Tipo)
SELECT Genero
FROM V_Genero;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA CLIENTE
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Cliente
AS SELECT Id_Cliente,Nombre,Apellido,Direccion,Telefono,Tarjeta,Edad,Salario,Genero,Id_Pais
FROM AuxCliente
WHERE Id_Cliente NOT LIKE '' AND 
 Nombre IS NOT NULL AND
 Apellido IS NOT NULL AND
 Direccion IS NOT NULL AND 
 Telefono IS NOT NULL AND
 Tarjeta IS NOT NULL AND
 Edad IS NOT NULL AND
 Salario IS NOT NULL AND
 Genero IS NOT NULL AND
 Id_Pais IS NOT NULL
GROUP BY Id_Cliente,Nombre,Apellido,Direccion,Telefono,Tarjeta,Edad,Salario,Genero,Id_Pais;

CREATE OR REPLACE VIEW V_Cliente2
AS SELECT AuxCliente.Id_Cliente,AuxCliente.Nombre,AuxCliente.Apellido,AuxCliente.Direccion,
AuxCliente.Telefono,AuxCliente.Tarjeta,AuxCliente.Edad,AuxCliente.Salario,AuxCliente.Genero,
Genero.Id_Genero,AuxCliente.Id_Pais
FROM AuxCliente,Genero
WHERE AuxCliente.Genero = Genero.Tipo
GROUP BY AuxCliente.Id_Cliente,AuxCliente.Nombre,AuxCliente.Apellido,AuxCliente.Direccion,
AuxCliente.Telefono,AuxCliente.Tarjeta,AuxCliente.Edad,AuxCliente.Salario,AuxCliente.Genero,
Genero.Id_Genero,AuxCliente.Id_Pais;

INSERT INTO Cliente(Nombre,Apellido,Direccion,Telefono,Tarjeta,Edad,Salario,Id_Genero,Id_Pais)
SELECT Nombre,Apellido,Direccion,Telefono,Tarjeta,Edad,Salario,Id_Genero,Id_Pais
FROM V_Cliente2;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA AUXILIAR DE EMPLEADO
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AuxEmpleado(
    Id_Empleado INT,
    Nombre VARCHAR(100),
    Id_Pais INT
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A LA TABLA AUXILIAR DE EMPLEADO
#-------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/Henrr/OneDrive/Documentos/Bases de Datos 1/[BD1]P1_201314439/BD1_Proyecto/Archivos CSV/DB_Excel_CSV_6.csv' 
INTO TABLE AuxEmpleado
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(Id_Empleado,Nombre,Id_Pais);

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA EMPLEADO
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Empleado
AS SELECT Id_Empleado,
SUBSTRING(Nombre,1,LOCATE(" ",Nombre)) AS Nombres,
SUBSTRING(Nombre,LOCATE(" ",Nombre)+1,LENGTH(Nombre)) AS Apellido,
Id_Pais
FROM AuxEmpleado
GROUP BY Id_Empleado,Nombres,Apellido,Id_Pais;

INSERT INTO Empleado(Nombre,Apellido,Id_Pais)
SELECT Nombres,Apellido,Id_Pais
FROM V_Empleado;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA AUXILIAR DE FACTURA
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS AuxFactura(
    Id_Orden INT,
    Linea_Orden INT,
    Fecha DATE,
    Id_Cliente INT,
    Id_Vendedor INT,
    Id_Producto INT,
    Cantidad INT
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A LA TABLA AUXILIAR DE EMPLEADO
#-------------------------------------------------------------------------
LOAD DATA LOCAL INFILE 'C:/Users/Henrr/OneDrive/Documentos/Bases de Datos 1/[BD1]P1_201314439/BD1_Proyecto/Archivos CSV/DB_Excel_CSV_3.csv' 
INTO TABLE AuxFactura
FIELDS TERMINATED BY ';' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS 
(Id_Orden,linea_Orden,@Fecha,Id_Cliente,Id_Vendedor,Id_Producto,Cantidad)
SET Fecha = STR_TO_DATE(@Fecha,'%d/%m/%Y');

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA FACTURA
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Factura
AS SELECT Id_Orden,Fecha,Id_Cliente
FROM AuxFactura
GROUP BY Id_Orden,Fecha,Id_Cliente;

INSERT INTO Factura(Fecha,Id_Cliente)
SELECT Fecha,Id_Cliente
FROM V_Factura;

#-------------------------------------------------------------------------
#CARGAMOS LOS DATOS A VISTA DETALLE FACTURA
#-------------------------------------------------------------------------
CREATE OR REPLACE VIEW V_Detalle_Factura
AS SELECT Linea_Orden,Cantidad,Id_Orden,Id_Vendedor,Id_Producto
FROM AuxFactura
GROUP BY Linea_Orden,Cantidad,Id_Orden,Id_Vendedor,Id_Producto;

INSERT INTO Detalle_Factura(Id_Linea,Cantidad,Id_Factura,Id_Empleado,Id_Producto)
SELECT Linea_Orden,Cantidad,Id_Orden,Id_Vendedor,Id_Producto
FROM V_Detalle_Factura;

#-------------------------------------------------------------------------
#ELIMINACION DE TABLAS AUXILIARES
#-------------------------------------------------------------------------
DROP TABLE AuxCategoria;
DROP TABLE AuxCliente;
DROP TABLE AuxEmpleado;
DROP TABLE AuxFactura;
DROP TABLE AuxPais;
DROP TABLE AuxProducto;

#-------------------------------------------------------------------------
#ELIMINACION DE VISTAS
#-------------------------------------------------------------------------
DROP VIEW V_Categoria;
DROP VIEW V_Cliente;
DROP VIEW V_Cliente2;
DROP VIEW V_Detalle_Factura;
DROP VIEW V_Empleado;
DROP VIEW V_Factura;
DROP VIEW V_Genero;
DROP VIEW V_Pais;
DROP VIEW V_Producto;
