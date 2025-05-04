SELECT 
    cc.ID,
    cc.Renglon,
    cc.Estado,
    ca.CantidadHorasProgPrep AS HorasProgPrep,
    ca.CantidadHorasProgProd AS HorasProgProd,
    SUM(cc.CantidadHoras) AS HorasRealPrep,
    tvu.saccod1,
    tvu.OP
FROM ConCubo cc
LEFT JOIN ConArbol ca ON cc.ID = ca.ID
LEFT JOIN TablaVinculadaUnion tvu ON cc.ID = tvu.OP
WHERE cc.Estado = 'Preparación'AND Renglon = '201' -- Focalizar solo en preparación 
GROUP BY cc.ID, cc.Renglon, cc.Estado, ca.CantidadHorasProgPrep, ca.CantidadHorasProgProd, tvu.saccod1, tvu.OP
ORDER BY cc.ID;
