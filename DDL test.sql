--https://kasabiann.files.wordpress.com/2011/01/entidad-relacion.png

CREATE TABLE autores(
	id NUMBER(4) PRIMARY KEY,
	nombre VARCHAR2(50) NOT NULL,
	apellido_paterno VARCHAR2(50) NOT NULL,
	apellido_materno VARCHAR2(50) NOT NULL
);

CREATE TABLE libros(
	isbn VARCHAR2(13) PRIMARY KEY,
	titulo VARCHAR2(255) NOT NULL,
	sinopsis VARCHAR2(1000),
	num_paginas NUMBER(4),
	editorial_id NUMBER(4)
);

CREATE TABLE autores_libros(
	autor_id NUMBER(4),
	libro_id VARCHAR2(13)
);

CREATE TABLE editoriales(
	id NUMBER(4) PRIMARY KEY,
	nombre VARCHAR2(100) NOT NULL,
	sede VARCHAR2(255)
);

ALTER TABLE autores_libros
ADD CONSTRAINT autor_fk FOREIGN KEY(autor_id)
REFERENCES autores(id);

ALTER TABLE autores_libros
ADD CONSTRAINT libro_fk FOREIGN KEY(libro_id)
REFERENCES libros(isbn);

ALTER TABLE libros
ADD CONSTRAINT libro_editorial_fk FOREIGN KEY(editorial_id)
REFERENCES editoriales(id);