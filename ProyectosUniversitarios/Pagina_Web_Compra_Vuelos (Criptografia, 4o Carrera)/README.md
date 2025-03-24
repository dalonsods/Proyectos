# Trabajo Criptografía 4º Carrera. Aplicación Segura de Compra de Vuelos.

Se trata de una página web que registra de forma segura a los usuarios en una base de datos y los vuelos comprados.

Para poder ejecutar la aplicación es necesario instalar las librerías de requirements: se puede hacer desde terminal de python con el comando pip install -r requirements.txt

Una vez ejecutado el programa, en terminal aparecerá un enlace, se debe pinchar en él para acceder a la página web (Suele poner http://127.0.0.1:5000)

> [!WARNING]  
> Si se utiliza un visor de bases de datos (DB Browser en Pycharm por ejemplo), desconectar después de ver las tablas, ya que si se intenta ejecutar una acción de reserva (por ejemplo) mientras está el visor activo, dará error.

Estructura de la carpeta Pagina_Web_Compra_Vuelos
- static: carpeta para css e imagenes de la web
- templates: Carpeta para los html de la web
- crypto.py: Funciones criptográficas utilizadas.
- data.db: Fichero para la base de datos. La primera vez se creará al ejecutar main.py
- database.py: Funciones relacionadas con el manejo de la base de datos
- main.py: fichero base.