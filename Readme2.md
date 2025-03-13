# **README: Creación y Validación de Tablas en SQL Server**

## **1. Introducción**
Este documento detalla el proceso de creación y validación de tres tablas en SQL Server: **ConCubo_2025**, **ConArbol_2025** y **VinculadaUnion_2025**. Se incluyen las decisiones tomadas, correcciones aplicadas y los scripts finales utilizados.

## **Creación de la Base de Datos**

Antes de ejecutar cualquier código de tablas, la fábrica debe crear la base de datos Sispro_2025 y asegurarse de que están trabajando en ella:

CREATE DATABASE Sispro_2025;

USE Sispro_2025;


## **2. Estructura de las Tablas**
Las tablas están diseñadas para almacenar datos de producción y vincular información clave entre ellas.

### **2.1. ConArbol_2025** (Debe crearse primero)
Esta tabla almacena los identificadores de los procesos y los tiempos programados.

```sql
CREATE TABLE ConArbol_2025 (
    ID VARCHAR(20) NOT NULL,                         
    ID_Limpio INT NOT NULL PRIMARY KEY,  -- Clave primaria
    Renglones VARCHAR(20) NOT NULL,      -- Puede contener texto
    Renglones_Limpio INT NOT NULL,       -- Solo números, sin texto
    HoraInicio TIME NOT NULL,                        
    HoraInicioProg TIME NOT NULL,                    
    CantidadHorasProgPrep TIME NOT NULL,            
    CantidadHorasProgProd TIME NOT NULL,
    UNIQUE (Renglones_Limpio)  -- Asegura que la clave foránea en ConCubo_2025 sea válida
);
```

### **2.2. ConCubo_2025** (Debe crearse después de `ConArbol_2025`)
Esta tabla almacena los tiempos efectivos de producción y se vincula con `ConArbol_2025`.

```sql
CREATE TABLE ConCubo_2025 (
    DiaInicio DATE NOT NULL,                         
    Inicio TIME NOT NULL,                           
    Fin TIME NOT NULL,                              
    Turno VARCHAR(50) NOT NULL,                     
    Solapa VARCHAR(50) NOT NULL,                    
    Renglon INT NOT NULL,  -- Se conecta con Renglones_Limpio en ConArbol_2025
    Maquinista VARCHAR(50),                          
    Maquinista_Cod VARCHAR(10),                      
    Maquinista_Nombre VARCHAR(50),                   
    ID VARCHAR(20) NOT NULL,                        
    ID_Limpio INT NOT NULL,  -- Se conecta con ConArbol_2025
    Maquina_Parada TIME NOT NULL,                   
    Preparacion TIME NOT NULL,                      
    Produccion TIME NOT NULL,                       
    Mantenimiento TIME NOT NULL,                    
    CantidadBuenosProducida INT NOT NULL,           
    CantidadMalosProducida INT NOT NULL,            
    codproducto VARCHAR(50) NOT NULL,               
    PRIMARY KEY (ID_Limpio),
    FOREIGN KEY (ID_Limpio) REFERENCES ConArbol_2025(ID_Limpio),  
    FOREIGN KEY (Renglon) REFERENCES ConArbol_2025(Renglones_Limpio)  
);
```

**Corrección aplicada:** Se agregó `UNIQUE (Renglones_Limpio)` en `ConArbol_2025` para evitar errores con la clave foránea de `ConCubo_2025`.

**Cálculo de `Tiempo_Total`:**
```sql
ALTER TABLE ConCubo_2025
ADD Tiempo_Total AS (
    CONVERT(TIME, DATEADD(SECOND,
        DATEDIFF(SECOND, '00:00:00', Maquina_Parada) +
        DATEDIFF(SECOND, '00:00:00', Preparacion) +
        DATEDIFF(SECOND, '00:00:00', Produccion) +
        DATEDIFF(SECOND, '00:00:00', Mantenimiento),
    '00:00:00'))
);
```

### **2.3. VinculadaUnion_2025** (Debe crearse al final)
Esta tabla almacena las referencias a los procesos de producción.

```sql
CREATE TABLE VinculadaUnion_2025 (
    OP VARCHAR(20) NOT NULL,                         -- ID que se vincula con ConCubo y ConArbol
    OP_Limpio INT NOT NULL,                          -- Solo la parte numérica de OP
    saccod1 VARCHAR(50) NOT NULL,                    -- Muy heterogéneo, se deja como texto
    Alto INT NOT NULL,                               
    Ancho INT NOT NULL,                              
    Alto_V INT NOT NULL,                             
    Ancho_V INT NOT NULL,                            
    PRIMARY KEY (OP_Limpio),
    FOREIGN KEY (OP_Limpio) REFERENCES ConCubo_2025(ID_Limpio),  
    FOREIGN KEY (OP_Limpio) REFERENCES ConArbol_2025(ID_Limpio)  
);
```

## **3. Pruebas de Inserción y Eliminación de Datos**

### **3.1. Insertar Datos de Prueba**
```sql
INSERT INTO ConArbol_2025 (ID, ID_Limpio, Renglones, Renglones_Limpio, HoraInicio, HoraInicioProg, CantidadHorasProgPrep, CantidadHorasProgProd)
VALUES ('FAM 26446', 26446, '201', 201, '08:00:00', '07:50:00', '00:10:00', '01:30:00');

INSERT INTO ConCubo_2025 (DiaInicio, Inicio, Fin, Turno, Solapa, Renglon, ID, ID_Limpio, Maquina_Parada, Preparacion, Produccion, Mantenimiento, CantidadBuenosProducida, CantidadMalosProducida, codproducto)
VALUES ('2025-03-03', '08:45:32', '10:30:15', 'Mañana', 'Conf Sobres', 201, 'FAM 26446', 26446, '00:30:00', '00:20:00', '01:00:00', '00:10:00', 3620, 0, '6500');
```

### **3.2. Eliminar Datos de Prueba**
```sql
DELETE FROM VinculadaUnion_2025;
DELETE FROM ConCubo_2025;
DELETE FROM ConArbol_2025;
```

## **4. Orden Correcto de Carga de Datos**
Debido a las claves foráneas, **los datos deben cargarse en este orden:**
1. **Primero:** `ConArbol_2025`
2. **Segundo:** `ConCubo_2025`
3. **Tercero:** `VinculadaUnion_2025`

Esto garantiza que las relaciones entre tablas funcionen sin errores.

## **5. Conclusión**
Las tres tablas están correctamente estructuradas y vinculadas. Se realizaron pruebas exitosas de inserción y eliminación de datos.

🚀 **Este documento servirá para futuras referencias y mantenimiento de la base de datos.**

--------------------

# **📌 INSTRUCCIONES PARA LA FÁBRICA: CREACIÓN Y CARGA DE DATOS EN SQL SERVER**

## **1. Objetivo**
Estas instrucciones explican cómo crear y cargar correctamente los datos en las nuevas tablas **ConCubo_2025**, **ConArbol_2025** y **VinculadaUnion_2025** en SQL Server.

## **2. Orden Correcto de Creación y Carga de Datos**
⚠️ **IMPORTANTE:** Las tablas tienen claves foráneas, por lo que los datos deben cargarse en este orden:
1️⃣ **Primero:** Crear la tabla `ConArbol_2025` y cargar sus datos.
2️⃣ **Segundo:** Crear la tabla `ConCubo_2025` y cargar sus datos.
3️⃣ **Tercero:** Crear la tabla `VinculadaUnion_2025` y cargar sus datos.

---
## **3. Creación de Tablas**
### **3.1. Crear `ConArbol_2025`** (Debe ejecutarse primero)
```sql
CREATE TABLE ConArbol_2025 (
    ID VARCHAR(20) NOT NULL,                         
    ID_Limpio INT NOT NULL PRIMARY KEY,  -- Clave primaria
    Renglones VARCHAR(20) NOT NULL,      -- Puede contener texto
    Renglones_Limpio INT NOT NULL,       -- Solo números, sin texto
    HoraInicio TIME NOT NULL,                        
    HoraInicioProg TIME NOT NULL,                    
    CantidadHorasProgPrep TIME NOT NULL,            
    CantidadHorasProgProd TIME NOT NULL,
    UNIQUE (Renglones_Limpio)  -- Asegura que la clave foránea en ConCubo_2025 sea válida
);
```

### **3.2. Crear `ConCubo_2025`** (Debe ejecutarse después de `ConArbol_2025`)
```sql
CREATE TABLE ConCubo_2025 (
    DiaInicio DATE NOT NULL,                         
    Inicio TIME NOT NULL,                           
    Fin TIME NOT NULL,                              
    Turno VARCHAR(50) NOT NULL,                     
    Solapa VARCHAR(50) NOT NULL,                    
    Renglon INT NOT NULL,  -- Se conecta con Renglones_Limpio en ConArbol_2025
    Maquinista VARCHAR(50),                          
    Maquinista_Cod VARCHAR(10),                      
    Maquinista_Nombre VARCHAR(50),                   
    ID VARCHAR(20) NOT NULL,                        
    ID_Limpio INT NOT NULL,  -- Se conecta con ConArbol_2025
    Maquina_Parada TIME NOT NULL,                   
    Preparacion TIME NOT NULL,                      
    Produccion TIME NOT NULL,                       
    Mantenimiento TIME NOT NULL,                    
    CantidadBuenosProducida INT NOT NULL,           
    CantidadMalosProducida INT NOT NULL,            
    codproducto VARCHAR(50) NOT NULL,               
    PRIMARY KEY (ID_Limpio),
    FOREIGN KEY (ID_Limpio) REFERENCES ConArbol_2025(ID_Limpio),  
    FOREIGN KEY (Renglon) REFERENCES ConArbol_2025(Renglones_Limpio)  
);
```

**Cálculo de `Tiempo_Total`:**
```sql
ALTER TABLE ConCubo_2025
ADD Tiempo_Total AS (
    CONVERT(TIME, DATEADD(SECOND,
        DATEDIFF(SECOND, '00:00:00', Maquina_Parada) +
        DATEDIFF(SECOND, '00:00:00', Preparacion) +
        DATEDIFF(SECOND, '00:00:00', Produccion) +
        DATEDIFF(SECOND, '00:00:00', Mantenimiento),
    '00:00:00'))
);
```

### **3.3. Crear `VinculadaUnion_2025`** (Debe ejecutarse al final)
```sql
CREATE TABLE VinculadaUnion_2025 (
    OP VARCHAR(20) NOT NULL,                         -- ID que se vincula con ConCubo y ConArbol
    OP_Limpio INT NOT NULL,                          -- Solo la parte numérica de OP
    saccod1 VARCHAR(50) NOT NULL,                    -- Muy heterogéneo, se deja como texto
    Alto INT NOT NULL,                               
    Ancho INT NOT NULL,                              
    Alto_V INT NOT NULL,                             
    Ancho_V INT NOT NULL,                            
    PRIMARY KEY (OP_Limpio),
    FOREIGN KEY (OP_Limpio) REFERENCES ConCubo_2025(ID_Limpio),  
    FOREIGN KEY (OP_Limpio) REFERENCES ConArbol_2025(ID_Limpio)  
);
```

---
## **4. Pruebas de Inserción de Datos**
Una vez creadas las tablas, deben probar la carga de datos.

### **4.1. Insertar Datos de Prueba en `ConArbol_2025`**
```sql
INSERT INTO ConArbol_2025 (ID, ID_Limpio, Renglones, Renglones_Limpio, HoraInicio, HoraInicioProg, CantidadHorasProgPrep, CantidadHorasProgProd)
VALUES ('FAM 26446', 26446, '201', 201, '08:00:00', '07:50:00', '00:10:00', '01:30:00');
```

### **4.2. Insertar Datos de Prueba en `ConCubo_2025`**
```sql
INSERT INTO ConCubo_2025 (DiaInicio, Inicio, Fin, Turno, Solapa, Renglon, ID, ID_Limpio, Maquina_Parada, Preparacion, Produccion, Mantenimiento, CantidadBuenosProducida, CantidadMalosProducida, codproducto)
VALUES ('2025-03-03', '08:45:32', '10:30:15', 'Mañana', 'Conf Sobres', 201, 'FAM 26446', 26446, '00:30:00', '00:20:00', '01:00:00', '00:10:00', 3620, 0, '6500');
```

### **4.3. Insertar Datos de Prueba en `VinculadaUnion_2025`**
```sql
INSERT INTO VinculadaUnion_2025 (OP, OP_Limpio, saccod1, Alto, Ancho, Alto_V, Ancho_V)
VALUES ('OP 26446', 26446, '002/2', 150, 200, 160, 210);
```

---
## **5. Eliminación de Datos de Prueba**
Para limpiar las tablas antes de su uso oficial:
```sql
DELETE FROM VinculadaUnion_2025;
DELETE FROM ConCubo_2025;
DELETE FROM ConArbol_2025;
```

---
## **6. Verificación Final**
Ejecutar las siguientes consultas para asegurarse de que las tablas están creadas y vacías:
```sql
SELECT * FROM ConArbol_2025;
SELECT * FROM ConCubo_2025;
SELECT * FROM VinculadaUnion_2025;
```
📢 **Si todas las tablas están vacías y sin errores, la base de datos está lista para su uso.**

🚀 **Por favor, realizar todas las pruebas y confirmar el correcto funcionamiento antes de comenzar la carga oficial de datos.**

-------------------------------

Aquí tienes el **mensaje detallado** para enviar a la fábrica, explicando **el orden correcto de carga de datos** en SQL Server.

---

📢 **Asunto:** 🔹 Orden Correcto de Carga de Datos en SQL Server – `ConArbol_2025`, `ConCubo_2025` y `VinculadaUnion_2025`  

👋 **Equipo**,  

Les enviamos esta guía con el **orden correcto para cargar los datos en las nuevas tablas** de producción. Es importante que el sistema **siga esta secuencia**, de lo contrario, las claves foráneas (`FOREIGN KEY`) generarán errores al intentar insertar registros.  

## **📌 Orden Correcto de Carga de Datos**  

⚠️ **El sistema debe insertar los datos en el siguiente orden:**  

1️⃣ **Primero: Cargar `ConArbol_2025`**  
   - Aquí se registran los **ID_Limpio** y **Renglones_Limpio**.  
   - Esta tabla **debe llenarse primero** porque `ConCubo_2025` y `VinculadaUnion_2025` dependen de sus datos.  
   
   **Ejemplo de inserción:**  
   ```sql
   INSERT INTO ConArbol_2025 (ID, ID_Limpio, Renglones, Renglones_Limpio, HoraInicio, HoraInicioProg, CantidadHorasProgPrep, CantidadHorasProgProd)
   VALUES ('FAM 26446', 26446, '201', 201, '08:00:00', '07:50:00', '00:10:00', '01:30:00');
   ```

2️⃣ **Segundo: Cargar `ConCubo_2025`**  
   - **Solo se pueden insertar datos aquí si `ID_Limpio` ya existe en `ConArbol_2025`.**  
   - La clave foránea `Renglon` debe coincidir con `Renglones_Limpio` en `ConArbol_2025`.  

   **Ejemplo de inserción:**  
   ```sql
   INSERT INTO ConCubo_2025 (DiaInicio, Inicio, Fin, Turno, Solapa, Renglon, ID, ID_Limpio, Maquina_Parada, Preparacion, Produccion, Mantenimiento, CantidadBuenosProducida, CantidadMalosProducida, codproducto)
   VALUES ('2025-03-03', '08:45:32', '10:30:15', 'Mañana', 'Conf Sobres', 201, 'FAM 26446', 26446, '00:30:00', '00:20:00', '01:00:00', '00:10:00', 3620, 0, '6500');
   ```

3️⃣ **Tercero: Cargar `VinculadaUnion_2025`**  
   - **Solo se pueden insertar datos aquí si `OP_Limpio` ya existe en `ConCubo_2025` y `ConArbol_2025`.**  
   - La clave foránea `OP_Limpio` debe vincularse con `ID_Limpio` de ambas tablas.  

   **Ejemplo de inserción:**  
   ```sql
   INSERT INTO VinculadaUnion_2025 (OP, OP_Limpio, saccod1, Alto, Ancho, Alto_V, Ancho_V)
   VALUES ('OP 26446', 26446, '002/2', 150, 200, 160, 210);
   ```

---

## **📌 ¿Qué pasa si se intenta cargar fuera de orden?**  

❌ **Si intentan cargar `ConCubo_2025` antes de `ConArbol_2025`**, SQL Server devolverá un error porque `ID_Limpio` aún no existe en `ConArbol_2025`.  

❌ **Si intentan cargar `VinculadaUnion_2025` antes de `ConCubo_2025` o `ConArbol_2025`**, SQL Server devolverá un error porque `OP_Limpio` aún no está vinculado.  

✅ **Si el sistema respeta este orden, la carga de datos será exitosa sin errores.**  

---

## **📌 ¿Qué deben hacer ahora?**  

🔹 **1️⃣ Revisar cómo su sistema carga los datos en SQL.**  
- **¿Genera primero los registros en `ConArbol_2025` antes de insertar en `ConCubo_2025` y `VinculadaUnion_2025`?**  
- **¿O intenta insertar en las tres tablas al mismo tiempo?**  

🔹 **2️⃣ Hacer una prueba de carga con datos reales.**  
Ejecutar el proceso normal y verificar que:  
✅ **Primero aparecen los datos en `ConArbol_2025`**.  
✅ **Luego en `ConCubo_2025` con los ID_Limpio correctos**.  
✅ **Finalmente, en `VinculadaUnion_2025`, vinculando con los ID_Limpio de ambas tablas.**  

🔹 **3️⃣ Informar si hay problemas.**  
Si el sistema intenta cargar todo a la vez y falla, podemos evaluar soluciones como:  
- **Ajustar el orden de inserción en el sistema.**  
- **Desactivar temporalmente las claves foráneas (`FOREIGN KEY`) y reactivarlas luego.**  

---

📢 **Por favor, confirmen si su sistema carga los datos en este orden y realicen una prueba.**  
Si encuentran algún problema, envíennos el error para analizar la mejor solución.  

🚀 **Esperamos su respuesta para validar que todo funcione correctamente.**  

Saludos,  
Marcelo

---------------------------------------------------------



