import pandas as pd

# Definir las rutas de los archivos CSV
ruta_concubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_desde_Nov24.csv"
ruta_conarbol = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_desde_Nov24.csv"
ruta_vinculada = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/TablaVinculadaUNION_desde_Nov24.csv"

try:
    # Leer CSVs con detección de delimitador automática (por si acaso)
    df_concubo = pd.read_csv(ruta_concubo, sep=None, engine="python", encoding="utf-8-sig")
    df_conarbol = pd.read_csv(ruta_conarbol, sep=";", encoding="utf-8-sig")
    df_vinculada = pd.read_csv(ruta_vinculada, sep=";", encoding="utf-8-sig")

    print("✅ Archivos CSV cargados correctamente.\n")

    # Mostrar los nombres de las columnas correctamente
    print("📌 Columnas en ConCubo:", df_concubo.columns.tolist(), "\n")
    print("📌 Columnas en ConArbol:", df_conarbol.columns.tolist(), "\n")
    print("📌 Columnas en TablaVinculadaUNION:", df_vinculada.columns.tolist(), "\n")

except Exception as e:
    print(f"❌ Error cargando CSVs: {e}")


