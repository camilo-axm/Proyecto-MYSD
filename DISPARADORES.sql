/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Disparadores */

/*Valida que un jugador tenga mínimo 5 años antes de registrarse*/
CREATE OR REPLACE TRIGGER trg_validar_edad_jugador
BEFORE INSERT ON Jugador
FOR EACH ROW
DECLARE
    v_fecha DATE;
    v_edad NUMBER;
BEGIN
    SELECT fechaNacimiento
    INTO v_fecha
    FROM Persona
    WHERE idPersona = :NEW.idPersona;

    v_edad := FLOOR(MONTHS_BETWEEN(SYSDATE, v_fecha) / 12);

    IF v_edad < 5 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El jugador debe tener al menos 5 anos.');
    END IF;
END;
/

/*Agrega automáticamente una observación cuando un participante no asiste*/
CREATE OR REPLACE TRIGGER trg_obs_participante
BEFORE INSERT ON Participante
FOR EACH ROW
BEGIN
    IF :NEW.asistencia = 'N' AND :NEW.observaciones IS NULL THEN
        :NEW.observaciones := 'No asistio al entrenamiento';
    END IF;
END;
/

/*Agrega automáticamente una observación cuando un equipo no asiste*/
CREATE OR REPLACE TRIGGER trg_obs_recibe
BEFORE INSERT ON Recibe
FOR EACH ROW
BEGIN
    IF :NEW.asistencia = 'N' AND :NEW.observaciones IS NULL THEN
        :NEW.observaciones := 'Equipo no asistio al entrenamiento';
    END IF;
END;
/

/*Actualiza automáticamente el estado de inscripción cuando un pago es PAGADO*/
CREATE OR REPLACE TRIGGER trg_actualizar_estado_inscripcion
AFTER INSERT ON Pago
FOR EACH ROW
BEGIN
    IF :NEW.estadoPago = 'PAGADO' THEN
        UPDATE Inscripcion
        SET estadoInscripcion = 'ACTIVA'
        WHERE idInscripcion = :NEW.idInscripcion;
    END IF;
END;
/

/*Valida que el número de camiseta sea único dentro de una escuela*/
CREATE OR REPLACE TRIGGER trg_validar_numero_camiseta_equipo
BEFORE INSERT ON Jugador
FOR EACH ROW
DECLARE
    v_existe NUMBER;
    v_id_escuela NUMBER;
BEGIN
    /*Obtiene la escuela asociada al jugador*/
    SELECT idEscuela INTO v_id_escuela
    FROM Inscripcion
    WHERE idPersona = :NEW.idPersona
    AND ROWNUM = 1;
    
    /*verifica que el número de camiseta no esté repetido*/
    SELECT COUNT(*) INTO v_existe
    FROM Jugador j
    JOIN Inscripcion i ON j.idPersona = i.idPersona
    WHERE j.numeroCamiseta = :NEW.numeroCamiseta
    AND i.idEscuela = v_id_escuela
    AND j.idPersona != :NEW.idPersona;
    
    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'El numero de camiseta ya existe en esta equipo.');
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'El jugador debe tener una inscripcion antes de ser registrado como jugador.');
END;
/

/*Asigna automáticamente la fecha actual cuando un pago PAGADO no tiene fecha*/
CREATE OR REPLACE TRIGGER trg_fecha_pago_automatica
BEFORE INSERT ON Pago
FOR EACH ROW
BEGIN
    IF :NEW.estadoPago = 'PAGADO' AND :NEW.fechaPago IS NULL THEN
        :NEW.fechaPago := SYSDATE;
    END IF;
END;
/




/* CICLO2 */

/*TRIGGER 1: VALIDAR PLANIFICACION AL INSERTAR/ACTUALIZAR
Asegurar que el entrenamiento existe antes de crear la planificación*/
CREATE OR REPLACE TRIGGER tr_validar_planificacion
BEFORE INSERT OR UPDATE ON Planificacion
FOR EACH ROW
DECLARE
    v_existe NUMBER;
BEGIN
    /* Verificar que el entrenamiento exista */
    SELECT 1
    INTO v_existe
    FROM Entrenamiento
    WHERE idEntrenamiento = :NEW.idEntrenamiento;

    /* Asignar fecha automática */
    IF INSERTING THEN
        :NEW.fechaCreacion := SYSDATE;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20101,
            'ERROR: El entrenamiento no existe.'
        );
END;
/

/* TRIGGER 2: VALIDAR EVALUACION AL INSERTAR/ACTUALIZAR
Asegurar que entrenador y jugador existen, y validar calificación*/
CREATE OR REPLACE TRIGGER tr_validar_evaluacion
BEFORE INSERT OR UPDATE ON Evaluacion
FOR EACH ROW
DECLARE
    v_existe NUMBER;
BEGIN

    /* Verificar entrenador */
    SELECT 1
    INTO v_existe
    FROM Entrenador
    WHERE idPersona = :NEW.idEntrenador;

    /* Verificar jugador */
    SELECT 1
    INTO v_existe
    FROM Jugador
    WHERE idPersona = :NEW.idJugador;

    /* Validar que no sean la misma persona */
    IF :NEW.idEntrenador = :NEW.idJugador THEN
        RAISE_APPLICATION_ERROR(
            -20203,
            'ERROR: El entrenador y el jugador no pueden ser la misma persona.'
        );
    END IF;

    /* Fecha automática */
    IF INSERTING THEN
        :NEW.fechaEvaluacion := SYSDATE;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(
            -20201,
            'ERROR: El entrenador o el jugador no existe.'
        );
END;
/

/*TRIGGER 3: GENERAR ESTADO DE CUENTA AL CREAR INSCRIPCION
Crear automáticamente un registro de estado de cuenta cuando hay una inscripción*/
CREATE OR REPLACE TRIGGER tr_generar_estado_cuenta
AFTER INSERT ON Inscripcion
FOR EACH ROW
DECLARE
    v_totalPagado NUMBER(10,2) := 0;
    v_totalPendiente NUMBER(10,2) := 0;
    v_id_estado_cuenta NUMBER;
BEGIN

    /* Calcular totales de pagos para esta inscripción */
    SELECT NVL(SUM(CASE WHEN estadoPago = 'PAGADO' THEN monto ELSE 0 END), 0),
           NVL(SUM(CASE WHEN estadoPago = 'PENDIENTE' THEN monto ELSE 0 END), 0)
    INTO v_totalPagado, v_totalPendiente
    FROM Pago
    WHERE idInscripcion = :NEW.idInscripcion;

    /* Obtener siguiente ID */
    SELECT NVL(MAX(idEstadoCuenta), 0) + 1
    INTO v_id_estado_cuenta
    FROM EstadoCuenta;

    /* Insertar estado de cuenta */
    INSERT INTO EstadoCuenta (
        idEstadoCuenta,
        fechaGeneracion,
        totalPagado,
        totalPendiente,
        idInscripcion
    )
    VALUES (
        v_id_estado_cuenta,
        SYSDATE,
        v_totalPagado,
        v_totalPendiente,
        :NEW.idInscripcion
    );

END tr_generar_estado_cuenta;
/


/* TRIGGER 4: VALIDAR CAMBIOS DE ESTADO EN CONVOCATORIA
Prevenir transiciones de estado inválidas en convocatorias*/
CREATE OR REPLACE TRIGGER tr_validar_estado_convocatoria
BEFORE UPDATE ON Convocatoria
FOR EACH ROW
BEGIN

    IF :OLD.estadoEvento = 'REALIZADA'
       AND :NEW.estadoEvento = 'CANCELADA' THEN

        RAISE_APPLICATION_ERROR(
            -20401,
            'ERROR: No se puede cancelar una convocatoria realizada.'
        );

    END IF;

END tr_validar_estado_convocatoria;
/

