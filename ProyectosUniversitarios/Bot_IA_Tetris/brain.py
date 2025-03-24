import copy
import random

from ProyectosUniversitarios.Bot_IA_Tetris.currentstate import CurrentState
from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.settings import *

# components
from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.game import Game, Tetromino
from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.score import Score
from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.preview import Preview

from random import choice


class Brain:
	def __init__(self, a, b, c, d, max_piezas, max_games, fin_cerebro):

		self.a = a
		self.b = b
		self.c = c
		self.d = d
		self.max_piezas = max_piezas
		self.max_games = max_games
		self.total_score = 0

		self.piezas_restantes = max_piezas
		self.juegos_restantes = max_games
		self.fin_cerebro = fin_cerebro

		# general
		self.display_surface = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
		self.clock = pygame.time.Clock()

		# shapes
		self.next_shapes = [choice(list(TETROMINOS.keys())) for _ in range(3)]
		self.generador = self.choice_equitativo(list(TETROMINOS.keys()))

		# components
		self.current_piece = None
		self.game = Game(self.get_next_shape, self.update_score, self.end_game)
		self.score = Score()
		self.preview = Preview()

	@property
	def juegos_restantes(self):
		return self._juegos_restantes

	@juegos_restantes.setter
	def juegos_restantes(self, value):
		self._juegos_restantes = value
		if value > 0:
			self.piezas_restantes = self.max_piezas
			self.game = Game(self.get_next_shape, self.update_score, self.end_game)
		else:
			self.game = None
			self.fin_cerebro()

	@property
	def piezas_restantes(self):
		return self._piezas_restantes

	@piezas_restantes.setter
	def piezas_restantes(self, value):
		self._piezas_restantes = value
		if value <= 0:
			self.end_game()

	def end_game(self):
		self.total_score += self.score.score
		self.juegos_restantes -= 1

	def update_score(self, lines, score, level):
		self.score.lines = lines
		self.score.score = score
		self.score.level = level

	def get_next_shape(self):
		next_shape = self.next_shapes.pop(0)
		self.next_shapes.append(next(self.generador))
		return next_shape

	@staticmethod
	def choice_equitativo(seq):
		# Iterar de forma continua
		while True:
			# Barajar la lista en cada iteración
			shuffled_seq = list(seq)
			random.shuffle(shuffled_seq)

			# Iterar sobre la lista barajada de forma circular
			for elem in shuffled_seq:
				yield elem

	def play_best_move(self):
		best_move = self.get_best_move()

		for rotation in range(best_move[0]):
			self.game.tetromino.rotate()
		self.game.tetromino.move_horizontal(best_move[1])
		while not self.game.tetromino.next_move_vertical_collide(self.game.tetromino.blocks, 1):
			self.game.tetromino.move_down()

	def get_posible_moves(self):

		# Aquí irán las posiciones finales de las 2 piezas [[move_p1, move_p2], [move_p1, move_p2], ...]
		posiciones_2_piezas = []
		final_moves = []

		# Calculamos los posibles movimientos para la primera pieza
		moves, positions = CurrentState.get_posible_moves(self.game.field_data, self.game.tetromino)

		# Jugaremos cada una de las jugadas de positions y para cada una de ellas calcularemos los posibles movimientos
		# para la segunda pieza
		for jugada in positions:
			tablero_nuevo = [[1 if elem != 0 else 0 for elem in fila] for fila in self.game.field_data]
			CurrentState.add_pieza(tablero_nuevo, jugada)
			segundo_tetro = Tetromino(self.next_shapes[0], pygame.sprite.Group(), self.game.tetromino.create_new_tetromino, self.game.field_data)
			n2_moves, n2_positions = CurrentState.get_posible_moves(tablero_nuevo, segundo_tetro)
			for jugada2 in n2_positions:
				# Añadimos las posiciones finales de las dos piezas de forma: [posición_p1, posición_p2]
				posiciones_2_piezas.append([jugada, jugada2])

				# De move solo guardaremos el relativo a la primera pieza, pues es la que queremos jugar
				final_moves.append(moves[positions.index(jugada)])

		return final_moves, posiciones_2_piezas

	def get_best_move(self):
		real_moves, moves = self.get_posible_moves()
		moves_eval = []
		for move in moves:
			tab = [[1 if elem != 0 else 0 for elem in fila] for fila in self.game.field_data]
			# Añadimos la jugada 1 y 2 al tablero
			CurrentState.add_pieza(tab, move[0])
			CurrentState.add_pieza(tab, move[1])
			# Evaluamos
			moves_eval.append(self.eval_tablero(tab))

		return real_moves[moves_eval.index(max(moves_eval))]

	def eval_tablero(self, tab):
		aggregate_height = CurrentState.aggregate_height(tab)
		complete_lines = CurrentState.complete_lines(tab)
		holes = CurrentState.holes(tab)
		bumpiness = CurrentState.bumpiness(tab)

		return self.a * aggregate_height + self.b * complete_lines + self.c * holes + self.d * bumpiness

	def possible_mutate(self, ratio_mutacion):
		mutar = random.choices([0, 1], [1-ratio_mutacion, ratio_mutacion])
		if mutar:
			atributo_a_mutar = random.choice([0, 1, 2, 3])
			cantidad_a_mutar = random.uniform(-0.2, 0.2)
			if atributo_a_mutar == 0:
				self.a += cantidad_a_mutar
			elif atributo_a_mutar == 1:
				self.b += cantidad_a_mutar
			elif atributo_a_mutar == 2:
				self.c += cantidad_a_mutar
			else:
				self.d += cantidad_a_mutar

	def run(self):

		if self.game:
			if self.current_piece != self.game.tetromino:
				self.current_piece = self.game.tetromino
				self.play_best_move()

				if self.game:
					self.piezas_restantes -= 1

			else:
				# updating the game
				self.game.run()

			pygame.display.update()
			self.clock.tick()

	def draw(self):

		# display
		self.display_surface.fill(GRAY)

		# components
		self.game.draw()
		self.score.draw()
		self.preview.draw(self.next_shapes)

		# updating the game
		pygame.display.update()
		self.clock.tick()
