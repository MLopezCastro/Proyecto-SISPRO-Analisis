SELECT *
FROM ConCubo
WHERE CAST(SUBSTRING(ID, 5, LEN(ID)) AS INT) >= 13600; -- Extrae el n�mero de ID y lo filtra
