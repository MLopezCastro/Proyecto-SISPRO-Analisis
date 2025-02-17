import pandas as pd

# 📂 Ruta del archivo original (ajústala si es necesario)
archivo_original = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_legible.csv"

# 📂 Ruta del archivo filtrado (donde se guardará el resultado)
archivo_filtrado = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_filtrado.csv"

# 📅 Fecha de inicio para el filtro (ajusta según necesites)
fecha_inicio = "2025-01-01"

# 🔄 Intentamos leer el archivo con diferentes separadores
try:
    df = pd.read_csv(archivo_original, sep=",", parse_dates=["HoraInicio_legible"], dayfirst=True)
    print("✅ Archivo leído correctamente con `,`")
except:
    print("⚠️ Error con `,`, intentando con `;`...")
    df = pd.read_csv(archivo_original, sep=";", parse_dates=["HoraInicio_legible"], dayfirst=True)
    print("✅ Archivo leído correctamente con `;`")

# 📋 Mostramos las columnas para verificar nombres
print("📋 Columnas en el archivo:", df.columns.tolist())

# 📌 Filtramos por "Renglones" y la fecha mínima
df_filtrado = df[(df["Renglones"] == 201) & (df["HoraInicio_legible"] >= fecha_inicio)]

# 💾 Guardamos el archivo filtrado
df_filtrado.to_csv(archivo_filtrado, index=False, sep=";")

print(f"✅ Archivo filtrado guardado en: {archivo_filtrado}")
print(f"📊 Filas finales: {len(df_filtrado)}")


import pandas as pd

archivo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_legible.csv"

# Intentamos detectar el separador
with open(archivo, "r", encoding="utf-8-sig") as f:
    primera_linea = f.readline()
    print("🔍 Primera línea del archivo:\n", primera_linea)

# Intentamos leer con diferentes separadores
for sep in [",", ";", "\t", "|"]:
    try:
        df = pd.read_csv(archivo, sep=sep, nrows=5)
        print(f"\n✅ CSV leído con separador: '{sep}'")
        print("🔹 Columnas detectadas:", df.columns.tolist())
        break  # Si se lee bien, salimos del bucle
    except Exception as e:
        print(f"❌ Error con separador '{sep}':", e)


print(df.dtypes)  # Ver tipos de datos
print(df["HoraInicio_legible"].head(10))  # Ver primeras 10 fechas

df["HoraInicio_legible"] = pd.to_datetime(df["HoraInicio_legible"], format="%H:%M:%S", errors="coerce")
print(df.dtypes)


df["HoraInicio_legible"] = pd.to_datetime(df["HoraInicio_legible"], format="%Y-%m-%d %H:%M:%S", errors="coerce")

print(df.dtypes)
print(df["HoraInicio_legible"].head(10))
