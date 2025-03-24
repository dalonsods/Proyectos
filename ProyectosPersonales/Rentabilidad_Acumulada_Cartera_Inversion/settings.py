"""
Este fichero se usará para definir la configuración principal de la rentabilidad a visualizar
- Fecha de inicio
- Fecha de fin
- Acciones (tickers de todas las acciones que en algún momento han estado en cartera)
- Dinero total invertido durante el periodo (suma total añadida a la cuenta)

En este fichero también se debe configurar la compra y venta de acciones, que se añadirán al ejecutar el fichero.
Al final del fichero se puede comprobar un ejemplo de creación de la cartera.
"""
import os
import database as db
from datetime import datetime
from database import insert_transaccion


# Ejemplo de inicialización de parámetros
CAPITAL_TOTAL_INGRESADO = 20000
FECHA_INICIO = "2023-09-01"
FECHA_HOY = datetime.now().strftime("%Y-%m-%d")
ACCIONES = ["MSFT", "AAPL", "GOOGL", "AMZN", "NVDA", "EURUSD=X"]  # Necesario añadir cambio de divisa


if __name__ == "__main__":

	# Si no existe la base de datos se crea
	if not os.path.isfile(db.DB_PATH):
		db.create_db()

	# Añadimos las acciones compradas
	# (Esto solo se debe ejecutar una vez, en veces posteriores añadir solo las nuevas compras/ventas)

	# Insertar compra de 100 acciones NVDA a 45.50 el dia 2023-09-08
	insert_transaccion("NVDA", "2023-09-08", 100, 45.50, 4550, 4251.54, 1.0702, 2, 4251.54)

	# Insertar compra de 10 acciones MSFT a 334.20 el dia 2023-09-08
	insert_transaccion("MSFT", "2023-09-08", 10, 334.20, 3342, 3122.78, 1.0702, 2, 3124.78)

	# Insertar compra de 10 acciones AMZN a 138.20 el dia 2023-09-08
	insert_transaccion("AMZN", "2023-09-08", 10, 138.20, 1382, 1291.34, 1.0702, 2, 1293.34)

	# Insertar compra de 10 acciones AAPL a 178.10 el dia 2023-09-08
	insert_transaccion("AAPL", "2023-09-08", 10, 178.10, 1781, 1664.17, 1.0702, 2, 1666.17)

	# Insertar compra de 10 acciones GOOGL a 136.35 el dia 2023-09-08
	insert_transaccion("GOOGL", "2023-09-08", 10, 136.30, 1363, 1273.59, 1.0702, 2, 1275.59)
