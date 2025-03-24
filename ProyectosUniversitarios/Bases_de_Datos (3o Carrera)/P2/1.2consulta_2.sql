
-----------------------SEGUNDA CONSULTA -----------------------
----------PORCENTAJE--------------------------
-------Creación de la tabla PAIR, sequ, performer, title, writer, cowriter, rec_date para comparar-----------
WITH
tabla_porc1 AS (
    SELECT albums.pair, sequ, albums.performer, tracks.title, tracks.writer, rec_date
        FROM tracks
        JOIN albums ON tracks.PAIR = albums.PAIR
        JOIN songs ON (tracks.writer = songs.writer AND songs.title = tracks.title )
),

-----------------------------------listado de interpretaciones--------------------------------------------
tabla_perf AS (
    SELECT performer, sequ, songtitle, songwriter, performances.when
        FROM performances
),

-----------------------------------tabla con interpretaciones grabadas--------------------------------
tabla_porc2 AS (
    SELECT tabla_perf.performer, songtitle, songwriter, tabla_perf.when
    FROM tabla_perf
    WHERE EXISTS (
        SELECT * FROM tabla_porc1
            WHERE (performer = performer AND songtitle = title AND songwriter = writer AND when > rec_date)
                )
),

--int grabadas contadas
int_grab AS (
    SELECT performer, COUNT(*) AS num_int_grab
        FROM tabla_porc2
        GROUP BY performer
),

-- int totales contadas
int_tot AS(
    SELECT performer, COUNT(*) AS num_int_tot
        FROM tabla_perf
        GROUP BY performer),

porcentaje AS (
    SELECT int_tot.performer, (num_int_grab / num_int_tot) * 100 AS porcentaje
        FROM int_tot
        LEFT JOIN int_grab
        ON int_tot.performer = int_grab.performer
),

------------EDAD MEDIA----------------------
----tabla con perf, songtitle, songwriter, when, rec_date para filtrar
tabla_conjunta AS (
    SELECT tracks.PAIR, tracks.sequ, albums.performer, tracks.title,
    tracks.writer, songs.cowriter, tracks.rec_date
        FROM tracks
        JOIN albums ON (tracks.PAIR = albums.PAIR)
        JOIN songs ON (tracks.title = songs.title AND tracks.writer = songs.writer)),

tabla_filtrar AS (
    SELECT performances.performer, performances.songtitle, performances.songwriter,
    performances.when, rec_date
        FROM tabla_conjunta
        JOIN performances
        ON (tabla_conjunta.performer = performances.performer AND songtitle = title AND songwriter = writer)
),

tabla_previa_diferencia AS (
    SELECT performer, songtitle, songwriter, MIN(when) as when, MIN(rec_date) AS rec_date
        FROM tabla_filtrar
        GROUP BY performer, songtitle, songwriter, when
),

tabla_previa_conteo AS (
    SELECT performer, songtitle, songwriter, MIN(when - rec_date) AS diferencia
        FROM tabla_previa_diferencia
        GROUP BY performer, songtitle, songwriter
),

tabla_conteo AS (
    SELECT performer, AVG(diferencia) AS media_diferencia
        FROM tabla_previa_conteo
        GROUP BY performer
),

diferencia AS (
    SELECT DISTINCT performer, TRUNC(media_diferencia / 365) AS años,
    TRUNC(MOD(media_diferencia, 365) / 30) AS meses,
    TRUNC(MOD(MOD(media_diferencia, 365), 30)) AS dias
        FROM tabla_conteo
),

-----consulta antes de la final
consulta_prefinal AS (
    SELECT porcentaje.performer, porcentaje.porcentaje, diferencia.años, diferencia.meses, diferencia.dias
        FROM porcentaje
        JOIN diferencia ON porcentaje.performer = diferencia.performer
        ORDER BY porcentaje.porcentaje DESC, porcentaje.performer
)

-----consulta final
SELECT * FROM consulta_prefinal
    WHERE rownum <= 10;
