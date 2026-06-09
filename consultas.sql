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
