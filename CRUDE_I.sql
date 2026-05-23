/* PROYECTO: Formando Campeones CRUDI
   CICLO 1 - IMPLEMENTACIÓN SEGÚN UML
   OBJETIVO: Implementación de 6 packages de componentes + 2 de apoyo
*/

/* PACKAGE BODY: PC_PERSONA */
CREATE OR REPLACE PACKAGE BODY PC_PERSONA AS

  PROCEDURE AD_PERSONA(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Persona WHERE documento = p_documento;
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20014, 'Documento ya existe: ' || p_documento);
    END IF;
    INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
    VALUES (p_idPersona, p_documento, p_nombres, p_apellidos, p_fechaNacimiento, p_telefono, p_correo);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20017, 'ID Persona duplicado: ' || p_idPersona);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20018, 'Error en AD_PERSONA: ' || SQLERRM);
  END AD_PERSONA;

  PROCEDURE MO_PERSONA(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  ) IS
  BEGIN
    UPDATE Persona
    SET documento = p_documento,
        nombres = p_nombres,
        apellidos = p_apellidos,
        fechaNacimiento = p_fechaNacimiento,
        telefono = p_telefono,
        correo = p_correo
    WHERE idPersona = p_idPersona;
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20021, 'Persona no encontrada: ' || p_idPersona);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20022, 'Error en MO_PERSONA: ' || SQLERRM);
  END MO_PERSONA;

  PROCEDURE EL_PERSONA(p_idPersona IN NUMBER) IS
  BEGIN
    DELETE FROM Persona WHERE idPersona = p_idPersona;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20024, 'Persona no encontrada: ' || p_idPersona);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20025, 'Error en EL_PERSONA: ' || SQLERRM);
  END EL_PERSONA;

  FUNCTION CO_PERSONA RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo
    FROM Persona
    ORDER BY nombres, apellidos;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20026, 'Error en CO_PERSONA: ' || SQLERRM);
  END CO_PERSONA;

END PC_PERSONA;
/

/* PACKAGE BODY: PC_EQUIPO */
CREATE OR REPLACE PACKAGE BODY PC_EQUIPO AS

  PROCEDURE AD_EQUIPO(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Escuela WHERE idEscuela = p_idEscuela;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20027, 'Escuela no existe: ' || p_idEscuela);
    END IF;
    SELECT COUNT(*) INTO v_count FROM Categoria WHERE idCategoria = p_idCategoria;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20028, 'Categoría no existe: ' || p_idCategoria);
    END IF;

    INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
    VALUES (p_idEquipo, p_nombre, p_estadoEquipo, p_idEscuela, p_idCategoria);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20030, 'ID Equipo duplicado: ' || p_idEquipo);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20031, 'Error en AD_EQUIPO: ' || SQLERRM);
  END AD_EQUIPO;

  PROCEDURE MO_EQUIPO(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  ) IS
  BEGIN
    UPDATE Equipo
    SET nombre = p_nombre,
        estadoEquipo = p_estadoEquipo,
        idEscuela = p_idEscuela,
        idCategoria = p_idCategoria
    WHERE idEquipo = p_idEquipo;
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20035, 'Equipo no encontrado: ' || p_idEquipo);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20036, 'Error en MO_EQUIPO: ' || SQLERRM);
  END MO_EQUIPO;

  PROCEDURE EL_EQUIPO(p_idEquipo IN NUMBER) IS
  BEGIN
    DELETE FROM Equipo WHERE idEquipo = p_idEquipo;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20038, 'Equipo no encontrado: ' || p_idEquipo);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20039, 'Error en EL_EQUIPO: ' || SQLERRM);
  END EL_EQUIPO;

  FUNCTION CO_EQUIPO RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT eq.idEquipo, eq.nombre, eq.estadoEquipo, e.nombre AS escuela, c.nombre AS categoria
    FROM Equipo eq
    JOIN Escuela e ON eq.idEscuela = e.idEscuela
    JOIN Categoria c ON eq.idCategoria = c.idCategoria
    ORDER BY e.nombre, eq.nombre;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20040, 'Error en CO_EQUIPO: ' || SQLERRM);
  END CO_EQUIPO;

END PC_EQUIPO;
/

/* PACKAGE BODY: PC_INSCRIPCION */
CREATE OR REPLACE PACKAGE BODY PC_INSCRIPCION AS

  PROCEDURE AD_INSCRIPCION(
    p_idInscripcion IN NUMBER,
    p_fechaInscripcion IN DATE,
    p_estadoInscripcion IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEscuela IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    IF p_fechaInscripcion > TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(-20041, 'Fecha de inscripción no puede ser futura');
    END IF;
    SELECT COUNT(*) INTO v_count FROM Inscripcion
    WHERE idPersona = p_idPersona AND idEscuela = p_idEscuela 
          AND estadoInscripcion = 'ACTIVA';
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20042, 'Persona ya tiene inscripción activa en esta escuela');
    END IF;

    INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
    VALUES (p_idInscripcion, p_fechaInscripcion, p_estadoInscripcion, p_idPersona, p_idEscuela);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20043, 'ID Inscripción duplicado: ' || p_idInscripcion);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20044, 'Error en AD_INSCRIPCION: ' || SQLERRM);
  END AD_INSCRIPCION;

  PROCEDURE EL_INSCRIPCION(p_idInscripcion IN NUMBER) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Pago WHERE idInscripcion = p_idInscripcion;
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20045, 'No puede eliminar inscripción con pagos registrados');
    END IF;

    DELETE FROM Inscripcion WHERE idInscripcion = p_idInscripcion;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20046, 'Inscripción no encontrada: ' || p_idInscripcion);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20047, 'Error en EL_INSCRIPCION: ' || SQLERRM);
  END EL_INSCRIPCION;

  FUNCTION CO_INSCRIPCION RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT i.idInscripcion, i.fechaInscripcion, i.estadoInscripcion, 
           pe.nombres, pe.apellidos, e.nombre AS escuela
    FROM Inscripcion i
    JOIN Persona pe ON i.idPersona = pe.idPersona
    JOIN Escuela e ON i.idEscuela = e.idEscuela
    ORDER BY i.fechaInscripcion DESC;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20048, 'Error en CO_INSCRIPCION: ' || SQLERRM);
  END CO_INSCRIPCION;

END PC_INSCRIPCION;
/

/* PACKAGE BODY: PC_PAGO */
CREATE OR REPLACE PACKAGE BODY PC_PAGO AS

  PROCEDURE AD_PAGO(
    p_idPago IN NUMBER,
    p_fechaPago IN DATE,
    p_monto IN NUMBER,
    p_estadoPago IN VARCHAR2,
    p_metodoPago IN VARCHAR2,
    p_idInscripcion IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Inscripcion WHERE idInscripcion = p_idInscripcion;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20049, 'Inscripción no existe: ' || p_idInscripcion);
    END IF;
    IF p_monto <= 0 THEN
      RAISE_APPLICATION_ERROR(-20050, 'Monto debe ser mayor a 0');
    END IF;
    IF p_metodoPago NOT IN ('EFECTIVO', 'TRANSFERENCIA', 'TARJETA') THEN
      RAISE_APPLICATION_ERROR(-20051, 'Método de pago inválido. Use: EFECTIVO, TRANSFERENCIA, TARJETA');
    END IF;

    INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
    VALUES (p_idPago, p_fechaPago, p_monto, p_estadoPago, p_metodoPago, p_idInscripcion);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20052, 'ID Pago duplicado: ' || p_idPago);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20053, 'Error en AD_PAGO: ' || SQLERRM);
  END AD_PAGO;

  PROCEDURE EL_PAGO(p_idPago IN NUMBER) IS
    v_estadoActual VARCHAR2(20);
  BEGIN
    SELECT estadoPago INTO v_estadoActual FROM Pago WHERE idPago = p_idPago;
    IF v_estadoActual = 'PAGADO' THEN
      RAISE_APPLICATION_ERROR(-20054, 'No puede eliminar un pago confirmado');
    END IF;

    DELETE FROM Pago WHERE idPago = p_idPago;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20055, 'Pago no encontrado: ' || p_idPago);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20056, 'Error en EL_PAGO: ' || SQLERRM);
  END EL_PAGO;

  FUNCTION CO_PAGO RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT p.idPago, p.fechaPago, p.monto, p.estadoPago, p.metodoPago, i.idInscripcion
    FROM Pago p
    JOIN Inscripcion i ON p.idInscripcion = i.idInscripcion
    ORDER BY p.fechaPago DESC;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20057, 'Error en CO_PAGO: ' || SQLERRM);
  END CO_PAGO;

END PC_PAGO;
/

/* PACKAGE BODY: PC_ASISTENCIA */
CREATE OR REPLACE PACKAGE BODY PC_ASISTENCIA AS

  PROCEDURE AD_ASISTENCIA(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_rol IN VARCHAR2,
    p_observaciones IN VARCHAR2
  ) IS
  BEGIN
    INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
    VALUES (p_idPersona, p_idEntrenamiento, p_asistencia, p_rol, p_observaciones);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20058, 'Participante ya existe en este entrenamiento');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20059, 'Error en AD_ASISTENCIA: ' || SQLERRM);
  END AD_ASISTENCIA;

  PROCEDURE MO_ASISTENCIA(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_observaciones IN VARCHAR2
  ) IS
  BEGIN
    UPDATE Participante
    SET asistencia = p_asistencia,
        observaciones = p_observaciones
    WHERE idPersona = p_idPersona AND idEntrenamiento = p_idEntrenamiento;
    
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20060, 'Participante no encontrado');
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20061, 'Error en MO_ASISTENCIA: ' || SQLERRM);
  END MO_ASISTENCIA;

  FUNCTION CO_ASISTENCIA RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT p.idPersona, p.idEntrenamiento, p.asistencia, p.rol, p.observaciones, pe.nombres
    FROM Participante p
    JOIN Persona pe ON p.idPersona = pe.idPersona
    ORDER BY p.idEntrenamiento, pe.nombres;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20062, 'Error en CO_ASISTENCIA: ' || SQLERRM);
  END CO_ASISTENCIA;

END PC_ASISTENCIA;
/

/* PACKAGE BODY: PC_ENTRENAMIENTO */
CREATE OR REPLACE PACKAGE BODY PC_ENTRENAMIENTO AS

  PROCEDURE AD_ENTRENAMIENTO(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_count FROM Equipo WHERE idEquipo = p_idEquipo;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20063, 'Equipo no existe: ' || p_idEquipo);
    END IF;

    INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
    VALUES (p_idEntrenamiento, p_fecha, p_hora, p_lugar, p_estado, p_idEquipo);
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20066, 'ID Entrenamiento duplicado: ' || p_idEntrenamiento);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20067, 'Error en AD_ENTRENAMIENTO: ' || SQLERRM);
  END AD_ENTRENAMIENTO;

  PROCEDURE MO_ENTRENAMIENTO(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  ) IS
  BEGIN
    UPDATE Entrenamiento
    SET fecha = p_fecha,
        hora = p_hora,
        lugar = p_lugar,
        estado = p_estado,
        idEquipo = p_idEquipo
    WHERE idEntrenamiento = p_idEntrenamiento;
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20069, 'Entrenamiento no encontrado: ' || p_idEntrenamiento);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20070, 'Error en MO_ENTRENAMIENTO: ' || SQLERRM);
  END MO_ENTRENAMIENTO;

  PROCEDURE EL_ENTRENAMIENTO(p_idEntrenamiento IN NUMBER) IS
  BEGIN
    DELETE FROM Entrenamiento WHERE idEntrenamiento = p_idEntrenamiento;
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20073, 'Entrenamiento no encontrado: ' || p_idEntrenamiento);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20074, 'Error en EL_ENTRENAMIENTO: ' || SQLERRM);
  END EL_ENTRENAMIENTO;

  FUNCTION CO_ENTRENAMIENTO RETURN SYS_REFCURSOR IS
    v_cursor SYS_REFCURSOR;
  BEGIN
    OPEN v_cursor FOR
    SELECT e.idEntrenamiento, e.fecha, e.hora, e.lugar, e.estado, eq.nombre AS equipo
    FROM Entrenamiento e
    JOIN Equipo eq ON e.idEquipo = eq.idEquipo
    ORDER BY e.fecha DESC;
    RETURN v_cursor;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20075, 'Error en CO_ENTRENAMIENTO: ' || SQLERRM);
  END CO_ENTRENAMIENTO;

END PC_ENTRENAMIENTO;
/




/*Ciclo 2*/

/*PACKAGE BODY: PC_PLANIFICACION*/
CREATE OR REPLACE PACKAGE BODY PC_PLANIFICACION AS

  PROCEDURE AD_PLANIFICACION(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER,
    p_idEntrenamiento IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN

    /* Validar que el título no esté vacío */
    IF LENGTH(TRIM(p_titulo)) = 0 THEN
      RAISE_APPLICATION_ERROR(
        -20301,
        'ERROR: El título de la planificación no puede estar vacío.'
      );
    END IF;

    /* Validar que la duración sea mayor a 0 */
    IF p_duracion <= 0 THEN
      RAISE_APPLICATION_ERROR(
        -20302,
        'ERROR: La duración debe ser mayor a 0 minutos.'
      );
    END IF;

    /* Validar que el objetivo tenga mínimo 10 caracteres */
    IF LENGTH(TRIM(p_objetivo)) < 10 THEN
      RAISE_APPLICATION_ERROR(
        -20303,
        'ERROR: El objetivo debe tener al menos 10 caracteres.'
      );
    END IF;

    /* Validar que el entrenamiento existe */
    SELECT COUNT(*)
    INTO v_count
    FROM Entrenamiento
    WHERE idEntrenamiento = p_idEntrenamiento;

    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(
        -20304,
        'ERROR: El entrenamiento no existe.'
      );
    END IF;

    /* Insertar planificación */
    INSERT INTO Planificacion (
      idPlanificacion,
      titulo,
      descripcion,
      objetivo,
      duracion,
      fechaCreacion,
      idEntrenamiento
    )
    VALUES (
      p_idPlanificacion,
      p_titulo,
      p_descripcion,
      p_objetivo,
      p_duracion,
      SYSDATE,
      p_idEntrenamiento
    );

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END AD_PLANIFICACION;


  PROCEDURE MO_PLANIFICACION(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER
  ) IS
  BEGIN

    /* Validar duración */
    IF p_duracion <= 0 THEN
      RAISE_APPLICATION_ERROR(
        -20305,
        'ERROR: La duración debe ser mayor a 0 minutos.'
      );
    END IF;

    /* Validar objetivo */
    IF LENGTH(TRIM(p_objetivo)) = 0 THEN
      RAISE_APPLICATION_ERROR(
        -20306,
        'ERROR: El objetivo no puede estar vacío.'
      );
    END IF;

    /* Actualizar planificación */
    UPDATE Planificacion
    SET titulo = p_titulo,
        descripcion = p_descripcion,
        objetivo = p_objetivo,
        duracion = p_duracion
    WHERE idPlanificacion = p_idPlanificacion;

    /* Validar que exista la planificación */
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(
        -20308,
        'ERROR: La planificación no existe.'
      );
    END IF;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END MO_PLANIFICACION;


  PROCEDURE EL_PLANIFICACION(
    p_idPlanificacion IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN

    /* Validar existencia */
    SELECT COUNT(*)
    INTO v_count
    FROM Planificacion
    WHERE idPlanificacion = p_idPlanificacion;

    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(
        -20307,
        'ERROR: La planificación no existe.'
      );
    END IF;

    /* Eliminar planificación */
    DELETE FROM Planificacion
    WHERE idPlanificacion = p_idPlanificacion;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END EL_PLANIFICACION;


  FUNCTION CO_PLANIFICACION
    RETURN SYS_REFCURSOR
  IS
    v_cursor SYS_REFCURSOR;
  BEGIN

    OPEN v_cursor FOR
      SELECT
        idPlanificacion,
        titulo,
        descripcion,
        objetivo,
        duracion,
        fechaCreacion,
        idEntrenamiento
      FROM Planificacion
      ORDER BY fechaCreacion DESC;

    RETURN v_cursor;

  END CO_PLANIFICACION;

END PC_PLANIFICACION;
/



/*PACKAGE BODY: PC_ESTADOCUENTA*/
CREATE OR REPLACE PACKAGE BODY PC_ESTADOCUENTA AS

  PROCEDURE AD_ESTADOCUENTA(
    p_idEstadoCuenta IN NUMBER,
    p_totalPagado IN NUMBER,
    p_totalPendiente IN NUMBER,
    p_idInscripcion IN NUMBER
  ) IS
    v_existe NUMBER;
  BEGIN

    /* Validar inscripción */
    SELECT 1
    INTO v_existe
    FROM Inscripcion
    WHERE idInscripcion = p_idInscripcion;

    /* Validar que no exista ya un estado de cuenta */
    SELECT COUNT(*)
    INTO v_existe
    FROM EstadoCuenta
    WHERE idInscripcion = p_idInscripcion;

    IF v_existe > 0 THEN
      RAISE_APPLICATION_ERROR(
        -20401,
        'ERROR: Ya existe un estado de cuenta para esta inscripción.'
      );
    END IF;

    /* Insertar estado de cuenta */
    INSERT INTO EstadoCuenta (
      idEstadoCuenta,
      fechaGeneracion,
      totalPagado,
      totalPendiente,
      idInscripcion
    )
    VALUES (
      p_idEstadoCuenta,
      SYSDATE,
      p_totalPagado,
      p_totalPendiente,
      p_idInscripcion
    );

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20402,
        'ERROR: La inscripción no existe.'
      );
  END AD_ESTADOCUENTA;


  PROCEDURE MO_ESTADOCUENTA(
    p_idEstadoCuenta IN NUMBER,
    p_totalPagado IN NUMBER,
    p_totalPendiente IN NUMBER
  ) IS
    v_total_actual NUMBER;
  BEGIN

    /* Obtener total actual */
    SELECT totalPagado
    INTO v_total_actual
    FROM EstadoCuenta
    WHERE idEstadoCuenta = p_idEstadoCuenta;

    /* Validar que el total pagado no disminuya */
    IF p_totalPagado < v_total_actual THEN
      RAISE_APPLICATION_ERROR(
        -20403,
        'ERROR: El total pagado no puede disminuir.'
      );
    END IF;

    /* Actualizar */
    UPDATE EstadoCuenta
    SET totalPagado = p_totalPagado,
        totalPendiente = p_totalPendiente
    WHERE idEstadoCuenta = p_idEstadoCuenta;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20404,
        'ERROR: El estado de cuenta no existe.'
      );
  END MO_ESTADOCUENTA;


  PROCEDURE EL_ESTADOCUENTA(
    p_idEstadoCuenta IN NUMBER
  ) IS
    v_existe NUMBER;
  BEGIN

    /* Validar existencia */
    SELECT 1
    INTO v_existe
    FROM EstadoCuenta
    WHERE idEstadoCuenta = p_idEstadoCuenta;

    /* Eliminar */
    DELETE FROM EstadoCuenta
    WHERE idEstadoCuenta = p_idEstadoCuenta;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20405,
        'ERROR: El estado de cuenta no existe.'
      );
  END EL_ESTADOCUENTA;


  FUNCTION CO_ESTADOCUENTA
    RETURN SYS_REFCURSOR
  IS
    v_cursor SYS_REFCURSOR;
  BEGIN

    OPEN v_cursor FOR
      SELECT
        idEstadoCuenta,
        fechaGeneracion,
        totalPagado,
        totalPendiente,
        idInscripcion
      FROM EstadoCuenta
      ORDER BY fechaGeneracion DESC;

    RETURN v_cursor;

  END CO_ESTADOCUENTA;

END PC_ESTADOCUENTA;
/

/*PACKAGE BODY: PC_EVALUACION*/
CREATE OR REPLACE PACKAGE BODY PC_EVALUACION AS

  PROCEDURE AD_EVALUACION(
    p_idEvaluacion IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_calificacion IN NUMBER,
    p_idEntrenador IN NUMBER,
    p_idJugador IN NUMBER
  ) IS
    v_existe NUMBER;
  BEGIN

    /* Validar descripción */
    IF LENGTH(TRIM(p_descripcion)) < 10 THEN
      RAISE_APPLICATION_ERROR(
        -20501,
        'ERROR: La descripción debe tener al menos 10 caracteres.'
      );
    END IF;

    /* Validar entrenador */
    SELECT 1
    INTO v_existe
    FROM Entrenador
    WHERE idPersona = p_idEntrenador;

    /* Validar jugador */
    SELECT 1
    INTO v_existe
    FROM Jugador
    WHERE idPersona = p_idJugador;

    /* Validar que no sean la misma persona */
    IF p_idEntrenador = p_idJugador THEN
      RAISE_APPLICATION_ERROR(
        -20502,
        'ERROR: El entrenador y el jugador no pueden ser la misma persona.'
      );
    END IF;

    /* Validar evaluación duplicada en el mismo día */
    SELECT COUNT(*)
    INTO v_existe
    FROM Evaluacion
    WHERE idJugador = p_idJugador
      AND TRUNC(fechaEvaluacion) = TRUNC(SYSDATE);

    IF v_existe > 0 THEN
      RAISE_APPLICATION_ERROR(
        -20503,
        'ERROR: Ya existe una evaluación para este jugador en la fecha actual.'
      );
    END IF;

    /* Insertar evaluación */
    INSERT INTO Evaluacion (
      idEvaluacion,
      fechaEvaluacion,
      descripcion,
      calificacion,
      idEntrenador,
      idJugador
    )
    VALUES (
      p_idEvaluacion,
      SYSDATE,
      p_descripcion,
      p_calificacion,
      p_idEntrenador,
      p_idJugador
    );

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20504,
        'ERROR: El entrenador o el jugador no existe.'
      );
  END AD_EVALUACION;


  PROCEDURE MO_EVALUACION(
    p_idEvaluacion IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_calificacion IN NUMBER
  ) IS
    v_existe NUMBER;
  BEGIN

    /* Validar existencia */
    SELECT 1
    INTO v_existe
    FROM Evaluacion
    WHERE idEvaluacion = p_idEvaluacion;

    /* Validar descripción */
    IF TRIM(p_descripcion) IS NULL THEN
      RAISE_APPLICATION_ERROR(
        -20505,
        'ERROR: La descripción no puede estar vacía.'
      );
    END IF;

    /* Actualizar evaluación */
    UPDATE Evaluacion
    SET descripcion = p_descripcion,
        calificacion = p_calificacion
    WHERE idEvaluacion = p_idEvaluacion;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20506,
        'ERROR: La evaluación no existe.'
      );
  END MO_EVALUACION;


  PROCEDURE EL_EVALUACION(
    p_idEvaluacion IN NUMBER
  ) IS
    v_existe NUMBER;
  BEGIN

    /* Validar existencia */
    SELECT 1
    INTO v_existe
    FROM Evaluacion
    WHERE idEvaluacion = p_idEvaluacion;

    /* Eliminar evaluación */
    DELETE FROM Evaluacion
    WHERE idEvaluacion = p_idEvaluacion;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20507,
        'ERROR: La evaluación no existe.'
      );
  END EL_EVALUACION;


  FUNCTION CO_EVALUACION
    RETURN SYS_REFCURSOR
  IS
    v_cursor SYS_REFCURSOR;
  BEGIN

    OPEN v_cursor FOR
      SELECT
        idEvaluacion,
        fechaEvaluacion,
        descripcion,
        calificacion,
        idEntrenador,
        idJugador
      FROM Evaluacion
      ORDER BY fechaEvaluacion DESC;

    RETURN v_cursor;

  END CO_EVALUACION;

END PC_EVALUACION;
/


/*PACKAGE BODY: PC_CONVOCATORIA*/
CREATE OR REPLACE PACKAGE BODY PC_CONVOCATORIA AS

  PROCEDURE AD_CONVOCATORIA(
    p_idConvocatoria IN NUMBER,
    p_fechaEvento IN DATE,
    p_lugarEvento IN VARCHAR2,
    p_tipoEvento IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_estadoEvento IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEquipo IN NUMBER
  ) IS
    v_existe NUMBER;
  BEGIN

    /* Validar fecha */
    IF p_fechaEvento < TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(
        -20601,
        'ERROR: La fecha del evento no puede ser menor a la fecha actual.'
      );
    END IF;

    /* Validar lugar */
    IF TRIM(p_lugarEvento) IS NULL THEN
      RAISE_APPLICATION_ERROR(
        -20602,
        'ERROR: El lugar del evento no puede estar vacío.'
      );
    END IF;

    /* Validar persona */
    SELECT 1
    INTO v_existe
    FROM Persona
    WHERE idPersona = p_idPersona;

    /* Validar equipo */
    SELECT 1
    INTO v_existe
    FROM Equipo
    WHERE idEquipo = p_idEquipo;

    /* Validar convocatoria duplicada */
    SELECT COUNT(*)
    INTO v_existe
    FROM Convocatoria
    WHERE fechaEvento = p_fechaEvento
      AND lugarEvento = p_lugarEvento
      AND tipoEvento = p_tipoEvento;

    IF v_existe > 0 THEN
      RAISE_APPLICATION_ERROR(
        -20603,
        'ERROR: Ya existe una convocatoria con la misma fecha, lugar y tipo.'
      );
    END IF;

    /* Insertar convocatoria */
    INSERT INTO Convocatoria (
      idConvocatoria,
      fechaEvento,
      lugarEvento,
      tipoEvento,
      descripcion,
      estadoEvento,
      idPersona,
      idEquipo
    )
    VALUES (
      p_idConvocatoria,
      p_fechaEvento,
      p_lugarEvento,
      p_tipoEvento,
      p_descripcion,
      p_estadoEvento,
      p_idPersona,
      p_idEquipo
    );

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20604,
        'ERROR: La persona o el equipo no existen.'
      );
  END AD_CONVOCATORIA;


  PROCEDURE MO_CONVOCATORIA(
    p_idConvocatoria IN NUMBER,
    p_fechaEvento IN DATE,
    p_lugarEvento IN VARCHAR2,
    p_tipoEvento IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_estadoEvento IN VARCHAR2
  ) IS
    v_estado_actual VARCHAR2(30);
  BEGIN

    /* Obtener estado actual */
    SELECT estadoEvento
    INTO v_estado_actual
    FROM Convocatoria
    WHERE idConvocatoria = p_idConvocatoria;

    /* Validar modificación */
    IF v_estado_actual IN ('REALIZADA', 'CANCELADA') THEN
      RAISE_APPLICATION_ERROR(
        -20605,
        'ERROR: No se puede modificar una convocatoria finalizada o cancelada.'
      );
    END IF;

    /* Validar fecha */
    IF p_fechaEvento < TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(
        -20606,
        'ERROR: La fecha del evento no puede ser menor a la fecha actual.'
      );
    END IF;

    /* Validar lugar */
    IF TRIM(p_lugarEvento) IS NULL THEN
      RAISE_APPLICATION_ERROR(
        -20607,
        'ERROR: El lugar del evento no puede estar vacío.'
      );
    END IF;

    /* Actualizar convocatoria */
    UPDATE Convocatoria
    SET fechaEvento = p_fechaEvento,
        lugarEvento = p_lugarEvento,
        tipoEvento = p_tipoEvento,
        descripcion = p_descripcion,
        estadoEvento = p_estadoEvento
    WHERE idConvocatoria = p_idConvocatoria;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20608,
        'ERROR: La convocatoria no existe.'
      );
  END MO_CONVOCATORIA;


  PROCEDURE EL_CONVOCATORIA(
    p_idConvocatoria IN NUMBER
  ) IS
    v_existe NUMBER;
  BEGIN

    /* Validar existencia */
    SELECT 1
    INTO v_existe
    FROM Convocatoria
    WHERE idConvocatoria = p_idConvocatoria;

    /* Eliminar convocatoria */
    DELETE FROM Convocatoria
    WHERE idConvocatoria = p_idConvocatoria;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(
        -20609,
        'ERROR: La convocatoria no existe.'
      );
  END EL_CONVOCATORIA;


  FUNCTION CO_CONVOCATORIA
    RETURN SYS_REFCURSOR
  IS
    v_cursor SYS_REFCURSOR;
  BEGIN

    OPEN v_cursor FOR
      SELECT
        idConvocatoria,
        fechaEvento,
        lugarEvento,
        tipoEvento,
        descripcion,
        estadoEvento,
        idPersona,
        idEquipo
      FROM Convocatoria
      ORDER BY fechaEvento DESC;

    RETURN v_cursor;

  END CO_CONVOCATORIA;

END PC_CONVOCATORIA;
/