/* PROYECTO: Formando Campeones
   CICLO 1
   OBJETIVO: Restricciones declarativas. */

/* PRIMARIAS */
ALTER TABLE Persona
    ADD CONSTRAINT pk_persona PRIMARY KEY (idPersona);

ALTER TABLE Jugador
    ADD CONSTRAINT pk_jugador PRIMARY KEY (idPersona);

ALTER TABLE Acudiente
    ADD CONSTRAINT pk_acudiente PRIMARY KEY (idPersona);

ALTER TABLE Administrador
    ADD CONSTRAINT pk_administrador PRIMARY KEY (idPersona);

ALTER TABLE Entrenador
    ADD CONSTRAINT pk_entrenador PRIMARY KEY (idPersona);

ALTER TABLE Escuela
    ADD CONSTRAINT pk_escuela PRIMARY KEY (idEscuela);

ALTER TABLE Categoria
    ADD CONSTRAINT pk_categoria PRIMARY KEY (idCategoria);

ALTER TABLE Equipo
    ADD CONSTRAINT pk_equipo PRIMARY KEY (idEquipo);

ALTER TABLE Inscripcion
    ADD CONSTRAINT pk_inscripcion PRIMARY KEY (idInscripcion);

ALTER TABLE Pago
    ADD CONSTRAINT pk_pago PRIMARY KEY (idPago);

ALTER TABLE Entrenamiento
    ADD CONSTRAINT pk_entrenamiento PRIMARY KEY (idEntrenamiento);

ALTER TABLE Participante
    ADD CONSTRAINT pk_participante PRIMARY KEY (idPersona, idEntrenamiento);
ALTER TABLE Recibe
    ADD CONSTRAINT pk_recibe PRIMARY KEY (idEntrenamiento,idEquipo);
    

/* UNICAS */
ALTER TABLE Persona
    ADD CONSTRAINT uk_persona_documento UNIQUE (documento);

ALTER TABLE Persona
    ADD CONSTRAINT uk_persona_correo UNIQUE (correo);

ALTER TABLE Persona 
    ADD CONSTRAINT uk_persona_telefono UNIQUE (telefono);

ALTER TABLE Escuela
    ADD CONSTRAINT uk_escuela_direccion UNIQUE (direccion);

ALTER TABLE Escuela
    ADD CONSTRAINT uk_escuela_correo UNIQUE (correo);

ALTER TABLE Escuela
    ADD CONSTRAINT uk_escuela_telefono UNIQUE (telefono);

/*Unica ciclo 2*/

ALTER TABLE Convocatoria
    ADD CONSTRAINT uk_convocatoria_lugar UNIQUE (lugarEvento);

/* FORANEAS */
ALTER TABLE Jugador
    ADD CONSTRAINT fk_jugador_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Acudiente
    ADD CONSTRAINT fk_acudiente_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Administrador
    ADD CONSTRAINT fk_administrador_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Entrenador
    ADD CONSTRAINT fk_entrenador_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Equipo
    ADD CONSTRAINT fk_equipo_escuela
    FOREIGN KEY (idEscuela) REFERENCES Escuela(idEscuela);

ALTER TABLE Equipo
    ADD CONSTRAINT fk_equipo_categoria
    FOREIGN KEY (idCategoria) REFERENCES Categoria(idCategoria);

ALTER TABLE Inscripcion
    ADD CONSTRAINT fk_inscripcion_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Inscripcion
    ADD CONSTRAINT fk_inscripcion_escuela
    FOREIGN KEY (idEscuela) REFERENCES Escuela(idEscuela);

ALTER TABLE Pago
    ADD CONSTRAINT fk_pago_inscripcion
    FOREIGN KEY (idInscripcion) REFERENCES Inscripcion(idInscripcion);

ALTER TABLE Entrenamiento
    ADD CONSTRAINT fk_entrenamiento_equipo
    FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo);

ALTER TABLE Participante
    ADD CONSTRAINT fk_participante_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Participante
    ADD CONSTRAINT fk_participante_entrenamiento
    FOREIGN KEY (idEntrenamiento) REFERENCES Entrenamiento(idEntrenamiento);

ALTER TABLE Recibe
    ADD CONSTRAINT fk_recibe_entrenamiento 
    FOREIGN KEY (idEntrenamiento) REFERENCES Entrenamiento (idEntrenamiento);
    
ALTER TABLE Recibe
    ADD CONSTRAINT fk_recibe_equipo 
    FOREIGN KEY (idEquipo) REFERENCES Equipo (idEquipo);

/* PRIMARIAS - CICLO 2 */
ALTER TABLE Planificacion
    ADD CONSTRAINT pk_planificacion PRIMARY KEY (idPlanificacion);

ALTER TABLE Evaluacion
    ADD CONSTRAINT pk_evaluacion PRIMARY KEY (idEvaluacion);

ALTER TABLE EstadoCuenta
    ADD CONSTRAINT pk_estadocuenta PRIMARY KEY (idEstadoCuenta);

ALTER TABLE Convocatoria
    ADD CONSTRAINT pk_convocatoria PRIMARY KEY (idConvocatoria);

/* FORANEAS - CICLO 2 */
ALTER TABLE Planificacion
    ADD CONSTRAINT fk_planificacion_entrenamiento
    FOREIGN KEY (idEntrenamiento) REFERENCES Entrenamiento(idEntrenamiento);

ALTER TABLE Evaluacion
    ADD CONSTRAINT fk_evaluacion_entrenador
    FOREIGN KEY (idEntrenador) REFERENCES Entrenador(idPersona);

ALTER TABLE Evaluacion
    ADD CONSTRAINT fk_evaluacion_jugador
    FOREIGN KEY (idJugador) REFERENCES Jugador(idPersona);

ALTER TABLE Convocatoria
    ADD CONSTRAINT fk_convocatoria_persona
    FOREIGN KEY (idPersona) REFERENCES Persona(idPersona);

ALTER TABLE Convocatoria
    ADD CONSTRAINT fk_convocatoria_equipo
    FOREIGN KEY (idEquipo) REFERENCES Equipo(idEquipo);

ALTER TABLE EstadoCuenta
    ADD CONSTRAINT fk_estadocuenta_inscripcion
    FOREIGN KEY (idInscripcion) REFERENCES Inscripcion(idInscripcion);

    
/* CHECK */
ALTER TABLE Jugador
    ADD CONSTRAINT ck_jugador_numeroCamiseta
    CHECK (numeroCamiseta > 0);

ALTER TABLE Pago
    ADD CONSTRAINT ck_pago_monto
    CHECK (monto > 0);

ALTER TABLE Pago
    ADD CONSTRAINT ck_pago_estado
    CHECK (estadoPago IN ('PENDIENTE', 'PAGADO', 'ANULADO'));

ALTER TABLE Pago
    ADD CONSTRAINT ck_pago_metodo
    CHECK (metodoPago IN ('EFECTIVO', 'TRANSFERENCIA', 'TARJETA'));

ALTER TABLE Inscripcion
    ADD CONSTRAINT ck_inscripcion_estado
    CHECK (estadoInscripcion IN ('ACTIVA', 'PENDIENTE', 'CANCELADA'));

ALTER TABLE Equipo
    ADD CONSTRAINT ck_equipo_estado
    CHECK (estadoEquipo IN ('ACTIVO', 'INACTIVO'));

ALTER TABLE Entrenamiento
    ADD CONSTRAINT ck_entrenamiento_estado
    CHECK (estado IN ('PROGRAMADO', 'REALIZADO', 'CANCELADO'));

ALTER TABLE Categoria
    ADD CONSTRAINT ck_categoria_nivel
    CHECK (nivel IN ('BASICO', 'INTERMEDIO', 'AVANZADO'));

ALTER TABLE Participante
    ADD CONSTRAINT ck_participa_asistencia
    CHECK (asistencia IN ('S', 'N'));
    
ALTER TABLE Recibe
    ADD CONSTRAINT ck_recibe_asistencia
    CHECK (asistencia IN ('S', 'N'));

ALTER TABLE Participante
    ADD CONSTRAINT ck_participa_rol
    CHECK (rol IN ('JUGADOR', 'ACUDIENTE', 'ENTRENADOR', 'ADMINISTRADOR'));

/* CHECK - CICLO 2 */
ALTER TABLE Planificacion
    ADD CONSTRAINT ck_planificacion_titulo
    CHECK (titulo IN ('RESISTENCIA', 'FUERZA', 'TACTICA', 'TECNICA'));

ALTER TABLE Convocatoria
    ADD CONSTRAINT ck_convocatoria_estado
    CHECK (estadoEvento IN ('PROGRAMADA', 'REALIZADA', 'CANCELADA'));

ALTER TABLE Convocatoria
    ADD CONSTRAINT ck_convocatoria_evento
    CHECK (tipoEvento IN ('PARTIDO_AMISTOSO', 'OFICIAL'));

ALTER TABLE Evaluacion
    ADD CONSTRAINT ck_evaluacion_calificacion
    CHECK (calificacion >= 1 AND calificacion <= 5);

