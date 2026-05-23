/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Restricciones de tupla */

/* Si el participante asistio, debe registrar observacion */
ALTER TABLE Participante
ADD CONSTRAINT ck_participante_asistencia_obs
CHECK (
    (asistencia = 'S' AND observaciones IS NOT NULL)
    OR
    (asistencia = 'N')
);

/* Si el equipo asistio al entrenamiento, debe registrar observacion */
ALTER TABLE Recibe
ADD CONSTRAINT ck_recibe_asistencia_obs
CHECK (
    (asistencia = 'S' AND observaciones IS NOT NULL)
    OR
    (asistencia = 'N')
);

/* Si el pago esta anulado, el monto debe ser mayor que 0 igualmente
   y el estado debe ser uno de los definidos */
ALTER TABLE Pago
ADD CONSTRAINT ck_pago_estado_monto
CHECK (
    (estadoPago IN ('PAGADO', 'PENDIENTE', 'ANULADO'))
    AND monto > 0
);



/*Ciclo 2 */


/* Si la evaluación tiene una calificación alta,
   debe registrar una observación */
ALTER TABLE Evaluacion
ADD CONSTRAINT ck_evaluacion_obs
CHECK (
    (calificacion >= 4 AND observaciones IS NOT NULL)
    OR
    (calificacion < 4)
);

/* Si la planificación es de resistencia,
   la duración debe ser mínimo de 30 minutos */
ALTER TABLE Planificacion
ADD CONSTRAINT ck_planificacion_duracion
CHECK (
    (titulo = 'RESISTENCIA' AND duracion >= 30)
    OR
    (titulo != 'RESISTENCIA')
);

/* Si la convocatoria es cancelada,
   debe registrar una descripción del motivo */
ALTER TABLE Convocatoria
ADD CONSTRAINT ck_convocatoria_cancelacion
CHECK (
    (estadoEvento = 'CANCELADA' AND descripcion IS NOT NULL)
    OR
    (estadoEvento != 'CANCELADA')
);

/* Si la convocatoria fue realizada,
   debe registrar una fecha del evento */
ALTER TABLE Convocatoria
ADD CONSTRAINT ck_convocatoria_fecha
CHECK (
    (estadoEvento = 'REALIZADA' AND fechaEvento IS NOT NULL)
    OR
    (estadoEvento IN ('PROGRAMADA', 'CANCELADA'))
);

/* Los valores totales del estado de cuenta
   no pueden ser negativos */
ALTER TABLE EstadoCuenta
ADD CONSTRAINT ck_estado_cuenta_totales
CHECK (
    totalPagado >= 0
    AND totalPendiente >= 0
); 