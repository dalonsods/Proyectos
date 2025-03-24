
------------------ PRUEBA 1 ------------------
-- Insertamos una canción de 2 minutos
INSERT INTO performances values ('Abdi', '12/10/85', 12, 'Dice', 'SE>>0307236139', 120);

-- Vemos que el tiempo del concierto pasa de 124 a 126 minutos
select * from concerts where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 2 ------------------
-- Insertamos una canción de 2 minutos en 2 conciertos distintos
INSERT ALL
    INTO performances VALUES ('Abdi', '12/10/85', 12, 'Dice', 'SE>>0307236139', 120)
    INTO performances VALUES ('Abdi', '30/05/86', 12, 'Dice', 'SE>>0307236139', 120)
SELECT 1 FROM DUAL;
-- Vemos que el tiempo del primer concierto pasa de 124 a 126 minutos
-- Vemos que el tiempo del segundo concierto pasa de 117 a 119 minutos
select * from concerts
    where (performer = 'Abdi' AND (when = '12/10/85' OR when = '30/05/86'));

-- Después ROLLBACK
rollback;

------------------ PRUEBA 3 ------------------
-- Insertamos dos canciones de 2 minutos en el mismo concierto
INSERT ALL
    INTO performances VALUES ('Abdi', '12/10/85', 12, 'Dice', 'SE>>0307236139', 120)
    INTO performances VALUES ('Abdi', '12/10/85', 13, 'Dice', 'SE>>0307236139', 120)
SELECT 1 FROM DUAL;
-- Vemos que el tiempo del primer concierto pasa de 124 a 128 minutos
select * from concerts
    where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 4 ------------------
-- Insertamos varias canciones, algunas en el mismo concierto
INSERT ALL
    INTO performances VALUES ('Abdi', '12/10/85', 12, 'Dice', 'SE>>0307236139', 120)
    INTO performances VALUES ('Abdi', '12/10/85', 13, 'Dice', 'SE>>0307236139', 120)
    INTO performances VALUES ('Abdi', '12/10/85', 14, 'Dice', 'SE>>0307236139', 120)
    INTO performances VALUES ('Abdi', '30/05/86', 12, 'Dice', 'SE>>0307236139', 120)
    INTO performances VALUES ('Abdi', '30/05/86', 13, 'Dice', 'SE>>0307236139', 120)
SELECT 1 FROM DUAL;
-- Vemos que el tiempo del primer concierto pasa de 124 a 130 minutos (+3 canciones)
-- Vemos que el tiempo del segundo concierto pasa de 117 a 121 minutos (+2 canciones)
select * from concerts
    where (performer = 'Abdi' AND (when = '12/10/85' OR when = '30/05/86'));

-- Después ROLLBACK
rollback;

------------------ PRUEBA 5 ------------------
-- Borramos una canción del primer concierto
DELETE FROM performances
    WHERE (performer='Abdi' AND when='12/10/85' AND sequ=11);
-- Vemos que el tiempo del primer concierto pasa de 124 a 120 minutos
select * from concerts
    where (performer = 'Abdi' AND when = '12/10/85');
-- Después ROLLBACK
rollback;

------------------ PRUEBA 6 ------------------
-- Borramos 2 canciones de conciertos distintos
DELETE FROM performances
    WHERE (performer='Abdi' AND (when = '12/10/85' OR when = '30/05/86') AND sequ=11);
-- Vemos que el tiempo del primer concierto pasa de 124 a 120 minutos (-238s)
-- Vemos que el tiempo del segundo concierto pasa de 117 a 112 minutos (-298s)
select * from concerts
    where (performer = 'Abdi' AND (when = '12/10/85' OR when = '30/05/86'));

-- Después ROLLBACK
rollback;

------------------ PRUEBA 7 ------------------
-- Borramos 2 canciones del mismo concierto
DELETE FROM performances
    WHERE (performer='Abdi' AND when = '12/10/85' AND sequ>9);
-- Vemos que el tiempo del primer concierto pasa de 124 a 114 (-238s y -343s)
select * from concerts
    where (performer = 'Abdi' AND (when = '12/10/85' OR when = '30/05/86'));

-- Después ROLLBACK
rollback;

------------------ PRUEBA 8 ------------------
-- Borramos 3 canciones de cada concierto
DELETE FROM performances
    WHERE (performer='Abdi' AND (when = '12/10/85' OR when = '30/05/86') AND sequ>8);
-- Vemos que el tiempo del primer concierto pasa de 124 a 110 (-238s, -343s y -224s)
-- Vemos que el tiempo del segundo concierto pasa de 117 a 103 (-298s, -238s, -316s)
select * from concerts
    where (performer = 'Abdi' AND (when = '12/10/85' OR when = '30/05/86'));

-- Después ROLLBACK
rollback;

------------------ PRUEBA 9 ------------------
-- Modificamos la duración de una canción de 238 a 298 (+1min)
UPDATE performances SET duration=298
    WHERE (performer='Abdi' AND when='12/10/85' AND sequ=11);
-- Vemos que el tiempo del concierto pasa de 124 a 125 minutos
select * from concerts where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 10 ------------------
-- Modificamos la duración de una canción de 238 a 178 (-1min)
UPDATE performances SET duration=178
    WHERE (performer='Abdi' AND when='12/10/85' AND sequ=11);
-- Vemos que el tiempo del concierto pasa de 124 a 123 minutos
select * from concerts where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 11 ------------------
-- No modificamos la duración
UPDATE performances SET sequ=12
    WHERE (performer='Abdi' AND when='12/10/85' AND sequ=11);
-- Vemos que el tiempo no varía
select * from concerts where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 12 ------------------
-- Modificamos la duración de 238 a 178 (-1min) en el primer concierto
-- En el segundo concierto de 298 a 178 (-2min)
UPDATE performances SET duration=178
    WHERE (performer='Abdi' AND (when = '12/10/85' OR when = '30/05/86') AND sequ=11);
-- Vemos que el tiempo del primer concierto pasa de 124 a 123 minutos
-- Vemos que el tiempo del segundo concierto pasa de 117 a 115 minutos
select * from concerts
    where (performer = 'Abdi' AND (when = '12/10/85' OR when = '30/05/86'));

-- Después ROLLBACK
rollback;

------------------ PRUEBA 13 ------------------
-- Modificamos la duración de una canción de 238 a 400
-- Y de la otra canción de a 343 a 400
-- En total tiene que aumentar 4 minutos la duración
UPDATE performances SET duration=400
    WHERE (performer='Abdi' AND when='12/10/85' AND sequ>9);
-- Vemos que el tiempo del concierto pasa de 124 a 128 minutos
select * from concerts where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 14 ------------------
-- Modificamos la duración de una canción de 238 a 178 (-1min)
-- Y de la otra canción de a 343 a 178
-- En total tiene que bajar 4 minutos la duración
UPDATE performances SET duration=178
    WHERE (performer='Abdi' AND when='12/10/85' AND sequ>9);
-- Vemos que el tiempo del concierto pasa de 124 a 120 minutos
select * from concerts where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 15 ------------------
-- Modificamos la duración de una canción de 238 a 260 (+22)
-- Y de la otra canción de a 343 a 260 (-83)
-- En total tiene que bajar 1 minuto
UPDATE performances SET duration=260
    WHERE (performer='Abdi' AND when='12/10/85' AND sequ>9);
-- Vemos que el tiempo del concierto pasa de 124 a 123 minutos
select * from concerts where (performer = 'Abdi' AND when = '12/10/85');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 16 ------------------
-- Variaciones concierto 1 (+26 -93 +12)
-- Variaciones concierto 2 (-66 +12 -48)
-- Ambos deben bajar 2 minutos
UPDATE performances SET duration=250
    WHERE (performer='Abdi' AND (when = '12/10/85' OR when = '30/05/86') AND sequ>8);
-- Vemos que el tiempo del concierto 1 pasa de 124 a 122 minutos
-- Vemos que el tiempo del concierto 2 pasa de 117 a 115 minutos
select * from concerts
    where (performer = 'Abdi' AND (when = '12/10/85' OR when = '30/05/86'));

-- Después ROLLBACK
rollback;
