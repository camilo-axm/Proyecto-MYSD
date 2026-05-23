/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Acciones de referencia */

/* ACCION 1 
Participante a Entrenamiento (ON DELETE CASCADE) */

ALTER TABLE Participante DROP CONSTRAINT fk_participante_entrenamiento;

ALTER TABLE Participante
ADD CONSTRAINT fk_participante_entrenamiento
FOREIGN KEY (idEntrenamiento)
REFERENCES Entrenamiento(idEntrenamiento)
ON DELETE CASCADE;


/* ACCION 2 
Recibe a Entrenamiento (ON DELETE CASCADE) */

ALTER TABLE Recibe DROP CONSTRAINT fk_recibe_entrenamiento;

ALTER TABLE Recibe
ADD CONSTRAINT fk_recibe_entrenamiento
FOREIGN KEY (idEntrenamiento)
REFERENCES Entrenamiento(idEntrenamiento)
ON DELETE CASCADE;


/* ACCION 3
Entrenamiento a Equipo (ON DELETE CASCADE) */

ALTER TABLE Entrenamiento DROP CONSTRAINT fk_entrenamiento_equipo;

ALTER TABLE Entrenamiento
ADD CONSTRAINT fk_entrenamiento_equipo
FOREIGN KEY (idEquipo)
REFERENCES Equipo(idEquipo)
ON DELETE CASCADE;


/* ACCION 4 
Equipo a Escuela (ON DELETE CASCADE) */

ALTER TABLE Equipo DROP CONSTRAINT fk_equipo_escuela;

ALTER TABLE Equipo
ADD CONSTRAINT fk_equipo_escuela
FOREIGN KEY (idEscuela)
REFERENCES Escuela(idEscuela)
ON DELETE CASCADE;



/* ACCION 5 
Pago a Inscripción (ON DELETE SET NULL) */

ALTER TABLE Pago DROP CONSTRAINT fk_pago_inscripcion;

ALTER TABLE Pago
ADD CONSTRAINT fk_pago_inscripcion
FOREIGN KEY (idInscripcion)
REFERENCES Inscripcion(idInscripcion)
ON DELETE SET NULL;


/*Ciclo 2 - Acciones para las nuevas funcionalidades*/

/* ACCION 6
Planificacion a Entrenamiento (ON DELETE CASCADE) */

ALTER TABLE Planificacion
DROP CONSTRAINT fk_planificacion_entrenamiento;

ALTER TABLE Planificacion
ADD CONSTRAINT fk_planificacion_entrenamiento
FOREIGN KEY (idEntrenamiento)
REFERENCES Entrenamiento(idEntrenamiento)
ON DELETE CASCADE;

/* ACCION 7
EstadoCuenta a Inscripcion (ON DELETE CASCADE) */

ALTER TABLE EstadoCuenta
DROP CONSTRAINT fk_estado_cuenta_inscripcion;

ALTER TABLE EstadoCuenta
ADD CONSTRAINT fk_estado_cuenta_inscripcion
FOREIGN KEY (idInscripcion)
REFERENCES Inscripcion(idInscripcion)
ON DELETE CASCADE;

/* ACCION 8
Evaluacion a Jugador (ON DELETE CASCADE) */

ALTER TABLE Evaluacion
DROP CONSTRAINT fk_evaluacion_jugador;

ALTER TABLE Evaluacion
ADD CONSTRAINT fk_evaluacion_jugador
FOREIGN KEY (idJugador)
REFERENCES Jugador(idPersona)
ON DELETE CASCADE;

/* ACCION 9
Convocatoria a Equipo (ON DELETE CASCADE) */

ALTER TABLE Convocatoria
DROP CONSTRAINT fk_convocatoria_equipo;

ALTER TABLE Convocatoria
ADD CONSTRAINT fk_convocatoria_equipo
FOREIGN KEY (idEquipo)
REFERENCES Equipo(idEquipo)
ON DELETE CASCADE;
