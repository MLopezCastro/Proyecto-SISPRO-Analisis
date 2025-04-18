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

---------------

¡Por supuesto! Acá tenés la explicación lista para pegar en tu `README.md`, escrita de forma clara y profesional:

---

### 🔎 Cómo encontrar vistas (`views`) en SQL Server Management Studio (SSMS)

En SQL Server, las vistas no aparecen en la misma sección que las tablas. Para acceder a ellas:

1. Abrir el **Object Explorer** (panel izquierdo en SSMS).
2. Navegar hasta la base de datos deseada (por ejemplo, `Sispro_Restaurada_ML`).
3. Expandir el nodo de la base de datos.
4. Expandir la carpeta **Views** para ver todas las vistas disponibles, como por ejemplo `dbo.vista_PreparacionesUnicas_2025`.

#### 🧠 Si no se recuerda el nombre exacto de la vista:
Ejecutar la siguiente consulta para listar todas las vistas:

```sql
SELECT name 
FROM sys.views
ORDER BY name;
```

O bien, buscar por palabra clave (por ejemplo, "preparaciones"):

```sql
SELECT name 
FROM sys.views
WHERE name LIKE '%preparaciones%';
```

#### 🔧 Sugerencia:
Hacer clic derecho sobre una vista y seleccionar:

```
Script View as → SELECT To → New Query Editor Window
```

Esto permite ver la definición SQL completa de la vista, ideal para revisar o modificar su lógica.

---

Perfecto, Marcelo. Acá tenés un resumen detallado de lo que hiciste en este proyecto hasta llegar al primer avance, incluyendo el uso de la CTE (`vista_PreparacionesUnicas_2025`) y cómo surgió:

---

## 🛠️ Contexto del Proyecto y Avance 1 – Preparación Única por Orden

### 🔧 Problema inicial:
En el sistema de la empresa (alimentado por los sistemas Sispro, Presea y Aramis), los datos de producción se registraban en vistas mal estructuradas con múltiples errores:

- Órdenes de trabajo (`ID`) con eventos **duplicados de preparación**, lo que hacía que el tiempo real de setup se contara más de una vez.
- Tiempos registrados en formato `float`, lo que dificultaba su interpretación (por ejemplo, `45667.0837384259`).
- Fechas mal calculadas, ya que la conversión desde `float` a `datetime` era incorrecta o inconsistente.
- No se podía diferenciar fácilmente **cuál era la primera preparación válida** para cada orden.

Esto impedía calcular KPIs confiables como el **porcentaje de tiempo de preparación vs. tiempo total productivo**.

---

### 🧠 Solución propuesta en el primer avance:
Se decidió crear una **vista específica** (`vista_PreparacionesUnicas_2025`) que aislara **solo la primera preparación real** de cada orden en una máquina específica (`Renglon = 201`).

Para eso:

1. **Se creó una CTE (Common Table Expression)** que ordenaba los eventos de preparación por fecha de inicio (`Inicio`) para cada combinación de `ID_Limpio` y `Renglon`.
2. Se aplicó `ROW_NUMBER()` para asignar una jerarquía y quedarnos **únicamente con el primer registro** de preparación por orden.

#### Ejemplo de la lógica (simplificada):

```sql
WITH PreparacionesOrdenadas AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ID_Limpio, Renglon ORDER BY Inicio ASC) AS Fila
    FROM ConCubo_Limpia
    WHERE Estado = 'Preparación' AND Renglon = 201
)
SELECT *
FROM PreparacionesOrdenadas
WHERE Fila = 1;
```

3. Finalmente, esta lógica se encapsuló en la vista **`vista_PreparacionesUnicas_2025`**, para poder reutilizarla desde Power BI sin duplicar cálculos.

---

### 🎯 Resultado del primer avance:

- Se logró obtener una tabla limpia con **una única fila de preparación por orden**, lista para análisis.
- Se conectó esta vista en Power BI para construir visualizaciones como:
  - % de tiempo de preparación por orden.
  - Gráfico de correlación entre horas de preparación y producción.
  - Indicadores tipo “semáforo” (verde/amarillo/rojo) por eficiencia.
- Se presentó el primer prototipo funcional a planta, validando que el modelo funcionaba correctamente **en la mayoría de los casos**.

---

¡Perfecto! Acá tenés el texto en estilo README, claro y técnico, para documentar la nueva vista `vista_PreparacionesAjustadas_2025`:

---

¡Genial, Marcelo! Acá tenés el **bloque actualizado** para tu README con la corrección que faltaba (agregar la columna `HorasPreparacionOriginal`), manteniendo el mismo estilo profesional y técnico:

---

### 🔹 `vista_PreparacionesAjustadas_2025`

Esta vista muestra todos los bloques reales de **preparación** registrados en el sistema durante el año 2025 para la máquina con `Renglon = 201`, pero evita que los **tiempos de preparación se sumen más de una vez por orden**.

---

#### 📌 Motivación

En los datos originales, una misma orden (`ID_Limpio`) puede ingresar múltiples veces a la máquina en diferentes momentos del día, generando **varios registros** con estado `Preparación`.  
Si se suman todos, los indicadores de eficiencia se **sobreestiman**.  
Esta vista soluciona ese problema permitiendo:

- Visualizar **todos los eventos reales**,  
- Pero considerar **solo la primera ocurrencia por orden** en el cálculo de horas efectivas de preparación.

---

#### 📐 Lógica aplicada

- Se parte de `vista_ConCubo_2025`, que contiene todos los registros de la máquina 201 durante 2025.
- Se crea una CTE con `ROW_NUMBER()` para enumerar las ocurrencias de preparación por `ID_Limpio` y `Renglon`.
- Se agregan dos columnas clave:
  - `HorasPreparacionOriginal`: mantiene el valor original de `CantidadHoras`.
  - `HorasPreparacionAjustada`: mantiene el valor **solo si** es la primera vez (`nro_vez = 1`), y devuelve `0` en los siguientes.

---

#### 🧾 Columnas principales

| Columna                  | Descripción                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `ID`                     | Identificador de orden original                                             |
| `ID_Limpio`              | Versión numérica del ID                                                     |
| `Renglon`                | Máquina analizada (201)                                                     |
| `Estado`                 | Siempre `"Preparación"`                                                     |
| `HorasPreparacionOriginal` | Valor original de `CantidadHoras` para cada bloque                        |
| `HorasPreparacionAjustada` | Valor corregido: solo se conserva en la primera ocurrencia                |
| `Inicio_Legible`         | Fecha y hora de inicio en formato legible                                   |
| `Fin_Legible`            | Fecha y hora de fin en formato legible                                      |
| `nro_vez`                | Número de ocurrencia de preparación para esa orden                          |

---

#### 🧠 Uso esperado

- En Power BI, **usar `HorasPreparacionAjustada`** para calcular KPIs (porcentaje de preparación, eficiencia, etc.).
- `HorasPreparacionOriginal` queda disponible para **análisis exploratorio**, por ejemplo, para auditar cuántas veces se repite una OT y en qué horarios.

---

¡Excelente, Marcelo! Acá tenés el bloque completo para **continuar y cerrar la sección del README**, con la parte de validación incluida —todo en el mismo estilo profesional que venís usando:

---

#### ✅ Validación y ejemplo real

Para verificar que esta vista resuelve correctamente el problema de la duplicación de tiempos de preparación, se realizó una auditoría comparando:

- `TotalOriginal`: suma de `HorasPreparacionOriginal` por orden.  
- `TotalAjustado`: suma de `HorasPreparacionAjustada` por orden.

El siguiente ejemplo muestra cómo las órdenes con múltiples eventos de preparación fueron correctamente ajustadas:

| `ID_Limpio` | `TotalOriginal` | `TotalAjustado` |
|-------------|------------------|------------------|
| 14292       | 1.1621           | 0.1959           |
| 14454       | 0.2564           | 0.1282           |
| 14470       | 1.3899           | 0.1985           |
| 14581       | 1.4617           | 0.2088           |
| 14586       | 0.4239           | 0.0716           |
| 14597       | 1.3430           | 0.2686           |
| 14609       | 1.7943           | 0.8971           |
| 14610       | 1.5219           | 0.3044           |
| 14613       | 0.6500           | 0.2167           |
| 14619       | 1.2898           | 0.4059           |
| 14620       | 0.5786           | 0.3659           |
| 14626       | 1.2741           | 0.5779           |
| 14631       | 0.1831           | 0.0677           |
| 14641       | 1.6242           | 0.3248           |
| 14654       | 0.2811           | 0.1406           |

Esto confirma que:

- Solo se conserva el tiempo de la primera preparación por orden.  
- El resto de las ocurrencias son conservadas en el análisis, pero no duplican los KPIs.

En cambio, para órdenes que solo tienen una preparación, los valores coinciden:

| `ID_Limpio` | `TotalOriginal` | `TotalAjustado` |
|-------------|------------------|------------------|
| 14594       | 0.2713           | 0.2713           |
| 14603       | 0.3991           | 0.3991           |
| 14617       | 0.3085           | 0.3085           |

---

✅ Esto demuestra que la vista `vista_PreparacionesAjustadas_2025` **corrige el problema sin perder datos reales**, y está lista para ser integrada en Power BI o futuros modelos.

---

Vamos a **agregar el campo `Inicio_Legible_Corregido`** directamente en la vista `vista_PreparacionesAjustadas_2025` para reflejar el ajuste de -2 días sin alterar la lógica existente.


## 🛠️ Código actualizado para la vista

```sql
CREATE OR ALTER VIEW vista_PreparacionesAjustadas_2025 AS
WITH PreparacionesOrdenadas AS (
    SELECT 
        ID,
        TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT) AS ID_Limpio,
        Renglon,
        Estado,
        CantidadHoras AS HorasPreparacionOriginal,
        CAST(Inicio AS DATETIME) AS Inicio_Legible,
        DATEADD(DAY, -2, CAST(Inicio AS DATETIME)) AS Inicio_Legible_Corregido,
        CAST(Fin AS DATETIME) AS Fin_Legible,
        ROW_NUMBER() OVER (
            PARTITION BY TRY_CAST(SUBSTRING(ID, PATINDEX('%[0-9]%', ID), LEN(ID)) AS INT), Renglon
            ORDER BY CAST(Inicio AS DATETIME)
        ) AS nro_vez
    FROM ConCubo
    WHERE 
        Estado = 'Preparación' AND
        TRY_CAST(Renglon AS INT) = 201 AND
        AnoInicio = 2025
)
SELECT 
    ID,
    ID_Limpio,
    Renglon,
    Estado,
    HorasPreparacionOriginal,
    CASE WHEN nro_vez = 1 THEN HorasPreparacionOriginal ELSE 0 END AS HorasPreparacionAjustada,
    Inicio_Legible,
    Inicio_Legible_Corregido,
    Fin_Legible,
    nro_vez
FROM PreparacionesOrdenadas;
```

#### 🛠️ Ajuste de desfase en fechas

Durante las validaciones realizadas con el equipo de planta, se detectó un **desfase sistemático de +2 días** en la columna `Inicio_Legible`. Si bien la hora era correcta, la fecha no coincidía con el registro real de ingreso en máquina (`DiaInicio`), tal como se reportó en órdenes como la **OT 14292**.

Para preservar la trazabilidad del dato original y al mismo tiempo ofrecer una versión corregida para análisis, se agregó una nueva columna:

| Columna                   | Descripción                                                 |
|---------------------------|-------------------------------------------------------------|
| `Inicio_Legible_Corregido` | Fecha y hora ajustada, restando 2 días al campo original    |

El ajuste se aplica de forma segura con `DATEADD(DAY, -2, Inicio_Legible)`, manteniendo la hora exacta.  
Esto permite comparar ambas fechas en Power BI y verificar fácilmente la diferencia.

---





