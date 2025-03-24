DROP TABLE ficha;
DROP TABLE cliente;
DROP TABLE pista_album;
DROP TABLE pista;
DROP TABLE estudio;
DROP TABLE album;
DROP TABLE discografica;
DROP TABLE tema_concierto;
DROP TABLE tema;
DROP TABLE evento;
DROP TABLE gira;
DROP TABLE manager;
DROP TABLE mus_pertenece;
DROP TABLE musico;
DROP TABLE interprete;


CREATE TABLE interprete (
    nom_artist VARCHAR2(50) NOT NULL,
    nacionalidad VARCHAR2(20) NOT NULL,
    idioma VARCHAR2(20) NOT NULL,
    CONSTRAINT pk_interprete PRIMARY KEY (nom_artist)
);

CREATE TABLE musico (
    pasaporte VARCHAR2(14) NOT NULL,
    nombre_comp VARCHAR2(50) NOT NULL,
    nacionalidad VARCHAR2(20) NOT NULL,
    fecha_nac DATE NOT NULL,
    CONSTRAINT pk_musico PRIMARY KEY (pasaporte)
);

CREATE TABLE mus_pertenece (
    musico VARCHAR2(14) NOT NULL,
    interprete VARCHAR2(50) NOT NULL,
    fecha_inic DATE NOT NULL,
    fecha_fin DATE,
    rol VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_mus_pertenece
        PRIMARY KEY (musico, interprete),
    CONSTRAINT fk_mus_pertenece_musico
        FOREIGN KEY (musico)
        REFERENCES musico(pasaporte),
    CONSTRAINT fk_mus_pertenece_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist),
    -- O bien no existe fecha de baja, o si existe es mayor a la de inicio
    CONSTRAINT ck_mus_pertenece CHECK ((fecha_fin IS NULL) OR (fecha_fin >= fecha_inic))
);

CREATE TABLE manager (
    nombre VARCHAR2(35) NOT NULL,
    apellido VARCHAR2(20) NOT NULL,
    apellido2 VARCHAR2(20),
    movil NUMBER(9) NOT NULL,
    CONSTRAINT pk_manager PRIMARY KEY (movil)
);

CREATE TABLE gira (
    interprete VARCHAR2(50) NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    manager NUMBER(9) NOT NULL,
    CONSTRAINT pk_gira PRIMARY KEY (interprete, nombre),
    CONSTRAINT fk_gira_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist)
        ON DELETE CASCADE,
    CONSTRAINT fk_gira_manager
        FOREIGN KEY (manager)
        REFERENCES manager(movil)
        ON DELETE CASCADE
);

CREATE TABLE evento (
    interprete VARCHAR2(50) NOT NULL,
    fecha DATE NOT NULL,
    nom_gira VARCHAR2(100),
    manager NUMBER(9) NOT NULL,
    municipio VARCHAR2(100) NOT NULL,
    pais VARCHAR2(100) NOT NULL,
    direccion VARCHAR2(100) NOT NULL,
    asistentes NUMBER DEFAULT 0 NOT NULL,
    duracion NUMBER NOT NULL,
    CONSTRAINT pk_evento PRIMARY KEY (interprete, fecha),
    CONSTRAINT fk_evento_gira
        FOREIGN KEY (interprete, nom_gira)
        REFERENCES gira(interprete, nombre)
        ON DELETE SET NULL,
    CONSTRAINT fk_evento_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist)
        ON DELETE CASCADE,
    CONSTRAINT fk_evento_manager
        FOREIGN KEY (manager)
        REFERENCES manager(movil)
        ON DELETE CASCADE
);

CREATE TABLE tema (
    titulo_tema VARCHAR2(50) NOT NULL,
    autor VARCHAR2(14) NOT NULL,
    autor_sec VARCHAR2(14),
    CONSTRAINT pk_tema PRIMARY KEY (titulo_tema, autor),
    CONSTRAINT fk_autor_musico
        FOREIGN KEY (autor)
        REFERENCES musico(pasaporte),
    CONSTRAINT fk_autor_sec_musico
        FOREIGN KEY (autor_sec)
        REFERENCES musico(pasaporte)
);

CREATE TABLE tema_concierto (
    titulo_tema VARCHAR2(50) NOT NULL,
    autor VARCHAR2(14) NOT NULL,
    interprete VARCHAR2(50) NOT NULL,
    fecha DATE NOT NULL,
    orden_seq NUMBER NOT NULL,
    duracion NUMBER NOT NULL,
    CONSTRAINT pk_tema_concierto PRIMARY KEY (interprete, fecha, orden_seq),
    CONSTRAINT fk_tema_concierto_tema
        FOREIGN KEY (titulo_tema, autor)
        REFERENCES tema(titulo_tema, autor),
    CONSTRAINT fk_tema_concierto_evento
        FOREIGN KEY (interprete, fecha)
        REFERENCES evento(interprete, fecha)
        ON DELETE CASCADE,
    CONSTRAINT fk_tema_concierto_autor
        FOREIGN KEY (autor)
        REFERENCES musico(pasaporte),
    CONSTRAINT fk_tema_concierto_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist)
        ON DELETE CASCADE
);

CREATE TABLE discografica (
    nombre_discog VARCHAR2(25) NOT NULL,
    tlf_disc NUMBER(9) NOT NULL,
    CONSTRAINT pk_discografica PRIMARY KEY (nombre_discog)
);

CREATE TABLE album (
    pair CHAR(15) NOT NULL,
    interprete VARCHAR2(50) NOT NULL,
    nombre_alb VARCHAR2(50) NOT NULL,
    formato VARCHAR2(10) NOT NULL,
    fecha_alb DATE NOT NULL,
    discografica VARCHAR2(25) NOT NULL,
    manager NUMBER(9) NOT NULL,
    duracion NUMBER NOT NULL,
    CONSTRAINT pk_album PRIMARY KEY (pair),
    CONSTRAINT uk_album UNIQUE (interprete, nombre_alb, formato, fecha_alb),
    CONSTRAINT fk_album_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist),
    CONSTRAINT fk_album_discografica
        FOREIGN KEY (discografica)
        REFERENCES discografica(nombre_discog),
    CONSTRAINT fk_album_manager
        FOREIGN KEY (manager)
        REFERENCES manager(movil)
);

CREATE TABLE estudio (
    nombre_est VARCHAR2(50) NOT NULL,
    dir_est VARCHAR2(100) NOT NULL,
    CONSTRAINT pk_estudio PRIMARY KEY (nombre_est)
);

CREATE TABLE pista (
    titulo_tema VARCHAR2(50) NOT NULL,
    autor VARCHAR2(14) NOT NULL,
    interprete VARCHAR2(50) NOT NULL,
    fecha_grab DATE NOT NULL,
    ingeniero VARCHAR2(50) NOT NULL,
    estudio VARCHAR2(50),
    duracion NUMBER NOT NULL,
    CONSTRAINT pk_pista PRIMARY KEY (titulo_tema, autor, interprete, fecha_grab),
    CONSTRAINT fk_pista_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist),
    CONSTRAINT fk_pista_tema
        FOREIGN KEY (titulo_tema, autor)
        REFERENCES tema(titulo_tema, autor),
    CONSTRAINT fk_pista_autor
        FOREIGN KEY (autor)
        REFERENCES musico(pasaporte),
    CONSTRAINT fk_pista_estudio
        FOREIGN KEY (estudio)
        REFERENCES estudio(nombre_est)
        ON DELETE SET NULL,
    CONSTRAINT ck_pista_duracion CHECK ((duracion > 0) AND (duracion <= 5400))
);

CREATE TABLE pista_album (
    titulo_tema VARCHAR2(50) NOT NULL,
    autor VARCHAR2(14) NOT NULL,
    interprete VARCHAR2(50) NOT NULL,
    fecha_grab DATE NOT NULL,
    pair CHAR(15) NOT NULL,
    num_pista NUMBER NOT NULL,
    CONSTRAINT pk_pista_album PRIMARY KEY (titulo_tema, autor, interprete, fecha_grab, pair),
    CONSTRAINT uk_pista_album UNIQUE (pair, num_pista),
    CONSTRAINT fk_pista_album_pista
        FOREIGN KEY (titulo_tema, autor, interprete, fecha_grab)
        REFERENCES pista(titulo_tema, autor, interprete, fecha_grab),
    CONSTRAINT fk_pista_album_album
        FOREIGN KEY (pair)
        REFERENCES album(pair)
        ON DELETE CASCADE,
    CONSTRAINT fk_pista_album_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist),
    CONSTRAINT fk_pista_album_tema
        FOREIGN KEY (titulo_tema, autor)
        REFERENCES tema(titulo_tema, autor),
    CONSTRAINT fk_pista_album_autor
        FOREIGN KEY (autor)
        REFERENCES musico(pasaporte)
);

CREATE TABLE cliente (
    email VARCHAR2(100) NOT NULL,
    dni NUMBER(8),
    nombre VARCHAR2(80),
    ap1 VARCHAR2(80),
    ap2 VARCHAR2(80),
    fecha_nac DATE,
    tlf NUMBER(9),
    dir VARCHAR2(100),
    CONSTRAINT pk_cliente PRIMARY KEY (email),
    CONSTRAINT uk_cliente UNIQUE (dni)
);

CREATE TABLE ficha (
    interprete VARCHAR2(50) NOT NULL,
    fecha DATE NOT NULL,
    cliente VARCHAR2(100) NOT NULL,
    rfid VARCHAR2(120) NOT NULL,
    fecha_nac DATE NOT NULL,
    fecha_compra DATE NOT NULL,
    CONSTRAINT pk_ficha PRIMARY KEY (interprete, fecha, cliente),
    CONSTRAINT uk_ficha UNIQUE (rfid),
    CONSTRAINT fk_ficha_evento
        FOREIGN KEY (interprete, fecha)
        REFERENCES evento(interprete, fecha),
    CONSTRAINT fk_ficha_cliente
        FOREIGN KEY (cliente)
        REFERENCES cliente(email)
        ON DELETE CASCADE,
    CONSTRAINT fk_ficha_interprete
        FOREIGN KEY (interprete)
        REFERENCES interprete(nom_artist),
    CONSTRAINT ck_fecha_compra_valida CHECK (fecha >= fecha_compra),
    CONSTRAINT ck_mayor_edad CHECK (fecha >= fecha_nac + 6574.36)
);
