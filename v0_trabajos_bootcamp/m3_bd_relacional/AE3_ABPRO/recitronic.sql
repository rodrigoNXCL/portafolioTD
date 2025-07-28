-- ========================================================
-- RECITRONIC - Gestión de Reciclaje de Electrónicos
-- Ejercicio grupal AE3_ABPRO
-- Autor: Rodrigo Chandia 
-- ========================================================

-- 1. CREACIÓN DE LA BASE DE DATOS Y TABLAS

-- Crear la base de datos (ejecuta sólo una vez)
CREATE DATABASE IF NOT EXISTS recitronic_db;
USE recitronic_db;

-- Tabla de clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(150) NOT NULL
);

-- Tabla de artículos electrónicos reciclados
CREATE TABLE articulos (
    id_articulo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    tipo_articulo VARCHAR(80) NOT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'pendiente', -- Ejemplo: pendiente, reciclado
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabla de citas para retiro de artículos
CREATE TABLE citas (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha_hora DATETIME NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- Tabla de pagos realizados
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_pago DATETIME NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- 2. INSERCIÓN DE DATOS (DML)
-- --------------------------------------------------------

-- Insertar clientes
INSERT INTO clientes (nombre, telefono, direccion) VALUES
('Ana Torres', '912345678', 'Calle Futura 123'),
('Carlos Peña', '987654321', 'Av. Central 45'),
('Marta Rivas', '932167890', 'Pasaje Verde 18');

-- Insertar artículos reciclados
INSERT INTO articulos (id_cliente, tipo_articulo, estado) VALUES
(1, 'Televisor', 'pendiente'),
(1, 'Microondas', 'pendiente'),
(2, 'Notebook', 'pendiente'),
(2, 'Tablet', 'pendiente'),
(3, 'Impresora', 'pendiente');

-- Insertar citas (agendar retiros)
INSERT INTO citas (id_cliente, fecha_hora) VALUES
(1, '2024-08-14 09:30:00'),
(2, '2024-08-14 11:00:00'),
(3, '2024-08-15 15:00:00');

-- Insertar pagos
INSERT INTO pagos (id_cliente, monto, fecha_pago) VALUES
(1, 12000, '2024-08-14 10:00:00'),
(2, 8000,  '2024-08-14 12:00:00');

-- --------------------------------------------------------
-- 3. ACTUALIZACIÓN DE INFORMACIÓN
-- --------------------------------------------------------

-- Actualizar la fecha de una cita (por conflicto de horario)
UPDATE citas
SET fecha_hora = '2024-08-15 17:30:00'
WHERE id_cita = 3;

-- Cambiar el estado de un artículo reciclado
UPDATE articulos
SET estado = 'reciclado'
WHERE id_articulo = 2; -- Microondas de Ana Torres

-- --------------------------------------------------------
-- 4. ELIMINACIÓN DE REGISTROS
-- --------------------------------------------------------

-- Eliminar un artículo reciclado ingresado por error
DELETE FROM articulos
WHERE id_articulo = 5; -- Impresora de Marta

-- Eliminar una cita cancelada
DELETE FROM citas
WHERE id_cita = 2;

-- --------------------------------------------------------
-- 5. RESTRICCIONES Y REFERENCIAS
-- (Ya implementadas arriba con PRIMARY KEY y FOREIGN KEY)
-- - No se puede agendar cita si el cliente no existe
-- - No se pueden ingresar artículos para clientes inexistentes

-- --------------------------------------------------------
-- 6. USO DE TRANSACCIONES (ATOMICIDAD, CONSISTENCIA, AISLAMIENTO Y DURABILIDAD - ACID)
-- --------------------------------------------------------

-- Ejemplo de transacción exitosa: Insertar un nuevo cliente, artículo, cita y pago
START TRANSACTION;
    INSERT INTO clientes (nombre, telefono, direccion) VALUES ('Pedro León', '921234567', 'Calle del Sol 111');
    SET @ultimo_id := LAST_INSERT_ID();
    INSERT INTO articulos (id_cliente, tipo_articulo, estado) VALUES (@ultimo_id, 'Monitor', 'pendiente');
    INSERT INTO citas (id_cliente, fecha_hora) VALUES (@ultimo_id, '2024-08-16 10:30:00');
    INSERT INTO pagos (id_cliente, monto, fecha_pago) VALUES (@ultimo_id, 6000, '2024-08-16 11:00:00');
COMMIT; -- Si todas las operaciones tienen éxito

-- Ejemplo de transacción con ROLLBACK (simula un error)
START TRANSACTION;
    INSERT INTO clientes (nombre, telefono, direccion) VALUES ('Cliente Erróneo', '911111111', 'Calle Error 999');
    SET @cid := LAST_INSERT_ID();
    -- Error intencional: intentar agendar cita con id_cliente inexistente
    INSERT INTO citas (id_cliente, fecha_hora) VALUES (9999, '2024-08-20 15:00:00');
    -- Esta operación falla, por lo tanto:
ROLLBACK; -- Revierte todo, el cliente erróneo NO queda en la BD

-- --------------------------------------------------------
-- Fin del desarrollo SQL para RECITRONIC :D
-- --------------------------------------------------------
