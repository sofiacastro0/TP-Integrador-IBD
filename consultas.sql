-- Traer los mozos que trabajan turno noche
SELECT mozos.id_mozo, mozos.nombre, mozos.apellido, turnos.nombre 
FROM mozos
JOIN turnos ON turnos.id_turno = mozos.turnos_id_turno
WHERE mozos.turnos_id_turno = (SELECT id_turno FROM turnos WHERE nombre LIKE 'Noche');

-- Traer los productos con la categoría 'Entrada'
SELECT * FROM productos
WHERE categorias_id_categoria = (SELECT id_categoria FROM categorias WHERE nombre LIKE 'entrada');

-- Ver todos los pedidos con el nombre del mozo y el número de mesa
SELECT pedidos.id_pedido, pedidos.fecha_hora, pedidos.estado, mesas.numero_mesa, mozos.nombre AS nombre_mozo, mozos.apellido AS apellido_mozo FROM pedidos
JOIN mozos ON mozos.id_mozo = pedidos.mozos_id_mozo
JOIN mesas ON mesas.id_mesa = pedidos.mesas_id_mesa;

-- Cuántos productos hay disponibles por cada categoría
SELECT categorias.nombre AS categoria, COUNT(productos.id_producto) AS cantidad_productos
FROM categorias
LEFT JOIN productos ON categorias.id_categoria = productos.categorias_id_categoria
GROUP BY categorias.id_categoria, categorias.nombre;

-- Total a pagar de cada pedido
SELECT pedidos.id_pedido, SUM(dp.cantidad * dp.precio_unitario) AS total
FROM pedidos
JOIN detalles_pedido dp ON pedidos.id_pedido = dp.pedidos_id_pedido
GROUP BY pedidos.id_pedido
ORDER BY pedidos.id_pedido ASC;

-- Productos más populares (Ranking de ventas)
SELECT productos.nombre AS producto, SUM(dp.cantidad) AS unidades_vendidas
FROM productos
JOIN detalles_pedido dp ON productos.id_producto = dp.productos_id_producto
GROUP BY productos.id_producto, productos.nombre
ORDER BY unidades_vendidas DESC;

-- Precio promedio de los platos principales
SELECT AVG(precio_actual) AS precio_promedio_plato_principal 
FROM productos 
WHERE categorias_id_categoria = (SELECT id_categoria FROM categorias WHERE nombre LIKE 'Principal');

-- ver todos los pedidos con el nombre del mozo y el número de mesa
 SELECT p.id_pedido, p.fecha_hora, p.estado, m.numero_mesa, m.sector, mo.nombre AS mozo_nombre, mo.apellido AS mozo_apellido 
 FROM pedidos p 
 INNER JOIN mesas m ON p.mesas_id_mesa = m.id_mesa 
 INNER JOIN mozos mo ON p.mozos_id_mozo = mo.id_mozo 
 ORDER BY p.fecha_hora; 

-- ver todos los detalles de pedido con su categoría de producto 
SELECT dp.id_detalle, p.id_pedido, c.nombre AS categoria, pr.nombre AS producto, dp.cantidad, dp.precio_unitario 
FROM detalles_pedido dp 
INNER JOIN productos pr ON dp.productos_id_producto = pr.id_producto 
INNER JOIN categorias c ON pr.categorias_id_categoria = c.id_categoria 
INNER JOIN pedidos p ON dp.pedidos_id_pedido = p.id_pedido 
ORDER BY p.id_pedido, c.nombre; 

-- pedidos de una mesa específica (mesa número 2) 
SELECT p.id_pedido, p.fecha_hora, p.estado, m.numero_mesa 
FROM pedidos p 
INNER JOIN mesas m ON p.mesas_id_mesa = m.id_mesa 
WHERE m.numero_mesa = 2 
ORDER BY p.fecha_hora; 

-- pedidos cancelados atendidos por un mozo 
SELECT p.id_pedido, p.fecha_hora, p.estado, mo.nombre AS mozo_nombre, mo.apellido AS mozo_apellido, m.numero_mesa 
FROM pedidos p 
INNER JOIN mozos mo ON p.mozos_id_mozo = mo.id_mozo 
INNER JOIN mesas m ON p.mesas_id_mesa = m.id_mesa 
WHERE p.estado = 'Cancelado' 
ORDER BY mo.apellido; 


-- productos ordenados por precio de mayor a menor 
SELECT pr.nombre, pr.precio_actual, pr.descripcion, c.nombre AS categoria 
FROM productos pr 
INNER JOIN categorias c ON pr.categorias_id_categoria = c.id_categoria 
ORDER BY pr.precio_actual DESC; 

-- pedidos ordenados por fecha más reciente 
SELECT p.id_pedido, p.fecha_hora, p.estado, m.numero_mesa, mo.nombre AS mozo 
FROM pedidos p 
INNER JOIN mesas m ON p.mesas_id_mesa = m.id_mesa 
INNER JOIN mozos mo ON p.mozos_id_mozo = mo.id_mozo 
ORDER BY p.fecha_hora DESC; 


-- producto más pedido (por cantidad total) 
SELECT pr.nombre AS producto, SUM(dp.cantidad) AS total_pedido 
FROM detalles_pedido dp 
INNER JOIN productos pr ON dp.productos_id_producto = pr.id_producto 
GROUP BY pr.id_producto, pr.nombre 
ORDER BY total_pedido DESC; 

-- cantidad de pedidos por estado 
SELECT estado, COUNT(*) AS cantidad 
FROM pedidos 
GROUP BY estado 
ORDER BY cantidad DESC; 

-- Pedidos en un rango de fechas
SELECT
    pedidos.id_pedido,
    pedidos.fecha_hora,
    pedidos.estado,
    mesas.numero_mesa,
    mozos.nombre AS mozo
FROM pedidos
    INNER JOIN mesas ON pedidos.mesas_id_mesa = mesas.id_mesa
    INNER JOIN mozos ON pedidos.mozos_id_mozo = mozos.id_mozo
WHERE pedidos.fecha_hora BETWEEN '2026-06-05 00:00:00' AND '2026-06-05 23:59:59'
ORDER BY pedidos.fecha_hora;

-- Productos disponibles de una categoría
SELECT
    productos.id_producto,
    productos.nombre,
    productos.precio_actual,
    c.nombre AS categoria
FROM productos
    INNER JOIN categorias c ON productos.categorias_id_categoria = c.id_categoria
WHERE productos.disponible = 1
  AND c.nombre = 'Bebida'
ORDER BY productos.precio_actual;

-- Cuántos pedidos tomó cada mozo
SELECT
    mozos.nombre,
    mozos.apellido,
    t.nombre AS jornada,
    COUNT(p.id_pedido) AS total_pedidos
FROM mozos
    INNER JOIN turnos t ON mozos.turnos_id_turno = t.id_turno
    LEFT JOIN pedidos p ON p.mozos_id_mozo = mozos.id_mozo
GROUP BY mozos.id_mozo, mozos.nombre, mozos.apellido, t.nombre
ORDER BY total_pedidos DESC;

-- Total facturado por mesa en una noche
SELECT
    m.numero_mesa,
    m.sector,
    COUNT(DISTINCT p.id_pedido) AS cantidad_pedidos,
    SUM(detalle.cantidad * detalle.precio_unitario) AS total_facturado
FROM mesas m
    INNER JOIN pedidos p ON p.mesas_id_mesa = m.id_mesa
    INNER JOIN detalles_pedido detalle ON detalle.pedidos_id_pedido = p.id_pedido
WHERE p.estado != 'Cancelado'
  AND DATE(p.fecha_hora) = '2026-06-05' -- Fecha ajustada a los datos de prueba
GROUP BY m.id_mesa, m.numero_mesa, m.sector
ORDER BY total_facturado DESC;

-- Categoría que más ingresos generó
SELECT
    c.nombre AS categoria,
    SUM(detalle.cantidad * detalle.precio_unitario) AS total_ingresos
FROM detalles_pedido detalle
    INNER JOIN productos ON detalle.productos_id_producto = productos.id_producto
    INNER JOIN categorias c ON productos.categorias_id_categoria = c.id_categoria
    INNER JOIN pedidos p  ON detalle.pedidos_id_pedido = p.id_pedido
WHERE p.estado != 'Cancelado'
GROUP BY c.id_categoria, c.nombre
ORDER BY total_ingresos DESC;

-- Ranking de mozos por ventas del mes
SELECT
    mozos.nombre,
    mozos.apellido,
    t.nombre AS jornada,
    COUNT(DISTINCT p.id_pedido) AS pedidos_tomados,
    SUM(detalle.cantidad * detalle.precio_unitario) AS total_vendido
FROM mozos
    INNER JOIN turnos t ON mozos.turnos_id_turno = t.id_turno
    INNER JOIN pedidos p ON p.mozos_id_mozo = mozos.id_mozo
    INNER JOIN detalles_pedido detalle ON detalle.pedidos_id_pedido = p.id_pedido
WHERE p.estado != 'Cancelado'
  AND MONTH(p.fecha_hora) = 6
  AND YEAR(p.fecha_hora) = 2026
GROUP BY mozos.id_mozo, mozos.nombre, mozos.apellido, t.nombre
ORDER BY total_vendido DESC;

-- Productos que nunca fueron pedidos
SELECT
    productos.id_producto,
    productos.nombre,
    productos.precio_actual,
    c.nombre AS categoria
FROM productos
    INNER JOIN categorias c ON productos.categorias_id_categoria = c.id_categoria
    LEFT JOIN detalles_pedido detalle ON detalle.productos_id_producto = productos.id_producto
WHERE detalle.id_detalle IS NULL
ORDER BY c.nombre, productos.nombre;