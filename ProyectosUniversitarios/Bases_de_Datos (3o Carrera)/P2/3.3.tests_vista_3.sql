
------------------ PRUEBA 1 ------------------
-- Ponemos int_actual a null
begin melopack.asig_interp(null);
end;
/
-- Vemos el resultado de la vista
select * from fans;

------------------ PRUEBA 2 ------------------
-- Ponemos int_actual con un intérprete no existente
begin melopack.asig_interp('NoExiste');
end;
/
-- Vemos el resultado de la vista
select * from fans;

------------------ PRUEBA 3 ------------------
-- Ponemos int_actual con intérprete válido
begin melopack.asig_interp('A.M.S.');
end;
/
-- Vemos el resultado de la vista
select * from fans;

------------------ PRUEBA 4 ------------------
-- Ponemos int_actual con otro intérprete válido
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos el resultado de la vista
select * from fans;

------------------ PRUEBA 5 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos que 'olao@clients.vinylinc.com' es fan de Amapola
select * from fans where e_mail='olao@clients.vinylinc.com';

-- Eliminamos todas las entradas de 'olao@clients.vinylinc.com'
DELETE FROM ATTENDANCES
    WHERE(PERFORMER='Amapola' AND client='olao@clients.vinylinc.com');

-- Vemos que deja de aparecer en la vista
select * from fans where e_mail='olao@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 6 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos que el cliente 'felia@clients.vinylinc.com' no es fan de Amapola
select * from fans where e_mail='felia@clients.vinylinc.com';

-- Le añadimos dos entradas
INSERT ALL
    INTO ATTENDANCES(client, performer, when, rfid, birthdate)
        VALUES('felia@clients.vinylinc.com', 'Amapola', '08/06/85',
            'RFID1', '20/02/99')
    INTO ATTENDANCES(client, performer, when, rfid, birthdate)
        VALUES('felia@clients.vinylinc.com', 'Amapola', '28/06/85',
            'RFID2', '20/02/99')
SELECT 1 FROM DUAL;

-- Vemos que ahora aparece en fans
select * from fans where e_mail='felia@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 7 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos que 'olao@clients.vinylinc.com' es fan de Amapola
select * from fans where e_mail='olao@clients.vinylinc.com';

-- Añadimos a 'olao@clients.vinylinc.com' a la tabla de vetados,
INSERT INTO VETADOS
    VALUES('olao@clients.vinylinc.com', melopack.int_actual);

-- Vemos que deja de aparecer en la vista
select * from fans where e_mail='olao@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 8 ------------------
-- Estado inicial de la vista
select * from fans;

-- Intentamos actualizar
UPDATE fans SET nombre='NuevoNombre'
    WHERE e_mail='olao@clients.vinylinc.com';

-- Debe rechazar la actualización

-- Vemos que el nombre del fan no ha cambiado
select * from fans where e_mail='olao@clients.vinylinc.com';

------------------ PRUEBA 9 ------------------
-- Estado inicial de la vista
select * from fans;

-- Intentamos actualizar
UPDATE fans SET nombre='NuevoNombre';

-- Debe rechazar la actualización

-- Vemos que los nombres no han cambiado
select * from fans;

------------------ PRUEBA 10 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos que 'olao@clients.vinylinc.com' es fan de Amapola
select * from fans where e_mail='olao@clients.vinylinc.com';

-- Lo eliminamos de la vista
DELETE FROM fans WHERE e_mail='olao@clients.vinylinc.com';

-- Vemos que ya no aparece como fan
select * from fans where e_mail='olao@clients.vinylinc.com';

-- Pero sigue existiendo como cliente de 'Amapola'
select * from attendances
    WHERE (PERFORMER='Amapola' AND client='olao@clients.vinylinc.com');

-- Después ROLLBACK
rollback;

------------------ PRUEBA 11 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos los fans de 'Amapola'
select * from fans;

-- Eliminamos los dos primeros
DELETE FROM fans WHERE(
    e_mail='olao@clients.vinylinc.com' OR
    e_mail='sanchoalegria@clients.vinylinc.com');

-- Vemos que ya no aparecen
select * from fans;

-- Ahora están en la tabla de vetados
select * from vetados;

-- Después ROLLBACK
rollback;

------------------ PRUEBA 12 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos los fans de Amapola
select * from fans;

-- Los eliminamos de la vista
DELETE FROM fans;

-- Vemos que ya no aparece nadie como fan
select * from fans;

-- Pero sigue existiendo como cliente de 'Amapola'
select * from attendances WHERE PERFORMER='Amapola';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 13 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos que 'olao@clients.vinylinc.com' es fan de Amapola
select * from fans where e_mail='olao@clients.vinylinc.com';

-- Lo intentamos añadir a fans
INSERT INTO FANS
    VALUES('olao@clients.vinylinc.com', 'Olao', 'Marquina', 'Sanchez', 29);

-- Muestra un error

-- Después ROLLBACK
rollback;

------------------ PRUEBA 14 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vemos que 'olao@clients.vinylinc.com' es fan de Amapola
select * from fans where e_mail='olao@clients.vinylinc.com';
--Lo añadimos manualmente en vetados
INSERT INTO VETADOS
    VALUES('olao@clients.vinylinc.com', melopack.int_actual);

-- Lo intentamos añadir a fans
INSERT INTO FANS
    VALUES('olao@clients.vinylinc.com', 'Olao', 'Marquina', 'Sanchez', 29);
-- Vemos que vuelve a aparecer como fan
select * from fans where e_mail='olao@clients.vinylinc.com';
-- Y no aparece en vetados
select * from vetados where client='olao@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 15 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos insertar un cliente no existente
INSERT INTO FANS
    VALUES('danialonso@gmail', 'Dani', 'Alonso', 'dos Santos', 21);

-- Vemos que aparece como fan
select * from fans where e_mail='danialonso@gmail';
-- Vemos que se han creado 2 entradas en attendance
select * from attendances where client='danialonso@gmail';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 16 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Intentamos insertar un cliente que existe y que tiene
-- 0 entradas de Amapola
INSERT INTO FANS
    VALUES('felia@clients.vinylinc.com', 'Maria de la Felicidad',
    'Paez', 'Garcia', 37);

-- Vemos que aparece como fan
select * from fans where e_mail='felia@clients.vinylinc.com';
-- Vemos que se han creado 2 entradas en attendance
select * from attendances where client='felia@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 17 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vamos a insertar a 'andree@clients.vinylinc.com' que, como
-- vemos, existe y ya tiene una entrada para Amapola
select * from attendances where client='andree@clients.vinylinc.com';

-- Intentamos insertarlo como fan
INSERT INTO FANS
    VALUES('andree@clients.vinylinc.com', 'Maria de la Felicidad',
    'Paez', 'Garcia', 37);

-- Vemos que aparece como fan
select * from fans where e_mail='andree@clients.vinylinc.com';
-- Vemos que se ha generado una segunda entrada en attendance
select * from attendances where client='andree@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 18 ------------------
-- Ponemos de int_actual a Amapola para la prueba
begin melopack.asig_interp('Amapola');
end;
/
-- Vamos a volver a usar a 'felia@clients.vinylinc.com',
-- que tenía 0 entradas.
-- Para preparar el entorno, le añadiremos una attendance
-- para el concierto más reciente de Amapola.
INSERT INTO ATTENDANCES(client, performer, when, rfid, birthdate)
    VALUES('felia@clients.vinylinc.com', 'Amapola', '25/09/20',
            'RFID1', '20/02/99');

-- Ahora intentamos insertarla en fans
INSERT INTO FANS
    VALUES('felia@clients.vinylinc.com', 'Maria de la Felicidad',
    'Paez', 'Garcia', 37);

-- Vemos que aparece como fan
select * from fans where e_mail='felia@clients.vinylinc.com';
-- Vemos que se han generado una nueva entrada en attendance
-- Como ya tenía para el concierto más reciente, ha usado el segundo
select * from attendances where client='felia@clients.vinylinc.com';

-- Después ROLLBACK
rollback;
