from datetime import timedelta
import yfinance as yf
import pandas as pd
from settings import *


def update():
	for accion in ACCIONES:
		print(f"Comienzo de actualización de {accion}")
		ultima = db.last_update(accion)
		divisa = yf.Ticker(accion).info["currency"]

		# Si hay última actualización
		inicio = max((datetime.strptime(ultima, "%Y-%m-%d") + timedelta(days=1)).strftime("%Y-%m-%d"), FECHA_INICIO) if ultima else FECHA_INICIO

		# El manejo de cambio de divisa sera diferente, por lo que excluimos
		if accion != "EURUSD=X":
			while inicio < FECHA_HOY:
				inicio_en_date = datetime.strptime(inicio, "%Y-%m-%d")

				precio_cierre = obtener_precio_cierre_accion(accion, inicio)
				db.insert_historico(accion, inicio, divisa, precio_cierre)

				print(f"Actualizado día {inicio}")
				inicio_en_date += timedelta(days=1)
				inicio = inicio_en_date.strftime("%Y-%m-%d")

		# Manejo de cambio de divisa
		else:
			while inicio < FECHA_HOY:
				inicio_en_date = datetime.strptime(inicio, "%Y-%m-%d")

				precio_cierre = obtener_precio_cierre_cambio(accion, inicio)
				db.insert_historico(accion, inicio, divisa, precio_cierre)

				print(f"Actualizado día {inicio}")
				inicio_en_date += timedelta(days=1)
				inicio = inicio_en_date.strftime("%Y-%m-%d")

		print(f"Final de actualización de {accion}")


def obtener_precio_cierre_accion(symbol, fecha):
	# Crear un objeto Ticker para el símbolo proporcionado
	accion = yf.Ticker(symbol)

	# Obtener datos históricos para la fecha especificada
	datos_historicos = accion.history(start=fecha, end=(pd.to_datetime(fecha) + pd.DateOffset(days=1)).strftime('%Y-%m-%d'))

	# Obtener el precio de cierre
	precio_cierre = datos_historicos['Close'].values[0] if not datos_historicos.empty else obtener_precio_cierre_accion(symbol, (pd.to_datetime(fecha) + pd.DateOffset(days=-1)).strftime('%Y-%m-%d'))
	return precio_cierre


def obtener_precio_cierre_cambio(symbol, fecha):
	# Obtener datos históricos para la fecha especificada
	datos_historicos = None
	while datos_historicos is None:
		datos_historicos = try_historico(symbol, fecha)
		fecha = (pd.to_datetime(fecha) + pd.DateOffset(days=-1)).strftime('%Y-%m-%d')
	fecha = (pd.to_datetime(fecha) + pd.DateOffset(days=+1)).strftime('%Y-%m-%d')

	# Obtener el precio de cierre
	precio_cierre = datos_historicos['Close'].values[0] if not datos_historicos.empty else obtener_precio_cierre_accion(symbol, (pd.to_datetime(fecha) + pd.DateOffset(days=-1)).strftime('%Y-%m-%d'))
	return precio_cierre


def try_historico(symbol, fecha):
	# Crear un objeto Ticker para el símbolo proporcionado
	accion = yf.Ticker(symbol)
	# Obtener datos históricos para la fecha especificada
	try:
		return accion.history(start=fecha, end=(pd.to_datetime(fecha) + pd.DateOffset(days=1)).strftime('%Y-%m-%d'))

	except:
		return None


def rentabilidad_diaria_euros(inicio, fin):
	"""Esta función calcula la rentabilidad acumulada para cada día del rango indicado. Lo hace en euros,
	es decir, pasa el valor de las acciones americanas a euros antes de calcular rentabilidad. Tiene en cuenta los tipos
	de cambio de ese día"""

	dias = []
	rentabilidades = []

	while inicio < fin:

		tipo_cambio = db.read_historico_valor(ACCIONES[-1], inicio)
		acciones = ACCIONES[:-1]
		posiciones = {accion: [0, 0, 0] for accion in acciones}
		euros_iniciales = CAPITAL_TOTAL_INGRESADO
		euros_gastados = 0
		euros_potenciales = 0

		for accion in acciones:
			poss = db.read_transacciones_accion(accion, inicio)
			for pos in poss:
				euros_gastados += pos[5]
				posiciones[accion][0] += pos[2]
				posiciones[accion][1] += pos[5]
				posiciones[accion][2] += pos[4]

		for accion in acciones:
			euros_potenciales += posiciones[accion][0] * db.read_historico_valor(accion, inicio) / db.read_historico_valor("EURUSD=X", inicio)

		# El caulculo de rentabilidades es sobre toda la cartera, teniendo en cuenta el capital no invertido.
		# Ej: si se tienen 1000€ en acciones y 19000 sin invertir y las acciones se duplican, la rentabilidad es 5% no 100%
		euros_potenciales += (euros_iniciales - euros_gastados)
		rentabilidad = (euros_potenciales / euros_iniciales - 1) * 100

		dias.append(inicio)
		rentabilidades.append(rentabilidad)

		inicio = (pd.to_datetime(inicio) + pd.DateOffset(days=1)).strftime('%Y-%m-%d')

	return dias, rentabilidades


def rentabilidad_diaria_dollar(inicio, fin):
	"""Esta función calcula la rentabilidad acumulada para cada día del rango indicado. Lo hace en dólares"""

	dias = []
	rentabilidades = []

	while inicio < fin:

		tipo_cambio = db.read_historico_valor(ACCIONES[-1], inicio)
		acciones = ACCIONES[:-1]
		posiciones = {accion: [0, 0, 0] for accion in acciones}
		euros_iniciales = CAPITAL_TOTAL_INGRESADO
		euros_gastados = 0
		dolares_gastados = 0
		dolares_potenciales = 0

		for accion in acciones:
			poss = db.read_transacciones_accion(accion, inicio)
			for pos in poss:
				euros_gastados += pos[5]
				dolares_gastados += pos[4]
				posiciones[accion][0] += pos[2]
				posiciones[accion][1] += pos[5]
				posiciones[accion][2] += pos[4]

		for accion in acciones:
			dolares_potenciales += posiciones[accion][0] * db.read_historico_valor(accion, inicio)

		# El caulculo de rentabilidades es sobre toda la cartera, teniendo en cuenta el capital no invertido.
		# Ej: si se tienen 1000 en acciones y 19000 sin invertir y las acciones se duplican, la rentabilidad es 5% no 100%
		rentabilidad = (dolares_potenciales / dolares_gastados - 1) * 100 * (euros_gastados / euros_iniciales) if dolares_gastados > 0 else 0

		dias.append(inicio)
		rentabilidades.append(rentabilidad)

		inicio = (pd.to_datetime(inicio) + pd.DateOffset(days=1)).strftime('%Y-%m-%d')

	return dias, rentabilidades
