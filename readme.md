# Proyecto: Análisis de datos en Sispro

Este proyecto tiene como objetivo resolver problemas relacionados con el cálculo de tiempos de preparación en una planta de producción, optimizando los datos y facilitando la generación de reportes en Power BI.

## 🛠️ Tecnologías utilizadas
- **SQL Server**: Para el manejo de la base de datos.
- **Python**: Para análisis de datos y procesamiento ETL.
- **Power BI**: Para la visualización de resultados.
- **GitHub**: Para el control de versiones y la documentación.

## 📂 Estructura del proyecto
- `data/`: Archivos de datos (por ejemplo, exportaciones en CSV, si se utilizan en local).
- `sql/`: Scripts SQL utilizados para consultas y análisis.
- `scripts/`: Código Python u otros lenguajes para procesamiento de datos.
- `docs/`: Documentación del proyecto, objetivos, problemas y soluciones.

## 🚀 Estado actual del proyecto
### 1. **Tablas exploradas**:
   - **ConCubo**: Contiene órdenes de trabajo (`ID`).
   - **TablaVinculadaUNION**: Es una vista con códigos de sacabocado (`saccod1`) y órdenes (`OP`).
### 2. **Relación identificada**:
   - Relación entre `ConCubo` (`ID`) y `TablaVinculadaUNION` (`OP`).
### 3. **Próximos pasos**:
   - Analizar las columnas clave (`saccod1`) y filtrar datos para la máquina 201.
   - Generar una tabla optimizada para el análisis de tiempos de preparación.

## 📝 Tareas pendientes
- [ ] Documentar la definición de la vista `TablaVinculadaUNION`.
- [ ] Analizar si la tabla `TablaVinculadaUnion20210702` aporta datos adicionales.
- [ ] Relacionar las tablas y preparar una tabla consolidada.
- [ ] Crear visualizaciones en Power BI.

----------------
## Objetivo general: Mejorar el análisis de tiempos y secuencias de órdenes de trabajo (OT)
El problema que identificamos está relacionado con:

1-Tiempos de preparación que no reflejan la realidad cuando las órdenes comparten configuraciones similares.

2-Inconsistencias en los reportes generados por Power BI debido a estas discrepancias.

3-Escalabilidad: Cómo crear un sistema flexible para incluir otras máquinas y sus variables específicas.

-----------
1. Resumen de lo que ya hicimos

## Tenemos las tablas clave: ConCubo y TablaVinculadaUNION.

### Sabemos que saccod1 (código de sacabocado) es importante para discriminar órdenes en la máquina 201.

### Las columnas clave son:

1-En ConCubo: ID (identificador de la orden de trabajo).

2-En TablaVinculadaUNION: OP (orden de trabajo) y saccod1 (código de sacabocado).

Ahora necesitamos avanzar hacia un análisis más profundo y establecer un flujo de trabajo para abordar el problema.

------

## 2. Plan de acción: Siguiente etapa

Paso 1: Explorar y entender las tablas de datos

Antes de aplicar transformaciones o filtros, debemos analizar a fondo las tablas principales para asegurarnos de que tenemos toda la información relevante.

Consulta y descripción de las tablas:

![image](https://github.com/user-attachments/assets/15870bd7-3477-4e9e-bd66-bafeb35e4160)

