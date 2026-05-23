
-- ============================================================
-- SCRIPT: 03_consultas.sql
-- Archivo   : 03_consultas.sql
-- Sistema   : Plataforma de Gestion de Cursos Online
-- Autores   : Nicolas Jimenez C. | Johan Santiago Cadena G.
--             Jhon Sebastian Mejia A. | Alejandro Rodriguez M.
-- Materia   : Bases de Datos 2026-10
-- ============================================================


-- ============================================================
-- SECCION 1: CONSULTAS BASICAS (5 consultas)
-- ============================================================

-- ============================================================================
-- CONSULTA #01: Cursos publicados ordenados por precio descendente O
-- Descripcion: Lista todos los cursos disponibles para compra con su precio
--              y categoria, ordenados de mayor a menor precio.
-- Tipo: Basica - WHERE, ORDER BY
-- ============================================================================
SELECT
    id_curso,
    titulo,
    categoria,
    precio,
    puntaje_min_cert,
    fecha_creacion
FROM CURSO
WHERE estado = 'publicado'
ORDER BY precio DESC;


-- ============================================================================
-- CONSULTA #02: Los 5 instructores mejor calificados 0
-- Descripcion: Muestra los instructores con mayor calificacion promedio
--              para destacarlos en la pagina principal de la plataforma.
-- Tipo: Basica - WHERE, ORDER BY, FETCH FIRST
-- ============================================================================
SELECT
    id_instructor,
    nombre,
    especialidad,
    calificacion_prom
FROM INSTRUCTOR
WHERE calificacion_prom IS NOT NULL
ORDER BY calificacion_prom DESC
FETCH FIRST 5 ROWS ONLY;


-- ============================================================================
-- CONSULTA #03: Nivel educativo O
-- Descripcion:indica  como el instructor debe manejar y organizar las clases
-- Tipo: Basica
-- ============================================================================
SELECT NIVEL_EDUCATIVO, COUNT(*) AS total
FROM ESTUDIANTE
GROUP BY NIVEL_EDUCATIVO
HAVING COUNT(*) > 1;


-- ============================================================================
-- CONSULTA #04: Evaluaciones con tiempo limite y puntaje minimo alto O
-- Descripcion: Identifica evaluaciones exigentes para analizar la dificultad
--              del contenido de la plataforma.
-- Tipo: Basica - WHERE con multiples condiciones, funciones numericas
-- ============================================================================
SELECT
    id_eval,
    titulo,
    tipo,
    puntaje_min,
    tiempo_limite_min,
    ROUND(tiempo_limite_min / 60, 2) AS horas_limite,
    id_curso
FROM EVALUACION
WHERE puntaje_min       >= 70
  AND tiempo_limite_min IS NOT NULL
ORDER BY puntaje_min DESC, tiempo_limite_min ASC;


-- ============================================================================
-- CONSULTA #05: Lecciones de video con duracion en horas O
-- Descripcion: Lista todas las lecciones de video con su duracion convertida
--              a horas, ordenadas de mayor a menor para detectar lecciones largas.
-- Tipo: Basica - Funciones numericas, WHERE, ORDER BY
-- ============================================================================
SELECT
    id_leccion,
    titulo,
    tipo_contenido,
    duracion_min,
    ROUND(duracion_min / 60, 2) AS duracion_horas,
    id_modulo
FROM LECCION
WHERE tipo_contenido = 'video'
  AND duracion_min IS NOT NULL
ORDER BY duracion_min DESC;


-- ============================================================
-- SECCION 2: JOINs (5 consultas)
-- ============================================================

-- ============================================================================
-- CONSULTA #06: Cursos con su instructor (INNER JOIN 2 tablas) O
-- Descripcion: Lista cada curso publicado junto con el nombre y especialidad
--              de su instructor para mostrar en el catalogo de la plataforma.
-- Tipo: JOIN - INNER JOIN 2 tablas
-- ============================================================================
SELECT
    c.id_curso,
    c.titulo          AS curso,
    c.categoria,
    c.precio,
    i.nombre          AS instructor,
    i.especialidad,
    i.calificacion_prom
FROM CURSO      c
JOIN INSTRUCTOR i ON i.id_instructor = c.id_instructor
WHERE c.estado = 'publicado'
ORDER BY i.calificacion_prom DESC NULLS LAST;


-- ============================================================================
-- CONSULTA #07: Detalle completo de inscripciones activas (INNER JOIN 3+ tablas) O
-- Descripcion: Muestra el nombre del estudiante, el curso en que esta inscrito
--              y el instructor que lo dicta, para el panel de administracion.
-- Tipo: JOIN - INNER JOIN 4 tablas
-- ============================================================================
SELECT
    u.nombre          AS estudiante,
    c.titulo          AS curso,
    c.categoria,
    i.nombre          AS instructor,
    ins.progreso_pct  AS progreso,
    ins.estado,
    ins.fecha_matric
FROM INSCRIPCION ins
JOIN USUARIO     u  ON u.id_usuario    = ins.id_usuario
JOIN CURSO       c  ON c.id_curso      = ins.id_curso
JOIN INSTRUCTOR  i  ON i.id_instructor = c.id_instructor
WHERE ins.estado = 'activo'
ORDER BY ins.progreso_pct DESC;


-- ============================================================================
-- CONSULTA #08: Cursos sin ninguna inscripcion (LEFT JOIN sin coincidencia) O
-- Descripcion: Detecta cursos que aun no tienen estudiantes inscritos,
--              util para campanas de marketing o revision del contenido.
-- Tipo: JOIN - LEFT JOIN mostrando registros sin coincidencia
-- ============================================================================
SELECT
    c.id_curso,
    c.titulo,
    c.categoria,
    c.estado,
    c.fecha_creacion,
    i.nombre AS instructor
FROM CURSO      c
JOIN INSTRUCTOR i   ON i.id_instructor = c.id_instructor
LEFT JOIN INSCRIPCION ins ON ins.id_curso = c.id_curso
WHERE ins.id_inscripcion IS NULL
ORDER BY c.fecha_creacion DESC;


-- ============================================================================
-- CONSULTA #09: Hilos de respuesta en foros (SELF JOIN) O
-- Descripcion: Muestra cada respuesta junto con el contenido de la publicacion
--              padre a la que responde, para visualizar los hilos del foro.
-- Tipo: JOIN - SELF JOIN usando la relacion recursiva RESPONDE_A
-- ============================================================================
SELECT
    r.id_publicacion              AS id_respuesta,
    u_r.nombre                    AS autor_respuesta,
    SUBSTR(r.contenido, 1, 80)    AS texto_respuesta,
    p.id_publicacion              AS id_publicacion_padre,
    u_p.nombre                    AS autor_padre,
    SUBSTR(p.contenido, 1, 80)    AS texto_padre,
    r.fecha_publicacion
FROM PUBLICACION_FORO r
JOIN PUBLICACION_FORO p   ON p.id_publicacion = r.id_pub_padre
JOIN USUARIO          u_r ON u_r.id_usuario   = r.id_usuario
JOIN USUARIO          u_p ON u_p.id_usuario   = p.id_usuario
ORDER BY r.id_foro, r.fecha_publicacion;


-- ============================================================================
-- CONSULTA #10: Progreso detallado de lecciones por estudiante y curso
-- Descripcion: Muestra el avance leccion por leccion de cada estudiante,
--              incluyendo si la completo y cuando, para reportes de progreso.
-- Tipo: JOIN - INNER JOIN 4 tablas
-- ============================================================================
SELECT
    u.nombre        AS estudiante,
    c.titulo        AS curso,
    m.titulo        AS modulo,
    l.titulo        AS leccion,
    l.tipo_contenido,
    CASE pl.completada
        WHEN 1 THEN 'Completada'
        ELSE 'En progreso'
    END             AS estado_leccion,
    pl.fecha_inicio,
    pl.fecha_completado
FROM PROGRESO_LECCION pl
JOIN USUARIO          u  ON u.id_usuario = pl.id_usuario
JOIN LECCION          l  ON l.id_leccion = pl.id_leccion
JOIN MODULO           m  ON m.id_modulo  = l.id_modulo
JOIN CURSO            c  ON c.id_curso   = m.id_curso
ORDER BY u.nombre, c.titulo, m.orden, l.orden;


-- ============================================================
-- SECCION 3: AGREGACIONES (5 consultas)
-- ============================================================

-- ============================================================================
-- CONSULTA #11: Total de inscripciones y promedio de progreso por curso y estado
-- Descripcion: Resume cuantos estudiantes tiene cada curso segun su estado
--              de inscripcion y cual es el progreso promedio de cada grupo.
-- Tipo: Agregacion - GROUP BY multiples columnas, COUNT, AVG, MIN, MAX
-- ============================================================================
SELECT
    c.titulo                        AS curso,
    ins.estado,
    COUNT(ins.id_inscripcion)       AS total_estudiantes,
    ROUND(AVG(ins.progreso_pct), 2) AS progreso_promedio,
    MIN(ins.progreso_pct)           AS progreso_minimo,
    MAX(ins.progreso_pct)           AS progreso_maximo
FROM INSCRIPCION ins
JOIN CURSO       c ON c.id_curso = ins.id_curso
GROUP BY c.titulo, ins.estado
ORDER BY c.titulo, ins.estado;


-- ============================================================================
-- CONSULTA #12: Instructores con mas de 5 estudiantes activos (HAVING)
-- Descripcion: Identifica instructores con alta demanda para reconocerlos
--              o planificar la expansion de sus cursos.
-- Tipo: Agregacion - GROUP BY, HAVING, COUNT
-- ============================================================================
SELECT
    i.nombre                     AS instructor,
    i.especialidad,
    COUNT(ins.id_inscripcion)    AS estudiantes_activos,
    COUNT(DISTINCT ins.id_curso) AS cursos_con_estudiantes
FROM INSTRUCTOR  i
JOIN CURSO       c   ON c.id_instructor = i.id_instructor
JOIN INSCRIPCION ins ON ins.id_curso    = c.id_curso
WHERE ins.estado = 'activo'
GROUP BY i.nombre, i.especialidad
HAVING COUNT(ins.id_inscripcion) > 5
ORDER BY estudiantes_activos DESC;


-- ============================================================================
-- CONSULTA #13: Ingresos potenciales por categoria de curso
-- Descripcion: Calcula cuantas inscripciones tiene cada categoria y el
--              ingreso potencial sumando el precio por cada inscripcion.
-- Tipo: Agregacion - GROUP BY, SUM, COUNT
-- ============================================================================
SELECT
    c.categoria,
    COUNT(DISTINCT c.id_curso)   AS total_cursos,
    COUNT(ins.id_inscripcion)    AS total_inscripciones,
    SUM(c.precio)                AS suma_precios_cursos
FROM CURSO       c
JOIN INSCRIPCION ins ON ins.id_curso = c.id_curso
WHERE c.estado = 'publicado'
GROUP BY c.categoria
ORDER BY total_inscripciones DESC;


-- ============================================================================
-- CONSULTA #14: Rendimiento academico promedio por curso
-- Descripcion: Muestra el puntaje promedio, minimo y maximo obtenido por
--              los estudiantes en las evaluaciones de cada curso.
-- Tipo: Agregacion - JOIN + GROUP BY + AVG, MIN, MAX, COUNT
-- ============================================================================
SELECT
    c.titulo                                AS curso,
    c.puntaje_min_cert                      AS puntaje_minimo_cert,
    COUNT(re.id_resultado)                  AS total_intentos,
    ROUND(AVG(re.puntaje_obtenido), 2)      AS promedio_puntaje,
    MIN(re.puntaje_obtenido)                AS puntaje_minimo,
    MAX(re.puntaje_obtenido)                AS puntaje_maximo
FROM RESULTADO_EVALUACION re
JOIN EVALUACION           e  ON e.id_eval  = re.id_eval
JOIN CURSO                c  ON c.id_curso = e.id_curso
GROUP BY c.titulo, c.puntaje_min_cert
ORDER BY promedio_puntaje DESC;


-- ============================================================================
-- CONSULTA #15: Actividad en foros por curso 0
-- Descripcion: Mide la participacion en cada foro contando publicaciones
--              totales, hilos raiz, respuestas y participantes unicos.
-- Tipo: Agregacion - LEFT JOIN + GROUP BY + COUNT con CASE
-- ============================================================================
SELECT
    f.titulo                      AS foro,
    c.titulo                      AS curso,
    COUNT(p.id_publicacion)       AS total_publicaciones,
    SUM(CASE WHEN p.id_pub_padre IS NULL     THEN 1 ELSE 0 END) AS hilos_principales,
    SUM(CASE WHEN p.id_pub_padre IS NOT NULL THEN 1 ELSE 0 END) AS respuestas,
    COUNT(DISTINCT p.id_usuario)  AS participantes_unicos
FROM FORO           f
JOIN CURSO          c  ON c.id_curso = f.id_curso
LEFT JOIN PUBLICACION_FORO p ON p.id_foro = f.id_foro
GROUP BY f.titulo, c.titulo
ORDER BY total_publicaciones DESC;


-- ============================================================
-- SECCION 4: SUBCONSULTAS (5 consultas)
-- ============================================================

-- ============================================================================
-- CONSULTA #16: Estudiantes inscritos en cursos de programacion (IN)
-- Descripcion: Lista los estudiantes que tienen al menos una inscripcion
--              en cursos de la categoria Programacion.
-- Tipo: Subconsulta - WHERE con IN
-- ============================================================================
SELECT
    u.id_usuario,
    u.nombre,
    u.email,
    e.nivel_educativo,
    e.areas_interes
FROM USUARIO    u
JOIN ESTUDIANTE e ON e.id_usuario = u.id_usuario
WHERE u.id_usuario IN (
    SELECT ins.id_usuario
      FROM INSCRIPCION ins
      JOIN CURSO       c ON c.id_curso = ins.id_curso
     WHERE c.categoria = 'Programacion'
)
ORDER BY u.nombre;


-- ============================================================================
-- CONSULTA #17: Cursos que tienen al menos un examen final definido (EXISTS)
-- Descripcion: Identifica cursos que ya tienen su examen final configurado,
--              util para verificar que el contenido esta completo.
-- Tipo: Subconsulta - WHERE con EXISTS
-- ============================================================================
SELECT
    c.id_curso,
    c.titulo,
    c.categoria,
    c.estado,
    c.puntaje_min_cert
FROM CURSO c
WHERE EXISTS (
    SELECT 1
      FROM EVALUACION e
     WHERE e.id_curso = c.id_curso
       AND e.tipo     = 'examen_final'
)
ORDER BY c.categoria, c.titulo;


-- ============================================================================
-- CONSULTA #18: Estudiantes con progreso mayor al promedio de su curso
-- Descripcion: Encuentra estudiantes que van adelantados respecto al promedio
--              de sus companeros en el mismo curso, para reconocerlos.
-- Tipo: Subconsulta - Subconsulta correlacionada
-- ============================================================================
SELECT
    u.nombre          AS estudiante,
    c.titulo          AS curso,
    ins.progreso_pct  AS mi_progreso,
    ROUND((
        SELECT AVG(ins2.progreso_pct)
          FROM INSCRIPCION ins2
         WHERE ins2.id_curso = ins.id_curso
    ), 2)             AS promedio_del_curso
FROM INSCRIPCION ins
JOIN USUARIO     u ON u.id_usuario = ins.id_usuario
JOIN CURSO       c ON c.id_curso   = ins.id_curso
WHERE ins.progreso_pct > (
    SELECT AVG(ins2.progreso_pct)
      FROM INSCRIPCION ins2
     WHERE ins2.id_curso = ins.id_curso
)
  AND ins.estado = 'activo'
ORDER BY  ins.progreso_pct DESC ;


-- ============================================================================
-- CONSULTA #19: Ranking de cursos por tasa de completitud (tabla derivada) O
-- Descripcion: Calcula que porcentaje de los inscritos en cada curso lo
--              completaron, para identificar los cursos mas efectivos.
-- Tipo: Subconsulta - Subconsulta en FROM (tabla derivada)
-- ============================================================================
SELECT
    resumen.titulo,
    resumen.categoria,
    resumen.total_inscritos,
    resumen.completados,
    resumen.abandonados,
    ROUND(
        (resumen.completados / resumen.total_inscritos) * 100
    , 2)              AS tasa_completitud_pct
FROM (
    SELECT
        c.titulo,
        c.categoria,
        COUNT(ins.id_inscripcion)                                   AS total_inscritos,
        SUM(CASE WHEN ins.estado = 'completado' THEN 1 ELSE 0 END) AS completados,
        SUM(CASE WHEN ins.estado = 'abandonado' THEN 1 ELSE 0 END) AS abandonados
    FROM CURSO       c
    JOIN INSCRIPCION ins ON ins.id_curso = c.id_curso
    GROUP BY c.titulo, c.categoria
) resumen
WHERE resumen.total_inscritos > 0
ORDER BY tasa_completitud_pct DESC;


-- ============================================================================
-- CONSULTA #20: Estudiantes que nunca han reprobado una evaluacion (NOT IN)
-- Descripcion: Identifica estudiantes con historial academico perfecto,
--              candidatos para reconocimientos en la plataforma.
-- Tipo: Subconsulta - WHERE con NOT IN
-- ============================================================================
SELECT
    u.id_usuario,
    u.nombre,
    e.nivel_educativo,
    COUNT(re.id_resultado) AS total_evaluaciones_presentadas
FROM USUARIO              u
JOIN ESTUDIANTE           e  ON e.id_usuario  = u.id_usuario
JOIN RESULTADO_EVALUACION re ON re.id_usuario = u.id_usuario
WHERE u.id_usuario NOT IN (
    SELECT re2.id_usuario
      FROM RESULTADO_EVALUACION re2
     WHERE re2.aprobado = 0
)
GROUP BY u.id_usuario, u.nombre, e.nivel_educativo
ORDER BY total_evaluaciones_presentadas DESC;


-- ============================================================
-- SECCION 5: OPERACIONES DE CONJUNTOS (5 consultas)
-- ============================================================

-- ============================================================================
-- CONSULTA #21: Directorio unificado de todos los usuarios activos (UNION ALL)
-- Descripcion: Genera un listado de todos los usuarios activos del sistema
--              sin importar su rol, con su tipo identificado.
-- Tipo: Operacion de conjuntos - UNION ALL
-- ============================================================================
SELECT
    u.id_usuario,
    u.nombre,
    u.email,
    'Administrador' AS tipo_usuario,
    a.nivel_acceso  AS detalle
FROM USUARIO       u
JOIN ADMINISTRADOR a ON a.id_usuario = u.id_usuario
WHERE u.activo = 1

UNION ALL

SELECT
    u.id_usuario,
    u.nombre,
    u.email,
    'Instructor'    AS tipo_usuario,
    i.especialidad  AS detalle
FROM USUARIO    u
JOIN INSTRUCTOR i ON i.id_usuario = u.id_usuario
WHERE u.activo = 1

UNION ALL

SELECT
    u.id_usuario,
    u.nombre,
    u.email,
    'Estudiante'      AS tipo_usuario,
    e.nivel_educativo AS detalle
FROM USUARIO    u
JOIN ESTUDIANTE e ON e.id_usuario = u.id_usuario
WHERE u.activo = 1

ORDER BY tipo_usuario, nombre;


-- ============================================================================
-- CONSULTA #22: Cursos en borrador o archivados (UNION)
-- Descripcion: Lista todos los cursos que NO estan publicados para que
--              el equipo editorial priorice su revision o eliminacion.
-- Tipo: Operacion de conjuntos - UNION
-- ============================================================================
SELECT
    id_curso,
    titulo,
    categoria,
    'BORRADOR - Pendiente de revision' AS situacion,
    fecha_creacion
FROM CURSO
WHERE estado = 'borrador'

UNION

SELECT
    id_curso,
    titulo,
    categoria,
    'ARCHIVADO - Fuera de catalogo'    AS situacion,
    fecha_creacion
FROM CURSO
WHERE estado = 'archivado'

ORDER BY situacion, fecha_creacion;


-- ============================================================================
-- CONSULTA #23: Estudiantes que participan en foros Y tienen certificados (INTERSECT)
-- Descripcion: Identifica estudiantes muy comprometidos: los que participan
--              en foros y ademas ya obtuvieron al menos un certificado.
-- Tipo: Operacion de conjuntos - INTERSECT
-- ============================================================================
SELECT
    u.id_usuario,
    u.nombre,
    u.email
FROM PUBLICACION_FORO p
JOIN USUARIO          u ON u.id_usuario = p.id_usuario

INTERSECT

SELECT
    u.id_usuario,
    u.nombre,
    u.email
FROM CERTIFICADO c
JOIN USUARIO     u ON u.id_usuario = c.id_usuario

ORDER BY nombre;


-- ============================================================================
-- CONSULTA #24: Estudiantes inscritos pero sin ningun resultado de evaluacion (MINUS)
-- Descripcion: Encuentra estudiantes que se inscribieron pero nunca han
--              presentado ninguna evaluacion, para enviarles recordatorios.
-- Tipo: Operacion de conjuntos - MINUS
-- ============================================================================
SELECT
    u.id_usuario,
    u.nombre,
    u.email
FROM INSCRIPCION ins
JOIN USUARIO     u ON u.id_usuario = ins.id_usuario
WHERE ins.estado = 'activo'

MINUS

SELECT
    u.id_usuario,
    u.nombre,
    u.email
FROM RESULTADO_EVALUACION re
JOIN USUARIO              u ON u.id_usuario = re.id_usuario

ORDER BY nombre;


-- ============================================================================
-- CONSULTA #25: Instructores con cursos publicados pero sin cursos archivados (MINUS)
-- Descripcion: Identifica instructores nuevos que solo tienen cursos activos
--              y nunca han tenido un curso retirado del catalogo.
-- Tipo: Operacion de conjuntos - MINUS
-- ============================================================================
SELECT
    i.id_instructor,
    i.nombre,
    i.especialidad
FROM INSTRUCTOR i
JOIN CURSO      c ON c.id_instructor = i.id_instructor
WHERE c.estado = 'publicado'

MINUS

SELECT
    i.id_instructor,
    i.nombre,
    i.especialidad
FROM INSTRUCTOR i
JOIN CURSO      c ON c.id_instructor = i.id_instructor
WHERE c.estado = 'archivado'

ORDER BY nombre;


-- ============================================================
-- SECCION 6: VISTAS (5 vistas)
-- ============================================================

-- ============================================================================
-- CONSULTA #26: Vista de inscripciones activas con datos completos
-- Descripcion: Centraliza la informacion de inscripciones activas con datos
--              del estudiante, curso e instructor para reportes frecuentes
--              sin repetir los JOIN en cada consulta del panel admin.
-- Tipo: Vista - Reporte frecuente
-- ============================================================================
CREATE OR REPLACE VIEW VW_INSCRIPCIONES_ACTIVAS AS
SELECT
    ins.id_inscripcion,
    u.id_usuario,
    u.nombre                              AS estudiante,
    u.email,
    c.id_curso,
    c.titulo                              AS curso,
    c.categoria,
    i.nombre                              AS instructor,
    ins.fecha_matric,
    ins.progreso_pct,
    ins.estado,
    TRUNC(SYSDATE - ins.fecha_matric)     AS dias_inscrito
FROM INSCRIPCION ins
JOIN USUARIO     u  ON u.id_usuario    = ins.id_usuario
JOIN CURSO       c  ON c.id_curso      = ins.id_curso
JOIN INSTRUCTOR  i  ON i.id_instructor = c.id_instructor
WHERE ins.estado = 'activo';

-- Uso de la vista
SELECT * FROM VW_INSCRIPCIONES_ACTIVAS
ORDER BY progreso_pct DESC;


-- ============================================================================
-- CONSULTA #27: Vista de certificados emitidos con datos del estudiante y curso
-- Descripcion: Simplifica la consulta de certificados combinando usuario,
--              curso e instructor en una sola vista para reportes de egresados.
-- Tipo: Vista - Reporte frecuente
-- ============================================================================
CREATE OR REPLACE VIEW VW_CERTIFICADOS_EMITIDOS AS
SELECT
    ce.id_certificado,
    u.nombre           AS estudiante,
    u.email,
    c.titulo           AS curso,
    c.categoria,
    i.nombre           AS instructor,
    ce.cod_verif,
    ce.fecha_gen,
    ce.url_descarga
FROM CERTIFICADO ce
JOIN USUARIO     u  ON u.id_usuario    = ce.id_usuario
JOIN CURSO       c  ON c.id_curso      = ce.id_curso
JOIN INSTRUCTOR  i  ON i.id_instructor = c.id_instructor;

-- Uso de la vista
SELECT * FROM VW_CERTIFICADOS_EMITIDOS
ORDER BY fecha_gen DESC;


-- ============================================================================
-- CONSULTA #28: Vista de rendimiento academico por estudiante y curso
-- Descripcion: Simplifica la consulta de rendimiento combinando inscripciones
--              y resultados de evaluaciones para reportes academicos complejos.
-- Tipo: Vista - Simplifica consultas complejas
-- ============================================================================
CREATE OR REPLACE VIEW VW_RENDIMIENTO_ACADEMICO AS
SELECT
    u.id_usuario,
    u.nombre                                     AS estudiante,
    c.id_curso,
    c.titulo                                     AS curso,
    c.categoria,
    ins.estado                                   AS estado_inscripcion,
    ins.progreso_pct,
    COUNT(re.id_resultado)                       AS total_evaluaciones,
    ROUND(NVL(AVG(re.puntaje_obtenido), 0), 2)  AS promedio_evaluaciones,
    SUM(CASE WHEN re.aprobado = 1 THEN 1 ELSE 0 END) AS evaluaciones_aprobadas
FROM INSCRIPCION ins
JOIN USUARIO     u  ON u.id_usuario = ins.id_usuario
JOIN CURSO       c  ON c.id_curso   = ins.id_curso
LEFT JOIN RESULTADO_EVALUACION re
    ON  re.id_usuario = ins.id_usuario
    AND re.id_eval IN (
        SELECT id_eval FROM EVALUACION WHERE id_curso = ins.id_curso
    )
GROUP BY
    u.id_usuario, u.nombre,
    c.id_curso,   c.titulo, c.categoria,
    ins.estado,   ins.progreso_pct;

-- Uso de la vista
SELECT * FROM VW_RENDIMIENTO_ACADEMICO
WHERE estado_inscripcion = 'completado'
ORDER BY promedio_evaluaciones DESC;


-- ============================================================================
-- CONSULTA #29: Vista del catalogo publico de cursos
-- Descripcion: Expone solo la informacion que un visitante necesita ver
--              para elegir un curso, sin datos internos del sistema.
-- Tipo: Vista - Simplifica consultas complejas
-- ============================================================================
CREATE OR REPLACE VIEW VW_CATALOGO_CURSOS AS
SELECT
    c.id_curso,
    c.titulo,
    c.categoria,
    c.precio,
    c.puntaje_min_cert,
    i.nombre           AS instructor,
    i.especialidad,
    i.calificacion_prom,
    COUNT(DISTINCT ins.id_usuario) AS total_estudiantes,
    COUNT(DISTINCT m.id_modulo)    AS total_modulos
FROM CURSO       c
JOIN INSTRUCTOR  i   ON i.id_instructor = c.id_instructor
LEFT JOIN INSCRIPCION ins ON ins.id_curso = c.id_curso
LEFT JOIN MODULO      m   ON m.id_curso   = c.id_curso
WHERE c.estado = 'publicado'
GROUP BY
    c.id_curso,    c.titulo,       c.categoria,
    c.precio,      c.puntaje_min_cert,
    i.nombre,      i.especialidad, i.calificacion_prom;

-- Uso de la vista
SELECT * FROM VW_CATALOGO_CURSOS
ORDER BY calificacion_prom DESC NULLS LAST;


-- ============================================================================
-- CONSULTA #30: Vista de actividad reciente en foros
-- Descripcion: Consolida las publicaciones de foros con datos del autor
--              y del curso, para mostrar el feed de actividad reciente.
-- Tipo: Vista - Simplifica consultas complejas
-- ============================================================================
CREATE OR REPLACE VIEW VW_ACTIVIDAD_FOROS AS
SELECT
    p.id_publicacion,
    f.titulo                      AS foro,
    c.titulo                      AS curso,
    u.nombre                      AS autor,
    SUBSTR(p.contenido, 1, 120)   AS resumen_contenido,
    p.fecha_publicacion,
    CASE
        WHEN p.id_pub_padre IS NULL THEN 'Hilo nuevo'
        ELSE 'Respuesta'
    END                           AS tipo_publicacion
FROM PUBLICACION_FORO p
JOIN FORO             f ON f.id_foro    = p.id_foro
JOIN CURSO            c ON c.id_curso   = f.id_curso
JOIN USUARIO          u ON u.id_usuario = p.id_usuario;

-- Uso de la vista
SELECT * FROM VW_ACTIVIDAD_FOROS
ORDER BY fecha_publicacion DESC
FETCH FIRST 20 ROWS ONLY;
-SELECT
    c.TITULO AS titulo,
    c.PRECIO * COUNT(ins.ID_USUARIO) AS ingresos,
    COUNT(ins.ID_USUARIO) AS cantidad_estudiantes
FROM CURSO c
JOIN INSCRIPCION ins
ON c.ID_CURSO = ins.ID_CURSO
GROUP BY c.ID_CURSO, c.TITULO, c.PRECIO
ORDER BY ingresos DESC
FETCH FIRST 3 ROWS ONLY;

 -- top 3 cursos
SELECT
    c.TITULO AS titulo,
    c.PRECIO * COUNT(ins.ID_USUARIO) AS ingresos,
    COUNT(ins.ID_USUARIO) AS cantidad_estudiantes
FROM CURSO c
JOIN INSCRIPCION ins
ON c.ID_CURSO = ins.ID_CURSO
GROUP BY c.ID_CURSO, c.TITULO, c.PRECIO
ORDER BY ingresos DESC
FETCH FIRST 3 ROWS ONLY;





