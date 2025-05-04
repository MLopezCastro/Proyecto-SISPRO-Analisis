SELECT 
    c.ID,
    c.Renglon AS Maquina,
    u.saccod1,
    u.alto,
    u.ventana,
    MIN(c.Inicio) AS FechaInicio,
    MAX(c.Fin) AS FechaFin,
    COUNT(c.ID) AS TotalOrdenes,
    SUM(a.CantidadHorasProgPrep) AS TotalHorasProgPrep,
    SUM(a.CantidadHorasProgProd) AS TotalHorasProgProd,
    DATEDIFF(SECOND, MIN(c.Inicio), MAX(c.Fin)) / 3600.0 AS HorasReales,
    (DATEDIFF(SECOND, MIN(c.Inicio), MAX(c.Fin)) / 3600.0) - 
    (SUM(a.CantidadHorasProgPrep) + SUM(a.CantidadHorasProgProd)) AS DiferenciaTotalHoras
INTO Filtrada_Maquina201
FROM ConCuboFiltrada2024 c
LEFT JOIN TablaVinculadaUNION u ON c.ID = u.OP
LEFT JOIN ConArbol a ON c.ID = a.ID
WHERE c.Renglon = 201 -- Máquina 201
GROUP BY c.ID, c.Renglon, u.saccod1, u.alto, u.ventana
HAVING DATEDIFF(SECOND, MIN(c.Inicio), MAX(c.Fin)) / 3600.0 BETWEEN 0 AND 500 -- Filtro de tiempos reales razonables
   AND u.saccod1 IS NOT NULL -- Excluir configuraciones nulas
ORDER BY FechaInicio;


SELECT * FROM Filtrada_Maquina201