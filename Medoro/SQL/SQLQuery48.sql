SELECT 
    c.ID,
    c.Maquina,
    c.saccod1,
    c.alto,
    c.ventana,
    MIN(c.FechaInicio) AS FechaInicio,
    MAX(c.FechaFin) AS FechaFin,
    COUNT(c.ID) AS TotalOrdenes,
    SUM(a.CantidadHorasProgPrep) AS TotalHorasProgPrep,
    SUM(a.CantidadHorasProgProd) AS TotalHorasProgProd,
    DATEDIFF(SECOND, MIN(c.FechaInicio), MAX(c.FechaFin)) / 3600.0 AS HorasReales, -- Tiempos reales en horas
    DATEDIFF(SECOND, MIN(c.FechaInicio), MAX(c.FechaFin)) / 3600.0 - 
        SUM(a.CantidadHorasProgPrep + a.CantidadHorasProgProd) AS DiferenciaTotalHoras -- Diferencia total
FROM 
    (SELECT 
         ID, 
         Renglon AS Maquina, 
         saccod1, 
         alto, 
         ventana, 
         MIN(Inicio) AS FechaInicio, 
         MAX(Fin) AS FechaFin
     FROM ConCuboFiltrada2024
     WHERE Renglon = 201 -- Máquina 201
     GROUP BY ID, Renglon, saccod1, alto, ventana
    ) c
LEFT JOIN ConArbol a
    ON c.ID = a.ID -- Ajustar si la relación entre las tablas requiere más columnas
GROUP BY 
    c.ID, 
    c.Maquina, 
    c.saccod1, 
    c.alto, 
    c.ventana
ORDER BY FechaInicio;
