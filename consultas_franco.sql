
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
