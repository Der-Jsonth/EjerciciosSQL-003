-- TALLER SQL II | AUTORUTA | 20 CASOS CON WHERE | SOLUCIONARIO DOCENTE
-- Base: AutoRuta_Datos_Oracle.sql | Motor: Oracle Database / Oracle SQL Developer
-- Se utilizan exclusivamente SELECT; no se modifican las tablas originales.
-- Conteos calculados con los registros del script adjunto; los resultados pueden variar si se cambia la base.
-- Ejecutar cada consulta de manera independiente. Las consultas son una posible solucion correcta.
-- Nota: LIKE puede distinguir mayusculas/minusculas segun la configuracion de la base.

-- CASO 01: Revisión de vehículos usados
-- Registros esperados: 6
SELECT id_vehiculo, marca, modelo, anio, kilometraje
FROM ca_vehiculo
WHERE estado = 'Usado'
ORDER BY kilometraje ASC;

-- CASO 02: Vehículos nuevos dentro del presupuesto
-- Registros esperados: 5
SELECT id_vehiculo, marca, modelo, estado, precio_lista
FROM ca_vehiculo
WHERE estado = 'Nuevo'
  AND precio_lista <= 18000000
ORDER BY precio_lista ASC, marca ASC;

-- CASO 03: Modelos de años seleccionados
-- Registros esperados: 13
SELECT id_vehiculo, marca, modelo, anio
FROM ca_vehiculo
WHERE anio BETWEEN 2023 AND 2025
ORDER BY anio ASC, marca ASC;

-- CASO 04: Marcas de interés para una alianza
-- Registros esperados: 3
SELECT DISTINCT marca AS marca
FROM ca_vehiculo
WHERE marca IN ('Toyota', 'Kia', 'Mazda')
ORDER BY marca ASC;

-- CASO 05: Catálogo fuera de dos categorías
-- Registros esperados: 4
SELECT marca, modelo, tipo, precio_lista
FROM ca_vehiculo
WHERE tipo NOT IN ('SUV', 'Hatchback')
ORDER BY precio_lista DESC;

-- CASO 06: Búsqueda de modelos por letra inicial
-- Registros esperados: 3
SELECT marca, modelo, anio, precio_lista
FROM ca_vehiculo
WHERE modelo LIKE 'S%'
ORDER BY modelo ASC;

-- CASO 07: Búsqueda de modelos por terminación
-- Registros esperados: 3
SELECT marca, modelo
FROM ca_vehiculo
WHERE modelo LIKE '%a'
ORDER BY modelo ASC;

-- CASO 08: Bonos de fábrica no informados
-- Registros esperados: 6
SELECT id_vehiculo, marca, modelo, precio_lista, bono_marca
FROM ca_vehiculo
WHERE bono_marca IS NULL
ORDER BY marca ASC, modelo ASC;

-- CASO 09: Contactos telefónicos por zona
-- Registros esperados: 3
SELECT id_cliente, nombre, apellido, ciudad, telefono
FROM ca_cliente
WHERE ciudad IN ('Santiago', 'Puente Alto')
  AND telefono IS NOT NULL
ORDER BY apellido ASC, nombre ASC;

-- CASO 10: Ventas de septiembre de 2026
-- Registros esperados: 6
SELECT id_venta, fecha_venta, precio_base
FROM ca_venta
WHERE fecha_venta BETWEEN DATE '2026-09-01' AND DATE '2026-09-30'
ORDER BY fecha_venta DESC, id_venta ASC;

-- CASO 11: Ventas con descuento y sin costo de gestión
-- Registros esperados: 3
SELECT id_venta, precio_base, descuento_pct, costo_gestion
FROM ca_venta
WHERE descuento_pct > 5
  AND costo_gestion IS NULL
ORDER BY descuento_pct DESC;

-- CASO 12: Campaña SUV: condiciones alternativas
-- Registros esperados: 5
SELECT id_vehiculo, marca, modelo, estado, precio_lista, kilometraje
FROM ca_vehiculo
WHERE tipo = 'SUV'
  AND (
    (estado = 'Nuevo' AND precio_lista <= 23000000)
    OR
    (estado = 'Usado' AND precio_lista <= 20000000 AND kilometraje <= 30000)
  )
ORDER BY precio_lista ASC;

-- CASO 13: Usados recientes para evaluación técnica
-- Registros esperados: 3
SELECT id_vehiculo, marca, modelo, anio, kilometraje
FROM ca_vehiculo
WHERE estado = 'Usado'
  AND anio >= 2022
  AND kilometraje BETWEEN 30000 AND 50000
ORDER BY kilometraje DESC, marca ASC;

-- CASO 14: Bono destacado o pendiente de confirmación
-- Registros esperados: 5
SELECT id_vehiculo, marca, modelo, anio, estado, precio_lista, bono_marca
FROM ca_vehiculo
WHERE estado = 'Nuevo'
  AND anio = 2025
  AND (bono_marca IS NULL OR bono_marca >= 400000)
ORDER BY marca ASC, modelo ASC;

-- CASO 15: Ciudades que contienen una letra
-- Registros esperados: 7
SELECT id_cliente, nombre, apellido, ciudad
FROM ca_cliente
WHERE ciudad LIKE '%a%'
ORDER BY ciudad ASC, apellido ASC;

-- CASO 16: Nombres con patrón y teléfono disponible
-- Registros esperados: 3
SELECT id_cliente, nombre, apellido, telefono
FROM ca_cliente
WHERE nombre LIKE '_a%'
  AND telefono IS NOT NULL
ORDER BY nombre ASC;

-- CASO 17: Ventas con descuento moderado
-- Registros esperados: 5
SELECT id_venta, precio_base, descuento_pct,
       precio_base * (1 - descuento_pct / 100) AS total_descontado
FROM ca_venta
WHERE descuento_pct BETWEEN 5 AND 8
  AND precio_base > 10000000
ORDER BY descuento_pct DESC, id_venta ASC;

-- CASO 18: Operaciones para revisión administrativa
-- Registros esperados: 3
SELECT id_venta, fecha_venta, precio_base, descuento_pct, costo_gestion
FROM ca_venta
WHERE descuento_pct = 0
   OR costo_gestion >= 180000
ORDER BY fecha_venta ASC, id_venta ASC;

-- CASO 19: Clientes sin teléfono fuera de una ciudad
-- Registros esperados: 2
SELECT id_cliente, nombre, apellido, ciudad, correo
FROM ca_cliente
WHERE telefono IS NULL
  AND ciudad <> 'Valparaiso'
ORDER BY ciudad ASC, apellido ASC;

-- CASO 20: Selección final para la vitrina SUV
-- Registros esperados: 5
SELECT id_vehiculo, marca, modelo, anio, precio_lista, bono_marca
FROM ca_vehiculo
WHERE tipo = 'SUV'
  AND anio >= 2024
  AND precio_lista BETWEEN 17000000 AND 23000000
  AND bono_marca IS NOT NULL
ORDER BY precio_lista ASC, marca ASC;

-- DESAFIO OPCIONAL (nivel posterior): JOIN + WHERE (3 ventas esperadas)
SELECT v.id_venta, v.fecha_venta,
       c.nombre || ' ' || c.apellido AS "CLIENTE",
       a.marca || ' ' || a.modelo AS "VEHICULO",
       e.nombre || ' ' || e.apellido AS "VENDEDOR",
       v.descuento_pct,
       v.precio_base * (1 - v.descuento_pct / 100) AS "TOTAL_PAGAR"
FROM ca_venta v
JOIN ca_cliente c ON c.id_cliente = v.id_cliente
JOIN ca_vehiculo a ON a.id_vehiculo = v.id_vehiculo
JOIN ca_vendedor e ON e.id_vendedor = v.id_vendedor
WHERE v.fecha_venta BETWEEN DATE '2026-10-01' AND DATE '2026-10-31'
  AND v.descuento_pct >= 5
ORDER BY v.id_venta ASC;

-- OBSERVACIONES PARA REVISION
-- CASO 08 y 19: NULL se busca con IS NULL, no mediante = NULL.
-- CASO 10: los registros de practica contienen fechas sin horas; para uso productivo es
-- preferible un intervalo semiabierto: fecha_venta >= DATE '2026-09-01'
--                                      AND fecha_venta < DATE '2026-10-01'.
-- CASO 12 y 14: parentesis obligatorios para expresar la logica solicitada.
-- CASO 15 y 16: en una configuracion habitual sensible a mayusculas se
-- consideran solo coincidencias con letra a minuscula.
-- CASO 17: el campo descuento_pct almacena 5 para representar 5%.
-- CASO 18: un registro con descuento_pct = 0 debe incluirse aunque costo_gestion sea NULL.
-- CASO 20: BETWEEN incluye ambos limites del rango numerico.
