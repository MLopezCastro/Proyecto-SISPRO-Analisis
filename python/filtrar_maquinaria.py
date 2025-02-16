import pandas as pd

# 📌 Rutas de los archivos CSV
ruta_concubo = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_desde_Nov24.csv"
ruta_conarbol = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_desde_Nov24.csv"
ruta_vinculada = "C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/TablaVinculadaUNION_desde_Nov24.csv"

# 📌 Cargar los archivos CSV
try:
    df_concubo = pd.read_csv(ruta_concubo, sep=";", encoding="utf-8-sig")
    df_conarbol = pd.read_csv(ruta_conarbol, sep=";", encoding="utf-8-sig")
    df_vinculada = pd.read_csv(ruta_vinculada, sep=";", encoding="utf-8-sig")
    print("✅ Archivos CSV cargados correctamente.\n")

    # 📌 Verificar valores únicos antes de filtrar
    print("🔍 Valores únicos en ConCubo - Renglon:", df_concubo["Renglon"].unique())
    print("\n🔍 Valores únicos en ConArbol - CodigoRenglon:", df_conarbol["CodigoRenglon"].unique())
    print("\n🔍 Valores únicos en TablaVinculadaUNION - saccod1:", df_vinculada["saccod1"].unique())

    # 📌 Aplicar el filtrado por máquina 201
    df_concubo_filtrado = df_concubo[df_concubo["Renglon"] == 201]
    df_conarbol_filtrado = df_conarbol[df_conarbol["CodigoRenglon"] == 201]
    df_vinculada_filtrada = df_vinculada[df_vinculada["saccod1"] == 201]

    # 📌 Mostrar cuántas filas quedaron después del filtrado
    print(f"\n📌 Filtrado ConCubo: {len(df_concubo_filtrado)} filas")
    print(f"📌 Filtrado ConArbol: {len(df_conarbol_filtrado)} filas")
    print(f"📌 Filtrado TablaVinculadaUNION: {len(df_vinculada_filtrada)} filas")

    # 📌 Guardar los archivos filtrados
    df_concubo_filtrado.to_csv("C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConCubo_maquina201.csv", index=False, sep=";", encoding="utf-8-sig")
    df_conarbol_filtrado.to_csv("C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/ConArbol_maquina201.csv", index=False, sep=";", encoding="utf-8-sig")
    df_vinculada_filtrada.to_csv("C:/Users/mlope/OneDrive/Escritorio/MLopezCastro/Proyecto-SISPRO-Analisis/python/TablaVinculadaUNION_maquina201.csv", index=False, sep=";", encoding="utf-8-sig")

    print("\n✅ Exportación de archivos filtrados completada.")

except Exception as e:
    print(f"\n❌ Error: {e}")
