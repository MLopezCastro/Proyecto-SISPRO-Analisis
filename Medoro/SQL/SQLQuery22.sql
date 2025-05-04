SELECT *
FROM ConCubo
WHERE 
    TRY_CAST(Renglon AS INT) IS NOT NULL -- Excluye valores no num�ricos en Renglon
    AND Renglon = 201 -- Filtra por la m�quina 201
    AND TRY_CAST(Inicio AS FLOAT) IS NOT NULL -- Excluye valores no num�ricos en Inicio
    AND TRY_CAST(Fin AS FLOAT) IS NOT NULL -- Excluye valores no num�ricos en Fin
    AND DATEADD(DAY, TRY_CAST(Inicio AS FLOAT) - 2, '1900-01-01') >= '2024-01-01'; -- Filtra por fecha
