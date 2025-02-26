import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

# Datos del gráfico
regiones = [
    "La Libertad", "Madre de Dios", "Puno", "Ica", "Lambayeque", "San Martín", "Piura",
    "Moquegua", "Huancavelica", "Tumbes", "Ayacucho", "Arequipa", "Huánuco", "Junín",
    "Áncash", "Cajamarca", "Apurímac", "Ucayali", "Tacna", "Pasco", "Loreto", "Cusco", "Amazonas"
]
porcentajes = [1, 6, 10, 13, 14, 15, 16, 18, 18, 19, 22, 22, 26, 27, 28, 31, 33, 38, 43, 43, 60, 70, 71]

# Crear la figura y el gráfico
fig, ax = plt.subplots(figsize=(8, 10))
bars = ax.barh(regiones, porcentajes, color='gray', edgecolor='black')

# Resaltar las regiones con mayor porcentaje (últimos 5 valores)
for i in range(-5, 0):
    bars[i].set_color('black')

# Etiquetas y título en formato APA 7
# ax.set_xlabel("Porcentaje de proyectos programados sin ejecutar", fontsize=12)
# ax.set_ylabel("Región", fontsize=12)
# ax.set_title("Figura 2\nCosto de proyectos programados sin ejecutar al 3T 2023 respecto al costo total de proyectos programados en la PMI", fontsize=14, fontweight='bold')

# ax.set_xlabel("Porcentaje de proyectos programados sin ejecutar", fontsize=12)
ax.set_ylabel("Región", fontsize=12)
# ax.set_title("Figura 2\nCosto de proyectos programados sin ejecutar al 3T 2023 respecto al costo total de proyectos programados en la PMI", fontsize=14, fontweight='bold')


# Mostrar los valores dentro de las barras
for bar, porcentaje in zip(bars, porcentajes):
    ax.text(bar.get_width() + 1, bar.get_y() + bar.get_height()/2, f"{porcentaje}%", va='center', fontsize=10)

# Definir los colores para las barras, manteniendo los originales y cambiando solo los grises
updated_colors = [
     "#66BB6A", "#66BB6A", "#66BB6A", "#66BB6A", "#66BB6A", "#66BB6A"
    ,"#FFB74D", "#FFB74D", "#FFB74D", "#FFB74D", "#FFB74D", "#FFB74D"
    ,"#F8BBD0", "#F8BBD0", "#F8BBD0", "#F8BBD0", "#F8BBD0", "#F8BBD0"
    ,"#CFD8DC", "#CFD8DC", "#CFD8DC", "#CFD8DC", "#CFD8DC"
]


# Crear la figura y el gráfico con los colores actualizados
fig, ax = plt.subplots(figsize=(8, 10))
bars = ax.barh(regiones, porcentajes, color=updated_colors, edgecolor='black')

# Etiquetas y título en formato APA 7
ax.set_xlabel("Porcentaje de proyectos programados sin ejecutar", fontsize=12)
ax.set_ylabel("Región", fontsize=12)
# ax.set_title("Figura 2\nCosto de proyectos programados sin ejecutar al 3T 2023 respecto al costo total de proyectos programados en la PMI", fontsize=14, fontweight='bold')

# Mostrar los valores dentro de las barras
for bar, porcentaje in zip(bars, porcentajes):
    ax.text(bar.get_width() + 1, bar.get_y() + bar.get_height()/2, f"{porcentaje}%", va='center', fontsize=10)

# Agregar la fuente de los datos en formato APA 7
# plt.figtext(0.5, -0.05, "Nota. Los porcentajes reflejan el costo de proyectos programados sin ejecutar al tercer trimestre de 2023 "
#                         "respecto al costo total de proyectos programados en la PMI. \nFuente: Propuestas del Bicentenario (2023), "
#                         "https://propuestasdelbicentenario.pe/wp-content/uploads/2023/11/IREI_3T-2023.pdf.",
# wrap=True, horizontalalignment='center', fontsize=10)

# Invertir el eje Y para mejorar la lectura
plt.gca().invert_yaxis()

# Mostrar el gráfico
plt.show()
