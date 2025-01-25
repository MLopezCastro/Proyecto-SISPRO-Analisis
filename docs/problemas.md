# Registro de Problemas y Soluciones

## 1. Tabla `TablaVinculadaUNION` no visible en el Explorador de Objetos
- **Problema**: Inicialmente, la tabla `TablaVinculadaUNION` no aparecía en el Explorador de Objetos.
- **Causa**: La tabla no es una tabla física, sino una vista.
- **Solución**:
  - Se utilizó la consulta:
    ```sql
    SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME LIKE '%TablaVinculadaUNION%';
    ```
  - Confirmamos que `TablaVinculadaUNION` es una vista y accedimos a su contenido.
 
  - ![image](https://github.com/user-attachments/assets/80e80607-0390-4d3c-b92f-6152c6fbf460)


## 2. Relación entre tablas `ConCubo` y `TablaVinculadaUNION`
- **Problema**: No estaba claro cómo relacionar las tablas.
- **Causa**: Faltaba explorar las columnas clave (`ID`, `OP`).
- **Solución**:
  - Verificamos la relación con la consulta:
    ```sql
    SELECT TOP 100 c.ID, v.OP
    FROM ConCubo c
    INNER JOIN TablaVinculadaUNION v
    ON c.ID = v.OP;
    ```
