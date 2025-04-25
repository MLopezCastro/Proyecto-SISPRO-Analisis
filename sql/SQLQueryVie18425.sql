SELECT * FROM vista_PreparacionesUnicas_2025

SELECT * FROM vista_ConCubo_2025

CREATE VIEW vista_PreparacionesAjustadas_2025 AS
WITH PreparacionesAjustadas AS (
    SELECT 
        ID,
        ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras,
        Inicio_Legible,
        Fin_Legible,
        ROW_NUMBER() OVER (
            PARTITION BY ID_Limpio, Renglon 
            ORDER BY Inicio_Legible
        ) AS nro_vez
    FROM vista_ConCubo_2025
    WHERE Estado = 'Preparación'
)
SELECT 
    ID,
    ID_Limpio,
    Renglon,
    Estado,
    CASE 
        WHEN nro_vez = 1 THEN CantidadHoras
        ELSE 0
    END AS HorasPreparacionAjustada,
    CantidadHoras AS HorasPreparacionOriginal,
    Inicio_Legible,
    Fin_Legible,
    nro_vez
FROM PreparacionesAjustadas;

--

SELECT * FROM vista_PreparacionesAjustadas_2025

--

CREATE OR ALTER VIEW vista_PreparacionesAjustadas_2025 AS
WITH PreparacionesOrdenadas AS (
    SELECT 
        ID,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras AS HorasPreparacionOriginal,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon
            ORDER BY CAST(Inicio AS DATETIME)
        ) AS nro_vez
    FROM ConCubo
    WHERE 
        Estado = 'Preparación' AND
        TRY_CAST(Renglon AS INT) = 201 AND
        AnoInicio = 2025
)
SELECT 
    ID,
    ID_Limpio,
    Renglon,
    Estado,
    HorasPreparacionOriginal,
    CASE WHEN nro_vez = 1 THEN HorasPreparacionOriginal ELSE 0 END AS HorasPreparacionAjustada,
    Inicio_Legible,
    Fin_Legible,
    nro_vez
FROM PreparacionesOrdenadas;


--🧪 Validación en SQL Server
--1. Verificar órdenes con múltiples preparaciones

SELECT ID_Limpio, COUNT(*) AS PreparacionesTotales
FROM vista_PreparacionesAjustadas_2025
GROUP BY ID_Limpio
HAVING COUNT(*) > 1;

--2. Ver los valores corregidos por ejemplo

SELECT ID, ID_Limpio, HorasPreparacionOriginal, HorasPreparacionAjustada, nro_vez
FROM vista_PreparacionesAjustadas_2025
WHERE ID_Limpio = 14292;  -- o cualquier otra con duplicación


--3. Sumar el tiempo de preparación ajustado vs. original
SELECT 
  ID_Limpio,
  SUM(HorasPreparacionOriginal) AS TotalOriginal,
  SUM(HorasPreparacionAjustada) AS TotalAjustado
FROM vista_PreparacionesAjustadas_2025
GROUP BY ID_Limpio
ORDER BY ID_Limpio;

--modificamos la vista para ajustar fecha, porque adelanta 2 días:

CREATE OR ALTER VIEW vista_PreparacionesAjustadas_2025 AS
WITH PreparacionesOrdenadas AS (
    SELECT 
        ID,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras AS HorasPreparacionOriginal,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        DATEADD(DAY, -2, CAST(Inicio AS DATETIME)) AS Inicio_Legible_Corregido,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon
            ORDER BY CAST(Inicio AS DATETIME)
        ) AS nro_vez
    FROM ConCubo
    WHERE 
        Estado = 'Preparación' AND
        TRY_CAST(Renglon AS INT) = 201 AND
        AnoInicio = 2025
)
SELECT 
    ID,
    ID_Limpio,
    Renglon,
    Estado,
    HorasPreparacionOriginal,
    CASE WHEN nro_vez = 1 THEN HorasPreparacionOriginal ELSE 0 END AS HorasPreparacionAjustada,
    Inicio_Legible,
    Inicio_Legible_Corregido,
    Fin_Legible,
    nro_vez
FROM PreparacionesOrdenadas;

---🛠️ CÓDIGO SQL — Versión corregida con detección de reinicio por otra OT

-- 🔄 Vista: vista_PreparacionesReales_2025
-- Esta vista identifica TODAS las preparaciones reales,
-- incluyendo aquellas que ocurren cuando una misma OT se repite luego de haber sido interrumpida por otra.

CREATE OR ALTER VIEW vista_PreparacionesReales_2025 AS
WITH PreparacionesOrdenadas AS (
    SELECT 
        ID,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras AS HorasPreparacionOriginal,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        LAG(TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT)) 
            OVER (ORDER BY CAST(Inicio AS DATETIME)) AS ID_Anterior
    FROM ConCubo
    WHERE 
        AnoInicio = 2025 AND
        Renglon = 201 AND
        Estado = 'Preparación'
),
PreparacionesConFlag AS (
    SELECT *,
        CASE 
            WHEN ID_Limpio <> ID_Anterior THEN 1
            ELSE 0
        END AS FlagPreparacionValida
    FROM PreparacionesOrdenadas
)
SELECT 
    ID,
    ID_Limpio,
    Renglon,
    Estado,
    HorasPreparacionOriginal,
    CASE 
        WHEN FlagPreparacionValida = 1 THEN HorasPreparacionOriginal
        ELSE 0
    END AS HorasPreparacionAjustada,
    Inicio_Legible,
    Fin_Legible,
    FlagPreparacionValida
FROM PreparacionesConFlag;


--Luego probá esto para auditar:
SELECT * 
FROM vista_PreparacionesReales_2025
WHERE ID_Limpio = 14292
ORDER BY Inicio_Legible;

--✅ Actualización de la vista vista_PreparacionesReales_2025 para evitar errores por IDs no numéricos
--Esta versión evita errores como el de 'Rotatek 700' al filtrar cualquier ID que no contenga números antes de hacer el TRY_CAST.
CREATE OR ALTER VIEW vista_PreparacionesReales_2025 AS
WITH PreparacionesOrdenadas AS (
    SELECT 
        ID,
        Renglon,
        Estado,
        CantidadHoras AS HorasPreparacionOriginal,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon
            ORDER BY CAST(Inicio AS DATETIME)
        ) AS nro_vez
    FROM ConCubo
    WHERE Estado = 'Preparación'
      AND PATINDEX('%[0-9]%', ID) > 0 -- solo filas con número en el ID
)

SELECT *,
       CASE 
           WHEN nro_vez = 1 THEN HorasPreparacionOriginal
           ELSE 0
       END AS HorasPreparacionAjustada,
       CASE 
           WHEN nro_vez = 1 THEN 1
           ELSE 0
       END AS FlagPreparacionValida
FROM PreparacionesOrdenadas;

--A continuación te paso el código SQL para reemplazar la vista vista_PreparacionesReales_2025, 
--agregando la columna Inicio_Legible_Corregido que corrige el desfase de +2 días en la fecha original:

ALTER VIEW vista_PreparacionesReales_2025 AS
WITH PreparacionesOrdenadas AS (
    SELECT 
        ID,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras AS HorasPreparacionOriginal,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon
            ORDER BY CAST(Inicio AS DATETIME)
        ) AS nro_vez
    FROM ConCubo
    WHERE Estado = 'Preparación' AND
          Renglon = 201 AND
          TRY_CAST(Inicio AS DATETIME) IS NOT NULL
)
SELECT
    *,
    CASE WHEN nro_vez = 1 THEN HorasPreparacionOriginal ELSE 0 END AS HorasPreparacionAjustada,
    CASE WHEN nro_vez = 1 THEN 1 ELSE 0 END AS FlagPreparacionValida,
    DATEADD(DAY, -2, Inicio_Legible) AS Inicio_Legible_Corregido
FROM PreparacionesOrdenadas;

--📌 Esta vista queda lista para ser usada en Power BI sin problemas de jerarquía y mostrando correctamente fecha y hora.
ALTER VIEW vista_PreparacionesReales_2025 AS
WITH PreparacionesEnumeradas AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ID_Limpio, Renglon ORDER BY Inicio_Legible) AS nro_vez
    FROM vista_ConCubo_2025
    WHERE Estado = 'Preparación'
),
PreparacionesValidadas AS (
    SELECT *,
           CASE 
               WHEN nro_vez = 1 THEN CantidadHoras
               WHEN EXISTS (
                   SELECT 1
                   FROM vista_ConCubo_2025 v2
                   WHERE v2.ID_Limpio = p.ID_Limpio
                     AND v2.Renglon = p.Renglon
                     AND v2.Inicio_Legible < p.Inicio_Legible
                     AND v2.Estado = 'Producción'
               ) THEN CantidadHoras
               ELSE 0
           END AS HorasPreparacionAjustada,
           CASE 
               WHEN nro_vez = 1 THEN 1
               WHEN EXISTS (
                   SELECT 1
                   FROM vista_ConCubo_2025 v2
                   WHERE v2.ID_Limpio = p.ID_Limpio
                     AND v2.Renglon = p.Renglon
                     AND v2.Inicio_Legible < p.Inicio_Legible
                     AND v2.Estado = 'Producción'
               ) THEN 1
               ELSE 0
           END AS FlagPreparacionValida
    FROM PreparacionesEnumeradas p
)
SELECT 
    ID,
    ID_Limpio,
    Renglon,
    Estado,
    CantidadHoras AS HorasPreparacionOriginal,
    HorasPreparacionAjustada,
    FlagPreparacionValida,
    Inicio_Legible,
    Fin_Legible,
    DATEADD(DAY, -2, Inicio_Legible) AS Inicio_Legible_Corregido,
    CONVERT(VARCHAR(19), DATEADD(DAY, -2, Inicio_Legible), 120) AS Inicio_Legible_Corregido_Texto,
    nro_vez
FROM PreparacionesValidadas;

