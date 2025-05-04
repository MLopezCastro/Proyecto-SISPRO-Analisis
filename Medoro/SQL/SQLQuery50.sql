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
    DATEDIFF(SECOND, MIN(c.Inicio), MAX(c.Fin)) / 3600.0 AS HorasReales, -- Tiempos reales en horas
    DATEDIFF(SECOND, MIN(c.Inicio), MAX(c.Fin)) / 3600.0 - 
        SUM(a.CantidadHorasProgPrep + a.CantidadHorasProgProd) AS DiferenciaTotalHoras -- Diferencia total
FROM 
    ConCuboFiltrada2024 c
LEFT JOIN ConArbol a
    ON c.ID = a.ID -- Ajustar la clave según corresponda
LEFT JOIN TablaVinculadaUNION u
    ON c.ID = u.OP -- Ajustar si la relación es diferente
WHERE 
    c.Renglon = 201 -- Máquina 201
GROUP BY 
    c.ID, 
    c.Renglon, 
    u.saccod1, 
    u.alto, 
    u.ventana
ORDER BY FechaInicio;
