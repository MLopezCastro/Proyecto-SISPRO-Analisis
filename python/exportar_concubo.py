import pyodbc
import pandas as pd

# Conexión a SQL Server
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=DESKTOP-UFKKV4B\\SQLEXPRESS;"
    "DATABASE=Sispro_Restaurada_ML;"
    "Trusted_Connection=yes;"
)

# Consulta SQL con el filtro desde noviembre 2024
query = """
SELECT *  
FROM ConCubo  
WHERE DiaInicio >= '2024-11-01';
"""

# Cargar los datos en un DataFrame de pandas
df = pd.read_sql(query, conn)

# Guardar en un CSV
ruta_csv = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_desde_Nov24.csv"
df.to_csv(ruta_csv, index=False, encoding='utf-8-sig')

# Cerrar conexión
conn.close()

print(f"✅ Exportación completada: {ruta_csv}")
