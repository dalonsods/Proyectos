import pyxel
import random

HEIGHT = 256
WIDTH = 256
NUM_CASILLAS = 16
TAM_CASILLA = 16


class PlataformasIniciales:
    """Clase que genera las plataformas iniciales cuando es llamada."""
    def __init__(self):
        # Listas para los bordes y las plataformas
        self.bordes = []
        self.plataformas = []
        # Creamos el borde derecho, izquierdo y el suelo
        for x in range(NUM_CASILLAS):
            for y in range(2, NUM_CASILLAS):

                if x == 0 or x == NUM_CASILLAS - 1:
                    self.bordes.append((x, y))

                if y == NUM_CASILLAS - 1:
                    self.bordes.append((x, y))

        # Para aumentar la jugabilidad las plataformas se iniciarán en posiciones
        # aleatorias pero que no hayan sido usadas antes. Para ello usamos la
        # siguiente lista
        posiciones_usadas = []

        # Generamos 6 plataformas en las filas impares
        for y in range(3, NUM_CASILLAS - 1, 2):
            tamanio = random.randint(5, 10)
            # Determinamos la posición del inicio de la plataforma
            posicion = random.randrange(1, NUM_CASILLAS - tamanio)
            # Este bucle while hace que la posicion no esté elgida
            while posicion in posiciones_usadas:
                posicion = random.randrange(1, NUM_CASILLAS - tamanio)
            posiciones_usadas.append(posicion)
            # Generamos n bloques desde la posición inicial
            for plataforma in range(tamanio):
                self.plataformas.append((posicion, y))
                posicion += 1
        # Generamos la salida y el final
        self.casilla_salida = self.__casilla_salida()
        self.casilla_final = self.__casilla_final()

    def __casilla_salida(self):
        """Este método genera la casilla de salida. Para aumentar la jugabilidad
        solo se creará en una de las 3 primeras plataformas."""

        posibles_casillas = []
        pos_y = random.randrange(3, 8, 2)

        for x in range(1, NUM_CASILLAS - 1):
            if (x, pos_y) in self.plataformas:
                posibles_casillas.append((x, pos_y - 1))

        n_casilla = random.randrange(len(posibles_casillas))
        casilla_salida = posibles_casillas[n_casilla]

        return casilla_salida

    def __casilla_final(self):
        """Este método genera la casilla final. Para aumentar la jugabilidad
        solo se creará en una de las 3 últimas plataformas."""

        posibles_casillas2 = []
        pos_y = random.randrange(9, 14, 2)

        for x in range(1, NUM_CASILLAS - 1):
            if (x, pos_y) in self.plataformas:
                posibles_casillas2.append((x, pos_y - 1))

        n_casilla2 = random.randrange(len(posibles_casillas2))
        casilla_final = posibles_casillas2[n_casilla2]

        return casilla_final

    def draw(self):
        """Método para pintar los bloques de las listas y las casillas
        inicial y final."""
        # Bloques de plataformas
        for (x, y) in self.plataformas:
            pyxel.blt(x * 16, y * 16, 0, 32, 16, 16, 16, colkey=3)
        # Bloques de bordes
        for (x, y) in self.bordes:
            pyxel.blt(x * 16, y * 16, 0, 32, 16, 16, 16, colkey=3)

        # Casillas salida y final
        pyxel.blt(self.casilla_salida[0] * 16, self.casilla_salida[1] * 16,
                  0, 48, 64, 16, 16, colkey=3)
        pyxel.blt(self.casilla_final[0] * 16, self.casilla_final[1] * 16,
                  0, 48, 48, 16, 16, colkey=3)
