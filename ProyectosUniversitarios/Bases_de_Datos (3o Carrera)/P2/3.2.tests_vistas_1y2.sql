
------------------------------------------------------
--------------- TESTS PRIMERA VISTA ------------------

------------------- PRUEBA 1 ------------------
-- Ponemos int_actual a null
begin melopack.asig_interp(null);
end;
/
-- Vemos el resultado de la vista
select * from my_albums;

------------------ PRUEBA 2 ------------------
-- Ponemos int_actual con un intérprete no existente
begin melopack.asig_interp('NoExiste');
end;
/
-- Vemos el resultado de la vista
select * from my_albums;

------------------ PRUEBA 3 ------------------
-- Ponemos int_actual con intérprete válido
begin melopack.asig_interp('A.M.S.');
end;
/
-- Vemos el resultado de la vista
select * from my_albums;

------------------ PRUEBA 4 ------------------
-- Ponemos int_actual con otro intérprete válido
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos el resultado de la vista
select * from my_albums;

------------------- PRUEBA 5 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Creamos un nuevo álbum
INSERT INTO ALBUMS
    VALUES('123456789012345', 'Amapola', 'T', 'NewAlbum',
        '03/04/23', 'Aloisio', 555198446);

-- Vemos que el álbum no aparece en la vista
select * from my_albums where pair='123456789012345';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 6 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Creamos un nuevo álbum y una pista para ese álbum
INSERT INTO ALBUMS
    VALUES('123456789012345', 'Amapola', 'T', 'NewAlbum',
        '03/04/23', 'Aloisio', 555198446);
INSERT INTO TRACKS
    VALUES('123456789012345', 1, 'Moments', 'DE>>0030666064', 178,
    '23/08/05', 'Jurado Studios', 'Anastasia Acosta');

-- Vemos que el álbum aparece en la vista
select * from my_albums;
-- O también
select * from my_albums where pair='123456789012345';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 7 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Borramos uno de los álbumes de Amapola
DELETE FROM ALBUMS WHERE PAIR='O17930L74069FYA';

-- Comprobamos que ya no aparece en la vista
select * from my_albums where pair='O17930L74069FYA';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 8 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Borramos todos los álbumes de Amapola
DELETE FROM ALBUMS WHERE PERFORMER=melopack.int_actual;

-- Comprobamos que ya no aparece nada en la vista
select * from my_albums;

-- Después ROLLBACK
rollback;

------------------- PRUEBA 9 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos actualizar sobre la vista
UPDATE my_albums SET title='NuevoTitulo';
-- Debe mostrar un error

-- Comprobamos que la vista no cambia
select * from my_albums;

------------------ PRUEBA 10 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos borrar sobre la vista
DELETE FROM my_albums;
-- Debe mostrar un error

-- Comprobamos que la vista no cambia
select * from my_albums;

------------------ PRUEBA 11 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos insertar sobre la vista
INSERT INTO my_albums
    VALUES('PAIR', 'NOMBRE', '10/10/10', 1234);

-- Debe dar error


------------------------------------------------------
--------------- TESTS SEGUNDA VISTA ------------------

------------------- PRUEBA 1 ------------------
-- Ponemos int_actual a null
begin melopack.asig_interp(null);
end;
/
-- Vemos el resultado de la vista
select * from events;

------------------ PRUEBA 2 ------------------
-- Ponemos int_actual con un intérprete no existente
begin melopack.asig_interp('NoExiste');
end;
/
-- Vemos el resultado de la vista
select * from events;

------------------ PRUEBA 3 ------------------
-- Ponemos int_actual con intérprete válido
begin melopack.asig_interp('A.M.S.');
end;
/
-- Vemos el resultado de la vista
select * from events;

------------------ PRUEBA 4 ------------------
-- Ponemos int_actual con otro intérprete válido
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos el resultado de la vista
select * from events;

------------------- PRUEBA 5 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Creamos un nuevo concierto
INSERT INTO CONCERTS
    VALUES('Amapola', '10/10/23', null, 'municipio',
        'direccion', 'pais', 0, 0, 555001118);

-- Vemos que la vista no cambia
select * from events;

-- Después ROLLBACK
rollback;

------------------ PRUEBA 6 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Creamos un concierto, una interpretación y un asistente
INSERT INTO CONCERTS
    VALUES('Amapola', '10/10/23', null, 'municipio',
        'direccion', 'pais', 0, 0, 555001118);
INSERT INTO PERFORMANCES
    VALUES('Amapola', '10/10/23', 1, 'Animal willow',
        'GB>>0611132173', 295);
INSERT INTO ATTENDANCES
    VALUES('clemi@clients.vinylinc.com', 'Amapola', '10/10/23',
        'NewRFID', '10/10/90', null);

-- Vemos que el concierto aparece en la vista
select * from events;
-- O también
select * from events where mes='2023 OCTUBRE   ';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 7 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Borramos algunas interpretaciones de Amapola
DELETE FROM PERFORMANCES WHERE WHEN<'01/01/20';

-- Comprobamos que ya no aparecen en la vista
select * from events;

-- Después ROLLBACK
rollback;

------------------ PRUEBA 8 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Borramos todos los conciertos de Amapola
DELETE FROM PERFORMANCES WHERE PERFORMER=melopack.int_actual;

-- Comprobamos que ya no aparece nada en la vista
select * from events;

-- Después ROLLBACK
rollback;

------------------- PRUEBA 9 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos actualizar sobre la vista
UPDATE events SET mes='2023 MARZO';
-- Debe mostrar un error

-- Comprobamos que la vista no cambia
select * from events;

------------------ PRUEBA 10 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos borrar sobre la vista
DELETE FROM events;
-- Debe mostrar un error

-- Comprobamos que la vista no cambia
select * from events;

------------------ PRUEBA 11 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos insertar sobre la vista
INSERT INTO events
    VALUES('2023 ABRIL', 1, 40, 145, 12);

-- Debe dar error
