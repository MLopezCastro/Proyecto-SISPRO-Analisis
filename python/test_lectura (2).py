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