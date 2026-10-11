# Keys and Constraints

All constraints below are declared in [`database/02_create_tables.sql`](../database/02_create_tables.sql) and exercised by [`database/04_verification_queries.sql`](../database/04_verification_queries.sql).

## 1. Primary keys

| Table | Primary key | Type | Why |
|---|---|---|---|
| academic_sessions, semesters, departments, programmes, students, lecturers, courses, course_offerings, course_registrations, users, results | `<table>_id` | surrogate, `INT UNSIGNED AUTO_INCREMENT` | Small, stable, never changes; natural identifiers stay as UNIQUE keys |
| programme_courses | (`programme_id`, `course_id`) | composite | A pure junction row is identified by the pair it links |
| audit_logs | `audit_id` | `BIGINT UNSIGNED AUTO_INCREMENT` | Append-only table expected to grow fastest |

## 2. Candidate (alternate) keys: UNIQUE constraints

| Table | UNIQUE constraint | Business rule |
|---|---|---|
| academic_sessions | `session_name` | One row per session label |
| semesters | (`session_id`, `semester_name`) | A session has only one First and one Second semester |
| departments | `department_code`, `department_name` | No duplicate departments |
| programmes | `programme_code` | |
| students | `matric_no`, `email` | Matric number and email identify one student |
| lecturers | `staff_no`, `email` | |
| courses | `course_code` | |
| course_offerings | (`course_id`, `semester_id`) | A course is offered at most once per semester (single section) |
| course_registrations | (`student_id`, `offering_id`) | No duplicate registration for the same offering |
| results | `registration_id` | At most one result per registration (enforces the 1 : 0..1) |
| users | `username`, `student_id`, `lecturer_id` | One account per student/lecturer; unique login names |

## 3. Foreign keys and referential actions

The full list is in [`relational-schema.md`](relational-schema.md). The policy was:

- **`ON DELETE RESTRICT` by default.** Academic records must not disappear silently. A department with programmes, courses or lecturers cannot be deleted, and a student with registrations cannot be deleted. Students leave via `status = 'Withdrawn'`, not by deletion.
- **`ON UPDATE CASCADE`** on most keys. Surrogate keys do not normally change, but if one is corrected the change propagates safely.
- **`ON DELETE CASCADE` only on `programme_courses`.** It is a pure link table with no independent meaning, so link rows should vanish when a programme or course is removed.
- **`users` foreign keys use RESTRICT for both actions.** MySQL does not allow a CHECK constraint on a column that has a CASCADE or SET NULL referential action, and `users.student_id` / `users.lecturer_id` take part in the role-link CHECK. Surrogate keys do not change, so nothing is lost.

## 4. CHECK constraints

| Table | Constraint | Rule |
|---|---|---|
| academic_sessions | `ck_session_dates` | `end_date > start_date` |
| programmes | `ck_programme_duration` | `duration_years BETWEEN 1 AND 5` |
| students | `ck_students_level` | `academic_level IN (100, 200, 300, 400)` (ND1, ND2, HND1, HND2) |
| courses | `ck_courses_credit` | `credit_unit BETWEEN 1 AND 6` |
| courses | `ck_courses_level` | `level IN (100, 200, 300, 400)` |
| course_offerings | `ck_offering_capacity` | `max_capacity > 0` |
| results | `ck_results_ca` | `ca_score BETWEEN 0 AND 40` |
| results | `ck_results_exam` | `exam_score BETWEEN 0 AND 60` |
| users | `ck_users_role_link` | Student accounts must have only `student_id`; Lecturer accounts only `lecturer_id`; Admin/Registrar accounts neither |

## 5. Domain constraints (ENUM)

`status`, `role`, `gender`, `award_type`, `semester_type`, `course_status`, `academic_rank`, `result_status` and `action` are `ENUM` columns, so only listed values are accepted. This keeps the schema self-documenting. The trade-off is that adding a value needs an `ALTER TABLE`; for values that change often, a lookup table is the more flexible alternative.

## 5a. NOT NULL and DEFAULT constraints

- Every column that the business needs is `NOT NULL`. Only genuinely optional data is nullable: `students.phone`, `results.remark`, `users.student_id`/`lecturer_id`, `audit_logs.record_id`/`old_value`/`new_value`.
- Defaults: `status` columns start in their initial state (`'Active'`, `'Open'`, `'Registered'`, `'Draft'`), timestamps default to `CURRENT_TIMESTAMP`, `max_capacity` defaults to 100.

## 6. Generated (derived) columns

`results.total_score`, `grade` and `grade_point` are `GENERATED ALWAYS ... STORED`. The database computes them from `ca_score` and `exam_score`, so they cannot be inserted directly or drift out of sync. See [`normalisation.md`](normalisation.md) for why this matters.

## 7. Indexes

InnoDB automatically indexes primary keys, UNIQUE keys and foreign key columns. Extra secondary indexes were added for foreign keys not already covered by a UNIQUE key (e.g. `students.programme_id`, `course_registrations.offering_id`) and for expected audit lookups (`audit_logs(user_id, action_time)` and `(table_name, record_id)`). Index effectiveness is analysed properly with `EXPLAIN` in Portfolio 2.

## 8. Rules NOT enforceable declaratively (deferred)

These business rules cannot be expressed as simple keys or CHECKs. They need triggers or transaction logic, which Portfolio 3 will address.

| Rule | Planned mechanism |
|---|---|
| Registrations for an offering must not exceed `max_capacity` | Transaction with `SELECT ... FOR UPDATE` on the offering row (Portfolio 3) |
| A student may only register for an `Open` offering | Stored procedure / transaction |
| A student may only take courses in their programme's curriculum (or approved electives) | Stored procedure checking `programme_courses` |
| Results can only be entered for registrations with status `Registered` | Trigger or stored procedure |
| `result_status` must move Draft -> Submitted -> Approved -> Published | Trigger |
| Every INSERT/UPDATE on `results` writes an `audit_logs` row | Trigger |
| Session date ranges must not overlap | Trigger |

## 9. Constraint verification evidence

Running `04_verification_queries.sql` demonstrates that each rule is enforced. Run it on **your own server (MySQL or MariaDB via WAMP)**, save the output and screenshots in `evidence/`, and confirm they match the table below. (Exact error numbers for CHECK failures differ slightly between MySQL, which reports 3819, and MariaDB.)

| Test | Result |
|---|---|
| Duplicate matric number | ERROR 1062 (UNIQUE) |
| Duplicate registration | ERROR 1062 (UNIQUE) |
| Student with non-existent programme | ERROR 1452 (FOREIGN KEY) |
| `exam_score` = 75 | CHECK constraint failed |
| `credit_unit` = 9 | CHECK constraint failed |
| Session end before start | CHECK constraint failed |
| Student account without `student_id` | CHECK constraint failed |
| Second result for one registration | ERROR 1062 (UNIQUE) |
| Delete department with dependants | ERROR 1451 (FOREIGN KEY RESTRICT) |
| Result without `entered_by` | ERROR 1364 (NOT NULL, no default) |
| `academic_level` = 700 | CHECK constraint failed |
| Valid result (38 + 52 = 90) | Succeeds, grade `A`, grade point `4.00` derived automatically |
