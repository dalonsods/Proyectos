
------------------ PREPARACIÓN DEL ENTORNO DE PRUEBAS ------------------
-- Insertamos un nuevo cliente que sea menor de edad
INSERT INTO clients values ('danielalonso@gmail.com', 'Daniel', 'Alonso', 'dos Santos',
                            '06/04/10', 123456789, 'Calle 1, España', '2345678A');

-- Hacemos commit para poder usarlo en todas las pruebas
commit;

------------------ PRUEBA 1 ------------------
-- Insertamos compra sobre feliciana, mayor de edad, pero en la compra
-- ponemos un año que hace que sea menor de edad
INSERT INTO attendances values ('felicianalopez@clients.vinylinc.com', 'Abdi',
                                '12/10/85', 'RFID', '01/04/2005', sysdate);
-- Se rechaza la compra

-- Después ROLLBACK
rollback;

------------------ PRUEBA 2 ------------------
-- Insertamos compra sobre feliciana, mayor de edad, en la compra
-- ponemos también su año de nacimiento correcto (+18)
INSERT INTO attendances values ('felicianalopez@clients.vinylinc.com', 'Abdi',
                                '12/10/85', 'RFID', '20/05/95', sysdate);
-- Debe insertar correctamente
select * from attendances where client='felicianalopez@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 3 ------------------
-- Insertamos compra sobre daniel, menor de edad, y en la compra
-- ponemos un su nacimiento correcto, menor de edad
INSERT INTO attendances values ('danielalonso@gmail.com', 'Abdi',
                                '12/10/85', 'RFID', '06/06/2010', sysdate);
-- Se rechaza la compra

-- Después ROLLBACK
rollback;

------------------ PRUEBA 4 ------------------
-- Insertamos compra sobre daniel, menor de edad, y en la compra
-- ponemos un nacimiento falso, que le hace mayor de edad
INSERT INTO attendances values ('danielalonso@gmail.com', 'Abdi',
                                '12/10/85', 'RFID', '06/06/2002', sysdate);
-- Se rechaza la compra

-- Después ROLLBACK
rollback;

------------------ PRUEBA 5 ------------------
-- Insertamos dos compras correctas sobre feliciana, mayor de edad
-- en la compra ponemos también su año de nacimiento correcto (+18)
INSERT ALL
    INTO attendances values ('felicianalopez@clients.vinylinc.com',
                             'Abdi', '12/10/85', 'RFID1', '20/05/95', sysdate)
    INTO attendances values ('felicianalopez@clients.vinylinc.com',
                             'Abdi', '30/05/86', 'RFID2', '20/05/95', sysdate)
SELECT 1 FROM DUAL;

-- Debe insertar correctamente
select * from attendances where client='felicianalopez@clients.vinylinc.com';

-- Después ROLLBACK
rollback;

------------------ PRUEBA 6 ------------------
-- Insertamos dos compras incorrectas sobre daniel, menor de edad
-- en la compra ponemos también su año de nacimiento correcto (-18)
INSERT ALL
    INTO attendances values ('danielalonso@gmail.com', 'Abdi',
                             '12/10/85', 'RFID1', '06/04/2010', sysdate)
    INTO attendances values ('danielalonso@gmail.com', 'Abdi',
                             '30/05/86', 'RFID2', '06/04/2010', sysdate)
SELECT 1 FROM DUAL;
-- Se rechaza la compra

-- Después ROLLBACK
rollback;

------------------ PRUEBA 7 ------------------
-- Insertamos 1 compra correcta sobre sobre feliciana, mayor de edad
-- e insertamos 1 compra incorrecta sobre daniel, menor de edad
INSERT ALL
    INTO attendances values ('felicianalopez@clients.vinylinc.com',
                             'Abdi', '12/10/85', 'RFID1', '20/05/95', sysdate)
    INTO attendances values ('danielalonso@gmail.com', 'Abdi',
                             '30/05/86', 'RFID2', '06/04/2010', sysdate)
SELECT 1 FROM DUAL;
-- Se rechaza la compra

-- Después ROLLBACK
rollback;

------------------ PRUEBA 8 ------------------
-- Insertamos varias compras, algunas incorrectas
INSERT ALL
    INTO attendances values ('felicianalopez@clients.vinylinc.com',
                             'Abdi', '12/10/85', 'RFID1', '20/05/95', sysdate)
    INTO attendances values ('danielalonso@gmail.com', 'Abdi',
                             '30/05/86', 'RFID2', '06/04/2010', sysdate)
    INTO attendances values ('danielalonso@gmail.com', 'Abdi',
                             '30/05/86', 'RFID3', '06/04/2010', sysdate)
    INTO attendances values ('felicianalopez@clients.vinylinc.com',
                             'Abdi', '30/05/86', 'RFID4', '20/05/95', sysdate)
SELECT 1 FROM DUAL;
-- Se rechaza la compra

-- Después ROLLBACK
rollback;
