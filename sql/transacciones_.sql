-- ============================================================
-- SCRIPT DE TRANSACCIONES
-- Archivo   : 05_transacciones.sql
-- Sistema   : Plataforma de Gestion de Cursos Online
-- Autores   : Nicolas Jimenez C. | Johan Santiago Cadena G.
--             Jhon Sebastian Mejia A. | Alejandro Rodriguez M.
-- Materia   : Bases de Datos 2026-10
-- ============================================================
-- Descripcion:
--   Demuestra el manejo de transacciones en Oracle mediante
--   escenarios reales del negocio. Cada escenario muestra
--   atomicidad: o todas las operaciones se confirman (COMMIT)
--   o ninguna persiste (ROLLBACK).
-- ============================================================


-- ============================================================
-- ESCENARIO 1 (EXITOSO): Inscripcion completa de un estudiante
-- ============================================================
-- Contexto de negocio:
--   Cuando un estudiante se matricula en un curso, el sistema
--   debe en una sola transaccion atomica:
--     1. Crear el registro de inscripcion.
--     2. Crear el registro de progreso (0%) en cada leccion
--        obligatoria del primer modulo del curso.
--     3. Crear el hilo inicial del foro del curso para el usuario.
--   Si cualquiera de estos pasos falla, no debe quedar ningun
--   registro parcial en la base de datos.
-- ============================================================

DECLARE
    v_id_inscripcion NUMBER;
    v_id_progreso    NUMBER;
    v_id_publicacion NUMBER;
    v_id_foro        NUMBER;
    v_primer_modulo  NUMBER;
    v_existe         NUMBER;

    -- Parametros de entrada
    v_id_usuario NUMBER := 42;  -- Brigitte Meza (estudiante activa)
    v_id_curso   NUMBER := 5;   -- Curso: Hacking Etico y Ciberseguridad (publicado)

BEGIN
    -- --------------------------------------------------------
    -- PASO 1: Verificar que el estudiante no este ya inscrito
    -- --------------------------------------------------------
    SELECT COUNT(*)
      INTO v_existe
      FROM INSCRIPCION
     WHERE id_usuario = v_id_usuario
       AND id_curso   = v_id_curso;

    IF v_existe > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] ERROR: El estudiante ya esta inscrito en este curso.');
        RETURN;
    END IF;

    -- --------------------------------------------------------
    -- PASO 2: Insertar el registro de INSCRIPCION
    -- El trigger trg_validar_inscripcion valida automaticamente
    -- que el usuario sea estudiante y el curso este publicado.
    -- --------------------------------------------------------
    v_id_inscripcion := SEQ_INSCRIPCION.NEXTVAL;

    INSERT INTO INSCRIPCION (
        id_inscripcion, id_usuario, id_curso,
        fecha_matric, progreso_pct, estado
    ) VALUES (
        v_id_inscripcion, v_id_usuario, v_id_curso,
        SYSDATE, 0, 'activo'
    );

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] Paso 2 OK - Inscripcion creada con id=' || v_id_inscripcion);

    -- --------------------------------------------------------
    -- PASO 3: Obtener el primer modulo del curso
    -- --------------------------------------------------------
    SELECT id_modulo
      INTO v_primer_modulo
      FROM MODULO
     WHERE id_curso = v_id_curso
       AND orden    = 1;

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] Paso 3 OK - Primer modulo: id=' || v_primer_modulo);

    -- --------------------------------------------------------
    -- PASO 4: Crear registros de PROGRESO_LECCION (completada=0)
    --         para cada leccion obligatoria del primer modulo.
    -- --------------------------------------------------------
    FOR rec IN (
        SELECT id_leccion
          FROM LECCION
         WHERE id_modulo      = v_primer_modulo
           AND es_obligatoria = 1
         ORDER BY orden
    ) LOOP
        v_id_progreso := SEQ_PROGRESO.NEXTVAL;

        INSERT INTO PROGRESO_LECCION (
            id_progreso, id_usuario, id_leccion,
            completada, fecha_inicio, fecha_completado
        ) VALUES (
            v_id_progreso, v_id_usuario, rec.id_leccion,
            0, SYSDATE, NULL
        );

        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] Paso 4 OK - Progreso inicial creado para leccion id=' || rec.id_leccion);
    END LOOP;

    -- --------------------------------------------------------
    -- PASO 5: Publicar mensaje de bienvenida en el foro del curso
    -- --------------------------------------------------------
    SELECT id_foro
      INTO v_id_foro
      FROM FORO
     WHERE id_curso = v_id_curso;

    v_id_publicacion := SEQ_PUBLICACION.NEXTVAL;

    INSERT INTO PUBLICACION_FORO (
        id_publicacion, id_foro, id_usuario,
        contenido, fecha_publicacion, id_pub_padre
    ) VALUES (
        v_id_publicacion, v_id_foro, v_id_usuario,
        'Hola a todos! Acabo de inscribirme en el curso. Mucho gusto a todos los companeros.',
        SYSDATE, NULL
    );

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] Paso 5 OK - Publicacion de bienvenida creada con id=' || v_id_publicacion);

    -- --------------------------------------------------------
    -- COMMIT: todos los pasos completados sin errores.
    -- --------------------------------------------------------
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] COMMIT exitoso.');
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] Inscripcion registrada, progreso inicial creado');
    DBMS_OUTPUT.PUT_LINE('             y mensaje de bienvenida publicado en el foro.');
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] Estudiante id=' || v_id_usuario ||
                         ' inscrito en curso id=' || v_id_curso || '.');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] ERROR: No se encontro el curso, modulo o foro requerido.');
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] ROLLBACK aplicado. No se guardo ningun cambio.');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] ERROR inesperado: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 1] ROLLBACK aplicado. No se guardo ningun cambio.');
END;
/


-- ============================================================
-- ESCENARIO 2 (EXITOSO): Generacion automatica de certificado
-- ============================================================
-- Contexto de negocio:
--   Cuando un estudiante completa todas las lecciones obligatorias
--   y aprueba las evaluaciones con el puntaje minimo requerido,
--   el sistema genera automaticamente su certificado.
--   La transaccion debe:
--     1. Verificar que el estudiante cumpla ambos requisitos.
--     2. Marcar la inscripcion como 'completado'.
--     3. Generar el certificado con codigo unico de verificacion.
--   Si el estudiante no cumple los requisitos se hace ROLLBACK
--   y no se genera ningun certificado.
-- CORRECCIONES:
--   - Se elimino WHEN RAISE_APPLICATION_ERROR del EXCEPTION
--     porque no es una excepcion valida en Oracle. Se usa
--     WHEN OTHERS para capturar todos los errores incluyendo
--     los lanzados con RAISE_APPLICATION_ERROR.
-- ============================================================

DECLARE
    v_lecciones_obligatorias NUMBER;
    v_lecciones_completadas  NUMBER;
    v_puntaje_promedio       NUMBER(5,2);
    v_puntaje_minimo         NUMBER(5,2);
    v_id_certificado         NUMBER;
    v_cod_verif              VARCHAR2(60);
    v_nombre_usuario         VARCHAR2(100);
    v_ya_tiene               NUMBER;

    -- Parametros de entrada
    v_id_usuario NUMBER := 34;  -- Santiago Ospina (completado en curso 1)
    v_id_curso   NUMBER := 1;   -- Curso: Desarrollo Web Full Stack

BEGIN
    -- --------------------------------------------------------
    -- PASO 1: Obtener nombre del usuario y puntaje minimo del curso
    -- --------------------------------------------------------
    SELECT u.nombre, c.puntaje_min_cert
      INTO v_nombre_usuario, v_puntaje_minimo
      FROM USUARIO u
      JOIN CURSO   c ON c.id_curso = v_id_curso
     WHERE u.id_usuario = v_id_usuario;

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Verificando requisitos para: ' || v_nombre_usuario);
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Puntaje minimo del curso: ' || v_puntaje_minimo);

    -- --------------------------------------------------------
    -- PASO 2: Verificar que no exista ya un certificado
    -- --------------------------------------------------------
    SELECT COUNT(*)
      INTO v_ya_tiene
      FROM CERTIFICADO
     WHERE id_usuario = v_id_usuario
       AND id_curso   = v_id_curso;

    IF v_ya_tiene > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] AVISO: El estudiante ya tiene certificado para este curso.');
        RETURN;
    END IF;

    -- --------------------------------------------------------
    -- PASO 3: Verificar lecciones obligatorias completadas
    -- --------------------------------------------------------
    SELECT COUNT(*)
      INTO v_lecciones_obligatorias
      FROM LECCION l
      JOIN MODULO  m ON m.id_modulo = l.id_modulo
     WHERE m.id_curso       = v_id_curso
       AND l.es_obligatoria = 1;

    SELECT COUNT(*)
      INTO v_lecciones_completadas
      FROM PROGRESO_LECCION pl
      JOIN LECCION          l ON l.id_leccion = pl.id_leccion
      JOIN MODULO           m ON m.id_modulo  = l.id_modulo
     WHERE pl.id_usuario    = v_id_usuario
       AND m.id_curso        = v_id_curso
       AND l.es_obligatoria  = 1
       AND pl.completada     = 1;

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Lecciones obligatorias: ' || v_lecciones_obligatorias ||
                         ' | Completadas: ' || v_lecciones_completadas);

    IF v_lecciones_completadas < v_lecciones_obligatorias THEN
        RAISE_APPLICATION_ERROR(-20001,
            'El estudiante no ha completado todas las lecciones obligatorias. ' ||
            'Completadas: ' || v_lecciones_completadas || ' de ' || v_lecciones_obligatorias);
    END IF;

    -- --------------------------------------------------------
    -- PASO 4: Verificar puntaje promedio en evaluaciones
    -- --------------------------------------------------------
    SELECT NVL(AVG(re.puntaje_obtenido), 0)
      INTO v_puntaje_promedio
      FROM RESULTADO_EVALUACION re
      JOIN EVALUACION           e ON e.id_eval = re.id_eval
     WHERE re.id_usuario = v_id_usuario
       AND e.id_curso    = v_id_curso;

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Puntaje promedio: ' || v_puntaje_promedio ||
                         ' | Minimo requerido: ' || v_puntaje_minimo);

    IF v_puntaje_promedio < v_puntaje_minimo THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Puntaje promedio insuficiente: ' || v_puntaje_promedio ||
            '. Se requiere minimo: ' || v_puntaje_minimo);
    END IF;

    -- --------------------------------------------------------
    -- PASO 5: Actualizar inscripcion a estado 'completado'
    -- --------------------------------------------------------
    UPDATE INSCRIPCION
       SET estado       = 'completado',
           progreso_pct = 100
     WHERE id_usuario = v_id_usuario
       AND id_curso   = v_id_curso;

    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003,
            'No se encontro la inscripcion del estudiante en el curso.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Paso 5 OK - Inscripcion marcada como completado.');

    -- --------------------------------------------------------
    -- PASO 6: Generar codigo unico de verificacion
    -- --------------------------------------------------------
    v_cod_verif := 'CERT-' ||
                   LPAD(v_id_curso,   3, '0') || '-USR' ||
                   LPAD(v_id_usuario, 4, '0') || '-' ||
                   TO_CHAR(SYSDATE, 'YYYYMM');

    -- --------------------------------------------------------
    -- PASO 7: Insertar el CERTIFICADO
    -- --------------------------------------------------------
    v_id_certificado := SEQ_CERTIFICADO.NEXTVAL;

    INSERT INTO CERTIFICADO (
        id_certificado, id_usuario, id_curso,
        cod_verif, fecha_gen, url_descarga
    ) VALUES (
        v_id_certificado, v_id_usuario, v_id_curso,
        v_cod_verif,
        SYSDATE,
        'https://certs.educloud.co/' || v_cod_verif || '.pdf'
    );

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Paso 7 OK - Certificado generado: ' || v_cod_verif);

    -- --------------------------------------------------------
    -- COMMIT: inscripcion actualizada + certificado creado
    -- --------------------------------------------------------
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] COMMIT exitoso.');
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Certificado ' || v_cod_verif ||
                         ' generado para ' || v_nombre_usuario || '.');

EXCEPTION
    -- --------------------------------------------------------
    -- CORRECCION: se reemplazo WHEN RAISE_APPLICATION_ERROR
    -- (que no existe como excepcion en Oracle) por WHEN OTHERS,
    -- que captura correctamente tanto los errores del sistema
    -- como los lanzados con RAISE_APPLICATION_ERROR(-20xxx).
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] Requisitos no cumplidos o error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 2] ROLLBACK aplicado. No se genero ningun certificado.');
END;
/


-- ============================================================
-- ESCENARIO 3 (ROLLBACK FORZADO): Registro de resultado de
-- evaluacion con violacion de regla de negocio RN04
-- ============================================================
-- Contexto de negocio (RN04):
--   El estudiante solo puede repetir una evaluacion 24 horas
--   despues de su ultimo intento. Si intenta antes, el sistema
--   rechaza el intento completo y no guarda ningun resultado.
-- CORRECCIONES:
--   - Se elimino el Paso 5 (UPDATE manual de progreso_pct + 10)
--     porque el trigger trg_actualizar_progreso_curso ya recalcula
--     el progreso automaticamente desde PROGRESO_LECCION.
--     Hacer ese UPDATE manual causaria conflicto con el trigger
--     trg_validar_inscripcion (ORA-20003).
-- ============================================================

DECLARE
    v_ultimo_intento      DATE;
    v_horas_transcurridas NUMBER;
    v_id_resultado        NUMBER;
    v_puntaje             NUMBER(5,2) := 82.00;
    v_aprobado            NUMBER(1);
    v_puntaje_min         NUMBER(5,2);

    -- Parametros de entrada
    v_id_usuario NUMBER := 27;  -- Leonardo Avila (tiene intentos previos)
    v_id_eval    NUMBER := 6;   -- Evaluacion: Tarea Analisis Exploratorio (curso 2)

BEGIN
    -- --------------------------------------------------------
    -- PASO 1: Obtener el puntaje minimo de la evaluacion
    -- --------------------------------------------------------
    SELECT puntaje_min
      INTO v_puntaje_min
      FROM EVALUACION
     WHERE id_eval = v_id_eval;

    -- --------------------------------------------------------
    -- PASO 2: Verificar tiempo desde el ultimo intento (RN04)
    -- --------------------------------------------------------
    SELECT MAX(fecha_intento)
      INTO v_ultimo_intento
      FROM RESULTADO_EVALUACION
     WHERE id_usuario = v_id_usuario
       AND id_eval    = v_id_eval;

    IF v_ultimo_intento IS NOT NULL THEN
        v_horas_transcurridas := (SYSDATE - v_ultimo_intento) * 24;

        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] Ultimo intento: ' ||
                             TO_CHAR(v_ultimo_intento, 'DD/MM/YYYY HH24:MI'));
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] Horas transcurridas: ' ||
                             ROUND(v_horas_transcurridas, 2));

        -- RN04: si no han pasado 24 horas, lanzar error
        IF v_horas_transcurridas < 24 THEN
            RAISE_APPLICATION_ERROR(-20010,
                'RN04 VIOLADA: Han pasado solo ' ||
                ROUND(v_horas_transcurridas, 2) ||
                ' horas desde el ultimo intento. ' ||
                'Debe esperar 24 horas para volver a intentarlo.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] Es el primer intento del estudiante en esta evaluacion.');
    END IF;

    -- --------------------------------------------------------
    -- PASO 3: Determinar si el puntaje es aprobatorio
    -- --------------------------------------------------------
    IF v_puntaje >= v_puntaje_min THEN
        v_aprobado := 1;
    ELSE
        v_aprobado := 0;
    END IF;

    -- --------------------------------------------------------
    -- PASO 4: Insertar el nuevo RESULTADO_EVALUACION
    -- --------------------------------------------------------
    v_id_resultado := SEQ_RESULTADO.NEXTVAL;

    INSERT INTO RESULTADO_EVALUACION (
        id_resultado, id_eval, id_usuario,
        puntaje_obtenido, fecha_intento, aprobado
    ) VALUES (
        v_id_resultado, v_id_eval, v_id_usuario,
        v_puntaje, SYSDATE, v_aprobado
    );

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] Paso 4 OK - Resultado registrado: puntaje=' ||
                         v_puntaje || ' | aprobado=' || v_aprobado);

    -- NOTA: El progreso del curso NO se actualiza manualmente aqui.
    -- El trigger trg_actualizar_progreso_curso se encarga de eso
    -- automaticamente cuando se marcan lecciones como completadas
    -- en PROGRESO_LECCION. Actualizarlo manualmente aqui causaria
    -- conflicto con el trigger trg_validar_inscripcion.

    -- --------------------------------------------------------
    -- COMMIT: resultado guardado correctamente
    -- --------------------------------------------------------
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] COMMIT exitoso.');
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] Resultado id=' || v_id_resultado ||
                         ' registrado para usuario id=' || v_id_usuario || '.');

EXCEPTION
    -- --------------------------------------------------------
    -- ROLLBACK: la regla RN04 fue violada o cualquier otro error.
    -- No se guarda el intento ni se modifica ningun otro dato.
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] ROLLBACK aplicado.');
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 3] El intento NO fue registrado.');
END;
/


-- ============================================================
-- ESCENARIO 4 (ROLLBACK FORZADO): Creacion de curso con
-- instructor inexistente
-- ============================================================
-- Contexto de negocio:
--   El administrador intenta crear un nuevo curso con modulos
--   y lecciones en una sola operacion. Si el instructor no
--   existe o esta inactivo, toda la transaccion se revierte:
--   ni el curso, ni los modulos, ni las lecciones quedan en
--   la base de datos.
-- ============================================================

DECLARE
    v_id_curso           NUMBER;
    v_id_modulo_1        NUMBER;
    v_id_modulo_2        NUMBER;
    v_id_leccion         NUMBER;
    v_instructor_activo  NUMBER;

    -- Instructor con id 999 NO EXISTE en el sistema
    v_id_instructor NUMBER := 999;

BEGIN
    -- --------------------------------------------------------
    -- PASO 1: Verificar que el instructor existe y esta activo
    -- --------------------------------------------------------
    SELECT COUNT(*)
      INTO v_instructor_activo
      FROM INSTRUCTOR i
      JOIN USUARIO    u ON u.id_usuario = i.id_usuario
     WHERE i.id_instructor = v_id_instructor
       AND u.activo        = 1;

    IF v_instructor_activo = 0 THEN
        RAISE_APPLICATION_ERROR(-20020,
            'El instructor con id=' || v_id_instructor ||
            ' no existe o su cuenta esta inactiva. ' ||
            'No se puede crear el curso.');
    END IF;

    -- --------------------------------------------------------
    -- PASO 2: Insertar el CURSO
    -- (No se alcanza si el instructor no existe)
    -- --------------------------------------------------------
    v_id_curso := SEQ_CURSO.NEXTVAL;

    INSERT INTO CURSO (
        id_curso, titulo, precio, categoria,
        estado, puntaje_min_cert, fecha_creacion, id_instructor
    ) VALUES (
        v_id_curso,
        'Blockchain y Web3 para Desarrolladores',
        320000, 'Programacion',
        'borrador', 75, SYSDATE,
        v_id_instructor
    );

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] Paso 2 OK - Curso creado con id=' || v_id_curso);

    -- --------------------------------------------------------
    -- PASO 3: Insertar modulos del curso
    -- --------------------------------------------------------
    v_id_modulo_1 := SEQ_MODULO.NEXTVAL;
    INSERT INTO MODULO VALUES (v_id_modulo_1, 'Fundamentos de Blockchain', 1, v_id_curso);

    v_id_modulo_2 := SEQ_MODULO.NEXTVAL;
    INSERT INTO MODULO VALUES (v_id_modulo_2, 'Smart Contracts con Solidity', 2, v_id_curso);

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] Paso 3 OK - 2 modulos creados.');

    -- --------------------------------------------------------
    -- PASO 4: Insertar lecciones en el primer modulo
    -- --------------------------------------------------------
    v_id_leccion := SEQ_LECCION.NEXTVAL;
    INSERT INTO LECCION VALUES (
        v_id_leccion, 'Que es Blockchain y como funciona',
        'video', 'https://cdn.educloud.co/v/bc-01', 22, 1, 1, v_id_modulo_1
    );

    v_id_leccion := SEQ_LECCION.NEXTVAL;
    INSERT INTO LECCION VALUES (
        v_id_leccion, 'Consenso: Proof of Work vs Proof of Stake',
        'video', 'https://cdn.educloud.co/v/bc-02', 28, 2, 1, v_id_modulo_1
    );

    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] Paso 4 OK - 2 lecciones creadas.');

    -- COMMIT (solo se alcanza si el instructor existia)
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] COMMIT exitoso. Curso, modulos y lecciones guardados.');

EXCEPTION
    -- --------------------------------------------------------
    -- ROLLBACK: instructor invalido o cualquier otro error.
    -- Ni el curso, ni los modulos, ni las lecciones persisten.
    -- --------------------------------------------------------
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] ROLLBACK aplicado.');
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] No se creo el curso, modulos ni lecciones.');
        DBMS_OUTPUT.PUT_LINE('[ESCENARIO 4] La base de datos quedo en su estado anterior.');
END;
/


-- ============================================================
-- VERIFICACION FINAL: consultas para confirmar el estado
-- de la base de datos despues de ejecutar los escenarios
-- ============================================================

-- Verificar inscripciones del estudiante 42 (Escenario 1)
SELECT i.id_inscripcion, u.nombre, c.titulo, i.estado, i.progreso_pct, i.fecha_matric
  FROM INSCRIPCION i
  JOIN USUARIO u ON u.id_usuario = i.id_usuario
  JOIN CURSO   c ON c.id_curso   = i.id_curso
 WHERE i.id_usuario = 42
 ORDER BY i.fecha_matric DESC;

-- Verificar certificados del estudiante 34 (Escenario 2)
SELECT ce.id_certificado, u.nombre, c.titulo, ce.cod_verif, ce.fecha_gen
  FROM CERTIFICADO ce
  JOIN USUARIO u ON u.id_usuario = ce.id_usuario
  JOIN CURSO   c ON c.id_curso   = ce.id_curso
 WHERE ce.id_usuario = 34
 ORDER BY ce.fecha_gen DESC;

-- Verificar resultados de evaluacion del usuario 27 (Escenario 3)
SELECT re.id_resultado, u.nombre, e.titulo, re.puntaje_obtenido, re.fecha_intento, re.aprobado
  FROM RESULTADO_EVALUACION re
  JOIN USUARIO    u ON u.id_usuario = re.id_usuario
  JOIN EVALUACION e ON e.id_eval    = re.id_eval
 WHERE re.id_usuario = 27
   AND re.id_eval    = 6
 ORDER BY re.fecha_intento DESC;

-- Verificar que el curso con instructor invalido NO se creo (Escenario 4)
SELECT id_curso, titulo, id_instructor
  FROM CURSO
 WHERE id_instructor = 999;

-- ============================================================
-- FIN DEL SCRIPT 05_transacciones.sql
-- ============================================================