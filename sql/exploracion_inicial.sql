-- Verificar relación entre ConCubo y TablaVinculadaUNION
SELECT TOP 100 c.ID, v.OP, v.saccod1
FROM ConCubo c
INNER JOIN TablaVinculadaUNION v
ON c.ID = v.OP;

-- Buscar tablas con columnas relevantes
SELECT TABLE_NAME, COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN ('saccod1', 'OP');
