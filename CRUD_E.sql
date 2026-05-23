/* PROYECTO: Formando Campeones CRUDE
   ESPECIFICACIÓN DE COMPONENTES (PACKAGES)
*/

/* PACKAGE: PC_PERSONA
   Gestión CRUD de Personas  */
CREATE OR REPLACE PACKAGE PC_PERSONA AS

  PROCEDURE AD_PERSONA(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  );

  PROCEDURE MO_PERSONA(
    p_idPersona IN NUMBER,
    p_documento IN VARCHAR2,
    p_nombres IN VARCHAR2,
    p_apellidos IN VARCHAR2,
    p_fechaNacimiento IN DATE,
    p_telefono IN VARCHAR2,
    p_correo IN VARCHAR2
  );

  PROCEDURE EL_PERSONA(p_idPersona IN NUMBER);

  FUNCTION CO_PERSONA RETURN SYS_REFCURSOR;

END PC_PERSONA;
/

/* PACKAGE: PC_EQUIPO
   Gestión CRUD de Equipos  */
CREATE OR REPLACE PACKAGE PC_EQUIPO AS

  PROCEDURE AD_EQUIPO(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  );

  PROCEDURE MO_EQUIPO(
    p_idEquipo IN NUMBER,
    p_nombre IN VARCHAR2,
    p_estadoEquipo IN VARCHAR2,
    p_idEscuela IN NUMBER,
    p_idCategoria IN NUMBER
  );

  PROCEDURE EL_EQUIPO(p_idEquipo IN NUMBER);

  FUNCTION CO_EQUIPO RETURN SYS_REFCURSOR;

END PC_EQUIPO;
/

/* PACKAGE: PC_INSCRIPCION
   Gestión CRUD de Inscripciones  */
CREATE OR REPLACE PACKAGE PC_INSCRIPCION AS

  PROCEDURE AD_INSCRIPCION(
    p_idInscripcion IN NUMBER,
    p_fechaInscripcion IN DATE,
    p_estadoInscripcion IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEscuela IN NUMBER
  );

  PROCEDURE EL_INSCRIPCION(p_idInscripcion IN NUMBER);

  FUNCTION CO_INSCRIPCION RETURN SYS_REFCURSOR;

END PC_INSCRIPCION;
/

/* PACKAGE: PC_PAGO
   Gestión CRUD de Pagos */
CREATE OR REPLACE PACKAGE PC_PAGO AS

  PROCEDURE AD_PAGO(
    p_idPago IN NUMBER,
    p_fechaPago IN DATE,
    p_monto IN NUMBER,
    p_estadoPago IN VARCHAR2,
    p_metodoPago IN VARCHAR2,
    p_idInscripcion IN NUMBER
  );

  PROCEDURE EL_PAGO(p_idPago IN NUMBER);

  FUNCTION CO_PAGO RETURN SYS_REFCURSOR;

END PC_PAGO;
/

/* PACKAGE: PC_ASISTENCIA
   Gestión CRUD de Asistencia/Participantes */
CREATE OR REPLACE PACKAGE PC_ASISTENCIA AS

  PROCEDURE AD_ASISTENCIA(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_rol IN VARCHAR2,
    p_observaciones IN VARCHAR2
  );

  PROCEDURE MO_ASISTENCIA(
    p_idPersona IN NUMBER,
    p_idEntrenamiento IN NUMBER,
    p_asistencia IN CHAR,
    p_observaciones IN VARCHAR2
  );

  FUNCTION CO_ASISTENCIA RETURN SYS_REFCURSOR;

END PC_ASISTENCIA;
/

/* PACKAGE: PC_ENTRENAMIENTO
   Gestión CRUD de Entrenamientos - Directamente del UML */
CREATE OR REPLACE PACKAGE PC_ENTRENAMIENTO AS

  PROCEDURE AD_ENTRENAMIENTO(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  );

  PROCEDURE MO_ENTRENAMIENTO(
    p_idEntrenamiento IN NUMBER,
    p_fecha IN DATE,
    p_hora IN TIMESTAMP,
    p_lugar IN VARCHAR2,
    p_estado IN VARCHAR2,
    p_idEquipo IN NUMBER
  );

  PROCEDURE EL_ENTRENAMIENTO(p_idEntrenamiento IN NUMBER);

  FUNCTION CO_ENTRENAMIENTO RETURN SYS_REFCURSOR;

END PC_ENTRENAMIENTO;
/


/* CICLO 2
OBJETIVO: Paquetes CRUD para nuevas funcionalidades */

/*PACKAGE: PC_PLANIFICACION
Gestión CRUD de Planificaciones*/
CREATE OR REPLACE PACKAGE PC_PLANIFICACION AS

  PROCEDURE AD_PLANIFICACION(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER,
    p_idEntrenamiento IN NUMBER
  );

  PROCEDURE MO_PLANIFICACION(
    p_idPlanificacion IN NUMBER,
    p_titulo IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_objetivo IN VARCHAR2,
    p_duracion IN NUMBER
  );

  PROCEDURE EL_PLANIFICACION(p_idPlanificacion IN NUMBER);

  FUNCTION CO_PLANIFICACION RETURN SYS_REFCURSOR;

END PC_PLANIFICACION;
/

/*PACKAGE: PC_ESTADOCUENTA
Gestión CRUD de Estados de Cuenta*/
CREATE OR REPLACE PACKAGE PC_ESTADOCUENTA AS

  PROCEDURE AD_ESTADOCUENTA(
    p_idEstadoCuenta IN NUMBER,
    p_totalPagado IN NUMBER,
    p_totalPendiente IN NUMBER,
    p_idInscripcion IN NUMBER
  );

  PROCEDURE MO_ESTADOCUENTA(
    p_idEstadoCuenta IN NUMBER,
    p_totalPagado IN NUMBER,
    p_totalPendiente IN NUMBER
  );

  PROCEDURE EL_ESTADOCUENTA(p_idEstadoCuenta IN NUMBER);

  FUNCTION CO_ESTADOCUENTA RETURN SYS_REFCURSOR;

END PC_ESTADOCUENTA;
/

/*PACKAGE: PC_EVALUACION
Gestión CRUD de Evaluaciones*/
CREATE OR REPLACE PACKAGE PC_EVALUACION AS

  PROCEDURE AD_EVALUACION(
    p_idEvaluacion IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_calificacion IN NUMBER,
    p_idEntrenador IN NUMBER,
    p_idJugador IN NUMBER
  );

  PROCEDURE MO_EVALUACION(
    p_idEvaluacion IN NUMBER,
    p_descripcion IN VARCHAR2,
    p_calificacion IN NUMBER
  );

  PROCEDURE EL_EVALUACION(p_idEvaluacion IN NUMBER);

  FUNCTION CO_EVALUACION RETURN SYS_REFCURSOR;

END PC_EVALUACION;
/

/*PACKAGE: PC_CONVOCATORIA
Gestión CRUD de Convocatorias*/
CREATE OR REPLACE PACKAGE PC_CONVOCATORIA AS

  PROCEDURE AD_CONVOCATORIA(
    p_idConvocatoria IN NUMBER,
    p_fechaEvento IN DATE,
    p_lugarEvento IN VARCHAR2,
    p_tipoEvento IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_estadoEvento IN VARCHAR2,
    p_idPersona IN NUMBER,
    p_idEquipo IN NUMBER
  );

  PROCEDURE MO_CONVOCATORIA(
    p_idConvocatoria IN NUMBER,
    p_fechaEvento IN DATE,
    p_lugarEvento IN VARCHAR2,
    p_tipoEvento IN VARCHAR2,
    p_descripcion IN VARCHAR2,
    p_estadoEvento IN VARCHAR2
  );

  PROCEDURE EL_CONVOCATORIA(p_idConvocatoria IN NUMBER);

  FUNCTION CO_CONVOCATORIA RETURN SYS_REFCURSOR;

END PC_CONVOCATORIA;
/


