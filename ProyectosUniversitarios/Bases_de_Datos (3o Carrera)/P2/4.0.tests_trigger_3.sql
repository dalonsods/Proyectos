
------------------ PRUEBA 1 ------------------
-- Insertamos una nueva canción que no existe al revés
INSERT INTO songs
    VALUES('New Song', 'ES>>0105221781', 'ES>>0027957239');

-- Debe insertar correctamente
select * from songs where title='New Song';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 2 ------------------
-- Preparamos el entorno
-- Insertamos una nueva canción que no existe al revés
INSERT INTO songs
    VALUES('New Song', 'ES>>0105221781', 'ES>>0027957239');

-- Ahora insertamos la misma canción pero al revés
INSERT INTO songs
    VALUES('New Song', 'ES>>0027957239', 'ES>>0105221781');
-- Se rechaza la inserción

-- Después ROLLBACK
rollback;

------------------ PRUEBA 3 ------------------
-- Insertamos dos nuevas canciones que no existen al revés
INSERT ALL
    INTO songs VALUES('New Song 1', 'ES>>0105221781', 'ES>>0027957239')
    INTO songs VALUES('New Song 2', 'ES>>0105221781', 'ES>>0027957239')
SELECT 1 FROM DUAL;

-- Debe insertar correctamente
select * from songs
    where (title='New Song 1' OR title='New Song 2');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 4 ------------------
-- Preparamos el entorno
-- Insertamos dos nuevas canciones que no existen al revés
INSERT ALL
    INTO songs VALUES('New Song 1', 'ES>>0105221781', 'ES>>0027957239')
    INTO songs VALUES('New Song 2', 'ES>>0105221781', 'ES>>0027957239')
SELECT 1 FROM DUAL;

-- Ahora insertamos las mismas canciones pero al revés
INSERT ALL
    INTO songs VALUES('New Song 1', 'ES>>0027957239', 'ES>>0105221781')
    INTO songs VALUES('New Song 2', 'ES>>0027957239', 'ES>>0105221781')
SELECT 1 FROM DUAL;
-- Se rechaza la inserción

-- Después ROLLBACK
rollback;

------------------ PRUEBA 5 ------------------
-- Preparamos el entorno
-- Insertamos una nueva canción que no existe al revés
INSERT INTO songs
    VALUES('New Song 2', 'ES>>0105221781', 'ES>>0027957239');

-- Ahora insertamos una canción bien (la primera) y una mal,
-- la segunda es la que habíamos añadido antes pero al revés
INSERT ALL
    INTO songs VALUES('New Song 1', 'ES>>0027957239', 'ES>>0105221781')
    INTO songs VALUES('New Song 2', 'ES>>0027957239', 'ES>>0105221781')
SELECT 1 FROM DUAL;
-- Se rechaza la inserción

-- Después ROLLBACK
rollback;

------------------ PRUEBA 6 ------------------
-- Preparamos el entorno
-- Insertamos una nueva canción que no existe al revés
INSERT INTO songs
    VALUES('New Song 2', 'ES>>0105221781', 'ES>>0027957239');

-- Vamos a hacer una inserción múltiple con una canción inválida
-- La inválida es la 2
INSERT ALL
    INTO songs VALUES('New Song 1', 'ES>>0105221781', 'ES>>0027957239')
    INTO songs VALUES('New Song 2', 'ES>>0027957239', 'ES>>0105221781')
    INTO songs VALUES('New Song 3', 'ES>>0105221781', 'ES>>0027957239')
    INTO songs VALUES('New Song 4', 'ES>>0105221781', 'ES>>0027957239')
    INTO songs VALUES('New Song 5', 'ES>>0105221781', 'ES>>0027957239')
    INTO songs VALUES('New Song 6', 'ES>>0105221781', 'ES>>0027957239')
SELECT 1 FROM DUAL;
-- Se rechaza la inserción

-- Después ROLLBACK
rollback;

------------------ PRUEBA 7 ------------------
-- Insertamos en la misma sentencia una canción que no existe al revés
-- y después, esa misma canción pero con autores revertidos
INSERT ALL
    INTO songs VALUES ('NewSong', 'ES>>0105221781', 'ES>>0027957239')
    INTO songs VALUES ('NewSong', 'ES>>0027957239', 'ES>>0105221781')
SELECT 1 FROM DUAL;
-- Se rechaza la inserción

-- Podemos comprobar que no existe la canción
select * from songs where title='NewSong';

-- Después ROLLBACK
rollback;
