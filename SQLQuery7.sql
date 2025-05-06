CREATE OR ALTER VIEW vista_Tiempos_Produccion_Preparacion_Medoro5_2025 AS
SELECT
    ID,
    ID_Limpio,
    Renglon,
    Estado AS Tipo,
    -- Tiempos de preparaci�n solo cuando el estado sea Preparaci�n
    CASE 
        WHEN Estado = 'Preparaci�n' THEN 
            DATEDIFF(SECOND, Inicio_Legible, Fin_Legible) / 3600.0 
        ELSE NULL 
    END AS HorasPreparacionOriginal,
    
    -- HorasPreparacionAjustada: s�lo v�lida si no es duplicada
    CASE 
        WHEN Estado = 'Preparaci�n' AND 
             DATEDIFF(SECOND, Inicio_Legible, Fin_Legible) / 3600.0 > 0 THEN 
             DATEDIFF(SECOND, Inicio_Legible, Fin_Legible) / 3600.0
        ELSE 0
    END AS HorasPreparacionAjustada,
    
    -- Flag 1 si es preparaci�n v�lida, 0 en cualquier otro caso
    CASE 
        WHEN Estado = 'Preparaci�n' AND 
             DATEDIFF(SECOND, Inicio_Legible, Fin_Legible) / 3600.0 > 0 THEN 1
        ELSE 0
    END AS FlagPreparacionValida,

    -- Tiempos de producci�n (solo si el estado es Producci�n)
    CASE 
        WHEN Estado = 'Producci�n' THEN 
            DATEDIFF(SECOND, Inicio_Legible, Fin_Legible) / 3600.0 
        ELSE NULL 
    END AS HorasProduccionVisible,

    -- Fechas para comparaci�n
    Inicio_Legible AS Inicio_Original,
    Fin_Legible AS Fin_Original,

    -- Corregidas (-2 d�as)
    DATEADD(DAY, -2, Inicio_Legible) AS Inicio_Corregido,
    FORMAT(DATEADD(DAY, -2, Inicio_Legible), 'yyyy-MM-dd HH:mm:ss') AS Inicio_Texto,
    
    -- Ordenar en Power BI
    YEAR(Inicio_Legible) AS AnioInicio,
    FORMAT(Inicio_Legible, 'yyyy/MM') AS MesInicio

FROM vista_ConCubo_2025
WHERE Renglon = 201;
