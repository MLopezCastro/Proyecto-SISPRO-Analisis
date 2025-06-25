SELECT TOP 10 * FROM vista_Tiempos_Produccion_Preparacion_Medoro5_2025



CREATE OR ALTER VIEW vista_MedoroResumen5_Final_2025 AS
WITH DatosFiltrados AS (
    SELECT *
    FROM vista_Tiempos_Produccion_Preparacion_Medoro5_2025
    WHERE AnioInicio = 2025 AND Renglon = 201
),
Enumerados AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY ID_Limpio ORDER BY Inicio_Corregido) AS nro_vez
    FROM DatosFiltrados
),
Etiquetados AS (
    SELECT *,
        CASE 
            WHEN Tipo = 'Preparación' THEN HorasPreparacionAjustada
            ELSE 0
        END AS HorasPreparacion_Valida_Total,
        CASE 
            WHEN Tipo = 'Producción' THEN HorasProduccionVisible
            ELSE 0
        END AS HorasProduccion_Total,
        CASE 
            WHEN Tipo = 'Preparación' THEN 1
            ELSE 0
        END AS FlagPreparacion
    FROM Enumerados
)
SELECT
    ID,
    ID_Limpio,
    Renglon,
    Tipo,
    Inicio_Corregido AS Inicio,
    Fin_Original AS Fin,
    FORMAT(Inicio_Corregido, 'yyyy-MM-dd HH:mm:ss') AS Inicio_Corregido_Texto,
    nro_vez,
    HorasPreparacion_Valida_Total,
    HorasProduccion_Total,
    FlagPreparacion,
    AnioInicio,
    [MesInicio]
FROM Etiquetados;


---
SELECT *
FROM vista_Tiempos_Produccion_Preparacion_Medoro5_2025
WHERE (HorasPreparacionAjustada < 0.10 AND HorasPreparacionAjustada > 0)
   OR (HorasProduccionVisible < 0.10 AND HorasProduccionVisible > 0)
ORDER BY ID_Limpio, Inicio_Corregido;
