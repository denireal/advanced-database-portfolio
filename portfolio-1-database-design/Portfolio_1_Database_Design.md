# MIT 8103 — Advanced Database Systems

## Portfolio 1: Database Design and Modelling

### Case Study: Student Academic Management and Result Processing System (SAMRPS)

**Database Name:** `sarms_db`
**Database Management System:** MySQL/MariaDB
**Development Environment:** WAMP / phpMyAdmin
**Portfolio Activity:** 1 — Database Design and Modelling
**Assessment Weight:** 7 Marks

---

## 1. Introduction

The Student Academic Management and Result Processing System (SAMRPS) is a relational database designed to support the management of student academic information within an academic institution.

The system provides a structured database environment for managing students, programmes, departments, lecturers, courses, academic sessions, semesters, course offerings, course registrations, examination results, system users, and audit records.

The database was implemented using MySQL/MariaDB and administered through phpMyAdmin. The design follows relational database principles and applies primary keys, foreign keys, unique constraints, domain restrictions, referential integrity, and normalization up to Third Normal Form (3NF).

The database is intended to provide a reliable foundation for academic administration, reporting, result processing, and future extensions such as analytics and decision-support applications.

---

# 2. Problem Definition

Academic administration involves the management of a large volume of interconnected information. Student records are associated with programmes and departments, while courses are assigned to lecturers and offered during specific academic semesters.

Students register for courses, and results are subsequently recorded against those registrations. Academic sessions contain semesters, while courses are offered within specific semesters and assigned to lecturers.

If these records are managed using disconnected spreadsheets or poorly structured databases, several problems may arise, including:

* duplication of student and programme information;
* inconsistent course and lecturer records;
* difficulty tracking course registrations;
* difficulty associating results with the correct student and course;
* weak enforcement of referential integrity;
* inconsistent academic session and semester information;
* difficulty generating academic reports;
* limited auditability of changes;
* increased risk of data entry errors.

The FPE-SAMRPS database addresses these problems by organizing academic information into related entities with clearly defined relationships and integrity constraints.

---

# 3. Objectives of the Database

The main objectives of `sarms_db` are to:

1. Maintain accurate student academic records.
2. Store departments and academic programmes.
3. Manage lecturer information.
4. Maintain course information and credit units.
5. Manage academic sessions and semesters.
6. Record courses offered during particular semesters.
7. Assign lecturers to course offerings.
8. Record student course registrations.
9. Store examination and continuous-assessment results.
10. Support controlled access through user accounts and roles.
11. Maintain an audit trail of important database activities.
12. Provide a reliable foundation for academic reporting and future analytics.

---

# 4. Database Entities

The implemented database contains twelve major entities.

| No. | Entity                 | Purpose                                                                           |
| --: | ---------------------- | --------------------------------------------------------------------------------- |
|   1 | `departments`          | Stores academic departments                                                       |
|   2 | `programmes`           | Stores academic programmes offered by departments                                 |
|   3 | `students`             | Stores student biodata and academic information                                   |
|   4 | `lecturers`            | Stores lecturer and academic staff information                                    |
|   5 | `courses`              | Stores courses and their credit units                                             |
|   6 | `academic_sessions`    | Stores academic sessions                                                          |
|   7 | `semesters`            | Stores semesters within academic sessions                                         |
|   8 | `course_offerings`     | Represents courses offered during a particular semester and assigned to lecturers |
|   9 | `course_registrations` | Records student registration for course offerings                                 |
|  10 | `results`              | Stores student assessment and examination results                                 |
|  11 | `users`                | Stores system users and their roles                                               |
|  12 | `audit_logs`           | Records system activities for accountability and auditing                         |

---

# 5. Entity-Relationship Design

The major relationships in the system are:

* A department can have many programmes.
* A department can have many lecturers.
* A department can offer many courses.
* A programme belongs to one department.
* A student belongs to one programme.
* A course can have many course offerings.
* An academic session can contain multiple semesters.
* A semester can contain many course offerings.
* A lecturer can teach many course offerings.
* A student can register for many course offerings.
* A course offering can have many student registrations.
* A course registration can have one result.
* A user can generate many audit log entries.

The many-to-many relationship between students and course offerings is resolved through the `course_registrations` associative entity.

Similarly, the relationship between academic sessions and courses is managed through semesters and course offerings.

---

# 6. Entity-Relationship Diagram

The database relationship diagram was generated from the implemented `sarms_db` database using phpMyAdmin Designer and Figma.



# 7. Relational Schema

## 7.1 Departments

**Table:** `departments`

| Attribute         | Description               |
| ----------------- | ------------------------- |
| `department_id`   | Primary key               |
| `department_code` | Unique department code    |
| `department_name` | Unique department name    |
| `created_at`      | Record creation timestamp |

**Primary Key:** `department_id`

**Unique Constraints:**

* `department_code`
* `department_name`

---

## 7.2 Programmes

**Table:** `programmes`

| Attribute        | Description                         |
| ---------------- | ----------------------------------- |
| `programme_id`   | Primary key                         |
| `department_id`  | Foreign key referencing departments |
| `programme_code` | Unique programme code               |
| `programme_name` | Programme name                      |
| `award_type`     | ND, HND or Certificate              |
| `duration_years` | Programme duration                  |

**Primary Key:** `programme_id`

**Foreign Key:**

```text
programmes.department_id
        →
departments.department_id
```

**Unique Constraint:** `programme_code`

---

## 7.3 Students

**Table:** `students`

| Attribute        | Description                        |
| ---------------- | ---------------------------------- |
| `student_id`     | Primary key                        |
| `programme_id`   | Foreign key referencing programmes |
| `matric_no`      | Unique matriculation number        |
| `first_name`     | Student first name                 |
| `last_name`      | Student surname                    |
| `gender`         | Student gender                     |
| `date_of_birth`  | Date of birth                      |
| `email`          | Student email                      |
| `phone`          | Telephone number                   |
| `admission_year` | Year of admission                  |
| `academic_level` | ND1, ND2, HND1 or HND2             |
| `status`         | Current academic status            |
| `created_at`     | Record creation timestamp          |

**Primary Key:** `student_id`

**Foreign Key:**

```text
students.programme_id
        →
programmes.programme_id
```

**Unique Constraints:**

* `matric_no`
* `email`

---

## 7.4 Lecturers

**Table:** `lecturers`

| Attribute       | Description                         |
| --------------- | ----------------------------------- |
| `lecturer_id`   | Primary key                         |
| `department_id` | Foreign key referencing departments |
| `staff_no`      | Unique staff number                 |
| `first_name`    | First name                          |
| `last_name`     | Surname                             |
| `email`         | Email address                       |
| `academic_rank` | Academic rank                       |
| `status`        | Employment status                   |

**Primary Key:** `lecturer_id`

**Foreign Key:**

```text
lecturers.department_id
        →
departments.department_id
```

**Unique Constraints:**

* `staff_no`
* `email`

---

## 7.5 Courses

**Table:** `courses`

| Attribute       | Description                         |
| --------------- | ----------------------------------- |
| `course_id`     | Primary key                         |
| `department_id` | Foreign key referencing departments |
| `course_code`   | Unique course code                  |
| `course_title`  | Course title                        |
| `credit_unit`   | Credit unit                         |
| `level`         | Academic level                      |
| `semester_type` | First or Second semester            |

**Primary Key:** `course_id`

**Foreign Key:**

```text
courses.department_id
        →
departments.department_id
```

**Unique Constraint:** `course_code`

---

## 7.6 Academic Sessions

**Table:** `academic_sessions`

| Attribute      | Description                |
| -------------- | -------------------------- |
| `session_id`   | Primary key                |
| `session_name` | Unique academic session    |
| `start_date`   | Session start date         |
| `end_date`     | Session end date           |
| `status`       | Upcoming, Active or Closed |

**Primary Key:** `session_id`

**Unique Constraint:** `session_name`

**Integrity Rule:**

```text
end_date > start_date
```

---

## 7.7 Semesters

**Table:** `semesters`

| Attribute       | Description                               |
| --------------- | ----------------------------------------- |
| `semester_id`   | Primary key                               |
| `session_id`    | Foreign key referencing academic sessions |
| `semester_name` | First or Second                           |

**Primary Key:** `semester_id`

**Foreign Key:**

```text
semesters.session_id
        →
academic_sessions.session_id
```

**Composite Unique Constraint:**

```text
(session_id, semester_name)
```

This prevents the same semester from being entered more than once within an academic session.

---

## 7.8 Course Offerings

**Table:** `course_offerings`

| Attribute     | Description                       |
| ------------- | --------------------------------- |
| `offering_id` | Primary key                       |
| `course_id`   | Foreign key referencing courses   |
| `semester_id` | Foreign key referencing semesters |
| `lecturer_id` | Foreign key referencing lecturers |
| `status`      | Offering status                   |

**Primary Key:** `offering_id`

**Foreign Keys:**

```text
course_offerings.course_id
        →
courses.course_id
```

```text
course_offerings.semester_id
        →
semesters.semester_id
```

```text
course_offerings.lecturer_id
        →
lecturers.lecturer_id
```

**Unique Constraint:**

```text
(course_id, semester_id)
```

This prevents the same course from being scheduled more than once in the same semester.

---

## 7.9 Course Registrations

**Table:** `course_registrations`

| Attribute           | Description                              |
| ------------------- | ---------------------------------------- |
| `registration_id`   | Primary key                              |
| `student_id`        | Foreign key referencing students         |
| `offering_id`       | Foreign key referencing course offerings |
| `registration_date` | Registration timestamp                   |
| `status`            | Registration status                      |

**Primary Key:** `registration_id`

**Foreign Keys:**

```text
course_registrations.student_id
        →
students.student_id
```

```text
course_registrations.offering_id
        →
course_offerings.offering_id
```

**Composite Unique Constraint:**

```text
(student_id, offering_id)
```

This prevents a student from registering for the same course offering more than once.

---

## 7.10 Results

**Table:** `results`

| Attribute         | Description                                         |
| ----------------- | --------------------------------------------------- |
| `result_id`       | Primary key                                         |
| `registration_id` | Unique foreign key referencing course registrations |
| `ca_score`        | Continuous assessment score                         |
| `exam_score`      | Examination score                                   |
| `total_score`     | Generated total score                               |
| `grade`           | Letter grade                                        |
| `grade_point`     | Grade point                                         |
| `remark`          | Result remark                                       |
| `result_status`   | Draft, Submitted or Approved                        |
| `entered_at`      | Result entry timestamp                              |

**Primary Key:** `result_id`

**Foreign Key:**

```text
results.registration_id
        →
course_registrations.registration_id
```

The `registration_id` is unique in the results table because one course registration should have at most one result record.

The total score is generated from the assessment components:

```text
total_score = ca_score + exam_score
```

Score constraints ensure that:

```text
0 ≤ ca_score ≤ 40
```

and:

```text
0 ≤ exam_score ≤ 60
```

---

## 7.11 Users

**Table:** `users`

| Attribute       | Description                |
| --------------- | -------------------------- |
| `user_id`       | Primary key                |
| `username`      | Unique login username      |
| `password_hash` | Hashed password            |
| `role`          | System role                |
| `status`        | Account status             |
| `created_at`    | Account creation timestamp |

Supported roles include:

* Administrator
* Registry Officer
* Lecturer
* HOD
* Dean
* Student
* Auditor

**Primary Key:** `user_id`

**Unique Constraint:** `username`

---

## 7.12 Audit Logs

**Table:** `audit_logs`

| Attribute     | Description                   |
| ------------- | ----------------------------- |
| `audit_id`    | Primary key                   |
| `user_id`     | Foreign key referencing users |
| `action`      | Action performed              |
| `table_name`  | Affected table                |
| `record_id`   | Affected record               |
| `old_value`   | Previous data stored as JSON  |
| `new_value`   | New data stored as JSON       |
| `action_time` | Timestamp of activity         |

**Primary Key:** `audit_id`

**Foreign Key:**

```text
audit_logs.user_id
        →
users.user_id
```

The use of JSON fields for `old_value` and `new_value` provides flexibility for recording changes involving different tables and record structures.

---

# 8. Primary and Foreign Key Summary

| Table                  | Primary Key       | Foreign Keys                              |
| ---------------------- | ----------------- | ----------------------------------------- |
| `departments`          | `department_id`   | —                                         |
| `programmes`           | `programme_id`    | `department_id`                           |
| `students`             | `student_id`      | `programme_id`                            |
| `lecturers`            | `lecturer_id`     | `department_id`                           |
| `courses`              | `course_id`       | `department_id`                           |
| `academic_sessions`    | `session_id`      | —                                         |
| `semesters`            | `semester_id`     | `session_id`                              |
| `course_offerings`     | `offering_id`     | `course_id`, `semester_id`, `lecturer_id` |
| `course_registrations` | `registration_id` | `student_id`, `offering_id`               |
| `results`              | `result_id`       | `registration_id`                         |
| `users`                | `user_id`         | —                                         |
| `audit_logs`           | `audit_id`        | `user_id`                                 |

---

# 9. Referential Integrity

Referential integrity is enforced through foreign-key constraints.

For example:

```text
programmes.department_id
        →
departments.department_id
```

ensures that a programme cannot reference a department that does not exist.

Similarly:

```text
students.programme_id
        →
programmes.programme_id
```

ensures that each student is associated with a valid programme.

The relationship chain for academic processing can therefore be represented as:

```text
Department
    ↓
Programme
    ↓
Student
    ↓
Course Registration
    ↓
Result
```

while course delivery follows:

```text
Department
    ↓
Course
    ↓
Course Offering
    ↓
Lecturer
```

and academic scheduling follows:

```text
Academic Session
    ↓
Semester
    ↓
Course Offering
```

This structure prevents orphan records and improves data consistency.

---

# 10. Integrity Constraints

Several types of constraints are implemented in `sarms_db`.

## 10.1 Primary Key Constraints

Every major entity has a primary key that uniquely identifies each record.

Examples include:

```text
departments.department_id
students.student_id
courses.course_id
results.result_id
```

---

## 10.2 Foreign Key Constraints

Foreign keys enforce relationships between related tables.

Examples include:

```text
students.programme_id → programmes.programme_id
```

and:

```text
course_registrations.student_id → students.student_id
```

---

## 10.3 Unique Constraints

Unique constraints prevent duplicate business identifiers.

Examples include:

* department code;
* department name;
* programme code;
* matriculation number;
* student email;
* staff number;
* lecturer email;
* course code;
* academic session name;
* username.

---

## 10.4 Check Constraints

Domain validation is applied to important numerical and temporal attributes.

For example:

```text
credit_unit BETWEEN 1 AND 6
```

and:

```text
ca_score BETWEEN 0 AND 40
```

and:

```text
exam_score BETWEEN 0 AND 60
```

Academic session dates also follow:

```text
end_date > start_date
```

---

## 10.5 Domain Constraints

Controlled values are used for attributes such as:

```text
academic_level:
ND1, ND2, HND1, HND2
```

and:

```text
semester_name:
First, Second
```

Controlled status values are also used for students, lecturers, course offerings, registrations, results and users.

---

# 11. Normalization

The database design follows normalization principles to reduce redundancy and prevent update anomalies.

The target normal form is **Third Normal Form (3NF)**.

---

## 11.1 First Normal Form (1NF)

A relation satisfies First Normal Form when attributes contain atomic values and repeating groups are eliminated.

For example, student information is stored as individual attributes:

```text
student_id
matric_no
first_name
last_name
email
programme_id
```

Rather than storing multiple students or multiple programmes inside a single field.

Similarly, course registrations are represented as individual rows rather than storing several registered courses in a single student record.

Therefore, the design satisfies the requirements of 1NF.

---

## 11.2 Second Normal Form (2NF)

Second Normal Form requires:

1. the relation to already satisfy 1NF; and
2. non-key attributes to depend on the whole primary key.

The design separates entities so that attributes depend on their appropriate keys.

For example, student attributes depend on:

```text
student_id
```

while course information depends on:

```text
course_id
```

Course registration information is separated into:

```text
course_registrations
```

rather than being duplicated within the student or course tables.

This removes partial dependency problems and supports 2NF.

---

## 11.3 Third Normal Form (3NF)

Third Normal Form requires that non-key attributes do not depend transitively on another non-key attribute.

For example, department information is not stored repeatedly in the student table.

Instead:

```text
students
    ↓
programmes
    ↓
departments
```

The student's programme identifies the programme, while the programme identifies the department.

Similarly, lecturer information is maintained in the `lecturers` table rather than being repeatedly stored in `course_offerings`.

Academic session information is separated from semesters, and course information is separated from course offerings.

This prevents transitive dependencies and reduces redundancy.

The resulting database therefore satisfies the design objectives of 3NF.

---

# 12. Design Rationale

Several design decisions were made to improve maintainability and data integrity.

### 12.1 Separation of Programmes and Departments

A department can offer multiple programmes. Keeping these entities separate prevents department information from being duplicated for every programme.

### 12.2 Separation of Students and Programmes

A student's programme is represented through `programme_id`. This allows programme information to be maintained independently.

### 12.3 Separation of Courses and Course Offerings

A course is a reusable academic definition, while a course offering represents the delivery of that course during a specific semester and assignment to a lecturer.

This distinction is important because the same course can be offered in different academic sessions.

### 12.4 Course Registration as an Associative Entity

Students and course offerings have a many-to-many relationship.

The relationship is resolved using:

```text
course_registrations
```

This allows a student to register for many courses while each course offering can have many students.

### 12.5 Results Linked to Registrations

Results are associated with a specific course registration rather than directly with a student or course.

This prevents ambiguity and ensures that the result belongs to the correct student-course combination.

### 12.6 Separate Academic Sessions and Semesters

Academic sessions contain semesters. Separating the two entities allows the system to maintain multiple semesters within each academic session.

### 12.7 Audit Logging

The `audit_logs` table supports accountability by recording actions performed by system users.

The JSON fields provide flexibility for storing previous and updated values.

---

# 13. Sample Implemented Database Structure

The implemented database contains the following tables:

```text
sarms_db
│
├── departments
├── programmes
├── students
├── lecturers
├── courses
├── academic_sessions
├── semesters
├── course_offerings
├── course_registrations
├── results
├── users
└── audit_logs
```

The database therefore represents the major academic administration processes required by the case study.

---

# 14. Evidence of Implementation

The following evidence should be included in the final portfolio submission.

| Evidence | Description                                                      |
| -------- | ---------------------------------------------------------------- |
| Figure 1 | phpMyAdmin ER diagram showing implemented database relationships |
| Figure 2 | phpMyAdmin database structure showing the 12 tables              |
| Figure 3 | Example table structure showing primary and foreign keys         |
| Figure 4 | Example constraints and indexes                                  |

The screenshots should be captured directly from the implemented `sarms_db` database.

---

# 15. Conclusion

The sarms_db provides a structured relational solution for managing student academic information at an institution.

The database contains twelve related entities covering departments, programmes, students, lecturers, courses, academic sessions, semesters, course offerings, registrations, results, users and audit logs.

The design applies primary keys, foreign keys, unique constraints, domain restrictions and check constraints to improve data integrity.

The use of normalization up to Third Normal Form reduces unnecessary redundancy and minimizes insertion, update and deletion anomalies.

The resulting relational model provides a suitable foundation for the subsequent portfolio activities involving query processing and optimization, transactions and concurrency, NoSQL data modelling, and distributed/cloud database concepts.

---

---

## Author

**Denyefa Cletus Wari**

**Course:** MIT 8103 — Advanced Database Systems

**Case Study:** Student Academic Management and Result Processing System (SAMRPS)

**Database:** `sarms_db`
