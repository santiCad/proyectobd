-- ======================================================================
-- SECUENCIAS REQUERIDAS POR LA APLICACIÓN JAVAFX
-- Ejecutar en Oracle antes de correr la aplicación
-- ======================================================================
-- Solo es necesario si no se crearon en el script 01_crear_estructura.sql

-- Secuencia para USUARIO
CREATE SEQUENCE SEQ_USUARIO
    START WITH 1
    INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Secuencia para INSTRUCTOR
CREATE SEQUENCE SEQ_INSTRUCTOR
    START WITH 1
    INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Secuencia para CURSO
CREATE SEQUENCE SEQ_CURSO
    START WITH 1
    INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Secuencia para MODULO
CREATE SEQUENCE SEQ_MODULO
    START WITH 1
    INCREMENT BY 1
    NOCACHE NOCYCLE;

-- Secuencia para LECCION
CREATE SEQUENCE SEQ_LECCION
    START WITH 1
    INCREMENT BY 1
    NOCACHE NOCYCLE;
