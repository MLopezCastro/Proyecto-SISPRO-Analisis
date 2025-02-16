import pyodbc
import pandas as pd

# Conexión a SQL Server
server = "DESKTOP-UFKKV4B\\SQLEXPRESS"  # Asegúrate de que este sea tu servidor correcto
database = "Sispro_Restaurada_ML"
conn = pyodbc.connect(
    f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={server};DATABASE={database};Trusted_Connection=yes"
)

# Query para extraer los datos
query = """
SELECT * FROM TablaVinculadaUNION_desde_Nov24;
"""

# Ejecutar query y guardar en DataFrame
df = pd.read_sql(query, conn)

# Ruta donde se guardará el archivo CSV
ruta_guardado = "C:\\Users\\mlope\\OneDrive\\Escritorio\\MLopezCastro\\Proyecto-SISPRO-Analisis\\python\\TablaVinculadaUNION_desde_Nov24.csv"

# Exportar a CSV con separación por punto y coma y codificación UTF-8
df.to_csv(ruta_guardado, index=False, sep=";", encoding="utf-8-sig")

print("✅ Exportación completada: TablaVinculadaUNION_desde_Nov24.csv")

# Cerrar la conexión
conn.close()
