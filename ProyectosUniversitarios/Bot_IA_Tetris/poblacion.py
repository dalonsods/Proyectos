from datetime import datetime
from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.settings import *

from ProyectosUniversitarios.Bot_IA_Tetris.brain import Brain
import random


class Poblacion:
	def __init__(self):
		self.num_individuos = 100
		self.num_max_piezas = 500
		self.intentos = 4
		self.ratio_nuevos = 0.3
		self.random_selection = 0.1
		self.ratio_mutacion = 0.07
		self.num_generacion = 1
		self.generacion = self.first_brains()
		self.vivos = self.num_individuos

	@property
	def vivos(self):
		return self._vivos

	@vivos.setter
	def vivos(self, value):
		self._vivos = value
		if value <= 0:
			self.fin_generacion()
			self._vivos = self.num_individuos

	def fin_cerebro(self):
		# Calculamos cuantos quedan vivos
		vivos = sum(1 for objeto in self.generacion if objeto.game is not None)
		self.vivos = vivos

	def first_brains(self):
		brains = []
		for i in range(self.num_individuos):
			a, b, c, d = [random.uniform(-1.0, 1.0) for _ in range(4)]
			brains.append(Brain(a, b, c, d, self.num_max_piezas, self.intentos, self.fin_cerebro))

		return brains

	def fin_generacion(self):
		best_game = max(self.generacion, key=lambda x: x.total_score)

		print(f"-----------------------------------")
		print(f"Hora: {datetime.now().strftime('%H:%M:%S')}")
		print(f"Resultado de la generación número {self.num_generacion}")
		print(f"Mejor juego: {self.generacion.index(best_game)}")
		print(f"Parámetros: a = {best_game.a}, b = {best_game.b}, c = {best_game.c}, d = {best_game.d}")
		print(f"Puntuación obtenida: {best_game.total_score}")
		seleccion_ordenada = sorted(self.generacion, key=lambda x: x.total_score, reverse=True)
		print(f"Puntuación obtenida por cada individuo: {[x.total_score for x in seleccion_ordenada]}")
		print(f"-----------------------------------")

		self.num_generacion += 1
		self.generacion = self.nueva_generacion()

	def nueva_generacion(self):
		new_brains = []
		numero_nuevos = int(self.num_individuos * self.ratio_nuevos)

		# El 30% de la nueva generación se crea a partir de selección de torneo
		for i in range(numero_nuevos):
			seleccion_aleatoria = random.sample(self.generacion, int(self.num_individuos * self.random_selection))
			seleccion_ordenada = sorted(seleccion_aleatoria, key=lambda x: x.total_score, reverse=True)
			new_brains.append(self.crossover(seleccion_ordenada[0], seleccion_ordenada[1]))

		# El resto, el 70% mejor de la generación que acaba de terminar
		individuos_ordenados = sorted(self.generacion, key=lambda x: x.total_score, reverse=True)
		for i in range(self.num_individuos - numero_nuevos):
			old = individuos_ordenados[i]
			new_brains.append(Brain(old.a, old.b, old.c, old.d, self.num_max_piezas, self.intentos, self.fin_cerebro))

		return new_brains

	def crossover(self, first_brain, second_brain):

		# Combina cerebros dando prioridad al mejor, mientras al mismo tiempo normaliza.
		new_a = first_brain.a * first_brain.total_score + second_brain.a * second_brain.total_score
		new_b = first_brain.b * first_brain.total_score + second_brain.b * second_brain.total_score
		new_c = first_brain.c * first_brain.total_score + second_brain.c * second_brain.total_score
		new_d = first_brain.d * first_brain.total_score + second_brain.d * second_brain.total_score

		# Se divide entre suma de scores (es como hacer una media ponderada de los parámetros)
		if (first_brain.total_score + second_brain.total_score) != 0:
			new_a = new_a / (first_brain.total_score + second_brain.total_score)
			new_b = new_b / (first_brain.total_score + second_brain.total_score)
			new_c = new_c / (first_brain.total_score + second_brain.total_score)
			new_d = new_d / (first_brain.total_score + second_brain.total_score)

		new_brain = Brain(new_a, new_b, new_c, new_d, self.num_max_piezas, self.intentos, self.fin_cerebro)
		new_brain.possible_mutate(self.ratio_mutacion)
		return new_brain


class Main:
	def __init__(self):

		# general
		pygame.init()
		self.display_surface = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
		self.clock = pygame.time.Clock()
		pygame.display.set_caption('Tetris')

		# components
		self.poblacion = Poblacion()

	def run(self):
		while True:
			for event in pygame.event.get():
				if event.type == pygame.QUIT:
					pygame.quit()
					exit()
			for cerebro in self.poblacion.generacion:
				if cerebro.game:
					cerebro.run()


if __name__ == '__main__':
	print(f"Comienzo del entrenamiento con algoritmo genético")
	print(f"En esta terminal se irán poniendo los resultados de cada generación")
	print(f"Cada generación puede llegar a tardar horas")
	print(f"Hora de inicio: {datetime.now().strftime('%H:%M:%S')}")
	main = Main()
	main.run()
