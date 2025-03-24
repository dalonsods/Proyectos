
------------------------------------------------------
---------------- TESTS asig_interp -------------------

------------------ PRUEBA 1 ------------------
-- Vemos que pasa si no hemos asignado nada
select melopack.int_actual from dual;

------------------ PRUEBA 2 ------------------
-- Ahora le asignamos un nombre
begin melopack.asig_interp('Estopa');
end;
/
-- Vemos que el valor se almacena correctamente
select melopack.int_actual from dual;

------------------ PRUEBA 3 ------------------
-- Ahora le asignamos un nombre de varias palabras
begin melopack.asig_interp('Los Chunguitos');
end;
/
-- Vemos que el valor se almacena correctamente
select melopack.int_actual from dual;

------------------ PRUEBA 4 ------------------
-- Ahora le asignamos el valor null
begin melopack.asig_interp(null);
end;
/
-- Vemos que el valor se almacena correctamente
select melopack.int_actual from dual;


------------------------------------------------------
---------------- TESTS int_actual --------------------

------------------ PRUEBA 1 ------------------
-- Vemos que muestra null si no hemos asignado nada
select melopack.int_actual from dual;

------------------ PRUEBA 2 ------------------
-- Ahora le asignamos un nombre
begin melopack.asig_interp('Estopa');
end;
/
-- Vemos que muestra el valor asignado
select melopack.int_actual from dual;

------------------ PRUEBA 3 ------------------
-- Ahora le asignamos un nombre de varias palabras
begin melopack.asig_interp('Los Chunguitos');
end;
/
-- Vemos que muestra el valor asignado
select melopack.int_actual from dual;

------------------ PRUEBA 4 ------------------
-- Ahora le asignamos el valor null
begin melopack.asig_interp(null);
end;
/
-- Vemos que muestra el valor asignado
select melopack.int_actual from dual;


------------------------------------------------------
------------ TESTS insert_alb_track ------------------

------------------ PRUEBA 1 ------------------
-- Llamamos al procedimiento con PAIR null
begin melopack.insert_alb_track(null, 'S', 'Titulo', '10/02/20',
    'Publisher', 123456789, 1, 'Song', 'SE>>0307236139', 20,
    '09/02/20', 'Studio', 'Ingeniero');
end;
/
-- Vemos que da error

------------------ PRUEBA 2 ------------------
-- Llamamos al procedimiento con sequ null
begin melopack.insert_alb_track('PAIR', 'S', 'Titulo', '10/02/20',
    'Publisher', 123456789, null, 'Song', 'SE>>0307236139', 20,
    '09/02/20', 'Studio', 'Ingeniero');
end;
/
-- Vemos que da error

------------------ PRUEBA 3 ------------------
-- Primero le damos un valor a performer actual
begin melopack.asig_interp('Bastidas');
end;
/
-- Llamamos al procedimiento con un pair existente, con el resto
-- de atributos de album a null
begin melopack.insert_alb_track('A0157KH85933GKQ', null, null, null,
    null, null, 3, 'Stranger', 'SE>>0359175040', 248,
    '26/09/81', 'Agustico Inc.', 'Agustin Enrique Guzman');
end;
/
-- Comprobamos que ha añadido el track
select * from tracks where pair ='A0157KH85933GKQ';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 4 ------------------
-- Primero le damos un valor a performer actual
begin melopack.asig_interp('Bastidas');
end;
/
-- Llamamos al procedimiento con un pair existente, con el resto
-- de atributos de album not null
begin melopack.insert_alb_track('A0157KH85933GKQ', 'S', 'Stranger', '24/11/82',
    'Armaggedom Rec.', 555999235, 3, 'Stranger', 'SE>>0359175040', 248,
    '26/09/81', 'Agustico Inc.', 'Agustin Enrique Guzman');
end;
/
-- Comprobamos que ha añadido el track
select * from tracks where pair ='A0157KH85933GKQ';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 5 ------------------
-- Primero le damos un valor a performer actual
begin melopack.asig_interp('Bastidas');
end;
/
-- Llamamos al procedimiento con un album que no existe
begin melopack.insert_alb_track('123456789012345', 'S', 'NEW ALBUM', '24/11/82',
    'Armaggedom Rec.', 555999235, 1, 'Stranger', 'SE>>0359175040', 248,
    '26/09/81', 'Agustico Inc.', 'Agustin Enrique Guzman');
end;
/
--Comprobamos que crea el album
select * from albums where pair ='123456789012345';
-- Comprobamos que ha añadido el track
select * from tracks where pair ='123456789012345';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 6 ------------------
-- Probamos a añadir una canción que no existe en 'songs'
begin melopack.insert_alb_track('A0157KH85933GKQ', null, null, null,
    null, null, 3, 'No existe', 'SE>>0359175040', 248,
    '26/09/81', 'Agustico Inc.', 'Agustin Enrique Guzman');
end;
/
-- Vemos que da error


------------------------------------------------------
------------ TESTS delete_alb_track ------------------

------------------ PRUEBA 1 ------------------
-- Llamamos al procedimiento con PAIR null
begin melopack.delete_alb_track(null, 9);
end;
/
-- Vemos que da error

------------------ PRUEBA 2 ------------------
-- Llamamos al procedimiento con sequ null
begin melopack.delete_alb_track('PAIR', null);
end;
/
-- Vemos que da error

------------------ PRUEBA 3 ------------------
-- Estado inicial de los tracks del album
select * from tracks where pair ='A0157KH85933GKQ';

-- Llamamos al procedimiento sobre un album de > 1 tema
begin melopack.delete_alb_track('A0157KH85933GKQ', 2);
end;
/
-- Vemos que borra correctamente
select * from tracks where pair ='A0157KH85933GKQ';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 4 ------------------
-- Estado inicial de los tracks del album
select * from tracks where pair ='A0157KH85933GKQ';
-- Preparamos el album para que solo tenga 1 tema
begin melopack.delete_alb_track('A0157KH85933GKQ', 2);
end;
/

-- Llamamos al procedimiento sobre album de 1 tema
begin melopack.delete_alb_track('A0157KH85933GKQ', 1);
end;
/
-- Vemos que borra correctamente
select * from tracks where pair ='A0157KH85933GKQ';
-- Vemos que el album ha sido borrado
select * from albums where pair ='A0157KH85933GKQ';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 5 ------------------
-- Llamamos al procedimiento con PAIR que no existe
begin melopack.delete_alb_track('NOEXISTSPAIR', 1);
end;
/
-- Vemos que no da error, pero tampoco hace nada

------------------ PRUEBA 6 ------------------
-- Llamamos al procedimiento con sequ que no existe
begin melopack.delete_alb_track('A0157KH85933GKQ', 15);
end;
/
-- Vemos que no da error, pero tampoco hace nada
-- No han cambiado los tracks
select * from albums where pair ='A0157KH85933GKQ';

------------------------------------------------------
----------------- TESTS informe ----------------------

------------------ PRUEBA 1 ------------------
-- Le asignamos null a int_actual
begin melopack.asig_interp(null);
end;
/

-- Llamamos al procedimiento del informe
begin melopack.informe;
end;
/

-- Vemos que da error

------------------ PRUEBA 2 ------------------
-- Le asignamos un intérprete no existente en la base
begin melopack.asig_interp('Estopa');
end;
/

-- Llamamos al procedimiento del informe
begin melopack.informe;
end;
/

-- Vemos que da error

------------------ PRUEBA 3 ------------------
-- Le asignamos un intérprete existente en la base
begin melopack.asig_interp('Amapola');
end;
/

-- Llamamos al procedimiento del informe
begin melopack.informe;
end;
/

-- Vemos que funciona correctamente

------------------ PRUEBA 4 ------------------
-- Le asignamos otro intérprete existente en la base
begin melopack.asig_interp('A.M.S.');
end;
/

-- Llamamos al procedimiento del informe
begin melopack.informe;
end;
/

-- Vemos que funciona correctamente