-- Insertamos los interpretes
INSERT INTO interprete(nom_artist, nacionalidad, idioma) (
    SELECT DISTINCT BAND, BAND_NATION, BAND_LANGUAGE
    FROM fsdb.artists
    WHERE BAND IS NOT NULL AND BAND_NATION IS NOT NULL AND BAND_LANGUAGE IS NOT NULL
);

-- Insertamos los musicos
INSERT INTO musico(pasaporte, nombre_comp, nacionalidad, fecha_nac) (
    SELECT DISTINCT PASSPORT, MUSICIAN, NATIONALITY, TO_DATE(BIRTHDATE, 'DD-MM-YYYY')
    FROM fsdb.artists
    WHERE PASSPORT IS NOT NULL AND MUSICIAN IS NOT NULL AND NATIONALITY IS NOT NULL AND BIRTHDATE IS NOT NULL
);

-- Insertamos los musicos que pertenecen a un grupo o son solistas, excepto los que no tienen fecha de incorporacion o
-- la fecha de incorporacion es mayor que la de baja
INSERT INTO mus_pertenece(musico, interprete, fecha_inic, fecha_fin, rol) (
    SELECT DISTINCT PASSPORT, BAND, TO_DATE(START_DATE, 'DD-MM-YYYY'), TO_DATE(END_DATE, 'DD-MM-YYYY'), ROLE
    FROM fsdb.artists
    WHERE PASSPORT IS NOT NULL AND BAND IS NOT NULL AND START_DATE IS NOT NULL AND ROLE IS NOT NULL
    AND((END_DATE IS NULL) OR (TO_DATE(END_DATE, 'DD-MM-YYYY') >= TO_DATE(START_DATE, 'DD-MM-YYYY')))
);

-- Insertamos aquellos en los que la fecha de incorporacion es mayor que la de baja
-- DECISION -> Cambiamos las fechas de orden
INSERT INTO mus_pertenece(musico, interprete, fecha_inic, fecha_fin, rol) (
    SELECT DISTINCT PASSPORT, BAND, TO_DATE(END_DATE, 'DD-MM-YYYY'), TO_DATE(START_DATE, 'DD-MM-YYYY'), ROLE
    FROM fsdb.artists
    WHERE PASSPORT IS NOT NULL AND BAND IS NOT NULL AND START_DATE IS NOT NULL AND ROLE IS NOT NULL
    AND NOT ((END_DATE IS NULL) OR (TO_DATE(END_DATE, 'DD-MM-YYYY') >= TO_DATE(START_DATE, 'DD-MM-YYYY')))
);

-- Insertamos los musicos que tienen grupo pero no tienen fecha de incorporacion.
-- DECISION -> en START_DATE ponemos la fecha actual, pues es cuando nos hemos dado cuenta de que faltaba
INSERT INTO mus_pertenece(musico, interprete, fecha_inic, fecha_fin, rol) (
    SELECT DISTINCT PASSPORT, BAND, SYSDATE, END_DATE, ROLE
    FROM fsdb.artists
    WHERE PASSPORT IS NOT NULL AND BAND IS NOT NULL AND START_DATE IS NULL AND END_DATE IS NULL
);

-- Insercion de manager (union de managers de evento y de albumes)
INSERT INTO manager(nombre, apellido, apellido2, movil) (
    SELECT DISTINCT MANAGER_NAME, MAN_FAM_NAME, MAN_SURNAME, MAN_MOBILE FROM (
        SELECT DISTINCT MANAGER_NAME, MAN_FAM_NAME, MAN_SURNAME, MAN_MOBILE
                FROM fsdb.livesingings
        UNION
        SELECT DISTINCT MANAGER_NAME, MAN_FAM_NAME, MAN_SURNAME, MAN_MOBILE
                FROM fsdb.recordings)

    WHERE MANAGER_NAME IS NOT NULL AND MAN_FAM_NAME IS NOT NULL AND MAN_MOBILE IS NOT NULL
);

-- Insertamos las giras
INSERT INTO gira(interprete, nombre, manager) (
    SELECT DISTINCT PERFORMER, TOUR, MAN_MOBILE
    FROM fsdb.livesingings
    WHERE PERFORMER IS NOT NULL AND TOUR IS NOT NULL AND MAN_MOBILE IS NOT NULL
);

-- Insertamos los eventos que tengan numero de asistentes no nulo
INSERT INTO evento(interprete, fecha, nom_gira, manager, municipio, pais, direccion, asistentes, duracion) (
    SELECT DISTINCT PERFORMER, WHEN, TOUR, MAN_MOBILE, MUNICIPALITY, COUNTRY, ADDRESS, ATTENDANCE, DURATION_MIN
    FROM fsdb.livesingings
    WHERE PERFORMER IS NOT NULL AND WHEN IS NOT NULL AND MAN_MOBILE IS NOT NULL AND MUNICIPALITY IS NOT NULL AND
    COUNTRY IS NOT NULL AND ADDRESS IS NOT NULL AND ATTENDANCE IS NOT NULL AND DURATION_MIN IS NOT NULL
);

-- Insertamos los eventos que tengan numero de asistentes nulo, la tabla les dara valor 0 por defecto
INSERT INTO evento(interprete, fecha, nom_gira, manager, municipio, pais, direccion, duracion) (
    SELECT DISTINCT PERFORMER, WHEN, TOUR, MAN_MOBILE, MUNICIPALITY, COUNTRY, ADDRESS, DURATION_MIN
    FROM fsdb.livesingings
    WHERE PERFORMER IS NOT NULL AND WHEN IS NOT NULL AND MAN_MOBILE IS NOT NULL AND MUNICIPALITY IS NOT NULL AND
    COUNTRY IS NOT NULL AND ADDRESS IS NOT NULL AND DURATION_MIN IS NOT NULL
);

-- Insertamos los temas, haciendo una union entre temas de evento y recordings
INSERT INTO tema(titulo_tema, autor, autor_sec) (
    SELECT DISTINCT SONG, WRITER, COWRITER FROM (
        SELECT DISTINCT SONG, WRITER, COWRITER
                FROM fsdb.livesingings
        UNION
        SELECT DISTINCT SONG, WRITER, COWRITER
                FROM fsdb.recordings)

    WHERE SONG IS NOT NULL AND WRITER IS NOT NULL
);

-- Insertamos los temas de evento
INSERT INTO tema_concierto(titulo_tema, autor, interprete, fecha, orden_seq, duracion) (
    SELECT DISTINCT SONG, WRITER, PERFORMER, WHEN, SEQNUMBER, DURATION_SEC
    FROM fsdb.livesingings
    WHERE SONG IS NOT NULL AND WRITER IS NOT NULL AND PERFORMER IS NOT NULL AND
    WHEN IS NOT NULL AND SEQNUMBER IS NOT NULL AND DURATION_SEC IS NOT NULL
);

-- Insertamos las discograficas
INSERT INTO discografica(nombre_discog, tlf_disc) (
    SELECT DISTINCT PUBLISHER, PUB_PHONE
    FROM fsdb.recordings
    WHERE PUBLISHER IS NOT NULL AND PUB_PHONE IS NOT NULL
);

-- Insertamos los albumes
INSERT INTO album(pair, interprete, nombre_alb, formato, fecha_alb, discografica, manager, duracion) (
    SELECT DISTINCT ALBUM_PAIR, PERFORMER, ALBUM_TITLE, FORMAT, RELEASE_DATE, PUBLISHER, MAN_MOBILE, ALBUM_LENGTH
    FROM fsdb.recordings
    WHERE ALBUM_PAIR IS NOT NULL AND PERFORMER IS NOT NULL AND ALBUM_TITLE IS NOT NULL AND FORMAT IS NOT NULL AND
    RELEASE_DATE IS NOT NULL AND PUBLISHER IS NOT NULL AND MAN_MOBILE IS NOT NULL AND ALBUM_LENGTH IS NOT NULL
);

-- Insertamos los estudios
INSERT INTO estudio(nombre_est, dir_est) (
    SELECT DISTINCT STUDIO, STUD_ADDRESS
    FROM fsdb.recordings
    WHERE STUDIO IS NOT NULL AND STUD_ADDRESS IS NOT NULL
);

-- Insertamos las pistas
INSERT INTO pista(titulo_tema, autor, interprete, fecha_grab, ingeniero, estudio, duracion) (
    SELECT DISTINCT SONG, WRITER, PERFORMER, REC_DATE, ENGINEER, STUDIO, DURATION
    FROM fsdb.recordings
    WHERE SONG IS NOT NULL AND WRITER IS NOT NULL AND PERFORMER IS NOT NULL AND REC_DATE IS NOT NULL AND
    ENGINEER IS NOT NULL AND STUDIO IS NOT NULL AND DURATION IS NOT NULL
);

-- Insertamos las pistas de album, excepto la cancion 'Die and thyme' del album 'I7625DU181121GN'
-- DECISION -> Esta canción tiene un traknum de 9, pero ya existia en la base, asi que le asignamos el 10
-- en el siguiente insert
INSERT INTO pista_album(titulo_tema, autor, interprete, fecha_grab, pair, num_pista) (
    SELECT DISTINCT SONG, WRITER, PERFORMER, REC_DATE, ALBUM_PAIR, TRACKNUM
    FROM fsdb.recordings
    WHERE SONG IS NOT NULL AND WRITER IS NOT NULL AND PERFORMER IS NOT NULL AND REC_DATE IS NOT NULL AND
    ALBUM_PAIR IS NOT NULL AND TRACKNUM IS NOT NULL
    AND NOT (ALBUM_PAIR='I7625DU181121GN' AND SONG='Die and thyme')
);

-- Insercion de la cancion 'Die and thyme' del album 'I7625DU181121GN' con numtrack 10 en vez de 9
INSERT INTO pista_album(titulo_tema, autor, interprete, fecha_grab, pair, num_pista) (
    SELECT DISTINCT SONG, WRITER, PERFORMER, REC_DATE, ALBUM_PAIR, 10
    FROM fsdb.recordings
    WHERE SONG IS NOT NULL AND WRITER IS NOT NULL AND PERFORMER IS NOT NULL AND REC_DATE IS NOT NULL AND
    ALBUM_PAIR IS NOT NULL AND TRACKNUM IS NOT NULL
    AND (ALBUM_PAIR='I7625DU181121GN' AND SONG='Die and thyme')
);

-- Insertamos a los clientes
INSERT INTO cliente(email, dni, nombre, ap1, ap2, fecha_nac, tlf, dir) (
    SELECT DISTINCT E_MAIL, DNI, NAME, SURN1, SURN2, BIRTHDATE, PHONE, ADDRESS
    FROM fsdb.melomaniacs
    WHERE E_MAIL IS NOT NULL
);

-- Insertamos las fichas de evento_cliente, solo aquellas que tengan un interprete correcto
INSERT INTO ficha(interprete, fecha, cliente, rfid, fecha_nac, fecha_compra) (
    SELECT DISTINCT PERFORMER, WHEN, E_MAIL, RFID, BIRTHDATE, PURCHASE
    FROM fsdb.melomaniacs
    WHERE PERFORMER IS NOT NULL AND WHEN IS NOT NULL AND E_MAIL IS NOT NULL AND RFID IS NOT NULL AND
    BIRTHDATE IS NOT NULL AND PURCHASE IS NOT NULL
    AND PERFORMER IN (SELECT nom_artist FROM interprete) -- INTERPRETE EXISTE
);

-- Insertamos las fichas de evento_cliente, cambiando el nombre incorrecto por el correcto
INSERT INTO ficha(interprete, fecha, cliente, rfid, fecha_nac, fecha_compra) (
    SELECT DISTINCT 'Cunegunda', WHEN, E_MAIL, RFID, BIRTHDATE, PURCHASE
    FROM fsdb.melomaniacs
    WHERE PERFORMER IS NOT NULL AND WHEN IS NOT NULL AND E_MAIL IS NOT NULL AND RFID IS NOT NULL AND
    BIRTHDATE IS NOT NULL AND PURCHASE IS NOT NULL
    AND PERFORMER NOT IN (SELECT nom_artist FROM interprete) -- INTERPRETE MAL ESCRITO, NO EXISTE
);
