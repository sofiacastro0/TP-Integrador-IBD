-- Traer los mozos que trabajan turno noche
SELECT mozos.id_mozo, mozos.nombre, mozos.apellido, turnos.nombre 
FROM mozos
JOIN turnos ON turnos.id_turno = mozos.turnos_id_turno
WHERE mozos.turnos_id_turno = (SELECT id_turno FROM turnos WHERE nombre LIKE 'Noche')

-- Traer los productos con la categoría 'Entrada'
SELECT * FROM productos
WHERE categorias_id_categoria = (SELECT id_categoria FROM categorias WHERE nombre LIKE 'entrada' )

-- Ver todos los pedidos con el nombre del mozo y el número de mesa
SELECT pedidos.id_pedido, pedidos.fecha_hora, pedidos.estado, mesas.numero_mesa, mozos.nombre AS nombre_mozo, mozos.apellido AS apellido_mozo FROM pedidos
JOIN mozos ON mozos.id_mozo = pedidos.mozos_id_mozo
JOIN mesas ON mesas.id_mesa = pedidos.mesas_id_mesa

-- Cuántos productos hay disponibles por cada categoría
SELECT categorias.nombre AS categoria, COUNT(productos.id_producto) AS cantidad_productos
FROM categorias
LEFT JOIN productos ON categorias.id_categoria = productos.categorias_id_categoria
GROUP BY categorias.id_categoria, categorias.nombre

-- Total a pagar de cada pedido
SELECT pedidos.id_pedido, SUM(dp.cantidad * dp.precio_unitario) AS total
FROM pedidos
JOIN detalles_pedido dp ON pedidos.id_pedido = dp.pedidos_id_pedido
GROUP BY pedidos.id_pedido
ORDER BY pedidos.id_pedido ASC

-- Productos más populares (Ranking de ventas)
SELECT productos.nombre AS producto, SUM(dp.cantidad) AS unidades_vendidas
FROM productos
JOIN detalles_pedido dp ON productos.id_producto = dp.productos_id_producto
GROUP BY productos.id_producto, productos.nombre
ORDER BY unidades_vendidas DESC

-- Precio promedio de los platos principales
SELECT AVG(precio_actual) AS precio_promedio_plato_principal 
FROM productos 
WHERE categorias_id_categoria = (SELECT id_categoria FROM categorias WHERE nombre LIKE 'Principal')
