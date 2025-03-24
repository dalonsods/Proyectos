
------------------ PRIMERA CONSULTA ------------------
WITH
------------------ Primer porcentaje -----------------
-- Todos los tracks con writer y pair
all_tracks_cowr AS (
    SELECT albums.pair, sequ, tracks.title, albums.performer, tracks.writer,
    songs.cowriter, rec_date
        FROM tracks
        JOIN albums
            ON tracks.PAIR = albums.PAIR
        JOIN songs
            ON (tracks.writer = songs.writer AND songs.title = tracks.title)
),
-- De los tracks totales, nos quedamos con los propios
tracks_propios AS (
    SELECT PAIR, SEQU, TITLE, PERFORMER, REC_DATE
        FROM all_tracks_cowr
        WHERE ((PERFORMER, WRITER) IN (SELECT BAND, MUSICIAN FROM INVOLVEMENT) OR
               (PERFORMER, COWRITER) IN (SELECT BAND, MUSICIAN FROM INVOLVEMENT))
),
-- Contamos las canciones propias
num_canc_prop AS (
    SELECT PERFORMER, COUNT('x') NUM_C_PROP
        FROM tracks_propios
        GROUP BY PERFORMER
),
-- Contamos las canciones totales
num_canc_tot AS (
    SELECT PERFORMER, COUNT('x') NUM_C_TOT
        FROM all_tracks_cowr
        GROUP BY PERFORMER
),
porc_can_prop AS (
    SELECT num_canc_tot.PERFORMER,
    ROUND((NVL(NUM_C_PROP, 0)/NUM_C_TOT * 100), 2)||'%' AS CAN_PROP_PORC
        FROM num_canc_tot
        LEFT JOIN num_canc_prop
        ON num_canc_tot.performer = num_canc_prop.performer
),
----------------- Segundo porcentaje -----------------
-- Todas las interpretaciones, con cowriter
all_perf_cowr AS (
    SELECT DISTINCT PERFORMER, SONGTITLE, SONGWRITER, COWRITER, WHEN, SEQU
        FROM PERFORMANCES
        JOIN SONGS ON (TITLE = SONGTITLE AND WRITER = SONGWRITER)
),
-- Del total de interpetaciones, nos quedamos solo con las propias
perf_propias AS (
    SELECT PERFORMER, SONGTITLE, SONGWRITER, COWRITER, WHEN, SEQU
        FROM all_perf_cowr
        WHERE ((PERFORMER, SONGWRITER) IN (SELECT BAND, MUSICIAN FROM INVOLVEMENT) OR
               (PERFORMER, COWRITER) IN (SELECT BAND, MUSICIAN FROM INVOLVEMENT))
),
-- Contamos el número de interpretaciones propias por performer
num_propias AS (
    SELECT PERFORMER, COUNT('x') AS NUM_PERF_PROP
        FROM perf_propias
        GROUP BY PERFORMER
),
-- Contamos el número de interpretaciones totales por performer
int_totales AS (
    SELECT PERFORMER, COUNT('x') AS NUM_PERF_TOT
        FROM all_perf_cowr
        GROUP BY PERFORMER
),
porc_int_prop AS (
    SELECT int_totales.PERFORMER,
    ROUND((NVL(NUM_PERF_PROP, 0)/NUM_PERF_TOT * 100), 2)||'%' AS INT_PROP_PORC
        FROM int_totales
        LEFT JOIN num_propias
        ON int_totales.performer = num_propias.performer
)
-------------------- Consulta final --------------------
SELECT COALESCE(porc_can_prop.performer, porc_int_prop.performer) PERFORMER,
    porc_can_prop.CAN_PROP_PORC,
    porc_int_prop.INT_PROP_PORC
        FROM porc_can_prop
        FULL OUTER JOIN porc_int_prop
        ON porc_can_prop.performer = porc_int_prop.performer;
