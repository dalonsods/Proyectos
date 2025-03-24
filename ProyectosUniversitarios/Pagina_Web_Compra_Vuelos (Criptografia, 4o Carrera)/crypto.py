import os
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.exceptions import InvalidKey


def derive_pass(passw: str) -> tuple:
    """Esta función encripta una contraseña y devuelve una tupla con
    un string formato hexadecimal de la contraseña y otro con el salt"""

    # Creamos un salt aleatorio de 16 bytes
    salt = os.urandom(16)

    # kdf necesario para derivar la key
    kdf = Scrypt(
        salt=salt,
        length=32,
        n=2 ** 14,
        r=8,
        p=1,
    )

    # Derivamos la key de la contraseña recibida como parámetro
    key = kdf.derive(passw.encode('utf-8'))

    return key.hex(), salt.hex()


def verify_pass(element: tuple, passw: str) -> bool:
    """Esta función comprueba que la contraseña coincida con la almacenada en
    una tuple (user, email, passEncry, salt) que incluye user, passEncry y salt.
    Devuelve un booleano indicando si es correcta o no"""

    # Intentamos verificar la contraseña proporcionada
    try:
        # Pasamos a bytes el salt proporcionado
        salt = bytes.fromhex(element[3])

        # Creamos el mismo kdf que se creó al derivar
        kdf = Scrypt(
            salt=salt,
            length=32,
            n=2 ** 14,
            r=8,
            p=1,
        )

        # Verificamos
        kdf.verify(passw.encode('utf-8'), bytes.fromhex(element[2]))
        return True

    # Si no se ha podido verificar
    except InvalidKey:
        return False


def encrypt_msg_aesgcm(passw: str, data: tuple) -> tuple:
    """Esta función encripta un conjunto de datos y devuelve una tupla con
    una lista con los datos encriptados formato hexadecimal y el nonce"""

    # Creamos un nonce aleatorio de 12 bytes
    nonce = os.urandom(12)

    # Utilizamos ese mismo nonce para crear un kdf para derivar la contraseña
    kdf = Scrypt(
        salt=nonce,
        length=32,
        n=2 ** 14,
        r=8,
        p=1,
    )

    # Derivamos la contraseña. Esta será nuestra clave de encriptado
    key = kdf.derive(passw.encode('utf-8'))
    # Utilizamos aesgcm
    aesgcm = AESGCM(key)

    # Lista con los datos encriptados
    data_encry = []
    # Encriptamos todos los datos
    for elemento in data:
        ct = aesgcm.encrypt(nonce, elemento.encode('utf-8'), passw.encode('utf-8'))
        data_encry.append(ct.hex())

    print("Se ha encriptado el mensaje", data, "mediante AES-GCM, usando:\n",
          "* Nonce:", nonce, "\n", "* Key:", key, "\n", "produciendo el mensaje cifrado:", data_encry, "\n")

    return nonce.hex(), tuple(data_encry)


def decrypt_msg_aesgcm(ct: str, nonce: str, passw: str) -> str:
    """Esta función desencripta un mensaje encriptado mediante AES-GCM"""

    # Pasamos a bytes el nonce proporcionado
    nonce = bytes.fromhex(nonce)

    # Creamos el mismo kdf que se creó al derivar
    kdf = Scrypt(
        salt=nonce,
        length=32,
        n=2 ** 14,
        r=8,
        p=1,
    )
    # Derivamos la password y creamos el objeto aesgcm
    key = kdf.derive(passw.encode('utf-8'))
    aesgcm = AESGCM(key)

    # Desencriptamos los datos
    data = aesgcm.decrypt(nonce, bytes.fromhex(ct), passw.encode('utf-8')).decode('utf-8')

    print("Se ha desencriptado el mensaje", ct, "mediante AES-GCM, usando:\n",
          "* Nonce:", nonce, "\n", "* Key:", key, "\n", "produciendo el mensaje descifrado:", data, "\n")

    return data
