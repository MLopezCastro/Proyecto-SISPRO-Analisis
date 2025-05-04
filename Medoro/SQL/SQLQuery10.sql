SELECT 
    tvu.saccod1,
    COUNT(DISTINCT cc.ID) AS TotalOrdenes,
    MIN(cc.ID) AS PrimeraOrden,
    MAX(cc.ID) AS UltimaOrden,
    SUM(cc.CantidadHoras) AS TotalHorasReales
FROM ConCubo cc
LEFT JOIN TablaVinculadaUnion tvu ON cc.ID = tvu.OP
WHERE cc.Renglon = 201 -- Máquina 201
  AND tvu.saccod1 IS NOT NULL -- Solo configuraciones válidas
GROUP BY tvu.saccod1
HAVING COUNT(DISTINCT cc.ID) > 1 -- Configuraciones compartidas
ORDER BY tvu.saccod1;

SELECT DISTINCT saccod1
FROM TablaVinculadaUnion
WHERE ISNUMERIC(saccod1) = 0;
