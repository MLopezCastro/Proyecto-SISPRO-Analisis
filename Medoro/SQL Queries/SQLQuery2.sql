CREATE DATABASE Sispro_2025;

SELECT name FROM sys.databases;

--PASO 1: Crear ConArbol_2025 primero
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
--UNIQUE (Renglones_Limpio): Ahora ConCubo_2025 puede usar Renglones_Limpio como FOREIGN KEY.

--PASO 2: Crear ConCubo_2025 correctamente
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
--a clave foránea FOREIGN KEY (Renglon) REFERENCES ConArbol_2025(Renglones_Limpio) ahora funcionará porque Renglones_Limpio es UNIQUE.

--PASO 3: Agregar Tiempo_Total
ALTER TABLE ConCubo_2025
ADD Tiempo_Total AS (
    DATEADD(SECOND, 
        DATEDIFF(SECOND, '00:00:00', Maquina_Parada) + 
        DATEDIFF(SECOND, '00:00:00', Preparacion) + 
        DATEDIFF(SECOND, '00:00:00', Produccion) + 
        DATEDIFF(SECOND, '00:00:00', Mantenimiento), 
    '00:00:00')
);

--Cómo probar que Tiempo_Total se calcula bien
SELECT ID_Limpio, Maquina_Parada, Preparacion, Produccion, Mantenimiento, Tiempo_Total
FROM ConCubo_2025;
--Si Tiempo_Total aparece con el resultado correcto, todo está bien.

--Código SQL para crear VinculadaUnion_2025
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

--Explicación detallada
--1?OP_Limpio es la clave primaria, garantizando que cada orden de producción (OP) sea única.
--2?Se crean dos claves foráneas (FOREIGN KEY):
--OP_Limpio conecta con ID_Limpio en ConCubo_2025.
--OP_Limpio conecta con ID_Limpio en ConArbol_2025.
--3?saccod1 se mantiene como VARCHAR(50) porque sus valores son muy heterogéneos (002, 002/2, GUILLO, etc.).
--4?Alto, Ancho, Alto_V y Ancho_V son INT, asegurando que sean valores numéricos enteros.

SELECT name FROM sys.tables WHERE name = 'VinculadaUnion_2025';

SELECT * FROM ConCubo_2025
SELECT * FROM ConArbol_2025
SELECT * FROM VinculadaUnion_2025

--PASO 1: Insertar datos de prueba
--Aquí insertaremos registros de prueba en las tres tablas, asegurándonos de que las conexiones (FOREIGN KEY) funcionan correctamente.
--1Insertar datos en ConArbol_2025 (Debe ser primero)
INSERT INTO ConArbol_2025 (ID, ID_Limpio, Renglones, Renglones_Limpio, HoraInicio, HoraInicioProg, CantidadHorasProgPrep, CantidadHorasProgProd)
VALUES 
('FAM 26446', 26446, '201', 201, '08:00:00', '07:50:00', '00:10:00', '01:30:00'),
('TEC 671', 671, '125', 125, '09:30:00', '09:20:00', '00:10:00', '02:00:00');

--Insertar datos en ConCubo_2025 (Debe ser después de ConArbol_2025)
INSERT INTO ConCubo_2025 (DiaInicio, Inicio, Fin, Turno, Solapa, Renglon, Maquinista, Maquinista_Cod, Maquinista_Nombre, 
                          ID, ID_Limpio, Maquina_Parada, Preparacion, Produccion, Mantenimiento, CantidadBuenosProducida, 
                          CantidadMalosProducida, codproducto)
VALUES 
('2025-03-03', '08:45:32', '10:30:15', 'Mañana', 'Conf Sobres', 201, '1209 CORTIZO WALTER', '1209', 'CORTIZO WALTER', 
 'FAM 26446', 26446, '00:30:00', '00:20:00', '01:00:00', '00:10:00', 3620, 0, '6500'),
('2025-03-04', '09:30:00', '11:00:00', 'Tarde', 'Impresión', 125, '1300 LOPEZ JUAN', '1300', 'LOPEZ JUAN', 
 'TEC 671', 671, '00:15:00', '00:30:00', '01:15:00', '00:20:00', 4100, 5, 'ZSSUP18CV');

--Insertar datos en VinculadaUnion_2025 (Debe ser lo último)
INSERT INTO VinculadaUnion_2025 (OP, OP_Limpio, saccod1, Alto, Ancho, Alto_V, Ancho_V)
VALUES 
('OP 26446', 26446, '002/2', 150, 200, 160, 210),
('OP 671', 671, '388/2', 180, 250, 190, 260);

--PASO 2: Verificar que todo funciona

--Verificar ConArbol_2025
SELECT * FROM ConArbol_2025;

--Verificar ConCubo_2025
SELECT ID_Limpio, Renglon, Maquina_Parada, Preparacion, Produccion, Mantenimiento, Tiempo_Total 
FROM ConCubo_2025;

--Verificar VinculadaUnion_2025
SELECT * FROM VinculadaUnion_2025;

ALTER TABLE ConCubo_2025
DROP COLUMN Tiempo_Total;

ALTER TABLE ConCubo_2025
ADD Tiempo_Total AS (
    CONVERT(TIME, DATEADD(SECOND, 
        DATEDIFF(SECOND, '00:00:00', Maquina_Parada) + 
        DATEDIFF(SECOND, '00:00:00', Preparacion) + 
        DATEDIFF(SECOND, '00:00:00', Produccion) + 
        DATEDIFF(SECOND, '00:00:00', Mantenimiento), 
    '00:00:00'))
);

SELECT ID_Limpio, Renglon, Maquina_Parada, Preparacion, Produccion, Mantenimiento, Tiempo_Total 
FROM ConCubo_2025;

DELETE FROM VinculadaUnion_2025;
DELETE FROM ConCubo_2025;
DELETE FROM ConArbol_2025;

SELECT * FROM VinculadaUnion_2025;
SELECT * FROM ConCubo_2025;
SELECT * FROM ConArbol_2025;

EXEC sp_fkeys 'ConCubo_2025';
EXEC sp_fkeys 'VinculadaUnion_2025';
