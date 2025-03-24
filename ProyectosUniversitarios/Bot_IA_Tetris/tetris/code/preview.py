from ProyectosUniversitarios.Bot_IA_Tetris.tetris.code.settings import *
from pygame.image import load
from os import path


class Preview:
	def __init__(self):

		# general
		self.display_surface = pygame.display.get_surface()
		self.surface = pygame.Surface((SIDEBAR_WIDTH, GAME_HEIGHT * PREVIEW_HEIGHT_FRACTION))
		self.rect = self.surface.get_rect(topright=(WINDOW_WIDTH - PADDING, PADDING))

		# shapes
		self.shape_surfaces = {shape: load(path.join('tetris', 'graphics', f'{shape}.png')).convert_alpha() for shape in TETROMINOS.keys()}

		# Definir el factor de escala
		factor_escala = FACTOR_SIZE / 10

		# Redimensionar las imágenes
		for shape, surface in self.shape_surfaces.items():
			ancho_original, alto_original = surface.get_size()
			nuevo_ancho = int(ancho_original * factor_escala)
			nuevo_alto = int(alto_original * factor_escala)
			self.shape_surfaces[shape] = pygame.transform.scale(surface, (nuevo_ancho, nuevo_alto))

		# image position data
		self.increment_height = self.surface.get_height() / 3

	def display_pieces(self, shapes):
		for i, shape in enumerate(shapes):
			shape_surface = self.shape_surfaces[shape]
			x = self.surface.get_width() / 2
			y = self.increment_height / 2 + i * self.increment_height
			rect = shape_surface.get_rect(center=(x, y))
			self.surface.blit(shape_surface, rect)

	def draw(self, next_shapes):
		self.surface.fill(GRAY)
		self.display_pieces(next_shapes)
		self.display_surface.blit(self.surface, self.rect)
		pygame.draw.rect(self.display_surface, LINE_COLOR, self.rect, 2, 2)
