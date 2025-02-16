import pyodbc
import pandas as pd

# Conexión a SQL Server
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=DESKTOP-UFKKV4B\\SQLEXPRESS;"
    "DATABASE=Sispro_Restaurada_ML;"
    "Trusted_Connection=yes;"
)

# Query para extraer los datos de la tabla
query = "SELECT * FROM ConArbol_desde_Nov24;"

# Leer los datos con pandas
df = pd.read_sql(query, conn)

# Guardar en CSV
ruta_guardado = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\ConArbol_desde_Nov24.csv"
df.to_csv(ruta_guardado, index=False, sep=";", encoding="utf-8-sig")

# Cerrar la conexión
conn.close()

print("✅ Exportación completada: ConArbol_desde_Nov24.csv")


import pandas as pd

ruta_csv = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_desde_Nov24.csv"

df = pd.read_csv(ruta_csv, delimiter=";", encoding="utf-8")  # Si falla, probar encoding="latin1"
print(df.head(10))
