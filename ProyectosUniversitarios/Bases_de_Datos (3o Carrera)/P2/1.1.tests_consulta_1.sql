
------------- TESTS PRIMERA CONSULTA ----------------

------------------ PRUEBA 1 ------------------
-- Aquí se ejecuta la consulta de 1.1.consulta_1.sql

-- Después ROLLBACK
rollback;

------------------ PRUEBA 2 ------------------
-- Buscamos un músico de Amapola
SELECT * FROM involvement where band='Amapola';
-- Vemos que 'DE>>0147495674' es de la banda

-- Borramos las interpretaciones en las que sea autor
DELETE FROM PERFORMANCES WHERE SONGWRITER='DE>>0147495674';

-- Aquí se ejecuta la consulta
-- Vemos que el porcentaje baja

-- Después ROLLBACK
rollback;

------------------ PRUEBA 3 ------------------
-- Buscamos un músico de Amapola
SELECT * FROM involvement where band='Amapola';
-- Vemos que 'DE>>0147495674' es de la banda

-- Borramos los tracks en las que sea autor
DELETE FROM TRACKS WHERE WRITER='DE>>0147495674';

-- Aquí se ejecuta la consulta
-- Vemos que el porcentaje baja

-- Después ROLLBACK
rollback;

------------------ PRUEBA 4 ------------------
-- Buscamos un músico de Amapola
SELECT * FROM involvement where band='Amapola';
-- Vemos que 'DE>>0147495674' es de la banda

-- Insertamos interpretaciones de ese músico
INSERT ALL
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 20, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 21, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 22, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 23, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 24, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 25, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 26, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 27, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 28, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 29, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 30, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 31, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 32, 'Bed love', 'DE>>0147495674', 10)
    INTO PERFORMANCES
        VALUES('Amapola','20/09/09', 33, 'Bed love', 'DE>>0147495674', 10)
SELECT 1 FROM DUAL;

-- Aquí se ejecuta la consulta
-- Vemos que el porcentaje sube

-- Después ROLLBACK
rollback;

------------------ PRUEBA 5 ------------------
-- Buscamos un músico de Amapola
SELECT * FROM involvement where band='Amapola';
-- Vemos que 'DE>>0147495674' es de la banda

-- Insertamos interpretaciones de ese músico
INSERT ALL
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 3, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 4, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 5, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 6, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 7, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 8, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 9, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
    INTO TRACKS
        VALUES('V5702IWJ6430QQH', 10, 'Bed love', 'DE>>0147495674', 10,
         '10/10/10', 'Jurado Studios', 'Amable Lopez Cavero')
SELECT 1 FROM DUAL;

-- Aquí se ejecuta la consulta
-- Vemos que el porcentaje sube

-- Después ROLLBACK
rollback;
