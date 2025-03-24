
------------------ PRIMERA VISTA ------------------
-- Vista 'my_albums' que muestra los álbumes del intérprete
-- actual, con su duración total
CREATE OR REPLACE VIEW my_albums AS
    -- Duración de cada álbum
    WITH info_duration AS (
        SELECT PAIR, SUM(DURATION) TOTAL_DURATION
        FROM TRACKS
        GROUP BY PAIR
    )
    -- Unimos al resto de la información
    SELECT PAIR, TITLE, REL_DATE, TOTAL_DURATION
        FROM info_duration
        NATURAL JOIN ALBUMS
        WHERE PERFORMER=melopack.int_actual
    WITH READ ONLY;

------------------ SEGUNDA VISTA ------------------
-- Vista 'events' que muestra la cantidad de conciertos
-- por mes, cantidad total de espectadores, media de canciones
-- y media de duración
-- Los conciertos que no tengan espectadores o canciones
-- no serán tenidos en cuenta en la vista
CREATE OR REPLACE VIEW events AS
    -- Número de espectadores de cada concierto
    WITH espec_conc AS (
        SELECT PERFORMER, WHEN, COUNT('x') NUM_ESPECT
            FROM ATTENDANCES
            WHERE PERFORMER=melopack.int_actual
            GROUP BY PERFORMER, WHEN
    ),
    -- Número de interpretaciones de cada concierto
    intp_conc AS (
        SELECT PERFORMER, WHEN, COUNT('x') NUM_INTERP
            FROM PERFORMANCES
            GROUP BY PERFORMER, WHEN
    ),
    -- Cambiamos el formato del mes para poder agrupar
    mes_conc AS (
        SELECT to_char(WHEN, 'YYYY MONTH') MES, DURATION,
        NUM_ESPECT, NUM_INTERP
            FROM (espec_conc
                  NATURAL JOIN concerts
                  NATURAL JOIN intp_conc)
            ORDER BY WHEN
    )
    -- Agrupamos por mes y calculamos las medias y sumas
    SELECT MES, COUNT('x') NUM_CONC,
        SUM(NUM_ESPECT) TOT_ESPECT, AVG(DURATION) DUR_MEDIA,
        AVG(NUM_INTERP) INTERP_MEDIAS
            FROM mes_conc
            GROUP BY MES
    -- En modo solo lectura
    WITH READ ONLY;
