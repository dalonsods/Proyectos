import pyxel


class Escalera:
    """Esta clase genera escaleras que ayudan al lemming a subir o bajar a una
    determinada posición."""
    def __init__(self, x, y, pos):
        self.x = x
        self.y = y
        # Determina la posición de la escalera (0 derecha, 16 izquierda)
        self.pos = pos

    # Property y setter de x
    @property
    def x(self):
        return self.__x

    @x.setter
    def x(self, x):
        # Condición para que no se salga del tablero
        if x < 16:
            self.__x = 16
        elif x > 224:
            self.__x = 224
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
        elif y > 224:
            self.__y = 224
        else:
            self.__y = y

    # Property y setter de pos
    @property
    def pos(self):
        return self.__pos

    @pos.setter
    def pos(self, pos):
        # La posición solo puede ser 0 o 16
        if pos != 0 and pos != 16:
            self.__pos = 0
        else:
            self.__pos = pos

    def __eq__(self, other):
        """Método para comparar dos objetos de la clase Escalera."""
        return self.x == other.x and self.y == other.y and self.pos == other.pos

    def draw(self):
        """Método para pintar los objetos de la clase escalera."""
        pyxel.blt(self.x, self.y, 0, 64, self.pos, 16, 16, colkey=3)
