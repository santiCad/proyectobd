-- ============================================================
-- SCRIPT DDL: Creacion de Estructura
-- Archivo   : 01_crear_estructura.sql
-- Sistema   : Plataforma de Gestion de Cursos Online
-- Autores   : Nicolas Jimenez C. | Johan Santiago Cadena G.
--             Jhon Sebastian Mejia A. | Alejandro Rodriguez M.
-- Materia   : Bases de Datos 2026-10
-- ============================================================
-- Opción rápida: purgar objetos del usuario actual
-- Paso 1: Eliminar FK primero (para evitar dependencias)
BEGIN
  FOR c IN (SELECT constraint_name, table_name
            FROM user_constraints
            WHERE constraint_type = 'R') LOOP
    EXECUTE IMMEDIATE 'ALTER TABLE "' || c.table_name ||
                      '" DROP CONSTRAINT "' || c.constraint_name || '"';
  END LOOP;
END;
/

-- Paso 2: Eliminar las tablas
BEGIN
  FOR t IN (SELECT table_name FROM user_tables) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE "' || t.table_name || '" CASCADE CONSTRAINTS';
  END LOOP;
END;
/
-- ============================================================
-- SECCION 1: ELIMINACION DE TABLAS (en orden inverso de FK)
-- ============================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE CERTIFICADO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PROGRESO_LECCION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE PUBLICACION_FORO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE FORO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE RESULTADO_EVALUACION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE EVALUACION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE LECCION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE MODULO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE INSCRIPCION CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE CURSO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE INSTRUCTOR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ADMINISTRADOR CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE ESTUDIANTE CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE USUARIO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================
-- ELIMINACION DE SECUENCIAS
-- ============================================================

BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_USUARIO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_ADMIN'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_INSTRUCTOR'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_CURSO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_INSCRIPCION'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_MODULO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_LECCION'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_EVALUACION'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_RESULTADO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_FORO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_PUBLICACION'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_PROGRESO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_CERTIFICADO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- ============================================================
-- SECCION 2: CREACION DE SECUENCIAS
-- ============================================================

CREATE SEQUENCE SEQ_USUARIO     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_ADMIN       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_INSTRUCTOR  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CURSO       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_INSCRIPCION START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_MODULO      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_LECCION     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_EVALUACION  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_RESULTADO   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_FORO        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PUBLICACION START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_PROGRESO    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE SEQ_CERTIFICADO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- ============================================================
-- SECCION 3: CREACION DE TABLAS
-- ============================================================

-- ------------------------------------------------------------
-- Tabla 1: USUARIO (tabla padre de herencia)
-- ------------------------------------------------------------
CREATE TABLE USUARIO (
    id_usuario      NUMBER          CONSTRAINT pk_usuario PRIMARY KEY,
    nombre          VARCHAR2(100)   CONSTRAINT nn_usu_nombre    NOT NULL,
    email           VARCHAR2(150)   CONSTRAINT nn_usu_email     NOT NULL
                                    CONSTRAINT uq_usu_email     UNIQUE,
    nickname        VARCHAR2(60)    CONSTRAINT nn_usu_nickname  NOT NULL
                                    CONSTRAINT uq_usu_nickname  UNIQUE,
    contrasena      VARCHAR2(255)   CONSTRAINT nn_usu_pass      NOT NULL,
    rol             VARCHAR2(20)    CONSTRAINT nn_usu_rol       NOT NULL
                                    CONSTRAINT ck_usu_rol       CHECK (rol IN ('estudiante', 'instructor', 'administrador')),
    activo          NUMBER(1)       DEFAULT 1
                                    CONSTRAINT nn_usu_activo    NOT NULL
                                    CONSTRAINT ck_usu_activo    CHECK (activo IN (0, 1)),
    fecha_registro  DATE            DEFAULT SYSDATE
                                    CONSTRAINT nn_usu_fecha_reg NOT NULL
);

COMMENT ON TABLE  USUARIO                IS 'Tabla padre de herencia. Contiene datos comunes a todos los tipos de usuario del sistema.';
COMMENT ON COLUMN USUARIO.id_usuario     IS 'Identificador unico del usuario.';
COMMENT ON COLUMN USUARIO.nombre         IS 'Nombre completo del usuario.';
COMMENT ON COLUMN USUARIO.email          IS 'Correo electronico unico usado para autenticacion.';
COMMENT ON COLUMN USUARIO.nickname       IS 'Nombre de usuario publico, unico en la plataforma.';
COMMENT ON COLUMN USUARIO.contrasena     IS 'Hash de la contrasena del usuario.';
COMMENT ON COLUMN USUARIO.rol            IS 'Rol del usuario: estudiante, instructor o administrador.';
COMMENT ON COLUMN USUARIO.activo         IS 'Indica si la cuenta esta habilitada (1) o deshabilitada (0).';
COMMENT ON COLUMN USUARIO.fecha_registro IS 'Fecha en que el usuario se registro en la plataforma.';

-- ------------------------------------------------------------
-- Tabla 2: ESTUDIANTE (herencia de USUARIO, PK/FK compartida)
-- ------------------------------------------------------------
CREATE TABLE ESTUDIANTE (
    id_usuario       NUMBER         CONSTRAINT pk_estudiante PRIMARY KEY,
    areas_interes    VARCHAR2(300),
    fecha_nacim      DATE,
    nivel_educativo  VARCHAR2(50)   CONSTRAINT ck_est_nivel CHECK (nivel_educativo IN ('bachillerato', 'tecnico', 'pregrado', 'posgrado', 'otro')),
    notif_email      NUMBER(1)      DEFAULT 1
                                   CONSTRAINT ck_est_notif CHECK (notif_email IN (0, 1)),
    -- FK que implementa la herencia ES_UN
    CONSTRAINT fk_est_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

COMMENT ON TABLE  ESTUDIANTE              IS 'Subtipo de USUARIO. Almacena atributos exclusivos del rol estudiante.';
COMMENT ON COLUMN ESTUDIANTE.id_usuario   IS 'PK y FK hacia USUARIO. Implementa la relacion de herencia ES_UN.';
COMMENT ON COLUMN ESTUDIANTE.areas_interes IS 'Temas de interes del estudiante (valor libre, podria normalizarse a futuro).';
COMMENT ON COLUMN ESTUDIANTE.fecha_nacim  IS 'Fecha de nacimiento del estudiante.';
COMMENT ON COLUMN ESTUDIANTE.nivel_educativo IS 'Nivel de escolaridad del estudiante.';
COMMENT ON COLUMN ESTUDIANTE.notif_email  IS 'Indica si el estudiante acepta notificaciones por email (1=si, 0=no).';

-- ------------------------------------------------------------
-- Tabla 3: ADMINISTRADOR (herencia de USUARIO, PK propia)
-- ------------------------------------------------------------
CREATE TABLE ADMINISTRADOR (
    id_admin      NUMBER        CONSTRAINT pk_admin PRIMARY KEY,
    id_usuario    NUMBER        CONSTRAINT nn_adm_usuario NOT NULL,
    nombre_adm    VARCHAR2(100) CONSTRAINT nn_adm_nombre  NOT NULL,
    nivel_acceso  VARCHAR2(30)  CONSTRAINT nn_adm_nivel   NOT NULL
                                CONSTRAINT ck_adm_nivel   CHECK (nivel_acceso IN ('basico', 'intermedio', 'superadmin')),
    -- FK que implementa la herencia ES_UN
    CONSTRAINT fk_adm_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT uq_adm_usuario UNIQUE (id_usuario)
);

COMMENT ON TABLE  ADMINISTRADOR             IS 'Subtipo de USUARIO. Almacena atributos exclusivos del rol administrador.';
COMMENT ON COLUMN ADMINISTRADOR.id_admin    IS 'Identificador propio del administrador.';
COMMENT ON COLUMN ADMINISTRADOR.id_usuario  IS 'FK hacia USUARIO. Implementa la relacion de herencia ES_UN.';
COMMENT ON COLUMN ADMINISTRADOR.nombre_adm  IS 'Nombre de display del administrador dentro del sistema.';
COMMENT ON COLUMN ADMINISTRADOR.nivel_acceso IS 'Nivel de permisos: basico, intermedio o superadmin.';

-- ------------------------------------------------------------
-- Tabla 4: INSTRUCTOR (herencia de USUARIO, PK propia)
-- ------------------------------------------------------------
CREATE TABLE INSTRUCTOR (
    id_instructor      NUMBER        CONSTRAINT pk_instructor PRIMARY KEY,
    id_usuario         NUMBER        CONSTRAINT nn_ins_usuario NOT NULL,
    nombre             VARCHAR2(100) CONSTRAINT nn_ins_nombre  NOT NULL,
    especialidad       VARCHAR2(150),
    biografia          CLOB,
    calificacion_prom  NUMBER(3,2)   DEFAULT 0
                                     CONSTRAINT ck_ins_calif CHECK (calificacion_prom BETWEEN 0 AND 5),
    -- FK que implementa la herencia ES_UN
    CONSTRAINT fk_inst_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT uq_inst_usuario UNIQUE (id_usuario)
);

COMMENT ON TABLE  INSTRUCTOR                  IS 'Subtipo de USUARIO. Almacena atributos exclusivos del rol instructor.';
COMMENT ON COLUMN INSTRUCTOR.id_instructor    IS 'Identificador propio del instructor.';
COMMENT ON COLUMN INSTRUCTOR.id_usuario       IS 'FK hacia USUARIO. Implementa la relacion de herencia ES_UN.';
COMMENT ON COLUMN INSTRUCTOR.nombre           IS 'Nombre publico del instructor mostrado en los cursos.';
COMMENT ON COLUMN INSTRUCTOR.especialidad     IS 'Area de conocimiento principal del instructor.';
COMMENT ON COLUMN INSTRUCTOR.biografia        IS 'Descripcion larga del perfil del instructor.';
COMMENT ON COLUMN INSTRUCTOR.calificacion_prom IS 'Promedio de calificaciones recibidas (0.00 a 5.00).';

-- ------------------------------------------------------------
-- Tabla 5: CURSO
-- ------------------------------------------------------------
CREATE TABLE CURSO (
    id_curso          NUMBER         CONSTRAINT pk_curso PRIMARY KEY,
    titulo            VARCHAR2(200)  CONSTRAINT nn_cur_titulo   NOT NULL,
    precio            NUMBER(10,2)   DEFAULT 0
                                     CONSTRAINT ck_cur_precio   CHECK (precio >= 0),
    categoria         VARCHAR2(100)  CONSTRAINT nn_cur_cat      NOT NULL,
    estado            VARCHAR2(20)   DEFAULT 'borrador'
                                     CONSTRAINT nn_cur_estado   NOT NULL
                                     CONSTRAINT ck_cur_estado   CHECK (estado IN ('borrador', 'publicado', 'archivado')),
    puntaje_min_cert  NUMBER(5,2)    DEFAULT 70
                                     CONSTRAINT ck_cur_pmin    CHECK (puntaje_min_cert BETWEEN 0 AND 100),
    fecha_creacion    DATE           DEFAULT SYSDATE
                                     CONSTRAINT nn_cur_fecha    NOT NULL,
    id_instructor     NUMBER         CONSTRAINT nn_cur_inst     NOT NULL,
    -- FK relacion DICTA: un instructor dicta muchos cursos
    CONSTRAINT fk_cur_instructor FOREIGN KEY (id_instructor) REFERENCES INSTRUCTOR(id_instructor)
);

COMMENT ON TABLE  CURSO                  IS 'Representa un curso ofrecido en la plataforma, dictado por un instructor.';
COMMENT ON COLUMN CURSO.id_curso         IS 'Identificador unico del curso.';
COMMENT ON COLUMN CURSO.titulo           IS 'Titulo descriptivo del curso.';
COMMENT ON COLUMN CURSO.precio           IS 'Precio de inscripcion al curso en moneda local.';
COMMENT ON COLUMN CURSO.categoria        IS 'Categoria tematica del curso (ej: Programacion, Diseno, Marketing).';
COMMENT ON COLUMN CURSO.estado           IS 'Estado del ciclo de vida: borrador, publicado o archivado.';
COMMENT ON COLUMN CURSO.puntaje_min_cert IS 'Puntaje minimo (0-100) requerido para obtener certificado.';
COMMENT ON COLUMN CURSO.fecha_creacion   IS 'Fecha en que el curso fue creado en el sistema.';
COMMENT ON COLUMN CURSO.id_instructor    IS 'FK hacia INSTRUCTOR. Relacion DICTA (N:1).';

-- ------------------------------------------------------------
-- Tabla 6: INSCRIPCION (tabla intermedia M:N entre USUARIO y CURSO)
-- ------------------------------------------------------------
CREATE TABLE INSCRIPCION (
    id_inscripcion  NUMBER        CONSTRAINT pk_inscripcion PRIMARY KEY,
    id_usuario      NUMBER        CONSTRAINT nn_ins_usr   NOT NULL,
    id_curso        NUMBER        CONSTRAINT nn_ins_cur   NOT NULL,
    fecha_matric    DATE          DEFAULT SYSDATE
                                  CONSTRAINT nn_ins_fecha NOT NULL,
    progreso_pct    NUMBER(5,2)   DEFAULT 0
                                  CONSTRAINT ck_ins_prog  CHECK (progreso_pct BETWEEN 0 AND 100),
    estado          VARCHAR2(20)  DEFAULT 'activo'
                                  CONSTRAINT nn_ins_est   NOT NULL
                                  CONSTRAINT ck_ins_est   CHECK (estado IN ('activo', 'completado', 'abandonado')),
    -- FK relacion MATRICULADO_EN
    CONSTRAINT fk_insc_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT fk_insc_curso   FOREIGN KEY (id_curso)   REFERENCES CURSO(id_curso),
    -- Un usuario no puede inscribirse dos veces al mismo curso
    CONSTRAINT uq_insc_usr_cur UNIQUE (id_usuario, id_curso)
);

COMMENT ON TABLE  INSCRIPCION               IS 'Tabla intermedia que resuelve la relacion M:N MATRICULADO_EN entre USUARIO y CURSO.';
COMMENT ON COLUMN INSCRIPCION.id_inscripcion IS 'Identificador unico de la inscripcion.';
COMMENT ON COLUMN INSCRIPCION.id_usuario     IS 'FK hacia USUARIO. Parte de la clave compuesta logica.';
COMMENT ON COLUMN INSCRIPCION.id_curso       IS 'FK hacia CURSO. Parte de la clave compuesta logica.';
COMMENT ON COLUMN INSCRIPCION.fecha_matric   IS 'Fecha en que el estudiante se matriculo al curso.';
COMMENT ON COLUMN INSCRIPCION.progreso_pct   IS 'Porcentaje de avance del estudiante en el curso (0-100).';
COMMENT ON COLUMN INSCRIPCION.estado         IS 'Estado de la inscripcion: activo, completado o abandonado.';

-- ------------------------------------------------------------
-- Tabla 7: MODULO (pertenece a un CURSO)
-- ------------------------------------------------------------
CREATE TABLE MODULO (
    id_modulo  NUMBER        CONSTRAINT pk_modulo PRIMARY KEY,
    titulo     VARCHAR2(200) CONSTRAINT nn_mod_titulo NOT NULL,
    orden      NUMBER        CONSTRAINT nn_mod_orden  NOT NULL
                             CONSTRAINT ck_mod_orden  CHECK (orden > 0),
    id_curso   NUMBER        CONSTRAINT nn_mod_curso  NOT NULL,
    -- FK relacion CONTIENE: un curso contiene muchos modulos
    CONSTRAINT fk_mod_curso FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso)
);

COMMENT ON TABLE  MODULO          IS 'Unidad tematica que agrupa lecciones dentro de un curso.';
COMMENT ON COLUMN MODULO.id_modulo IS 'Identificador unico del modulo.';
COMMENT ON COLUMN MODULO.titulo   IS 'Titulo descriptivo del modulo.';
COMMENT ON COLUMN MODULO.orden    IS 'Posicion del modulo dentro del curso (comienza en 1).';
COMMENT ON COLUMN MODULO.id_curso IS 'FK hacia CURSO. Relacion CONTIENE (N:1).';

-- ------------------------------------------------------------
-- Tabla 8: LECCION (pertenece a un MODULO)
-- ------------------------------------------------------------
CREATE TABLE LECCION (
    id_leccion      NUMBER        CONSTRAINT pk_leccion PRIMARY KEY,
    titulo          VARCHAR2(200) CONSTRAINT nn_lec_titulo NOT NULL,
    tipo_contenido  VARCHAR2(30)  CONSTRAINT nn_lec_tipo   NOT NULL
                                  CONSTRAINT ck_lec_tipo   CHECK (tipo_contenido IN ('video', 'lectura', 'quiz', 'recurso')),
    url_contenido   VARCHAR2(500),
    duracion_min    NUMBER        CONSTRAINT ck_lec_dur    CHECK (duracion_min >= 0),
    orden           NUMBER        CONSTRAINT nn_lec_orden  NOT NULL
                                  CONSTRAINT ck_lec_orden  CHECK (orden > 0),
    es_obligatoria  NUMBER(1)     DEFAULT 1
                                  CONSTRAINT ck_lec_oblig  CHECK (es_obligatoria IN (0, 1)),
    id_modulo       NUMBER        CONSTRAINT nn_lec_modulo NOT NULL,
    -- FK relacion TIENE: un modulo tiene muchas lecciones
    CONSTRAINT fk_lec_modulo FOREIGN KEY (id_modulo) REFERENCES MODULO(id_modulo)
);

COMMENT ON TABLE  LECCION                IS 'Unidad minima de contenido dentro de un modulo (video, lectura, quiz o recurso).';
COMMENT ON COLUMN LECCION.id_leccion     IS 'Identificador unico de la leccion.';
COMMENT ON COLUMN LECCION.titulo         IS 'Titulo descriptivo de la leccion.';
COMMENT ON COLUMN LECCION.tipo_contenido IS 'Tipo de contenido: video, lectura, quiz o recurso descargable.';
COMMENT ON COLUMN LECCION.url_contenido  IS 'URL al recurso de contenido (video, PDF, etc.).';
COMMENT ON COLUMN LECCION.duracion_min   IS 'Duracion estimada de la leccion en minutos.';
COMMENT ON COLUMN LECCION.orden          IS 'Posicion de la leccion dentro del modulo.';
COMMENT ON COLUMN LECCION.es_obligatoria IS 'Indica si la leccion es obligatoria para completar el modulo (1=si, 0=no).';
COMMENT ON COLUMN LECCION.id_modulo      IS 'FK hacia MODULO. Relacion TIENE (N:1).';

-- ------------------------------------------------------------
-- Tabla 9: EVALUACION (pertenece a un CURSO)
-- ------------------------------------------------------------
CREATE TABLE EVALUACION (
    id_eval           NUMBER        CONSTRAINT pk_evaluacion PRIMARY KEY,
    titulo            VARCHAR2(200) CONSTRAINT nn_eva_titulo NOT NULL,
    puntaje_min       NUMBER(5,2)   DEFAULT 60
                                    CONSTRAINT ck_eva_pmin   CHECK (puntaje_min BETWEEN 0 AND 100),
    tipo              VARCHAR2(20)  CONSTRAINT nn_eva_tipo   NOT NULL
                                    CONSTRAINT ck_eva_tipo   CHECK (tipo IN ('quiz', 'examen_final', 'tarea', 'proyecto')),
    tiempo_limite_min NUMBER        CONSTRAINT ck_eva_tiem   CHECK (tiempo_limite_min > 0),
    id_curso          NUMBER        CONSTRAINT nn_eva_curso  NOT NULL,
    -- FK relacion INCLUYE: un curso incluye muchas evaluaciones
    CONSTRAINT fk_eva_curso FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso)
);

COMMENT ON TABLE  EVALUACION                  IS 'Evaluacion o actividad de calificacion asociada a un curso.';
COMMENT ON COLUMN EVALUACION.id_eval          IS 'Identificador unico de la evaluacion.';
COMMENT ON COLUMN EVALUACION.titulo           IS 'Titulo de la evaluacion.';
COMMENT ON COLUMN EVALUACION.puntaje_min      IS 'Puntaje minimo para aprobar la evaluacion (0-100).';
COMMENT ON COLUMN EVALUACION.tipo             IS 'Tipo de evaluacion: quiz, examen_final, tarea o proyecto.';
COMMENT ON COLUMN EVALUACION.tiempo_limite_min IS 'Tiempo maximo en minutos para completar la evaluacion. NULL = sin limite.';
COMMENT ON COLUMN EVALUACION.id_curso         IS 'FK hacia CURSO. Relacion INCLUYE (N:1).';

-- ------------------------------------------------------------
-- Tabla 10: RESULTADO_EVALUACION (tabla intermedia M:N USUARIO-EVALUACION)
-- ------------------------------------------------------------
CREATE TABLE RESULTADO_EVALUACION (
    id_resultado     NUMBER       CONSTRAINT pk_resultado PRIMARY KEY,
    id_eval          NUMBER       CONSTRAINT nn_res_eval  NOT NULL,
    id_usuario       NUMBER       CONSTRAINT nn_res_usr   NOT NULL,
    puntaje_obtenido NUMBER(5,2)  CONSTRAINT nn_res_punt  NOT NULL
                                  CONSTRAINT ck_res_punt  CHECK (puntaje_obtenido BETWEEN 0 AND 100),
    fecha_intento    DATE         DEFAULT SYSDATE
                                  CONSTRAINT nn_res_fecha NOT NULL,
    aprobado         NUMBER(1)    CONSTRAINT nn_res_apro  NOT NULL
                                  CONSTRAINT ck_res_apro  CHECK (aprobado IN (0, 1)),
    -- FK relacion REALIZA
    CONSTRAINT fk_res_eval    FOREIGN KEY (id_eval)    REFERENCES EVALUACION(id_eval),
    CONSTRAINT fk_res_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

COMMENT ON TABLE  RESULTADO_EVALUACION              IS 'Registra cada intento de un usuario en una evaluacion. Tabla intermedia de REALIZA (M:N).';
COMMENT ON COLUMN RESULTADO_EVALUACION.id_resultado  IS 'Identificador unico del resultado.';
COMMENT ON COLUMN RESULTADO_EVALUACION.id_eval       IS 'FK hacia EVALUACION.';
COMMENT ON COLUMN RESULTADO_EVALUACION.id_usuario    IS 'FK hacia USUARIO.';
COMMENT ON COLUMN RESULTADO_EVALUACION.puntaje_obtenido IS 'Puntaje alcanzado por el usuario en este intento (0-100).';
COMMENT ON COLUMN RESULTADO_EVALUACION.fecha_intento IS 'Fecha y hora en que se realizo el intento.';
COMMENT ON COLUMN RESULTADO_EVALUACION.aprobado      IS 'Indica si el intento fue aprobado (1=si, 0=no).';

-- ------------------------------------------------------------
-- Tabla 11: FORO (relacion 1:1 con CURSO)
-- ------------------------------------------------------------
CREATE TABLE FORO (
    id_foro      NUMBER        CONSTRAINT pk_foro PRIMARY KEY,
    titulo       VARCHAR2(200) CONSTRAINT nn_foro_titulo NOT NULL,
    descripcion  VARCHAR2(500),
    id_curso     NUMBER        CONSTRAINT nn_foro_curso  NOT NULL,
    -- FK relacion PERTENECE (1:1 logico)
    CONSTRAINT fk_foro_curso FOREIGN KEY (id_curso) REFERENCES CURSO(id_curso),
    CONSTRAINT uq_foro_curso UNIQUE (id_curso)
);

COMMENT ON TABLE  FORO             IS 'Espacio de discusion asociado a un curso. Relacion 1:1 con CURSO.';
COMMENT ON COLUMN FORO.id_foro    IS 'Identificador unico del foro.';
COMMENT ON COLUMN FORO.titulo     IS 'Titulo del foro de discusion.';
COMMENT ON COLUMN FORO.descripcion IS 'Descripcion breve del proposito del foro.';
COMMENT ON COLUMN FORO.id_curso   IS 'FK hacia CURSO. UNIQUE garantiza la relacion 1:1.';

-- ------------------------------------------------------------
-- Tabla 12: PUBLICACION_FORO (con Self-Join para hilos)
-- ------------------------------------------------------------
CREATE TABLE PUBLICACION_FORO (
    id_publicacion    NUMBER       CONSTRAINT pk_publicacion PRIMARY KEY,
    id_foro           NUMBER       CONSTRAINT nn_pub_foro   NOT NULL,
    id_usuario        NUMBER       CONSTRAINT nn_pub_usr    NOT NULL,
    contenido         CLOB         CONSTRAINT nn_pub_cont   NOT NULL,
    fecha_publicacion DATE         DEFAULT SYSDATE
                                   CONSTRAINT nn_pub_fecha  NOT NULL,
    id_pub_padre      NUMBER,       -- NULL si es publicacion raiz
    -- FK relacion TIENE (Foro-Publicacion)
    CONSTRAINT fk_pub_foro    FOREIGN KEY (id_foro)      REFERENCES FORO(id_foro),
    -- FK relacion ESCRIBE (Usuario-Publicacion)
    CONSTRAINT fk_pub_usuario FOREIGN KEY (id_usuario)   REFERENCES USUARIO(id_usuario),
    -- FK Self-Join: relacion recursiva RESPONDE_A
    CONSTRAINT fk_pub_padre   FOREIGN KEY (id_pub_padre) REFERENCES PUBLICACION_FORO(id_publicacion)
);

COMMENT ON TABLE  PUBLICACION_FORO                  IS 'Mensaje publicado en un foro. El Self-Join id_pub_padre permite hilos de respuestas anidados.';
COMMENT ON COLUMN PUBLICACION_FORO.id_publicacion   IS 'Identificador unico de la publicacion.';
COMMENT ON COLUMN PUBLICACION_FORO.id_foro          IS 'FK hacia FORO al que pertenece la publicacion.';
COMMENT ON COLUMN PUBLICACION_FORO.id_usuario       IS 'FK hacia USUARIO que escribio la publicacion.';
COMMENT ON COLUMN PUBLICACION_FORO.contenido        IS 'Texto completo de la publicacion.';
COMMENT ON COLUMN PUBLICACION_FORO.fecha_publicacion IS 'Fecha y hora de la publicacion.';
COMMENT ON COLUMN PUBLICACION_FORO.id_pub_padre     IS 'FK Self-Join: apunta a la publicacion que esta responde. NULL si es raiz. Relacion RESPONDE_A.';

-- ------------------------------------------------------------
-- Tabla 13: PROGRESO_LECCION (tabla intermedia M:N USUARIO-LECCION)
-- ------------------------------------------------------------
CREATE TABLE PROGRESO_LECCION (
    id_progreso      NUMBER   CONSTRAINT pk_progreso PRIMARY KEY,
    id_usuario       NUMBER   CONSTRAINT nn_pro_usr   NOT NULL,
    id_leccion       NUMBER   CONSTRAINT nn_pro_lec   NOT NULL,
    completada       NUMBER(1) DEFAULT 0
                              CONSTRAINT ck_pro_comp  CHECK (completada IN (0, 1)),
    fecha_inicio     DATE     DEFAULT SYSDATE,
    fecha_completado DATE,
    -- FK relacion REGISTRA
    CONSTRAINT fk_pro_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT fk_pro_leccion FOREIGN KEY (id_leccion) REFERENCES LECCION(id_leccion),
    -- Un usuario solo tiene un registro de progreso por leccion
    CONSTRAINT uq_pro_usr_lec UNIQUE (id_usuario, id_leccion),
    -- Restriccion: fecha_completado no puede ser anterior a fecha_inicio
    CONSTRAINT ck_pro_fechas CHECK (fecha_completado IS NULL OR fecha_completado >= fecha_inicio)
);

COMMENT ON TABLE  PROGRESO_LECCION               IS 'Rastrea el avance de un usuario en cada leccion. Tabla intermedia de REGISTRA (M:N).';
COMMENT ON COLUMN PROGRESO_LECCION.id_progreso   IS 'Identificador unico del registro de progreso.';
COMMENT ON COLUMN PROGRESO_LECCION.id_usuario    IS 'FK hacia USUARIO.';
COMMENT ON COLUMN PROGRESO_LECCION.id_leccion    IS 'FK hacia LECCION.';
COMMENT ON COLUMN PROGRESO_LECCION.completada    IS 'Indica si el usuario completo la leccion (1=si, 0=no).';
COMMENT ON COLUMN PROGRESO_LECCION.fecha_inicio  IS 'Fecha en que el usuario comenzo la leccion.';
COMMENT ON COLUMN PROGRESO_LECCION.fecha_completado IS 'Fecha en que el usuario completo la leccion. NULL si aun no la termina.';

-- ------------------------------------------------------------
-- Tabla 14: CERTIFICADO
-- ------------------------------------------------------------
CREATE TABLE CERTIFICADO (
    id_certificado  NUMBER        CONSTRAINT pk_certificado PRIMARY KEY,
    id_usuario      NUMBER        CONSTRAINT nn_cer_usr   NOT NULL,
    id_curso        NUMBER        CONSTRAINT nn_cer_cur   NOT NULL,
    cod_verif       VARCHAR2(60)  CONSTRAINT nn_cer_cod   NOT NULL
                                  CONSTRAINT uq_cer_cod   UNIQUE,
    fecha_gen       DATE          DEFAULT SYSDATE
                                  CONSTRAINT nn_cer_fecha NOT NULL,
    url_descarga    VARCHAR2(500),
    -- FK relacion OBTIENE
    CONSTRAINT fk_cer_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT fk_cer_curso   FOREIGN KEY (id_curso)   REFERENCES CURSO(id_curso),
    -- Un usuario no puede tener dos certificados del mismo curso
    CONSTRAINT uq_cer_usr_cur UNIQUE (id_usuario, id_curso)
);

COMMENT ON TABLE  CERTIFICADO                IS 'Certificado de finalizacion emitido al completar un curso con el puntaje minimo requerido.';
COMMENT ON COLUMN CERTIFICADO.id_certificado IS 'Identificador unico del certificado.';
COMMENT ON COLUMN CERTIFICADO.id_usuario     IS 'FK hacia USUARIO que recibe el certificado.';
COMMENT ON COLUMN CERTIFICADO.id_curso       IS 'FK hacia CURSO por el que se emite el certificado.';
COMMENT ON COLUMN CERTIFICADO.cod_verif      IS 'Codigo unico de verificacion de autenticidad del certificado.';
COMMENT ON COLUMN CERTIFICADO.fecha_gen      IS 'Fecha en que se genero el certificado.';
COMMENT ON COLUMN CERTIFICADO.url_descarga   IS 'URL para descargar el certificado en PDF.';

-- ============================================================
-- SECCION 4: INDICES EN LLAVES FORANEAS Y BUSQUEDAS FRECUENTES
-- ============================================================

-- Indices en ESTUDIANTE
CREATE INDEX idx_est_nivel     ON ESTUDIANTE(nivel_educativo);

-- Indices en ADMINISTRADOR


-- Indices en INSTRUCTOR


-- Indices en CURSO
CREATE INDEX idx_cur_instructor ON CURSO(id_instructor);
CREATE INDEX idx_cur_estado     ON CURSO(estado);
CREATE INDEX idx_cur_categoria  ON CURSO(categoria);

-- Indices en INSCRIPCION
CREATE INDEX idx_insc_usuario    ON INSCRIPCION(id_usuario);
CREATE INDEX idx_insc_curso      ON INSCRIPCION(id_curso);
CREATE INDEX idx_insc_estado     ON INSCRIPCION(estado);

-- Indices en MODULO
CREATE INDEX idx_mod_curso      ON MODULO(id_curso);

-- Indices en LECCION
CREATE INDEX idx_lec_modulo     ON LECCION(id_modulo);
CREATE INDEX idx_lec_tipo       ON LECCION(tipo_contenido);

-- Indices en EVALUACION
CREATE INDEX idx_eva_curso      ON EVALUACION(id_curso);

-- Indices en RESULTADO_EVALUACION
CREATE INDEX idx_res_eval       ON RESULTADO_EVALUACION(id_eval);
CREATE INDEX idx_res_usuario    ON RESULTADO_EVALUACION(id_usuario);

-- Indices en FORO


-- Indices en PUBLICACION_FORO
CREATE INDEX idx_pub_foro       ON PUBLICACION_FORO(id_foro);
CREATE INDEX idx_pub_usuario    ON PUBLICACION_FORO(id_usuario);
CREATE INDEX idx_pub_padre      ON PUBLICACION_FORO(id_pub_padre);

-- Indices en PROGRESO_LECCION
CREATE INDEX idx_pro_usuario    ON PROGRESO_LECCION(id_usuario);
CREATE INDEX idx_pro_leccion    ON PROGRESO_LECCION(id_leccion);

-- Indices en CERTIFICADO
CREATE INDEX idx_cer_usuario    ON CERTIFICADO(id_usuario);
CREATE INDEX idx_cer_curso      ON CERTIFICADO(id_curso);

-- ============================================================
-- FIN DEL SCRIPT 01_crear_estructura.sql
-- ============================================================

/