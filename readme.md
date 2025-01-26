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

![image](https://github.com/user-attachments/assets/2e47793b-a202-42cd-94a6-4c0dce74ad49)

*Tabla Concubo: registros desde 2013

*Tabla TablaVinculadaUnion: registros desde 2009

---------------------

## Paso 1: Explorar y entender las tablas

1. Revisemos las columnas clave identificadas:

## Tabla ConCubo:

*ID: Identificador de la orden de trabajo (clave principal).

*Columnas relevantes para análisis: CantidadHoras, Estado, Motivo, Planta, entre otras.

## Tabla TablaVinculadaUNION:

*OP: Orden de Producción, parece ser un identificador que podemos relacionar con ID de ConCubo.

*saccod1: Código de sacabocado, clave para identificar configuraciones compartidas.


Columnas adicionales como descripcionProducto, cantidad, fechaEntrega.

Nota inicial:

ConCubo tiene datos desde 2013, mientras que TablaVinculadaUNION empieza en 2009. Esto significa que solo podremos analizar las órdenes desde 2009 en adelante, ya que es cuando ambas tablas tienen datos.

----------------

## 2. Analicemos el volumen de datos

Antes de proceder a realizar filtros, revisemos cuántos registros tienen estas tablas:

Consulta de conteo de registros por tabla:

![image](https://github.com/user-attachments/assets/e56aed2e-b9f7-4b8c-959a-577fb91f1b17)

![image](https://github.com/user-attachments/assets/406cfdba-b28a-484f-96f8-dcbdd911fa13)

![image](https://github.com/user-attachments/assets/b2bf4895-2021-4e75-bf9c-7b6f5b0cc5e4)

![image](https://github.com/user-attachments/assets/b61a17d7-a0ee-4e9a-9189-ee8459a81829)

------------

## Paso 1: Ajustar el rango de fechas

Ahora que sabemos que podemos trabajar desde 2013, ajustemos las consultas para asegurarnos de que ambas tablas coincidan en su rango de análisis:


## 1. Filtrar registros relevantes en ambas tablas

## Filtrar datos en ConCubo desde 2013 en adelante:

![image](https://github.com/user-attachments/assets/9f33f2c1-c1a4-4bd5-aee5-3db681fb0b2e)

![image](https://github.com/user-attachments/assets/05af266a-53d9-4007-892e-baf9264c5135)

--------------

## 1. Verificar y ordenar las fechas en TablaVinculadaUNION

Como las fechas en fechaEntrega parecen estar desordenadas, primero confirmemos el rango de fechas exacto y ordenemos los datos para explorarlos mejor:

![image](https://github.com/user-attachments/assets/3f18c534-41d7-4eac-91d0-b4a22f05fb6d)

![image](https://github.com/user-attachments/assets/651d405a-dacd-4d59-a7bf-d8b85f9d8a5a)

Esto nos dará una idea clara de:

-Desde cuándo y hasta cuándo existen registros en TablaVinculadaUNION.

-Si hay fechas fuera del rango esperado o datos inconsistentes.









