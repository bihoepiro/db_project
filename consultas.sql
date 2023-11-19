-- Consulta 1 --
-- Cuales fueron los 5 tipos de Botas más y menos vendidas en Invierno 2023 y 2022.
WITH TopProductosMasVendidos AS (
    -- Subconsulta que encuentra los productos más vendidos
    SELECT IV.modelo_c, IV.color_c, SUM(IV.cantidad) AS total_vendido
    FROM ItemVendido IV
    INNER JOIN Venta V ON IV.código_v = V.código
    WHERE EXTRACT(MONTH FROM V.fecha_y_hora) IN ('6', '7', '8', '9', '10')
        AND EXTRACT(YEAR FROM V.fecha_y_hora) IN ('2022', '2023') AND IV.modelo_c LIKE 'B%'
    GROUP BY IV.modelo_c, IV.color_c
    ORDER BY total_vendido DESC
    LIMIT 5
)

SELECT TP.modelo_c,
       TP.color_c,
       TP.total_vendido,
       COALESCE(VP.modalidad, VV.modalidad, 'Sin información') AS modalidad_mas_vendida
FROM TopProductosMasVendidos TP
LEFT JOIN (
    SELECT IV.modelo_c, IV.color_c, 'Presencial' AS modalidad, SUM(IV.cantidad) AS total_presencial
    FROM ItemVendido IV
    INNER JOIN VentaPresencial VP ON IV.código_v = VP.código
    GROUP BY IV.modelo_c, IV.color_c
) VP ON TP.modelo_c = VP.modelo_c AND TP.color_c = VP.color_c
LEFT JOIN (
    SELECT IV.modelo_c, IV.color_c, 'Virtual' AS modalidad, SUM(IV.cantidad) AS total_virtual
    FROM ItemVendido IV
    INNER JOIN VentaVirtual VV ON IV.código_v = VV.código
    GROUP BY IV.modelo_c, IV.color_c
) VV ON TP.modelo_c = VV.modelo_c AND TP.color_c = VV.color_c;

-- Consulta 2 --
-- A que empresas pertenecen los repartidores que hicieron más envíos.
SELECT E.nombre AS nombre_empresa
FROM (
    SELECT R.ruc, COUNT(*) AS veces_repartiendo
    FROM VentaVirtual VV
    JOIN Repartidor R ON VV.dni_rep = R.dni
    GROUP BY R.ruc
) repartidores_max
JOIN Empresa E ON repartidores_max.ruc = E.ruc
WHERE repartidores_max.veces_repartiendo IN (
    SELECT MAX(veces_repartiendo)
    FROM (
        SELECT COUNT(*) AS veces_repartiendo
        FROM VentaVirtual VV
        JOIN Repartidor R ON VV.dni_rep = R.dni
        GROUP BY R.ruc
    ) max_veces_repartiendo
);

-- Consulta 3 --
-- Tienda tiene más pagos en MasterCard, Visa, Yape y Plin.
WITH PagosPorMetodo AS (
    SELECT
        P.método_pago,
        C.num_stand,
        C.centro_comercial,
        COUNT(*) AS total_pagos
    FROM Pago P
    JOIN VentaPresencial VP ON P.código = VP.código
    JOIN Caja C ON VP.caja_número = C.número AND VP.num_stand = C.num_stand AND VP.centro_comercial = C.centro_comercial
    GROUP BY P.método_pago, C.num_stand, C.centro_comercial
),
MaxPagosPorMetodo AS (
    SELECT
        método_pago,
        MAX(total_pagos) AS max_pagos
    FROM PagosPorMetodo
    WHERE método_pago IN ('MasterCard', 'Visa', 'Yape', 'Plin')
    GROUP BY método_pago
)
SELECT
    P.num_stand,
    P.centro_comercial,
    P.método_pago,
    P.total_pagos
FROM PagosPorMetodo P
JOIN MaxPagosPorMetodo M ON P.método_pago = M.método_pago AND P.total_pagos = M.max_pagos;

-- Consulta 4 --
-- Los calzados más abastecidos en cada tienda y cuantos han sido vendidos de estos en dicha tienda.
WITH CalzadoAbastecido AS (
    SELECT
        S.num_stand_T AS num_stand,
        S.centro_comercial_T AS centro_comercial,
        A.modelo_c AS modelo,
        A.color_c AS color,
        A.talla_c AS talla,
        SUM(S.cantidad) AS total_stock
    FROM Stock S
    JOIN Abastecimiento A ON S.modelo_c = A.modelo_c AND S.color_c = A.color_c AND S.talla_c = A.talla_c
    GROUP BY S.num_stand_T, S.centro_comercial_t, A.modelo_c, A.color_c, A.talla_c
),
MaxStockPorTienda AS (
    SELECT
        num_stand,
        centro_comercial,
        MAX(total_stock) AS max_stock
    FROM CalzadoAbastecido
    GROUP BY num_stand, centro_comercial
),
CalzadoMaxAbastecido AS (
    SELECT
        CA.num_stand AS num_stand,
        CA.centro_comercial AS centro_comercial,
        CA.modelo AS modelo,
        CA.color AS color,
        CA.talla AS talla,
        CA.total_stock AS stock
    FROM CalzadoAbastecido CA
    JOIN MaxStockPorTienda M ON CA.num_stand = M.num_stand AND CA.centro_comercial = M.centro_comercial AND CA.total_stock = M.max_stock
)
SELECT
    CMA.num_stand,
    CMA.centro_comercial,
    CMA.modelo,
    CMA.color,
    CMA.talla,
    CMA.stock AS stock_abastecido,
    COALESCE(SUM(IV.cantidad), 0) AS cantidad_vendida
FROM CalzadoMaxAbastecido CMA
LEFT JOIN ItemVendido IV ON CMA.modelo = IV.modelo_c AND CMA.color = IV.color_c AND CMA.talla = IV.talla_c
GROUP BY CMA.num_stand, CMA.centro_comercial, CMA.modelo, CMA.color, CMA.talla, CMA.stock;
