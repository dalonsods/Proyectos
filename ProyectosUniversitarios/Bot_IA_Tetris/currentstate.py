import copy
import math
from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.settings import *
from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.game import Tetromino


class CurrentState:

	@staticmethod
	def next_move_horizontal_collide(field, tetromino, amount):
		collision_list = [CurrentState.horizontal_collide(int(block[0] + amount), block[1], field) for block in tetromino]
		return True if any(collision_list) else False

	@staticmethod
	def next_move_vertical_collide(field, tetromino, amount):
		collision_list = [CurrentState.vertical_collide(block[0], int(block[1] + amount), field) for block in tetromino]
		return True if any(collision_list) else False

	@staticmethod
	def horizontal_collide(x, y, field_data):
		if not 0 <= x < COLUMNS:
			return True

		if field_data[int(y)][x]:
			return True

	@staticmethod
	def vertical_collide(x, y, field_data):
		if y >= ROWS:
			return True

		if y >= 0 and field_data[y][int(x)]:
			return True

	@staticmethod
	def move_horizontal(tetromino, amount):
		for block in tetromino:
			block[0] += amount

	@staticmethod
	def move_down(tetromino):
		for block in tetromino:
			block[1] += 1

	@staticmethod
	def rotate_point_around_pivot(point, pivot, angle_degrees):
		x, y = point
		pivot_x, pivot_y = pivot
		angle_radians = math.radians(angle_degrees)
		translated_x = x - pivot_x
		translated_y = y - pivot_y
		new_x = translated_x * math.cos(angle_radians) - translated_y * math.sin(angle_radians)
		new_y = translated_x * math.sin(angle_radians) + translated_y * math.cos(angle_radians)
		return [new_x + pivot_x, new_y + pivot_y]

	@staticmethod
	def add_pieza(tab, pieza):
		for bloque in pieza:
			tab[int(bloque[1])][int(bloque[0])] = 1

	@staticmethod
	def aggregate_height(tab):
		for i, fila in enumerate(tab):
			if any(fila):
				return ROWS - i
		return 0

	@staticmethod
	def complete_lines(tab):
		lineas = 0
		for fila in tab:
			if all(fila):
				lineas += 1
		return lineas

	@staticmethod
	def holes(tab):
		holes = 0
		for j in range(COLUMNS):
			found_first_one = False
			for i in range(ROWS):
				if not found_first_one and tab[i][j]:
					found_first_one = True
				if found_first_one and tab[i][j] == 0:
					holes += 1
		return holes

	@staticmethod
	def bumpiness(tab):
		bumpiness = 0
		previous_height = 0

		for j in range(len(tab[0])):
			found_first_one = False
			for i in range(len(tab)):
				if tab[i][j] and not found_first_one:
					found_first_one = True
					height = len(tab) - i
					if j > 0:
						bumpiness += abs(height - previous_height)
					previous_height = height

			if not found_first_one:
				if j > 0:
					bumpiness += previous_height
				previous_height = 0

		return bumpiness

	@staticmethod
	def get_posible_moves(field_data, tetromino_origen):
		moves = []
		positions = []
		for rotation in range(4):
			a = pygame.sprite.Group()
			tet = Tetromino(tetromino_origen.shape, a, tetromino_origen.create_new_tetromino, field_data)
			for rotar in range(rotation):
				tet.rotate()
			tetromino = [[objeto.pos.x, objeto.pos.y] for objeto in tet.blocks]

			while any(any(elem < 0 for elem in block) for block in tetromino):
				CurrentState.move_down(tetromino)

			del tet

			# Añadimos el no movimiento, solo rotado
			positions.append(copy.deepcopy(tetromino))
			moves.append([rotation, 0])

			# Añadimos resto de movimientos, a derecha o izquierda
			for i in [-1, 1]:

				tetro = copy.deepcopy(tetromino)

				count = 0

				while not CurrentState.next_move_horizontal_collide(field_data, tetro, i):
					CurrentState.move_horizontal(tetro, i)
					count += i
					positions.append(copy.deepcopy(tetro))
					moves.append([rotation, count])

		for tetromino in positions:
			while not CurrentState.next_move_vertical_collide(field_data, tetromino, 1):
				CurrentState.move_down(tetromino)

		return moves, positions
