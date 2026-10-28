# Keys and Constraints: Luma Polytechnic Database

## 1. Introduction

Keys and constraints help maintain accuracy, consistency, and integrity in a relational database. The Luma Polytechnic database uses primary keys, foreign keys, unique constraints, CHECK constraints, and indexes to support reliable academic record management.

## 2. Primary Keys

Each main entity has a primary key that uniquely identifies each record.

| Table | Primary Key |
|---|---|
| `departments` | `department_id` |
| `programmes` | `programme_id` |
| `students` | `student_id` |
| `lecturers` | `lecturer_id` |
| `courses` | `course_id` |
| `academic_terms` | `term_id` |
| `course_offerings` | `offering_id` |
| `registrations` | `registration_id` |
| `grades` | `grade_id` |

Primary keys prevent duplicate identifiers and provide stable references between related tables.

## 3. Foreign Keys

Foreign keys maintain relationships between parent and child records.

| Child Table | Foreign-Key Column | Referenced Table | Referenced Column |
|---|---|---|---|
| `programmes` | `department_id` | `departments` | `department_id` |
| `students` | `programme_id` | `programmes` | `programme_id` |
| `lecturers` | `department_id` | `departments` | `department_id` |
| `courses` | `department_id` | `departments` | `department_id` |
| `course_offerings` | `course_id` | `courses` | `course_id` |
| `course_offerings` | `lecturer_id` | `lecturers` | `lecturer_id` |
| `course_offerings` | `term_id` | `academic_terms` | `term_id` |
| `registrations` | `student_id` | `students` | `student_id` |
| `registrations` | `offering_id` | `course_offerings` | `offering_id` |
| `grades` | `registration_id` | `registrations` | `registration_id` |

These foreign keys ensure that referenced parent records exist before dependent records can be inserted. The practical test using a nonexistent student identifier demonstrated that MySQL rejected an invalid registration.

## 4. Unique Constraints

Unique constraints prevent duplicate values in designated columns.

The implemented student table includes:

- `uq_students_matric` on `matric_number`
- `uq_students_email` on `email`

These constraints help prevent duplicate matriculation numbers and email addresses. The actual schema determines whether additional unique constraints apply to other tables.

## 5. CHECK Constraints

The `grades` table contains score-validation constraints.

| Constraint | Rule | Purpose |
|---|---|---|
| `chk_ca_score` | `ca_score` between 0 and 30 | Restricts continuous assessment scores to the permitted range. |
| `chk_exam_score` | `exam_score` between 0 and 70 | Restricts examination scores to the permitted range. |

Practical tests attempted to insert a CA score of 35 and an examination score of 75. MySQL rejected both statements, confirming that the CHECK constraints were enforced.

## 6. Generated Columns

The `grades` table uses generated columns for:

- `total_score`
- `letter_grade`
- `grade_point`

These columns derive grading information from the assessment data according to the expressions defined in the SQL schema. This reduces the need to enter calculated values manually.

## 7. Indexes

Indexes help MySQL locate records efficiently.

The `students` table includes indexes associated with the primary key, the unique matriculation number, the unique email address, and `idx_students_programme` on `programme_id`.

Unique indexes also enforce uniqueness for the corresponding columns. Other indexes may be required depending on query patterns and execution-plan analysis.

## 8. Verification

The implementation was tested using phpMyAdmin and SQL queries:

- `SHOW INDEX FROM students;` to inspect indexes and unique indexes.
- A query against `information_schema.KEY_COLUMN_USAGE` to inspect foreign keys.
- A referential-integrity query to identify registrations with missing student or course-offering references.
- Invalid registration insertion to test foreign-key enforcement.
- Queries against `information_schema.CHECK_CONSTRAINTS` to inspect grade constraints.
- Invalid CA and examination score insertions to test CHECK enforcement.

The successful rejection of invalid records provides practical evidence that the relevant constraints operate as intended.

## 9. Conclusion

Primary keys identify records, foreign keys enforce valid relationships, unique constraints prevent duplicate institutional identifiers, and CHECK constraints validate assessment scores. Generated columns automate calculated grading values, while indexes support record lookup. Together, these features strengthen the integrity and reliability of the Luma Polytechnic database.
