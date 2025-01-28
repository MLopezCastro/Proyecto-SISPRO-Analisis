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

![image](https://github.com/user-attachments/assets/c31b2e41-335d-4e83-ad7f-664b0e33c23d)

-------

## Paso 1: Filtrar registros desde 2014 en adelante

Para trabajar con datos desde 2014, ajustemos las consultas para filtrar ambos conjuntos de datos:

## 1. Filtrar en ConCubo desde 2014

Queremos incluir solo las órdenes de trabajo (OT) desde 2014:

![image](https://github.com/user-attachments/assets/7426d06e-74ed-4b4f-a1fa-3b990fcce089)

![image](https://github.com/user-attachments/assets/89094511-dd68-46e4-a5c2-b3e2df9d3395)

## 2. Filtrar en TablaVinculadaUNION desde 2014

Vamos a hacer lo mismo para los registros de TablaVinculadaUNION basándonos en la columna

![image](https://github.com/user-attachments/assets/9f35d222-7a94-4639-85a1-3808d1db31c9)

![image](https://github.com/user-attachments/assets/57cb80be-e996-451e-ac01-6fa4312da331)

----------

## Paso 2: Revisar la relación entre ID y OP

Queremos confirmar si ID (de ConCubo) y OP (de TablaVinculadaUNION) están relacionados correctamente después del filtrado.

Consulta para verificar coincidencias:

![image](https://github.com/user-attachments/assets/2cb8ae90-f1ba-4c9f-8073-18aab536e994)

![image](https://github.com/user-attachments/assets/d62d29f8-0ff8-411e-aa4d-4d7192b5b072)

-------------

## Paso 3: Analizar saccod1 para configuraciones compartidas

Como sabemos que saccod1 es clave para la máquina 201, exploremos su distribución para ver qué configuraciones se repiten.

Consulta para analizar saccod1:

![image](https://github.com/user-attachments/assets/9b47e05a-1558-472a-b233-ae15399afb42)

![image](https://github.com/user-attachments/assets/d55567e1-bd8d-4bb2-8057-611ac4998bbe)

----------------

## Paso 4: Análisis de saccod1 para configuraciones compartidas (Máquina 201)

Objetivo: Entender la distribución de saccod1 para identificar patrones y configuraciones compartidas en la máquina 201.

Consulta de valores únicos de saccod1:


![image](https://github.com/user-attachments/assets/b140de59-abac-460d-b3c2-06f7164fe148)


![image](https://github.com/user-attachments/assets/b233e8a5-1197-46e9-a354-9ea664d1769f)

## 1. Análisis del resultado

Distribución de saccod1:

El valor más común es 29547 registros con saccod1 = 0, lo que parece indicar un valor por defecto o vacío en muchos registros. Esto podría significar que:

No se asignó un código de sacabocado para esas órdenes.

Es un valor irrelevante para el análisis de configuraciones compartidas.

Hay 1,099 registros con saccod1 = NULL, lo cual implica que la información no está presente para estas órdenes.

Los valores restantes tienen distribuciones más pequeñas, como:

saccod1 = 385 con 50 registros.

saccod1 = 414 con 27 registros.

Otros valores únicos con cantidades menores.

¿Qué podemos deducir?

saccod1 = 0 o NULL probablemente no representan configuraciones válidas. Estos valores deberían descartarse para el análisis de configuraciones compartidas.
Los valores como 385, 414, 484, etc., sí parecen ser configuraciones reales. Estos serán útiles para identificar órdenes que comparten la misma configuración.

-----------------

## 2. Ajustar los datos para avanzar

Filtrar los valores útiles de saccod1:

Vamos a descartar los registros donde:

saccod1 = 0

saccod1 IS NULL

Consulta SQL:

![image](https://github.com/user-attachments/assets/abf8e8c0-81ff-4e2d-810a-736ac71346f4)

Resultados esperados:

Esto debería mostrarnos solo los valores válidos de saccod1 para el análisis (es decir, aquellos mayores a 0).


![image](https://github.com/user-attachments/assets/2ea65790-4a6e-40fa-adef-e014e449d7de)

El error Conversion failed when converting the nvarchar value '38/2' to data type int ocurre porque en tu columna saccod1 hay valores que no son enteros (como el caso '38/2'). Esto sucede porque saccod1 está almacenado como un tipo de dato nvarchar, y al intentar compararlo con un número o realizar operaciones que esperan un tipo int, falla.

Para resolverlo, necesitamos filtrar y convertir solo los valores que sean numéricos:

## Solución: Filtrar solo valores numéricos

Podemos usar una consulta que asegure que solo se procesen los valores numéricos en saccod1.

1. Identificar registros no numéricos

Primero, verifiquemos qué valores en saccod1 no son numéricos. Esto nos ayudará a confirmar cuántos registros están causando el problema:

![image](https://github.com/user-attachments/assets/cb95725e-d617-4124-b215-d19bc3d575be)

![image](https://github.com/user-attachments/assets/b03b8330-b1ad-4163-b42a-2fab904c9e12)

##2. Filtrar registros numéricos

Una vez identificados, ajustemos la consulta para trabajar solo con los valores numéricos. Esto filtra los valores válidos antes de convertir saccod1 a un tipo int:


![image](https://github.com/user-attachments/assets/c9ac9199-0158-412e-b7ba-9836140c0311)


![image](https://github.com/user-attachments/assets/72944d7e-04e6-42e0-b9d7-5e4e44742044)

Explicación

-ISNUMERIC(saccod1):

Filtra los valores que son numéricos (por ejemplo, '38' será válido, pero '38/2' no).
CAST(saccod1 AS INT):

Convierte los valores numéricos de tipo nvarchar a tipo int para que podamos analizarlos correctamente.

----------------

## 3. Consulta ajustada para relacionar tablas

Después de confirmar y filtrar los valores válidos de saccod1, ajustemos la consulta para relacionar ConCubo con TablaVinculadaUNION usando únicamente valores numéricos:

![image](https://github.com/user-attachments/assets/8f9c5bec-a26c-4345-94cb-60b5d7addaa4)

![image](https://github.com/user-attachments/assets/c92ccf63-d125-459f-97a7-632e7a7047a4)

Vemos que los registros en común comienzan en Octubre de 2021

-------------------

## ¿Qué hemos logrado hasta ahora?

-Filtramos valores válidos de saccod1:

-Descubrimos que algunos valores no eran numéricos, y ahora solo trabajamos con valores que se pueden convertir a int.

-Relacionamos ConCubo y TablaVinculadaUNION:

-Confirmamos que las columnas ID y OP están correctamente relacionadas para el rango de fechas y valores filtrados.

-Obtenemos datos útiles para el análisis:

Ahora tenemos información combinada entre ambas tablas, incluyendo:

*Año y mes de inicio (AnoInicio, MesInicio).

*Configuración identificada por saccod1_int.

*Fecha de entrega.

--------------------------------------

## Próximos pasos

Con estos resultados, avanzaremos al siguiente nivel del análisis: identificar secuencias de órdenes que comparten la misma configuración (saccod1_int) y calcular tiempos optimizados.

## Paso 1: Identificar secuencias consecutivas con el mismo saccod1_int

Consulta para calcular secuencias consecutivas: Utilizaremos una ventana en SQL para determinar si una orden comparte la misma configuración (saccod1_int) con la anterior.

![image](https://github.com/user-attachments/assets/a1bb38fd-5164-44fb-b3f9-f1ff19e9f52f)

![image](https://github.com/user-attachments/assets/d8281384-0ece-4d39-8562-28fdefeca07b)

*Propósito:

-Identificar si una orden pertenece a la misma secuencia que la anterior.

-Etiquetar cada orden como MISMA_SECUENCIA o NUEVA_SECUENCIA.

## Lo que observamos en los datos:

Hay registros con MISMA_SECUENCIA y NUEVA_SECUENCIA:

Esto significa que la lógica para detectar secuencias está funcionando parcialmente.

Sin embargo, en algunos casos, para una misma combinación de ID, OP y saccod1_int, todavía se marca como NUEVA_SECUENCIA, lo cual podría no ser esperado.

Problema potencial:

Si el valor de saccod1_int, OP o fechaEntrega es constante dentro de un grupo, pero SQL considera que hay una "nueva secuencia," podríamos estar enfrentando uno de estos escenarios:

-Las fechas de entrega son todas iguales, lo que podría estar confundiendo la lógica.

-Falta de orden consistente en los datos, lo que hace que las secuencias no se calculen correctamente.

----------

## Diagnóstico: Verificar los datos

Antes de ajustar la lógica, confirmemos lo siguiente:

1. ¿Las fechas de entrega (fechaEntrega) tienen variación?

![image](https://github.com/user-attachments/assets/c3eec540-8de8-4c97-8f89-a32fbd298cdd)

![image](https://github.com/user-attachments/assets/9dbb7b9e-5b5d-478d-8f78-e8922ee60929)

Resultado esperado:

-Si FechasUnicas = 1, entonces todas las fechas son iguales para ese grupo, y eso podría estar causando inconsistencias en las secuencias.

-Si hay varias fechas únicas, entonces el cálculo de secuencias es válido.

El hecho de que FechasUnicas siempre sea 1 significa que, para cada combinación de ID, OP y saccod1_int, todas las órdenes tienen exactamente la misma fecha de entrega (fechaEntrega). Esto explica por qué nuestra lógica para detectar secuencias puede no estar 

funcionando como se esperaba: no hay variación en las fechas dentro de cada grupo, lo que hace difícil calcular cambios entre registros consecutivos.

Causa del problema

Cuando todas las filas tienen la misma fecha dentro de un grupo, la función LAG que usamos para calcular secuencias no puede basarse en un orden natural para distinguir registros consecutivos. Esto da lugar a resultados inconsistentes, como asignar NUEVA_SECUENCIA 

cuando en realidad podría ser parte de una misma secuencia.

## Opciones para resolverlo

1. Incorporar otra columna como criterio adicional

Si las fechas no varían, podemos incluir otra columna en la lógica de ordenamiento para garantizar que los registros se procesen correctamente. Una buena opción sería usar la columna ID, ya que parece ser única en cada registro.

Lógica ajustada:

Usaremos tanto fechaEntrega como ID para determinar el orden:

![image](https://github.com/user-attachments/assets/42c9f3b3-dbd7-41d2-8984-03ce34635149)

Qué estamos haciendo aquí:

Usamos fechaEntrega como criterio principal y ID como criterio secundario para ordenar los registros dentro de cada grupo.

Esto asegura que SQL procese los registros en un orden claro y consistente, incluso si las fechas son idénticas.

![image](https://github.com/user-attachments/assets/8d6bd228-10ce-432f-a8bb-addef41c7ebb)

## 2. Agrupar directamente por saccod1_int y OP

Si no hay un criterio claro para distinguir registros dentro de un grupo, podríamos considerar simplemente agrupar los registros que comparten el mismo OP y saccod1_int sin intentar calcular secuencias.

Consulta alternativa:

![image](https://github.com/user-attachments/assets/004797fa-a903-413e-b7fa-e73c8483e0f7)

Qué estamos haciendo aquí:

-Agrupamos por OP y saccod1_int para obtener una visión general de las órdenes que comparten la misma configuración.

-Calculamos la cantidad de órdenes, así como la fecha de inicio y fin de cada grupo.

![image](https://github.com/user-attachments/assets/f706522a-97fb-47b8-9152-533270d61eee)

Los resultados del Enfoque 2 parecen más consistentes y prácticos para este caso, dado que:

-El enfoque 2 agrupa directamente por OP y saccod1_int:

Esto te da un resumen claro de cuántas órdenes (TotalOrdenes) comparten una misma configuración (saccod1_int) dentro de un mismo OP.

Además, las columnas FechaInicio y FechaFin te proporcionan un rango de tiempo consolidado para esas órdenes, lo cual es ideal para el análisis de tiempos de preparación.

El enfoque 1, basado en secuencias (MISMA_SECUENCIA/NUEVA_SECUENCIA), no agrega mucho valor en este caso:

Dado que las fechas no varían dentro de cada grupo, las secuencias no aportan una segmentación significativa.

Termina siendo más complejo sin una ganancia clara.

## Conclusión

El Enfoque 2 es el mejor camino por ahora, ya que ofrece un análisis claro y manejable de configuraciones compartidas y su impacto en la producción.

-----------

## Próximos pasos con el enfoque 2

1. Validar los resultados obtenidos

Asegúrate de que los resultados del Enfoque 2 sean consistentes en todos los registros:

-saccod1_int: Verifica que los valores sean relevantes y correctos (por ejemplo, sin valores nulos o erróneos).

-Fechas: Asegúrate de que FechaInicio y FechaFin reflejen correctamente el rango de las órdenes.

2. Exportar los resultados para análisis adicional

Con los resultados agrupados por OP y saccod1_int, puedes exportar estos datos para visualizarlos o analizarlos en Power BI o Python:

![image](https://github.com/user-attachments/assets/363dadd3-0591-41d8-b90a-afec8aa32269)

![image](https://github.com/user-attachments/assets/0e54c11f-14a7-4f76-a0f7-6130f5c472e1)

![image](https://github.com/user-attachments/assets/04a6344c-2475-4ea4-bfeb-713ffb7486b9)

![image](https://github.com/user-attachments/assets/a4c59031-a1f4-4125-b094-1fb3b2915f88)

![image](https://github.com/user-attachments/assets/ed7edcff-6ed8-49a9-8bfe-757ea3849549)

![image](https://github.com/user-attachments/assets/c82331a5-09f0-4b66-ac72-45ed014b1d95)

--------------------

## Resumen del progreso

-Hemos limpiado y estructurado los datos clave:

-Identificamos que la columna saccod1 era útil para la máquina 201 y limpiamos los valores no numéricos.

-Relacionamos correctamente las tablas ConCubo y TablaVinculadaUNION usando ID y OP.

-Optamos por un enfoque práctico (agrupación por saccod1_int y OP):

-Calculamos TotalOrdenes, FechaInicio, y FechaFin para cada combinación de OP y saccod1_int, lo que simplifica el análisis de configuraciones compartidas.

-Esto nos permite identificar cuántas órdenes comparten la misma configuración.

-Exportamos los datos optimizados a una nueva tabla (TablaOptimizadaSecuencias):

Los datos ya están listos para análisis adicionales en Power BI, Python, o SQL.

El análisis por saccod1_int es escalable: lo que hicimos para la máquina 201 puede aplicarse a otras máquinas con diferentes criterios de configuración.

-------------

## Estado actual: Máquina 201

El problema de los tiempos de preparación de la máquina 201 está en camino de ser resuelto, gracias a los siguientes logros:

Identificamos configuraciones compartidas:

-Los datos ahora permiten analizar cuántas órdenes consecutivas utilizan la misma configuración (saccod1_int).

-Esto es clave para ajustar los tiempos de preparación y optimizar el cálculo de indicadores como el OEE.

-Base lista para visualización:

Con la tabla optimizada, puedes crear reportes que muestren:

-Configuraciones más comunes.

-Fechas en las que se comparte la misma configuración.

-Tiempos acumulados de preparación para secuencias específicas.

Siguiente etapa: Análisis de tiempos de preparación:

Con los datos agrupados por saccod1_int, puedes calcular tiempos ajustados de preparación y compararlos con los tiempos reales para identificar mejoras.

----------

## ¿Qué estamos buscando?

El objetivo final es solucionar el problema de los tiempos de preparación de la máquina 201 (y posiblemente de otras máquinas en el futuro), que impacta la eficiencia operativa, incluyendo indicadores como el OEE (Eficiencia General del Equipo).

Para eso, estamos:

Identificando configuraciones compartidas: Ya logramos agrupar órdenes que usan la misma configuración (saccod1_int).

Analizando tiempos de preparación: Ahora necesitamos entender cuánto tiempo real lleva preparar la máquina para estas configuraciones, ya sea:

Tiempos reales (si están registrados en el sistema).

Estimaciones basadas en conocimiento del personal operativo.

¿Por qué analizamos las fechas?

Las columnas fechaEmision y fechaEntrega en TablaVinculadaUNION pueden ser una forma indirecta de estimar:

Cuánto tiempo transcurrió entre el inicio de la orden (emisión) y la finalización (entrega).

Esto podría incluir tanto el tiempo de preparación como el tiempo de producción.

Sin embargo, como hemos visto, las fechas son inconsistentes y no parecen ser completamente confiables para este propósito. Por eso, podría ser más efectivo consultar a los operadores de las máquinas para obtener información real sobre los tiempos de preparación.

