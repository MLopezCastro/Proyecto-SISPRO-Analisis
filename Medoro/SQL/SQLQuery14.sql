SELECT *, 
       DATEADD(SECOND, Inicio * 86400, '1900-01-01') AS InicioConvertido,
       DATEADD(SECOND, Fin * 86400, '1900-01-01') AS FinConvertido
FROM ConCubo
WHERE DATEADD(SECOND, Inicio * 86400, '1900-01-01') >= '2024-01-01';


SELECT *
FROM ConCubo
WHERE Inicio > 3652059 -- Este valor corresponde a aproximadamente el año 9999 en el formato de días desde 1900
   OR Fin > 3652059
   OR Inicio < 0       -- Asegurarnos de que no haya valores negativos
   OR Fin < 0;


SELECT *, 
       DATEADD(SECOND, Inicio * 86400, '1900-01-01') AS InicioConvertido,
       DATEADD(SECOND, Fin * 86400, '1900-01-01') AS FinConvertido
FROM ConCubo
WHERE Inicio BETWEEN 0 AND 3652059
  AND Fin BETWEEN 0 AND 3652059
  AND DATEADD(SECOND, Inicio * 86400, '1900-01-01') >= '2024-01-01';


SELECT *, 
       CASE 
           WHEN Inicio BETWEEN 0 AND 3652059 THEN DATEADD(SECOND, Inicio * 86400, '1900-01-01')
           ELSE NULL
       END AS InicioConvertido,
       CASE 
           WHEN Fin BETWEEN 0 AND 3652059 THEN DATEADD(SECOND, Fin * 86400, '1900-01-01')
           ELSE NULL
       END AS FinConvertido
FROM ConCubo
WHERE (Inicio BETWEEN 0 AND 3652059 AND Fin BETWEEN 0 AND 3652059)
  AND (DATEADD(SECOND, Inicio * 86400, '1900-01-01') >= '2024-01-01' 
       OR DATEADD(SECOND, Fin * 86400, '1900-01-01') >= '2024-01-01');


SELECT TOP 50 Inicio, Fin
FROM ConCubo
ORDER BY Inicio DESC;  -- Ver los valores más altos

