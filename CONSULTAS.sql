/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Consultas SQL del proyecto */


/* Consulta 1
   Objetivo: Consultar total recaudado por escuela
   Rol: Administrador */
SELECT
    e.idEscuela,
    e.nombre AS nombreEscuela,
    NVL(SUM(CASE WHEN p.estadoPago = 'PAGADO' THEN p.monto ELSE 0 END), 0) AS totalRecaudado
FROM Escuela e
LEFT JOIN Inscripcion i
    ON e.idEscuela = i.idEscuela
LEFT JOIN Pago p
    ON i.idInscripcion = p.idInscripcion
GROUP BY e.idEscuela, e.nombre
ORDER BY e.idEscuela;


/* Consulta 2
   Objetivo: Consultar jugadores por equipo
   Rol: Administrador */
SELECT DISTINCT
    eq.idEquipo,
    eq.nombre AS nombreEquipo,
    pe.idPersona,
    pe.nombres,
    pe.apellidos,
    j.posicion,
    j.numeroCamiseta
FROM Equipo eq
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
JOIN Participante pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Persona pe
    ON pa.idPersona = pe.idPersona
JOIN Jugador j
    ON pe.idPersona = j.idPersona
WHERE pa.rol = 'JUGADOR'
ORDER BY eq.idEquipo, pe.apellidos, pe.nombres;

/* Consulta 3
   Objetivo: Consultar jugadores por categoría
   Rol: Administrador */
SELECT DISTINCT
    pe.idPersona,
    pe.nombres,
    pe.apellidos,
    c.nombre AS categoria,
    eq.nombre AS equipo,
    j.numeroCamiseta
FROM Categoria c
JOIN Equipo eq
    ON c.idCategoria = eq.idCategoria
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
JOIN Participante pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Persona pe
    ON pa.idPersona = pe.idPersona
JOIN Jugador j
    ON pe.idPersona = j.idPersona
WHERE pa.rol = 'JUGADOR'
ORDER BY c.nombre, eq.nombre, pe.apellidos, pe.nombres;


/* Consulta 4
   Objetivo: Consultar inscripciones con pagos pendientes
   Rol: Administrador */
SELECT
    i.idInscripcion,
    i.idPersona,
    pe.nombres,
    pe.apellidos,
    i.estadoInscripcion,
    NVL(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) AS montoPendiente
FROM Inscripcion i
JOIN Persona pe
    ON i.idPersona = pe.idPersona
LEFT JOIN Pago p
    ON i.idInscripcion = p.idInscripcion
GROUP BY i.idInscripcion, i.idPersona, pe.nombres, pe.apellidos, i.estadoInscripcion
HAVING NVL(SUM(CASE WHEN p.estadoPago = 'PENDIENTE' THEN p.monto ELSE 0 END), 0) > 0
ORDER BY i.idInscripcion;


/* Consulta 5
   Objetivo: Consultar entrenamientos programados por equipo
   Rol: Entrenador */
SELECT
    eq.idEquipo,
    eq.nombre AS nombreEquipo,
    en.idEntrenamiento,
    en.fecha,
    en.hora,
    en.lugar,
    en.estado
FROM Equipo eq
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
WHERE en.estado = 'PROGRAMADO'
ORDER BY eq.idEquipo, en.fecha, en.hora;


/* Consulta 6
   Objetivo: Consultar jugadores de mi equipo
   Rol: Entrenador */
SELECT DISTINCT
    pe.idPersona,
    pe.nombres,
    pe.apellidos,
    j.posicion,
    j.numeroCamiseta,
    eq.nombre AS nombreEquipo
FROM Equipo eq
JOIN Entrenamiento en
    ON eq.idEquipo = en.idEquipo
JOIN Participante pa
    ON en.idEntrenamiento = pa.idEntrenamiento
JOIN Persona pe
    ON pa.idPersona = pe.idPersona
JOIN Jugador j
    ON pe.idPersona = j.idPersona
WHERE pa.rol = 'JUGADOR'
ORDER BY pe.apellidos, pe.nombres;


/* CICLO 2 OBJETIVO: Consultas para las nuevas funcionalidades */

/* CONSULTAS PARA PLANIFICACION */

/*Listar todas las planificaciones con detalles de entrenamiento */
SELECT 
    p.idPlanificacion,
    p.titulo,
    p.descripcion,
    p.objetivo,
    p.duracion,
    p.fechaCreacion,
    e.idEntrenamiento,
    e.fecha,
    e.lugar,
    eq.nombre AS nombreEquipo
FROM Planificacion p
JOIN Entrenamiento e ON p.idEntrenamiento = e.idEntrenamiento
JOIN Equipo eq ON e.idEquipo = eq.idEquipo
ORDER BY p.fechaCreacion DESC;

/*Planificaciones por tipo de entrenamiento */
SELECT 
    titulo,
    COUNT(*) AS cantidad,
    AVG(duracion) AS duracionPromedio,
    MIN(fechaCreacion) AS primeraCreacion,
    MAX(fechaCreacion) AS ultimaCreacion
FROM Planificacion
GROUP BY titulo
ORDER BY cantidad DESC;

/*Planificaciones del último mes */
SELECT 
    p.idPlanificacion,
    p.titulo,
    p.descripcion,
    p.duracion,
    p.fechaCreacion,
    e.lugar
FROM Planificacion p
JOIN Entrenamiento e ON p.idEntrenamiento = e.idEntrenamiento
WHERE p.fechaCreacion >= ADD_MONTHS(TRUNC(SYSDATE), -1)
ORDER BY p.fechaCreacion DESC;


/* CONSULTAS PARA EVALUACION*/

SELECT 
    ev.idEvaluacion,
    ev.fechaEvaluacion,
    ev.calificacion,
    ev.descripcion,
    ent.idPersona AS idEntrenador,
    per_ent.nombres || ' ' || per_ent.apellidos AS nombreEntrenador,
    jug.idPersona AS idJugador,
    per_jug.nombres || ' ' || per_jug.apellidos AS nombreJugador
FROM Evaluacion ev
JOIN Entrenador ent 
    ON ev.idEntrenador = ent.idPersona
JOIN Persona per_ent 
    ON ent.idPersona = per_ent.idPersona
JOIN Jugador jug 
    ON ev.idJugador = jug.idPersona
JOIN Persona per_jug 
    ON jug.idPersona = per_jug.idPersona
WHERE ev.idJugador = &idJugador
ORDER BY ev.fechaEvaluacion DESC;


/*Promedio de calificaciones por jugador */
SELECT 
    jug.idPersona,
    per.nombres || ' ' || per.apellidos AS nombreJugador,
    jug.posicion,
    COUNT(ev.idEvaluacion) AS totalEvaluaciones,
    ROUND(AVG(ev.calificacion), 2) AS calificacionPromedio,
    MIN(ev.calificacion) AS calificacionMinima,
    MAX(ev.calificacion) AS calificacionMaxima
FROM Evaluacion ev
JOIN Jugador jug 
    ON ev.idJugador = jug.idPersona
JOIN Persona per 
    ON jug.idPersona = per.idPersona
GROUP BY 
    jug.idPersona,
    per.nombres,
    per.apellidos,
    jug.posicion
ORDER BY calificacionPromedio DESC;



/*Jugadores con mejor desempeño (calificación >= 4)*/
SELECT 
    jug.idPersona,
    per.nombres || ' ' || per.apellidos AS nombreJugador,
    jug.posicion,
    ROUND(AVG(ev.calificacion), 2) AS calificacionPromedio,
    COUNT(ev.idEvaluacion) AS totalEvaluaciones
FROM Evaluacion ev
INNER JOIN Jugador jug
    ON ev.idJugador = jug.idPersona
INNER JOIN Persona per
    ON jug.idPersona = per.idPersona
GROUP BY 
    jug.idPersona,
    per.nombres,
    per.apellidos,
    jug.posicion
HAVING AVG(ev.calificacion) >= 4
ORDER BY calificacionPromedio DESC;


/*CONSULTAS PARA ESTADO DE CUENTA*/
/*Estados de cuenta con detalles de inscripción*/
SELECT 
    ec.idEstadoCuenta,
    ec.fechaGeneracion,
    ec.totalPagado,
    ec.totalPendiente,
    (ec.totalPagado + ec.totalPendiente) AS totalRegistrado,
    per.nombres || ' ' || per.apellidos AS nombrePersona,
    per.correo,
    ins.fechaInscripcion
FROM EstadoCuenta ec
JOIN Inscripcion ins ON ec.idInscripcion = ins.idInscripcion
JOIN Persona per ON ins.idPersona = per.idPersona
ORDER BY ec.fechaGeneracion DESC;

/*Resumen financiero por estado de cuenta */
SELECT 
    COUNT(*) AS totalRegistros,
    SUM(ec.totalPagado) AS totalPagado,
    SUM(ec.totalPendiente) AS totalPendiente,
    SUM(ec.totalPagado) + SUM(ec.totalPendiente) AS totalRegistrado,
    ROUND(
        SUM(ec.totalPagado) /
        NULLIF(
            SUM(ec.totalPagado) + SUM(ec.totalPendiente),
            0
        ) * 100,
        2
    ) AS porcentajeRecaudacion
FROM EstadoCuenta ec;

/*CONSULTAS PARA CONVOCATORIA*/

/*Convocatorias por estado*/
SELECT 
    cv.idConvocatoria,
    cv.fechaEvento,
    cv.estadoEvento,
    cv.tipoEvento,
    cv.lugarEvento,
    cv.descripcion,
    per.nombres || ' ' || per.apellidos AS nombreResponsable,
    eq.nombre AS nombreEquipo
FROM Convocatoria cv
JOIN Persona per ON cv.idPersona = per.idPersona
JOIN Equipo eq ON cv.idEquipo = eq.idEquipo
WHERE cv.estadoEvento = 'PROGRAMADA' -- Cambiar según necesidad
ORDER BY cv.fechaEvento ASC;


/*Historial de convocatorias de un equipo */
SELECT 
    cv.idConvocatoria,
    cv.fechaEvento,
    cv.estadoEvento,
    cv.tipoEvento,
    cv.lugarEvento,
    per.nombres || ' ' || per.apellidos AS nombreResponsable,
    cv.descripcion
FROM Convocatoria cv
JOIN Persona per 
    ON cv.idPersona = per.idPersona
WHERE cv.idEquipo = &idEquipo
ORDER BY cv.fechaEvento DESC;

/*Estadísticas de convocatorias por tipo de evento */
SELECT 
    tipoEvento,
    COUNT(*) AS totalConvocatorias,
    SUM(CASE WHEN estadoEvento = 'PROGRAMADA' THEN 1 ELSE 0 END) AS programadas,
    SUM(CASE WHEN estadoEvento = 'REALIZADA' THEN 1 ELSE 0 END) AS realizadas,
    SUM(CASE WHEN estadoEvento = 'CANCELADA' THEN 1 ELSE 0 END) AS canceladas
FROM Convocatoria
GROUP BY tipoEvento;

