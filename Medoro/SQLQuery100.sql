WITH OrdenesSecuencias AS (
    SELECT 
        ID,
        Maquina,
        saccod1,
        FechaInicio,
        FechaFin,
        TotalHorasProgPrep,
        TotalHorasProgProd,
        HorasReales,
        DiferenciaTotalHoras,
        LAG(FechaFin) OVER (PARTITION BY saccod1 ORDER BY FechaInicio) AS FechaFinAnterior,
        ROW_NUMBER() OVER (PARTITION BY saccod1 ORDER BY FechaInicio) AS OrdenEnGrupo
    FROM Filtrada_Maquina201
),
SecuenciasConSaltos AS (
    SELECT 
        ID,
        Maquina,
        saccod1,
        FechaInicio,
        FechaFin,
        TotalHorasProgPrep,
        TotalHorasProgProd,
        HorasReales,
        DiferenciaTotalHoras,
        FechaFinAnterior,
        CASE 
            WHEN FechaFinAnterior IS NULL THEN 1
            WHEN DATEDIFF(HOUR, FechaFinAnterior, FechaInicio) > 24 THEN 1
            ELSE 0
        END AS Salto
    FROM OrdenesSecuencias
),
SecuenciasFinales AS (
    SELECT 
        *,
        SUM(Salto) OVER (PARTITION BY saccod1 ORDER BY FechaInicio ROWS UNBOUNDED PRECEDING) AS SecuenciaID
    FROM SecuenciasConSaltos
)
-- Obtener fechas de inicio y fin de las órdenes dentro de SecuenciaID = 1
SELECT 
    SecuenciaID,
    CONVERT(DATETIME, MIN(FechaInicio)) AS FechaInicioSecuencia,
    CONVERT(DATETIME, MAX(FechaFin)) AS FechaFinSecuencia,
    COUNT(*) AS TotalOrdenes
FROM SecuenciasFinales
WHERE SecuenciaID = 1 -- Cambiar aquí para analizar otra secuencia
GROUP BY SecuenciaID;
