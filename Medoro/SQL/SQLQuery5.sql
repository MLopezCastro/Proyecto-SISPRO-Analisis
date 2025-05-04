SELECT 
    ID, 
    Renglon, 
    Estado, 
    DATEADD(SECOND, (Inicio - FLOOR(Inicio)) * 86400, DATEADD(DAY, FLOOR(Inicio), '1900-01-01')) AS InicioConvertido,
    DATEADD(SECOND, (Fin - FLOOR(Fin)) * 86400, DATEADD(DAY, FLOOR(Fin), '1900-01-01')) AS FinConvertido,
    CantidadHoras
FROM ConCubo
WHERE Renglon = '201' AND Estado = 'Preparación'
ORDER BY Inicio;
