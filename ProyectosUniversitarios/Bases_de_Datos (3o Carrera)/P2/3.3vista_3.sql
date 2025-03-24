
------------------ TERCERA VISTA ------------------
DROP TABLE VETADOS;

-- Creamos una tabla auxiliar, vetados, que almacenará
-- qué clientes están vetados por qué artista
CREATE TABLE VETADOS(
    CLIENT       VARCHAR2(100) NOT NULL,
    PERFORMER    VARCHAR2(50) NOT NULL,
    CONSTRAINT PK_VETADOS PRIMARY KEY(CLIENT, PERFORMER),
    CONSTRAINT FK_VETADOS FOREIGN KEY(CLIENT)
        REFERENCES CLIENTS ON DELETE CASCADE
);

-- Ahora creamos la vista 'fans' que utilizará la anterior
-- tabla para mostrar los fans no vetados
CREATE OR REPLACE VIEW fans AS
    -- Seleción de los clientes del int_actual que han ido
    -- a más de un concierto
    WITH client_masdeuno AS (
        SELECT CLIENT
            FROM attendances
            WHERE performer=melopack.int_actual
            GROUP BY CLIENT
            HAVING COUNT('x')>1),
    -- Unimos la anterior tabla con clientes para sacar el resto
    -- de información necesaria de los clientes
    fans_alldata AS (
        SELECT E_MAIL, NAME NOMBRE, SURN1 APELL1, SURN2 APELL2,
            TRUNC((SYSDATE - BIRTHDATE)/365.2422, 0) EDAD
            FROM client_masdeuno
            JOIN CLIENTS ON (CLIENT=E_MAIL))
    -- Consulta final. Del total de clientes con más de un concierto,
    -- solo mostramos los que no están vetados
    SELECT E_MAIL, NOMBRE, APELL1, APELL2, EDAD
        FROM fans_alldata
        WHERE E_MAIL NOT IN (
            SELECT CLIENT FROM VETADOS
            WHERE PERFORMER=melopack.int_actual);

-- Creamos un trigger para la vista, para insertar/borrar/actualizar
CREATE OR REPLACE TRIGGER modif_fans
-- Lo declaramos de tipo INSTEAD OF para que realice la operación que
-- indiquemos en lugar de insert/delete/update
INSTEAD OF INSERT OR DELETE OR UPDATE ON fans
FOR EACH ROW
DECLARE
    client_ban NUMBER;
    exist_client NUMBER;
    num_attend NUMBER;
BEGIN
    -- Si intenta insertar, insertamos el cliente si no existiera y
    -- le asignamos conciertos para que tenga al menos 2. Además,
    -- si estuviera vetado lo desvetamos
    IF (INSERTING)
        THEN

        -- Si esta vetado guardará un 1, si no un 0
        SELECT count('x') INTO client_ban FROM VETADOS
            WHERE (CLIENT=:new.e_mail
                AND PERFORMER=melopack.int_actual);
        -- Si existe en 'clients' guardara un 1, si no 0
        SELECT count('x') INTO exist_client FROM CLIENTS
            WHERE E_MAIL=:new.e_mail;
        -- Cuenta el número de attendances para int_actual
        SELECT count('x') INTO num_attend FROM ATTENDANCES
            WHERE (CLIENT=:new.e_mail
                AND PERFORMER=melopack.int_actual);

        -- Si está vetado, lo desvetamos
        IF (client_ban > 0) THEN
            DELETE FROM VETADOS
            WHERE (CLIENT=:new.e_mail
                AND PERFORMER=melopack.int_actual);

        -- Si no existe el cliente, se crea y se le asignan los dos
        ELSIF (exist_client = 0)
            THEN
            -- Insertamos el cliente
            INSERT INTO CLIENTS(E_MAIL, NAME, SURN1, SURN2)
                VALUES(:new.e_mail, :new.nombre, :new.apell1, :new.apell2);
            -- Insertamos también dos attendances
            INSERT INTO ATTENDANCES (SELECT :new.e_mail, PERFORMER, WHEN,
                'RFID'||:new.e_mail, SYSDATE - :new.edad*365.2422, SYSDATE
                FROM (SELECT * FROM CONCERTS ORDER BY WHEN DESC)
                WHERE PERFORMER=melopack.int_actual
                AND rownum < 3);

        -- Si existe el cliente, pero tiene 0 attendances se le asignan 2
        ELSIF (num_attend = 0)
            THEN
            -- Insertamos dos attendances
            INSERT INTO ATTENDANCES (SELECT :new.e_mail, PERFORMER, WHEN,
                'RFID'||:new.e_mail, SYSDATE - :new.edad*365.2422, SYSDATE
                FROM (SELECT * FROM CONCERTS ORDER BY WHEN DESC)
                WHERE PERFORMER=melopack.int_actual
                AND rownum < 3);

        -- En caso contrario, el cliente existe y tiene 1 attendance, le
        -- asignamos otra
        ELSIF (num_attend = 1) THEN
            -- Intentamos añadir el último concierto
            BEGIN
                INSERT INTO ATTENDANCES SELECT :new.e_mail, PERFORMER, WHEN,
                    'RFID'||:new.e_mail, SYSDATE - :new.edad*365.2422, SYSDATE
                    FROM (SELECT * FROM CONCERTS ORDER BY WHEN DESC)
                    WHERE PERFORMER=melopack.int_actual
                    AND rownum = 1;
            -- Si da error puede significar que ya tenía entrada para ese
            -- concierto, insertamos insertar el siguiente
            EXCEPTION WHEN OTHERS THEN
                INSERT INTO ATTENDANCES SELECT :new.e_mail, PERFORMER, WHEN,
                    'RFID'||:new.e_mail, SYSDATE - :new.edad*365.2422, SYSDATE
                    FROM (SELECT * FROM CONCERTS ORDER BY WHEN DESC)
                    WHERE PERFORMER=melopack.int_actual
                    AND rownum = 2;
            END;
        -- Si no está vetado, existe y tiene más de 2 attendances significa que
        -- se está insertando un cliente que ya existe en la vista. Error.
        ELSE
            dbms_output.put_line('El fan introducido ya existe');
            RAISE_APPLICATION_ERROR(-20006, 'El fan introducido ya existe');
        END IF;

    -- Si intenta borrar, añadimos el cliente a la tabla vetados
    ELSIF (DELETING)
        THEN INSERT INTO vetados
            VALUES(:old.e_mail, melopack.int_actual);

    -- Si intenta actualizar, mostramos un error indicando que no es posible
    ELSIF (UPDATING)
        THEN dbms_output.put_line('No está permitida la actualización.');
        RAISE_APPLICATION_ERROR(-20007, 'No está permitida la actualización.');

    END IF;
-- Si se produce excepción lo comunicamos
EXCEPTION WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20008, 'Error. Puede haber parámetros u operaciones incorrectas');
END modif_fans;
/