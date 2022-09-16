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
INNER JOIN Factura
ON Detalle_Factura.Id_Factura = Factura.Id_Factura
INNER JOIN Cliente 
ON Factura.Id_Cliente = Cliente.Id_Cliente
INNER JOIN Pais
ON Cliente.Id_Pais = Pais.Id_Pais
GROUP BY Pais.Nombre
ORDER BY Total DESC
LIMIT 1)
UNION
(SELECT Pais.Nombre AS Pais,SUM(Cantidad*Precio) AS Total
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
	ORDER BY Total DESC
	LIMIT 5) AS PAISES
ORDER BY Total ASC;

#-------------------------------------------------------------------------
#6.MOSTRAR LA CATEGORIA QUE MAS Y MENOS SE HA COMPRADO 
#
#-------------------------------------------------------------------------


