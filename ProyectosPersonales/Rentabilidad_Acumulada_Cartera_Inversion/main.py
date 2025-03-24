import time

import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import finance
from settings import *


print("Actualizando la base de datos...")
print("Si no ha sido actualizada o las fechas son muy antiguas este proceso puede llevar tiempo.")
time.sleep(0.5)
finance.update()

# Generar datos de ejemplo
fechas, porcentajes = finance.rentabilidad_diaria_euros(FECHA_INICIO, FECHA_HOY)
fechas2, porcentajes2 = finance.rentabilidad_diaria_dollar(FECHA_INICIO, FECHA_HOY)
fechas = [datetime.strptime(fecha, '%Y-%m-%d') for fecha in fechas]

# Crear el gráfico de líneas
plt.figure(figsize=(10, 6))
plt.plot(fechas, porcentajes, marker='o', linestyle='-', label='Rentabilidad € (%)')
plt.plot(fechas, porcentajes2, marker='x', linestyle='--', label='Rentabilidad $ (%)')

# Configurar el formato de las fechas en el eje X
plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
plt.gca().xaxis.set_major_locator(mdates.DayLocator())
plt.gcf().autofmt_xdate()

# Agregar una línea horizontal en el eje Y en y=0
plt.axhline(y=0, color='black', linestyle='--', linewidth=1, label='Y=0')

# Agregar líneas verticales al comienzo de cada mes
for fecha in fechas:
    if fecha.day == 1:
        plt.axvline(x=fecha, color='black', linestyle=':', linewidth=1)

# Configurar el eje Y para mostrar todos los enteros
plt.yticks(range(int(min(porcentajes + porcentajes2))-1, int(max(porcentajes + porcentajes2))+1))

# Etiquetas y título
plt.xlabel('Fechas')
plt.ylabel('Porcentaje')
plt.title('Revalorización acumulada de la cartera (cash incluido)')

# Mostrar el gráfico
plt.legend()  # Agregar leyenda
plt.show()
