# Proyecto Medoro 5 – Optimización de Tiempos de Preparación y Producción (2025)

> **Estado:** Finalizado ✅
> **Fuente:** SQL Server (vistas internas + exportación a Excel para Power BI portable)
> **Responsable:** Marcelo Fabián López

---

## 📊 Objetivo del Proyecto

Corregir los errores históricos en la medición de tiempos de preparación y producción para cada orden de trabajo (ID\_Limpio), asegurando:

* Fechas legibles sin desfase (2 días corregidos)
* Tiempos reales y no duplicados de preparación
* Detección de reinicios válidos de preparación cuando una OT es interrumpida por otra
* Datos limpios, listos para visualización y análisis

---

## 🔠 Fuentes y Estructura de Datos

### Vista principal:

**`vista_MedoroResumen5_Final_2025`**
Construida sobre:

* `vista_Tiempos_Produccion_Preparacion_Medoro5_2025`
* Correcciones de fechas y filtros de eventos válidos

### Campos clave:

| Campo                           | Descripción                                                             |
| ------------------------------- | ----------------------------------------------------------------------- |
| `ID_Limpio`                     | Orden de trabajo (limpia)                                               |
| `Renglon`                       | Máquina (ej. 201)                                                       |
| `Inicio_Corregido_Texto`        | Fecha y hora reales del inicio (corrigido sin desfase, formato legible) |
| `Fin_Corregido_Texto`           | Fecha y hora reales del fin (corrigido, legible)                        |
| `HorasPreparacion_Valida_Total` | Tiempo de preparación válido (solo si `FlagPreparacion` = 1)            |
| `HorasProduccion_Total`         | Tiempo real de producción visible                                       |
| `FlagPreparacion`               | Marca si el evento es preparación válida                                |
| `nro_vez`                       | Nro secuencial del evento dentro de la OT                               |
| `Tipo`                          | Preparación / Producción / Maquina Parada                               |

---

## 🔢 Medidas DAX (Power BI)

```DAX
Medida_HorasPreparacion =
CALCULATE(
    SUM(vista_MedoroResumen5_Final_2025[HorasPreparacion_Valida_Total]),
    vista_MedoroResumen5_Final_2025[FlagPreparacion] = 1
)

Medida_HorasProduccion =
CALCULATE(
    SUM(vista_MedoroResumen5_Final_2025[HorasProduccion_Total]),
    vista_MedoroResumen5_Final_2025[Tipo] = "Producción"
)

Medida_PorcentajePreparacion =
DIVIDE([Medida_HorasPreparacion], [Medida_HorasProduccion])
```

---

## 📉 Visualizaciones (Power BI)

* **Tarjetas:** Horas de Preparación, Producción y % Tiempo en Preparación
* **Gráfico de barras agrupado:**

  * Eje X: `Day`, `Month`, `Quarter`, `Year`
  * Series: Preparación vs Producción por fecha real de inicio (`Inicio_Corregido_Texto`)
* **Tabla Detalle:**

  * Incluye secuencia completa de eventos para cada ID (OT), con duraciones reales
  * Microtiempos incluidos (no filtrados), con posibilidad de inspección

---

## ✅ Validación Cruzada

Los datos fueron verificados manualmente con notas manuscritas del responsable José:

* Para OT `14620`: 3.46 h de preparación coinciden con 3.47 h registradas a mano
* Para OT `14626`: 4.35 h automáticas vs 4.377 h en validación manual (prácticamente exacto)

Los microtiempos presentes se originan en datos crudos: son reales y no errores del modelo.

---

## 📁 Exportación para otros usuarios (como José)

1. Exportar `vista_MedoroResumen5_Final_2025` desde SQL a Excel
2. Importar el `.xlsx` en Power BI (modo importación)
3. Reconstruir medidas DAX si es necesario
4. Guardar como `Medoro5_Jose.pbix`

---

## ♻️ Escalabilidad

La lógica implementada permite:

* Replicar en otras máquinas (Renglones != 201)
* Comparación mensual o diaria de eficiencia
* Automatización de alertas por exceso de tiempo de preparación

---

## 💼 Archivos involucrados

* SQL:

  * `vista_Tiempos_Produccion_Preparacion_Medoro5_2025`
  * `vista_MedoroResumen5_Final_2025`
* Power BI:

  * `Medoro5_Final.pbix`
  * `Medoro5_Jose.pbix`
* Excel:

  * `Medoro5_Jose.xlsx`

---

## 🚀 Resultado

* Tiempos corregidos con precisión
* Validación manual positiva
* Microtiempos identificados, no descartados
* Dashboards claros y exportables

---

## 📆 Próximos pasos

* Incorporar `CantidadProducida` por OT
* Clasificar con semáforo de eficiencia
* Replicar para todas las líneas del 2025

---

## 🏆 Autor

**Marcelo Fabián López**
[GitHub](https://github.com/MLopezCastro) | [LinkedIn](https://www.linkedin.com/in/marcelo-fabian-lopez)

---

> Si este README te resultó últil, dejá una estrella en el repo ✨
