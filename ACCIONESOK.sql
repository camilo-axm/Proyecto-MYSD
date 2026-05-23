/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Probar TODAS las 5 acciones de referencia */

/*Crear datos de prueba para los procedimientos*/
INSERT INTO Escuela (idEscuela, nombre, direccion, telefono, correo)
VALUES (400, 'Escuela Acciones Test', 'Calle Test Acciones 1', '3009900401', 'test400@acciones.com');

INSERT INTO Categoria (idCategoria, nombre, descripcion, nivel)
VALUES (400, 'SUB14', 'Categoria Test Acciones', 'BASICO');

INSERT INTO Equipo (idEquipo, nombre, estadoEquipo, idEscuela, idCategoria)
VALUES (400, 'Equipo Acciones 400', 'ACTIVO', 400, 400);

INSERT INTO Entrenamiento (idEntrenamiento, fecha, hora, lugar, estado, idEquipo)
VALUES (400, DATE '2024-05-25', TIMESTAMP '2024-05-25 18:00:00', 'Cancha Test', 'PROGRAMADO', 400);

INSERT INTO Persona (idPersona, documento, nombres, apellidos, fechaNacimiento, telefono, correo)
VALUES (400, '1000000400', 'Test', 'Acciones', DATE '2010-05-10', '3009900402', 'test400@mail.com');

INSERT INTO Inscripcion (idInscripcion, fechaInscripcion, estadoInscripcion, idPersona, idEscuela)
VALUES (400, DATE '2024-04-01', 'ACTIVA', 400, 400);

INSERT INTO Participante (idPersona, idEntrenamiento, asistencia, rol, observaciones)
VALUES (400, 400, 'S', 'JUGADOR', 'Test participante');

INSERT INTO Recibe (idEntrenamiento, idEquipo, asistencia, observaciones)
VALUES (400, 400, 'S', 'Test recibe');

INSERT INTO Pago (idPago, fechaPago, monto, estadoPago, metodoPago, idInscripcion)
VALUES (400, DATE '2024-04-01', 120000.00, 'PAGADO', 'EFECTIVO', 400);

COMMIT;

/* ACCION 1: Participante a Entrenamiento (CASCADE) 
TEST 1: DELETE Entrenamiento 400 borra Participante en CASCADE*/
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
SELECT COUNT(*) AS "Participantes tras delete" FROM Participante WHERE idEntrenamiento = 400;
ROLLBACK;

/* ACCION 2: Recibe a Entrenamiento (CASCADE)
TEST 2: DELETE Entrenamiento borra Recibe en CASCADE */
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
SELECT COUNT(*) AS "Recibe tras delete" FROM Recibe WHERE idEntrenamiento = 400;
ROLLBACK;

/* ACCION 3: Entrenamiento a Equipo (CASCADE) 
TEST 3: DELETE Equipo borra Entrenamiento en CASCADE*/
DELETE FROM Equipo WHERE idEquipo = 400;
SELECT COUNT(*) AS "Entrenamientos tras delete" FROM Entrenamiento WHERE idEquipo = 400;
ROLLBACK;

/* ACCION 4: Equipo a Escuela (ON DELETE CASCADE)
TEST 4: DELETE Escuela elimina automaticamente Equipo en CASCADE*/
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
DELETE FROM Pago WHERE idPago = 400;
DELETE FROM Inscripcion WHERE idInscripcion = 400;
DELETE FROM Escuela WHERE idEscuela = 400;
SELECT COUNT(*) AS "Equipos tras delete" FROM Equipo WHERE idEscuela = 400;
ROLLBACK;

/* ACCION 5: Pago a Inscripcion (SET NULL)
TEST 5: DELETE Inscripcion deja idInscripcion en NULL en Pago */
/* Verificar que el pago tiene la inscripcion */
SELECT idPago, idInscripcion FROM Pago WHERE idPago = 400;
/* Borrar la inscripcion padre (activa ON DELETE SET NULL) */
DELETE FROM Inscripcion WHERE idInscripcion = 400;
/* Verificar que el pago sigue existiendo pero con idInscripcion en NULL*/
SELECT idPago, idInscripcion FROM Pago WHERE idPago = 400;
ROLLBACK;

/* Limpiar */
DELETE FROM Pago WHERE idPago = 400;
DELETE FROM Participante WHERE idPersona = 400;
DELETE FROM Recibe WHERE idEquipo = 400;
DELETE FROM Inscripcion WHERE idInscripcion = 400;
DELETE FROM Entrenamiento WHERE idEntrenamiento = 400;
DELETE FROM Persona WHERE idPersona = 400;
DELETE FROM Equipo WHERE idEquipo = 400;
DELETE FROM Escuela WHERE idEscuela = 400;
DELETE FROM Categoria WHERE idCategoria = 400;
COMMIT;


/* PROYECTO: Formando Campeones
   CICLO 2
   OBJETIVO: Probar acciones de referencia */

/*Crear datos de prueba*/

/* Escuela */
INSERT INTO Escuela (idEscuela,nombre,direccion,telefono,correo)
VALUES (500,'Escuela Ciclo 2','Calle 500','3005000001','ciclo2@escuela.com');

/* Categoria */
INSERT INTO Categoria (idCategoria,nombre,descripcion,nivel)
VALUES (500,'SUB17','Categoria ciclo 2','INTERMEDIO');

/* Persona */
INSERT INTO Persona (idPersona,documento,nombres,apellidos,fechaNacimiento,telefono,correo)
VALUES (500,'1000000500','Camilo','Test',DATE '2008-05-10','3005000002','persona500@test.com');

/* Entrenador */
INSERT INTO Entrenador (idPersona,experiencia,especialidad)
VALUES (500,5,'TACTICA');

/* Jugador */
INSERT INTO Jugador (idPersona,posicion,numeroCamiseta)
VALUES (500,'DELANTERO',9);

/* Equipo */
INSERT INTO Equipo (idEquipo,nombre,estadoEquipo, idEscuela, idCategoria)
VALUES (500,'Equipo Ciclo 2','ACTIVO',500,500);

/* Entrenamiento */
INSERT INTO Entrenamiento (idEntrenamiento,fecha,hora,lugar,estado,idEquipo)
VALUES ( 500, DATE '2025-05-20', TIMESTAMP '2025-05-20 18:00:00', 'Cancha Principal', 'PROGRAMADO', 500);

/* Planificacion */
INSERT INTO Planificacion (idPlanificacion,titulo,descripcion,objetivo,duracion,fechaCreacion,idEntrenamiento)
VALUES (500,'RESISTENCIA','Planificacion prueba','Mejorar condicion fisica',60,SYSDATE,500);

/* Inscripcion */
INSERT INTO Inscripcion (idInscripcion,fechaInscripcion,estadoInscripcion,idPersona,idEscuela)
VALUES (500,SYSDATE,'ACTIVA',500,500);

/* EstadoCuenta */
INSERT INTO EstadoCuenta (idEstadoCuenta,fechaGeneracion,totalPagado,totalPendiente,idInscripcion)
VALUES (500,SYSDATE,100000,50000,500);

/* Convocatoria */
INSERT INTO Convocatoria (idConvocatoria,fechaEvento,lugarEvento,tipoEvento,descripcion,estadoEvento,idPersona,idEquipo)
VALUES (500,DATE '2025-06-10','Estadio Central','OFICIAL','Convocatoria prueba','PROGRAMADA', 500, 500);

/* Evaluacion */
INSERT INTO Evaluacion (idEvaluacion,fechaEvaluacion,descripcion,calificacion,idEntrenador,idJugador)
VALUES (500,SYSDATE,'Evaluacion prueba',5,500,500);

COMMIT;


/* ACCION 6: Planificacion a Entrenamiento (CASCADE)
TEST 6: DELETE Entrenamiento elimina Planificacion */

DELETE FROM Entrenamiento
WHERE idEntrenamiento = 500;

SELECT COUNT(*) AS "Planificaciones tras delete" FROM Planificacion
WHERE idEntrenamiento = 500;

ROLLBACK;


/* ACCION 7: EstadoCuenta a Inscripcion (CASCADE)
TEST 7: DELETE Inscripcion elimina EstadoCuenta */

DELETE FROM Inscripcion
WHERE idInscripcion = 500;

SELECT COUNT(*) AS "EstadosCuenta tras delete" FROM EstadoCuenta
WHERE idInscripcion = 500;

ROLLBACK;


/* ACCION 8: Evaluacion a Jugador (CASCADE)
TEST 8: DELETE Jugador elimina Evaluacion */

DELETE FROM Jugador
WHERE idPersona = 500;

SELECT COUNT(*) AS "Evaluaciones tras delete" FROM Evaluacion
WHERE idJugador = 500;

ROLLBACK;


/* ACCION 9: Convocatoria a Equipo (CASCADE)
TEST 9: DELETE Equipo elimina Convocatoria */

DELETE FROM Equipo
WHERE idEquipo = 500;

SELECT COUNT(*) AS "Convocatorias tras delete" FROM Convocatoria
WHERE idEquipo = 500;

ROLLBACK;


/* LIMPIEZA */
DELETE FROM Evaluacion WHERE idEvaluacion = 500;
DELETE FROM Convocatoria WHERE idConvocatoria = 500;
DELETE FROM EstadoCuenta WHERE idEstadoCuenta = 500;
DELETE FROM Planificacion WHERE idPlanificacion = 500;
DELETE FROM Entrenamiento WHERE idEntrenamiento = 500;
DELETE FROM Jugador WHERE idPersona = 500;
DELETE FROM Entrenador WHERE idPersona = 500;
DELETE FROM Inscripcion WHERE idInscripcion = 500;
DELETE FROM Equipo WHERE idEquipo = 500;
DELETE FROM Persona WHERE idPersona = 500;
DELETE FROM Escuela WHERE idEscuela = 500;
DELETE FROM Categoria WHERE idCategoria = 500;

COMMIT;

