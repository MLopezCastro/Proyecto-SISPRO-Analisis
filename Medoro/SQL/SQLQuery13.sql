SELECT *
FROM ConCubo
WHERE CAST(SUBSTRING(ID, 5, LEN(ID)) AS INT) >= 13600; -- Extrae el número de ID y lo filtra
