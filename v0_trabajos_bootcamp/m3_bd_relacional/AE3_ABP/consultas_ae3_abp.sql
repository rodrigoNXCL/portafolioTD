-- AE3_ABP – Consultas y operaciones para base de datos de clientes y pedidos
-- Autor: [Tu nombre]

-- 1. CREACIÓN DE TABLAS

-- Tabla de clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    telefono VARCHAR(30)
);

-- Tabla de pedidos, con FK a clientes
CREATE TABLE pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE
);

-- 2. INSERCIÓN DE CLIENTES (al menos 5)
INSERT INTO clientes (nombre, direccion, telefono) VALUES
('Ana López',      'Calle Falsa 123',     '987654321'),
('Juan Pérez',     'Av. Central 45',      '912345678'),
('Lucía Torres',   'Camino Real 77',      '934567890'),
('Mario Gómez',    'Las Flores 200',      '988765432'),
('Pedro Ramírez',  'El Bosque 18',        '976543210');

-- 3. INSERCIÓN DE PEDIDOS (al menos 10, asociando cliente_id)
INSERT INTO pedidos (cliente_id, fecha, total) VALUES
(1, '2024-07-01', 18000),
(1, '2024-07-05',  5500),
(2, '2024-07-02', 16000),
(2, '2024-07-09',  9000),
(2, '2024-07-12', 12000),
(3, '2024-07-03',  7000),
(3, '2024-07-08',  8200),
(4, '2024-07-04', 21000),
(5, '2024-07-10',  5000),
(5, '2024-07-15', 11500);

-- 4. PROYECTAR TODOS LOS CLIENTES Y SUS PEDIDOS
-- Muestra todos los clientes con sus pedidos (si tienen)
SELECT c.id AS cliente_id, c.nombre, c.direccion, c.telefono,
       p.id AS pedido_id, p.fecha, p.total
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
ORDER BY c.id, p.fecha;

-- 5. PROYECTAR PEDIDOS DE UN CLIENTE ESPECÍFICO (por ejemplo, id=2)
-- Cambia el valor según el cliente que quieras consultar
SELECT p.*
FROM pedidos p
WHERE p.cliente_id = 2;

-- 6. CALCULAR EL TOTAL DE TODOS LOS PEDIDOS PARA CADA CLIENTE
SELECT c.id, c.nombre, SUM(p.total) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- 7. ACTUALIZAR LA DIRECCIÓN DE UN CLIENTE (por ejemplo, id=3)
UPDATE clientes
SET direccion = 'Nueva Dirección 888'
WHERE id = 3;

-- 8. ELIMINAR UN CLIENTE Y SUS PEDIDOS ASOCIADOS (por ejemplo, id=4)
-- Gracias a ON DELETE CASCADE, los pedidos se eliminan automáticamente
DELETE FROM clientes
WHERE id = 4;

-- 9. PROYECTAR LOS TRES CLIENTES CON MÁS PEDIDOS (orden descendente)
SELECT c.id, c.nombre, COUNT(p.id) AS cantidad_pedidos
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre
ORDER BY cantidad_pedidos DESC
LIMIT 3;

-- FIN DEL ARCHIVO DE CONSULTAS AE3_ABP :)
