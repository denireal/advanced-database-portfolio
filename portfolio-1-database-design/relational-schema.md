# Relational Schema

**Notation:** `table(` **primary key**, *foreign key* `->` referenced table, plain attributes `)`. Alternate (candidate) keys are listed under each relation. Full data types are in [`database/02_create_tables.sql`](../database/02_create_tables.sql).

## Relations

```
academic_sessions(
  session_id PK, session_name, start_date, end_date, status)
  UNIQUE(session_name)

semesters(
  semester_id PK, session_id FK -> academic_sessions, semester_name)
  UNIQUE(session_id, semester_name)

departments(
  department_id PK, department_code, department_name, created_at)
  UNIQUE(department_code), UNIQUE(department_name)

programmes(
  programme_id PK, department_id FK -> departments,
  programme_code, programme_name, award_type, duration_years)
  UNIQUE(programme_code)

students(
  student_id PK, programme_id FK -> programmes, matric_no, first_name,
  last_name, gender, date_of_birth, email, phone, admission_year,
  academic_level, status, created_at)
  UNIQUE(matric_no), UNIQUE(email)

lecturers(
  lecturer_id PK, department_id FK -> departments, staff_no, first_name,
  last_name, email, academic_rank, status)
  UNIQUE(staff_no), UNIQUE(email)

courses(
  course_id PK, department_id FK -> departments, course_code,
  course_title, credit_unit, level, semester_type)
  UNIQUE(course_code)

programme_courses(
  (programme_id FK -> programmes, course_id FK -> courses) PK,
  course_status)

course_offerings(
  offering_id PK, course_id FK -> courses, semester_id FK -> semesters,
  lecturer_id FK -> lecturers, max_capacity, status)
  UNIQUE(course_id, semester_id)

course_registrations(
  registration_id PK, student_id FK -> students,
  offering_id FK -> course_offerings, registration_date, status)
  UNIQUE(student_id, offering_id)

users(
  user_id PK, username, password_hash, role,
  student_id FK -> students (nullable), lecturer_id FK -> lecturers (nullable),
  status, created_at)
  UNIQUE(username), UNIQUE(student_id), UNIQUE(lecturer_id)

results(
  result_id PK, registration_id FK -> course_registrations,
  ca_score, exam_score, total_score*, grade*, grade_point*, remark,
  result_status, entered_by FK -> users, entered_at)
  UNIQUE(registration_id)
  * generated (derived) columns

audit_logs(
  audit_id PK, user_id FK -> users, action, table_name, record_id,
  old_value, new_value, action_time)
```

## Foreign key map

| Child table | FK column | Parent table | ON DELETE | ON UPDATE |
|---|---|---|---|---|
| semesters | session_id | academic_sessions | RESTRICT | CASCADE |
| programmes | department_id | departments | RESTRICT | CASCADE |
| students | programme_id | programmes | RESTRICT | CASCADE |
| lecturers | department_id | departments | RESTRICT | CASCADE |
| courses | department_id | departments | RESTRICT | CASCADE |
| programme_courses | programme_id | programmes | CASCADE | CASCADE |
| programme_courses | course_id | courses | CASCADE | CASCADE |
| course_offerings | course_id | courses | RESTRICT | CASCADE |
| course_offerings | semester_id | semesters | RESTRICT | CASCADE |
| course_offerings | lecturer_id | lecturers | RESTRICT | CASCADE |
| course_registrations | student_id | students | RESTRICT | CASCADE |
| course_registrations | offering_id | course_offerings | RESTRICT | CASCADE |
| users | student_id | students | RESTRICT | RESTRICT |
| users | lecturer_id | lecturers | RESTRICT | RESTRICT |
| results | registration_id | course_registrations | RESTRICT | CASCADE |
| results | entered_by | users | RESTRICT | CASCADE |
| audit_logs | user_id | users | RESTRICT | CASCADE |

## Mapping decisions (ER to relational)

- **1 : N relationships** become a foreign key on the "many" side.
- **M : N: programmes and courses** is resolved with `programme_courses`, whose primary key is the composite of both foreign keys. The `course_status` attribute (Core/Elective) belongs to the relationship, not to either entity.
- **M : N: students and course offerings** is resolved with `course_registrations`. It has its own surrogate key `registration_id` because `results` and the audit trail reference an individual registration. `UNIQUE(student_id, offering_id)` still prevents duplicates.
- **1 : 0..1: registration and result** is a foreign key in `results` with a UNIQUE constraint, so a registration can have at most one result.
- **1 : 0..1: user and profile:** two nullable, unique foreign keys in `users`, with a CHECK that forces the right one to be set for each role.
- **Surrogate keys:** every entity table uses `AUTO_INCREMENT` integer keys, while natural identifiers (matric number, staff number, course code, etc.) are kept as UNIQUE alternate keys so they can change format without cascading through the schema.
