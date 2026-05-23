/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Definición de índices para optimizar búsquedas y joins frecuentes */

/*INDICE 1: Búsquedas por documento de Persona
CREATE INDEX idx_persona_documento ON Persona(documento);
COMMIT;
INDICE 1:
   documento ya posee índice automático
   debido a PRIMARY KEY o UNIQUE */

   
/*INDICE 2: Filtros por estado de Pago*/
CREATE INDEX idx_pago_estadoPago ON Pago(estadoPago);
COMMIT;

/*INDICE 3: Filtros por estado de Inscripcion*/
CREATE INDEX idx_inscripcion_estadoInscripcion ON Inscripcion(estadoInscripcion);
COMMIT;

/*INDICE 4: Filtros por estado de Entrenamiento*/
CREATE INDEX idx_entrenamiento_estado ON Entrenamiento(estado);
COMMIT;

/*INDICE 5: Búsquedas de Jugadores por numero de camiseta*/
CREATE INDEX idx_jugador_numeroCamiseta ON Jugador(numeroCamiseta);
COMMIT;

/*INDICE 6: Joins frecuentes en Participante*/
CREATE INDEX idx_participante_idEntrenamiento ON Participante(idEntrenamiento);
COMMIT;

/*INDICE 7: Joins frecuentes en Recibe*/
CREATE INDEX idx_recibe_idEntrenamiento ON Recibe(idEntrenamiento);
COMMIT;

/*INDICE 8: Búsquedas de Jugadores por Escuela*/
CREATE INDEX idx_inscripcion_idEscuela ON Inscripcion(idEscuela);
COMMIT;

/*INDICE 9: Búsquedas de Entrenamientos por Equipo*/
CREATE INDEX idx_entrenamiento_idEquipo ON Entrenamiento(idEquipo);
COMMIT;

/*INDICE 10: Búsquedas de Jugadores por Equipo*/
CREATE INDEX idx_inscripcion_idPersona ON Inscripcion(idPersona);
COMMIT;

/* PROYECTO: Formando Campeones
   CICLO 2
   OBJETIVO: Definición de índices para optimizar búsquedas y joins frecuentes */

/* INDICE 11:
Búsquedas de Planificaciones por Entrenamiento */
CREATE INDEX idx_planificacion_idEntrenamiento
ON Planificacion(idEntrenamiento);
COMMIT;


/* INDICE 12:
Búsquedas de Evaluaciones por Jugador */
CREATE INDEX idx_evaluacion_idJugador
ON Evaluacion(idJugador);
COMMIT;


/* INDICE 13:
Filtros por calificacion en Evaluacion */
CREATE INDEX idx_evaluacion_calificacion
ON Evaluacion(calificacion);
COMMIT;

/* INDICE 14:
Búsquedas de EstadoCuenta por Inscripcion */
CREATE INDEX idx_estadocuenta_idInscripcion
ON EstadoCuenta(idInscripcion);
COMMIT;

/* INDICE 15:
Búsquedas de Convocatorias por Equipo */
CREATE INDEX idx_convocatoria_idEquipo
ON Convocatoria(idEquipo);
COMMIT;

/* INDICE 16:
Búsquedas de Convocatorias por Responsable */
CREATE INDEX idx_convocatoria_idPersona
ON Convocatoria(idPersona);

COMMIT;

/* INDICE 17:
Filtros por tipo de evento en Convocatoria */
CREATE INDEX idx_convocatoria_tipoEvento
ON Convocatoria(tipoEvento);

COMMIT;