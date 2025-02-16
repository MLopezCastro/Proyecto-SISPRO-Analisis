import pandas as pd
from datetime import datetime, timedelta

# 📂 Cargar el archivo
archivo = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\ConCubo_desde_Nov24.csv"
df = pd.read_csv(archivo)

# 🔍 Filtrar solo la máquina 201
df = df[df["Renglon"] == 201].copy()

# 🆔 Crear la columna de "ID limpio"
df["ID_limpio"] = "FAM 400"  # Si necesitas algo más dinámico, dime cómo

# ⏳ Convertir tiempos de Inicio y Fin
# Vamos a asumir que 4500.66523 es "días desde un punto de referencia"
referencia = datetime(1900, 1, 1)  # Puede ser otro si lo necesitas
df["Inicio_legible"] = df["Inicio"].apply(lambda x: referencia + timedelta(days=x))
df["Fin_legible"] = df["Fin"].apply(lambda x: referencia + timedelta(days=x))

# 📄 Guardar el archivo filtrado y corregido
salida = r"C:\Users\mlope\OneDrive\Escritorio\MLopezCastro\Proyecto-SISPRO-Analisis\python\ConCubo_filtrado.csv"
df.to_csv(salida, index=False)

print("✅ Archivo procesado y guardado en:", salida)


# Ver nombres de las columnas
print("📝 Columnas en el DataFrame:", df.columns)

# Ver las primeras filas del DataFrame
print(df.head())

# Ver info general del DataFrame
print(df.info())


import pandas as pd

# Cargar el archivo limpio
df = pd.read_csv("limpiar_ConCubo.csv")



