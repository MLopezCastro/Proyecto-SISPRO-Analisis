-- Vista base con columnas clave bien formateadas
--📌 Con esto ya podés ver los registros de la máquina 201 en el año 2025 con las fechas legibles y un ID_Limpio útil para análisis.
SELECT 
    ID,
    TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
    Renglon,
    Estado,
    CantidadHoras,
    CAST(Inicio AS DATETIME) AS Inicio_Legible,
    CAST(Fin AS DATETIME) AS Fin_Legible,
    AnoInicio,
    MesInicio
FROM ConCubo
WHERE 
    AnoInicio = 2025 AND
    Renglon = '201'


--Creo Vista ConCubo_2025
CREATE VIEW vista_ConCubo_2025 AS
SELECT 
    ID,
    TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
    Renglon,
    Estado,
    CantidadHoras,
    CAST(Inicio AS DATETIME) AS Inicio_Legible,
    CAST(Fin AS DATETIME) AS Fin_Legible,
    AnoInicio,
    MesInicio
FROM ConCubo
WHERE 
    AnoInicio = 2025 AND
    Renglon = '201';


--✅ Paso 2: Detectar la primera ocurrencia de “Preparación” por orden (ID_Limpio) y máquina (Renglon) con una CTE
--🎯 ¿Qué buscamos?
--Queremos que:
--Si una orden (ID_Limpio) aparece varias veces con estado 'Preparación' en la misma máquina (Renglon = 201), solo consideremos la primera vez.
--Esto evita contar más de una vez el tiempo de preparación para la misma orden, que es el núcleo del problema.
WITH PreparacionesUnicas AS (
    SELECT 
        ID,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        AnoInicio,
        MesInicio,
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon
            ORDER BY CAST(Inicio AS DATETIME)
        ) AS nro_vez
    FROM ConCubo
    WHERE Estado = 'Preparación'
      AND AnoInicio = 2025
      AND Renglon = '201'
)

SELECT *
FROM PreparacionesUnicas
WHERE nro_vez = 1;

--✅ ¿Qué hace esto?
--Agrupa por ID_Limpio y Renglon → es decir, una orden en una máquina.
--Ordena por Inicio para encontrar la primera aparición.
--Usa ROW_NUMBER() para asignar un número (1, 2, 3...) a cada preparación de esa orden.
--Filtra solo la nro_vez = 1, o sea, la primera vez que se ejecutó 'Preparación' para esa orden en esa máquina.

--⚠️ Importante: ¿La CTE se guarda?
--NO. Una CTE no se guarda en la base de datos como una tabla o una vista.
--Es temporal y solo vive durante esa consulta.
--📌 No podés hacer SELECT * FROM PreparacionesUnicas más adelante, porque desaparece una vez que termina la ejecución.

--Opción B — Convertirla en una vista si querés que esté guardada
--Si querés dejarla fija para usarla cuando quieras:

CREATE VIEW vista_PreparacionesUnicas_2025 AS
WITH PreparacionesUnicas AS (
    SELECT 
        ID,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        AnoInicio,
        MesInicio,
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon
            ORDER BY CAST(Inicio AS DATETIME)
        ) AS nro_vez
    FROM ConCubo
    WHERE Estado = 'Preparación'
      AND AnoInicio = 2025
      AND Renglon = '201'
)
SELECT *
FROM PreparacionesUnicas
WHERE nro_vez = 1;

--🔁 Ahora: ¿qué falta para cerrar el análisis completo?
--🔹 1. Producción (sin filtro)
--Queremos ver el tiempo total de producción por orden (ID_Limpio), que sí se puede sumar completo.
--🔹 2. Comparación Preparación vs Producción
--Por ejemplo:

--ID_Limpio	Tiempo Preparación	Tiempo Producción
--14594	0.27 h	1.6 h
--14595	0.5 h	2.2 h
--Esa tabla nos permite ver eficiencia, detectar órdenes con preparación muy alta, etc.

--🛠️ ¿Cómo lo hacemos?
--1️⃣ Crear una vista similar para producción:

CREATE VIEW vista_ProduccionPorOrden_2025 AS
SELECT 
    TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
    Renglon,
    SUM(CantidadHoras) AS Horas_Produccion
FROM ConCubo
WHERE Estado = 'Producción'
  AND AnoInicio = 2025
  AND Renglon = '201'
GROUP BY 
    TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT),
    Renglon;

--2️⃣ Luego, unir ambas vistas:
SELECT 
    pu.ID_Limpio,
    pu.Renglon,
    pu.CantidadHoras AS Horas_Preparacion,
    pr.Horas_Produccion
FROM vista_PreparacionesUnicas_2025 pu
JOIN vista_ProduccionPorOrden_2025 pr
  ON pu.ID_Limpio = pr.ID_Limpio AND pu.Renglon = pr.Renglon
ORDER BY pu.ID_Limpio;

--📌 Ahora sí:
--pu es el alias para vista_PreparacionesUnicas_2025
--pr es el alias para vista_ProduccionPorOrden_2025

--✅ ¿Qué significa esto que hicimos?
--Esta tabla que ves muestra, para cada orden de trabajo (ID_Limpio) en la máquina 201 en el año 2025:
--🟦 Cuántas horas reales de preparación tuvo → Horas_Preparacion
--🟩 Cuántas horas de producción total tuvo → Horas_Produccion

--📌 Esto resuelve el problema original:
--💥 Ya no estás contando la preparación duplicada cuando una misma orden se repite.
--✔ Ahora podés ver cuánto tiempo real pasó en cada etapa del proceso.

--✅ 1. CREAR la vista final con preparación y producción real
CREATE VIEW vista_Tiempos_Produccion_Preparacion_2025 AS
SELECT 
    pu.ID_Limpio,
    pu.Renglon,
    pu.CantidadHoras AS Horas_Preparacion,
    pr.Horas_Produccion
FROM vista_PreparacionesUnicas_2025 pu
JOIN vista_ProduccionPorOrden_2025 pr
  ON pu.ID_Limpio = pr.ID_Limpio AND pu.Renglon = pr.Renglon;

--Una vez creada, podés usarla en Power BI y en SQL como cualquier tabla:

SELECT * FROM vista_Tiempos_Produccion_Preparacion_2025;

SELECT * FROM vista_PreparacionesUnicas_2025;

SELECT * FROM vista_ConCubo_2025;

SELECT * FROM vista_ProduccionPorOrden_2025;



--Corregimos la vista:
CREATE OR ALTER VIEW vista_PreparacionesUnicas_2025 AS
SELECT 
    ID,
    TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
    Renglon,
    Estado,
    CantidadHoras,
    TRY_CAST(Inicio AS DATETIME) AS Inicio_Legible,
    TRY_CAST(Fin AS DATETIME) AS Fin_Legible,
    AnoInicio,
    MesInicio
FROM ConCubo
WHERE Estado = 'Preparación'
  AND AnoInicio = 2025
  AND TRY_CAST(Renglon AS INT) = 201
  AND TRY_CAST(Inicio AS DATETIME) IS NOT NULL


SELECT *
FROM vista_PreparacionesUnicas_2025
ORDER BY Inicio_Legible

SELECT 
    ID, Renglon, Estado,
    Inicio,
    TRY_CAST(Inicio AS DATETIME) AS FechaTraducida
FROM ConCubo
WHERE Estado = 'Preparación'
  AND ID = '14292'
  AND TRY_CAST(Renglon AS INT) = 201
ORDER BY TRY_CAST(Inicio AS DATETIME)

--✅ Consulta para ver toda la secuencia de la OT 14292 (renglón 201)
SELECT 
    ID,
    Estado,
    TRY_CAST(Inicio AS FLOAT) AS InicioFloat,
    TRY_CAST(Inicio AS DATETIME) AS InicioFecha,
    TRY_CAST(Fin AS DATETIME) AS FinFecha,
    DiaInicio,
    Renglon,
    Operario,
    motivo,
    Turno
FROM ConCubo
WHERE TRY_CAST(Renglon AS INT) = 201
  AND ID = '14292'
  AND Estado = 'Preparación'
  AND TRY_CAST(Inicio AS DATETIME) BETWEEN '2025-01-08' AND '2025-01-13'
ORDER BY TRY_CAST(Inicio AS DATETIME)

SELECT * FROM ConCubo

SELECT *
FROM vista_PreparacionesUnicas_2025
WHERE ID_Limpio = 14292 AND Renglon = 201



SELECT 
  ID, Estado, Renglon, 
  TRY_CAST(Inicio AS FLOAT) AS InicioFloat,
  TRY_CAST(Inicio AS DATETIME) AS InicioFecha,
  Fin AS FinFecha,
  DiaInicio,
  Operario, motivo, Turno
FROM ConCubo
WHERE ID = '14292'
  AND TRY_CAST(Renglon AS INT) = 201
  AND Estado = 'Preparación'
ORDER BY TRY_CAST(Inicio AS DATETIME)