import pyxel


class Marcador:
    """Esta clase genera un marcador con los datos introducidos cuando es
    llamada."""
    def __init__(self, nivel: int, tiempo: int, objetos: dict, lemmings: dict):
        # Texto a escribir
        self.__texto = ("\nNivel: %i   Tiempo: %i   Vivos: %i   Muertos: %i   Salvados: %i\n\n"
                        " Escaleras: %i    Bloqueadores: %i    Palas: %i    Paraguas: %i") % \
                       (nivel, tiempo, lemmings['vivos'], lemmings['muertos'], lemmings['salvados'],
                        objetos['escaleras'], objetos['bloqueadores'], objetos['palas'], objetos['paraguas'])

    def draw(self):
        """Método para pintar el marcador."""
        pyxel.text(6, 0, self.__texto, 3)
