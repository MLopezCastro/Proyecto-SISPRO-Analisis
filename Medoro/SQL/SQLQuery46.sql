SELECT 
    c.ID,
    c.Renglon AS Maquina,
    u.saccod1,
    u.alto,
    u.ventana,
    MIN(c.Inicio) AS FechaInicio,
    MAX(c.Fin) AS FechaFin,
    COUNT(c.ID) AS TotalOrdenes
FROM ConCuboFiltrada2024 c
LEFT JOIN TablaVinculadaUNION u
    ON c.ID = u.OP -- Ajustar la clave según la relación entre las tablas
WHERE c.Renglon = 201 -- Máquina 201
GROUP BY c.ID, c.Renglon, u.saccod1, u.alto, u.ventana
ORDER BY FechaInicio;
