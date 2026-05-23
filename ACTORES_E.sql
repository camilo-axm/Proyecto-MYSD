/* PROYECTO: Formando Campeones
   CICLO 1 - ESPECIFICACIÓN PAQUETES ACTORES_E
   
   OBJETIVO: Definir interfaces de acceso por rol (EXACTAMENTE según UML ASTAH)
   - PA_ADMINISTRADOR: Wrappers de personas, equipos, pagos, inscripciones, categorías, escuelas
   - PA_ENTRENADOR: Wrappers de entrenamientos, participantes, asistencia
   - PA_GERENTE: Wrappers de consultas gerenciales (solo lectura)
*/

/* PAQUETE PARA ADMINISTRADORES - ACCESO TOTAL */
CREATE OR REPLACE PACKAGE PA_ADMINISTRADOR AS
    
    /* PERSONAS */
    PROCEDURE personasAd(
        idPersona IN NUMBER, documento IN VARCHAR2, nombres IN VARCHAR2, 
        apellidos IN VARCHAR2, fechaNacimiento IN DATE, telefono IN VARCHAR2, correo IN VARCHAR2
    );
    
    PROCEDURE personasMod(
        idPersona IN NUMBER, documento IN VARCHAR2, nombres IN VARCHAR2, 
        apellidos IN VARCHAR2, telefono IN VARCHAR2, correo IN VARCHAR2
    );
    
    PROCEDURE personasEli(idPersona IN NUMBER);
    
    FUNCTION personasC RETURN SYS_REFCURSOR;
    
    /* EQUIPOS */
    PROCEDURE equiposAd(
        nombre IN VARCHAR2, idEscuela IN NUMBER, idCategoria IN NUMBER
    );
    
    PROCEDURE equiposMod(
        idEquipo IN NUMBER, nombre IN VARCHAR2, estadoEquipo IN VARCHAR2
    );
    
    PROCEDURE equiposEli(idEquipo IN NUMBER);
    
    FUNCTION equiposC RETURN SYS_REFCURSOR;
    
    /*  PAGOS */
    PROCEDURE pagosAd(
        idPago IN NUMBER, monto IN NUMBER, estadoPago IN VARCHAR2, 
        metodoPago IN VARCHAR2, idInscripcion IN NUMBER
    );
    
    PROCEDURE pagosMod(
        idPago IN NUMBER, estadoPago IN VARCHAR2
    );
    
    FUNCTION pagosC RETURN SYS_REFCURSOR;
    
    /* INSCRIPCIONES */
    PROCEDURE inscripcionesAd(
        idInscripcion IN NUMBER, fechaInscripcion IN DATE, estadoInscripcion IN VARCHAR2, 
        idPersona IN NUMBER, idEscuela IN NUMBER
    );
    
    PROCEDURE inscripcionesMod(
        idInscripcion IN NUMBER, estadoInscripcion IN VARCHAR2
    );
    
    PROCEDURE inscripcionesEli(idInscripcion IN NUMBER);
    
    FUNCTION recaudadoPorEscuela RETURN SYS_REFCURSOR;
    
    /* CONSULTAS OPERATIVAS */
    FUNCTION jugadoresPorEquipo(idEquipo IN NUMBER) RETURN SYS_REFCURSOR;
    
    FUNCTION jugadoresPorCategoria(idCategoria IN NUMBER) RETURN SYS_REFCURSOR;
    
    FUNCTION inscripcionesPendientes RETURN SYS_REFCURSOR;
    
    /* CATEGORÍAS */
    PROCEDURE categoriasAdd(
        idCategoria IN NUMBER, nombre IN VARCHAR2, descripcion IN VARCHAR2, nivel IN VARCHAR2
    );
    
    /* ESCUELAS */
    PROCEDURE escuelasAdd(
        idEscuela IN NUMBER, nombre IN VARCHAR2, direccion IN VARCHAR2, 
        telefono IN VARCHAR2, correo IN VARCHAR2
    );
    
END PA_ADMINISTRADOR;
/

/* PAQUETE PARA ENTRENADORES - ACCESO LIMITADO */
CREATE OR REPLACE PACKAGE PA_ENTRENADOR AS
    
    /* ENTRENAMIENTOS */
    PROCEDURE entrenamientosAd(
        fecha IN DATE, hora IN TIMESTAMP, lugar IN VARCHAR2, idEquipo IN NUMBER
    );
    
    PROCEDURE entrenamientosMod(
        idEntrenamiento IN NUMBER, fecha IN DATE, hora IN TIMESTAMP, lugar IN VARCHAR2
    );
    
    FUNCTION entrenamientosC RETURN SYS_REFCURSOR;
    
    PROCEDURE entrenamientoEli(idEntrenamiento IN NUMBER);
    
    FUNCTION entrenamientosProgramadosC RETURN SYS_REFCURSOR;
    
    /*  PARTICIPANTES  */
    PROCEDURE participantesAd(
        idPersona IN NUMBER, idEntrenamiento IN NUMBER, asistencia IN CHAR, rol IN VARCHAR2
    );
    
    FUNCTION participantesC RETURN SYS_REFCURSOR;
    
    /* CONSULTAS OPERATIVAS  */
    FUNCTION jugadoresEquipo(idEquipo IN NUMBER) RETURN SYS_REFCURSOR;
    
    /* ASISTENCIA */
    PROCEDURE asistenciaReg(
        idPersona IN NUMBER, idEntrenamiento IN NUMBER, asistencia IN CHAR, observaciones IN VARCHAR2
    );
    
    FUNCTION asistenciaC RETURN SYS_REFCURSOR;
    
END PA_ENTRENADOR;
/

/* PAQUETE PARA GERENTES - CONSULTAS GERENCIALES SOLO LECTURA */
CREATE OR REPLACE PACKAGE PA_GERENTE AS
    
    FUNCTION jugadoresPorEscuela RETURN SYS_REFCURSOR;
    
    FUNCTION pagosPorEstado RETURN SYS_REFCURSOR;
    
    FUNCTION promedioJugadoresPorEntrenamiento RETURN SYS_REFCURSOR;
    
    FUNCTION escuelasConMayorDemanda RETURN SYS_REFCURSOR;
    
    FUNCTION entrenamientosPorEquipo RETURN SYS_REFCURSOR;
    
END PA_GERENTE;
/

/* CICLO 2  ESPECIFICACIÓN PAQUETES ACTORES_E
   OBJETIVO: Definir interfaces de acceso por rol para nuevas funcionalidades
   PA_ADMINISTRADOR: Planificación, EstadoCuenta, Convocatoria + consultas operativas
   PA_ENTRENADOR: Planificación, Evaluación + consultas operativas
*/


/* PAQUETE PARA ADMINISTRADORES - ACCESO AMPLIADO CICLO 2 */
CREATE OR REPLACE PACKAGE PA_ADMINISTRADOR_CICLO2 AS
    
    /* PLANIFICACION */
    PROCEDURE planificacionAd(
        p_idPlanificacion IN NUMBER,
        p_titulo IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_objetivo IN VARCHAR2,
        p_duracion IN NUMBER,
        p_idEntrenamiento IN NUMBER
    );
    
    PROCEDURE planificacionMod(
        p_idPlanificacion IN NUMBER,
        p_titulo IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_objetivo IN VARCHAR2,
        p_duracion IN NUMBER
    );
    
    PROCEDURE planificacionEli(p_idPlanificacion IN NUMBER);
    
    FUNCTION planificacionC RETURN SYS_REFCURSOR;
    
    /* ESTADO DE CUENTA */
    PROCEDURE estadoCuentaAd(
        p_idEstadoCuenta IN NUMBER,
        p_totalPagado IN NUMBER,
        p_totalPendiente IN NUMBER,
        p_idInscripcion IN NUMBER
    );
    
    PROCEDURE estadoCuentaMod(
        p_idEstadoCuenta IN NUMBER,
        p_totalPagado IN NUMBER,
        p_totalPendiente IN NUMBER
    );
    
    PROCEDURE estadoCuentaEli(p_idEstadoCuenta IN NUMBER);
    
    FUNCTION estadoCuentaC RETURN SYS_REFCURSOR;
    
    /* CONVOCATORIA */
    PROCEDURE convocatoriaAd(
        p_idConvocatoria IN NUMBER,
        p_fechaEvento IN DATE,
        p_lugarEvento IN VARCHAR2,
        p_tipoEvento IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_estadoEvento IN VARCHAR2,
        p_idPersona IN NUMBER,
        p_idEquipo IN NUMBER
    );
    
    PROCEDURE convocatoriaMod(
        p_idConvocatoria IN NUMBER,
        p_fechaEvento IN DATE,
        p_lugarEvento IN VARCHAR2,
        p_tipoEvento IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_estadoEvento IN VARCHAR2
    );
    
    PROCEDURE convocatoriaEli(p_idConvocatoria IN NUMBER);
    
    FUNCTION convocatoriaC RETURN SYS_REFCURSOR;
    
END PA_ADMINISTRADOR_CICLO2;
/

/* PAQUETE PARA ENTRENADORES - ACCESO AMPLIADO CICLO 2 */
CREATE OR REPLACE PACKAGE PA_ENTRENADOR_CICLO2 AS
    
    /* PLANIFICACION */
    PROCEDURE planificacionAd(
        p_idPlanificacion IN NUMBER,
        p_titulo IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_objetivo IN VARCHAR2,
        p_duracion IN NUMBER,
        p_idEntrenamiento IN NUMBER
    );
    
    PROCEDURE planificacionMod(
        p_idPlanificacion IN NUMBER,
        p_titulo IN VARCHAR2,
        p_descripcion IN VARCHAR2,
        p_objetivo IN VARCHAR2,
        p_duracion IN NUMBER
    );
    
    PROCEDURE planificacionEli(p_idPlanificacion IN NUMBER);
    
    FUNCTION planificacionC RETURN SYS_REFCURSOR;
    
    /* EVALUACION */
    PROCEDURE evaluacionAd(
        p_idEvaluacion IN NUMBER,
        p_descripcion IN VARCHAR2,
        p_calificacion IN NUMBER,
        p_idEntrenador IN NUMBER,
        p_idJugador IN NUMBER
    );
    
    PROCEDURE evaluacionMod(
        p_idEvaluacion IN NUMBER,
        p_descripcion IN VARCHAR2,
        p_calificacion IN NUMBER
    );
    
    PROCEDURE evaluacionEli(p_idEvaluacion IN NUMBER);
    
    FUNCTION evaluacionC RETURN SYS_REFCURSOR;

END PA_ENTRENADOR_CICLO2;
/

COMMIT;
/
