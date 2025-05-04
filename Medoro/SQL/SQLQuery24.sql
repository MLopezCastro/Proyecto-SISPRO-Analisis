-- Paso 1: Crear la tabla temporal o permanente con los datos filtrados
SELECT *
INTO ConCubo2024Mas -- Nombre sugerido para claridad
FROM ConCubo
WHERE 
    ISNUMERIC(Inicio) = 1 -- Nos aseguramos de que Inicio sea numérico
    AND ISNUMERIC(Fin) = 1 -- Nos aseguramos de que Fin sea numérico
    AND ID NOT LIKE '%Rotatek%' -- Excluimos registros problemáticos
    AND CAST(Inicio AS FLOAT) >= 45624; -- Filtrar datos desde 2024 en adelante (fechas en formato FLOAT)

-- Paso 2: Verificar los datos en la nueva tabla
SELECT TOP 10 *
FROM ConCubo2024Mas
ORDER BY CAST(Inicio AS FLOAT); -- Ordenar para verificar los resultados

-- Paso 3: Usar la tabla para análisis
SELECT 
    ID,
    Renglon AS Maquina,
    Estado,
    CONVERT(DATETIME, DATEADD(DAY, CAST(Inicio AS FLOAT) - 2, '1900-01-01')) AS InicioConvertido,
    CONVERT(DATETIME, DATEADD(DAY, CAST(Fin AS FLOAT) - 2, '1900-01-01')) AS FinConvertido,
    CantidadHoras AS HorasReportadas
FROM ConCubo2024Mas
WHERE Renglon = 201 -- Focalizar en la máquina 201
ORDER BY InicioConvertido;
