import pandas as pd

ruta = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\ConCubo_filtrado.csv"

try:
    df = pd.read_csv(ruta, sep=None, engine="python", encoding="utf-8-sig")
    print(f"✅ Archivo leído correctamente. Tiene {df.shape[0]} filas y {df.shape[1]} columnas.")
    print(df.head())  # Mostrar las primeras filas
except Exception as e:
    print(f"❌ Error al leer el archivo: {e}")


import pandas as pd

ruta = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\ConArbol_legible.csv"

try:
    df = pd.read_csv(ruta, sep=None, engine="python", encoding="utf-8-sig")
    print(f"✅ Archivo leído correctamente. Tiene {df.shape[0]} filas y {df.shape[1]} columnas.")
    print(df.head())  # Mostrar las primeras filas
except Exception as e:
    print(f"❌ Error al leer el archivo: {e}")
    
    
import pandas as pd

ruta = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\Consolidado.csv"

try:
    df = pd.read_csv(ruta, sep=None, engine="python", encoding="utf-8-sig")
    print(f"✅ Archivo leído correctamente. Tiene {df.shape[0]} filas y {df.shape[1]} columnas.")
    print(df.head())  # Mostrar las primeras filas
except Exception as e:
    print(f"❌ Error al leer el archivo: {e}")
    
    
import pandas as pd

# Ruta del archivo
archivo = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\ConArbol_legible.csv"

# Intentamos leer el CSV
try:
    df = pd.read_csv(archivo, encoding="utf-8-sig")
    print("✅ Archivo leído correctamente")
    print(f"📊 Filas: {df.shape[0]}, Columnas: {df.shape[1]}")

    # Mostramos los nombres de las columnas
    print("\n📝 Columnas del archivo:")
    print(df.columns)

    # Filtramos para ver si hay datos desde 1/1/2025 y de la máquina 201
    df["HoraInicio_legible"] = pd.to_datetime(df["HoraInicio_legible"], errors='coerce')
    df_filtrado = df[(df["HoraInicio_legible"] >= "2025-01-01") & (df["ID"] == 201)]

    # Mostramos resultados del filtro
    print(f"\n🔎 Datos desde 1/1/2025 y máquina 201: {df_filtrado.shape[0]} filas")
    print(df_filtrado.head())

except Exception as e:
    print(f"❌ Error: {e}")


import pandas as pd

archivo = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\ConArbol_legible.csv"

# Intentar con diferentes separadores
for sep in [",", ";", "\t"]:
    try:
        df = pd.read_csv(archivo, sep=sep, encoding="utf-8-sig")
        print(f"\n✅ Archivo leído correctamente con separador '{sep}'")
        print(f"📊 Filas: {df.shape[0]}, Columnas: {df.shape[1]}")
        print(df.head())
        break  # Si funciona, terminamos el bucle
    except Exception as e:
        print(f"❌ Error con separador '{sep}': {e}")


