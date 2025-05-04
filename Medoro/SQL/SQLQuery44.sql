SELECT 
    V.saccod1,
    V.alto,
    V.ventana,
    COUNT(DISTINCT C.ID) AS TotalOrdenes,
    MIN(C.Inicio) AS FechaInicio,
    MAX(C.Fin) AS FechaFin,
    MIN(C.CantidadHoras) AS MinHorasRealPrep, -- Tiempo real mínimo
    MAX(C.CantidadHoras) AS MaxHorasRealPrep  -- Tiempo real máximo
FROM 
    ConCuboFiltrada2024 C
LEFT JOIN 
    TablaVinculadaUnion V
ON 
    C.ID = V.OP
WHERE 
    C.Renglon = 201 -- Solo máquina 201
    AND C.AnoInicio >= 2024
GROUP BY 
    V.saccod1, V.alto, V.ventana
ORDER BY 
    FechaInicio;
