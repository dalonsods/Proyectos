from ProyectosUniversitarios.Bot_IA_Tetris.brain import *


class Main:
	def __init__(self):

		# general
		pygame.init()
		self.display_surface = pygame.display.set_mode((WINDOW_WIDTH, WINDOW_HEIGHT))
		self.clock = pygame.time.Clock()
		pygame.display.set_caption('Tetris')

		# components
		self.game = Brain(-0.015272125469861392, -0.0718722461883823, -0.9823868699379594, -0.16996353047241927, 10000000, 1, exit)

	def run(self):
		while True:
			for event in pygame.event.get():
				if event.type == pygame.QUIT:
					pygame.quit()
					exit()
			if self.game.game:
				self.game.run()
			if self.game.game:
				self.game.draw()


if __name__ == '__main__':
	main = Main()
	main.run()
