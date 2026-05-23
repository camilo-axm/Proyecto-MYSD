/* PA_ADMINISTRADOR BODY - SQL directo sobre tablas */
CREATE OR REPLACE PACKAGE BODY PA_ADMINISTRADOR AS

    /* PERSONAS */
    PROCEDURE personasAd(
        idPersona IN NUMBER, documento IN VARCHAR2, nombres IN VARCHAR2,
        apellidos IN VARCHAR2, fechaNacimiento IN DATE, telefono IN VARCHAR2, correo IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Persona VALUES (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20010, 'Error en personasAd: ' || SQLERRM);
    END personasAd;

    PROCEDURE personasMod(
        idPersona IN NUMBER, documento IN VARCHAR2, nombres IN VARCHAR2,
        apellidos IN VARCHAR2, telefono IN VARCHAR2, correo IN VARCHAR2
    ) IS
        v_id     NUMBER := idPersona;
        v_doc    VARCHAR2(10) := documento;
        v_nom    VARCHAR2(50) := nombres;
        v_ape    VARCHAR2(50) := apellidos;
        v_tel    VARCHAR2(20) := telefono;
        v_email  VARCHAR2(100) := correo;
    BEGIN
        UPDATE Persona SET
            documento=v_doc, nombres=v_nom, apellidos=v_ape,
            telefono=v_tel, correo=v_email
        WHERE idPersona=v_id;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20011, 'Error en personasMod: ' || SQLERRM);
    END personasMod;

    PROCEDURE personasEli(idPersona IN NUMBER) IS
    BEGIN
        DELETE FROM Persona WHERE idPersona=idPersona;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20012, 'Error en personasEli: ' || SQLERRM);
    END personasEli;

    FUNCTION personasC RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR SELECT * FROM Persona;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20013, 'Error en personasC: ' || SQLERRM);
    END personasC;

    /* EQUIPOS */
    PROCEDURE equiposAd(
        nombre IN VARCHAR2, idEscuela IN NUMBER, idCategoria IN NUMBER
    ) IS
        v_idEquipo NUMBER;
    BEGIN
        SELECT NVL(MAX(idEquipo), 0) + 1 INTO v_idEquipo FROM Equipo;
        INSERT INTO Equipo VALUES (v_idEquipo, nombre, 'ACTIVO', idEscuela, idCategoria);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20014, 'Error en equiposAd: ' || SQLERRM);
    END equiposAd;

    PROCEDURE equiposMod(
        idEquipo IN NUMBER, nombre IN VARCHAR2, estadoEquipo IN VARCHAR2
    ) IS
        v_id    NUMBER := idEquipo;
        v_nom   VARCHAR2(30) := nombre;
        v_est   VARCHAR2(30) := estadoEquipo;
    BEGIN
        UPDATE Equipo SET nombre=v_nom, estadoEquipo=v_est
        WHERE idEquipo=v_id;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20015, 'Error en equiposMod: ' || SQLERRM);
    END equiposMod;

    PROCEDURE equiposEli(idEquipo IN NUMBER) IS
    BEGIN
        DELETE FROM Equipo WHERE idEquipo=idEquipo;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20016, 'Error en equiposEli: ' || SQLERRM);
    END equiposEli;

    FUNCTION equiposC RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR SELECT * FROM Equipo;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20017, 'Error en equiposC: ' || SQLERRM);
    END equiposC;

    /* PAGOS */
    PROCEDURE pagosAd(
        idPago IN NUMBER, monto IN NUMBER, estadoPago IN VARCHAR2,
        metodoPago IN VARCHAR2, idInscripcion IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Pago VALUES (idPago, SYSDATE, monto, estadoPago, metodoPago, idInscripcion);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20018, 'Error en pagosAd: ' || SQLERRM);
    END pagosAd;

    PROCEDURE pagosMod(idPago IN NUMBER, estadoPago IN VARCHAR2) IS
        v_estadoPago VARCHAR2(30) := estadoPago;
        v_idPago     NUMBER       := idPago;
    BEGIN
        UPDATE Pago SET estadoPago=v_estadoPago WHERE idPago=v_idPago;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20019, 'Error en pagosMod: ' || SQLERRM);
    END pagosMod;

    FUNCTION pagosC RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR SELECT * FROM Pago;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20020, 'Error en pagosC: ' || SQLERRM);
    END pagosC;

    /* INSCRIPCIONES */
    PROCEDURE inscripcionesAd(
        idInscripcion IN NUMBER, fechaInscripcion IN DATE, estadoInscripcion IN VARCHAR2,
        idPersona IN NUMBER, idEscuela IN NUMBER
    ) IS
    BEGIN
        INSERT INTO Inscripcion VALUES (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20021, 'Error en inscripcionesAd: ' || SQLERRM);
    END inscripcionesAd;

    PROCEDURE inscripcionesMod(idInscripcion IN NUMBER, estadoInscripcion IN VARCHAR2) IS
        v_estadoInscripcion VARCHAR2(30) := estadoInscripcion;
        v_idInscripcion     NUMBER       := idInscripcion;
    BEGIN
        UPDATE Inscripcion SET estadoInscripcion=v_estadoInscripcion
        WHERE idInscripcion=v_idInscripcion;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20022, 'Error en inscripcionesMod: ' || SQLERRM);
    END inscripcionesMod;

    PROCEDURE inscripcionesEli(idInscripcion IN NUMBER) IS
    BEGIN
        DELETE FROM Inscripcion WHERE idInscripcion=idInscripcion;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20023, 'Error en inscripcionesEli: ' || SQLERRM);
    END inscripcionesEli;

    FUNCTION recaudadoPorEscuela RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT e.nombre AS escuela, SUM(p.monto) AS total_recaudado
            FROM Escuela e
            JOIN Inscripcion i ON i.idEscuela = e.idEscuela
            JOIN Pago p ON p.idInscripcion = i.idInscripcion
            WHERE p.estadoPago = 'PAGADO'
            GROUP BY e.nombre;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20024, 'Error en recaudadoPorEscuela: ' || SQLERRM);
    END recaudadoPorEscuela;

    FUNCTION inscripcionesPendientes RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT * FROM Inscripcion WHERE estadoInscripcion = 'PENDIENTE';
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20025, 'Error en inscripcionesPendientes: ' || SQLERRM);
    END inscripcionesPendientes;

    /* CONSULTAS OPERATIVAS */
    FUNCTION jugadoresPorEquipo(idEquipo IN NUMBER) RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
        v_idEquipo NUMBER := idEquipo;
    BEGIN
        OPEN vCursor FOR
            SELECT DISTINCT p.idPersona, p.nombres, p.apellidos,
                   j.posicion, j.numeroCamiseta
            FROM Persona p
            INNER JOIN Jugador j ON j.idPersona = p.idPersona
            INNER JOIN Participante pa ON pa.idPersona = p.idPersona
            INNER JOIN Entrenamiento e ON e.idEntrenamiento = pa.idEntrenamiento
            WHERE e.idEquipo = v_idEquipo AND pa.rol = 'JUGADOR'
            ORDER BY p.apellidos, p.nombres;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20026, 'Error en jugadoresPorEquipo: ' || SQLERRM);
    END jugadoresPorEquipo;

    FUNCTION jugadoresPorCategoria(idCategoria IN NUMBER) RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
        v_idCategoria NUMBER := idCategoria;
    BEGIN
        OPEN vCursor FOR
            SELECT DISTINCT p.idPersona, p.nombres, p.apellidos,
                   j.posicion, j.numeroCamiseta, eq.nombre AS equipo
            FROM Persona p
            INNER JOIN Jugador j ON j.idPersona = p.idPersona
            INNER JOIN Participante pa ON pa.idPersona = p.idPersona
            INNER JOIN Entrenamiento e ON e.idEntrenamiento = pa.idEntrenamiento
            INNER JOIN Equipo eq ON eq.idEquipo = e.idEquipo
            WHERE eq.idCategoria = v_idCategoria AND pa.rol = 'JUGADOR'
            ORDER BY p.apellidos, p.nombres;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20027, 'Error en jugadoresPorCategoria: ' || SQLERRM);
    END jugadoresPorCategoria;

    /* CATEGORÍAS */
    PROCEDURE categoriasAdd(
        idCategoria IN NUMBER, nombre IN VARCHAR2, descripcion IN VARCHAR2, nivel IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Categoria VALUES (idCategoria, nombre, descripcion, nivel);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20028, 'Error en categoriasAdd: ' || SQLERRM);
    END categoriasAdd;

    /* ESCUELAS */
    PROCEDURE escuelasAdd(
        idEscuela IN NUMBER, nombre IN VARCHAR2, direccion IN VARCHAR2,
        telefono IN VARCHAR2, correo IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Escuela VALUES (idEscuela, nombre, direccion, telefono, correo);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20029, 'Error en escuelasAdd: ' || SQLERRM);
    END escuelasAdd;

END PA_ADMINISTRADOR;
/

/* PA_ENTRENADOR BODY - SQL directo sobre tablas */
CREATE OR REPLACE PACKAGE BODY PA_ENTRENADOR AS

    /* ENTRENAMIENTOS */
    PROCEDURE entrenamientosAd(
        fecha IN DATE, hora IN TIMESTAMP, lugar IN VARCHAR2, idEquipo IN NUMBER
    ) IS
        v_idEntrenamiento NUMBER;
    BEGIN
        SELECT NVL(MAX(idEntrenamiento), 0) + 1 INTO v_idEntrenamiento FROM Entrenamiento;
        INSERT INTO Entrenamiento VALUES (v_idEntrenamiento, fecha, hora, lugar, 'PROGRAMADO', idEquipo);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20040, 'Error en entrenamientosAd: ' || SQLERRM);
    END entrenamientosAd;

    PROCEDURE entrenamientosMod(
        idEntrenamiento IN NUMBER, fecha IN DATE, hora IN TIMESTAMP, lugar IN VARCHAR2
    ) IS
        v_id    NUMBER := idEntrenamiento;
        v_fecha DATE := fecha;
        v_hora  TIMESTAMP := hora;
        v_lugs  VARCHAR2(200) := lugar;
    BEGIN
        UPDATE Entrenamiento SET fecha=v_fecha, hora=v_hora, lugar=v_lugs
        WHERE idEntrenamiento=v_id;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20041, 'Error en entrenamientosMod: ' || SQLERRM);
    END entrenamientosMod;

    FUNCTION entrenamientosC RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR SELECT * FROM Entrenamiento;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20042, 'Error en entrenamientosC: ' || SQLERRM);
    END entrenamientosC;

    PROCEDURE entrenamientoEli(idEntrenamiento IN NUMBER) IS
        v_id NUMBER := idEntrenamiento;
    BEGIN
        DELETE FROM Entrenamiento WHERE idEntrenamiento=v_id;
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20043, 'Error en entrenamientoEli: ' || SQLERRM);
    END entrenamientoEli;

    FUNCTION entrenamientosProgramadosC RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT * FROM Entrenamiento
            WHERE estado = 'PROGRAMADO' AND fecha >= TRUNC(SYSDATE)
            ORDER BY fecha, hora;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20044, 'Error en entrenamientosProgramadosC: ' || SQLERRM);
    END entrenamientosProgramadosC;

    /* PARTICIPANTES */
    PROCEDURE participantesAd(
        idPersona IN NUMBER, idEntrenamiento IN NUMBER, asistencia IN CHAR, rol IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Participante VALUES (idPersona, idEntrenamiento, asistencia, rol, NULL);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20045, 'Error en participantesAd: ' || SQLERRM);
    END participantesAd;

    FUNCTION participantesC RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR SELECT * FROM Participante;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20046, 'Error en participantesC: ' || SQLERRM);
    END participantesC;

    /* CONSULTAS OPERATIVAS */
    FUNCTION jugadoresEquipo(idEquipo IN NUMBER) RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
        v_idEquipo NUMBER := idEquipo;
    BEGIN
        OPEN vCursor FOR
            SELECT DISTINCT p.idPersona, p.nombres, p.apellidos,
                   j.posicion, j.numeroCamiseta
            FROM Persona p
            INNER JOIN Jugador j ON j.idPersona = p.idPersona
            INNER JOIN Participante pa ON pa.idPersona = p.idPersona
            INNER JOIN Entrenamiento e ON e.idEntrenamiento = pa.idEntrenamiento
            WHERE e.idEquipo = v_idEquipo AND pa.rol = 'JUGADOR'
            ORDER BY p.apellidos, p.nombres;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20047, 'Error en jugadoresEquipo: ' || SQLERRM);
    END jugadoresEquipo;

    /* ASISTENCIA */
    PROCEDURE asistenciaReg(
        idPersona IN NUMBER, idEntrenamiento IN NUMBER, asistencia IN CHAR, observaciones IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO Participante VALUES (idPersona, idEntrenamiento, asistencia, 'JUGADOR', observaciones);
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20048, 'Error en asistenciaReg: ' || SQLERRM);
    END asistenciaReg;

    FUNCTION asistenciaC RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR SELECT * FROM Participante;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20049, 'Error en asistenciaC: ' || SQLERRM);
    END asistenciaC;

END PA_ENTRENADOR;
/

/* PA_GERENTE BODY - SQL directo sobre tablas */
CREATE OR REPLACE PACKAGE BODY PA_GERENTE AS

    FUNCTION jugadoresPorEscuela RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT e.nombre AS escuela, COUNT(DISTINCT i.idPersona) AS total_jugadores
            FROM Escuela e
            JOIN Inscripcion i ON i.idEscuela = e.idEscuela
            GROUP BY e.nombre ORDER BY total_jugadores DESC;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20080, 'Error en jugadoresPorEscuela: ' || SQLERRM);
    END jugadoresPorEscuela;

    FUNCTION pagosPorEstado RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT estadoPago, COUNT(*) AS cantidad, SUM(monto) AS total
            FROM Pago GROUP BY estadoPago;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20081, 'Error en pagosPorEstado: ' || SQLERRM);
    END pagosPorEstado;

    FUNCTION promedioJugadoresPorEntrenamiento RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT AVG(cnt) AS promedio_jugadores
            FROM (
                SELECT idEntrenamiento, COUNT(*) AS cnt
                FROM Participante WHERE rol = 'JUGADOR'
                GROUP BY idEntrenamiento
            );
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20082, 'Error en promedioJugadoresPorEntrenamiento: ' || SQLERRM);
    END promedioJugadoresPorEntrenamiento;

    FUNCTION escuelasConMayorDemanda RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT e.nombre AS escuela, COUNT(i.idInscripcion) AS total_inscripciones
            FROM Escuela e
            JOIN Inscripcion i ON i.idEscuela = e.idEscuela
            GROUP BY e.nombre ORDER BY total_inscripciones DESC;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20083, 'Error en escuelasConMayorDemanda: ' || SQLERRM);
    END escuelasConMayorDemanda;

    FUNCTION entrenamientosPorEquipo RETURN SYS_REFCURSOR IS
        vCursor SYS_REFCURSOR;
    BEGIN
        OPEN vCursor FOR
            SELECT eq.nombre AS equipo, COUNT(en.idEntrenamiento) AS total_entrenamientos
            FROM Equipo eq
            JOIN Entrenamiento en ON en.idEquipo = eq.idEquipo
            GROUP BY eq.nombre ORDER BY total_entrenamientos DESC;
        RETURN vCursor;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20084, 'Error en entrenamientosPorEquipo: ' || SQLERRM);
    END entrenamientosPorEquipo;

END PA_GERENTE;
/


/*Ciclo 2 */

/* PROYECTO: Formando Campeones
   CICLO 2 - IMPLEMENTACIÓN PAQUETES ACTORES_I
   
   OBJETIVO: Implementar interfaces de acceso por rol para nuevas funcionalidades
   - PA_ADMINISTRADOR_CICLO2: Implementación completa
   - PA_ENTRENADOR_CICLO2: Implementación completa
*/


/* PACKAGE BODY: PA_ADMINISTRADOR_CICLO2*/
CREATE OR REPLACE PACKAGE BODY PA_ADMINISTRADOR_CICLO2 AS

  /* PLANIFICACION PROCEDURES */
  PROCEDURE planificacionAd(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER,
    p_idEntrenamiento IN NUMBER
  ) IS
  BEGIN
    PC_PLANIFICACION.AD_PLANIFICACION(
      p_idPlanificacion, p_titulo, p_descripcion, 
      p_objetivo, p_duracion, p_idEntrenamiento
    );
  END planificacionAd;

  PROCEDURE planificacionMod(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER
  ) IS
  BEGIN
    PC_PLANIFICACION.MO_PLANIFICACION(
      p_idPlanificacion, p_titulo, p_descripcion, 
      p_objetivo, p_duracion
    );
  END planificacionMod;

  PROCEDURE planificacionEli(p_idPlanificacion IN NUMBER) IS
  BEGIN
    PC_PLANIFICACION.EL_PLANIFICACION(p_idPlanificacion);
  END planificacionEli;

  FUNCTION planificacionC RETURN SYS_REFCURSOR IS
  BEGIN
    RETURN PC_PLANIFICACION.CO_PLANIFICACION();
  END planificacionC;

  /* ESTADO DE CUENTA PROCEDURES */
  PROCEDURE estadoCuentaAd(
    p_idEstadoCuenta IN NUMBER,
    p_totalPagado IN NUMBER,
    p_totalPendiente IN NUMBER,
    p_idInscripcion IN NUMBER
  ) IS
  BEGIN
    PC_ESTADOCUENTA.AD_ESTADOCUENTA(
      p_idEstadoCuenta, p_totalPagado, 
      p_totalPendiente, p_idInscripcion
    );
  END estadoCuentaAd;

  PROCEDURE estadoCuentaMod(
    p_idEstadoCuenta IN NUMBER,
    p_totalPagado IN NUMBER,
    p_totalPendiente IN NUMBER
  ) IS
  BEGIN
    PC_ESTADOCUENTA.MO_ESTADOCUENTA(
      p_idEstadoCuenta, p_totalPagado, p_totalPendiente
    );
  END estadoCuentaMod;

  PROCEDURE estadoCuentaEli(p_idEstadoCuenta IN NUMBER) IS
  BEGIN
    PC_ESTADOCUENTA.EL_ESTADOCUENTA(p_idEstadoCuenta);
  END estadoCuentaEli;

  FUNCTION estadoCuentaC RETURN SYS_REFCURSOR IS
  BEGIN
    RETURN PC_ESTADOCUENTA.CO_ESTADOCUENTA();
  END estadoCuentaC;

  /* CONVOCATORIA PROCEDURES */
  PROCEDURE convocatoriaAd(
    p_idConvocatoria IN NUMBER,
    p_fechaEvento IN DATE,
    p_lugarEvento IN VARCHAR2,
    p_tipoEvento IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_estadoEvento IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEquipo IN NUMBER
  ) IS
  BEGIN
    PC_CONVOCATORIA.AD_CONVOCATORIA(
      p_idConvocatoria, p_fechaEvento, p_lugarEvento, 
      p_tipoEvento, p_descripcion, p_estadoEvento, 
      p_idPersona, p_idEquipo
    );
  END convocatoriaAd;

  PROCEDURE convocatoriaMod(
    p_idConvocatoria IN NUMBER,
    p_fechaEvento IN DATE,
    p_lugarEvento IN VARCHAR2,
    p_tipoEvento IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_estadoEvento IN VARCHAR2
  ) IS
  BEGIN
    PC_CONVOCATORIA.MO_CONVOCATORIA(
      p_idConvocatoria, p_fechaEvento, p_lugarEvento, 
      p_tipoEvento, p_descripcion, p_estadoEvento
    );
  END convocatoriaMod;

  PROCEDURE convocatoriaEli(p_idConvocatoria IN NUMBER) IS
  BEGIN
    PC_CONVOCATORIA.EL_CONVOCATORIA(p_idConvocatoria);
  END convocatoriaEli;

  FUNCTION convocatoriaC RETURN SYS_REFCURSOR IS
  BEGIN
    RETURN PC_CONVOCATORIA.CO_CONVOCATORIA();
  END convocatoriaC;
/



/* PACKAGE BODY: PA_ENTRENADOR_CICLO2 */
CREATE OR REPLACE PACKAGE BODY PA_ENTRENADOR_CICLO2 AS

  /* PLANIFICACION PROCEDURES */
  PROCEDURE planificacionAd(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER,
    p_idEntrenamiento IN NUMBER
  ) IS
  BEGIN
    PC_PLANIFICACION.AD_PLANIFICACION(
      p_idPlanificacion, p_titulo, p_descripcion, 
      p_objetivo, p_duracion, p_idEntrenamiento
    );
  END planificacionAd;

  PROCEDURE planificacionMod(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER
  ) IS
  BEGIN
    PC_PLANIFICACION.MO_PLANIFICACION(
      p_idPlanificacion, p_titulo, p_descripcion, 
      p_objetivo, p_duracion
    );
  END planificacionMod;

  PROCEDURE planificacionEli(
    p_idPlanificacion IN NUMBER
  ) IS
  BEGIN
    PC_PLANIFICACION.EL_PLANIFICACION(
      p_idPlanificacion
    );
  END planificacionEli;

  FUNCTION planificacionC 
  RETURN SYS_REFCURSOR IS
  BEGIN
    RETURN PC_PLANIFICACION.CO_PLANIFICACION();
  END planificacionC;


  /* EVALUACION PROCEDURES */
  PROCEDURE evaluacionAd(
    p_idEvaluacion IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_calificacion IN NUMBER,
    p_idEntrenador IN NUMBER,
    p_idJugador IN NUMBER
  ) IS
  BEGIN
    PC_EVALUACION.AD_EVALUACION(
      p_idEvaluacion,
      p_descripcion,
      p_calificacion, 
      p_idEntrenador,
      p_idJugador
    );
  END evaluacionAd;

  PROCEDURE evaluacionMod(
    p_idEvaluacion IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_calificacion IN NUMBER
  ) IS
  BEGIN
    PC_EVALUACION.MO_EVALUACION(
      p_idEvaluacion,
      p_descripcion,
      p_calificacion
    );
  END evaluacionMod;

  PROCEDURE evaluacionEli(
    p_idEvaluacion IN NUMBER
  ) IS
  BEGIN
    PC_EVALUACION.EL_EVALUACION(
      p_idEvaluacion
    );
  END evaluacionEli;

  FUNCTION evaluacionC 
  RETURN SYS_REFCURSOR IS
  BEGIN
    RETURN PC_EVALUACION.CO_EVALUACION();
  END evaluacionC;


END PA_ENTRENADOR_CICLO2;
/

COMMIT;