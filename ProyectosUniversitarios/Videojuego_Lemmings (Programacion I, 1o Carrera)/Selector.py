import pyxel
from Escalera import Escalera
from Paraguas import Paraguas
from Bloqueador import Bloqueador
from Pala import Pala

HEIGHT = 256
WIDTH = 256
TAM_CASILLA = 16


class Selector:
    """A través de esta clase el jugador podrá realizar acciones a lo largo del
    juego, crear objetos y moverse."""
    def __init__(self):
        self.x = 0
        self.y = 32
        self.__h = TAM_CASILLA
        self.__w = TAM_CASILLA
        self.__color = 7

    # Property y setter de x
    @property
    def x(self):
        return self.__x

    @x.setter
    def x(self, x):
        # Condición para que no se salga del tablero
        if x < 16:
            self.__x = 16
        elif x > WIDTH - TAM_CASILLA * 2:
            self.__x = WIDTH - TAM_CASILLA * 2
        else:
            self.__x = x

    # Property y setter de y
    @property
    def y(self):
        return self.__y

    @y.setter
    def y(self, y):
        # Condición para que no se salga del tablero
        if y < 32:
            self.__y = 32
        elif y > HEIGHT - TAM_CASILLA * 2:
            self.__y = HEIGHT - TAM_CASILLA * 2
        else:
            self.__y = y

    # Atributo que convierte una posicion en una posición de casilla
    @property
    def casilla(self):
        return self.x//16, self.y//16

    def update(self):
        """Este método actualiza la posición del selector dependiendo de
        la tecla que pulsa el usuario."""
        if pyxel.btnp(pyxel.KEY_RIGHT, 6, 3):
            self.x += TAM_CASILLA

        if pyxel.btnp(pyxel.KEY_LEFT, 6, 3):
            self.x -= TAM_CASILLA

        if pyxel.btnp(pyxel.KEY_DOWN, 6, 3):
            self.y += TAM_CASILLA

        if pyxel.btnp(pyxel.KEY_UP, 6, 3):
            self.y -= TAM_CASILLA

        if pyxel.btnp(pyxel.MOUSE_LEFT_BUTTON, 6, 3):
            self.x = pyxel.mouse_x // 16 * 16
            self.y = pyxel.mouse_y // 16 * 16

    def crear_objeto(self, lista: list, diccionario: dict, herramientas: dict):
        """Este método genera un objeto de una determinada clase en la posición
        del selector. Para ello utiliza la lista de objetos, el diccionario de
        posiciones(para comprobar si en esa posición hay objeto o no) y el
        diccionario de herramientas (para comprobar si hay herramientas
        restantes)."""

        # Con la E se crea una escalera derecha si no hay nada en la casilla
        # y si quedan escaleras
        if pyxel.btnp(pyxel.KEY_E) and self.casilla not in diccionario and \
                herramientas.get('escaleras') > 0:

            herramientas['escaleras'] -= 1
            lista.append(Escalera(self.x, self.y, 0))
            diccionario[self.casilla] = "escalera derecha"

            pyxel.playm(3, loop=False)

        # Con la R se crea una escalera izquierda si no hay nada en la casilla
        # y si quedan escaleras
        if pyxel.btnp(pyxel.KEY_R) and self.casilla not in diccionario and \
                herramientas.get('escaleras') > 0:

            herramientas['escaleras'] -= 1
            lista.append(Escalera(self.x, self.y, 16))
            diccionario[self.casilla] = "escalera izquierda"

            pyxel.playm(3, loop=False)

        # Con la Q se crea un bloqueador si no hay nada en la casilla
        # y si quedan bloqueadores
        if pyxel.btnp(pyxel.KEY_Q) and self.casilla not in diccionario and \
                herramientas.get('bloqueadores') > 0:

            herramientas['bloqueadores'] -= 1
            lista.append(Bloqueador(self.x, self.y))
            diccionario[self.casilla] = "bloqueador"

            pyxel.playm(3, loop=False)

        # Con la W se crea un paraguas si no hay nada en la casilla
        # y si quedan paraguas
        if pyxel.btnp(pyxel.KEY_W) and self.casilla not in diccionario and \
                herramientas.get('paraguas') > 0:

            herramientas['paraguas'] -= 1
            lista.append(Paraguas(self.x, self.y))
            diccionario[self.casilla] = "paraguas"

            pyxel.playm(3, loop=False)

        # Con la D se crea una pala si no hay nada en la casilla
        # y si quedan palas
        if pyxel.btnp(pyxel.KEY_D) and self.casilla not in diccionario and \
                diccionario.get((self.x//16, self.y//16 + 1)) == 'bloque' and \
                herramientas.get('palas') > 0:

            herramientas['palas'] -= 1
            lista.append(Pala(self.x, self.y))
            diccionario[self.casilla] = "pala"

            pyxel.playm(3, loop=False)

        # Si existe una escalera izquierda se puede cambiar a una derecha
        # sin consumir escaleras
        if pyxel.btnp(pyxel.KEY_E) and diccionario.get(self.casilla) == "escalera izquierda":

            del(lista[lista.index(Escalera(self.x, self.y, 16))])
            lista.append(Escalera(self.x, self.y, 0))
            diccionario[self.casilla] = "escalera derecha"

        # Si existe una escalera derecha se puede cambiar a una izquierda
        # sin consumir escaleras
        if pyxel.btnp(pyxel.KEY_R) and diccionario.get(self.casilla) == "escalera derecha":

            del(lista[lista.index(Escalera(self.x, self.y, 0))])
            lista.append(Escalera(self.x, self.y, 16))
            diccionario[self.casilla] = "escalera izquierda"

    def draw(self):
        """Este método dibuja el selector."""
        pyxel.rectb(self.x, self.y, self.__w, self.__h, self.__color)
