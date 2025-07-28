-- ===================================================
-- Evaluación de Módulo – Sistema de Inventario Relacional
-- Autor: Rodrigo Chandía
-- ===================================================

-- 1. MODELO RELACIONAL (entidades y relaciones)
-- Entidades: Productos, Proveedores, Transacciones
-- Relación: Un proveedor puede estar vinculado a muchas transacciones; un producto a muchas transacciones.

-- 2. CREACIÓN DE LA BASE DE DATOS Y TABLAS
CREATE DATABASE IF NOT EXISTS inventario_db;
USE inventario_db;

-- Tabla de productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10,2) NOT NULL CHECK (precio > 0),
    cantidad_inventario INT NOT NULL CHECK (cantidad_inventario >= 0)
);

-- Tabla de proveedores
CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(80)
);

-- Tabla de transacciones (compra/venta)
CREATE TABLE transacciones (
    id_transaccion INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('compra','venta') NOT NULL,
    fecha DATE NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    id_producto INT NOT NULL,
    id_proveedor INT,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

-- 3. CONSULTAS BÁSICAS

-- a) Recuperar todos los productos en inventario
SELECT * FROM productos;

-- b) Recuperar todos los proveedores que suministran productos específicos (por ejemplo, "Mouse")
SELECT DISTINCT pr.*
FROM proveedores pr
JOIN transacciones t ON pr.id_proveedor = t.id_proveedor
JOIN productos p ON t.id_producto = p.id_producto
WHERE p.nombre = 'Mouse';

-- c) Consultar las transacciones de una fecha específica
SELECT * FROM transacciones WHERE fecha = '2024-08-20';

-- d) Número total de productos vendidos (tipo venta) y valor total de compras (tipo compra)
SELECT SUM(cantidad) AS total_vendidos FROM transacciones WHERE tipo='venta';
SELECT SUM(cantidad*precio) AS valor_total_compras
FROM transacciones t
JOIN productos p ON t.id_producto = p.id_producto
WHERE t.tipo='compra';

-- 4. MANIPULACIÓN DE DATOS (DML)

-- a) Insertar productos
INSERT INTO productos (nombre, descripcion, precio, cantidad_inventario)
VALUES ('Mouse', 'Mouse óptico USB', 9900, 50),
       ('Teclado', 'Teclado mecánico', 29900, 30);

-- b) Insertar proveedores
INSERT INTO proveedores (nombre, direccion, telefono, email)
VALUES ('CompuPartes Ltda', 'Av. PC 123', '912345678', 'ventas@compupartes.cl'),
       ('TecnoSuministros', 'Calle Tech 456', '987654321', 'info@tecnosuministros.cl');

-- c) Insertar transacciones (compra y venta)
INSERT INTO transacciones (tipo, fecha, cantidad, id_producto, id_proveedor)
VALUES ('compra', '2024-08-20', 10, 1, 1),  -- Compra de 10 Mouse a CompuPartes
       ('venta',  '2024-08-21', 2, 1, NULL); -- Venta de 2 Mouse

-- d) Actualizar inventario tras una venta
UPDATE productos SET cantidad_inventario = cantidad_inventario - 2 WHERE id_producto = 1;

-- e) Eliminar producto si ya no está disponible
DELETE FROM productos WHERE id_producto = 2 AND cantidad_inventario = 0;

-- 5. TRANSACCIONES SQL

-- Registrar compra usando transacción
START TRANSACTION;
    INSERT INTO transacciones (tipo, fecha, cantidad, id_producto, id_proveedor)
    VALUES ('compra', CURDATE(), 20, 1, 2);
    UPDATE productos SET cantidad_inventario = cantidad_inventario + 20 WHERE id_producto = 1;
COMMIT;

-- Si ocurre un error, usar ROLLBACK
START TRANSACTION;
    -- Simula un error (por ejemplo, proveedor inexistente)
    INSERT INTO transacciones (tipo, fecha, cantidad, id_producto, id_proveedor)
    VALUES ('compra', CURDATE(), 5, 1, 99); -- proveedor 99 no existe
ROLLBACK;

-- 6. CONSULTAS COMPLEJAS

-- a) Total de ventas de un producto el mes anterior
SELECT p.nombre, SUM(t.cantidad) AS total_vendido
FROM transacciones t
JOIN productos p ON t.id_producto = p.id_producto
WHERE t.tipo = 'venta'
  AND t.fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 1 MONTH) AND CURDATE()
GROUP BY p.nombre;

-- b) JOIN: Mostrar transacciones con info de producto y proveedor
SELECT t.*, p.nombre AS nombre_producto, pr.nombre AS nombre_proveedor
FROM transacciones t
LEFT JOIN productos p ON t.id_producto = p.id_producto
LEFT JOIN proveedores pr ON t.id_proveedor = pr.id_proveedor;

-- c) Subconsulta: Productos que no se han vendido en los últimos 30 días
SELECT *
FROM productos
WHERE id_producto NOT IN (
    SELECT id_producto FROM transacciones
    WHERE tipo='venta' AND fecha >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
);

-- 7. NORMALIZACIÓN / DESNORMALIZACIÓN

-- Las tablas cumplen 3NF: cada campo depende sólo de la clave primaria y no hay datos redundantes.
-- Si se requiere rendimiento en reportes, desnormalizar productos y proveedores en transacciones puede ser útil.

-- 8. RESTRICCIONES Y EXCEPCIONES

-- La cantidad_inventario no puede ser negativa (CHECK), precios mayores que cero (CHECK).
-- Si usan procedimientos, puedes envolver DML en TRY/CATCH (o manejadores de error específicos de tu RDBMS).
-- Ejemplo en MySQL:
DELIMITER $$
CREATE PROCEDURE vender_producto(pid INT, cant INT)
BEGIN
  DECLARE stock_actual INT;
  SELECT cantidad_inventario INTO stock_actual FROM productos WHERE id_producto = pid;
  IF stock_actual < cant THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente';
  ELSE
    UPDATE productos SET cantidad_inventario = cantidad_inventario - cant WHERE id_producto = pid;
  END IF;
END $$
DELIMITER ;

-- 9. DOCUMENTACIÓN Y COMENTARIOS
-- Cada bloque del código contiene comentarios explicativos para facilitar su revisión y evaluación.

-- ===================================================
-- Fin del script de la Evaluación de Módulo
-- ===================================================
