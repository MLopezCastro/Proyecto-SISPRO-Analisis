SELECT 
    c.ID,
    c.Renglon AS Maquina,
    u.saccod1,
    u.alto,
    u.ventana,
    MIN(c.Inicio) AS FechaInicio,
    MAX(c.Fin) AS FechaFin,
    COUNT(c.ID) AS TotalOrdenes,
    a.CantidadHorasProgPrep, -- Tiempo de preparación programado
    a.CantidadHorasProgProd -- Tiempo de producción programado
FROM ConCuboFiltrada2024 c
LEFT JOIN TablaVinculadaUNION u
    ON c.ID = u.OP -- Relación entre ConCuboFiltrada2024 y TablaVinculadaUNION
LEFT JOIN ConArbol a
    ON c.ID = a.ID -- Relación entre ConCuboFiltrada2024 y ConArbol por el campo ID
WHERE c.Renglon = 201 -- Máquina 201
GROUP BY 
    c.ID, 
    c.Renglon, 
    u.saccod1, 
    u.alto, 
    u.ventana, 
    a.CantidadHorasProgPrep, 
    a.CantidadHorasProgProd
ORDER BY FechaInicio;
