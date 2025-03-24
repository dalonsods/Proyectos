import pyxel
from random import random

HEIGHT = 256
WIDTH = 256
NUM_CASILLAS = 16
NUM_NUBES = 8
NUM_LEMMINGS = 8


class Portada:
    """Esta clase generará la pantalla inicial. Se ha creado como una clase
    aparte y no como un método de App debido a su extensión"""
    def __init__(self):
        # Listas de nubes y de lemmings
        self.nube_list = []
        self.lemmings_list = []
        # Contador se usará en los métodos update y contador_animacion_lemming
        # Cuando llegue a 8 frames cambiará la animación del lemming
        self.__contador = 0
        self.__animacion = False

        # Añadimos a la lisa de nubes 8 nubes con posiciones  y velocidad
        # aleatorias. Nota: a la lista se añade una tupla de la forma (x, y, vel)
        for i in range(NUM_NUBES):
            self.nube_list.append(
                (round(random() * 1.5 * WIDTH), round(random() / 1.5 * HEIGHT),
                 round(random() + 1.35)))

        # Hacemos lo mismo para los lemmings. Nota: estos lemmings no son como
        # los de la clase lemmings, pues los atributos de esa clase no servían
        # para lo que queríamos hacer en la portada. Por tanto solo se añade una
        # tupla (x, y) y no un Lemming(x, y)
        for e in range(NUM_LEMMINGS):
            for x in range(0, 16, 2):
                self.lemmings_list.append((x * 16, 208))

    def update(self):
        """Este es el método update de la portada. Incrementa la posicion de
        x en función de la velocidad. Tanto a las nubes como a los lemmings."""
        for (x, y, velocidad) in self.nube_list:
            i = self.nube_list.index((x, y, velocidad))
            x -= velocidad
            if x <= -32:
                x = WIDTH
            self.nube_list[i] = (x, y, velocidad)

        for (x, y) in self.lemmings_list:
            i = self.lemmings_list.index((x, y))
            x += 1
            if x > WIDTH:
                x = 0
            self.lemmings_list[i] = (x, y)

        # Llamamos al método contador para que se actualice
        self.__contador_animacion_lemming()

    def __contador_animacion_lemming(self):
        """Este método verifica si el contador ha llegado a 8. Cada 8 frames
        cambia el valor de animacion de verdadero a falso o viceversa. Se
        actualiza llamándolo en update."""
        if self.__contador == 8:
            if not self.__animacion:
                self.__animacion = True
            else:
                self.__animacion = False
            self.__contador = 0
        self.__contador += 1

    def __draw_lemming(self, lista: list):
        """Este método dibuja a los lemmings. Nota: recordar que los lemmings
        de esta pantalla son distintos de los de la pantalla de juego."""
        for (x, y) in lista:
            if self.__animacion:
                pyxel.blt(x, y, 0, 0, 16, 16, 16, colkey=0)
            else:
                pyxel.blt(x, y, 0, 0, 0, 16, 16, colkey=0)

    def draw(self):
        """Este es el método draw de la portada. Pinta un fondo naranja, las nubes
        los lemmings, las casillas de suelo y los botones PLAY e INFO"""
        pyxel.cls(9)
        # Pinta las nubes
        for (x, y, speed) in self.nube_list:
            pyxel.blt(x, y, 1, 0, 0, 26, 16, colkey=3)
        # Pinta los lemmings
        self.__draw_lemming(self.lemmings_list)
        # Pinta el suelo
        for x in range(NUM_CASILLAS):
            pyxel.blt(x * 16, 240, 0, 32, 32, 16, 16)
        for n in range(NUM_CASILLAS):
            pyxel.blt(n * 16, 224, 0, 32, 0, 16, 16)
        # pinta los botones PLAY e INFO
        pyxel.blt(80, 48, 1, 0, 32, 96, 64, colkey=1)
        pyxel.blt(80, 128, 1, 0, 96, 96, 64, colkey=3)
