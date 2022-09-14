#-------------------------------------------------------------------------
#CREAMOS LA BASE DE DATOS DE LA EMPRESA "EL BUEN SAMARITANO"
#-------------------------------------------------------------------------
CREATE DATABASE EBS;

#CREACION DEL MODELO RELACIONAL
#CREACION DE TABLAS

#-------------------------------------------------------------------------
#USAMOS LA BASE DE DATOS
#-------------------------------------------------------------------------
USE EBS;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE CATEGORIA
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Categoria (
	Id_Categoria INT AUTO_INCREMENT,
    Descripcion VARCHAR (100) NOT NULL,
    PRIMARY KEY (Id_Categoria)
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE PAIS
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Pais (
	Id_Pais INT AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    PRIMARY KEY (Id_Pais)
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE GENERO
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Genero(
	Id_Genero INT AUTO_INCREMENT,
    Tipo VARCHAR(1) NOT NULL,
    PRIMARY KEY (Id_Genero)
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE PRODUCTO
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Producto(
	Id_Producto INT AUTO_INCREMENT,
    Nombre VARCHAR(100) NOT NULL,
    Precio DOUBLE(10,2) NOT NULL,
    Id_Categoria INT NOT NULL,
    PRIMARY KEY (Id_Producto),
    FOREIGN KEY (Id_Categoria) REFERENCES Categoria(Id_Categoria)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE CLIENTE
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Cliente (
	Id_Cliente INT AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Direccion VARCHAR(150) NOT NULL,
    Telefono BIGINT NOT NULL,
    Salario DOUBLE(5,2) NOT NULL,
    Id_Genero INT NOT NULL,
    Id_Pais INT NOT NULL,
    PRIMARY KEY (Id_Cliente),
    FOREIGN KEY (Id_Genero) REFERENCES Genero(Id_Genero)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Id_Pais) REFERENCES Pais(Id_Pais)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE EMPLEADO
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Empleado(
	Id_Empleado INT AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Id_Pais INT NOT NULL,
    PRIMARY KEY (Id_Empleado),
    FOREIGN KEY (Id_Pais) REFERENCES Pais(Id_Pais)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE FACTURA
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Factura(
	Id_Factura INT AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    Id_Cliente INT ,
    PRIMARY KEY (Id_Factura),
    FOREIGN KEY (Id_Cliente) REFERENCES Cliente(Id_Cliente)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=INNODB;

#-------------------------------------------------------------------------
#CREAMOS LA TABLA DE DETALLE_FACTURA
#-------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS Detalle_Factura(
	Id_Linea INT AUTO_INCREMENT,
    Cantidad INT NOT NULL,
    Id_Factura INT NOT NULL,
    Id_Empleado INT NOT NULL,    
    Id_Producto INT NOT NULL,    
    PRIMARY KEY (Id_Linea,Id_Factura),
    FOREIGN KEY (Id_Empleado) REFERENCES Empleado(Id_Empleado)
    ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (Id_Producto) REFERENCES Producto(Id_Producto)
    ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=INNODB;