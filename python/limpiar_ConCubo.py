import pandas as pd
import numpy as np

df["ID"] = df["ID"].astype(str)  # Convertir a string
df["ID_limpio"] = df["ID"].str.extract("(\d+)")






# Cargar ConCubo filtrado (máquina 201)
ruta_concubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_filtrado_201.csv"
df = pd.read_csv(ruta_concubo, sep=";", encoding="utf-8-sig")

# 🔹 1. Convertir 'Inicio' y 'Fin' a formato datetime
# Multiplicamos por 86400 (segundos en un día) y sumamos a la fecha base de Excel (1899-12-30)
df["Inicio_dt"] = pd.to_datetime("1899-12-30") + pd.to_timedelta(df["Inicio"] * 86400, unit="s")
df["Fin_dt"] = pd.to_datetime("1899-12-30") + pd.to_timedelta(df["Fin"] * 86400, unit="s")

# 🔹 2. Crear columna de ID limpio (extraer solo el número)
df["ID_limpio"] = df["ID"].str.extract("(\d+)")  # Extrae solo los números

# 🔹 3. Revisamos si todo salió bien
print(df[["Inicio", "Inicio_dt", "Fin", "Fin_dt", "ID", "ID_limpio"]].head())

# 🔹 4. Guardamos un nuevo archivo limpio
ruta_salida = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_filtrado_201_limpio.csv"
df.to_csv(ruta_salida, index=False, sep=";", encoding="utf-8-sig")

print(f"✅ Archivo guardado: {ruta_salida}")
