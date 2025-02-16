import pandas as pd
import os

# 📂 RUTA DEL ARCHIVO
ruta_base = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python"
archivo_conarbol = os.path.join(ruta_base, "ConArbol_desde_Nov24V2.csv")
archivo_salida = os.path.join(ruta_base, "ConArbol_legible.csv")

# 📌 Cargar ConArbol
df_arbol = pd.read_csv(archivo_conarbol, sep=";", encoding="utf-8-sig")

# 📌 Función para convertir HoraInicio (formato Excel a datetime)
def convertir_hora_excel(numero):
    return pd.to_datetime("1899-12-30") + pd.to_timedelta(numero, unit="D")  # Ajuste de Excel

df_arbol["HoraInicio_legible"] = df_arbol["HoraInicio"].apply(convertir_hora_excel)

# 📌 Función para convertir horas decimales a HH:MM:SS
def horas_a_hms(horas):
    return pd.to_timedelta(horas, unit="h")  # Convierte de horas a timedelta

df_arbol["CantidadHoras_legible"] = df_arbol["CantidadHoras"].apply(horas_a_hms)
df_arbol["CantidadHorasProgProd_legible"] = df_arbol["CantidadHorasProgProd"].apply(horas_a_hms)
df_arbol["CantidadHorasProgPrep_legible"] = df_arbol["CantidadHorasProgPrep"].apply(horas_a_hms)

# 📌 Guardar el archivo modificado
df_arbol.to_csv(archivo_salida, index=False, sep=";", encoding="utf-8-sig")

# 📌 Verificar
print(f"✅ Archivo modificado guardado en: {archivo_salida}")
print(df_arbol[["HoraInicio", "HoraInicio_legible", "CantidadHoras", "CantidadHoras_legible"]].head())

# 🚀 ❌ Elimina esta línea incorrecta:
# df.to_csv("ConArbol_legible.csv", index=False, sep=";", encoding="utf-8-sig")


import pandas as pd

# Rutas de los archivos
archivo_arbol = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_legible.csv"
archivo_cubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_filtrado.csv"

# Prueba con `;`
try:
    df_arbol = pd.read_csv(archivo_arbol, sep=";", encoding="utf-8-sig")
    df_cubo = pd.read_csv(archivo_cubo, sep=";", encoding="utf-8-sig")
    print("✅ CSV leído con `;` correctamente")
except Exception as e:
    print("❌ Error con `;`: ", e)

# Prueba con `,`
try:
    df_arbol_coma = pd.read_csv(archivo_arbol, sep=",", encoding="utf-8-sig")
    df_cubo_coma = pd.read_csv(archivo_cubo, sep=",", encoding="utf-8-sig")
    print("✅ CSV leído con `,` correctamente")
except Exception as e:
    print("❌ Error con `,`: ", e)



import pandas as pd  

archivo_arbol = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_legible.csv"

try:
    df_arbol = pd.read_csv(archivo_arbol, sep=";", encoding="utf-8-sig", on_bad_lines="skip")
    print(f"Cantidad de columnas detectadas: {len(df_arbol.columns)}")
    print("Columnas:", df_arbol.columns.tolist())
    print(df_arbol.head())  # Ver las primeras filas
except Exception as e:
    print(f"Error al leer el archivo: {e}")
    
    
df_arbol = pd.read_csv(archivo_arbol, sep=",", encoding="utf-8-sig", on_bad_lines="skip")
print(f"Columnas detectadas: {df_arbol.shape[1]}")
print(df_arbol.head())

import pandas as pd

archivo = "ruta/del/archivo.csv"

try:
    df = pd.read_csv(archivo, sep=",", encoding="utf-8-sig")
    print("✅ CSV leído correctamente con `,`")
except:
    print("❌ Error con `,`, probando con `;`")

try:
    df = pd.read_csv(archivo, sep=";", encoding="utf-8-sig")
    print("✅ CSV leído correctamente con `;`")
except:
    print("❌ Error con `;`, revisa el formato del archivo")
    
    
import csv

with open(archivo, "r", encoding="utf-8-sig") as f:
    dialect = csv.Sniffer().sniff(f.read(1024))
    delimitador_detectado = dialect.delimiter

df = pd.read_csv(archivo, sep=delimitador_detectado, encoding="utf-8-sig")
print(f"✅ CSV leído con delimitador detectado: `{delimitador_detectado}`")

import pandas as pd
import csv

archivo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_legible.csv"

# Detectar delimitador automáticamente
with open(archivo, "r", encoding="utf-8-sig") as f:
    dialect = csv.Sniffer().sniff(f.read(1024))
    delimitador_detectado = dialect.delimiter

# Leer CSV con delimitador detectado
df = pd.read_csv(archivo, sep=delimitador_detectado, encoding="utf-8-sig")
print(f"✅ CSV leído correctamente con delimitador: `{delimitador_detectado}`")
print(df.head())

import chardet

archivo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_legible.csv"

with open(archivo, "rb") as f:
    resultado = chardet.detect(f.read(100000))  # Lee una parte del archivo
    print(f"📌 Codificación detectada: {resultado['encoding']}")

