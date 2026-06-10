CREATE TABLE mesas(
    id_mesa INT AUTO_INCREMENT PRIMARY KEY,
    numero_mesa INT NOT NULL, 
    capacidad INT NOT NULL,
    sector VARCHAR(30) NOT NULL,
    observaciones TEXT NULL
);

CREATE TABLE turnos(
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL
);

CREATE TABLE mozos(
    id_mozo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    apellido VARCHAR(45) NOT NULL,
    turnos_id_turno INT NOT NULL,
    FOREIGN KEY (turnos_id_turno) REFERENCES turnos(id_turno)
);


CREATE TABLE categorias(
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(30) NOT NULL,
    descripcion TEXT NULL
);


CREATE TABLE productos(
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(45) NOT NULL,
    precio_actual DECIMAL(10,2) NOT NULL,
    descripcion TEXT NULL,
    disponible TINYINT(1) DEFAULT 1,
    categorias_id_categoria INT NOT NULL,
    FOREIGN KEY (categorias_id_categoria) REFERENCES categorias(id_categoria)
);

CREATE TABLE pedidos(
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente', 'En preparación', 'Entregado', 'Cancelado', 'Cerrado') DEFAULT 'Pendiente',
    mesas_id_mesa INT NOT NULL,
    mozos_id_mozo INT NOT NULL,
    FOREIGN KEY (mesas_id_mesa) REFERENCES mesas(id_mesa),
    FOREIGN KEY (mozos_id_mozo) REFERENCES mozos(id_mozo)
);

CREATE TABLE detalles_pedido(
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    observaciones TEXT NULL,
    productos_id_producto INT NOT NULL,
    pedidos_id_pedido INT NOT NULL,
    FOREIGN KEY(productos_id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY(pedidos_id_pedido) REFERENCES pedidos(id_pedido)
);

-- 1. CATEGORIAS
INSERT INTO categorias (id_categoria, nombre, descripcion) VALUES
(1, 'Entrada',   'Platos para comenzar la comida'),
(2, 'Principal', 'Platos fuertes y guarniciones'),
(3, 'Postre',    'Opciones dulces para cerrar'),
(4, 'Bebida',    'Bebidas sin alcohol'),
(5, 'Alcohol',   'Bebidas con contenido alcohólico');

-- 2. PRODUCTOS 
INSERT INTO productos (id_producto, categorias_id_categoria, nombre, descripcion, precio_actual, disponible) VALUES
(1,  1, 'Empanadas x4',        'Empanadas de carne cortada a cuchillo',       6000.00, 1),
(2,  1, 'Tabla de fiambres',   'Selección de quesos y fiambres regionales',  18000.00, 1),
(3,  1, 'Provoleta',           'Provolone a la plancha con chimichurri',      8000.00, 1),
(4,  2, 'Bife de chorizo',     'Bife 350g con guarnición a elección',        22000.00, 1),
(5,  2, 'Pollo grillado',      'Pechuga marinada con papas rústicas',        12000.00, 1),
(6,  2, 'Milanesa napolitana', 'Milanesa con jamón, queso y salsa',          15000.00, 1),
(7,  2, 'Pasta del día',       'Consultar al mozo',                          11000.00, 1),
(8,  2, 'Risotto de hongos',   'Arroz arbóreo con hongos salteados',         14000.00, 0),
(9,  3, 'Tiramisú',            'Clásico italiano con mascarpone',             6500.00, 1),
(10, 3, 'Brownie con helado',  'Brownie tibio con dos bochas de helado',      6000.00, 1),
(11, 3, 'Flan casero',         'Con dulce de leche y crema',                  4500.00, 1),
(12, 4, 'Agua mineral',        '500ml con o sin gas',                         2500.00, 1),
(13, 4, 'Gaseosa',             'Coca, Sprite o Seven Up 350ml',               3000.00, 1),
(14, 4, 'Jugo natural',        'Naranja o pomelo exprimido',                  4000.00, 1),
(15, 5, 'Vino tinto copa',     'Malbec de la casa',                           5000.00, 1),
(16, 5, 'Vino blanco copa',    'Torrontés de la casa',                        5000.00, 1),
(17, 5, 'Cerveza artesanal',   'Rubia o negra 500ml',                         4500.00, 1),
(18, 5, 'Botella vino tinto',  'Malbec reserva 750ml',                       18000.00, 1);

-- 3. MESAS
INSERT INTO mesas (id_mesa, numero_mesa, capacidad, sector, observaciones) VALUES
(1, 1, 2, 'Salón interior', 'Ocupada'),
(2, 2, 4, 'Salón interior', 'Ocupada'),
(3, 3, 4, 'Salón interior', 'Libre'),
(4, 4, 6, 'Salón interior', 'Ocupada'),
(5, 5, 2, 'Terraza',        'Ocupada'),
(6, 6, 4, 'Terraza',        'Libre'),
(7, 7, 8, 'Salón VIP',      'Ocupada'),
(8, 8, 4, 'Salón interior', 'Libre');

-- 4. TURNOS
INSERT INTO turnos (id_turno, nombre) VALUES 
(1, 'Mañana'), 
(2, 'Tarde'), 
(3, 'Noche');

-- 5. MOZOS
INSERT INTO mozos (id_mozo, nombre, apellido, turnos_id_turno) VALUES
(1, 'Lucía',   'Fernández', 3), 
(2, 'Martín',  'Gómez',     3),
(3, 'Valeria', 'Torres',    3),
(4, 'Diego',   'Sosa',      2); 

-- 6. PEDIDOS
INSERT INTO pedidos (id_pedido, mesas_id_mesa, mozos_id_mozo, fecha_hora, estado) VALUES
(1,  1, 1, '2026-06-05 20:15:00', 'Entregado'),
(2,  2, 1, '2026-06-05 20:30:00', 'Entregado'),
(3,  2, 1, '2026-06-05 21:45:00', 'Entregado'),
(4,  4, 2, '2026-06-05 20:45:00', 'Cancelado'),
(5,  4, 2, '2026-06-05 20:50:00', 'Entregado'),
(6,  5, 3, '2026-06-05 21:00:00', 'Entregado'),
(7,  7, 2, '2026-06-05 21:30:00', 'En preparación'),
(8,  1, 1, '2026-06-05 21:50:00', 'Cerrado');

-- 7. DETALLES_PEDIDO 
INSERT INTO detalles_pedido (id_detalle, pedidos_id_pedido, productos_id_producto, cantidad, precio_unitario, observaciones) VALUES
(1,  1, 3,  1,  8000.00, NULL),                      
(2,  1, 4,  1, 22000.00, 'Término medio'),           
(3,  1, 5,  1, 12000.00, NULL),                      
(4,  1, 15, 2,  5000.00, NULL),                      
(5,  1, 12, 1,  2500.00, NULL),                      
(6,  2, 1,  2,  6000.00, NULL),                      
(7,  2, 2,  1, 18000.00, NULL),    
(8,  2, 4,  2, 22000.00, NULL),  
(9,  2, 6,  2, 15000.00, NULL),         
(10, 2, 18, 1, 18000.00, NULL),        
(11, 2, 12, 2,  2500.00, NULL),          
(12, 3, 9,  2,  6500.00, NULL),              
(13, 3, 10, 2,  6000.00, 'Bien tibio'),       
(14, 3, 17, 4,  4500.00, NULL),      
(15, 4, 6,  3, 15000.00, NULL),               
(16, 5, 1,  1,  6000.00, NULL),               
(17, 5, 7,  2, 11000.00, NULL),            
(18, 5, 5,  1, 12000.00, NULL),                    
(19, 5, 6,  1, 15000.00, NULL),                 
(20, 5, 13, 3,  3000.00, NULL),               
(21, 5, 14, 1,  4000.00, NULL),            
(22, 5, 11, 2,  4500.00, NULL),                     
(23, 6, 15, 2,  5000.00, NULL),                  
(24, 6, 9,  1,  6500.00, NULL),                      
(25, 6, 10, 1,  6000.00, NULL),                      
(26, 7, 3,  2,  8000.00, NULL),                      
(27, 7, 2,  1, 18000.00, NULL),                      
(28, 7, 4,  3, 22000.00, 'Dos a punto, uno jugoso'), 
(29, 7, 5,  2, 12000.00, NULL),                      
(30, 7, 18, 2, 18000.00, NULL),                      
(31, 7, 16, 2,  5000.00, NULL);                      


-- modificar ddatos
UPDATE mesas 
SET observaciones = 'Ocupada' 
WHERE numero_mesa = 3;

-- eliminar datos
DELETE FROM detalles_pedido 
WHERE pedidos_id_pedido = 1 AND productos_id_producto = 12;


