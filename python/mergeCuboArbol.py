import pandas as pd

# 📂 Rutas de los archivos
archivo_arbol = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_legible.csv"
archivo_cubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_filtrado.csv"
archivo_salida = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/Consolidado.csv"

# 📌 Cargar los archivos asegurando el separador correcto
df_arbol = pd.read_csv(archivo_arbol, sep=";", encoding="utf-8-sig")
df_cubo = pd.read_csv(archivo_cubo, sep=";", encoding="utf-8-sig")

# 📊 Mostrar las columnas para verificar
print("📊 Columnas en ConArbol:", df_arbol.columns.tolist())
print("📊 Columnas en ConCubo:", df_cubo.columns.tolist())

# 📌 Asegurar que las claves de merge sean del mismo tipo
df_arbol["ID"] = df_arbol["ID"].astype(str)
df_cubo["ID"] = df_cubo["ID"].astype(str)

# 📌 Realizar el merge
df_merged = df_arbol.merge(df_cubo, on="ID", how="inner")

# 📌 Guardar el archivo final
df_merged.to_csv(archivo_salida, index=False, sep=";", encoding="utf-8-sig")

print(f"✅ Merge exitoso. Archivo guardado en: {archivo_salida}")
print(df_merged.head())  # Mostrar las primeras filas para verificar
