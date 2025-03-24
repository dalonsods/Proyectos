"""
En este fichero se encuentran todas las funciones necesarias para comunicarse con la base de datos.
"""

import sqlite3 as sql

DB_PATH = "data.db"


def drop_db():
    """Borra las tablas de la base de datos. Si no existieran aparecerá un error en terminal"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        cursor.execute(
            """DROP TABLE historico"""
        )
        cursor.execute(
            """DROP TABLE transacciones"""
        )
        conn.commit()


def create_db():
    """Crea las tablas de la base de datos. Si ya existieran aparecerá un error en terminal"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        cursor.execute(
            """CREATE TABLE historico (
                accion text NOT NULL,
                fecha text NOT NULL,
                divisa text NOT NULL,
                valor REAL NOT NULL,
                PRIMARY KEY (accion, fecha)
            )"""
        )
        cursor.execute(
            """CREATE TABLE transacciones (
                accion text NOT NULL,
                fecha text NOT NULL,
                numero REAL NOT NULL,
                precio REAL NOT NULL,
                valor_local REAL NOT NULL,
                valor_real REAL NOT NULL,
                tipo_cambio REAL NOT NULL,
                comisiones REAL NOT NULL,
                total_real REAL NOT NULL
            )"""
        )
        conn.commit()


def insert_historico(accion, fecha, divisa, valor):
    """Inserta una fila en la tabla users con los valores que se han indicado"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        instruction = f"INSERT INTO historico VALUES ('{accion}', '{fecha}', '{divisa}', {valor})"
        cursor.execute(instruction)
        conn.commit()


def read_historico(accion, fecha):
    """Lee de la base de datos los datos del usuario indicado"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        instruction = f"SELECT * FROM historico WHERE accion='{accion}' and fecha='{fecha}'"
        cursor.execute(instruction)
        datos = cursor.fetchall()
        conn.commit()
        return datos


def read_historico_valor(accion, fecha):
    """Lee de la base de datos los datos del usuario indicado"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        instruction = f"SELECT valor FROM historico WHERE accion='{accion}' and fecha='{fecha}'"
        cursor.execute(instruction)
        datos = cursor.fetchall()
        conn.commit()
        return datos[0][0]


def last_update(accion):
    """Lee de la base de datos los datos del usuario indicado"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        instruction = f"SELECT MAX(fecha) FROM historico WHERE accion='{accion}'"
        cursor.execute(instruction)
        datos = cursor.fetchone()[0]
        conn.commit()
        return datos


def insert_transaccion(accion, fecha, numero, precio, valor_local, valor_real, tipo_cambio, comisiones, total_real):
    """Inserta una fila en la tabla users con los valores que se han indicado"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        instruction = f"INSERT INTO transacciones VALUES ('{accion}', '{fecha}', '{numero}', '{precio}', " \
                      f"'{valor_local}', '{valor_real}', '{tipo_cambio}', '{comisiones}', '{total_real}')"
        cursor.execute(instruction)
        conn.commit()


def read_transacciones(fecha):
    """Lee de la base de datos los datos del usuario indicado"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        instruction = f"SELECT * FROM transacciones where fecha<='{fecha}'"
        cursor.execute(instruction)
        datos = cursor.fetchall()
        conn.commit()
        return datos


def read_transacciones_accion(accion, fecha):
    """Lee de la base de datos los datos del usuario indicado"""

    with sql.connect(DB_PATH) as conn:
        cursor = conn.cursor()
        instruction = f"SELECT * FROM transacciones WHERE accion='{accion}' and fecha<='{fecha}'"
        cursor.execute(instruction)
        datos = cursor.fetchall()
        conn.commit()
        return datos
