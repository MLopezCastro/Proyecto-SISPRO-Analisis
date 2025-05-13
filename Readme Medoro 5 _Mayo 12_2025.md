# Proyecto Medoro 5 - Análisis y Optimación de Tiempos de Producción y Preparación (2025)

## 🌐 Resumen General

Este proyecto presenta el resultado final del trabajo de optimización y depuración de los tiempos de **preparación** y **producción** para cada orden de trabajo (ID\_Limpio) en el año 2025, sobre la máquina correspondiente al `Renglon = 201`.

El objetivo fue consolidar y corregir los errores presentes en versiones anteriores (Medoro 3 y Medoro 4), permitiendo ahora una medición confiable de la eficiencia operativa, con posibilidad de escalar el modelo a otras máquinas.

---

## 🔧 Vista Principal Utilizada

**`vista_MedoroResumen5_Final_2025`**

Se construyó sobre la base de la vista:

* `vista_Tiempos_Produccion_Preparacion_Medoro5_2025`

Y contiene los siguientes campos corregidos y estructurados:

* `ID`, `ID_Limpio`, `Renglon`
* `Tipo` ("Preparación" o "Producción")
* `HorasPreparacionAjustada`, `HorasProduccionVisible`
* `FlagPreparacionValida` (1 si es una preparación válida, 0 si no)
* `Inicio_Corregido`, `Fin_Corregido` (datetime)
* `Inicio_Corregido_Texto`, `Fin_Corregido_Texto` (texto, evita jerarquías en Power BI)
* `nro_vez` (orden cronológico del evento)
* `AnioInicio`, `MesInicio`, `Quarter`, `Day`

---

## 🔢 Lógica de Construcción SQL

1. Se partieron los eventos de la tabla de tiempos en:

   * `Preparación` y `Producción`, usando el campo `Tipo`.

2. Se conservaron las fechas corregidas (`Inicio_Corregido`, `Fin_Corregido`) sin el desfase de 2 días.

3. Se agregó una versión en texto (`Inicio_Corregido_Texto`) para evitar la jerarquía automática de Power BI.

4. Se incluyeron indicadores:

   * `HorasPreparacionAjustada`: solo si es preparación y válida
   * `HorasProduccionVisible`: solo si es producción
   * `FlagPreparacionValida`: marca la preparación única por grupo
   * `nro_vez`: secuencia de eventos por orden y renglon

5. Se eliminaron eventos con duración cero o nula para visualización

---

## 📊 Visualizaciones en Power BI

### Tarjetas KPI

* `Medida_HorasPreparacion`: suma total por OT del tiempo de preparación válido
* `Medida_HorasProduccion`: suma total por OT del tiempo de producción real
* `Medida_PorcentajePreparacion`: proporción de preparación sobre el total

```DAX
Medida_HorasPreparacion =
CALCULATE(
    SUM(vista_MedoroResumen5_Final_2025[HorasPreparacionAjustada]),
    vista_MedoroResumen5_Final_2025[FlagPreparacionValida] = 1
)

Medida_HorasProduccion =
CALCULATE(
    SUM(vista_MedoroResumen5_Final_2025[HorasProduccionVisible]),
    vista_MedoroResumen5_Final_2025[Tipo] = "Producción"
)

Medida_PorcentajePreparacion =
DIVIDE([Medida_HorasPreparacion], [Medida_HorasProduccion])
```

---

### Gráficos

* Distribución temporal de preparación y producción por día (agrupado por `Year`, `Quarter`, `Month`, `Day`)
* Tabla de detalle por `ID_Limpio` y `Inicio_Corregido_Texto`

---

## 🔎 Validación Manual (OT 14620 y 14626)

* Tiempos de preparación coinciden con los registros manuscritos de José
* Tiempos de producción acumulados también se validaron en dashboard

---

## 📃 Exportación para uso offline (por José)

### 1. Exportar vista a Excel desde SQL Server Management Studio:

```sql
SELECT *
INTO Export_Medoro5_Jose
FROM vista_MedoroResumen5_Final_2025
```

O usar “Export Results” desde el entorno SSMS.

### 2. Guardar archivo como:

`Medoro5_Jose.xlsx`

### 3. Enviar por correo el Excel + PBIX desconectado

* En el PBIX, reemplazar la conexión SQL por el archivo Excel
* Verificar medidas y relaciones

---

## 🛍️ Nota para José (por correo)

Hola José,

Te comparto el avance final del dashboard Medoro 5, ya corregido con los tiempos validados. Las diferencias que antes teníamos con las preparaciones ya están resueltas, y también se corrigieron los desfases de fecha. Verás en el archivo Excel que los eventos están ordenados por fecha y tipo, y que los KPIs reflejan el valor exacto.

El archivo PBIX que acompaño está conectado a este Excel, por lo que podés abrirlo directamente sin depender de la base de datos.

Cualquier duda, lo revisamos juntos.

Saludos,
Marcelo

---

## 🌐 Escalabilidad

Este modelo fue diseñado para replicarse fácilmente:

* Puede aplicarse a otras máquinas cambiando el filtro de `Renglon`
* Puede ampliarse a otros años con mínimos ajustes
* La vista es reutilizable para otros dashboards

---

## 🚀 Impacto

* Se eliminó el desfase de 2 días en las fechas de fin
* Se corrigieron duplicaciones de preparación
* Se detectaron microtiempos reales, que ahora pueden analizarse con filtros
* Se construyó una lógica escalable y visualmente clara para decisiones operativas
