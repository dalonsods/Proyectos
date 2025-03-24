
------------------ PRIMER TRIGGER ------------------
-- Trigger para controlar duración de un concierto cuando
-- hay modificaciones en sus temas (inserción, borrado y actualización)
CREATE OR REPLACE TRIGGER modif_concert
-- Lo declaramos 'after' para que solo modifique la duración del concierto
-- si el tema a tocar es válido (evitamos modificar el concierto si introducimos
-- un tema que, por ejemplo, no cumple la clave primaria)
AFTER INSERT OR DELETE OR UPDATE OF duration ON performances
FOR EACH ROW
BEGIN
    IF (INSERTING)
        THEN UPDATE concerts
            -- Es importante dividir entre 60, pues en performances la duración está
            -- en segundos, mientras que en concierto está en minutos
            SET duration = duration + :new.duration/60
            WHERE (performer = :new.performer AND when = :new.when);

    ELSIF (DELETING)
        THEN UPDATE concerts
            SET duration = duration - :old.duration/60
            WHERE (performer = :old.performer AND when = :old.when);

    ELSIF (UPDATING)
        THEN UPDATE concerts
            SET duration = duration - :old.duration/60 + :new.duration/60
            WHERE (performer = :old.performer AND when = :old.when);

    END IF;
END modif_concert;
/

------------------ SEGUNDO TRIGGER ------------------
-- Trigger para rechazar compra de tickets por parte de clientes menores de 18 años.
-- IMPORTANTE: se asume que no son mayores de edad si en el momento de la compra
-- tienen menos de 18 años, independientemente de la edad que tengan cuando
-- se produzca el concierto
CREATE OR REPLACE TRIGGER CHK_mayor_edad
-- Al ser un trigger de rechazo lo creamos de modalidad 'before', para que si
-- no se cumple la condición no intente insertarlo.
BEFORE INSERT ON attendances
FOR EACH ROW
DECLARE birth_client DATE;
BEGIN
    -- Conseguimos birthdate de la tabla clients
    SELECT birthdate INTO birth_client FROM clients
        WHERE e_mail=:new.client;

    -- Si cualquiera de las dos es mayor rechazamos (ver memoria)
    IF ((birth_client > SYSDATE - 6574.36) OR (:new.birthdate > SYSDATE - 6574.36))
        THEN RAISE_APPLICATION_ERROR(-20001, 'El cliente debe ser mayor de edad');
    END IF;
END CHK_mayor_edad;
/

-------------- TERCER TRIGGER (CON error de tabla mutante) --------------
-- Trigger para rechazar la inserción de una canción cuando existe la
-- misma canción pero con los escritores al revés.
CREATE OR REPLACE TRIGGER CHK_song_rev
-- Al ser un trigger de rechazo lo creamos de modalidad 'before', para que si
-- no se cumple la condición no intente insertarlo.
BEFORE INSERT ON songs
FOR EACH ROW
-- La variable 'exist' indica si ha encontrado coincidencias
DECLARE exist NUMBER;
BEGIN
    --Vemos si ya existe esa canción con autores al revés
    SELECT count('x') INTO exist FROM songs
        WHERE (title=:new.title AND writer=:new.cowriter
               AND cowriter=:new.writer);

    -- Si existe, 'exist' será mayor que 0
    IF (exist > 0) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La canción ya existe con autores revertidos');
    END IF;
END CHK_song_rev;
/

-------------- TERCER TRIGGER (SIN error de tabla mutante) --------------
--------------- Este es el trigger definitivo para el 3 -----------------
-- Trigger para rechazar la inserción de una canción cuando existe la
-- misma canción pero con los escritores al revés.
CREATE OR REPLACE TRIGGER CHK_song_rev
-- En este caso, para evitar el error de tabla mutante, cambiaremos el
-- disparador 'before each row' por un disparador 'after each statement'
-- Lo que hará será insertar todas las canciones de la sentencia y,
-- después, comprobará si la inserción ha creado canciones revertidas.
AFTER INSERT ON songs
-- La variable 'exist' indica si ha encontrado coincidencias
DECLARE exist NUMBER;
BEGIN
    --Vemos si se han creado inconsistencias (canciones revertidas)
    SELECT count ('x') INTO exist
        FROM songs s1
        JOIN
        songs s2
        ON (s1.title = s2.title AND s1.writer = s2.cowriter AND s1.cowriter = s2.writer);

    -- Si hay alguna canción que se repita, con autores al revés,
    -- 'exist' será mayor que 0
    IF (exist > 0) THEN
        RAISE_APPLICATION_ERROR(-20002, 'La canción ya existe con autores revertidos');
    END IF;
END CHK_song_rev;
/

--------- TERCER TRIGGER (Compuesto v1)(CON error de tabla mutante) -----------
CREATE OR REPLACE TRIGGER CHK_song_rev
FOR INSERT ON songs
COMPOUND TRIGGER
    -- vartabla va a ser una tabla auxiliar con las mismas columnas que songs
    TYPE temp_tab IS TABLE OF songs%rowtype index by binary_integer;
    vartabla temp_tab;
    exist NUMBER:=0;

-- Inicialmente, guardamos el contenido de songs en una tabla
-- auxiliar, para poder hacer consultas sobre ella mientras muta
-- Para ello hacemos uso de 'before statement'
BEFORE STATEMENT IS
    BEGIN
        -- Copia de songs en vartabla
        SELECT title, writer, cowriter BULK COLLECT INTO vartabla
            FROM songs;
    END BEFORE STATEMENT;

-- Para cada 'row' a insertar, comprobaremos si existen
-- inconsistencias, comparando con vartabla
BEFORE EACH ROW IS
    BEGIN
        -- Vemos si ya existe esa canción con autores al revés en
        -- la tabla auxiliar, para ello iteramos sobre vartabla
        FOR i in 1..vartabla.count loop
            -- Si existe, ponemos 'exist' a 1
            IF (vartabla(i).title = :new.title AND
                vartabla(i).writer = :new.cowriter AND
                vartabla(i).cowriter = :new.writer)
                THEN exist:=1;
            END IF;
        END LOOP;
        -- Si existe la revertida, 'exist' será mayor que 0 (será 1)
        IF (exist > 0) THEN
            RAISE_APPLICATION_ERROR(-20002, 'La canción ya existe con autores revertidos');
        -- En caso contrario, actualizamos vartabla y se añade la canción
        ELSE
            vartabla(vartabla.count+1).title := :new.title;
            vartabla(vartabla.count).writer := :new.writer;
            vartabla(vartabla.count).cowriter := :new.cowriter;
        END IF;
    END BEFORE EACH ROW;
END CHK_song_rev -- Falta ';' No ejecutar este trigger, error de tabla mutante

--------- TERCER TRIGGER (Compuesto v2)(CON error de tabla mutante) -----------
CREATE OR REPLACE TRIGGER CHK_song_rev
FOR INSERT ON songs
COMPOUND TRIGGER
    TYPE temp_tab IS TABLE OF songs%rowtype index by binary_integer;
    vartabla temp_tab;
    exist NUMBER:=0;
    -- Inicialmente, guardamos el contenido de songs en un cursor,
    -- para poder hacer la copia de somgs desde la cabecera del trigger
    CURSOR my_cursor IS SELECT title, writer, cowriter FROM songs;

-- Copiamos el contenido del cursor en la tabla auxiliar vartabla
-- para poder hacer consultas sobre ella mientras muta
-- Para ello hacemos uso de 'before statement'
BEFORE STATEMENT IS
    BEGIN
        OPEN my_cursor;
        FETCH my_cursor BULK COLLECT INTO vartabla;
        CLOSE my_cursor;
    END BEFORE STATEMENT;

-- Para cada 'row' a insertar, comprobaremos si existen
-- inconsistencias, comparando con vartabla
BEFORE EACH ROW IS
    BEGIN
        -- Vemos si ya existe esa canción con autores al revés en
        -- la tabla auxiliar, para ello iteramos sobre vartabla
        FOR i in 1..vartabla.count loop
            -- Si existe, ponemos 'exist' a 1
            IF (vartabla(i).title = :new.title AND
                vartabla(i).writer = :new.cowriter AND
                vartabla(i).cowriter = :new.writer)
                THEN exist:=1;
            END IF;
        END LOOP;
        -- Si existe la revertida, 'exist' será mayor que 0 (será 1)
        IF (exist > 0) THEN
            RAISE_APPLICATION_ERROR(-20002, 'La canción ya existe con autores revertidos');
        -- En caso contrario, actualizamos vartabla y se añade la canción
        ELSE
            vartabla(vartabla.count+1).title := :new.title;
            vartabla(vartabla.count).writer := :new.writer;
            vartabla(vartabla.count).cowriter := :new.cowriter;
        END IF;
    END BEFORE EACH ROW;
END CHK_song_rev -- Falta ';' No ejecutar este trigger, error de tabla mutante
