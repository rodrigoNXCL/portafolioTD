-- =====================================
-- AE4_ABPRO: Base de datos Librería en Línea
-- Autor: Rodrigo chandia
-- =====================================

-- 1. Crear la base de datos
CREATE DATABASE IF NOT EXISTS libreria_db;
USE libreria_db;

-- 2. Crear tablas principales

-- Tabla Clientes
CREATE TABLE Clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre_cliente VARCHAR(100) NOT NULL,
  correo_cliente VARCHAR(100) NOT NULL UNIQUE,
  telefono_cliente VARCHAR(15) NOT NULL,
  direccion_cliente VARCHAR(255) NOT NULL
);

-- Tabla Libros
CREATE TABLE Libros (
  id_libro INT AUTO_INCREMENT PRIMARY KEY,
  titulo_libro VARCHAR(255) NOT NULL,
  autor_libro VARCHAR(100) NOT NULL,
  precio_libro DECIMAL(10,2) NOT NULL,
  cantidad_disponible INT NOT NULL CHECK (cantidad_disponible >= 0),
  categoria_libro VARCHAR(50) NOT NULL
);

-- Tabla Pedidos
CREATE TABLE Pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  fecha_pedido DATE NOT NULL,
  total_pedido DECIMAL(10,2) NOT NULL,
  estado_pedido VARCHAR(50) NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- Tabla Detalles_Pedido
CREATE TABLE Detalles_Pedido (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_libro INT NOT NULL,
  cantidad_libro INT NOT NULL,
  precio_libro DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
  FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
);

-- Tabla Pagos
CREATE TABLE Pagos (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  fecha_pago DATE NOT NULL,
  monto_pago DECIMAL(10,2) NOT NULL,
  metodo_pago VARCHAR(50) NOT NULL,
  FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
);

-- 3. Aplicar restricciones y reglas adicionales

-- Solo valores numéricos de 10 dígitos en telefono_cliente (MySQL no permite CHECK con regexp, así que se valida en app o trigger)
ALTER TABLE Clientes MODIFY telefono_cliente VARCHAR(15) NOT NULL;

-- correo_cliente ya es único y no nulo (ya en el diseño)

-- cantidad_disponible en Libros no puede ser negativo (CHECK ya aplicado)

-- id_pedido, id_cliente e id_libro ya son obligatorios (NOT NULL y FK)

-- 4. Modificaciones solicitadas

-- 4.1 Cambiar tipo de telefono_cliente a VARCHAR(20)
ALTER TABLE Clientes MODIFY telefono_cliente VARCHAR(20) NOT NULL;

-- 4.2 Cambiar DECIMALS de precio_libro a 3 decimales
ALTER TABLE Libros MODIFY precio_libro DECIMAL(10,3) NOT NULL;
ALTER TABLE Detalles_Pedido MODIFY precio_libro DECIMAL(10,3) NOT NULL;

-- 4.3 Agregar fecha_confirmacion a Pagos
ALTER TABLE Pagos ADD fecha_confirmacion DATE;

-- 4.4 Eliminar Detalles_Pedido de pedidos entregados
-- Ejemplo: eliminar detalles donde el estado del pedido sea 'Entregado'
DELETE DP FROM Detalles_Pedido DP
JOIN Pedidos P ON DP.id_pedido = P.id_pedido
WHERE P.estado_pedido = 'Entregado';

-- 5. Eliminar tabla Pagos
DROP TABLE IF EXISTS Pagos;

-- 6. Truncar tabla Pedidos (vacía todos los registros)
TRUNCATE TABLE Pedidos;

-- =====================================
-- Fin del script Librería en Línea (AE4_ABPRO) :)
-- =====================================
