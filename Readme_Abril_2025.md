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

## 🌟 Próximos pasos (para la semana que viene)
- Analizar los tiempos **programados** (desde `ConArbol`) y compararlos con los reales.
- Agregar análisis cruzado con `VinculadaUnion` (dimensiones, códigos, productos).
- Medir **eficiencia, desfasajes y razones de demoras**.






