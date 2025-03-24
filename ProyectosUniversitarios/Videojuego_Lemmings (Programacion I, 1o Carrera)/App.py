"""
Python version : 3.8
Descripción : Videojuego lemmings. Para visualizar los controles
ejecutar el programa e ir a la casilla INFO
"""


import pyxel
import random
from PlataformasIniciales import PlataformasIniciales
from Selector import Selector
from Lemmings import Lemming
from Marcador import Marcador
from Portada import Portada

CAPTION = "LEMMINGS"
FPS = 30
HEIGHT = 256
WIDTH = 256
NUM_CASILLAS = 16

# Las siguientes constantes asignan un valor a las pantallas
# para poder trabajar con ellas
PANTALLA_INICIO = 0
PANTALLA_INFO = 1
PANTALLA_NIVEL = 2
PANTALLA_GAMEOVER = 3


class App:
    """Clase principal del juego. En ella se entrelazan el resto de clases"""
    def __init__(self):
        # Iniciamos el programa, cargamos los archivos y ponemos la música
        pyxel.init(WIDTH, HEIGHT, caption=CAPTION, fps=FPS)
        pyxel.load("my_resource.pyxres")
        pyxel.playm(0, loop=True)
        # Inicia el ratón
        pyxel.mouse(True)

        # Creamos una portada iniciamos la pantalla en la de inicio,
        # el nivel en 1 y la cuenta en 60
        self.__pantalla = PANTALLA_INICIO
        self.__portada = Portada()
        self.__nivel = 1
        self.cuenta_atras = 60
        # Diccionario que nos indica las herramientas restantes
        self.__herramientas_restantes = {'escaleras': 12, 'bloqueadores': 5,
                                         'palas': 3, 'paraguas': 5}
        # Guarda todos los objetos creados
        self.__objetos_list = []
        # Este diccionario guarda como clave una tupla (x, y) y como valor el
        # nombre del objeto que guarda
        self.__pos_objetos = {}
        # Creamos un tablero
        self.__board = PlataformasIniciales()
        # Añadimos los bloques de board al diccionario de posiciones con el
        # valor 'bloque'. Hacemos lo mismo con entrada y salida.
        for lista in (self.__board.bordes, self.__board.plataformas):
            for (x, y) in lista:
                self.__pos_objetos[(x, y)] = "bloque"
        self.__pos_objetos[self.__board.casilla_salida] = "salida"
        self.__pos_objetos[self.__board.casilla_final] = "meta"

        # Nummero aleatorio para determinar el número de lemmings
        self.__lemmings_iniciales = random.randint(10, 20)
        # Información sobre el estado de los lemmings
        self.__lemmings_vivos = []
        self.__lemmings_muertos = []
        self.__lemmings_salvados = []

        # Iniciamos el selector con el que el usuario se desplazará
        self.__selector = Selector()
        # Iniciamos el marcador
        self.__marcador = Marcador(self.__nivel, self.cuenta_atras,
                                   self.__herramientas_restantes,
                                   self.__cuenta_lemmings)
        # Ejecutamos el programa con los métodos update y draw
        pyxel.run(self.update, self.draw)

    # Property de cuenta_atras
    @property
    def cuenta_atras(self):
        return self.__cuenta_atras

    @cuenta_atras.setter
    def cuenta_atras(self, cuenta_atras):
        """Si el valor de la cuenta atrás es menor que cero, el setter lo
        cambiará a 0. Esto se hace para evitar un contador negativo. Este
        contador nos indica el tiempo de vida que le queda al lemming."""
        if cuenta_atras < 0:
            self.__cuenta_atras = 0
        else:
            self.__cuenta_atras = cuenta_atras

    @property
    def __cuenta_lemmings(self):
        """Propiedad que genera un diccionario con la cantidad de lemmings de
        cada estado."""
        return {'vivos': self.__lemmings_iniciales + len(self.__lemmings_vivos),
                'muertos': len(self.__lemmings_muertos),
                'salvados': len(self.__lemmings_salvados)}

    def __crear_nivel(self):
        """Este método reinicia los valores iniciales anteriormente comentados
         cuando es llamado."""
        self.cuenta_atras = 60
        self.__herramientas_restantes = {'escaleras': 12, 'bloqueadores': 5,
                                         'palas': 3, 'paraguas': 5}
        self.__objetos_list = []
        self.__pos_objetos = {}

        self.__board = PlataformasIniciales()
        for lista in (self.__board.bordes, self.__board.plataformas):
            for (x, y) in lista:
                self.__pos_objetos[(x, y)] = "bloque"
        self.__pos_objetos[self.__board.casilla_salida] = "salida"
        self.__pos_objetos[self.__board.casilla_final] = "meta"

        self.__lemmings_iniciales = random.randint(10, 20)
        self.__lemmings_vivos = []
        self.__lemmings_muertos = []
        self.__lemmings_salvados = []

        self.__selector = Selector()
        self.__marcador = Marcador(self.__nivel, self.cuenta_atras,
                                   self.__herramientas_restantes,
                                   self.__cuenta_lemmings)

    def __generar_lemmings(self):
        """Este método utiliza self.__lemmings_iniciales para generar un lemming
        cada segundo hasta que se hayan generado todos. Añade lemmings a la
        lista de vivos. Utiliza la posiciónde la casilla de salida."""
        if pyxel.frame_count % FPS == 0 and self.__lemmings_iniciales > 0:
            self.__lemmings_vivos.append(
                Lemming(self.__board.casilla_salida[0] * 16,
                        self.__board.casilla_salida[1] * 16))
            self.__lemmings_iniciales -= 1

    def update(self):
        """Este es el método update general. Dependiendo de la pantalla en la
        que nos encontremos llamará a un método update u otro."""

        if self.__pantalla == PANTALLA_INICIO:
            self.__update_pantalla_inicio()
        elif self.__pantalla == PANTALLA_INFO:
            self.__update_pantalla_info()
        elif self.__pantalla == PANTALLA_NIVEL:
            self.__update_pantalla_nivel()
        elif self.__pantalla == PANTALLA_GAMEOVER:
            self.__update_pantalla_gameover()

    def __update_pantalla_inicio(self):
        """Este es el método update de la pantalla inicial. Hay dos posibles
        opciones: Iniciar nivel o ver controles."""
        # Esto llama a la funcion update propia de la clase Portada
        self.__portada.update()
        # Si se pulsa enter o se pincha en el boton PLAY se inicia un nivel
        if pyxel.btnp(pyxel.KEY_ENTER) or \
                (pyxel.btnp(pyxel.MOUSE_LEFT_BUTTON) and
                 80 < pyxel.mouse_x < 176 and 48 < pyxel.mouse_y < 112):
            self.__nivel = 1
            self.__pantalla = PANTALLA_NIVEL
            self.__crear_nivel()
        # Si se pulsa la I o se pincha en INFO se abre la pantalla de info
        if pyxel.btnp(pyxel.KEY_I) or (pyxel.btnp(pyxel.MOUSE_LEFT_BUTTON) and
                                       80 < pyxel.mouse_x < 176 and
                                       128 < pyxel.mouse_y < 192):
            self.__pantalla = PANTALLA_INFO

    def __update_pantalla_info(self):
        """Este es el método update de la pantalla de información."""
        # Si se pulsa enter o la cruz de la derecha de la ventana se cierra
        if pyxel.btnp(pyxel.KEY_ENTER) or \
                (pyxel.btnp(pyxel.MOUSE_LEFT_BUTTON) and
                 216 < pyxel.mouse_x < 232 and 35 < pyxel.mouse_y < 51):
            self.__pantalla = PANTALLA_INICIO

    def __update_pantalla_nivel(self):
        """Este es el método update para la pantalla de juego. Actualiza lo
        necesario para que el nivel funcione adecuadamente."""
        # Este condicional resta 1 al contador del nivel cada segundo
        if pyxel.frame_count % FPS == 0:
            self.cuenta_atras -= 1
        # Actualizador del marcador. Se sobreescribe uno nuevo cada frame
        self.__marcador = Marcador(self.__nivel, self.cuenta_atras,
                                   self.__herramientas_restantes,
                                   self.__cuenta_lemmings)
        # Genera los lemmings y actualiza el selector
        self.__generar_lemmings()
        self.__selector.update()
        # Comprueba si se el usuario intenta crear un nuevo objeto
        self.__selector.crear_objeto(self.__objetos_list, self.__pos_objetos,
                                     self.__herramientas_restantes)
        # Comprobamos aspectos de cada lemming vivo
        for lemming in self.__lemmings_vivos:
            # Si el contador llega a 0 el lemming muere
            if self.cuenta_atras == 0:
                lemming.vivo = False
            # Actualiza el movimiento y la animación
            lemming.movimiento(self.__pos_objetos, self.__objetos_list,
                               self.__board.plataformas)
            lemming.contador_animacion()
            # Si muere pasa a la lista de muertos y si se salva a la de salvados
            if not lemming.vivo:
                dead = self.__lemmings_vivos.pop(self.__lemmings_vivos.index(lemming))
                self.__lemmings_muertos.append(dead)
            if lemming.salvado:
                salv = self.__lemmings_vivos.pop(self.__lemmings_vivos.index(lemming))
                self.__lemmings_salvados.append(salv)

        # Si no hay lemmings vivos ni salvados se pasa a la pantalla de GAMEOVER
        if len(self.__lemmings_vivos) + self.__lemmings_iniciales == 0 and \
                len(self.__lemmings_salvados) == 0:
            self.__pantalla = PANTALLA_GAMEOVER
            # Paramos la música y ponemos la de GAMEOVER
            pyxel.stop()
            pyxel.playm(2, loop=False)
        # Si ya no hay vivos pero si salvados genera un nuevo nivel con la
        # cantidad de lemmings salvados
        if len(self.__lemmings_vivos) + self.__lemmings_iniciales == 0 and \
                len(self.__lemmings_salvados) > 0:
            self.__nivel += 1
            lemmings_restantes = len(self.__lemmings_salvados)
            self.__crear_nivel()
            self.__lemmings_iniciales = lemmings_restantes

    def __update_pantalla_gameover(self):
        """Este es el update de la pantalla de GAMEOVER. Si se pulsa enter se
        vuelve a la pantalla de inicio y se reinicia la música."""
        if pyxel.btnp(pyxel.KEY_ENTER):
            pyxel.playm(0, loop=True)
            self.__pantalla = PANTALLA_INICIO

    def draw(self):
        """Este es el método draw general. Dependiendo de la pantalla en la
        que nos encontremos llamará a un método draw u otro."""

        if self.__pantalla == PANTALLA_INICIO:
            self.__draw_pantalla_inicio()
        elif self.__pantalla == PANTALLA_INFO:
            self.__draw_pantalla_info()
        elif self.__pantalla == PANTALLA_NIVEL:
            self.__draw_pantalla_nivel()
        elif self.__pantalla == PANTALLA_GAMEOVER:
            self.__draw_pantalla_gameover()

    def __draw_pantalla_inicio(self):
        """Este es el método draw de la pantalla de inicio. Este método llama al
         método update propio de la clase Portada."""
        self.__portada.draw()

    def __draw_pantalla_info(self):
        """Este es el método draw de la pantalla de carga. Este método pinta una
        ventana negra de borde blanco y un texto con los diferentes controles."""
        # Pintamos también la portada
        self.__portada.draw()
        # Ventana y marco
        pyxel.rect(32, 43, 192, 154, 0)
        pyxel.rectb(32, 43, 192, 154, 7)
        # Casilla 'X' para salir  y texto
        pyxel.blt(216, 35, 0, 48, 80, 16, 16, colkey=3)
        texto = "\n\n        - INFORMACION DE LOS CONTROLES -" \
                "\n\n\n\n  Mover selector: teclas de movimiento y raton" \
                "\n\n\n  Escalera izquierda: tecla R" \
                "\n\n\n  Escalera derecha: tecla E" \
                "\n\n\n  Bloqueador: tecla Q" \
                "\n\n\n  Pala: tecla D" \
                "\n\n\n  Paraguas: tecla W"
        pyxel.text(32, 43, texto, 3)

    def __draw_pantalla_nivel(self):
        """Este es el método draw de la pantalla de juego. Genera un fondo negro
        y pinta todos los elementos del juego: marcador, plataforma, objetos,
        lemmings, selector."""
        pyxel.cls(0)
        # Pinta todos llos objetos
        for objeto in self.__objetos_list:
            objeto.draw()
        # Pinta tablero, selector y marcador
        self.__board.draw()
        self.__selector.draw()
        self.__marcador.draw()
        # Pinta los lemmings vivos y muertos
        for lista in (self.__lemmings_vivos, self.__lemmings_muertos):
            for lemming in lista:
                lemming.draw()

    def __draw_pantalla_gameover(self):
        """Este es el método draw de la pantalla de GAMEOVER. Pinta un fondo
        negro con las letras de GAMEOVER, el nivel que se alcanzó antes de
        perder y un letrero de -PRESS ENTER-."""
        pyxel.cls(0)
        # Pinta las letras de GAMEOVER
        pyxel.blt(52, 40, 2, 0, 0, 152, 88, colkey=0)
        # Pinta un letrero que aparece y desaparece cada segundo
        if (pyxel.frame_count // FPS) % 2 == 0:
            pyxel.blt(68, 190, 2, 0, 112, 120, 10, colkey=0)
        # Indicador del último nivel jugado
        pyxel.text(71, 150, "Has llegado hasta el nivel %i" % self.__nivel, 7)


App()
