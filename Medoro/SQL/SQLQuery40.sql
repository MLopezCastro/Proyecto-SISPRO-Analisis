SELECT 
    C.Solapa,
    C.Renglon,
    C.CantidadHoras AS HorasRealPrep,
    A.CantidadHorasProgPrep AS HorasProgPrep,
    A.CantidadHorasProgProd AS HorasProgProd,
    C.ID,
    A.Descripcion
FROM 
    ConCuboFiltrada2024 C
LEFT JOIN 
    ConArbol A
ON 
    C.ID = A.ID
WHERE 
    C.Renglon = 201 -- Solo para la máquina 201
    AND A.ID IS NOT NULL;
