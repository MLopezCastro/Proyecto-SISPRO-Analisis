# Objetivos del Proyecto

## 📌 Objetivo General
Optimizar los datos relacionados con tiempos de preparación en una planta de producción para mejorar los reportes de Power BI y facilitar la toma de decisiones.

## 🎯 Objetivos Específicos
1. **Explorar las tablas de la base de datos**:
   - Identificar las tablas relevantes: `ConCubo` y `TablaVinculadaUNION`.
   - Confirmar las relaciones entre las columnas clave (`ID`, `OP`, `saccod1`).

2. **Resolver el problema para la máquina 201**:
   - Usar `saccod1` para identificar configuraciones similares y calcular los tiempos de preparación reales y programados.

3. **Escalabilidad**:
   - Crear un modelo que permita incluir otras máquinas con diferentes variables (por ejemplo, ancho y alto para las confeccionadoras de sobres).

4. **Visualización de datos**:
   - Generar reportes en Power BI basados en los datos optimizados.
