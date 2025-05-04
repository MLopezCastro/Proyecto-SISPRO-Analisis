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
SELECT 
    SecuenciaID,
    COUNT(*) AS TotalOrdenesEnSecuencia,
    SUM(HorasReales) AS TotalHorasReales,
    SUM(TotalHorasProgPrep) AS TotalHorasProgPrep,
    SUM(TotalHorasProgProd) AS TotalHorasProgProd
FROM SecuenciasFinales
GROUP BY SecuenciaID
ORDER BY SecuenciaID;
