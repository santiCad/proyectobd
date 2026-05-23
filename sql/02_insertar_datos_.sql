-- ============================================================
-- SCRIPT DML: Datos de Prueba
-- Archivo   : 02_insertar_datos.sql
-- Sistema   : Plataforma de Gestion de Cursos Online
-- Autores   : Nicolas Jimenez C. | Johan Santiago Cadena G.
--             Jhon Sebastian Mejia A. | Alejandro Rodriguez M.
-- Materia   : Bases de Datos 2026-10
-- ============================================================

-- ============================================================
-- LIMPIEZA PREVIA (en orden inverso de FK)
-- ============================================================
DELETE FROM CERTIFICADO;
DELETE FROM PROGRESO_LECCION;
DELETE FROM PUBLICACION_FORO;
DELETE FROM FORO;
DELETE FROM RESULTADO_EVALUACION;
DELETE FROM EVALUACION;
DELETE FROM LECCION;
DELETE FROM MODULO;
DELETE FROM INSCRIPCION;
DELETE FROM CURSO;
DELETE FROM INSTRUCTOR;
DELETE FROM ADMINISTRADOR;
DELETE FROM ESTUDIANTE;
DELETE FROM USUARIO;

-- Reiniciar secuencias para que los IDs arranquen desde 1
DROP SEQUENCE SEQ_USUARIO;     CREATE SEQUENCE SEQ_USUARIO     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_ADMIN;       CREATE SEQUENCE SEQ_ADMIN       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_INSTRUCTOR;  CREATE SEQUENCE SEQ_INSTRUCTOR  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_CURSO;       CREATE SEQUENCE SEQ_CURSO       START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_INSCRIPCION; CREATE SEQUENCE SEQ_INSCRIPCION START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_MODULO;      CREATE SEQUENCE SEQ_MODULO      START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_LECCION;     CREATE SEQUENCE SEQ_LECCION     START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_EVALUACION;  CREATE SEQUENCE SEQ_EVALUACION  START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_RESULTADO;   CREATE SEQUENCE SEQ_RESULTADO   START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_FORO;        CREATE SEQUENCE SEQ_FORO        START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_PUBLICACION; CREATE SEQUENCE SEQ_PUBLICACION START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_PROGRESO;    CREATE SEQUENCE SEQ_PROGRESO    START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
DROP SEQUENCE SEQ_CERTIFICADO; CREATE SEQUENCE SEQ_CERTIFICADO START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

COMMIT;

-- ============================================================
-- SECCION 1: USUARIOS (tabla padre)
-- 60 usuarios: 5 administradores, 10 instructores, 45 estudiantes
-- IDs resultantes:
--   Administradores : 1-5
--   Instructores    : 6-15
--   Estudiantes     : 16-60
-- ============================================================

-- Administradores (ids 1-5)
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Laura Ospina Reyes',    'laura.ospina@educloud.co',    'lauraospina',    'hash_pass_001', 'administrador', 1, DATE '2023-01-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Miguel Torres Lara',    'miguel.torres@educloud.co',   'migueltorres',   'hash_pass_002', 'administrador', 1, DATE '2023-01-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Patricia Vega Suarez',  'patricia.vega@educloud.co',   'patriciavega',   'hash_pass_003', 'administrador', 1, DATE '2023-02-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Roberto Gomez Pena',    'roberto.gomez@educloud.co',   'robertogomez',   'hash_pass_004', 'administrador', 0, DATE '2023-02-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Sandra Mejia Ruiz',     'sandra.mejia@educloud.co',    'sandramejia',    'hash_pass_005', 'administrador', 1, DATE '2023-03-05');

-- Instructores (ids 6-15)
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Carlos Andres Nieto',   'c.nieto@instructor.co',       'carlosnieto',    'hash_pass_006', 'instructor', 1, DATE '2023-03-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Diana Marcela Rios',    'd.rios@instructor.co',        'dianaarios',     'hash_pass_007', 'instructor', 1, DATE '2023-03-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Esteban Vargas Cruz',   'e.vargas@instructor.co',      'estebanvargas',  'hash_pass_008', 'instructor', 1, DATE '2023-04-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Fernanda Castro Gil',   'f.castro@instructor.co',      'fernandacastro', 'hash_pass_009', 'instructor', 1, DATE '2023-04-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'German Salcedo Mora',   'g.salcedo@instructor.co',     'germansalcedo',  'hash_pass_010', 'instructor', 1, DATE '2023-05-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Hilda Bermudez Ortiz',  'h.bermudez@instructor.co',    'hildabermudez',  'hash_pass_011', 'instructor', 1, DATE '2023-05-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Ivan Pedroza Luna',     'i.pedroza@instructor.co',     'ivanpedroza',    'hash_pass_012', 'instructor', 1, DATE '2023-06-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Julia Sanchez Pinto',   'j.sanchez@instructor.co',     'juliasanchez',   'hash_pass_013', 'instructor', 0, DATE '2023-06-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Kevin Ramirez Aguilar', 'k.ramirez@instructor.co',     'kevinramirez',   'hash_pass_014', 'instructor', 1, DATE '2023-07-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Lucia Pardo Montoya',   'l.pardo@instructor.co',       'luciapardo',     'hash_pass_015', 'instructor', 1, DATE '2023-07-20');

-- Estudiantes (ids 16-60)
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Andres Felipe Mora',    'andres.mora@gmail.com',       'andresfmora',    'hash_pass_016', 'estudiante', 1, DATE '2023-08-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Beatriz Soto Vargas',   'beatriz.soto@hotmail.com',    'beatrizsoto',    'hash_pass_017', 'estudiante', 1, DATE '2023-08-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Camilo Duran Arce',     'camilo.duran@gmail.com',      'camiloduran',    'hash_pass_018', 'estudiante', 1, DATE '2023-08-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Daniela Lozano Perez',  'daniela.lozano@yahoo.com',    'danielalozano',  'hash_pass_019', 'estudiante', 1, DATE '2023-08-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Eduardo Cano Blanco',   'eduardo.cano@gmail.com',      'eduardocano',    'hash_pass_020', 'estudiante', 1, DATE '2023-08-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Francy Guzman Arias',   'francy.guzman@outlook.com',   'francyguzman',   'hash_pass_021', 'estudiante', 1, DATE '2023-09-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Gustavo Pineda Torres', 'gustavo.pineda@gmail.com',    'gustavopineda',  'hash_pass_022', 'estudiante', 1, DATE '2023-09-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Helena Romero Vidal',   'helena.romero@gmail.com',     'helenaromero',   'hash_pass_023', 'estudiante', 0, DATE '2023-09-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Isaac Chavez Paredes',  'isaac.chavez@yahoo.com',      'isaacchavez',    'hash_pass_024', 'estudiante', 1, DATE '2023-09-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Jimena Cardenas Ruiz',  'jimena.cardenas@gmail.com',   'jimenacardenas', 'hash_pass_025', 'estudiante', 1, DATE '2023-09-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Karol Mendez Fuentes',  'karol.mendez@hotmail.com',    'karolmendez',    'hash_pass_026', 'estudiante', 1, DATE '2023-10-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Leonardo Avila Saenz',  'leo.avila@gmail.com',         'leoavila',       'hash_pass_027', 'estudiante', 1, DATE '2023-10-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Monica Bravo Delgado',  'monica.bravo@outlook.com',    'monicabravo',    'hash_pass_028', 'estudiante', 1, DATE '2023-10-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Nicolas Restrepo Cano', 'nicolas.restrepo@gmail.com',  'nicolasrest',    'hash_pass_029', 'estudiante', 1, DATE '2023-10-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Olga Acosta Mendoza',   'olga.acosta@yahoo.com',       'olgaacosta',     'hash_pass_030', 'estudiante', 1, DATE '2023-10-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Pablo Herrera Arango',  'pablo.herrera@gmail.com',     'pabloherrera',   'hash_pass_031', 'estudiante', 1, DATE '2023-11-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Quiroga Isaza Felipe',  'quiroga.isaza@gmail.com',     'quirogaisaza',   'hash_pass_032', 'estudiante', 1, DATE '2023-11-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Rosa Beltran Jimenez',  'rosa.beltran@hotmail.com',    'rosabeltran',    'hash_pass_033', 'estudiante', 1, DATE '2023-11-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Santiago Ospina Gil',   'santiago.ospina@gmail.com',   'santiagoospina', 'hash_pass_034', 'estudiante', 1, DATE '2023-11-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Tatiana Velez Molina',  'tatiana.velez@outlook.com',   'tatianavelez',   'hash_pass_035', 'estudiante', 1, DATE '2023-11-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Uriel Zapata Ceron',    'uriel.zapata@gmail.com',      'urielzapata',    'hash_pass_036', 'estudiante', 1, DATE '2023-12-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Valeria Munoz Largo',   'valeria.munoz@gmail.com',     'valeriamunoz',   'hash_pass_037', 'estudiante', 1, DATE '2023-12-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'William Pena Guerrero', 'william.pena@yahoo.com',      'williampena',    'hash_pass_038', 'estudiante', 0, DATE '2023-12-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Ximena Lagos Soto',     'ximena.lagos@gmail.com',      'ximenallagos',   'hash_pass_039', 'estudiante', 1, DATE '2023-12-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Yulieth Castano Alba',  'yulieth.castano@hotmail.com', 'yuliethcastano', 'hash_pass_040', 'estudiante', 1, DATE '2023-12-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Zulema Arredondo Paz',  'zulema.arredondo@gmail.com',  'zulema_arred',   'hash_pass_041', 'estudiante', 1, DATE '2024-01-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Alejandro Forero Ruiz', 'alex.forero@gmail.com',       'alexforero',     'hash_pass_042', 'estudiante', 1, DATE '2024-01-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Brigitte Meza Correa',  'brigitte.meza@outlook.com',   'brigittemeza',   'hash_pass_043', 'estudiante', 1, DATE '2024-01-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Cesar Trujillo Nino',   'cesar.trujillo@gmail.com',    'cesartrujillo',  'hash_pass_044', 'estudiante', 1, DATE '2024-01-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Dario Galvis Segura',   'dario.galvis@yahoo.com',      'dariogalvis',    'hash_pass_045', 'estudiante', 1, DATE '2024-02-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Elena Patino Torres',   'elena.patino@gmail.com',      'elenapatino',    'hash_pass_046', 'estudiante', 1, DATE '2024-02-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Felipe Suaza Mora',     'felipe.suaza@hotmail.com',    'felipesuaza',    'hash_pass_047', 'estudiante', 1, DATE '2024-02-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Gloria Rincon Amaya',   'gloria.rincon@gmail.com',     'gloriarincon',   'hash_pass_048', 'estudiante', 0, DATE '2024-02-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Hugo Celis Barrios',    'hugo.celis@gmail.com',        'hugocelis',      'hash_pass_049', 'estudiante', 1, DATE '2024-02-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Ingrid Varela Cuesta',  'ingrid.varela@outlook.com',   'ingridvarela',   'hash_pass_050', 'estudiante', 1, DATE '2024-03-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Jorge Eliecer Rubio',   'jorge.rubio@gmail.com',       'jorgerubio',     'hash_pass_051', 'estudiante', 1, DATE '2024-03-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Karen Solano Bedoya',   'karen.solano@gmail.com',      'karensolano',    'hash_pass_052', 'estudiante', 1, DATE '2024-03-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Luis Enrique Oviedo',   'luis.oviedo@yahoo.com',       'luisoviedo',     'hash_pass_053', 'estudiante', 1, DATE '2024-03-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Martha Lucia Daza',     'martha.daza@gmail.com',       'marthadaza',     'hash_pass_054', 'estudiante', 1, DATE '2024-03-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Nelson David Prieto',   'nelson.prieto@hotmail.com',   'nelsonprieto',   'hash_pass_055', 'estudiante', 1, DATE '2024-04-01');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Oriana Cadavid Ossa',   'oriana.cadavid@gmail.com',    'orianacadavid',  'hash_pass_056', 'estudiante', 1, DATE '2024-04-05');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Pedro Alonso Marin',    'pedro.marin@outlook.com',     'pedromarin',     'hash_pass_057', 'estudiante', 1, DATE '2024-04-10');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Rebeca Leal Piza',      'rebeca.leal@gmail.com',       'rebecaleal',     'hash_pass_058', 'estudiante', 1, DATE '2024-04-15');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Samuel Cano Montiel',   'samuel.cano@gmail.com',       'samuelcano',     'hash_pass_059', 'estudiante', 1, DATE '2024-04-20');
INSERT INTO USUARIO VALUES (SEQ_USUARIO.NEXTVAL, 'Teresa Arango Franco',  'teresa.arango@yahoo.com',     'teresaarango',   'hash_pass_060', 'estudiante', 1, DATE '2024-05-01');

COMMIT;

-- ============================================================
-- SECCION 2: ADMINISTRADORES (id_usuario 1-5)
-- ============================================================

INSERT INTO ADMINISTRADOR VALUES (SEQ_ADMIN.NEXTVAL, 1, 'Laura Ospina',   'superadmin');
INSERT INTO ADMINISTRADOR VALUES (SEQ_ADMIN.NEXTVAL, 2, 'Miguel Torres',  'superadmin');
INSERT INTO ADMINISTRADOR VALUES (SEQ_ADMIN.NEXTVAL, 3, 'Patricia Vega',  'intermedio');
INSERT INTO ADMINISTRADOR VALUES (SEQ_ADMIN.NEXTVAL, 4, 'Roberto Gomez',  'basico');
INSERT INTO ADMINISTRADOR VALUES (SEQ_ADMIN.NEXTVAL, 5, 'Sandra Mejia',   'intermedio');

COMMIT;

-- ============================================================
-- SECCION 3: INSTRUCTORES (id_usuario 6-15)
-- id_instructor resultante: 1-10 (SEQ_INSTRUCTOR arranca en 1)
-- En CURSO se referencia id_instructor (1-10), NO id_usuario
-- ============================================================

INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 6,  'Carlos Nieto',   'Desarrollo Web Full Stack',  'Ingeniero de sistemas con 10 anos de experiencia en desarrollo web. Ha trabajado en startups y multinacionales. Apasionado por la educacion en linea.', 4.85);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 7,  'Diana Rios',     'Ciencia de Datos e IA',      'Matematica y estadistica con MSc en Machine Learning. Investigadora y docente universitaria con publicaciones en revistas indexadas.', 4.92);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 8,  'Esteban Vargas', 'Diseno UX/UI',               'Disenador grafico con especializacion en experiencia de usuario. Consultor para marcas reconocidas en Colombia y LATAM.', 4.70);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 9,  'Fernanda Castro','Marketing Digital',           'Especialista en marketing digital, SEO y redes sociales. Mas de 8 anos gestionando campanas para pymes y grandes empresas.', 4.60);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 10, 'German Salcedo', 'Ciberseguridad',             'Experto en seguridad informatica certificado en CEH y CISSP. Consultor de seguridad para entidades financieras y gubernamentales.', 4.75);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 11, 'Hilda Bermudez', 'Gestion de Proyectos',       'PMP certificada con 12 anos liderando proyectos de tecnologia. Instructora oficial de metodologias agiles y PMI.', 4.80);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 12, 'Ivan Pedroza',   'Programacion en Python',     'Desarrollador Python senior especializado en automatizacion y scripting. Contribuidor activo de proyectos open source.', 4.65);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 13, 'Julia Sanchez',  'Finanzas Personales',        'Economista y asesora financiera certificada. Ayuda a personas a manejar sus finanzas y alcanzar independencia economica.', NULL);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 14, 'Kevin Ramirez',  'Desarrollo Movil',           'Desarrollador Android e iOS con mas de 6 anos de experiencia. Ha publicado 12 aplicaciones en tiendas oficiales.', 4.55);
INSERT INTO INSTRUCTOR VALUES (SEQ_INSTRUCTOR.NEXTVAL, 15, 'Lucia Pardo',    'Fotografia y Video',         'Fotografa profesional y editora de video. Ha trabajado para revistas, marcas y eventos internacionales.', 4.78);

COMMIT;

-- ============================================================
-- SECCION 4: ESTUDIANTES (id_usuario 16-60)
-- ============================================================

INSERT INTO ESTUDIANTE VALUES (16,  'Programacion, Diseno',       DATE '1998-04-12', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (17,  'Marketing, Negocios',        DATE '1995-07-22', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (18,  'Programacion, Videojuegos',  DATE '2001-03-05', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (19,  'Diseno, Arte Digital',       DATE '1999-11-18', 'pregrado',    0);
INSERT INTO ESTUDIANTE VALUES (20,  'Ciberseguridad, Redes',      DATE '1997-02-28', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (21,  'IA, Datos, Python',          DATE '2000-06-14', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (22,  'Gestion, Liderazgo',         DATE '1993-09-30', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (23,  'Fotografia, Video',          DATE '2002-01-20', 'bachillerato',1);
INSERT INTO ESTUDIANTE VALUES (24,  'Finanzas, Inversiones',      DATE '1996-08-08', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (25,  'Programacion, Movil',        DATE '2003-05-15', 'bachillerato',0);
INSERT INTO ESTUDIANTE VALUES (26,  'Diseno, UX',                 DATE '1998-12-03', 'tecnico',     1);
INSERT INTO ESTUDIANTE VALUES (27,  'Datos, BI',                  DATE '1994-07-19', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (28,  'Marketing, Redes Sociales',  DATE '2001-10-25', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (29,  'Ciberseguridad',             DATE '1997-04-07', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (30,  'Finanzas, Emprendimiento',   DATE '1992-03-14', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (31,  'Python, Automatizacion',     DATE '1999-08-22', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (32,  'Videojuegos, 3D',            DATE '2002-06-11', 'bachillerato',1);
INSERT INTO ESTUDIANTE VALUES (33,  'Diseno Grafico',             DATE '2000-09-28', 'tecnico',     1);
INSERT INTO ESTUDIANTE VALUES (34,  'Programacion Web',           DATE '1998-01-16', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (35,  'IA, Machine Learning',       DATE '1996-11-04', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (36,  'Fotografia, Edicion',        DATE '2003-07-30', 'bachillerato',1);
INSERT INTO ESTUDIANTE VALUES (37,  'Marketing, SEO',             DATE '1997-05-21', 'pregrado',    0);
INSERT INTO ESTUDIANTE VALUES (38,  'Finanzas Personales',        DATE '1991-02-09', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (39,  'Desarrollo Movil, Flutter',  DATE '2001-12-17', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (40,  'Gestion Proyectos, Agile',   DATE '1995-04-03', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (41,  'Programacion, Backend',      DATE '1999-10-12', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (42,  'Diseno Web, Frontend',       DATE '2002-08-26', 'tecnico',     1);
INSERT INTO ESTUDIANTE VALUES (43,  'Datos, Python, R',           DATE '1996-03-19', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (44,  'Seguridad, Redes',           DATE '1998-06-07', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (45,  'Finanzas, Contabilidad',     DATE '1993-01-25', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (46,  'Programacion, DevOps',       DATE '2000-11-13', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (47,  'Marketing, Contenido',       DATE '2001-07-02', 'tecnico',     1);
INSERT INTO ESTUDIANTE VALUES (48,  'Diseno, Branding',           DATE '1997-09-18', 'pregrado',    0);
INSERT INTO ESTUDIANTE VALUES (49,  'Python, Data Science',       DATE '1995-12-06', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (50,  'Movil, iOS',                 DATE '2003-04-24', 'bachillerato',1);
INSERT INTO ESTUDIANTE VALUES (51,  'Videojuegos, Unity',         DATE '2002-02-11', 'bachillerato',1);
INSERT INTO ESTUDIANTE VALUES (52,  'UX, Investigacion',          DATE '1999-08-29', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (53,  'BI, Power BI',               DATE '1994-05-16', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (54,  'Seguridad, Hacking Etico',   DATE '1997-10-04', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (55,  'Finanzas, Criptomonedas',    DATE '1992-07-22', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (56,  'Fotografia, Drones',         DATE '2001-03-09', 'tecnico',     1);
INSERT INTO ESTUDIANTE VALUES (57,  'Programacion, Java',         DATE '1998-12-27', 'pregrado',    1);
INSERT INTO ESTUDIANTE VALUES (58,  'Diseno, Motion Graphics',    DATE '2000-06-14', 'tecnico',     1);
INSERT INTO ESTUDIANTE VALUES (59,  'Datos, SQL',                 DATE '1996-09-01', 'posgrado',    1);
INSERT INTO ESTUDIANTE VALUES (60,  'Marketing Digital, Ads',     DATE '1993-11-19', 'pregrado',    1);

COMMIT;

-- ============================================================
-- SECCION 5: CURSOS
-- NOTA: id_instructor referencia INSTRUCTOR.id_instructor (1-10)
--       NO USUARIO.id_usuario. SEQ_INSTRUCTOR arranco en 1.
-- ============================================================

INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Desarrollo Web Full Stack con React y Node.js', 299000, 'Programacion',     'publicado', 75, DATE '2023-04-15', 1);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Machine Learning con Python: de Cero a Experto',349000, 'Ciencia de Datos', 'publicado', 80, DATE '2023-05-01', 2);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Diseno UX/UI: Crea Experiencias que Enamoran',  199000, 'Diseno',           'publicado', 70, DATE '2023-06-10', 3);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Marketing Digital 360: Google, Meta y TikTok',  179000, 'Marketing',        'publicado', 65, DATE '2023-07-01', 4);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Hacking Etico y Ciberseguridad Empresarial',    379000, 'Ciberseguridad',   'publicado', 80, DATE '2023-08-20', 5);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Gestion de Proyectos con Scrum y Kanban',       149000, 'Gestion',          'publicado', 70, DATE '2023-09-05', 6);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Python Avanzado: Automatizacion y Scripting',   229000, 'Programacion',     'publicado', 75, DATE '2023-10-01', 7);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Finanzas Personales: Ahorra, Invierte y Crece',  99000, 'Finanzas',         'publicado', 60, DATE '2023-11-15', 8);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Desarrollo de Apps Android e iOS con Flutter',  269000, 'Desarrollo Movil', 'publicado', 75, DATE '2024-01-10', 9);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Fotografia Profesional: Tecnica y Arte',        159000, 'Arte y Creatividad','publicado', 65, DATE '2024-02-01', 10);
-- Cursos NO publicados para probar escenarios
-- NOTA: el trigger impide inscribirse a estos cursos (estado != 'publicado')
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Inteligencia Artificial Generativa (Borrador)', 399000, 'Ciencia de Datos', 'borrador',  85, DATE '2024-03-01', 2);
INSERT INTO CURSO VALUES (SEQ_CURSO.NEXTVAL, 'Diseno 3D para Videojuegos (Archivado)',        189000, 'Diseno',           'archivado', 70, DATE '2023-02-01', 3);

COMMIT;

-- ============================================================
-- SECCION 6: MODULOS
-- id_modulo resultante (SEQ_MODULO arranca en 1):
--   Curso 1: modulos 1-6
--   Curso 2: modulos 7-11
--   Curso 3: modulos 12-16
--   Curso 4: modulos 17-21
--   Curso 5: modulos 22-26
--   Curso 6: modulos 27-31
--   Curso 7: modulos 32-36
--   Curso 8: modulos 37-41
--   Curso 9: modulos 42-46
--   Curso 10: modulos 47-51
-- ============================================================

-- Curso 1: Desarrollo Web Full Stack
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Fundamentos de HTML y CSS',           1, 1);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'JavaScript Moderno (ES6+)',            2, 1);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Frontend con React',                   3, 1);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Backend con Node.js y Express',        4, 1);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Bases de Datos con MongoDB',           5, 1);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Despliegue y DevOps Basico',           6, 1);

-- Curso 2: Machine Learning
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Python para Ciencia de Datos',         1, 2);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Estadistica y Probabilidad',           2, 2);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Aprendizaje Supervisado',              3, 2);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Aprendizaje No Supervisado',           4, 2);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Redes Neuronales y Deep Learning',     5, 2);

-- Curso 3: Diseno UX/UI
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Fundamentos de Diseno',                1, 3);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Investigacion de Usuarios',            2, 3);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Prototipado con Figma',                3, 3);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Diseno Visual e Interfaz',             4, 3);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Pruebas de Usabilidad',                5, 3);

-- Curso 4: Marketing Digital
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Estrategia de Marketing Digital',      1, 4);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'SEO y Posicionamiento Web',            2, 4);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Publicidad en Google Ads',             3, 4);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Redes Sociales y Meta Ads',            4, 4);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Analisis y Metricas Digitales',        5, 4);

-- Curso 5: Ciberseguridad
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Fundamentos de Seguridad Informatica', 1, 5);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Reconocimiento y Escaneo',             2, 5);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Explotacion de Vulnerabilidades',      3, 5);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Seguridad en Aplicaciones Web',        4, 5);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Defensa y Respuesta a Incidentes',     5, 5);

-- Curso 6: Gestion de Proyectos
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Introduccion a la Gestion Agil',       1, 6);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Framework Scrum Completo',             2, 6);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Metodologia Kanban',                   3, 6);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Herramientas: Jira y Trello',          4, 6);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Liderazgo de Equipos Agiles',          5, 6);

-- Curso 7: Python Avanzado
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Python Orientado a Objetos',           1, 7);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Manejo de Archivos y APIs',            2, 7);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Automatizacion con Selenium',          3, 7);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Procesamiento de Datos con Pandas',    4, 7);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Despliegue de Scripts en la Nube',     5, 7);

-- Curso 8: Finanzas Personales
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Presupuesto y Control de Gastos',      1, 8);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Fondo de Emergencia y Ahorro',         2, 8);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Inversion en Fondos y Acciones',       3, 8);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Deudas y Credito Inteligente',         4, 8);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Planificacion Financiera a Largo Plazo',5,8);

-- Curso 9: Flutter
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Introduccion a Dart y Flutter',        1, 9);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Widgets y Layouts',                    2, 9);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Gestion de Estado con Provider',       3, 9);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Integracion con APIs REST',            4, 9);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Publicacion en App Store y Play Store',5, 9);

-- Curso 10: Fotografia
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Fundamentos de la Camara',             1, 10);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Composicion y Luz Natural',            2, 10);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Iluminacion Artificial',               3, 10);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Edicion con Lightroom',                4, 10);
INSERT INTO MODULO VALUES (SEQ_MODULO.NEXTVAL, 'Fotografia de Retrato',                5, 10);

COMMIT;

-- ============================================================
-- SECCION 7: LECCIONES
-- id_leccion resultante (SEQ_LECCION arranca en 1):
--   Modulo 1 (HTML/CSS)     : lecciones 1-5
--   Modulo 2 (JavaScript)   : lecciones 6-10
--   Modulo 3 (React)        : lecciones 11-15
--   Modulo 4 (Node.js)      : lecciones 16-20
--   Modulo 5 (MongoDB)      : lecciones 21-25
--   Modulo 6 (DevOps)       : lecciones 26-30
--   Modulo 7 (Python DS)    : lecciones 31-35
--   Modulo 8 (Estadistica)  : lecciones 36-40
--   Modulo 9 (Supervisado)  : lecciones 41-45
--   Modulo 10 (No Superv.)  : lecciones 46-50
-- ============================================================

-- Modulo 1: HTML y CSS (id_modulo=1)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Estructura de un documento HTML',    'video',   'https://cdn.educloud.co/v/html-01',  18, 1, 1, 1);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Etiquetas semanticas en HTML5',      'video',   'https://cdn.educloud.co/v/html-02',  22, 2, 1, 1);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'CSS: Selectores y Especificidad',    'video',   'https://cdn.educloud.co/v/css-01',   25, 3, 1, 1);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Flexbox y CSS Grid',                 'video',   'https://cdn.educloud.co/v/css-02',   30, 4, 1, 1);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Quiz: HTML y CSS Basico',            'quiz',    NULL,                                 NULL,5, 1, 1);

-- Modulo 2: JavaScript (id_modulo=2)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Variables, Tipos y Operadores',      'video',   'https://cdn.educloud.co/v/js-01',    20, 1, 1, 2);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Funciones y Arrow Functions',        'video',   'https://cdn.educloud.co/v/js-02',    25, 2, 1, 2);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Promesas y Async/Await',             'video',   'https://cdn.educloud.co/v/js-03',    28, 3, 1, 2);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Manipulacion del DOM',               'video',   'https://cdn.educloud.co/v/js-04',    32, 4, 1, 2);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Ejercicio: App de Lista de Tareas',  'recurso', 'https://cdn.educloud.co/r/js-lab01', NULL,5, 0, 2);

-- Modulo 3: React (id_modulo=3)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Componentes y Props',                'video',   'https://cdn.educloud.co/v/react-01', 24, 1, 1, 3);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Estado con useState y useEffect',    'video',   'https://cdn.educloud.co/v/react-02', 30, 2, 1, 3);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'React Router para Navegacion',       'video',   'https://cdn.educloud.co/v/react-03', 22, 3, 1, 3);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Consumo de APIs con Axios',          'video',   'https://cdn.educloud.co/v/react-04', 26, 4, 1, 3);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Lectura: Ecosistema React 2024',     'lectura', 'https://cdn.educloud.co/l/react-eco',NULL, 5, 0, 3);

-- Modulo 4: Node.js (id_modulo=4)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Introduccion a Node.js y NPM',       'video',   'https://cdn.educloud.co/v/node-01',  20, 1, 1, 4);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Creacion de APIs REST con Express',  'video',   'https://cdn.educloud.co/v/node-02',  35, 2, 1, 4);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Middleware y Autenticacion JWT',     'video',   'https://cdn.educloud.co/v/node-03',  30, 3, 1, 4);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Manejo de Errores y Validaciones',   'video',   'https://cdn.educloud.co/v/node-04',  25, 4, 1, 4);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Quiz: APIs REST con Node.js',        'quiz',    NULL,                                 NULL,5, 1, 4);

-- Modulo 5: MongoDB (id_modulo=5)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Bases de Datos NoSQL vs SQL',        'video',   'https://cdn.educloud.co/v/mongo-01', 18, 1, 1, 5);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Modelado de Datos en MongoDB',       'video',   'https://cdn.educloud.co/v/mongo-02', 22, 2, 1, 5);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'CRUD con Mongoose',                  'video',   'https://cdn.educloud.co/v/mongo-03', 28, 3, 1, 5);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Indices y Optimizacion',             'video',   'https://cdn.educloud.co/v/mongo-04', 20, 4, 1, 5);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Proyecto: API completa Full Stack',  'recurso', 'https://cdn.educloud.co/r/fs-proj',  NULL,5, 0, 5);

-- Modulo 6: DevOps (id_modulo=6)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Introduccion a Docker',              'video',   'https://cdn.educloud.co/v/dock-01',  25, 1, 1, 6);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Despliegue en Railway y Render',     'video',   'https://cdn.educloud.co/v/dep-01',   20, 2, 1, 6);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'CI/CD con GitHub Actions',           'video',   'https://cdn.educloud.co/v/cicd-01',  30, 3, 1, 6);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Variables de Entorno y Seguridad',   'lectura', 'https://cdn.educloud.co/l/env-sec',  NULL,4, 1, 6);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Proyecto Final: Despliegue Real',    'recurso', 'https://cdn.educloud.co/r/final-1',  NULL,5, 1, 6);

-- Modulo 7: Python para DS (id_modulo=7)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Instalacion de Anaconda y Jupyter',  'video',   'https://cdn.educloud.co/v/py-ds-01', 15, 1, 1, 7);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'NumPy: Arrays y Operaciones',        'video',   'https://cdn.educloud.co/v/py-ds-02', 25, 2, 1, 7);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Pandas: DataFrames y Series',        'video',   'https://cdn.educloud.co/v/py-ds-03', 35, 3, 1, 7);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Visualizacion con Matplotlib',       'video',   'https://cdn.educloud.co/v/py-ds-04', 28, 4, 1, 7);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Quiz: Herramientas Python DS',       'quiz',    NULL,                                 NULL,5, 1, 7);

-- Modulo 8: Estadistica (id_modulo=8)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Estadistica Descriptiva',            'video',   'https://cdn.educloud.co/v/stat-01',  30, 1, 1, 8);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Distribuciones de Probabilidad',     'video',   'https://cdn.educloud.co/v/stat-02',  35, 2, 1, 8);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Pruebas de Hipotesis',               'video',   'https://cdn.educloud.co/v/stat-03',  40, 3, 1, 8);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Correlacion y Regresion',            'video',   'https://cdn.educloud.co/v/stat-04',  38, 4, 1, 8);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Ejercicio con Dataset Real',         'recurso', 'https://cdn.educloud.co/r/stat-lab', NULL,5, 0, 8);

-- Modulo 9: Aprendizaje Supervisado (id_modulo=9)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Regresion Lineal y Logistica',       'video',   'https://cdn.educloud.co/v/ml-01',    32, 1, 1, 9);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Arboles de Decision y Random Forest','video',   'https://cdn.educloud.co/v/ml-02',    35, 2, 1, 9);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Support Vector Machines',            'video',   'https://cdn.educloud.co/v/ml-03',    30, 3, 1, 9);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Metricas de Evaluacion',             'video',   'https://cdn.educloud.co/v/ml-04',    25, 4, 1, 9);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Proyecto: Clasificador de Spam',     'recurso', 'https://cdn.educloud.co/r/ml-proj',  NULL,5, 0, 9);

-- Modulo 10: Aprendizaje No Supervisado (id_modulo=10)
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Clustering con K-Means',             'video',   'https://cdn.educloud.co/v/unsup-01', 28, 1, 1, 10);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'PCA y Reduccion de Dimensionalidad', 'video',   'https://cdn.educloud.co/v/unsup-02', 32, 2, 1, 10);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Deteccion de Anomalias',             'video',   'https://cdn.educloud.co/v/unsup-03', 25, 3, 1, 10);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Sistemas de Recomendacion',          'video',   'https://cdn.educloud.co/v/unsup-04', 30, 4, 1, 10);
INSERT INTO LECCION VALUES (SEQ_LECCION.NEXTVAL, 'Quiz: Modelos No Supervisados',      'quiz',    NULL,                                 NULL,5, 1, 10);

COMMIT;

-- ============================================================
-- SECCION 8: EVALUACIONES
-- id_eval resultante (SEQ_EVALUACION arranca en 1):
--   Curso 1: evals 1-4   Curso 2: evals 5-8   Curso 3: evals 9-11
--   Curso 4: evals 12-14 Curso 5: evals 15-18 Curso 6: evals 19-21
--   Curso 7: evals 22-24 Curso 8: evals 25-27 Curso 9: evals 28-31
--   Curso 10: evals 32-34
-- ============================================================

-- Curso 1
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Fundamentos HTML/CSS',        60, 'quiz',         30,  1);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: JavaScript Avanzado',         65, 'quiz',         40,  1);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Pagina Web Responsiva',      70, 'tarea',        NULL,1);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Proyecto Full Stack', 75, 'examen_final', NULL,1);
-- Curso 2
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Python y Estadistica',        70, 'quiz',         35,  2);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Analisis Exploratorio',      75, 'tarea',        NULL,2);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Proyecto: Modelo Predictivo',       80, 'proyecto',     NULL,2);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: ML Completo',         80, 'examen_final', 120, 2);
-- Curso 3
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Fundamentos de Diseno',       60, 'quiz',         25,  3);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Prototipo en Figma',         70, 'tarea',        NULL,3);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Case Study UX',       70, 'examen_final', NULL,3);
-- Curso 4
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Estrategia y SEO',            60, 'quiz',         30,  4);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Campana Google Ads',         65, 'tarea',        NULL,4);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Plan Marketing',      65, 'examen_final', 90,  4);
-- Curso 5
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Fundamentos de Seguridad',    70, 'quiz',         40,  5);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Reporte de Vulnerabilidades',75, 'tarea',        NULL,5);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Proyecto: Pentest Etico',           80, 'proyecto',     NULL,5);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Ciberseguridad',      80, 'examen_final', 120, 5);
-- Curso 6
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Scrum y Kanban',              65, 'quiz',         30,  6);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Sprint Planning',            70, 'tarea',        NULL,6);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Gestion Agil',        70, 'examen_final', 90,  6);
-- Curso 7
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: POO en Python',               65, 'quiz',         35,  7);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Script de Automatizacion',   70, 'tarea',        NULL,7);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Python Avanzado',     75, 'examen_final', 90,  7);
-- Curso 8
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Presupuesto y Ahorro',        60, 'quiz',         20,  8);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Plan Financiero Personal',   60, 'tarea',        NULL,8);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Finanzas',            60, 'examen_final', 60,  8);
-- Curso 9
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Dart y Widgets',              65, 'quiz',         30,  9);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: App con Provider',           70, 'tarea',        NULL,9);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Proyecto: App Publicada',           75, 'proyecto',     NULL,9);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Flutter',             75, 'examen_final', 90,  9);
-- Curso 10
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Quiz: Tecnica Fotografica',         60, 'quiz',         25,  10);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Tarea: Portfolio de 10 Fotos',      65, 'tarea',        NULL,10);
INSERT INTO EVALUACION VALUES (SEQ_EVALUACION.NEXTVAL, 'Examen Final: Sesion Fotografica',  65, 'examen_final', NULL,10);

COMMIT;

-- ============================================================
-- SECCION 9: INSCRIPCIONES
-- COMPATIBLE CON TRIGGER trg_validar_inscripcion:
--   - Solo id_usuario con rol 'estudiante' (16-60)
--   - Solo id_curso con estado 'publicado' (1-10)
--   - El progreso nunca disminuye entre filas del mismo usuario/curso
-- ============================================================

INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 16, 1,  DATE '2023-08-05', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 16, 2,  DATE '2023-08-10',  65.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 17, 4,  DATE '2023-08-10', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 17, 6,  DATE '2023-08-20',  80.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 18, 1,  DATE '2023-08-12',  40.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 18, 7,  DATE '2023-09-01',  15.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 19, 3,  DATE '2023-08-18',  90.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 20, 5,  DATE '2023-08-22', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 21, 2,  DATE '2023-09-05', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 21, 7,  DATE '2023-09-10',  55.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 22, 6,  DATE '2023-09-10', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 22, 4,  DATE '2023-09-15',  30.00, 'abandonado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 23, 10, DATE '2023-09-12',  70.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 24, 8,  DATE '2023-09-18', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 25, 9,  DATE '2023-09-22',  20.00, 'abandonado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 26, 3,  DATE '2023-10-01',  85.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 26, 8,  DATE '2023-10-05',  50.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 27, 2,  DATE '2023-10-05', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 27, 7,  DATE '2023-10-10',  75.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 28, 4,  DATE '2023-10-10',  60.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 29, 5,  DATE '2023-10-15',  45.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 30, 8,  DATE '2023-10-18', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 31, 1,  DATE '2023-11-01',  55.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 31, 7,  DATE '2023-11-05',  35.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 32, 1,  DATE '2023-11-05',   5.00, 'abandonado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 33, 3,  DATE '2023-11-10',  95.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 34, 1,  DATE '2023-11-12', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 35, 2,  DATE '2023-11-15',  88.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 36, 10, DATE '2023-11-18',  40.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 37, 4,  DATE '2023-12-01',  70.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 38, 8,  DATE '2023-12-05',  60.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 39, 9,  DATE '2023-12-08', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 40, 6,  DATE '2023-12-10',  80.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 41, 1,  DATE '2023-12-12',  50.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 42, 3,  DATE '2023-12-15',  25.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 43, 2,  DATE '2023-12-18',  90.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 44, 5,  DATE '2024-01-05',  30.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 45, 8,  DATE '2024-01-08', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 46, 1,  DATE '2024-01-10',  65.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 47, 4,  DATE '2024-01-12',  45.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 48, 3,  DATE '2024-01-15',  10.00, 'abandonado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 49, 2,  DATE '2024-01-18', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 50, 9,  DATE '2024-02-01',  55.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 51, 1,  DATE '2024-02-03',  20.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 52, 3,  DATE '2024-02-05',  75.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 53, 2,  DATE '2024-02-08',  95.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 54, 5,  DATE '2024-02-10',  60.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 55, 8,  DATE '2024-02-12',  85.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 56, 10, DATE '2024-02-15',  35.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 57, 1,  DATE '2024-02-18', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 58, 3,  DATE '2024-03-01',  15.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 59, 2,  DATE '2024-03-05', 100.00, 'completado');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 60, 4,  DATE '2024-03-08',  50.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 41, 5,  DATE '2024-04-01',   0.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 42, 7,  DATE '2024-04-02',   0.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 43, 6,  DATE '2024-04-03',   0.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 44, 10, DATE '2024-04-05',   0.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 45, 9,  DATE '2024-04-08',   0.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 46, 4,  DATE '2024-04-10',   0.00, 'activo');
INSERT INTO INSCRIPCION VALUES (SEQ_INSCRIPCION.NEXTVAL, 47, 6,  DATE '2024-04-12',   0.00, 'activo');

COMMIT;

-- ============================================================
-- SECCION 10: RESULTADOS DE EVALUACION
-- Los id_eval referenciados corresponden a la tabla de mapeo:
--   Curso 1: 1-4 | Curso 2: 5-8 | Curso 3: 9-11 | Curso 4: 12-14
--   Curso 5: 15-18 | Curso 6: 19-21 | Curso 7: 22-24 | Curso 8: 25-27
--   Curso 9: 28-31 | Curso 10: 32-34
-- ============================================================

-- Usuario 16 - Curso 1 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  1, 16, 82.00, DATE '2023-09-01', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  2, 16, 78.00, DATE '2023-09-15', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  3, 16, 90.00, DATE '2023-10-01', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  4, 16, 85.50, DATE '2023-10-20', 1);
-- Usuario 20 - Curso 5 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 15, 20, 88.00, DATE '2023-10-10', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 16, 20, 75.00, DATE '2023-10-25', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 17, 20, 91.00, DATE '2023-11-05', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 18, 20, 83.00, DATE '2023-11-20', 1);
-- Usuario 21 - Curso 2 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  5, 21, 91.00, DATE '2023-10-01', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  6, 21, 85.00, DATE '2023-10-15', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  7, 21, 88.50, DATE '2023-11-01', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  8, 21, 92.00, DATE '2023-11-15', 1);
-- Usuario 22 - Curso 6 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 19, 22, 77.00, DATE '2023-10-20', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 20, 22, 81.00, DATE '2023-11-10', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 21, 22, 79.00, DATE '2023-11-25', 1);
-- Usuario 24 - Curso 8 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 25, 24, 95.00, DATE '2023-11-01', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 26, 24, 88.00, DATE '2023-11-15', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 27, 24, 91.00, DATE '2023-11-28', 1);
-- Usuario 27 - Curso 2 (completado, incluye intento reprobado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  5, 27, 74.00, DATE '2023-11-05', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  6, 27, 69.00, DATE '2023-11-20', 0);  -- reprobado
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  6, 27, 78.00, DATE '2023-12-01', 1);  -- segundo intento aprobado
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  7, 27, 82.00, DATE '2023-12-10', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  8, 27, 85.00, DATE '2023-12-20', 1);
-- Usuario 30 - Curso 8 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 25, 30, 92.00, DATE '2023-11-20', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 26, 30, 87.00, DATE '2023-12-05', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 27, 30, 94.00, DATE '2023-12-18', 1);
-- Usuario 34 - Curso 1 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  1, 34, 88.00, DATE '2023-12-05', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  2, 34, 76.00, DATE '2023-12-15', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  3, 34, 83.00, DATE '2023-12-28', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  4, 34, 80.00, DATE '2024-01-10', 1);
-- Usuario 39 - Curso 9 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 28, 39, 80.00, DATE '2024-01-20', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 29, 39, 85.00, DATE '2024-02-05', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 30, 39, 90.00, DATE '2024-02-20', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 31, 39, 78.00, DATE '2024-03-05', 1);
-- Usuario 45 - Curso 8 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 25, 45, 98.00, DATE '2024-02-01', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 26, 45, 95.00, DATE '2024-02-15', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 27, 45, 97.00, DATE '2024-02-28', 1);
-- Usuario 49 - Curso 2 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  5, 49, 89.00, DATE '2024-02-05', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  6, 49, 84.00, DATE '2024-02-20', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  7, 49, 91.00, DATE '2024-03-05', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  8, 49, 93.00, DATE '2024-03-18', 1);
-- Usuario 57 - Curso 1 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  1, 57, 77.00, DATE '2024-03-01', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  2, 57, 72.00, DATE '2024-03-15', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  3, 57, 80.00, DATE '2024-03-28', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  4, 57, 76.50, DATE '2024-04-10', 1);
-- Usuario 59 - Curso 2 (completado)
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  5, 59, 95.00, DATE '2024-03-20', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  6, 59, 88.00, DATE '2024-04-02', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  7, 59, 92.00, DATE '2024-04-15', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  8, 59, 96.00, DATE '2024-04-25', 1);
-- Intentos reprobados para variedad
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL,  9, 26, 55.00, DATE '2023-12-10', 0);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 12, 28, 58.00, DATE '2024-01-20', 0);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 19, 40, 62.00, DATE '2024-01-25', 0);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 22, 31, 71.00, DATE '2024-02-20', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 25, 38, 88.00, DATE '2024-02-25', 1);
INSERT INTO RESULTADO_EVALUACION VALUES (SEQ_RESULTADO.NEXTVAL, 28, 50, 66.00, DATE '2024-03-10', 0);

COMMIT;

-- ============================================================
-- SECCION 11: FOROS (uno por curso publicado)
-- id_foro resultante: 1-10 (uno por cada curso publicado)
-- ============================================================

INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Desarrollo Web Full Stack',    'Resuelve dudas sobre HTML, CSS, JavaScript, React y Node.js.',         1);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Machine Learning con Python',  'Discusion sobre algoritmos, datasets y proyectos de ML.',              2);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Diseno UX/UI',                 'Comparte tus prototipos y recibe retroalimentacion de la comunidad.',  3);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Marketing Digital 360',        'Estrategias, herramientas y casos de exito en marketing digital.',      4);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Ciberseguridad',               'Discusiones tecnicas sobre seguridad, CTFs y buenas practicas.',       5);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Gestion de Proyectos Agiles',  'Todo sobre Scrum, Kanban y liderazgo de equipos.',                     6);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Python Avanzado',              'Comparte scripts, optimizaciones y proyectos de automatizacion.',      7);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Finanzas Personales',          'Consejos, estrategias y preguntas sobre manejo del dinero.',           8);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Desarrollo Movil con Flutter', 'Dudas sobre Dart, widgets y publicacion de apps.',                     9);
INSERT INTO FORO VALUES (SEQ_FORO.NEXTVAL, 'Foro: Fotografia Profesional',       'Comparte tus fotos y recibe critica constructiva.',                    10);

COMMIT;

-- ============================================================
-- SECCION 12: PUBLICACIONES EN FORO
-- ESTRATEGIA: primero todas las raices (id_pub_padre NULL),
-- luego las respuestas usando subconsulta para obtener el
-- id_publicacion real en lugar de hardcodear numeros.
-- ============================================================

-- PASO 1: Publicaciones raiz (id_pub_padre = NULL)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 1, 16, 'Hola a todos, tengo dudas con Flexbox. No entiendo la diferencia entre justify-content y align-items. Alguien puede explicar?',           DATE '2023-09-05', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 1, 31, 'Tengo un problema con CORS en mi API de Node.js. Al conectar con React me da error. Que hago?',                                            DATE '2023-11-10', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 2, 21, 'Alguien puede recomendar un dataset bueno para practicar regresion logistica? Prefiero algo relacionado con salud.',                        DATE '2023-10-10', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 2, 43, 'Que diferencia hay entre overfitting y underfitting? Llevo dos semanas y aun no lo tengo claro.',                                          DATE '2023-12-05', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 3, 19, 'Comparto mi primer prototipo de app de delivery hecho en Figma. Critiquen sin piedad!',                                                     DATE '2023-10-15', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 4, 17, 'Que herramienta es mejor para hacer keyword research: SEMrush o Ahrefs? Cuales han usado?',                                                DATE '2023-11-05', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 4, 60, 'Les comparto mi caso: aumente el trafico organico de un cliente en 180% en 6 meses solo con SEO. Las palabras clave de cola larga son el secreto.', DATE '2023-12-10', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 5, 20, 'Alguien esta preparando la certificacion CEH? Busco grupo de estudio.',                                                                      DATE '2023-11-20', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 5, 54, 'Que recursos recomiendan para practicar hacking etico de forma legal?',                                                                      DATE '2024-01-10', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 6, 22, 'En mi empresa quieren implementar Scrum pero el equipo es de 15 personas. Es demasiado grande para Scrum?',                                 DATE '2023-12-01', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 7, 31, 'Como optimizo un script que procesa un CSV de 2 millones de filas? Con pandas se me cuelga el computador.',                                 DATE '2024-01-15', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 8, 24, 'A que porcentaje del salario deberia destinar al ahorro si gano el minimo? Es posible ahorrar con ingresos bajos?',                         DATE '2023-11-25', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 9, 39, 'Me salio un error: setState called during build. Ya revise el codigo y no encuentro el problema. Alguien ha visto esto?',                   DATE '2024-02-10', NULL);
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 10,23, 'Que configuracion recomiendan para fotografia de retrato en exteriores con luz natural?',                                                    DATE '2024-02-20', NULL);

COMMIT;

-- PASO 2: Respuestas usando subconsulta para obtener id real del padre
-- Respuestas al hilo Flexbox (foro 1, usuario 16, fecha 2023-09-05)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 1, 18,
    'Claro! justify-content controla el eje principal (horizontal por defecto) y align-items el eje cruzado (vertical). Revisa el modulo 1 que lo explica muy bien.',
    DATE '2023-09-06',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=1 AND id_usuario=16 AND fecha_publicacion=DATE '2023-09-05'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 1, 34,
    'Para practicar Flexbox te recomiendo el juego Flexbox Froggy, aprendi mucho con eso.',
    DATE '2023-09-06',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=1 AND id_usuario=16 AND fecha_publicacion=DATE '2023-09-05'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 1, 16,
    'Gracias! El juego me ayudo muchisimo, ya lo entendi.',
    DATE '2023-09-07',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=1 AND id_usuario=16 AND fecha_publicacion=DATE '2023-09-05'));

-- Respuestas al hilo CORS (foro 1, usuario 31, fecha 2023-11-10)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 1, 41,
    'Instala el paquete cors con npm y agrega app.use(cors()) en tu servidor Express antes de las rutas. Eso resuelve el problema basico.',
    DATE '2023-11-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=1 AND id_usuario=31 AND fecha_publicacion=DATE '2023-11-10'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 1, 46,
    'Tambien puedes configurar cors con opciones para especificar el origen permitido, eso es mas seguro para produccion.',
    DATE '2023-11-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=1 AND id_usuario=31 AND fecha_publicacion=DATE '2023-11-10'));

-- Respuestas al hilo dataset ML (foro 2, usuario 21, fecha 2023-10-10)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 2, 27,
    'El dataset de diabetes de Pima Indians en Kaggle es excelente para empezar. Tiene buena documentacion y es clasico en los cursos de ML.',
    DATE '2023-10-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=2 AND id_usuario=21 AND fecha_publicacion=DATE '2023-10-10'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 2, 35,
    'Tambien esta el Heart Disease de UCI. Personalmente lo prefiero porque tiene mas features para explorar.',
    DATE '2023-10-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=2 AND id_usuario=21 AND fecha_publicacion=DATE '2023-10-10'));

-- Respuestas al hilo overfitting (foro 2, usuario 43, fecha 2023-12-05)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 2, 49,
    'Overfitting es cuando el modelo memoriza los datos de entrenamiento pero falla con datos nuevos. Underfitting es cuando ni siquiera aprende bien los datos de entrenamiento.',
    DATE '2023-12-06',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=2 AND id_usuario=43 AND fecha_publicacion=DATE '2023-12-05'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 2, 53,
    'Una forma simple: si el accuracy de entrenamiento es muy alto y el de validacion muy bajo, es overfitting. Si ambos son bajos, es underfitting.',
    DATE '2023-12-06',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=2 AND id_usuario=43 AND fecha_publicacion=DATE '2023-12-05'));

-- Respuestas al hilo prototipo Figma (foro 3, usuario 19, fecha 2023-10-15)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 3, 26,
    'Muy buen trabajo para ser el primero! La navegacion es intuitiva. Sugerencia: aumentar el contraste en los botones secundarios.',
    DATE '2023-10-16',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=3 AND id_usuario=19 AND fecha_publicacion=DATE '2023-10-15'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 3, 52,
    'El flujo de checkout tiene demasiados pasos. Intenta reducir a 3 pantallas: carrito, datos de pago y confirmacion.',
    DATE '2023-10-16',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=3 AND id_usuario=19 AND fecha_publicacion=DATE '2023-10-15'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 3, 19,
    'Gracias por el feedback! Ya hice las correcciones de contraste. Para el checkout voy a redisenar el flujo esta semana.',
    DATE '2023-10-17',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=3 AND id_usuario=19 AND fecha_publicacion=DATE '2023-10-15'));

-- Respuestas al hilo SEMrush (foro 4, usuario 17, fecha 2023-11-05)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 4, 28,
    'Yo uso SEMrush y me parece excelente. La base de datos de palabras clave es enorme y el analisis de competencia es muy detallado.',
    DATE '2023-11-06',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=4 AND id_usuario=17 AND fecha_publicacion=DATE '2023-11-05'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 4, 37,
    'Ambas son excelentes. Si empiezas, Google Keyword Planner es gratis y da buenos insights. SEMrush vale mas la pena cuando ya tienes presupuesto.',
    DATE '2023-11-06',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=4 AND id_usuario=17 AND fecha_publicacion=DATE '2023-11-05'));

-- Respuesta al hilo trafico organico (foro 4, usuario 60, fecha 2023-12-10)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 4, 17,
    'Impresionante! Que tipo de contenido crearon? Solo articulos de blog o usaron otras estrategias?',
    DATE '2023-12-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=4 AND id_usuario=60 AND fecha_publicacion=DATE '2023-12-10'));

-- Respuestas al hilo CEH (foro 5, usuario 20, fecha 2023-11-20)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 5, 29,
    'Yo tambien quiero! Tengo los materiales oficiales. Podemos organizar sesiones virtuales los sabados.',
    DATE '2023-11-21',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=5 AND id_usuario=20 AND fecha_publicacion=DATE '2023-11-20'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 5, 44,
    'Me uno! Estoy en el modulo 3 del curso y la base que da es bastante solida para el CEH.',
    DATE '2023-11-21',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=5 AND id_usuario=20 AND fecha_publicacion=DATE '2023-11-20'));

-- Respuesta al hilo hacking etico (foro 5, usuario 54, fecha 2024-01-10)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 5, 20,
    'TryHackMe y HackTheBox son los mejores para practicar en entornos controlados. TryHackMe es mas amigable para principiantes.',
    DATE '2024-01-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=5 AND id_usuario=54 AND fecha_publicacion=DATE '2024-01-10'));

-- Respuestas al hilo Scrum (foro 6, usuario 22, fecha 2023-12-01)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 6, 40,
    'La guia Scrum recomienda equipos de 3 a 9 personas. Con 15 lo ideal es dividir en 2 equipos y aplicar Scrum of Scrums para coordinacion.',
    DATE '2023-12-02',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=6 AND id_usuario=22 AND fecha_publicacion=DATE '2023-12-01'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 6, 22,
    'Tiene mucho sentido. Voy a proponer esa estructura. Gracias!',
    DATE '2023-12-02',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=6 AND id_usuario=22 AND fecha_publicacion=DATE '2023-12-01'));

-- Respuestas al hilo CSV grande (foro 7, usuario 31, fecha 2024-01-15)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 7, 41,
    'Usa el parametro chunksize en pd.read_csv() para procesar el archivo en bloques. Asi no cargas todo en memoria de una vez.',
    DATE '2024-01-16',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=7 AND id_usuario=31 AND fecha_publicacion=DATE '2024-01-15'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 7, 21,
    'Tambien puedes probar Polars en lugar de Pandas. Es significativamente mas rapido para datasets grandes.',
    DATE '2024-01-16',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=7 AND id_usuario=31 AND fecha_publicacion=DATE '2024-01-15'));

-- Respuestas al hilo ahorro (foro 8, usuario 24, fecha 2023-11-25)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 8, 30,
    'La regla 50-30-20 sugiere 20% al ahorro, pero con ingresos bajos es un reto. Puedes empezar con el 5% e ir aumentando gradualmente.',
    DATE '2023-11-26',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=8 AND id_usuario=24 AND fecha_publicacion=DATE '2023-11-25'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 8, 38,
    'Lo mas importante es el habito, no el monto. Automatiza una transferencia el dia que te pagan, aunque sea pequena.',
    DATE '2023-11-26',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=8 AND id_usuario=24 AND fecha_publicacion=DATE '2023-11-25'));

-- Respuestas al hilo setState (foro 9, usuario 39, fecha 2024-02-10)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 9, 50,
    'Ese error ocurre cuando llamas setState dentro del metodo build. Mueve la llamada a initState o a un callback de usuario.',
    DATE '2024-02-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=9 AND id_usuario=39 AND fecha_publicacion=DATE '2024-02-10'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 9, 39,
    'Era exactamente eso! Tenia una llamada en el build. Ya funciona, gracias.',
    DATE '2024-02-11',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=9 AND id_usuario=39 AND fecha_publicacion=DATE '2024-02-10'));

-- Respuestas al hilo fotografia retrato (foro 10, usuario 23, fecha 2024-02-20)
INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 10, 36,
    'Para retrato en exterior: apertura abierta (f/1.8 - f/2.8) para bokeh, ISO lo mas bajo posible y velocidad de obturacion al menos 1/focal usada.',
    DATE '2024-02-21',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=10 AND id_usuario=23 AND fecha_publicacion=DATE '2024-02-20'));

INSERT INTO PUBLICACION_FORO VALUES (SEQ_PUBLICACION.NEXTVAL, 10, 56,
    'La hora dorada (1 hora despues del amanecer y antes del atardecer) da la mejor luz para retratos. La luz es suave y calienta el tono de piel.',
    DATE '2024-02-21',
    (SELECT id_publicacion FROM PUBLICACION_FORO WHERE id_foro=10 AND id_usuario=23 AND fecha_publicacion=DATE '2024-02-20'));

COMMIT;

-- ============================================================
-- SECCION 13: PROGRESO DE LECCION
-- Los id_leccion corresponden al mapa definido en SECCION 7:
--   1-5: modulo 1 (HTML)  | 6-10: modulo 2 (JS)  | 11-15: modulo 3 (React)
--   16-20: modulo 4 (Node)| 21-25: modulo 5 (Mongo)| 26-30: modulo 6 (DevOps)
--   31-35: modulo 7 (PyDS)| 36-40: modulo 8 (Stat) | 41-45: modulo 9 (ML)
--   46-50: modulo 10 (Unsup)
-- ============================================================

-- Usuario 16 - lecciones del curso 1 completadas
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  1, 1, DATE '2023-08-10', DATE '2023-08-10');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  2, 1, DATE '2023-08-11', DATE '2023-08-12');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  3, 1, DATE '2023-08-13', DATE '2023-08-14');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  4, 1, DATE '2023-08-15', DATE '2023-08-16');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  5, 1, DATE '2023-08-17', DATE '2023-08-17');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  6, 1, DATE '2023-08-18', DATE '2023-08-19');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  7, 1, DATE '2023-08-20', DATE '2023-08-21');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  8, 1, DATE '2023-08-22', DATE '2023-08-23');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16,  9, 1, DATE '2023-08-24', DATE '2023-08-25');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 16, 10, 1, DATE '2023-08-26', DATE '2023-08-26');

-- Usuario 21 - lecciones del curso 2 completadas (modulos 7-10, lecciones 31-50)
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 31, 1, DATE '2023-09-08', DATE '2023-09-08');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 32, 1, DATE '2023-09-09', DATE '2023-09-10');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 33, 1, DATE '2023-09-11', DATE '2023-09-12');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 34, 1, DATE '2023-09-13', DATE '2023-09-14');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 35, 1, DATE '2023-09-15', DATE '2023-09-15');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 36, 1, DATE '2023-09-16', DATE '2023-09-17');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 37, 1, DATE '2023-09-18', DATE '2023-09-19');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 38, 1, DATE '2023-09-20', DATE '2023-09-21');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 39, 1, DATE '2023-09-22', DATE '2023-09-23');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 21, 40, 1, DATE '2023-09-24', DATE '2023-09-24');

-- Usuario 18 - en progreso (leccion 3 sin completar)
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 18,  1, 1, DATE '2023-08-15', DATE '2023-08-15');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 18,  2, 1, DATE '2023-08-16', DATE '2023-08-17');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 18,  3, 0, DATE '2023-08-18', NULL);

-- Usuario 34 - lecciones modulo 3 (React) completadas
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 34, 11, 1, DATE '2023-11-15', DATE '2023-11-15');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 34, 12, 1, DATE '2023-11-16', DATE '2023-11-17');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 34, 13, 1, DATE '2023-11-18', DATE '2023-11-19');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 34, 14, 1, DATE '2023-11-20', DATE '2023-11-21');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 34, 15, 1, DATE '2023-11-22', DATE '2023-11-22');

-- Usuario 27 - lecciones modulo 8 (estadistica), una sin completar
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 27, 36, 1, DATE '2023-10-08', DATE '2023-10-08');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 27, 37, 1, DATE '2023-10-09', DATE '2023-10-10');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 27, 38, 1, DATE '2023-10-11', DATE '2023-10-12');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 27, 39, 0, DATE '2023-10-13', NULL);

-- Usuario 49 - lecciones modulo 9 (aprendizaje supervisado) completadas
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 49, 41, 1, DATE '2024-01-20', DATE '2024-01-20');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 49, 42, 1, DATE '2024-01-21', DATE '2024-01-22');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 49, 43, 1, DATE '2024-01-23', DATE '2024-01-24');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 49, 44, 1, DATE '2024-01-25', DATE '2024-01-26');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 49, 45, 1, DATE '2024-01-27', DATE '2024-01-27');

-- Usuarios adicionales con lecciones en progreso
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 26,  1, 1, DATE '2023-10-03', DATE '2023-10-03');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 26,  2, 1, DATE '2023-10-04', DATE '2023-10-05');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 26,  3, 0, DATE '2023-10-06', NULL);
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 35, 31, 1, DATE '2023-11-18', DATE '2023-11-18');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 35, 32, 1, DATE '2023-11-19', DATE '2023-11-20');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 35, 33, 0, DATE '2023-11-21', NULL);
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 43, 31, 1, DATE '2023-12-20', DATE '2023-12-20');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 43, 32, 1, DATE '2023-12-21', DATE '2023-12-22');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 53, 36, 1, DATE '2024-02-10', DATE '2024-02-10');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 53, 37, 1, DATE '2024-02-11', DATE '2024-02-12');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 53, 38, 0, DATE '2024-02-13', NULL);
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 59, 31, 1, DATE '2024-03-08', DATE '2024-03-08');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 59, 32, 1, DATE '2024-03-09', DATE '2024-03-10');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 59, 33, 1, DATE '2024-03-11', DATE '2024-03-12');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 59, 34, 1, DATE '2024-03-13', DATE '2024-03-14');
INSERT INTO PROGRESO_LECCION VALUES (SEQ_PROGRESO.NEXTVAL, 59, 35, 1, DATE '2024-03-15', DATE '2024-03-15');

COMMIT;

-- ============================================================
-- SECCION 14: CERTIFICADOS
-- Solo para combinaciones usuario/curso que tienen inscripcion
-- con estado 'completado' en SECCION 9
-- ============================================================

INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 16, 1, 'CERT-WEB-USR16-2023A', DATE '2023-10-25', 'https://certs.educloud.co/CERT-WEB-USR16-2023A.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 17, 4, 'CERT-MKT-USR17-2023A', DATE '2023-10-01', 'https://certs.educloud.co/CERT-MKT-USR17-2023A.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 20, 5, 'CERT-SEC-USR20-2023B', DATE '2023-12-01', 'https://certs.educloud.co/CERT-SEC-USR20-2023B.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 21, 2, 'CERT-ML-USR21-2023B',  DATE '2023-12-01', 'https://certs.educloud.co/CERT-ML-USR21-2023B.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 22, 6, 'CERT-PM-USR22-2023B',  DATE '2023-12-10', 'https://certs.educloud.co/CERT-PM-USR22-2023B.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 24, 8, 'CERT-FIN-USR24-2023C', DATE '2023-12-20', 'https://certs.educloud.co/CERT-FIN-USR24-2023C.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 27, 2, 'CERT-ML-USR27-2024A',  DATE '2024-01-05', 'https://certs.educloud.co/CERT-ML-USR27-2024A.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 30, 8, 'CERT-FIN-USR30-2024A', DATE '2024-01-10', 'https://certs.educloud.co/CERT-FIN-USR30-2024A.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 34, 1, 'CERT-WEB-USR34-2024A', DATE '2024-01-15', 'https://certs.educloud.co/CERT-WEB-USR34-2024A.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 39, 9, 'CERT-MOB-USR39-2024B', DATE '2024-03-15', 'https://certs.educloud.co/CERT-MOB-USR39-2024B.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 45, 8, 'CERT-FIN-USR45-2024B', DATE '2024-03-10', 'https://certs.educloud.co/CERT-FIN-USR45-2024B.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 49, 2, 'CERT-ML-USR49-2024C',  DATE '2024-03-25', 'https://certs.educloud.co/CERT-ML-USR49-2024C.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 57, 1, 'CERT-WEB-USR57-2024C', DATE '2024-04-15', 'https://certs.educloud.co/CERT-WEB-USR57-2024C.pdf');
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 59, 2, 'CERT-ML-USR59-2024D',  DATE '2024-05-02', 'https://certs.educloud.co/CERT-ML-USR59-2024D.pdf');
-- Certificado sin URL de descarga (NULL permitido)
INSERT INTO CERTIFICADO VALUES (SEQ_CERTIFICADO.NEXTVAL, 43, 2, 'CERT-ML-USR43-2024D',  DATE '2024-05-05', NULL);

COMMIT;

-- ============================================================
-- FIN DEL SCRIPT 02_insertar_datos.sql
-- Total registros:
--   USUARIO           : 60
--   ADMINISTRADOR     :  5
--   INSTRUCTOR        : 10
--   ESTUDIANTE        : 45
--   CURSO             : 12 (10 publicados + 2 en otros estados)
--   MODULO            : 51
--   LECCION           : 50
--   EVALUACION        : 34
--   INSCRIPCION       : 62
--   RESULTADO_EVAL    : 56
--   FORO              : 10
--   PUBLICACION_FORO  : 42
--   PROGRESO_LECCION  : 62
--   CERTIFICADO       : 15
-- ============================================================
