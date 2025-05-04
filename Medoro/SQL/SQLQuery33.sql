SELECT DISTINCT Renglon, LEN(Renglon), Renglon + ''
FROM ConCubo
WHERE Renglon LIKE '%Rotatek%';


SELECT *
FROM ConCubo
WHERE ISNUMERIC(Renglon) = 1;

SELECT *
FROM ConCubo
WHERE ISNUMERIC(Renglon) = 1
  AND CAST(Renglon AS INT) = 201
  AND Inicio >= CAST('2024-01-01' AS FLOAT);

