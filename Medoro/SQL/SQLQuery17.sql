SELECT *,
       DATEADD(SECOND, Inicio * 86400, '1900-01-01') AS InicioConvertido,
       DATEADD(SECOND, Fin * 86400, '1900-01-01') AS FinConvertido
FROM ConCubo
WHERE DATEADD(SECOND, Inicio * 86400, '1900-01-01') >= '2024-01-01'
  AND DATEADD(SECOND, Fin * 86400, '1900-01-01') >= '2024-01-01';

SELECT TOP 10 Inicio, Fin
FROM ConCubo
ORDER BY Inicio DESC;

SELECT *,
       CASE 
           WHEN Inicio >= 0 AND Inicio < 50000 
           THEN DATEADD(SECOND, Inicio * 86400, '1900-01-01')
           ELSE NULL 
       END AS InicioConvertido,
       CASE 
           WHEN Fin >= 0 AND Fin < 50000 
           THEN DATEADD(SECOND, Fin * 86400, '1900-01-01')
           ELSE NULL 
       END AS FinConvertido
FROM ConCubo
WHERE Inicio IS NOT NULL AND Fin IS NOT NULL;


Msg 232, Level 16, State 3, Line 12
Arithmetic overflow error for type int, value = 3568120942.000003.

Completion time: 2025-02-06T15:13:18.5595872-03:00
