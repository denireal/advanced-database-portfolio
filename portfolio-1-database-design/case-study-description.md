# Case Study Description

## Selected organisation / scenario

**Student Academic Management and Result Processing System (SAMRPS)**

A realistic academic information system for a polytechnic environment, used as the single case study across all five portfolio activities. The relational database is named `sarms_db`.

## Nature of the business / system

The system models selected academic activities of a polytechnic: setting up departments, programmes (ND and HND), courses and the academic calendar; registering students for courses each semester; recording assessment results; and maintaining user accounts and an audit trail. It is designed to demonstrate database modelling, SQL query processing and optimisation, transaction management, NoSQL data modelling, and distributed/cloud database concepts.

## Users of the database

| User group | What they do in the system |
|---|---|
| **Administrator** | Maintains departments, programmes, courses, sessions, semesters and user accounts |
| **Registry / Exams Officer** (`Registrar` role) | Approves and publishes results, issues transcripts, audits records |
| **Lecturer** | Views their course offerings and class lists, enters CA and exam scores |
| **Student** | Registers for courses, views published results, GPA and transcript |

## Major data to be stored

- **Student management:** student profiles (matric number, programme, level, status)
- **Programme and department management:** departments, programmes (ND / HND), and the programme-course curriculum (core or elective)
- **Lecturer management:** lecturer profiles, department and rank
- **Course management:** courses with credit units and level
- **Academic sessions and semesters:** e.g. 2026/2027, First/Second semester
- **Course offerings:** a course delivered in a semester by a lecturer, with a capacity
- **Course registration:** which student registered for which offering
- **Student results:** CA score, exam score, and the derived total, grade and grade point
- **User management:** system accounts with roles, linked to a student or lecturer profile
- **Audit logging:** who changed what, when, with before and after values

## Key operations the database will support

1. **Register courses:** a student registers for an open course offering, within its capacity.
2. **Enter results:** a lecturer records CA (0-40) and exam (0-60) scores against a registration; total, grade and grade point are derived by the database.
3. **Approve and publish results:** results move Draft -> Submitted -> Approved -> Published.
4. **Compute GPA:** semester GPA and cumulative GPA from grade points weighted by credit units.
5. **Generate academic reports:** student academic profile, registration and teaching-assignment report, and transcripts.
6. **Audit changes:** sensitive changes (e.g. result amendments) are traceable to a user.

## Why this case study suits all five portfolio activities

| Portfolio | How FPE-SAMRPS supports it |
|---|---|
| 1. Design and modelling | 13 tables with 1:N, M:N (resolved), and 1:0..1 relationships, derived data, and a clear normalisation story |
| 2. Query optimisation | Multi-table joins (a seven-table registration and teaching-assignment query) and aggregations over a large registration/result dataset |
| 3. Transactions and concurrency | Registration against limited offering capacity (overbooking race), concurrent result updates, rollback on invalid entries |
| 4. NoSQL | Student transcripts and audit logs as documents; graph or key-value models for curriculum and sessions |
| 5. Distributed and cloud | Sharding by department or session, read replicas for result-checking peaks, availability vs consistency trade-offs |

## Assumptions and scope decisions

- **Awards and levels:** programmes are `ND` (National Diploma), `HND` (Higher National Diploma) or `Certificate`. Levels are stored as 100 = ND1, 200 = ND2, 300 = HND1, 400 = HND2.
- **Grading scale (assumption to confirm):** an NBTE-style 4-point scale with letter codes (A, AB, B, BC, C, CD, D, E, F) is applied to the 100-mark total (CA 40 + exam 60). The bands and grade points are in the `grade` and `grade_point` generated columns of `results`. Confirm them against your polytechnic's approved scale and adjust the two `CASE` expressions if they differ.
- **Lecturer ranks:** Assistant Lecturer, Lecturer III, II and I, Senior Lecturer, Principal Lecturer, Chief Lecturer. Adjust the `ENUM` if your institution uses different titles.
- Each **course offering has one lecturer and one section**. Team teaching and multiple sections are out of scope (they would need an `offering_lecturers` junction table).
- A **student belongs to one programme** at a time (no transfer history).
- A **user account is linked to at most one student or one lecturer**; Admin and Registrar accounts have no profile link.
- **Prerequisites, fees, hostel, SIWES and timetable data are out of scope.**
