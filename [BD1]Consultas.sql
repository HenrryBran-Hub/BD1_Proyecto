#-------------------------------------------------------------------------
#CREACION DE CONSULTAS
#-------------------------------------------------------------------------

#-------------------------------------------------------------------------
#1.MOSTRAR EL CLIENTE QUE MAS HA COMPRADO. SE DEBE DE MOSTRAR EL 
#ID DEL CLIENTE,NOMBRE,APELLIDO,PAIS Y MONTO TOTAL
#-------------------------------------------------------------------------
SELECT Cliente.Id_Cliente,Cliente.Nombre,Cliente.Apellido,Pais.Nombre AS Pais,SUM(Cantidad*Precio) AS Total
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Factura
ON Detalle_Factura.Id_Factura = Factura.Id_Factura
INNER JOIN Cliente 
ON Factura.Id_Cliente = Cliente.Id_Cliente
INNER JOIN Pais
ON Cliente.Id_Pais = Pais.Id_Pais
GROUP BY Cliente.Id_Cliente,Cliente.Nombre,Cliente.Apellido,Pais.Nombre
ORDER BY Total DESC
LIMIT 1;

#-------------------------------------------------------------------------
#2.MOSTRAR EL PRODUCTO MAS Y MENOS COMPRADO. SE DEBE MOSTRAR EL
#ID DE PRODUCTO,NOMBRE DEL PRODUCTO,CATEGORIA,CANTIDAD DE UNIDADES
#Y MONTO VENDIDO
#-------------------------------------------------------------------------
(SELECT Detalle_Factura.Id_Producto,Producto.Nombre,Categoria.Descripcion,SUM(Cantidad) as Total_Cantidades, SUM(Cantidad*Precio) AS Monto_Vendido
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Categoria
ON Categoria.Id_Categoria = Producto.Id_Categoria
GROUP BY Detalle_Factura.Id_Producto,Producto.Nombre,Categoria.Descripcion
ORDER BY Total_Cantidades DESC
LIMIT 1)
UNION
(SELECT Detalle_Factura.Id_Producto,Producto.Nombre,Categoria.Descripcion,SUM(Cantidad) as Total_Cantidades, SUM(Cantidad*Precio) AS Monto_Vendido
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Categoria
ON Categoria.Id_Categoria = Producto.Id_Categoria
GROUP BY Detalle_Factura.Id_Producto,Producto.Nombre,Categoria.Descripcion
ORDER BY Total_Cantidades,Monto_Vendido ASC
LIMIT 2);

#-------------------------------------------------------------------------
#3.MOSTRAR A LA PERSONA QUE MAS HA VENDIDO. SE DEBE MOSTRAR EL ID DEL 
#ID DEL VENDEDOR,NOMBRE DEL VENDEDOR, MONTO TOTAL VENDIDO
#-------------------------------------------------------------------------
SELECT Empleado.Id_Empleado,Empleado.Nombre,Empleado.Apellido,SUM(Cantidad*Precio) AS Total
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Empleado
ON Detalle_Factura.Id_Empleado = Empleado.Id_Empleado
GROUP BY Empleado.Id_Empleado,Empleado.Nombre,Empleado.Apellido
ORDER BY Total DESC
LIMIT 1;

#-------------------------------------------------------------------------
#4.MOSTRAR EL PAIS QUE MAS Y MENOS HA VENDIDO. SE DEBE MOSTRAR EL 
#NOMBRE DEL PAIS Y EL MONTO.(EN UNA SOLA CONSULTA)
#-------------------------------------------------------------------------
(SELECT Pais.Nombre AS Pais,SUM(Cantidad*Precio) AS Total
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Empleado
ON Detalle_Factura.Id_Empleado= Empleado.Id_Empleado
INNER JOIN Pais
ON Empleado.Id_Pais = Pais.Id_Pais
GROUP BY Pais.Nombre
ORDER BY Total DESC
LIMIT 1)
UNION
(SELECT Pais.Nombre AS Pais,SUM(Cantidad*Precio) AS Total
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Empleado
ON Detalle_Factura.Id_Empleado= Empleado.Id_Empleado
INNER JOIN Pais
ON Empleado.Id_Pais = Pais.Id_Pais
GROUP BY Pais.Nombre
ORDER BY Total ASC
LIMIT 1);

#-------------------------------------------------------------------------
#5.TOP 5 DE PAISES QUE MAS HAN COMPRADO EN ORDEN ASCENDENTE. SE LE  
#SOLICITA MOSTRAR EL ID DEL PAIS, NOMBRE Y MONTO TOTAL
#-------------------------------------------------------------------------
SELECT * FROM
	(SELECT Pais.Id_Pais,Pais.Nombre AS Pais,SUM(Cantidad*Precio) AS Total
	FROM Producto
	INNER JOIN Detalle_Factura
	ON Producto.Id_Producto = Detalle_Factura.Id_Producto
	INNER JOIN Factura
	ON Detalle_Factura.Id_Factura = Factura.Id_Factura
	INNER JOIN Cliente 
	ON Factura.Id_Cliente = Cliente.Id_Cliente
	INNER JOIN Pais
	ON Cliente.Id_Pais = Pais.Id_Pais
	GROUP BY Pais.Nombre
	ORDER BY Total ASC
	LIMIT 5) AS PAISES
ORDER BY Total ASC;

#-------------------------------------------------------------------------
#6.MOSTRAR LA CATEGORIA QUE MAS Y MENOS SE HA COMPRADO. DEBE DE MOSTRAR 
#EL NOMBRE DE LA CATEGORIA Y CANTIDAD DE UNIDADES
#-------------------------------------------------------------------------
(SELECT Categoria.Descripcion,SUM(Cantidad) AS No_Articulos,SUM(Cantidad*Precio) AS Total
FROM Categoria
INNER JOIN Producto
ON Categoria.Id_Categoria = Producto.Id_Categoria
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
GROUP BY Categoria.Descripcion
ORDER BY No_Articulos DESC
LIMIT 1)
UNION
(SELECT Categoria.Descripcion,SUM(Cantidad) AS No_Articulos,SUM(Cantidad*Precio) AS Total
FROM Categoria
INNER JOIN Producto
ON Categoria.Id_Categoria = Producto.Id_Categoria
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
GROUP BY Categoria.Descripcion
ORDER BY No_Articulos ASC
LIMIT 1);

#-------------------------------------------------------------------------
#7.MOSTRAR LA CATEGORIA QUE MAS Y MENOS SE HA COMPRADO DE CADA PAIS
#SE DEBE DE MOSTRAR NOMBRE DEL PAIS,NOMBRE DE LA CATEGORIA Y CANTIDAD 
#DE UNIDADES
#-------------------------------------------------------------------------
SELECT Descripcion AS Categoria,Pais,No_MAX_Articulos AS MAX_MIN_Articulos FROM (
(SELECT Descripcion,Pais,MAX(No_Articulos) AS No_MAX_Articulos
FROM (
	SELECT Categoria.Descripcion,Pais.Nombre AS Pais,SUM(Cantidad) as No_Articulos
	FROM Categoria
	INNER JOIN Producto
	ON Categoria.Id_Categoria = Producto.Id_Categoria
	INNER JOIN Detalle_Factura
	ON Producto.Id_Producto = Detalle_Factura.Id_Producto
	INNER JOIN Factura
	ON Detalle_Factura.Id_Factura = Factura.Id_Factura
	INNER JOIN Cliente 
	ON Factura.Id_Cliente = Cliente.Id_Cliente
	INNER JOIN Pais
	ON Cliente.Id_Pais = Pais.Id_Pais
	GROUP BY Categoria.Descripcion,Pais.Nombre
	ORDER BY Pais.Nombre,SUM(Cantidad) DESC) AS SUBCON
WHERE Pais IN (
    SELECT Nombre FROM Pais)
GROUP BY Pais
ORDER BY Pais,No_MAX_Articulos ASC)
UNION
(SELECT Descripcion,Pais,MIN(No_Articulos) AS No_MAX_Articulos
FROM (
	SELECT Categoria.Descripcion,Pais.Nombre AS Pais,SUM(Cantidad) as No_Articulos
	FROM Categoria
	INNER JOIN Producto
	ON Categoria.Id_Categoria = Producto.Id_Categoria
	INNER JOIN Detalle_Factura
	ON Producto.Id_Producto = Detalle_Factura.Id_Producto
	INNER JOIN Factura
	ON Detalle_Factura.Id_Factura = Factura.Id_Factura
	INNER JOIN Cliente 
	ON Factura.Id_Cliente = Cliente.Id_Cliente
	INNER JOIN Pais
	ON Cliente.Id_Pais = Pais.Id_Pais
	GROUP BY Categoria.Descripcion,Pais.Nombre
	ORDER BY Pais.Nombre,SUM(Cantidad) ASC) AS SUBCON2
WHERE Pais IN (
    SELECT Nombre FROM Pais)
GROUP BY Pais
ORDER BY Pais,No_MAX_Articulos ASC)) as SUBCON3
ORDER BY Pais,No_MAX_Articulos DESC;

#-------------------------------------------------------------------------
#8.MOSTRAR LAS VENTAS POR MES DE INGLATERRA. DEBE MOSTRAR EL NUMERO DE MES
#Y MONTO.
#-------------------------------------------------------------------------
SELECT MONTH(Fecha) AS Mes,SUM(Cantidad*Precio) AS Total
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Empleado
ON Detalle_Factura.Id_Empleado = Empleado.Id_Empleado 
INNER JOIN Factura
ON Detalle_Factura.Id_Factura = Factura.Id_Factura
INNER JOIN Pais
ON Empleado.Id_Pais = Pais.Id_Pais
WHERE Pais.Nombre LIKE 'Inglaterra\r'
GROUP BY Mes
ORDER BY Pais.Nombre,Mes;

#-------------------------------------------------------------------------
#9.MOSTRAR EL MES CON MAS Y MENOS VENTAS. SE DEBE MOSTRAR EL NUMERO DE 
#MES Y MONTO.(EN UNA SOLA CONSULTA)
#-------------------------------------------------------------------------
(SELECT MONTH(Fecha) AS Mes,SUM(Cantidad*Precio) AS Total
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Factura
ON Detalle_Factura.Id_Factura = Factura.Id_Factura
GROUP BY Mes
ORDER BY Total DESC
LIMIT 1)
UNION
(SELECT MONTH(Fecha) AS Mes,SUM(Cantidad*Precio) AS Total
FROM Producto
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
INNER JOIN Factura
ON Detalle_Factura.Id_Factura = Factura.Id_Factura
GROUP BY Mes
ORDER BY Total ASC
LIMIT 1);

#-------------------------------------------------------------------------
#10.MOSTRAR LAS VENTAS DE CADA PRODUCTO DE LA CATEGORIA DEPORTES. 
#SE DEBE DE MOSTRAR EL ID DEL PRODUCTO, NOMBRE Y MONTO
#-------------------------------------------------------------------------
SELECT Producto.Id_Producto,Producto.Nombre,sum(Cantidad) AS No_Articulos,Precio,SUM(Cantidad*Precio) AS Total
FROM Categoria
INNER JOIN Producto
ON Categoria.Id_Categoria = Producto.Id_Categoria
INNER JOIN Detalle_Factura
ON Producto.Id_Producto = Detalle_Factura.Id_Producto
WHERE Categoria.Descripcion LIKE 'Deportes\r'
GROUP BY Producto.Id_Producto,Producto.Nombre
ORDER BY Producto.Nombre ASC;


#ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '123456789';