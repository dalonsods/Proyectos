import os
import database as db
import crypto
from flask import Flask, request, render_template, redirect, url_for
import sqlite3 as sql


# Path de la base de datos
DB_PATH = os.path.join(os.getcwd(), "data.db")

# Session inicialmente vacía
session = {"usuario": '',
           "password": ''}

# La aplicación
app = Flask(__name__)

# Las siguientes definiciones son para los detectores de ruta.
# Cuando la aplicación esté ejecutándose irá comprobando la ruta en la que se encuentra mediante
# @app.route y hará las pertinentes operaciones.


@app.route('/')
def inicio():
    """Detecta que está en la ruta de inicio y carga el html de home, además de pasar como
    parámetro al html el nombre del usuario de la sesión actual. En caso de no haber sesión iniciada
    enviará un string vacío. Este valor puede ser accedido desde html."""

    return render_template("home.html", usuario=session["usuario"])


@app.route('/home')
def home():
    """Detecta que está en la ruta de home y carga el html de home, además de pasar como
    parámetro al html el nombre del usuario de la sesión actual. En caso de no haber sesión iniciada
    enviará un string vacío. Este valor puede ser accedido desde html."""

    return render_template("home.html", usuario=session["usuario"])


@app.route('/login')
def login():
    """Detecta que está en la ruta de login y carga el html de login"""

    return render_template("login.html")


@app.route('/entrar', methods=['POST'])
def entrar():
    """Detecta que se ha enviado el formulario de login. Recoge los datos del formulario, y los comprueba
    en la base de datos. Si no existe el usuario recarga la página de login.html con un error pasado por parámetro
    'mensaje'. Si no se verifica con éxito la contraseña recarga la página de login.html con un error distinto.
    En caso de éxito en el login, actualiza la variable diccionario de session y redirige a home"""

    user = request.form["Usuario"]
    passw = request.form["Contraseña"]

    # Leemos de la base de datos la información de ese usuario
    datos = db.read_user(user.lower())

    # Si es 0, el usuario no existe, no puede ser mayor que 1 por ser user la Primary Key
    if len(datos) != 1:
        return render_template("login.html", mensaje="El usuario no existe")

    # Si no se verifica con éxito se recarga la página con un mensaje de error
    if not crypto.verify_pass(datos[0], passw):
        return render_template("login.html", mensaje="Contraseña incorrecta")

    # En caso contrario usuario y contraseña correctos, se carga la página de inicio
    global session
    session["usuario"] = user
    session["password"] = passw
    return redirect(url_for("home"))


@app.route('/registro')
def registro():
    """Detecta que está en la ruta de registro y carga el html de registro"""

    return render_template("registro.html")


@app.route('/registrar', methods=['POST'])
def registrar():
    """Detecta que se ha enviado el formulario de registro. Recoge los datos del formulario, y los intenta añadir
    en la base de datos, encriptando la contraseña primero. Si ya existe un usuario con ese nombre recarga la página de
    login.html con un error pasado por parámetro 'mensaje'. Si ya existe una cuenta con ese email también envia error.
    Si hay algún otro error recarga la página de login.html con un error distinto.
    En caso de éxito en el registro, actualiza la variable diccionario de session y redirige a home"""

    # Recogemos los datos del formulario
    user = request.form["Usuario"]
    passw = request.form["Contraseña"]
    email = request.form["Email"]

    # Derivamos la contraseña, nos quedamos con el salt también
    key, salt = crypto.derive_pass(passw)

    try:
        # Intentamos hacer la inserción en la base de datos
        db.insert_user(user, email, key, salt)
    except sql.IntegrityError as error:
        message = str(error)
        if "UNIQUE constraint failed: users.user" in message:
            # Se violó la restricción PRIMARY KEY de nombre de user
            return render_template("registro.html", mensaje="El nombre de usuario ya existe")

        if "UNIQUE constraint failed: users.email" in message:
            # Se violó la restricción UNIQUE de email
            return render_template("registro.html", mensaje="Ya existe una cuenta con ese email")

        # Si el error es distinto pero de Integridad
        return render_template("registro.html", mensaje="Se produjo un error, intente de nuevo")

    # Otros errores
    except:
        return render_template("registro.html", mensaje="Se produjo un error, intente de nuevo")

    # En caso de que el registro sea correcto se inicia sesión y se redirige a home
    global session
    session["usuario"] = user
    session["password"] = passw
    return redirect(url_for("home"))


@app.route('/perfil')
def perfil():
    """Detecta que está en la ruta de perfil y carga el html de perfil. Envía dos parámetros al html: 'usuario'
    con el nombre de usuario de la session actual. En caso de no haber ninguna sesión se redirige a login;
    también se envia una lista 'reservas' con las reservas desencriptadas de dicho usuario. En caso de no haber
    reservas a su nombre se envía una lista vacía. Estos parámetros pueden ser accedidos desde perfil.html"""

    user = session["usuario"]

    # Si no hay session iniciada se redirige a login
    if not user:
        return redirect(url_for("login"))

    # Lista para las reservas desencriptadas
    reservas = []
    # Leemos de la base de datos las reservas asociadas al usuario
    select = db.read_bookings(user)

    # Este bucle desencripta todos los datos de las reservas. Recordemos que select es una lista de tuplas con el
    # formato: [(date, destination, passengers, nonce), (date, destination, passengers, nonce), ...]
    for elemento in select:
        # De cada tupla, detectamos el nonce y los datos encriptados
        nonce = elemento[3]
        data_encry = elemento[:3]
        # Lista para guardar los valores desencriptados de cada tupla
        data = []

        # Desencriptamos los datos
        for dato in data_encry:
            dato_decry = crypto.decrypt_msg_aesgcm(dato, nonce, session["password"])
            data.append(dato_decry)
        reservas.append(data)

    return render_template("perfil.html", usuario=session["usuario"], reservas=reservas)


@app.route('/cerrar')
def cerrar():
    """Detecta que está en la ruta de cierre de sesión. Vacía el diccionario de session y redirige a home"""

    global session
    session = {"usuario": '',
               "password": ''}
    return redirect(url_for("home"))


@app.route('/reserva')
def reserva():
    """Detecta que está en la ruta de reserva y carga el html de reserva pasando como parámetro el destino que se
    ha seleccionado desde home (hay tres botones distintos). En caso de no haber iniciado sesión redirige a login"""

    if not session["usuario"]:
        return redirect(url_for("login"))

    destino = request.args.get('destino')
    return render_template('reserva.html', destino=destino)


@app.route('/reservar', methods=['POST'])
def reservar():
    """Detecta que se ha enviado el formulario de reserva. Recoge los datos del formulario, y los intenta añadir
    en la base de datos, encriptándolos primero. Si ya existe una reserva para esa fecha para el usuario recarga la
    página de reserva.html con un error pasado por parámetro 'mensaje'. Si hay algún otro error recarga la página de
    reserva.html con un error distinto. Si el registro de la reserva es exitoso redirige a home al acabar"""

    # Recogemos los datos del formulario
    user = session["usuario"]
    destino = request.form["Destino"][9:]
    ida = request.form["Ida"]
    tarjeta = request.form["Tarjeta"]
    pasajeros = request.form["Pasajeros"]
    label_destino = request.args.get('destino')

    # Los encriptamos
    nonce, (destino, ida, tarjeta, pasajeros) = \
        crypto.encrypt_msg_aesgcm(session["password"], (destino, ida, tarjeta, pasajeros))

    try:
        # Intentamos añadirlo en la tabla de bookings
        db.insert_booking(user, destino, ida, tarjeta, pasajeros, nonce)
    except sql.IntegrityError as error:
        message = str(error)
        if "UNIQUE constraint failed" in message:
            # Se violó la restricción PRIMARY KEY
            return render_template("reserva.html", mensaje="Ya tienes una reserva ese día.", destino=label_destino)

        # Si el error es distinto pero de Integridad
        return render_template("reserva.html", mensaje="Se produjo un error, intente de nuevo", destino=label_destino)

    # Otros errores
    except:
        return render_template("reserva.html", mensaje="Se produjo un error, intente de nuevo", destino=label_destino)

    return redirect(url_for("home"))


if __name__ == "__main__":

    # La primera vez debemos crear la base de datos
    if not os.path.isfile(DB_PATH):
        db.create_db()

    app.run()
