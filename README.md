# PROYECTO-BASE-DE-DATOS
Formando Campeones es un Sistema profesional de gestión de academias de fútbol

**Sistema integral de gestión de escuelas de fútbol en Oracle 12c con arquitectura de 4 capas**

## 📋 Descripción General

Formando Campeones es un sistema empresarial de gestión para academias de fútbol que implementa una **arquitectura de 4 capas** en Oracle 12c:

- **Capa 1 (DATA):** Tablas, restricciones, disparadores, índices y vistas
- **Capa 2 (COMPONENTES):** Paquetes PL/SQL con lógica de negocio (PC_*, PK_*)
- **Capa 3 (ACTORES):** Paquetes wrapper façade (PA_ADMINISTRADOR, PA_ENTRENADOR, PA_GERENTE)
- **Capa 4 (SEGURIDAD):** Control de acceso basado en roles Oracle (C##ADMINISTRADOR, C##ENTRENADOR, C##GERENTE)

El sistema gestiona **escuelas, equipos, jugadores, entrenamientos, asistencia, inscripciones y pagos** con validaciones multinivel y control de acceso granular.

---

## 🎯 Características Principales

### ✅ Funcionalidad Completa

| Módulo | Descripción |
|--------|-------------|
| **Gestión de Personas** | Registro de jugadores, entrenadores, administradores y acudientes |
| **Escuelas y Equipos** | Creación de sedes, categorías de juego y equipos |
| **Inscripciones** | Registro de jugadores en escuelas con estados (PENDIENTE, ACTIVA, RETIRADA) |
| **Pagos** | Procesamiento de inscripciones con validación de montos y métodos |
| **Entrenamientos** | Programación de sesiones con asistencia y observaciones automáticas |
| **Reportes Gerenciales** | Informes de recaudos, demanda, asistencia y desempeño |

### 🔐 Seguridad Multinivel

```
┌─────────────────────────────────────────────┐
│ Capa 4: Roles Oracle (C##ADMINISTRADOR, etc) │
└─────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────┐
│ Capa 3: Actores (PA_ADMINISTRADOR, etc)     │
│ - Control de transacciones                   │
│ - Autorización de operaciones                │
└─────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────┐
│ Capa 2: Componentes (PC_PERSONA, etc)      │
│ - Validaciones de negocio                    │
│ - Procesamiento de datos                     │
└─────────────────────────────────────────────┘
                     ↓
┌─────────────────────────────────────────────┐
│ Capa 1: Data (13 tablas con restricciones) │
│ - Check constraints                          │
│ - Disparadores automáticos                   │
│ - Cascadas de eliminación                    │
└─────────────────────────────────────────────┘
```

### 📊 Modelo de Datos (13 Tablas)

**Personas:**
- `Persona` - Datos demográficos base
- `Jugador` - Posición y número de camiseta
- `Acudiente` - Guardián del jugador
- `Administrador` - Personal administrativo
- `Entrenador` - Staff de entrenamiento

**Institucionales:**
- `Escuela` - Sedes de la academia
- `Categoria` - Categorías de edad (SUB10, SUB12, etc)
- `Equipo` - Grupos de jugadores

**Operacional:**
- `Inscripcion` - Registro de jugador en escuela
- `Pago` - Transacciones (EFECTIVO, TRANSFERENCIA, TARJETA)
- `Entrenamiento` - Sesiones de entrenamiento
- `Participante` - Asistencia individual
- `Recibe` - Asistencia grupal

### 🔄 Transaccionalidad Automática

Cada operación en la capa ACTORES gestiona automáticamente:
- ✅ **COMMIT** en éxito
- ↩️ **ROLLBACK** en error
- 🚨 **Errores específicos** (-20000 a -20099)
