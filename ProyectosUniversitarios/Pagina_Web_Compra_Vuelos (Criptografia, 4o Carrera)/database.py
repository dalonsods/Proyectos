import sqlite3 as sql


def drop_db():
    """Borra las tablas de la base de datos. Si no existieran aparecerá un error en terminal"""

    with sql.connect("data.db") as conn:
        cursor = conn.cursor()
        cursor.execute(
            """DROP TABLE bookings"""
        )
        cursor.execute(
            """DROP TABLE users"""
        )
        conn.commit()


def create_db():
    """Crea las tablas de la base de datos. Si ya existieran aparecerá un error en terminal"""

    with sql.connect("data.db") as conn:
        cursor = conn.cursor()
        cursor.execute(
            """CREATE TABLE users (
                user text NOT NULL,
                email text NOT NULL,
                passEncry text NOT NULL,
                salt text NOT NULL,
                PRIMARY KEY (user),
                UNIQUE (email)
            )"""
        )
        cursor.execute(
            """CREATE TABLE bookings (            
                user TEXT NOT NULL,
                destination TEXT NOT NULL,
                date TEXT NOT NULL,
                card TEXT NOT NULL,
                passengers TEXT NOT NULL,
                nonce TEXT NOT NULL,
                PRIMARY KEY (user, date),
                FOREIGN KEY (user) REFERENCES users(user)
            )"""
        )
        conn.commit()


def insert_user(user, email, pass_encry, salt):
    """Inserta una fila en la tabla users con los valores que se han indicado"""

    with sql.connect("data.db") as conn:
        cursor = conn.cursor()
        instruction = f"INSERT INTO users VALUES ('{user.lower()}', '{email}', '{pass_encry}', '{salt}')"
        cursor.execute(instruction)
        conn.commit()


def read_user(user):
    """Lee de la base de datos los datos del usuario indicado"""

    with sql.connect("data.db") as conn:
        cursor = conn.cursor()
        instruction = f"SELECT * FROM users WHERE user='{user}'"
        cursor.execute(instruction)
        datos = cursor.fetchall()
        conn.commit()
        return datos


def insert_booking(user, destination, date, card, passengers, nonce):
    """Inserta una fila en la tabla bookings con los valores que se han indicado. Para que funcione, el user
    debe existir en la tabla users."""

    with sql.connect("data.db") as conn:
        cursor = conn.cursor()
        instruction = f"INSERT INTO bookings VALUES ('{user}', '{destination}', '{date}', '{card}', '{passengers}', " \
                      f"'{nonce}')"
        cursor.execute(instruction)
        conn.commit()


def read_bookings(user):
    """Lee de la base de datos los datos de las reservas del usuario indicado"""

    with sql.connect("data.db") as conn:
        cursor = conn.cursor()
        instruction = f"SELECT date, destination, passengers, nonce FROM bookings WHERE user = '{user}' " \
                      f"ORDER BY date DESC;"
        cursor.execute(instruction)
        datos = cursor.fetchall()
        conn.commit()
        return datos
