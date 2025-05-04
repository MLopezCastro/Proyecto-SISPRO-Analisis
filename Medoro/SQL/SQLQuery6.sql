SELECT *
FROM ConCubo
WHERE Renglon = '201' AND Estado = 'Preparación' AND ID IS NOT NULL;

SELECT 
    ID, 
    Renglon, 
    MIN(InicioConvertido) AS InicioReal,
    MAX(FinConvertido) AS FinReal,
    SUM(CantidadHoras) AS TotalHorasPreparacion
FROM (
    SELECT 
        ID, 
        Renglon, 
        Estado, 
        DATEADD(SECOND, (Inicio - FLOOR(Inicio)) * 86400, DATEADD(DAY, FLOOR(Inicio), '1900-01-01')) AS InicioConvertido,
        DATEADD(SECOND, (Fin - FLOOR(Fin)) * 86400, DATEADD(DAY, FLOOR(Fin), '1900-01-01')) AS FinConvertido,
        CantidadHoras
    FROM ConCubo
    WHERE Renglon = '201' AND Estado = 'Preparación' AND ID IS NOT NULL
) AS SubConsulta
GROUP BY ID, Renglon
ORDER BY InicioReal;
