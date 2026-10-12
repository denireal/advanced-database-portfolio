# Keys and Integrity Constraints Specification

To enforce relational integrity, security access levels, and advanced audit trails across the Southern Technical University database, the following primary keys, foreign keys, unique constraints, and check constraints are implemented:

## 1. Primary Keys (PK)
* **`Department(dept_id)`**: Uniquely identifies each academic department.
* **`AdminUser(admin_id)`**: Uniquely identifies each system administrator or portal operator.
* **`Lecturer(lecturer_id)`**: Uniquely identifies each faculty member.
* **`Student(student_id)`**: Uniquely identifies each student record.
* **`Course(course_id)`**: Uniquely identifies each institutional course offering.
* **`Enrollment(enrollment_id)`**: Uniquely identifies each student registration instance for a specific course and session.

## 2. Foreign Keys (FK) & Referencing Actions
* **`AdminUser(dept_id) -> Department(dept_id)`**: Restricts specific administrative accounts (such as Deans) to a designated department (`ON DELETE SET NULL`).
* **`AdminUser(created_by) -> AdminUser(admin_id)`**: Self-referencing foreign key tracking which administrator created another account for internal audit logging (`ON DELETE SET NULL`).
* **`Lecturer(dept_id) -> Department(dept_id)`**: Links lecturers to their parent department (`ON DELETE SET NULL`).
* **`Student(dept_id) -> Department(dept_id)`**: Associates students with their major department (`ON DELETE SET NULL`).
* **`Course(dept_id) -> Department(dept_id)`**: Associates courses with the department responsible for teaching them (`ON DELETE CASCADE`).
* **`Enrollment(student_id) -> Student(student_id)`**: Connects enrollment records to the specific student (`ON DELETE CASCADE`).
* **`Enrollment(course_id) -> Course(course_id)`**: Connects enrollment records to the corresponding course (`ON DELETE CASCADE`).

## 3. Unique & Restricted Constraints (UK / ENUM)
* **`Department(dept_name)`**: Ensures no duplicate department names exist.
* **`AdminUser(username)` & `AdminUser(email)`**: Ensures administrator accounts are strictly unique.
* **`AdminUser(role)`**: Restricted via an `ENUM` constraint (`SuperAdmin`, `Registrar`, `ITSupport`, `Dean`).
* **`AdminUser(status)`**: Controlled via an `ENUM` constraint (`Active`, `Suspended`, `Deactivated`) for account lifecycle management.
* **`Lecturer(email)` & `Student(email)`**: Guarantees communication emails remain unique across users.
* **`Student(matric_no)`**: Ensures university identification numbers are strictly unique per student.
* **`Course(course_code)`**: Prevents duplicate course code assignments.
* **`UC_student_course_session (student_id, course_id, semester, academic_session)`**: Prevents duplicate course registrations in the same term.

## 4. Check Constraints
* **`Course(credits > 0)`**: Ensures that all courses carry a positive credit unit value.
* **`Enrollment(score BETWEEN 0.00 AND 100.00)`**: Validates that assessment score entries stay within valid percentage bounds.