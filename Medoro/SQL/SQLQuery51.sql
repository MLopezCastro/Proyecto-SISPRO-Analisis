SELECT *
FROM ConCuboFiltrada2024 c
WHERE c.Renglon = 201
AND c.ID IN (13647, 13855) -- IDs con discrepancias en el ejemplo
ORDER BY c.Inicio;
