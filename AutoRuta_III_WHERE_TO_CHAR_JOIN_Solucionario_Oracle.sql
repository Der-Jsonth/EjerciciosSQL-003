-- AUTORUTA | TALLER III | WHERE + TO_CHAR + JOIN | 16 CASOS
-- Solucionario para docentes. Sintaxis: Oracle Database / Oracle SQL Developer.
-- Requiere haber ejecutado previamente AutoRuta_Datos_Oracle.sql.
-- Todos los casos son SELECT; no se modifican los datos originales.
-- Los separadores de TO_CHAR con G y D dependen de la configuracion NLS
-- de la sesion de Oracle. Las fechas DD/MM/YYYY no dependen de NLS.
-- Para verificar importes y ordenamientos, usar expresiones NUMERICAS y
-- no los resultados textuales de TO_CHAR.
-- Los totales de ventas excluyen costo_gestion salvo indicacion contraria.


-- CASO 01 | VEHÍCULOS USADOS PARA INSPECCIÓN
-- Eje: WHERE. Filas esperadas con la base original: 4.
SELECT id_vehiculo, marca, modelo, anio, kilometraje
FROM CA_VEHICULO
WHERE estado = 'Usado' AND kilometraje >= 30000
ORDER BY kilometraje DESC, id_vehiculo ASC;


-- CASO 02 | SUV NUEVOS PARA UN PRESUPUESTO DEFINIDO
-- Eje: WHERE. Filas esperadas con la base original: 4.
SELECT marca, modelo, anio, estado, precio_lista
FROM CA_VEHICULO
WHERE tipo = 'SUV' AND estado = 'Nuevo'
  AND precio_lista BETWEEN 17000000 AND 23000000
ORDER BY precio_lista ASC, marca ASC;


-- CASO 03 | SELECCIÓN DE MARCAS PARA CONVENIO
-- Eje: WHERE. Filas esperadas con la base original: 6.
SELECT id_vehiculo, marca, modelo, anio
FROM CA_VEHICULO
WHERE marca IN ('Toyota', 'Kia', 'Mazda') AND anio >= 2024
ORDER BY marca ASC, anio DESC;


-- CASO 04 | MODELOS QUE COMIENZAN CON UNA LETRA
-- Eje: WHERE. Filas esperadas con la base original: 2.
SELECT id_vehiculo, marca, modelo, anio, estado
FROM CA_VEHICULO
WHERE modelo LIKE 'S%' AND anio >= 2024
ORDER BY modelo ASC;


-- CASO 05 | BONOS PENDIENTES EN VEHÍCULOS USADOS
-- Eje: WHERE. Filas esperadas con la base original: 5.
SELECT id_vehiculo, marca, modelo, estado, precio_lista, bono_marca
FROM CA_VEHICULO
WHERE estado = 'Usado' AND bono_marca IS NULL
ORDER BY marca ASC, modelo ASC;


-- CASO 06 | VENTAS DE SEPTIEMBRE CON DESCUENTO
-- Eje: WHERE. Filas esperadas con la base original: 5.
SELECT id_venta, fecha_venta, precio_base, descuento_pct
FROM CA_VENTA
WHERE fecha_venta >= DATE '2026-09-01'
  AND fecha_venta < DATE '2026-10-01'
  AND descuento_pct >= 5
ORDER BY fecha_venta ASC, id_venta ASC;


-- CASO 07 | LISTA DE PRECIOS EXPRESADOS EN PESOS
-- Eje: WHERE + TO_CHAR. Filas esperadas con la base original: 5.
SELECT marca, modelo, precio_lista,
       TO_CHAR(precio_lista, 'FM999G999G999G990') || ' CLP' AS "PRECIO FORMATEADO"
FROM CA_VEHICULO
WHERE estado = 'Nuevo' AND precio_lista >= 20000000
ORDER BY precio_lista DESC;


-- CASO 08 | FECHAS Y DESCUENTOS DE OCTUBRE
-- Eje: WHERE + TO_CHAR. Filas esperadas con la base original: 3.
SELECT id_venta,
       TO_CHAR(fecha_venta, 'DD/MM/YYYY') AS "FECHA",
       TO_CHAR(descuento_pct, 'FM990D00') || ' %' AS "DESCUENTO",
       TO_CHAR(precio_base * (1 - descuento_pct / 100),
               'FM999G999G999G990D00') AS "TOTAL FORMATEADO"
FROM CA_VENTA
WHERE fecha_venta >= DATE '2026-10-01'
  AND fecha_venta < DATE '2026-11-01'
  AND descuento_pct > 0
ORDER BY fecha_venta ASC, id_venta ASC;


-- CASO 09 | PORCENTAJE QUE REPRESENTA EL BONO
-- Eje: WHERE + TO_CHAR. Filas esperadas con la base original: 6.
SELECT marca, modelo, precio_lista, bono_marca,
       TO_CHAR(bono_marca, 'FM999G999G999G990') AS "BONO FORMATEADO",
       TO_CHAR((bono_marca / precio_lista) * 100,
               'FM990D00') || ' %' AS "PORCENTAJE BONO"
FROM CA_VEHICULO
WHERE estado = 'Nuevo' AND bono_marca IS NOT NULL
  AND bono_marca >= 300000
ORDER BY (bono_marca / precio_lista) * 100 DESC;


-- CASO 10 | CLIENTES DE SANTIAGO CON COMPRAS BONIFICADAS
-- Eje: WHERE + JOIN. Filas esperadas con la base original: 4.
SELECT ve.id_venta,
       cl.nombre || ' ' || cl.apellido AS "CLIENTE",
       cl.ciudad, ve.fecha_venta, ve.descuento_pct
FROM CA_VENTA ve
INNER JOIN CA_CLIENTE cl ON cl.id_cliente = ve.id_cliente
WHERE cl.ciudad = 'Santiago' AND ve.descuento_pct > 0
ORDER BY ve.fecha_venta ASC, ve.id_venta ASC;


-- CASO 11 | USADOS VENDIDOS CON DESCUENTOS ACOTADOS
-- Eje: WHERE + JOIN. Filas esperadas con la base original: 3.
SELECT ve.id_venta, vh.marca, vh.modelo, vh.kilometraje,
       ve.precio_base, ve.descuento_pct
FROM CA_VENTA ve
INNER JOIN CA_VEHICULO vh ON vh.id_vehiculo = ve.id_vehiculo
WHERE vh.estado = 'Usado' AND ve.descuento_pct BETWEEN 5 AND 7
ORDER BY vh.kilometraje DESC;


-- CASO 12 | VENDEDORES CON COMISIONES ELEVADAS
-- Eje: WHERE + JOIN. Filas esperadas con la base original: 5.
SELECT ve.id_venta,
       vd.nombre || ' ' || vd.apellido AS "VENDEDOR",
       vd.comision_pct, ve.precio_base, ve.descuento_pct
FROM CA_VENTA ve
INNER JOIN CA_VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor
WHERE vd.comision_pct > 1.75 AND ve.descuento_pct >= 5
ORDER BY ve.descuento_pct DESC, ve.id_venta ASC;


-- CASO 13 | REPORTE DE VEHÍCULOS NUEVOS VENDIDOS EN SEPTIEMBRE
-- Eje: INTEGRACIÓN. Filas esperadas con la base original: 4.
SELECT ve.id_venta,
       TO_CHAR(ve.fecha_venta, 'DD/MM/YYYY') AS "FECHA",
       vh.marca || ' ' || vh.modelo AS "VEHICULO",
       cl.nombre || ' ' || cl.apellido AS "CLIENTE",
       TO_CHAR(ve.precio_base, 'FM999G999G999G990') AS "PRECIO BASE",
       TO_CHAR(ve.precio_base * ve.descuento_pct / 100,
               'FM999G999G999G990D00') AS "DESCUENTO CLP",
       TO_CHAR(ve.precio_base * (1 - ve.descuento_pct / 100),
               'FM999G999G999G990D00') AS "TOTAL CLP"
FROM CA_VENTA ve
INNER JOIN CA_VEHICULO vh ON vh.id_vehiculo = ve.id_vehiculo
INNER JOIN CA_CLIENTE cl ON cl.id_cliente = ve.id_cliente
WHERE vh.estado = 'Nuevo'
  AND ve.fecha_venta >= DATE '2026-09-01'
  AND ve.fecha_venta < DATE '2026-10-01'
  AND ve.descuento_pct >= 5
ORDER BY ve.precio_base * (1 - ve.descuento_pct / 100) DESC, ve.id_venta ASC;


-- CASO 14 | OPERACIONES DE OCTUBRE SIN COSTO DE GESTIÓN
-- Eje: INTEGRACIÓN. Filas esperadas con la base original: 2.
SELECT ve.id_venta,
       TO_CHAR(ve.fecha_venta, 'DD/MM/YYYY') AS "FECHA",
       cl.nombre || ' ' || cl.apellido AS "CLIENTE",
       vd.nombre || ' ' || vd.apellido AS "VENDEDOR",
       TO_CHAR(ve.descuento_pct, 'FM990D00') || ' %' AS "DESCUENTO",
       TO_CHAR(ve.precio_base * (1 - ve.descuento_pct / 100),
               'FM999G999G999G990D00') AS "TOTAL CLP"
FROM CA_VENTA ve
INNER JOIN CA_CLIENTE cl ON cl.id_cliente = ve.id_cliente
INNER JOIN CA_VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor
WHERE ve.fecha_venta >= DATE '2026-10-01'
  AND ve.fecha_venta < DATE '2026-11-01'
  AND ve.descuento_pct > 0
  AND ve.costo_gestion IS NULL
ORDER BY ve.fecha_venta DESC, ve.id_venta ASC;


-- CASO 15 | CAMPAÑA SUV CON DOS ALTERNATIVAS DE SELECCIÓN
-- Eje: INTEGRACIÓN. Filas esperadas con la base original: 3.
SELECT ve.id_venta,
       vh.marca || ' ' || vh.modelo AS "VEHICULO",
       cl.nombre || ' ' || cl.apellido AS "CLIENTE",
       vd.nombre || ' ' || vd.apellido AS "VENDEDOR",
       TO_CHAR(ve.fecha_venta, 'DD/MM/YYYY') AS "FECHA",
       TO_CHAR(ve.precio_base * (1 - ve.descuento_pct / 100),
               'FM999G999G999G990D00') AS "TOTAL CLP"
FROM CA_VENTA ve
INNER JOIN CA_VEHICULO vh ON vh.id_vehiculo = ve.id_vehiculo
INNER JOIN CA_CLIENTE cl ON cl.id_cliente = ve.id_cliente
INNER JOIN CA_VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor
WHERE vh.tipo = 'SUV'
  AND ((vh.estado = 'Nuevo' AND ve.descuento_pct >= 5)
       OR (vh.estado = 'Usado' AND vh.kilometraje < 30000))
ORDER BY ve.precio_base * (1 - ve.descuento_pct / 100) DESC, ve.id_venta ASC;


-- CASO 16 | AUDITORÍA COMERCIAL INTEGRAL Y SELECCIÓN DE OPORTUNIDADES
-- Eje: DESAFÍO FINAL. Filas esperadas con la base original: 4.
SELECT ve.id_venta AS "ID VENTA",
       TO_CHAR(ve.fecha_venta, 'DD/MM/YYYY') AS "FECHA",
       cl.nombre || ' ' || cl.apellido AS "CLIENTE",
       cl.ciudad AS "CIUDAD",
       vd.nombre || ' ' || vd.apellido AS "VENDEDOR",
       vh.marca || ' ' || vh.modelo AS "VEHICULO",
       vh.tipo AS "TIPO", vh.estado AS "ESTADO",
       vh.anio AS "ANIO", vh.kilometraje AS "KILOMETRAJE",
       TO_CHAR(ve.precio_base, 'FM999G999G999G990') AS "PRECIO BASE CLP",
       TO_CHAR(ve.descuento_pct, 'FM990D00') || ' %' AS "DESCUENTO %",
       TO_CHAR(ve.precio_base * ve.descuento_pct / 100,
               'FM999G999G999G990D00') AS "DESCUENTO CLP",
       TO_CHAR(ve.precio_base * (1 - ve.descuento_pct / 100),
               'FM999G999G999G990D00') AS "TOTAL NETO CLP",
       TO_CHAR(ve.costo_gestion, 'FM999G999G999G990') AS "COSTO GESTION CLP"
FROM CA_VENTA ve
INNER JOIN CA_VEHICULO vh ON vh.id_vehiculo = ve.id_vehiculo
INNER JOIN CA_CLIENTE cl ON cl.id_cliente = ve.id_cliente
INNER JOIN CA_VENDEDOR vd ON vd.id_vendedor = ve.id_vendedor
WHERE ve.fecha_venta >= DATE '2026-09-01'
  AND ve.fecha_venta < DATE '2026-11-01'
  AND ve.descuento_pct >= 5
  AND cl.ciudad IN ('Santiago', 'Valparaiso', 'Rancagua', 'La Serena')
  AND (vh.estado = 'Nuevo'
       OR (vh.estado = 'Usado' AND vh.kilometraje <= 50000))
  AND (ve.costo_gestion IS NULL OR ve.costo_gestion <= 150000)
  AND (vh.modelo LIKE 'S%' OR vh.tipo IN ('SUV', 'Sedan'))
ORDER BY ve.precio_base * (1 - ve.descuento_pct / 100) DESC,
         ve.id_venta ASC;

-- NOTA CASO 16: con los datos ficticios originales se seleccionan
-- los ID_VENTA: 4002, 4010, 4007 y 4001 (por total neto descendente).
-- El costo de gestion NULL permanece en NULL al formatearlo con TO_CHAR;
-- no equivale a costo 0. No se suma al neto mostrado en este informe.
-- Si cambian los datos de la base, los conteos indicados pueden variar.
