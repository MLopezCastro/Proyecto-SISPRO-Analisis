SELECT 
    tvu.saccod1,
    CASE 
        WHEN ISNUMERIC(tvu.saccod1) = 1 THEN 'Numérico'
        ELSE 'No Numérico'
    END AS TipoConfiguracion,
    COUNT(DISTINCT cc.ID) AS TotalOrdenes,
    MIN(cc.ID) AS PrimeraOrden,
    MAX(cc.ID) AS UltimaOrden,
    SUM(cc.CantidadHoras) AS TotalHorasReales
FROM ConCubo cc
LEFT JOIN TablaVinculadaUnion tvu 
    ON cc.ID = tvu.OP
WHERE cc.Renglon = 201 -- Máquina 201
  AND ISNUMERIC(tvu.saccod1) = 1 -- Filtrar SOLO valores numéricos
GROUP BY tvu.saccod1,
         CASE 
             WHEN ISNUMERIC(tvu.saccod1) = 1 THEN 'Numérico'
             ELSE 'No Numérico'
         END
ORDER BY tvu.saccod1;

SELECT DISTINCT tvu.saccod1
FROM TablaVinculadaUnion tvu
WHERE ISNUMERIC(tvu.saccod1) = 0;

SELECT DISTINCT cc.ID
FROM ConCubo cc
WHERE ISNUMERIC(cc.ID) = 0;
