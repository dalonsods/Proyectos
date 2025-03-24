
-- Paquete melopack
CREATE OR REPLACE PACKAGE melopack AS
-- Procedimiento para asignar un valor a intérprete actual
PROCEDURE asig_interp(interprete varchar2);
-- Función que devuelve el valor actual de intérprete
FUNCTION int_actual RETURN varchar2;
-- Procedimiento para insertar un álbum y una grabación
-- Si el álbum ya existe debe insertar solo la grabación
PROCEDURE insert_alb_track(PAIR_ins char, format char, a_title varchar2, release_date date, publisher varchar2,
    manager number, sequ_ins number, s_title varchar2, writer char, duration number, rec_date date,
    studio varchar2, engineer varchar2);
-- Procedimiento para borrar una grabación de un álbum
-- Si es la única grabación del álbum, éste también se borra
PROCEDURE delete_alb_track(PAIR_del char, sequ_del number);
-- Procedimiento para generar el informe
PROCEDURE informe;
-- Variable con el intérprete actual
inter_actual varchar2(50);

END melopack;
/

-- Cuerpo del paquete
CREATE OR REPLACE PACKAGE BODY melopack AS

-- Procedimiento para asignar valor a intérprete actual
PROCEDURE asig_interp(interprete varchar2) IS
BEGIN
    inter_actual := interprete;
END;

-- Función que devuelve el valor actual de intérprete
FUNCTION int_actual RETURN varchar2 IS
BEGIN
    RETURN inter_actual;
END;

-- Procedimiento para insertar un álbum y una grabación
-- Si el álbum ya existe debe insertar solo la grabación
PROCEDURE insert_alb_track(PAIR_ins char, format char, a_title varchar2, release_date date, publisher varchar2,
    manager number, sequ_ins number, s_title varchar2, writer char, duration number, rec_date date,
    studio varchar2, engineer varchar2) IS
    exists_alb NUMBER;
BEGIN
    -- Comprobamos que los parámetros identificativos no sean null
    IF (PAIR_ins IS NULL OR sequ_ins IS NULL)
        THEN RAISE_APPLICATION_ERROR(-20003, 'Algunos parámetros no pueden ser nulos.');
    ELSE
        -- Contamos el número de álbumes que existen con ese PAIR (0 o 1)
        SELECT count('x') INTO exists_alb FROM albums
            WHERE PAIR=PAIR_ins;
        -- Si no existe el album lo creamos
        IF (exists_alb = 0)
            THEN INSERT INTO albums
                VALUES(PAIR_ins, inter_actual, format, a_title,
                       release_date, publisher, manager);
        END IF;
        -- Si se produce un error puede haber parámetros incorrectos o nulos
        -- Si se ha llegado hasta aquí es porque o el album existía o
        -- se ha creado correctamente. Insertamos el track.
        INSERT INTO tracks
            VALUES(PAIR_ins, sequ_ins, s_title, writer, duration,
                   rec_date, studio, engineer);
        -- Si se produce un error puede haber parámetros incorrectos o nulos
    END IF;
-- Bloque para recoger las excepciones causadas por un fallo al insertar
EXCEPTION
    WHEN OTHERS THEN RAISE_APPLICATION_ERROR(-20004, 'Parámetros incorrectos');
END;

-- Procedimiento para borrar una grabación de un álbum
-- Si es la única grabación del álbum, éste tambien se borra
PROCEDURE delete_alb_track(PAIR_del char, sequ_del number) IS
    num_tracks NUMBER;
BEGIN
    IF (PAIR_del IS NULL OR sequ_del IS NULL)
        THEN RAISE_APPLICATION_ERROR(-20005, 'Los parámetros deben ser no nulos.');
    ELSE
        SELECT count('x') INTO num_tracks FROM tracks
            WHERE PAIR=PAIR_del;
        -- Si hay más de 1 numtrack, borramos solo el sequ indicado
        IF num_tracks > 1
            THEN DELETE FROM tracks
                WHERE(PAIR=PAIR_del AND sequ=sequ_del);
        -- En caso contrario, si hay 1 track, al borrarlo hay que borrar
        -- también el álbum. Gracias al delete cascade podemos eliminar solo
        -- el album y se borra también el track
        ELSE
            DELETE FROM albums
                WHERE(PAIR=PAIR_del);
        END IF;
    END IF;
END;

-- Procedimiento para generar el informe
PROCEDURE informe IS
-- Cursor con la consulta para los datos de los albumes
CURSOR data_albs IS
    WITH info_alb_tracks AS (
        SELECT PAIR, COUNT('x') NUM_TRACKS, SUM(DURATION) DUR
        FROM TRACKS
        GROUP BY PAIR
    ),
    info_alb_ext AS (
        SELECT PAIR, FORMAT, NUM_TRACKS, DUR, REL_DATE
        FROM (info_alb_tracks
        NATURAL JOIN ALBUMS)
        WHERE PERFORMER=inter_actual
    ),
    all_data_alb AS (
        SELECT FORMAT, COUNT('X') NUM_ALB, ROUND(AVG(NUM_TRACKS),2) TRACK_MED,
        ROUND(AVG(DUR), 2) DUR_MED, MAX(REL_DATE)- MIN(REL_DATE) DIFF_DATE
            FROM info_alb_ext
            GROUP BY FORMAT
    )
    SELECT DECODE(FORMAT, 'T', 'STREAMING', 'C', 'CD', 'M', 'AUDIO FILE',
        'V', 'VYNIL', 'S', 'SINGLE', 'NO FORMAT') FORMAT,
        NUM_ALB, TRACK_MED, DUR_MED, DIFF_DATE
            FROM all_data_alb;
-- Cursor con la consulta para los datos de los conciertos
CURSOR data_concerts IS
    WITH info_conc_canc AS (
        SELECT PERFORMER, WHEN, COUNT('x') NUM_CANC
        FROM PERFORMANCES
        WHERE PERFORMER=inter_actual
        GROUP BY PERFORMER, WHEN
    ),
    info_conc_ext AS (
        SELECT PERFORMER, WHEN, NUM_CANC, DURATION
        FROM (info_conc_canc
        NATURAL JOIN CONCERTS)
    )
    SELECT COUNT('X') NUM_CONC, ROUND(AVG(NUM_CANC),2) CANC_MED,
        ROUND(AVG(DURATION), 2) DURA_MED, MAX(WHEN)- MIN(WHEN) DIFF_DATES
            FROM info_conc_ext;
-- Cursor con la consulta para los datos de las discograficas
CURSOR discog IS
    SELECT PUBLISHER, COUNT('X') COLABORACIONES
        FROM ALBUMS
        WHERE PERFORMER=inter_actual
        GROUP BY PUBLISHER;
-- Cursor con la consulta para los datos de los managers de album
CURSOR man_albs IS
    SELECT MANAGER, COUNT('X') COLABORACIONES
        FROM ALBUMS
        WHERE PERFORMER=inter_actual
        GROUP BY MANAGER;
-- Cursor con la consulta para los datos de los managers de concierto
CURSOR man_conc IS
    SELECT MANAGER, COUNT('X') COLABORACIONES
        FROM CONCERTS
        WHERE PERFORMER=inter_actual
        GROUP BY MANAGER;
-- Cursor con la consulta para los datos de los studios
CURSOR stud IS
    SELECT STUDIO, COUNT('X') COLABORACIONES
        FROM (TRACKS NATURAL JOIN ALBUMS)
        WHERE PERFORMER=inter_actual
        GROUP BY STUDIO;
-- Cursor con la consulta para los datos de los engineer
CURSOR engin IS
    SELECT ENGINEER, COUNT('X') COLABORACIONES
        FROM (TRACKS NATURAL JOIN ALBUMS)
        WHERE PERFORMER=inter_actual
        GROUP BY ENGINEER;

-- Fila para iterar los datos de albumes
fila_albs data_albs%rowtype;
-- Fila para iterar los datos de conciertos
fila_conc data_concerts%rowtype;
-- Fila para iterar los datos de discograficas
fila_discog discog%rowtype;
-- Fila para iterar los datos de manager de album
fila_man_albs man_albs%rowtype;
-- Fila para iterar los datos de manager de album
fila_man_conc man_conc%rowtype;
-- Fila para iterar los datos de studio
fila_stud stud%rowtype;
-- Fila para iterar los datos de manager de album
fila_engin engin%rowtype;

-- Contadores para saber el total de cada
tot_conc NUMBER;
tot_tracks NUMBER;
tot_albums NUMBER;

-- Contador para saber si existe el performer
exist_p NUMBER;

BEGIN
    SELECT COUNT('X') INTO exist_p FROM PERFORMERS
        WHERE NAME=inter_actual;

    -- Si no existe el intérprete sale del procedimiento con error
    IF (exist_p = 0)
        THEN RAISE_APPLICATION_ERROR(-20010, 'No hay datos sobre el intéprete.');
    END IF;

    -- Contamos el número total de albumes
    SELECT COUNT('X') INTO tot_albums FROM ALBUMS
        WHERE PERFORMER=inter_actual;
    -- Contamos el número total de tracks
    SELECT COUNT('X') INTO tot_tracks
        FROM (TRACKS NATURAL JOIN ALBUMS)
        WHERE PERFORMER=inter_actual;
    -- Contamos el número total de conciertos
    SELECT COUNT('X') INTO tot_conc FROM CONCERTS
        WHERE PERFORMER=inter_actual;

    -- Inicio
    dbms_output.put_line('INFORME SOBRE INTÉRPRETE');
    dbms_output.put_line(' ');
    dbms_output.put_line('Esto es un informe sobre el intérprete: '||inter_actual);
    dbms_output.put_line(' ');
    dbms_output.put_line('El objeto de este informe es resumir las estadísticas del intérprete seleccionado');
    dbms_output.put_line('y de sus colaboradores. En cuanto a las estadísticas propias, se hará hincapié');
    dbms_output.put_line('en los álbumes, agrupados por formato y en los conciertos. En relación a los ');
    dbms_output.put_line('colaboradores, se mostrarán las participaciones de cada uno en la banda, y el ');
    dbms_output.put_line('porcentaje que representa sobre el total.');
    dbms_output.put_line(' ');

    -- Datos sobre los álbumes
    OPEN data_albs;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('---------------------- ESTADÍSTICAS DE ÁLBUMES POR FORMATO -----------------------');
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('|  FORMATO   | ÁLBUMES | TRACKS/ALB | DURACIÓN MEDIA | TIEMPO ENTRE LANZAMIENTOS |');
    LOOP
        FETCH data_albs INTO fila_albs;
        EXIT WHEN data_albs%notfound;
        dbms_output.put_line(RPAD('-', 82, '-'));
        dbms_output.put_line('| '||RPAD(fila_albs.FORMAT, 10)||
            ' | '||LPAD(fila_albs.NUM_ALB, 7)||
            ' | '||LPAD(fila_albs.TRACK_MED, 10)||
            ' | '||LPAD(fila_albs.DUR_MED, 14)||
            ' | '||LPAD(ROUND((fila_albs.DIFF_DATE/fila_albs.NUM_ALB), 2)||' DIAS', 25)||' |');
    END LOOP;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line(' ');
    CLOSE data_albs;

    -- Datos sobre los conciertos
    OPEN data_concerts;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('-------------------------- ESTADÍSTICAS DE CONCIERTOS  ---------------------------');
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('|   CONCIERTOS   |  CANCIONES/CONC  |   DURACIÓN/CONC   |   PERIODICIDAD (DÍAS)  |');
    LOOP
        FETCH data_concerts INTO fila_conc;
        EXIT WHEN data_concerts%notfound;
        dbms_output.put_line(RPAD('-', 82, '-'));
        dbms_output.put_line('| '||LPAD(fila_conc.NUM_CONC, 14)||
            ' | '||LPAD(fila_conc.CANC_MED, 16)||
            ' | '||LPAD(fila_conc.DURA_MED, 17)||
            ' | '||LPAD(ROUND((fila_conc.DIFF_DATES/fila_conc.NUM_CONC), 2)||' DIAS', 22)||' |');
    END LOOP;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line(' ');
    CLOSE data_concerts;

    -- Datos sobre las discográficas
    OPEN discog;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('------------------------ COLABORACIONES DE DISCOGRÁFICAS  ------------------------');
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('|       DISCOGRÁFICA       |  COLABORACIONES TOTALES  | COLABORACIONES RELATIVAS |');
    LOOP
        FETCH discog INTO fila_discog;
        EXIT WHEN discog%notfound;
        dbms_output.put_line(RPAD('-', 82, '-'));
        dbms_output.put_line('| '||RPAD(fila_discog.PUBLISHER, 24)||
            ' | '||LPAD(fila_discog.COLABORACIONES, 24)||
            ' | '||LPAD(ROUND((fila_discog.COLABORACIONES/tot_albums)*100, 2)||'%', 24)||' |');
    END LOOP;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line(' ');
    CLOSE discog;

    -- Datos sobre los estudios
    OPEN stud;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('------------------------- COLABORACIONES DE ESTUDIOS  ----------------------------');
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('|                     ESTUDIO                        |  COLAB TOT  |  COLAB REL  |');
    LOOP
        FETCH stud INTO fila_stud;
        EXIT WHEN stud%notfound;
        dbms_output.put_line(RPAD('-', 82, '-'));
        dbms_output.put_line('| '||RPAD(fila_stud.STUDIO, 50)||
            ' | '||LPAD(fila_stud.COLABORACIONES, 11)||
            ' | '||LPAD(ROUND((fila_stud.COLABORACIONES/tot_tracks)*100, 2)||'%', 11)||' |');
    END LOOP;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line(' ');
    CLOSE stud;

    -- Datos sobre los ingenieros
    OPEN engin;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('----------------------- COLABORACIONES DE INGENIEROS  ----------------------------');
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('|                    INGENIERO                       |  COLAB TOT  |  COLAB REL  |');
    LOOP
        FETCH engin INTO fila_engin;
        EXIT WHEN engin%notfound;
        dbms_output.put_line(RPAD('-', 82, '-'));
        dbms_output.put_line('| '||RPAD(fila_engin.ENGINEER, 50)||
            ' | '||LPAD(fila_engin.COLABORACIONES, 11)||
            ' | '||LPAD(ROUND((fila_engin.COLABORACIONES/tot_tracks)*100, 2)||'%', 11)||' |');
    END LOOP;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line(' ');
    CLOSE engin;

    -- Datos sobre los managers (conciertos)
    OPEN man_conc;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('------------------ COLABORACIONES DE MANAGERS EN CONCIERTOS  ---------------------');
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('|         MANAGER          |  COLABORACIONES TOTALES  | COLABORACIONES RELATIVAS |');
    LOOP
        FETCH man_conc INTO fila_man_conc;
        EXIT WHEN man_conc%notfound;
        dbms_output.put_line(RPAD('-', 82, '-'));
        dbms_output.put_line('| '||RPAD(fila_man_conc.MANAGER, 24)||
            ' | '||LPAD(fila_man_conc.COLABORACIONES, 24)||
            ' | '||LPAD(ROUND((fila_man_conc.COLABORACIONES/tot_conc)*100, 2)||'%', 24)||' |');
    END LOOP;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line(' ');
    CLOSE man_conc;

    -- Datos sobre los managers (albumes)
    OPEN man_albs;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('------------------- COLABORACIONES DE MANAGERS EN ALBUMES  -----------------------');
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line('|         MANAGER          |  COLABORACIONES TOTALES  | COLABORACIONES RELATIVAS |');
    LOOP
        FETCH man_albs INTO fila_man_albs;
        EXIT WHEN man_albs%notfound;
        dbms_output.put_line(RPAD('-', 82, '-'));
        dbms_output.put_line('| '||RPAD(fila_man_albs.MANAGER, 24)||
            ' | '||LPAD(fila_man_albs.COLABORACIONES, 24)||
            ' | '||LPAD(ROUND((fila_man_albs.COLABORACIONES/tot_albums)*100, 2)||'%', 24)||' |');
    END LOOP;
    dbms_output.put_line(RPAD('-', 82, '-'));
    dbms_output.put_line(' ');
    CLOSE man_albs;


END;

END melopack;
/