-- Crear la tabla filtrada
SELECT *
INTO ConCuboFiltrada2024
FROM ConCubo
WHERE 
    TRY_CAST(Renglon AS INT) IS NOT NULL -- Excluir valores no numéricos en Renglon
    AND AnoInicio >= 2024; -- Filtrar por registros a partir de 2024

SELECT DISTINCT Renglon
FROM ConCuboFiltrada2024;

SELECT TOP 10 *
FROM ConCuboFiltrada2024;

SELECT *
FROM ConCuboFiltrada2024
WHERE Renglon = 201;


