WITH Secuencias AS (
    SELECT 
        c.ID,
        c.Renglon AS Maquina,
        u.saccod1,
        MIN(c.Inicio) AS FechaInicio,
        MAX(c.Fin) AS FechaFin,
        ROW_NUMBER() OVER (
            PARTITION BY u.saccod1 
            ORDER BY MIN(c.Inicio)
        ) AS SecuenciaID
    FROM ConCuboFiltrada2024 c
    LEFT JOIN TablaVinculadaUNION u
        ON c.ID = u.OP
    WHERE c.Renglon = 201 -- Máquina 201
    GROUP BY c.ID, c.Renglon, u.saccod1
)
SELECT 
    s.SecuenciaID,
    s.saccod1,
    COUNT(s.ID) AS TotalOrdenesEnSecuencia,
    SUM(c.CantidadHoras) AS TotalHorasReales,
    SUM(a.CantidadHorasProgPrep) AS TotalHorasProgPrep,
    SUM(a.CantidadHorasProgProd) AS TotalHorasProgProd
FROM Secuencias s
LEFT JOIN ConCuboFiltrada2024 c
    ON s.ID = c.ID
LEFT JOIN ConArbol a
    ON c.ID = a.ID
GROUP BY s.SecuenciaID, s.saccod1
ORDER BY s.SecuenciaID;
