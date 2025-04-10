# Proyecto de Optimización de Tiempos de Producción - Análisis con SQL y Power BI

## 🔖 Contexto
La empresa cuenta con un sistema de registro de datos de producción (Sispro), pero las vistas actuales presentan varios problemas:

- Tiempos de preparación **duplicados** cuando una orden se repite.
- **Formatos de tiempo incorrectos** (valores como 41297.699... en lugar de fechas legibles).
- Falta de un **ID uniforme** (por ejemplo: FAM 26446, 14529, etc.).


## 📊 Objetivo
Desarrollar una solución que permita analizar correctamente los tiempos de preparación y producción sin duplicaciones, usando **SQL Server y Power BI**, y sin necesidad de modificar la base original.


## ✅ Lo que hicimos hoy

### 1. Creamos vistas limpias desde la vista original `ConCubo`

#### Vista: `vista_ConCubo_2025`
- Filtramos por:
  - Año 2025
  - `Renglon = 201` (primera máquina a analizar)
- Convertimos:
  - `Inicio` y `Fin` a formato `DATETIME`
  - `ID` a `ID_Limpio` (solo la parte numérica)

```sql
CAST(Inicio AS DATETIME) AS Inicio_Legible,
CAST(Fin AS DATETIME) AS Fin_Legible,
TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio
```

---

### 2. Creamos vista `vista_PreparacionesUnicas_2025`

- Selecciona solo **la primera fila de "Preparación"** por orden y máquina usando `ROW_NUMBER()`:

```sql
ROW_NUMBER() OVER (PARTITION BY ID_Limpio, Renglon ORDER BY Inicio_Legible) AS nro_vez
```

- Filtramos luego por `nro_vez = 1`

---

### 3. Creamos `vista_ProduccionPorOrden_2025`

- Agrupa el tiempo total de producción por `ID_Limpio` y `Renglon`:

```sql
SUM(CantidadHoras) AS Horas_Produccion
```

---

### 4. Creamos vista final: `vista_Tiempos_Produccion_Preparacion_2025`

Une las dos vistas anteriores:

```sql
SELECT
    pu.ID_Limpio,
    pu.Renglon,
    pu.CantidadHoras AS Horas_Preparacion,
    pr.Horas_Produccion
FROM vista_PreparacionesUnicas_2025 pu
JOIN vista_ProduccionPorOrden_2025 pr
  ON pu.ID_Limpio = pr.ID_Limpio AND pu.Renglon = pr.Renglon
```

Esta vista **resuelve el problema de la duplicación de preparaciones**. Solo se cuenta una vez.


---

## 📈 Power BI

- Conectamos a la base de datos `Sispro_Restaurada_ML`
- Cargamos la vista `vista_Tiempos_Produccion_Preparacion_2025`

### Visualizaciones
1. **Gráfico de barras comparando preparación vs producción por orden**
2. **Slicer por ID_Limpio**
3. Opcional: KPI con porcentaje de tiempo destinado a preparación (medida DAX)

```DAX
PorcentajePreparacion =
DIVIDE(SUM([Horas_Preparacion]), SUM([Horas_Produccion]))
```

# Proyecto de Optimización de Tiempos de Producción - Análisis con SQL y Power BI

## 🔖 Contexto
La empresa cuenta con un sistema de registro de datos de producción (Sispro), pero las vistas actuales presentan varios problemas:

- Tiempos de preparación **duplicados** cuando una orden se repite.
- **Formatos de tiempo incorrectos** (valores como 41297.699... en lugar de fechas legibles).
- Falta de un **ID uniforme** (por ejemplo: FAM 26446, 14529, etc.).


## 📊 Objetivo
Desarrollar una solución que permita analizar correctamente los tiempos de preparación y producción sin duplicaciones, usando **SQL Server y Power BI**, y sin necesidad de modificar la base original.


## ✅ Lo que hicimos hoy

### 1. Creamos vistas limpias desde la vista original `ConCubo`

#### Vista: `vista_ConCubo_2025`
- Filtramos por:
  - Año 2025
  - `Renglon = 201` (primera máquina a analizar)
- Convertimos:
  - `Inicio` y `Fin` a formato `DATETIME`
  - `ID` a `ID_Limpio` (solo la parte numérica)

```sql
CAST(Inicio AS DATETIME) AS Inicio_Legible,
CAST(Fin AS DATETIME) AS Fin_Legible,
TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio
```

---

### 2. Creamos vista `vista_PreparacionesUnicas_2025`

- Selecciona solo **la primera fila de "Preparación"** por orden y máquina usando `ROW_NUMBER()`:

```sql
ROW_NUMBER() OVER (PARTITION BY ID_Limpio, Renglon ORDER BY Inicio_Legible) AS nro_vez
```

- Filtramos luego por `nro_vez = 1`

---

### 3. Creamos `vista_ProduccionPorOrden_2025`

- Agrupa el tiempo total de producción por `ID_Limpio` y `Renglon`:

```sql
SUM(CantidadHoras) AS Horas_Produccion
```

---

### 4. Creamos vista final: `vista_Tiempos_Produccion_Preparacion_2025`

Une las dos vistas anteriores:

```sql
SELECT 
    pu.ID_Limpio,
    pu.Renglon,
    pu.CantidadHoras AS Horas_Preparacion,
    pr.Horas_Produccion
FROM vista_PreparacionesUnicas_2025 pu
JOIN vista_ProduccionPorOrden_2025 pr
  ON pu.ID_Limpio = pr.ID_Limpio AND pu.Renglon = pr.Renglon
```

Esta vista **resuelve el problema de la duplicación de preparaciones**. Solo se cuenta una vez.


---

## 📈 Power BI

- Conectamos a la base de datos `Sispro_Restaurada_ML`
- Cargamos la vista `vista_Tiempos_Produccion_Preparacion_2025`

### Visualizaciones
1. **Gráfico de barras comparando preparación vs producción por orden**
2. **Slicer por ID_Limpio**
3. Opcional: KPI con porcentaje de tiempo destinado a preparación (medida DAX)

```DAX
PorcentajePreparacion = 
DIVIDE(SUM([Horas_Preparacion]), SUM([Horas_Produccion]))
```


---

## 📄 Informe para la fábrica

> "Con este análisis logramos eliminar la duplicación de tiempos de preparación cuando una orden se repite. Esto permite conocer el tiempo real invertido en preparación vs producción, algo que antes no se podía calcular. No hizo falta modificar las tablas originales ni invertir en desarrollos costosos. La información está lista para ser utilizada en Power BI y tomar decisiones reales."


---

## 🧾 Apéndice: Códigos completos de vistas SQL

### 🔹 1. `vista_ConCubo_2025`
```sql
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
```

### 🔹 2. `vista_PreparacionesUnicas_2025`
```sql
CREATE VIEW vista_PreparacionesUnicas_2025 AS
WITH PreparacionesUnicas AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ID_Limpio, Renglon
               ORDER BY Inicio_Legible
           ) AS nro_vez
    FROM vista_ConCubo_2025
    WHERE Estado = 'Preparación'
)
SELECT *
FROM PreparacionesUnicas
WHERE nro_vez = 1;
```

### 🔹 3. `vista_ProduccionPorOrden_2025`
```sql
CREATE VIEW vista_ProduccionPorOrden_2025 AS
SELECT 
    ID_Limpio,
    Renglon,
    SUM(CantidadHoras) AS Horas_Produccion
FROM vista_ConCubo_2025
WHERE Estado = 'Producción'
GROUP BY ID_Limpio, Renglon;
```

### 🔹 4. `vista_Tiempos_Produccion_Preparacion_2025`
```sql
CREATE VIEW vista_Tiempos_Produccion_Preparacion_2025 AS
SELECT 
    pu.ID_Limpio,
    pu.Renglon,
    pu.CantidadHoras AS Horas_Preparacion,
    pr.Horas_Produccion
FROM vista_PreparacionesUnicas_2025 pu
JOIN vista_ProduccionPorOrden_2025 pr
  ON pu.ID_Limpio = pr.ID_Limpio AND pu.Renglon = pr.Renglon;
```

---

📌 **Con estas vistas, se logra eliminar la duplicación de tiempos, comparar contra producción real y preparar el terreno para medir eficiencia y desempeño.**


---



---

## 🌟 Próximos pasos (para la semana que viene)
- Analizar los tiempos **programados** (desde `ConArbol`) y compararlos con los reales.
- Agregar análisis cruzado con `VinculadaUnion` (dimensiones, códigos, productos).
- Medir **eficiencia, desfasajes y razones de demoras**.

--------------

# Informe sobre diferencia entre Inicio y DiaInicio para la OT 14292

Estuve revisando a fondo el tema que me señalaste sobre la OT **14292**, que en la vista `vista_PreparacionesUnicas_2025` figura con `Inicio_Legible = 2025-01-12`, y quiero contarte con mucho detalle lo que encontré.

---

## 🔍 Análisis que realicé

Me enfoqué en comparar lo que dice la vista con lo que está registrado en la base `ConCubo`, que es de donde viene el dato. La vista en sí no inventa valores, solo toma los datos que ya existen y los convierte para que sean legibles.

En este caso, lo que hice fue comparar dos campos de la tabla original:

- `Inicio` (que es un valor numérico FLOAT, tipo Excel)
- `DiaInicio` (que viene como texto o string en formato tipo `2025/1/10`)

Lo que observé es que hay **una diferencia entre ambos campos para la misma OT**.

---

## 📊 Qué muestra la vista

```sql
SELECT *
FROM vista_PreparacionesUnicas_2025
WHERE ID_Limpio = 14292 AND Renglon = 201
```

| ID    | Renglon | Estado      | Inicio_Legible           |
|-------|---------|-------------|---------------------------|
| 14292 | 201     | Preparación | 2025-01-12 02:00:34.997   |

La vista muestra **el 12 de enero de 2025** a las 2:00 am, y eso lo hace a partir de este cálculo:

```sql
TRY_CAST(Inicio AS DATETIME)
```

---

## 🛠 Qué muestra `ConCubo`

Consulté directamente los datos de `ConCubo`:

```sql
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
```

Y el resultado fue:

| ID    | Estado      | InicioFloat     | InicioFecha             | DiaInicio   |
|-------|-------------|------------------|--------------------------|-------------|
| 14292 | Preparación | 45667.0837384259 | 2025-01-12 02:00:34.997 | 2025/1/10   |

🔍 Como ves, el campo `Inicio` indica claramente que el evento fue el **12 de enero de 2025**, y eso es lo que la vista refleja correctamente.

El campo `DiaInicio`, sin embargo, muestra **10 de enero de 2025**, lo cual **no coincide con la fecha real**.

---

## 🧠 Posibles causas del error en `DiaInicio`

Estas son algunas hipótesis razonables:

1. **Carga manual errónea** del campo `DiaInicio`, sin sincronizar con `Inicio`
2. **Algoritmo defectuoso** que calcula `DiaInicio` con base en otro campo (por ejemplo, `Fin` o `Fecha de sistema`)
3. **Registro automático mal generado**, por ejemplo al descartar una orden o anular una preparación
4. **Problemas de reloj del sistema o desfase horario**

Además, me llamó la atención que el turno es "Noche" y el motivo figura como **087 DESCARTONADO**, lo que refuerza la posibilidad de que se trate de una corrección, o una operación no planificada cargada fuera de horario normal (domingo a las 2 am).

---

## ✅ Conclusión clara

- La vista está bien construida y **muestra exactamente lo que está en el campo `Inicio`**
- El campo `Inicio` tiene el valor FLOAT **45667.0837384259**, que representa **2025-01-12 02:00:34.997** ✅
- El campo `DiaInicio` tiene un valor incorrecto: **2025/1/10** ❌

Esto genera confusión porque uno esperaría que ambos campos coincidan, pero no es así.

---

## 📎 Recomendación técnica

Te recomiendo revisar cómo se genera el campo `DiaInicio` en la carga del sistema, ya que **no refleja correctamente el valor real del campo `Inicio`**.

Para reportes confiables y trazabilidad de eventos, sugiero usar:

```sql
TRY_CAST(Inicio AS DATETIME)
```
como fuente oficial de fecha y hora real.

---

## 📘 README – Registro técnico y código de auditoría

### 🔍 Auditoría de diferencias entre Inicio y DiaInicio

Durante el análisis de la vista `vista_PreparacionesUnicas_2025` se detectó una diferencia significativa entre los valores reales de `Inicio` (convertidos a datetime) y los valores registrados en `DiaInicio` para algunas OT, en particular la **14292**.

#### 🧪 Ejemplo real:

```sql
-- Desde ConCubo
SELECT ID, Estado, TRY_CAST(Inicio AS DATETIME) AS FechaReal, DiaInicio
FROM ConCubo
WHERE ID = '14292' AND Estado = 'Preparación' AND Renglon = '201'
```

**Resultado:**
- Fecha real (`Inicio` convertido): `2025-01-12 02:00:34.997`
- `DiaInicio` registrado: `2025/1/10` ❌

#### 📌 Confirmación en la vista:
```sql
SELECT *
FROM vista_PreparacionesUnicas_2025
WHERE ID_Limpio = 14292 AND Renglon = 201
```

**Devuelve:**
`Inicio_Legible = 2025-01-12 02:00:34.997` ✅

#### 🧭 Recomendación:

Basar los análisis de tiempo en el campo `Inicio` casteado a `DATETIME`, y no en `DiaInicio`, salvo que se valide su integridad.

```sql
-- Cálculo correcto
SELECT ID, TRY_CAST(Inicio AS DATETIME) AS FechaReal
FROM ConCubo
WHERE TRY_CAST(Inicio AS DATETIME) BETWEEN '2025-01-12' AND '2025-01-13'
```

---

✅ Documento actualizado – Abril 2025

# Informe sobre diferencia entre Inicio y DiaInicio para la OT 14292

## 🧾 Explicación detallada para José (primera persona)

Hola José,

Estuve revisando a fondo el tema que me señalaste sobre la OT **14292**, que en la vista `vista_PreparacionesUnicas_2025` figura con `Inicio_Legible = 2025-01-12`, y quiero contarte con mucho detalle lo que encontré.

---

## 🔍 Análisis que realicé

Me enfoqué en comparar lo que dice la vista con lo que está registrado en la base `ConCubo`, que es de donde viene el dato. La vista en sí no inventa valores, solo toma los datos que ya existen y los convierte para que sean legibles.

En este caso, lo que hice fue comparar dos campos de la tabla original:

- `Inicio` (que es un valor numérico FLOAT, tipo Excel)
- `DiaInicio` (que viene como texto o string en formato tipo `2025/1/10`)

Lo que observé es que hay **una diferencia entre ambos campos para la misma OT**.

---

## 📊 Qué muestra la vista

```sql
SELECT *
FROM vista_PreparacionesUnicas_2025
WHERE ID_Limpio = 14292 AND Renglon = 201
```

| ID    | Renglon | Estado      | Inicio_Legible           |
|-------|---------|-------------|---------------------------|
| 14292 | 201     | Preparación | 2025-01-12 02:00:34.997   |

La vista muestra **el 12 de enero de 2025** a las 2:00 am, y eso lo hace a partir de este cálculo:

```sql
TRY_CAST(Inicio AS DATETIME)
```

---

## 🛠 Qué muestra `ConCubo`

Consulté directamente los datos de `ConCubo`:

```sql
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
```

Y el resultado fue:

| ID    | Estado      | InicioFloat     | InicioFecha             | DiaInicio   |
|-------|-------------|------------------|--------------------------|-------------|
| 14292 | Preparación | 45667.0837384259 | 2025-01-12 02:00:34.997 | 2025/1/10   |

🔍 Como ves, el campo `Inicio` indica claramente que el evento fue el **12 de enero de 2025**, y eso es lo que la vista refleja correctamente.

El campo `DiaInicio`, sin embargo, muestra **10 de enero de 2025**, lo cual **no coincide con la fecha real**.

---

## 🧠 Posibles causas del error en `DiaInicio`

Estas son algunas hipótesis razonables:

1. **Carga manual errónea** del campo `DiaInicio`, sin sincronizar con `Inicio`
2. **Algoritmo defectuoso** que calcula `DiaInicio` con base en otro campo (por ejemplo, `Fin` o `Fecha de sistema`)
3. **Registro automático mal generado**, por ejemplo al descartar una orden o anular una preparación
4. **Problemas de reloj del sistema o desfase horario**

Además, me llamó la atención que el turno es "Noche" y el motivo figura como **087 DESCARTONADO**, lo que refuerza la posibilidad de que se trate de una corrección, o una operación no planificada cargada fuera de horario normal (domingo a las 2 am).

---

## ✅ Conclusión clara

- La vista está bien construida y **muestra exactamente lo que está en el campo `Inicio`**
- El campo `Inicio` tiene el valor FLOAT **45667.0837384259**, que representa **2025-01-12 02:00:34.997** ✅
- El campo `DiaInicio` tiene un valor incorrecto: **2025/1/10** ❌

Esto genera confusión porque uno esperaría que ambos campos coincidan, pero no es así.

---

## 📎 Recomendación técnica

Te recomiendo revisar cómo se genera el campo `DiaInicio` en la carga del sistema, ya que **no refleja correctamente el valor real del campo `Inicio`**.

Para reportes confiables y trazabilidad de eventos, sugiero usar:

```sql
TRY_CAST(Inicio AS DATETIME)
```
como fuente oficial de fecha y hora real.

Estoy disponible si necesitás hacer una revisión más amplia sobre estos casos. ¡Gracias por tu observación que me ayudó a detectar este detalle!

Abrazo,

**Marcelo Fabián López**  
Auditoría de datos – Proyecto Medoro

---

## 📘 README – Registro técnico y código de auditoría

### 🔍 Auditoría de diferencias entre Inicio y DiaInicio

Durante el análisis de la vista `vista_PreparacionesUnicas_2025` se detectó una diferencia significativa entre los valores reales de `Inicio` (convertidos a datetime) y los valores registrados en `DiaInicio` para algunas OT, en particular la **14292**.

#### 🧪 Ejemplo real:

```sql
-- Desde ConCubo
SELECT ID, Estado, TRY_CAST(Inicio AS DATETIME) AS FechaReal, DiaInicio
FROM ConCubo
WHERE ID = '14292' AND Estado = 'Preparación' AND Renglon = '201'
```

**Resultado:**
- Fecha real (`Inicio` convertido): `2025-01-12 02:00:34.997`
- `DiaInicio` registrado: `2025/1/10` ❌

#### 📌 Confirmación en la vista:
```sql
SELECT *
FROM vista_PreparacionesUnicas_2025
WHERE ID_Limpio = 14292 AND Renglon = 201
```

**Devuelve:**
`Inicio_Legible = 2025-01-12 02:00:34.997` ✅

#### 🧭 Recomendación:

Basar los análisis de tiempo en el campo `Inicio` casteado a `DATETIME`, y no en `DiaInicio`, salvo que se valide su integridad.

```sql
-- Cálculo correcto
SELECT ID, TRY_CAST(Inicio AS DATETIME) AS FechaReal
FROM ConCubo
WHERE TRY_CAST(Inicio AS DATETIME) BETWEEN '2025-01-12' AND '2025-01-13'
```

---

✅ Documento actualizado – Abril 2025





