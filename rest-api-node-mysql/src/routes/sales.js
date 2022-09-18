const express = require('express');
const router = express.Router();

const mysqlConnection = require('../database');

router.get('/1',(req, res) => {
    let consulta = `SELECT Cliente.Id_Cliente,Cliente.Nombre,Cliente.Apellido,Pais.Nombre AS Pais,SUM(Cantidad*Precio) AS Total
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
    LIMIT 1;`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/2',(req, res) => {
    let consulta = `(SELECT Detalle_Factura.Id_Producto,Producto.Nombre,Categoria.Descripcion,SUM(Cantidad) as Total_Cantidades, SUM(Cantidad*Precio) AS Monto_Vendido
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
    LIMIT 2);`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/3',(req, res) => {
    let consulta = `SELECT Empleado.Id_Empleado,Empleado.Nombre,Empleado.Apellido,SUM(Cantidad*Precio) AS Total
    FROM Producto
    INNER JOIN Detalle_Factura
    ON Producto.Id_Producto = Detalle_Factura.Id_Producto
    INNER JOIN Empleado
    ON Detalle_Factura.Id_Empleado = Empleado.Id_Empleado
    GROUP BY Empleado.Id_Empleado,Empleado.Nombre,Empleado.Apellido
    ORDER BY Total DESC
    LIMIT 1;`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/4',(req, res) => {
    let consulta = `(SELECT Pais.Nombre AS Pais,SUM(Cantidad*Precio) AS Total
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
    LIMIT 1);`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/5',(req, res) => {
    let consulta = `SELECT * FROM
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
ORDER BY Total ASC;`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/6',(req, res) => {
    let consulta = `(SELECT Categoria.Descripcion,SUM(Cantidad) AS No_Articulos,SUM(Cantidad*Precio) AS Total
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
    LIMIT 1);`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/7',(req, res) => {
    let consulta = `SELECT Descripcion AS Categoria,Pais,No_MAX_Articulos AS MAX_MIN_Articulos FROM (
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
        ORDER BY Pais,No_MAX_Articulos DESC;`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/8',(req, res) => {
    let consulta = `SELECT MONTH(Fecha) AS Mes,SUM(Cantidad*Precio) AS Total
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
    ORDER BY Pais.Nombre,Mes;`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/9',(req, res) => {
    let consulta = `(SELECT MONTH(Fecha) AS Mes,SUM(Cantidad*Precio) AS Total
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
    LIMIT 1);`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

router.get('/10',(req, res) => {
    let consulta = `SELECT Producto.Id_Producto,Producto.Nombre,sum(Cantidad) AS No_Articulos,Precio,SUM(Cantidad*Precio) AS Total
    FROM Categoria
    INNER JOIN Producto
    ON Categoria.Id_Categoria = Producto.Id_Categoria
    INNER JOIN Detalle_Factura
    ON Producto.Id_Producto = Detalle_Factura.Id_Producto
    WHERE Categoria.Descripcion LIKE 'Deportes\r'
    GROUP BY Producto.Id_Producto,Producto.Nombre
    ORDER BY Producto.Nombre ASC;`;
    mysqlConnection.query(consulta, (err, rows, fields) => {
        if (!err){
            res.json(rows);
        }else {
            console.log(err);
        }
    })
});

module.exports = router;