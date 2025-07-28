-- ==========================================
-- Ejercicio individual AE4_ABP: ECOINVENTORY_DB
-- Autor: Rodrigo Chandia
-- ==========================================

-- 1. Crear base de datos
CREATE DATABASE IF NOT EXISTS ECOINVENTORY_DB;
USE ECOINVENTORY_DB;

-- 2. Crear tablas

-- Tabla Productos
CREATE TABLE Productos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Categoría VARCHAR(50),
    Precio DECIMAL(10,2),
    Stock INT NOT NULL         -- Stock no permite nulos en inicio
);

-- Tabla Proveedores
CREATE TABLE Proveedores (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Teléfono INT,
    Dirección VARCHAR(120)
);

-- Tabla Compras
CREATE TABLE Compras (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_Proveedor INT NOT NULL,
    Fecha_Compra DATE,
    Total DECIMAL(10,2),
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID)
);

-- Tabla Detalle_Compra
CREATE TABLE Detalle_Compra (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_Compra INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT,
    Precio_Unitario DECIMAL(10,2),
    FOREIGN KEY (ID_Compra) REFERENCES Compras(ID),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID)
);

-- ==========================
-- 3. Aplicar reglas específicas
-- (Ya implementadas en la creación de tablas)
-- ==========================

-- ==========================
-- 4. Modificaciones en estructura
-- ==========================

-- 4.1 Agregar campo "Correo" a Proveedores
ALTER TABLE Proveedores ADD Correo VARCHAR(80);

-- 4.2 Cambiar tipo de "Teléfono" a VARCHAR(15)
ALTER TABLE Proveedores MODIFY COLUMN Teléfono VARCHAR(15);

-- 4.3 Permitir valores nulos en "Stock" (Productos)
ALTER TABLE Productos MODIFY COLUMN Stock INT NULL;

-- ==========================
-- 5. Eliminar y limpiar datos
-- ==========================

-- 5.1 Eliminar tabla Detalle_Compra
DROP TABLE IF EXISTS Detalle_Compra;

-- 5.2 Truncar tabla Productos (elimina todos los registros, estructura se mantiene)
TRUNCATE TABLE Productos;

-- Fin del ejercicio ECOINVENTORY_DB ;)
