import pandas as pd  

archivo_cubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_filtrado.csv"

try:
    df_cubo = pd.read_csv(archivo_cubo, sep=";", encoding="utf-8-sig", on_bad_lines="warn")
    print(df_cubo.head())  # Ver las primeras filas
except Exception as e:
    print(f"Error al leer el archivo: {e}")


import pandas as pd  

archivo_cubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_filtrado.csv"

try:
    df_cubo = pd.read_csv(archivo_cubo, sep=";", encoding="utf-8-sig", on_bad_lines="skip")
    print(f"Cantidad de columnas detectadas: {len(df_cubo.columns)}")
    print(df_cubo.head())  # Ver las primeras filas
except Exception as e:
    print(f"Error al leer el archivo: {e}")


with open(archivo_cubo, "r", encoding="utf-8-sig") as file:
    print("Primera línea del archivo:", file.readline())
    
    
import pandas as pd  

archivo_cubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_filtrado.csv"

try:
    df_cubo = pd.read_csv(archivo_cubo, sep=",", encoding="utf-8-sig", on_bad_lines="skip")
    print(f"Cantidad de columnas detectadas: {len(df_cubo.columns)}")
    print(df_cubo.head())  # Ver las primeras filas
except Exception as e:
    print(f"Error al leer el archivo: {e}")

print(df_cubo.head(10))  # Ver las primeras 10 filas
print(df_cubo.columns)  # Ver los nombres de las columnas
