import pyxel
from Pala import Pala


class Lemming:
    """Esta es la clase lemming. Aquí se operará con lo relacionado al lemming
    como el movimiento y los métodos update y draw."""
    def __init__(self, x: int, y: int):
        # x e y determinan la posición del lemming
        self.x = x
        self.y = y
        # Determinan si un lemming está salvado, vivo o muerto
        self.salvado = False
        self.vivo = True
        # Atributos que se usa para implementar la animación del lemming
        self.__animacion = False
        self.__contador = 0
        # Atributos para la gravedad y el paraguas
        self.__paraguas = False
        self.__gravedad = False
        # Direccion del lemming (1 derecha, -1 izquierda)
        self.__direccion = 1

    # Propiedad y setter de x
    @property
    def x(self):
        return self.__x

    @x.setter
    def x(self, x):
        # Definimos los valores que debe tomar para no salirse del tablero
        if x < 15:
            self.__x = 15
        elif x > 225:
            self.__x = 225
        else:
            self.__x = x

    # Propiedad y setter de y
    @property
    def y(self):
        return self.__y

    @y.setter
    def y(self, y):
        # Si el lemming entra en el espacio del marcador vuelve a la posición
        # y = 32 y cambia de dirección
        if y < 32:
            self.__y = 32
            self.__direccion *= (-1)
        # Si baja demasiado vuelve a la posición y = 225
        elif y > 225:
            self.__y = 225
        else:
            self.__y = y

    # Creamos cuatro puntos de referencia con los que comprobaremos la posición
    # del lemming: esquina superior izquierda, esquina superior derecha, pie
    # izquierdo y pie derecho
    @property
    def __pto_ref_izdo(self):
        return self.x, self.y

    @property
    def __pto_ref_dcho(self):
        return self.x + 15, self.y

    @property
    def __ref_pie_izdo(self):
        return self.x + 4, self.y + 15

    @property
    def __ref_pie_dcho(self):
        return self.x + 11, self.y + 15

    def __casilla_act(self, x: int, y: int):
        """Este método nos devuelve una tupla con la casilla actual del punto
        introducido como parámetro."""
        return x // 16, y // 16

    def __casilla_inf(self, x: int, y: int):
        """Este método nos devuelve una tupla con la casilla inferior del punto
        introducido como parámetro."""
        return x // 16, y // 16 + 1

    def movimiento(self, posiciones: dict, objetos: list, bloques: list):
        """Este método engloba todos los métodos de movimiento definidos,
        llamándolos cuando se cumplen determinadas condiciones. En este
        método recibimos 3 parámetros. El primero un diccionario con las
        posiciones usadas como claves y el tipo de objeto como valor.
        El segundo una lista con los objetos creados. Y el tercero otra
        lista con los bloques de las plataformas."""

        if self.vivo:
            # Se ejecuta cuando el lemming llega a la meta y va en direccion 1
            if posiciones.get(self.__casilla_act(*self.__pto_ref_izdo)) == "meta" and \
                    self.__direccion == 1 and not self.__gravedad:

                self.salvado = True
            # Se ejecuta cuando el lemming llega a la meta y va en direccion -1
            elif posiciones.get(self.__casilla_act(*self.__pto_ref_dcho)) == "meta" and \
                    self.__direccion == -1 and not self.__gravedad:
                self.salvado = True

            # Movimiento de la pala para dirección 1
            elif posiciones.get(self.__casilla_act(*self.__pto_ref_izdo)) == "pala" and \
                    self.__direccion == 1 and not self.__gravedad:
                del(posiciones[(self.__casilla_act(*self.__pto_ref_izdo))])
                del(posiciones[(self.__casilla_inf(*self.__pto_ref_izdo))])
                del(objetos[objetos.index(Pala(self.x // 16 * 16, self.y // 16 * 16))])
                del(bloques[bloques.index(self.__casilla_inf(*self.__pto_ref_izdo))])

            # Movimiento de la pala para dirección -1
            elif posiciones.get(self.__casilla_act(*self.__pto_ref_dcho)) == "pala" and \
                    self.__direccion == -1 and not self.__gravedad:
                del(posiciones[(self.__casilla_act(*self.__pto_ref_dcho))])
                del(posiciones[(self.__casilla_inf(*self.__pto_ref_dcho))])
                del(objetos[objetos.index(Pala((self.x + 15) // 16 * 16, self.y // 16 * 16))])
                del(bloques[bloques.index(self.__casilla_inf(*self.__pto_ref_dcho))])

            # Movimiento de borde para la dirección -1
            elif (posiciones.get(self.__casilla_act(*self.__pto_ref_izdo)) == "bloque" or
                    posiciones.get(self.__casilla_act(*self.__pto_ref_izdo)) == "bloqueador") and \
                    self.__direccion == -1:
                self.__mov_borde()

            # Movimiento de borde para la dirección 1
            elif (posiciones.get(self.__casilla_act(*self.__pto_ref_dcho)) == "bloque" or
                    posiciones.get(self.__casilla_act(*self.__pto_ref_dcho)) == "bloqueador") and \
                    self.__direccion == 1:
                self.__mov_borde()

            # Movimiento escalera superior para dirección 1
            elif posiciones.get(self.__casilla_act(*self.__ref_pie_dcho)) == "escalera derecha" and \
                    self.__direccion == 1 and not self.__gravedad:
                self.__mov_escalera_sup()

            # Movimiento escalera superior para dirección -1
            elif posiciones.get(self.__casilla_act(*self.__ref_pie_izdo)) == "escalera izquierda" and \
                    self.__direccion == -1 and not self.__gravedad:
                self.__mov_escalera_sup()

            # Movimiento escalera inferior para dirección -1
            elif posiciones.get(self.__casilla_inf(*self.__ref_pie_dcho)) == "escalera derecha" and \
                    self.__direccion == -1 and not self.__gravedad:
                self.__mov_escalera_inf()

            # Movimiento escalera inferior para dirección 1
            elif posiciones.get(self.__casilla_inf(*self.__ref_pie_izdo)) == "escalera izquierda" and \
                    self.__direccion == 1 and not self.__gravedad:
                self.__mov_escalera_inf()

            # Extensión de la escalera inferior. Cuando el lemming baja una escalera
            # inferior la escalera deja de estar en la casilla inferior del pie
            # para estar en la actual del pie. Por eso necestiamos este nuevo
            # condicional. Esto no ocurre en las de subida, pues siempre están
            # en la casilla actual del pie.
            elif posiciones.get(self.__casilla_act(*self.__ref_pie_izdo)) == "escalera izquierda" and \
                    self.__direccion == 1 and not self.__gravedad and \
                    (posiciones.get(self.__casilla_inf(*self.__ref_pie_izdo)) != "bloque" or
                     posiciones.get(self.__casilla_inf(*self.__pto_ref_izdo)) != "bloque"):
                self.__mov_escalera_inf()

            # Lo mismo que el condicional anterior pero para dirección -1
            elif posiciones.get(self.__casilla_act(*self.__ref_pie_dcho)) == "escalera derecha" and \
                    self.__direccion == -1 and not self.__gravedad and \
                    (posiciones.get(self.__casilla_inf(*self.__ref_pie_dcho)) != "bloque" or
                     posiciones.get(self.__casilla_inf(*self.__pto_ref_dcho)) != "bloque"):
                self.__mov_escalera_inf()

            # Comprueba si hay un bloque debajo
            elif posiciones.get(self.__casilla_inf(*self.__pto_ref_dcho)) == "bloque" or \
                    posiciones.get(self.__casilla_inf(*self.__pto_ref_izdo)) == "bloque":
                # Si caía sin paraguas muere y suena sonido de muerte
                if self.__gravedad and not self.__paraguas:
                    self.vivo = False
                    pyxel.play(0, 3)
                # Si no, se mueve en su dirección
                else:
                    self.__mov_plataforma()

            # Activa el paraguas
            elif posiciones.get(self.__casilla_act(*self.__pto_ref_dcho)) == "paraguas" and \
                    self.__gravedad:
                self.__paraguas = True

            # Si no se cumple ninguno de los condicionales anteriores es porque
            # no hay ningún bloque y el lemming cae
            else:
                self.__gravedad = True

        if self.vivo:
            # Condicional para la caída
            if self.__gravedad:
                self.__mov_caida()
            # Condicional para cuando el paraguas está activado
            if self.__paraguas:
                self.__mov_paraguas()

    def __mov_escalera_sup(self):
        """Método para subir una escalera, sin importar dirección."""
        self.x += self.__direccion
        self.y -= 1

    def __mov_escalera_inf(self):
        """Método para bajar una escalera, sin importar dirección."""
        self.x += self.__direccion
        self.y += 1

    def __mov_borde(self):
        """Método para chocar con un borde."""
        self.__direccion *= (-1)

    def __mov_plataforma(self):
        """Método para andar en una plataforma. Paraguas y gravedad se vuelven
        falsas."""
        self.x += self.__direccion
        self.__gravedad = False
        self.__paraguas = False

    def __mov_caida(self):
        """Método de caida."""
        self.y += 2

    def __mov_paraguas(self):
        """Método para caer más lento con el paraguas."""
        self.y -= 1

    def contador_animacion(self):
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

    def draw(self):
        """Este es el método draw de lemming. Dependiendo del estado del lemming
        lo pinta de una forma u otra."""
        # Si lleva paraguas
        if self.__paraguas:
            pyxel.blt(self.x, self.y, 0, 16, 32, 16, 16, colkey=0)
        # Si está muerto
        elif not self.vivo:
            pyxel.blt(self.x, self.y, 0, 0, 32, 16, 16, colkey=0)
        # Si está cayendo
        elif self.__gravedad:
            if self.__direccion == 1:
                pyxel.blt(self.x, self.y, 0, 0, 0, 16, 16, colkey=0)
            else:
                pyxel.blt(self.x, self.y, 0, 16, 0, 16, 16, colkey=0)
        # Si va andando, usando la animación
        elif self.__animacion:
            if self.__direccion == 1:
                pyxel.blt(self.x, self.y, 0, 0, 16, 16, 16, colkey=0)
            else:
                pyxel.blt(self.x, self.y, 0, 16, 16, 16, 16, colkey=0)
        else:
            if self.__direccion == 1:
                pyxel.blt(self.x, self.y, 0, 0, 0, 16, 16, colkey=0)
            else:
                pyxel.blt(self.x, self.y, 0, 16, 0, 16, 16, colkey=0)
