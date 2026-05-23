/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Consultas que demuestran el uso de indices y vistas */

/*TEST 1: Búsqueda rápida de Persona por documento usando índice*/
SELECT * FROM Persona WHERE documento = '1000000001';

/*TEST 2: Consulta usando VISTA de Jugadores por Equipo*/
SELECT * FROM vw_jugadores_por_equipo WHERE equipoNombre = 'Halcones Norte';

/*TEST 3: Reporte de Recaudos por Escuela usando VISTA*/
SELECT 
    escuelaNombre,
    totalRecaudado,
    totalPendiente,
    totalInscripciones,
    ROUND((totalRecaudado / NULLIF(totalInscripciones, 0)) * 100, 2) AS porcentajeRecaudado
FROM vw_recaudos_por_escuela
WHERE totalRecaudado > 0
ORDER BY totalRecaudado DESC;

/*TEST 4: Identificar Inscripciones con Pagos Pendientes usando VISTA*/
SELECT 
    idInscripcion,
    nombres,
    apellidos,
    escuelaNombre,
    montoPendiente,
    cantidadPagosPendientes
FROM vw_inscripciones_pendientes
ORDER BY montoPendiente DESC;

/*TEST 5: Listado de Entrenamientos Programados usando VISTA*/
SELECT 
    TO_CHAR(fecha, 'DD/MM/YYYY') AS fechaEntrenamiento,
    TO_CHAR(hora, 'HH24:MI') AS hora,
    equipoNombre,
    lugar,
    equiposParticipantes
FROM vw_entrenamientos_programados
ORDER BY fecha DESC;

/*TEST 6: Reporte de Asistencia por Entrenamiento usando VISTA*/
SELECT 
    TO_CHAR(fecha, 'DD/MM/YYYY') AS fechaEntrenamiento,
    COUNT(*) AS totalParticipantes,
    SUM(CASE WHEN asistencia = 'S' THEN 1 ELSE 0 END) AS asistentes,
    SUM(CASE WHEN asistencia = 'N' THEN 1 ELSE 0 END) AS inasistentes,
    ROUND((SUM(CASE WHEN asistencia = 'S' THEN 1 ELSE 0 END) / 
           COUNT(*)) * 100, 2) AS porcentajeAsistencia
FROM vw_asistencia_entrenamientos
WHERE asistencia IN ('S', 'N')
GROUP BY fecha
ORDER BY fecha DESC;

/*TEST 7: Filtro optimizado de Pagos por estado usando índice*/
SELECT 
    p.idPago,
    i.idInscripcion,
    p.monto,
    p.estadoPago,
    p.metodoPago,
    TO_CHAR(p.fechaPago, 'DD/MM/YYYY') AS fechaPago
FROM Pago p
JOIN Inscripcion i ON p.idInscripcion = i.idInscripcion
WHERE p.estadoPago = 'PAGADO'
ORDER BY p.fechaPago DESC;

/*TEST 8: Búsqueda de Entrenamientos Programados usando índice*/
SELECT 
    e.idEntrenamiento,
    TO_CHAR(e.fecha, 'DD/MM/YYYY') AS fechaEntrenamiento,
    TO_CHAR(e.hora, 'HH24:MI') AS hora,
    e.lugar,
    eq.nombre AS equipoNombre
FROM Entrenamiento e
JOIN Equipo eq ON e.idEquipo = eq.idEquipo
WHERE e.estado = 'PROGRAMADO'
ORDER BY e.fecha;

/*TEST 9: Distribución de Jugadores por Categoría usando VISTA*/
SELECT 
    categoriaNombre,
    nivel,
    cantidadJugadores
FROM vw_jugadores_categoria
WHERE cantidadJugadores > 0
ORDER BY categoriaNombre;

/*TEST 10: Asistencia consolidada por Persona*/
SELECT 
    a.idPersona,
    a.nombres,
    a.apellidos,
    a.posicion,
    COUNT(*) AS totalEntrenamientos,
    SUM(CASE WHEN a.asistencia = 'S' THEN 1 ELSE 0 END) AS asistencias,
    SUM(CASE WHEN a.asistencia = 'N' THEN 1 ELSE 0 END) AS inasistencias,
    ROUND((SUM(CASE WHEN a.asistencia = 'S' THEN 1 ELSE 0 END) / 
           COUNT(*)) * 100, 2) AS porcentajeAsistencia
FROM vw_asistencia_entrenamientos a
GROUP BY a.idPersona, a.nombres, a.apellidos, a.posicion
ORDER BY porcentajeAsistencia DESC;


/* PROYECTO: Formando Campeones
   CICLO 2
   OBJETIVO: Consultas que demuestran el uso de índices y vistas */

/* TEST 11:
Consulta de Planificaciones con datos de entrenamiento usando VISTA */
SELECT 
    idPlanificacion,
    titulo,
    nombreEquipo,
    lugar,
    duracion,
    TO_CHAR(fecha, 'DD/MM/YYYY') AS fechaEntrenamiento
FROM vw_planificaciones_entrenamiento
ORDER BY fechaCreacion DESC;

/* TEST 12:
Búsqueda optimizada de Planificaciones por Entrenamiento usando índice */
SELECT 
    p.idPlanificacion,
    p.titulo,
    p.objetivo,
    p.duracion,
    e.lugar
FROM Planificacion p
JOIN Entrenamiento e
    ON p.idEntrenamiento = e.idEntrenamiento
WHERE p.idEntrenamiento = 500;

/* TEST 13:
Reporte de Evaluaciones de Jugadores usando VISTA */
SELECT 
    nombreJugador,
    posicion,
    nombreEntrenador,
    calificacion,
    descripcion,
    TO_CHAR(fechaEvaluacion, 'DD/MM/YYYY') AS fechaEvaluacion
FROM vw_evaluaciones_jugadores
ORDER BY calificacion DESC;

/* TEST 14:
Búsqueda optimizada de Evaluaciones por Jugador usando índice */
SELECT 
    ev.idEvaluacion,
    ev.calificacion,
    ev.descripcion,
    TO_CHAR(ev.fechaEvaluacion, 'DD/MM/YYYY') AS fechaEvaluacion
FROM Evaluacion ev
WHERE ev.idJugador = 500
ORDER BY ev.calificacion DESC;

/* TEST 15:
Filtro optimizado de Evaluaciones por calificación usando índice */
SELECT 
    idEvaluacion,
    idJugador,
    calificacion,
    descripcion
FROM Evaluacion
WHERE calificacion >= 4
ORDER BY calificacion DESC;


/* TEST 16:
Reporte financiero usando VISTA */
SELECT 
    nombres,
    apellidos,
    nombreEscuela,
    totalPagado,
    totalPendiente,
    totalRegistrado
FROM vw_estado_financiero
ORDER BY totalPagado DESC;


/* TEST 17:
Búsqueda optimizada de EstadoCuenta por Inscripción usando índice */
SELECT 
    idEstadoCuenta,
    totalPagado,
    totalPendiente,
    TO_CHAR(fechaGeneracion, 'DD/MM/YYYY') AS fechaGeneracion
FROM EstadoCuenta
WHERE idInscripcion = 500;


/* TEST 18:
Consulta de Convocatorias Programadas usando VISTA */
SELECT 
    nombreEquipo,
    responsable,
    lugarEvento,
    tipoEvento,
    TO_CHAR(fechaEvento, 'DD/MM/YYYY') AS fechaEvento
FROM vw_convocatorias_programadas
ORDER BY fechaEvento;


/* TEST 19:
Búsqueda optimizada de Convocatorias por Equipo usando índice */
SELECT 
    idConvocatoria,
    lugarEvento,
    tipoEvento,
    estadoEvento
FROM Convocatoria
WHERE idEquipo = 500;


/* TEST 20:
Filtro de Convocatorias por tipo de evento usando índice */
SELECT 
    idConvocatoria,
    lugarEvento,
    estadoEvento,
    TO_CHAR(fechaEvento, 'DD/MM/YYYY') AS fechaEvento
FROM Convocatoria
WHERE tipoEvento = 'OFICIAL'
ORDER BY fechaEvento DESC;


/* TEST 21:
Promedio de Evaluaciones por Jugador usando VISTA */
SELECT 
    nombres,
    apellidos,
    posicion,
    totalEvaluaciones,
    promedioCalificacion,
    calificacionMinima,
    calificacionMaxima
FROM vw_promedio_jugadores
WHERE totalEvaluaciones > 0
ORDER BY promedioCalificacion DESC;

