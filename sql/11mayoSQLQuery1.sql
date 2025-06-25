CREATE OR ALTER VIEW vista_Bloques_Reales_2025 AS
SELECT
    ID_Limpio,
    MIN(Inicio_Corregido) AS Inicio,
    MAX(Fin_Original) AS Fin,
    SUM(HorasPreparacionAjustada) AS Preparacion,
    SUM(HorasProduccionVisible) AS Produccion,
    Tipo,
    MAX(FlagPreparacionValida) AS Flag,
    ROW_NUMBER() OVER (PARTITION BY ID_Limpio, Tipo ORDER BY MIN(Inicio_Corregido)) AS Nro,
    CONVERT(VARCHAR(19), MIN(Inicio_Corregido), 120) AS Inicio_Legible,
    CONVERT(VARCHAR(19), MAX(Fin_Original), 120) AS Fin_Legible
FROM vista_Tiempos_Produccion_Preparacion_Medoro5_2025
WHERE Renglon = 201
GROUP BY ID_Limpio, Tipo
HAVING SUM(HorasPreparacionAjustada) > 0 OR SUM(HorasProduccionVisible) > 0;


SELECT * FROM vista_Bloques_Reales_2025

-- Vista final correcta: vista_Bloques_M5_Legible_2025
-- Fuente: vista_Tiempos_Produccion_Preparacion_Medoro5_2025
-- Estructura simple: una fila por bloque, sin desfase, con fechas legibles y tiempos correctos
CREATE OR ALTER VIEW vista_M5_BloquesFinales_2025 AS
SELECT 
    ID,
    TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
    Renglon,
    'Preparación' AS Tipo,
    CantidadHoras AS HorasPreparacionOriginal,
    CASE 
        WHEN ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon 
            ORDER BY CAST(Inicio AS DATETIME)
        ) = 1 THEN CantidadHoras
        ELSE 0
    END AS HorasPreparacionAjustada,
    CASE 
        WHEN ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon 
            ORDER BY CAST(Inicio AS DATETIME)
        ) = 1 THEN 1
        ELSE 0
    END AS FlagPreparacionValida,
    DATEADD(DAY, -2, CAST(Inicio AS DATETIME)) AS Inicio_Corregido,
    DATEADD(DAY, -2, CAST(Fin AS DATETIME)) AS Fin_Corregido,
    CONVERT(VARCHAR(19), DATEADD(DAY, -2, CAST(Inicio AS DATETIME)), 120) AS Inicio_Legible_Corregido_Texto,
    CONVERT(VARCHAR(19), DATEADD(DAY, -2, CAST(Fin AS DATETIME)), 120) AS Fin_Legible_Corregido_Texto
FROM ConCubo
WHERE Estado = 'Preparación' 
  AND Renglon = 201 
  AND AnoInicio = 2025 
  AND PATINDEX('%[0-9]%', ID) > 0

UNION ALL

SELECT 
    ID,
    TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
    Renglon,
    'Producción' AS Tipo,
    NULL AS HorasPreparacionOriginal,
    NULL AS HorasPreparacionAjustada,
    NULL AS FlagPreparacionValida,
    DATEADD(DAY, -2, CAST(Inicio AS DATETIME)) AS Inicio_Corregido,
    DATEADD(DAY, -2, CAST(Fin AS DATETIME)) AS Fin_Corregido,
    CONVERT(VARCHAR(19), DATEADD(DAY, -2, CAST(Inicio AS DATETIME)), 120) AS Inicio_Legible_Corregido_Texto,
    CONVERT(VARCHAR(19), DATEADD(DAY, -2, CAST(Fin AS DATETIME)), 120) AS Fin_Legible_Corregido_Texto
FROM ConCubo
WHERE Estado = 'Producción' 
  AND Renglon = 201 
  AND AnoInicio = 2025 
  AND PATINDEX('%[0-9]%', ID) > 0;








SELECT TOP 5 *
FROM vista_ConCubo_2025;


SELECT * FROM vista_M5_BloquesFinales_2025



SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'vista_Tiempos_Produccion_Preparacion_Medoro5_2025';

SELECT TOP 20 ID_Limpio, Fin_Original, Inicio_Corregido, *
FROM vista_Tiempos_Produccion_Preparacion_Medoro5_2025
WHERE Renglon = 201
ORDER BY Inicio_Corregido;


SELECT TOP 20 
    T.ID_Limpio,
    T.Inicio_Corregido,
    T.Fin_Original,
    T.Tipo,
    T.Renglon,
    T.HorasPreparacionAjustada,
    T.HorasProduccionVisible
FROM vista_Tiempos_Produccion_Preparacion_Medoro5_2025 AS T
WHERE T.Renglon = 201
ORDER BY T.Inicio_Corregido;
