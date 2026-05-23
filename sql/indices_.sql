-- ============================================================
-- SCRIPT: 03_indices.sql
-- Sistema   : Plataforma de Gestion de Cursos Online
-- ============================================================

-- ============================================================
-- INDICE 1: USUARIO - Busqueda por email + rol combinados
-- ============================================================
-- El DDL ya tiene un UNIQUE en email (Oracle crea indice implicito),
-- pero no existe un indice compuesto email+rol.
-- Justificacion: El login del sistema busca por email Y valida
-- el rol en la misma consulta (WHERE email = ? AND rol = ?).
-- El indice compuesto resuelve ambas condiciones en una sola
-- lectura sin acceder a la tabla base.
CREATE INDEX idx_usu_email_rol
    ON USUARIO(email, rol);

-- ============================================================
-- INDICE 2: CURSO - Estado + categoria + precio combinados
-- ============================================================
-- El DDL tiene idx_cur_estado y idx_cur_categoria por separado,
-- pero NO existe un indice compuesto que cubra los tres.
-- Justificacion: El catalogo publico filtra cursos publicados
-- por categoria y ordena por precio en una sola consulta
-- (WHERE estado='publicado' AND categoria=? ORDER BY precio).
-- El indice compuesto evita dos accesos separados a indice.
CREATE INDEX idx_cur_estado_cat_precio
    ON CURSO(estado, categoria, precio);

-- ============================================================
-- INDICE 3: INSCRIPCION - Usuario + estado + progreso
-- ============================================================
-- El DDL tiene idx_ins_usuario e idx_ins_estado por separado.
-- Justificacion: El dashboard del estudiante consulta sus cursos
-- activos con progreso incompleto en una sola consulta
-- (WHERE id_usuario=? AND estado='activo' AND progreso_pct < 100).
-- El indice compuesto cubre las tres columnas sin ir a la tabla.
CREATE INDEX idx_ins_usr_estado_prog
    ON INSCRIPCION(id_usuario, estado, progreso_pct);

-- ============================================================
-- INDICE 4: PUBLICACION_FORO - Foro + fecha reciente
-- ============================================================
-- El DDL tiene idx_pub_foro (solo id_foro).
-- Justificacion: El foro muestra publicaciones ordenadas por
-- fecha DESC dentro de cada foro (WHERE id_foro=?
-- ORDER BY fecha_publicacion DESC). El indice compuesto
-- entrega los resultados ya ordenados sin sort adicional.
CREATE INDEX idx_pub_foro_fecha
    ON PUBLICACION_FORO(id_foro, fecha_publicacion DESC);

-- ============================================================
-- INDICE 5: PROGRESO_LECCION - Usuario + completada
-- ============================================================
-- El DDL tiene idx_pro_usuario (solo id_usuario).
-- Justificacion: El calculo del porcentaje de avance cuenta
-- lecciones completadas por usuario (WHERE id_usuario=?
-- AND completada=1). Indice compuesto permite resolver
-- el COUNT sin acceder a la tabla base (index-only scan).
CREATE INDEX idx_pro_usr_completada
    ON PROGRESO_LECCION(id_usuario, completada);

-- ============================================================
-- INDICE 6: LECCION - Modulo + orden
-- ============================================================
-- El DDL tiene idx_lec_modulo (solo id_modulo).
-- Justificacion: La navegacion del curso lista lecciones
-- ordenadas dentro de cada modulo (WHERE id_modulo=?
-- ORDER BY orden ASC). El indice compuesto entrega las
-- lecciones ya en orden sin sort en memoria.
CREATE INDEX idx_lec_modulo_orden
    ON LECCION(id_modulo, orden);

-- ============================================================
-- INDICE 7: MODULO - Curso + orden
-- ============================================================
-- El DDL tiene idx_mod_curso (solo id_curso).
-- Justificacion: Similar al anterior, la estructura del curso
-- lista modulos en orden (WHERE id_curso=? ORDER BY orden).
-- El indice compuesto evita el sort para cursos con muchos modulos.
CREATE INDEX idx_mod_curso_orden
    ON MODULO(id_curso, orden);

-- ============================================================
-- INDICE 8: INSCRIPCION - Rango de fechas de matricula
-- ============================================================
-- Justificacion: Los reportes mensuales de nuevas inscripciones
-- usan WHERE fecha_matric BETWEEN :f1 AND :f2. Sin indice
-- Oracle hace full scan de INSCRIPCION, que sera la tabla
-- con mas registros del sistema a medida que crece.
CREATE INDEX idx_ins_fecha_matric
    ON INSCRIPCION(fecha_matric);

-- ============================================================
-- INDICE 9: RESULTADO_EVALUACION - Fecha de intento
-- ============================================================
-- Justificacion: Los reportes de actividad academica filtran
-- intentos por rango de fecha (WHERE fecha_intento BETWEEN ...)
-- y el historial del estudiante ordena por fecha DESC.
-- Sin indice Oracle ordena en memoria todos los intentos.
CREATE INDEX idx_res_fecha_intento
    ON RESULTADO_EVALUACION(fecha_intento DESC);

-- ============================================================
-- INDICE 10: CURSO - Fecha de creacion descendente
-- ============================================================
-- Justificacion: Los reportes de "cursos mas recientes" y el
-- panel del instructor ordenan por fecha_creacion DESC.
-- Sin este indice Oracle realiza un sort en memoria sobre
-- toda la tabla antes de devolver resultados.
CREATE INDEX idx_cur_fecha_creacion
    ON CURSO(fecha_creacion DESC);