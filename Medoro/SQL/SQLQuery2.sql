SELECT * FROM TablaVinculadaUNION

SELECT * FROM ConCubo

SELECT Renglon, DiaInicio, ID, CantidadHoras, Estado, Inicio, Fin
FROM ConCubo;

SELECT * FROM ConArbol

SELECT Estado, CantidadHoras, Inicio, Fin, DiaInicio, ID, Renglon
FROM ConCubo
WHERE ID = 'FAM 20373'
ORDER BY DiaInicio, Inicio;


-- Mostrar las columnas de la tabla ConCubo
EXEC sp_columns 'ConCubo';

-- Mostrar las columnas de la tabla ConArbol
EXEC sp_columns 'ConArbol';

-- Mostrar las columnas de la tabla TablaVinculadaUNION
EXEC sp_columns 'TablaVinculadaUNION';

