SELECT TOP 10 Inicio, Fin
FROM ConCubo
WHERE Inicio > 50000 OR Fin > 50000
ORDER BY Inicio DESC;


SELECT COUNT(*) AS TotalNulos
FROM ConCubo
WHERE Inicio IS NULL OR Fin IS NULL;

SELECT TOP 10 Inicio, Fin
FROM ConCubo
WHERE Inicio IS NOT NULL AND Fin IS NOT NULL;

SELECT 
    MIN(Inicio) AS MinInicio,
    MAX(Inicio) AS MaxInicio,
    MIN(Fin) AS MinFin,
    MAX(Fin) AS MaxFin
FROM ConCubo;
