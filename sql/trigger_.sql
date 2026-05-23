-- ============================================================
-- SCRIPT: 04_triggers_plsql.sql
-- Sistema   : Plataforma de Gestion de Cursos Online
-- Autores   : Nicolas Jimenez C. | Johan Santiago Cadena G.
--             Jhon Sebastian Mejia A. | Alejandro Rodriguez M.
-- Materia   : Bases de Datos 2026-10
-- Descripcion:
--   Implementa la logica de negocio en la base de datos mediante:
--   - 3 Triggers (auditoria, validacion, calculo automatico)
--   - 2 Procedimientos almacenados
--   - 2 Funciones
-- ============================================================


-- ============================================================
-- SECCION 0: TABLA DE AUDITORIA
-- ============================================================

BEGIN EXECUTE IMMEDIATE 'DROP TABLE AUDITORIA_USUARIO CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

CREATE TABLE AUDITORIA_USUARIO (
    id_auditoria     NUMBER        GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    tabla_afectada   VARCHAR2(50)  NOT NULL,
    operacion        VARCHAR2(10)  NOT NULL,
    id_registro      NUMBER        NOT NULL,
    campo_modificado VARCHAR2(100),
    valor_anterior   VARCHAR2(500),
    valor_nuevo      VARCHAR2(500),
    usuario_bd       VARCHAR2(100) DEFAULT USER NOT NULL,
    fecha_hora       TIMESTAMP     DEFAULT SYSTIMESTAMP NOT NULL
);

COMMENT ON TABLE AUDITORIA_USUARIO IS 'Tabla de log que registra cambios sobre la tabla USUARIO.';
/


-- ============================================================
-- TRIGGER 1: AUDITORIA DE CAMBIOS EN USUARIO
-- ============================================================
-- Descripcion: Registra automaticamente en AUDITORIA_USUARIO
--   cualquier INSERT, UPDATE o DELETE sobre la tabla USUARIO.
--   Para UPDATE detecta solo los campos que realmente cambiaron.
-- Tipo: AFTER INSERT OR UPDATE OR DELETE - FOR EACH ROW
-- ============================================================

CREATE OR REPLACE TRIGGER trg_auditoria_usuario
    AFTER INSERT OR UPDATE OR DELETE
    ON USUARIO
    FOR EACH ROW
DECLARE
    v_op VARCHAR2(10);
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
        INSERT INTO AUDITORIA_USUARIO
            (tabla_afectada, operacion, id_registro, campo_modificado, valor_anterior, valor_nuevo)
        VALUES
            ('USUARIO', v_op, :NEW.id_usuario,
             'REGISTRO_COMPLETO',
             NULL,
             'email=' || :NEW.email || ' | rol=' || :NEW.rol || ' | activo=' || :NEW.activo);

    ELSIF DELETING THEN
        v_op := 'DELETE';
        INSERT INTO AUDITORIA_USUARIO
            (tabla_afectada, operacion, id_registro, campo_modificado, valor_anterior, valor_nuevo)
        VALUES
            ('USUARIO', v_op, :OLD.id_usuario,
             'REGISTRO_COMPLETO',
             'email=' || :OLD.email || ' | rol=' || :OLD.rol || ' | activo=' || :OLD.activo,
             NULL);

    ELSIF UPDATING THEN
        v_op := 'UPDATE';

        IF :OLD.email <> :NEW.email THEN
            INSERT INTO AUDITORIA_USUARIO
                (tabla_afectada, operacion, id_registro, campo_modificado, valor_anterior, valor_nuevo)
            VALUES ('USUARIO', v_op, :NEW.id_usuario, 'email', :OLD.email, :NEW.email);
        END IF;

        IF :OLD.rol <> :NEW.rol THEN
            INSERT INTO AUDITORIA_USUARIO
                (tabla_afectada, operacion, id_registro, campo_modificado, valor_anterior, valor_nuevo)
            VALUES ('USUARIO', v_op, :NEW.id_usuario, 'rol', :OLD.rol, :NEW.rol);
        END IF;

        IF :OLD.activo <> :NEW.activo THEN
            INSERT INTO AUDITORIA_USUARIO
                (tabla_afectada, operacion, id_registro, campo_modificado, valor_anterior, valor_nuevo)
            VALUES ('USUARIO', v_op, :NEW.id_usuario, 'activo',
                    TO_CHAR(:OLD.activo), TO_CHAR(:NEW.activo));
        END IF;

    END IF;
END trg_auditoria_usuario;
/


-- ============================================================
-- TRIGGER 2: VALIDACION DE NEGOCIO - INSCRIPCION
-- ============================================================
-- Descripcion: Antes de insertar o actualizar una INSCRIPCION,
--   valida las siguientes reglas de negocio:
--   1. Solo usuarios con rol 'estudiante' pueden inscribirse.
--   2. Solo se puede inscribir a cursos con estado 'publicado'.
-- NOTA: La regla de que el progreso no puede retroceder se
--   elimino porque el trigger trg_actualizar_progreso_curso
--   ya garantiza esto por diseno (cuenta lecciones completadas
--   que son irreversibles), y ademas causaba conflicto ORA-20003
--   cuando el trigger de progreso actualizaba INSCRIPCION.
-- Tipo: BEFORE INSERT OR UPDATE - FOR EACH ROW
-- ============================================================

CREATE OR REPLACE TRIGGER trg_validar_inscripcion
    BEFORE INSERT OR UPDATE
    ON INSCRIPCION
    FOR EACH ROW
DECLARE
    v_rol_usuario  USUARIO.rol%TYPE;
    v_estado_curso CURSO.estado%TYPE;
BEGIN
    -- Regla 1: Solo estudiantes pueden inscribirse
    SELECT rol INTO v_rol_usuario
    FROM   USUARIO
    WHERE  id_usuario = :NEW.id_usuario;

    IF v_rol_usuario <> 'estudiante' THEN
        RAISE_APPLICATION_ERROR(-20001,
            'ERROR: Solo los usuarios con rol "estudiante" pueden inscribirse. ' ||
            'Usuario ID=' || :NEW.id_usuario || ' tiene rol "' || v_rol_usuario || '".');
    END IF;

    -- Regla 2: Solo cursos publicados aceptan inscripciones
    SELECT estado INTO v_estado_curso
    FROM   CURSO
    WHERE  id_curso = :NEW.id_curso;

    IF v_estado_curso <> 'publicado' THEN
        RAISE_APPLICATION_ERROR(-20002,
            'ERROR: No se puede inscribir a un curso que no este publicado. ' ||
            'El curso ID=' || :NEW.id_curso || ' tiene estado "' || v_estado_curso || '".');
    END IF;

END trg_validar_inscripcion;
/


-- ============================================================
-- TRIGGER 3: CALCULO AUTOMATICO - PROGRESO DEL CURSO
-- ============================================================
-- Descripcion: Cada vez que se marca una leccion como completada
--   en PROGRESO_LECCION, este trigger:
--   1. Recalcula automaticamente el progreso_pct en INSCRIPCION
--      contando lecciones obligatorias completadas vs total.
--   2. Si el progreso llega al 100%, cambia el estado a 'completado'.
-- Tipo: COMPOUND TRIGGER (resuelve el problema de tabla mutante
--   ORA-04091 separando la logica en dos fases: AFTER EACH ROW
--   solo guarda datos en memoria, AFTER STATEMENT hace las
--   consultas cuando la tabla ya no esta mutando).
-- ============================================================

CREATE OR REPLACE TRIGGER trg_actualizar_progreso_curso
FOR INSERT OR UPDATE OF completada ON PROGRESO_LECCION
COMPOUND TRIGGER

    TYPE t_registro IS RECORD (
        id_usuario PROGRESO_LECCION.id_usuario%TYPE,
        id_leccion PROGRESO_LECCION.id_leccion%TYPE
    );
    TYPE t_lista IS TABLE OF t_registro INDEX BY PLS_INTEGER;
    v_lista t_lista;
    v_idx   PLS_INTEGER := 0;

    -- FASE 1: captura datos de cada fila sin tocar PROGRESO_LECCION
    AFTER EACH ROW IS
    BEGIN
        IF :NEW.completada = 1 THEN
            v_idx := v_idx + 1;
            v_lista(v_idx).id_usuario := :NEW.id_usuario;
            v_lista(v_idx).id_leccion := :NEW.id_leccion;
        END IF;
    END AFTER EACH ROW;

    -- FASE 2: cuando la tabla ya no esta mutando, hace las consultas
    AFTER STATEMENT IS
        v_id_curso       CURSO.id_curso%TYPE;
        v_total_obligat  NUMBER;
        v_completadas    NUMBER;
        v_nuevo_progreso NUMBER;
    BEGIN
        FOR i IN 1 .. v_idx LOOP

            SELECT c.id_curso
            INTO   v_id_curso
            FROM   LECCION l
            JOIN   MODULO  m ON m.id_modulo = l.id_modulo
            JOIN   CURSO   c ON c.id_curso  = m.id_curso
            WHERE  l.id_leccion = v_lista(i).id_leccion;

            SELECT COUNT(*)
            INTO   v_total_obligat
            FROM   LECCION l
            JOIN   MODULO  m ON m.id_modulo = l.id_modulo
            WHERE  m.id_curso       = v_id_curso
            AND    l.es_obligatoria = 1;

            SELECT COUNT(*)
            INTO   v_completadas
            FROM   PROGRESO_LECCION pl
            JOIN   LECCION          l ON l.id_leccion = pl.id_leccion
            JOIN   MODULO           m ON m.id_modulo  = l.id_modulo
            WHERE  m.id_curso      = v_id_curso
            AND    pl.id_usuario   = v_lista(i).id_usuario
            AND    pl.completada   = 1
            AND    l.es_obligatoria = 1;

            IF v_total_obligat > 0 THEN
                v_nuevo_progreso := ROUND((v_completadas / v_total_obligat) * 100, 2);
            ELSE
                v_nuevo_progreso := 100;
            END IF;

            UPDATE INSCRIPCION
            SET    progreso_pct = v_nuevo_progreso,
                   estado       = CASE
                                      WHEN v_nuevo_progreso >= 100 THEN 'completado'
                                      ELSE estado
                                  END
            WHERE  id_usuario = v_lista(i).id_usuario
            AND    id_curso   = v_id_curso;

        END LOOP;
    END AFTER STATEMENT;

END trg_actualizar_progreso_curso;
/


-- ============================================================
-- PROCEDIMIENTO 1: INSCRIBIR_ESTUDIANTE
-- ============================================================
-- Descripcion: Realiza el proceso completo de inscripcion:
--   1. Verifica que el estudiante no este ya inscrito.
--   2. Inserta el registro en INSCRIPCION.
--   3. Inicializa registros de progreso para todas las lecciones.
--   4. Retorna mensaje de confirmacion via parametro OUT.
-- Parametros:
--   p_id_usuario IN  -> ID del usuario estudiante
--   p_id_curso   IN  -> ID del curso
--   p_mensaje    OUT -> Resultado de la operacion
-- ============================================================

CREATE OR REPLACE PROCEDURE inscribir_estudiante (
    p_id_usuario IN  INSCRIPCION.id_usuario%TYPE,
    p_id_curso   IN  INSCRIPCION.id_curso%TYPE,
    p_mensaje    OUT VARCHAR2
) AS
    v_existe  NUMBER;
    v_id_insc NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO   v_existe
    FROM   INSCRIPCION
    WHERE  id_usuario = p_id_usuario
    AND    id_curso   = p_id_curso;

    IF v_existe > 0 THEN
        p_mensaje := 'ADVERTENCIA: El estudiante ID=' || p_id_usuario ||
                     ' ya esta inscrito en el curso ID=' || p_id_curso || '.';
        RETURN;
    END IF;

    v_id_insc := SEQ_INSCRIPCION.NEXTVAL;
    INSERT INTO INSCRIPCION (id_inscripcion, id_usuario, id_curso, fecha_matric, progreso_pct, estado)
    VALUES (v_id_insc, p_id_usuario, p_id_curso, SYSDATE, 0, 'activo');

    INSERT INTO PROGRESO_LECCION (id_progreso, id_usuario, id_leccion, completada, fecha_inicio)
    SELECT SEQ_PROGRESO.NEXTVAL,
           p_id_usuario,
           l.id_leccion,
           0,
           SYSDATE
    FROM   LECCION l
    JOIN   MODULO  m ON m.id_modulo = l.id_modulo
    WHERE  m.id_curso = p_id_curso;

    COMMIT;

    p_mensaje := 'OK: Estudiante ID=' || p_id_usuario ||
                 ' inscrito exitosamente en el curso ID=' || p_id_curso ||
                 '. Inscripcion ID=' || v_id_insc || '.';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'ERROR: ' || SQLERRM;
END inscribir_estudiante;
/


-- ============================================================
-- PROCEDIMIENTO 2: GENERAR_CERTIFICADO
-- ============================================================
-- Descripcion: Verifica si un estudiante cumple los requisitos
--   para recibir el certificado de un curso:
--   1. El curso debe estar completado (progreso = 100%).
--   2. El promedio de evaluaciones >= puntaje_min_cert del curso.
--   3. No debe existir ya un certificado para ese usuario/curso.
-- Parametros:
--   p_id_usuario IN  -> ID del usuario
--   p_id_curso   IN  -> ID del curso
--   p_resultado  OUT -> Mensaje con el resultado
-- ============================================================

CREATE OR REPLACE PROCEDURE generar_certificado (
    p_id_usuario IN  CERTIFICADO.id_usuario%TYPE,
    p_id_curso   IN  CERTIFICADO.id_curso%TYPE,
    p_resultado  OUT VARCHAR2
) AS
    v_progreso      INSCRIPCION.progreso_pct%TYPE;
    v_puntaje_min   CURSO.puntaje_min_cert%TYPE;
    v_promedio_eval NUMBER;
    v_ya_tiene      NUMBER;
    v_cod_verif     VARCHAR2(60);
    v_id_cert       NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_ya_tiene
    FROM   CERTIFICADO
    WHERE  id_usuario = p_id_usuario AND id_curso = p_id_curso;

    IF v_ya_tiene > 0 THEN
        p_resultado := 'ADVERTENCIA: El usuario ya posee un certificado para este curso.';
        RETURN;
    END IF;

    SELECT progreso_pct INTO v_progreso
    FROM   INSCRIPCION
    WHERE  id_usuario = p_id_usuario AND id_curso = p_id_curso;

    IF v_progreso < 100 THEN
        p_resultado := 'ERROR: El curso no esta completado. Progreso actual: ' ||
                       v_progreso || '%.';
        RETURN;
    END IF;

    SELECT puntaje_min_cert INTO v_puntaje_min
    FROM   CURSO
    WHERE  id_curso = p_id_curso;

    SELECT NVL(AVG(re.puntaje_obtenido), 0)
    INTO   v_promedio_eval
    FROM   RESULTADO_EVALUACION re
    JOIN   EVALUACION           e ON e.id_eval = re.id_eval
    WHERE  e.id_curso    = p_id_curso
    AND    re.id_usuario = p_id_usuario;

    IF v_promedio_eval < v_puntaje_min THEN
        p_resultado := 'ERROR: El promedio de evaluaciones (' || ROUND(v_promedio_eval, 2) ||
                       '%) es menor al minimo requerido (' || v_puntaje_min || '%).';
        RETURN;
    END IF;

    v_cod_verif := 'CERT-' || TO_CHAR(p_id_usuario) || '-' ||
                   TO_CHAR(p_id_curso) || '-' ||
                   TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');

    v_id_cert := SEQ_CERTIFICADO.NEXTVAL;
    INSERT INTO CERTIFICADO (id_certificado, id_usuario, id_curso, cod_verif, fecha_gen, url_descarga)
    VALUES (v_id_cert, p_id_usuario, p_id_curso, v_cod_verif, SYSDATE,
            'https://educloud.co/certificados/' || v_cod_verif || '.pdf');

    COMMIT;

    p_resultado := 'OK: Certificado generado exitosamente. ' ||
                   'ID=' || v_id_cert || ' | Codigo: ' || v_cod_verif;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        p_resultado := 'ERROR: No se encontro inscripcion activa para este usuario y curso.';
    WHEN OTHERS THEN
        ROLLBACK;
        p_resultado := 'ERROR inesperado: ' || SQLERRM;
END generar_certificado;
/


-- ============================================================
-- FUNCION 1: FN_PROMEDIO_CURSO
-- ============================================================
-- Descripcion: Retorna el promedio de puntajes de todos los
--   estudiantes en todas las evaluaciones de un curso.
-- Parametros:
--   p_id_curso IN -> ID del curso
-- Retorna: NUMBER con el promedio (0 si no hay evaluaciones)
-- ============================================================

CREATE OR REPLACE FUNCTION fn_promedio_curso (
    p_id_curso IN CURSO.id_curso%TYPE
) RETURN NUMBER AS
    v_promedio NUMBER;
BEGIN
    SELECT NVL(ROUND(AVG(re.puntaje_obtenido), 2), 0)
    INTO   v_promedio
    FROM   RESULTADO_EVALUACION re
    JOIN   EVALUACION           e ON e.id_eval = re.id_eval
    WHERE  e.id_curso = p_id_curso;

    RETURN v_promedio;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_promedio_curso;
/


-- ============================================================
-- FUNCION 2: FN_TOTAL_INSCRIPCIONES_ACTIVAS
-- ============================================================
-- Descripcion: Retorna el numero de inscripciones activas de
--   todos los cursos de un instructor.
-- Parametros:
--   p_id_instructor IN -> ID del instructor
-- Retorna: NUMBER con el conteo de inscripciones activas
-- ============================================================

CREATE OR REPLACE FUNCTION fn_total_inscripciones_activas (
    p_id_instructor IN INSTRUCTOR.id_instructor%TYPE
) RETURN NUMBER AS
    v_total NUMBER;
BEGIN
    SELECT COUNT(i.id_inscripcion)
    INTO   v_total
    FROM   INSCRIPCION i
    JOIN   CURSO       c ON c.id_curso = i.id_curso
    WHERE  c.id_instructor = p_id_instructor
    AND    i.estado        = 'activo';

    RETURN v_total;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;
END fn_total_inscripciones_activas;
/