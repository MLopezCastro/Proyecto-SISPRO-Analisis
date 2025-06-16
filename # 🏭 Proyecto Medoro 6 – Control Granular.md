# 🏭 Proyecto Medoro 5 – Control Granular de Preparaciones y Producción (2025)

Este proyecto forma parte del análisis de eficiencia en planta industrial, enfocado en el control **granular** de eventos de **preparación** y **producción** durante el año 2025.

Se diseñó una nueva vista SQL llamada `vista_Medoro_BajaGranularidad_2025_OK`, que permite observar con mayor detalle cada evento asociado a una OT (orden de trabajo), incluyendo el número de repetición del bloque, los tiempos involucrados y su validación.

---

## 📑 Estructura de la Vista `vista_Medoro_BajaGranularidad_2025_OK`

| Columna                          | Descripción                                                     |
|----------------------------------|-----------------------------------------------------------------|
| `ID`                             | Identificador de orden original                                 |
| `ID_Limpio`                      | Versión numérica del ID para clave de unión                     |
| `Renglon`                        | Máquina o línea asignada                                        |
| `Tipo`                           | Tipo de estado (Preparación, Producción, etc.)                  |
| `Inicio`                         | Fecha y hora de inicio real                                     |
| `Fin`                            | Fecha y hora de fin real                                        |
| `Inicio_Corregido_Texto`         | Fecha de inicio corregida (sin desfase, como texto plano)       |
| `nro_vez`                        | Número de vez que se repite una preparación                     |
| `HorasPreparacion_Valida_Total` | Tiempo de preparación válido (horas)                            |
| `HorasProduccion_Total`         | Tiempo de producción real (horas)                               |
| `FlagPreparacion`               | 1 si es evento de preparación, 0 si no                          |
| `AnioInicio`                    | Año del evento                                                  |
| `MesInicio`                     | Mes del evento                                                  |

---

## 🧠 Objetivo

Esta vista permite crear visualizaciones de **baja granularidad** que resumen la información por cada bloque de preparación, como por ejemplo:

- Fecha de inicio y fin de cada bloque.
- Cantidad de veces que se repitió una orden.
- Horas efectivas de producción y preparación.
- Porcentaje de tiempo de preparación sobre el total.

Esto es clave para tomar decisiones operativas y detectar **ineficiencias** en tiempo real.

---

## 🛠️ Herramientas utilizadas

- **SQL Server** (versión 2014)
- **Power BI Desktop** (modo Import)
- **GitHub** para versionado y documentación

---

¿Dudas, mejoras o sugerencias? ¡Estoy abierto a feedback y colaboraciones!
