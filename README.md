# Football Academy Management System

A professional football academy management system built on **Oracle Database 12c**, following a **four-layer enterprise architecture**.

## 📋 Overview

**Football Academy Management System** is an enterprise-grade database application designed to manage the daily operations of football academies. The project follows a **four-layer architecture** that separates data, business logic, user access, and security to improve maintainability, scalability, and security.

### Architecture

* **Layer 1 – Data:** Tables, constraints, triggers, indexes, and views.
* **Layer 2 – Business Components:** PL/SQL packages (`PC_*`, `PK_*`) implementing the business logic.
* **Layer 3 – Actors:** Facade wrapper packages (`PA_ADMINISTRATOR`, `PA_COACH`, `PA_MANAGER`) responsible for transaction management and operation authorization.
* **Layer 4 – Security:** Oracle role-based access control using dedicated roles (`C##ADMINISTRATOR`, `C##COACH`, `C##MANAGER`).

The system manages **football academies, teams, players, training sessions, attendance, registrations, and payments**, while enforcing multi-level business validations and fine-grained access control.

---

# 🚀 Key Features

## Complete Management Modules

| Module                  | Description                                                                                   |
| ----------------------- | --------------------------------------------------------------------------------------------- |
| **People Management**   | Register and manage players, coaches, administrators, and guardians.                          |
| **Academies & Teams**   | Create academy branches, age categories, and football teams.                                  |
| **Player Registration** | Register players with enrollment statuses such as **PENDING**, **ACTIVE**, and **WITHDRAWN**. |
| **Payment Management**  | Process registration payments with amount validation and multiple payment methods.            |
| **Training Sessions**   | Schedule training sessions, record attendance, and generate observations automatically.       |
| **Management Reports**  | Generate reports for revenue, attendance, player demand, and overall academy performance.     |

---

# 🔐 Four-Layer Security Architecture

```text
┌────────────────────────────────────────────────────────────┐
│ Layer 4 – Oracle Security Roles                           │
│ (C##ADMINISTRATOR, C##COACH, C##MANAGER)                  │
└────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│ Layer 3 – Actor Packages                                  │
│ (PA_ADMINISTRATOR, PA_COACH, PA_MANAGER)                  │
│ • Transaction management                                  │
│ • Authorization and controlled access                     │
└────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│ Layer 2 – Business Components                             │
│ (PC_PERSON, PK_*, etc.)                                   │
│ • Business rules                                          │
│ • Data processing                                         │
│ • Validation logic                                        │
└────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────┐
│ Layer 1 – Data Layer                                      │
│ • 13 relational tables                                    │
│ • Constraints                                              │
│ • Triggers                                                 │
│ • Indexes                                                  │
│ • Views                                                    │
└────────────────────────────────────────────────────────────┘
```

---

# 🗄️ Database Model

The database consists of **13 relational tables**, organized into three functional domains.

## People

* `Person` — Stores general personal information.
* `Player` — Player-specific information such as position and jersey number.
* `Guardian` — Parent or legal guardian information.
* `Administrator` — Administrative staff.
* `Coach` — Coaching staff.

## Organizational

* `Academy` — Football academy branches.
* `Category` — Age divisions (U10, U12, U14, etc.).
* `Team` — Player teams within each category.

## Operational

* `Registration` — Player enrollment records.
* `Payment` — Registration payment transactions.
* `Training` — Training session scheduling.
* `Participant` — Individual attendance records.
* `Receives` — Group attendance relationships.

---

# 🔄 Automatic Transaction Management

Every operation executed through the **Actor Layer** automatically handles database transactions by providing:

* ✅ Automatic **COMMIT** on successful operations.
* ↩️ Automatic **ROLLBACK** whenever an error occurs.
* 🚨 Custom Oracle exceptions using error codes ranging from **-20000** to **-20099**.
* 🔒 Consistent enforcement of business rules across all modules.

---

# 🛠️ Technologies

* **Oracle Database 12c**
* **PL/SQL**
* **Oracle SQL**
* **Oracle Roles & Privileges**
* **Stored Procedures**
* **Packages**
* **Triggers**
* **Views**
* **Indexes**
* **Check Constraints**

---

# 📌 Design Principles

This project was designed following enterprise database development best practices:

* Layered architecture.
* Separation of concerns.
* Encapsulation through PL/SQL packages.
* Role-based security.
* Centralized business rules.
* Automatic transaction management.
* Data integrity through constraints and triggers.
* Modular and maintainable database components.
