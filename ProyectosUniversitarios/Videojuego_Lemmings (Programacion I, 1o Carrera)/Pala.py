import pyxel


class Pala:
    """Esta clase genera objetos que eliminan bloques al ser activados por un
    lemming."""
    def __init__(self, x, y):
        self.x = x
        self.y = y

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

    def __eq__(self, other):
        """Método para comparar dos objetos de la clase Pala."""
        return self.x == other.x and self.y == other.y

    def draw(self):
        """Método para pintar los objetos de la clase pala."""
        pyxel.blt(self.x, self.y, 0, 48, 0, 16, 16, colkey=3)
