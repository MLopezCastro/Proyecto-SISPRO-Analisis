# Proyecto Medoro 5 - Cálculo correcto de Tiempos de Preparación y Producción (2025)

### 🔢 Descripción general

Este README documenta el trabajo final de corrección del Proyecto Medoro 5, orientado a resolver definitivamente los errores históricos en los tiempos de preparación y producción registrados para cada orden de trabajo (`ID_Limpio`) en la línea de producción (`Renglon = 201`).

---

## 🔍 Problemas detectados en versiones anteriores (Medoro 3 y Medoro 4)

* Los tiempos de preparación estaban **incompletos o duplicados**.
* El dato de producción aparecía como si fuese preparación.
* La tarjeta de "Horas Producción" mostraba a veces los datos correctos de preparación.
* Se ignoraban preparaciones adicionales para la misma OT si eran interrumpidas por otra OT.

---

## 🔹 Vista principal utilizada

`vista_Tiempos_Produccion_Preparacion_Medoro5_2025`

Contiene:

* Eventos de `Preparación` y `Producción` para `Renglon = 201`
* Columnas clave:

  * `HorasPreparacionAjustada`
  * `HorasProduccionVisible`
  * `FlagPreparacionValida`
  * `Inicio_Corregido` (fecha legible corregida, sin desfase)
  * `nro_vez` (orden cronológico dentro de cada `ID_Limpio`)

Fuente:

* `vista_ConCubo_2025` para eventos originales
* `vista_PreparacionesReales_Corregidas_2025` para lógica corregida de preparaciones
* `vista_ProduccionPorOrden_2025` para producción consolidada

---

## ⚖️ Validación cruzada

**OT 14620**

* Tiempo correcto de preparación manual (según José): **3.47 h**
* Tiempo en reporte Medoro 5: **3.46 h**

**OT 14626**

* Tiempo correcto de preparación manual: **4.377 h**
* En validación futura (pendiente), se debe confirmar este dato

---

## 📈 Métricas en Power BI (DAX)

### HorasPreparacion\_Valida\_Total

```DAX
HorasPreparacion_Valida_Total =
CALCULATE(
    SUM(vista_Tiempos_Produccion_Preparacion_Medoro5_2025[HorasPreparacionAjustada]),
    vista_Tiempos_Produccion_Preparacion_Medoro5_2025[FlagPreparacionValida] = 1
)
```

### HorasProduccion\_Total

```DAX
HorasProduccion_Total =
CALCULATE(
    SUM(vista_Tiempos_Produccion_Preparacion_Medoro5_2025[HorasProduccionVisible]),
    vista_Tiempos_Produccion_Preparacion_Medoro5_2025[Tipo] = "Producción"
)
```

### %TiempoPreparacion\_Real

```DAX
%TiempoPreparacion_Real =
DIVIDE([HorasPreparacion_Valida_Total], [HorasProduccion_Total])
```

---

## 🔒 Detalles técnicos a tener en cuenta

* La columna `Inicio_Corregido` permite filtrar correctamente sin jerarquías automáticas.
* Si al filtrar por fechas individuales aparece `(Blank)`, se debe revisar si esas fechas tienen registros con `FlagPreparacionValida = 0` o si son sólo de producción.
* La columna `nro_vez` sirve para entender el orden cronológico de las entradas de cada OT, pero **no es requerida para los KPIs**.

---

## 📄 Archivos involucrados

* Power BI: `Medoro5_Final.pbix`
* SQL Server: vistas `vista_Tiempos_Produccion_Preparacion_Medoro5_2025`, `vista_ConCubo_2025`, `vista_PreparacionesReales_Corregidas_2025`, `vista_ProduccionPorOrden_2025`

---

## 🚀 Resultado

Gracias a estas correcciones:

* Se eliminaron los desfases de fecha.
* Se capturaron todas las preparaciones interrumpidas correctamente.
* Se obtuvieron los valores validados contra control manual.
* El dashboard ahora presenta valores confiables para decisiones.

---

## 📅 Proximos pasos

* Incluir saccod1 (sacabocados) desde `TablaVinculadaUNION_2025`
* Incorporar cantidad producida por OT
* Clasificar tiempos con semáforo de eficiencia
* Replicar en otras máquinas de forma estandarizada con este README

---

📅 Actualizado: 2025-05-04
📈 Autor: Marcelo Fabián López
