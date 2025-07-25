-- AE2_ABPRO – Consultas SQL para sistema de alquiler de autos
-- Grupo: Rodrigo Chandia 
-- Cada consulta incluye comentarios para facilitar su revisión.

-- Consulta 1:
-- Mostrar nombre, teléfono y email de los clientes con un alquiler activo hoy.
SELECT c.nombre, c.telefono, c.email
FROM Clientes c
JOIN Alquileres a ON c.id_cliente = a.id_cliente
WHERE CURDATE() BETWEEN a.fecha_inicio AND a.fecha_fin;

-- Consulta 2:
-- Mostrar vehículos alquilados en marzo de 2025 (modelo, marca, precio_dia).
SELECT v.modelo, v.marca, v.precio_dia
FROM Vehículos v
JOIN Alquileres a ON v.id_vehiculo = a.id_vehiculo
WHERE a.fecha_inicio BETWEEN '2025-03-01' AND '2025-03-31'
   OR a.fecha_fin BETWEEN '2025-03-01' AND '2025-03-31';

-- Consulta 3:
-- Calcular el precio total del alquiler para cada cliente.
SELECT c.nombre, a.id_alquiler,
       DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1 AS dias_alquiler,
       v.precio_dia,
       ((DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1) * v.precio_dia) AS precio_total
FROM Clientes c
JOIN Alquileres a ON c.id_cliente = a.id_cliente
JOIN Vehículos v ON a.id_vehiculo = v.id_vehiculo;

-- Consulta 4:
-- Clientes que NO han realizado ningún pago (nombre, email).
SELECT c.nombre, c.email
FROM Clientes c
LEFT JOIN Alquileres a ON c.id_cliente = a.id_cliente
LEFT JOIN Pagos p ON a.id_alquiler = p.id_alquiler
WHERE p.id_pago IS NULL;

-- Consulta 5:
-- Promedio de los pagos realizados por cada cliente (nombre, promedio).
SELECT c.nombre, AVG(p.monto) AS promedio_pago
FROM Clientes c
JOIN Alquileres a ON c.id_cliente = a.id_cliente
JOIN Pagos p ON a.id_alquiler = p.id_alquiler
GROUP BY c.nombre;

-- Consulta 6:
-- Vehículos disponibles para alquilar en una fecha específica (ejemplo: 2025-03-18).
SELECT v.modelo, v.marca, v.precio_dia
FROM Vehículos v
WHERE v.id_vehiculo NOT IN (
  SELECT a.id_vehiculo
  FROM Alquileres a
  WHERE '2025-03-18' BETWEEN a.fecha_inicio AND a.fecha_fin
);

-- Consulta 7:
-- Marca y modelo de vehículos alquilados más de una vez en marzo 2025.
SELECT v.marca, v.modelo, COUNT(*) AS veces_alquilado
FROM Vehículos v
JOIN Alquileres a ON v.id_vehiculo = a.id_vehiculo
WHERE (a.fecha_inicio BETWEEN '2025-03-01' AND '2025-03-31'
   OR a.fecha_fin BETWEEN '2025-03-01' AND '2025-03-31')
GROUP BY v.id_vehiculo, v.marca, v.modelo
HAVING COUNT(*) > 1;

-- Consulta 8:
-- Nombre del cliente, suma total de los pagos y cantidad de pagos efectuados.
SELECT c.nombre,
       SUM(p.monto) AS total_pagos,
       COUNT(p.id_pago) AS cantidad_pagos
FROM Clientes c
JOIN Alquileres a ON c.id_cliente = a.id_cliente
JOIN Pagos p ON a.id_alquiler = p.id_alquiler
GROUP BY c.nombre;

-- Consulta 9:
-- Clientes que alquilaron el Ford Focus (id_vehiculo = 3), mostrando nombre y fecha del alquiler.
SELECT c.nombre, a.fecha_inicio, a.fecha_fin
FROM Clientes c
JOIN Alquileres a ON c.id_cliente = a.id_cliente
WHERE a.id_vehiculo = 3;

-- Consulta 10:
-- Nombre del cliente y total de días alquilados, ordenado de mayor a menor.
SELECT c.nombre,
       SUM(DATEDIFF(a.fecha_fin, a.fecha_inicio) + 1) AS total_dias_alquilados
FROM Clientes c
JOIN Alquileres a ON c.id_cliente = a.id_cliente
GROUP BY c.nombre
ORDER BY total_dias_alquilados DESC;

-- Fin del archivo de consultas.
