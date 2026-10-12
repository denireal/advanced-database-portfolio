MIT 8103 Advanced Database Systems
Practical Database Portfolio
Southern Technical University Academic Portal
---
1. Project Overview
This repository contains the practical database portfolio developed for MIT 8103 – Advanced Database Systems.
The project uses a realistic academic information system based on the Southern Technical University Academic Portal.
The system demonstrates the practical application of advanced database concepts, including database modelling, SQL query processing, query optimisation, transaction management, NoSQL data modelling, and distributed and cloud database concepts.
2. Case Study: Southern Technical University Academic Portal
2.1 Organisation Overview
Southern Technical University is a premier tertiary institution focused on engineering, technology, and applied sciences. The university manages thousands of students across multiple academic departments, tracking their academic lifecycle from admission and course registration to grade processing and graduation.
2.2 Nature of the Business / System
The Academic Portal is a centralised online management system designed to streamline academic operations. It replaces legacy manual record-keeping with an automated, transaction-safe database environment that handles course enrolments, continuous assessments, and GPA computations.
2.3 Database Users
Students: Register for semester courses, view lecture schedules, check semester grades, and monitor cumulative grade point averages (CGPA).
Lecturers: Enter continuous assessment and examination scores, manage course rosters, and track student performance.
Department Heads and Administrators: Manage departmental course offerings, assign teaching staff, resolve registration conflicts, and generate official academic transcripts.
2.4 Major Data Stored
Departments: Department names, administrative details, and head-of-department information.
Admin Users: Secure system operators, registrars, and deans, with role-based access control, two-factor authentication (2FA) credentials, account status, and departmental restrictions.
Lecturers: Faculty profiles, contact information, and departmental affiliations.
Students: Student profiles, matriculation numbers, admission years, and departmental details.
Courses: Course codes, titles, credit units, and owning departments.
Enrollments: Records linking students to courses taken during specific semesters and academic sessions, including scores and computed letter grades.
2.5 Key Operations Supported
Course Registration: Enables students to enrol in approved courses for a specified semester and academic session.
Grade Entry: Allows authorised lecturers to enter and update student marks.
GPA Computation: Calculates semester grade point average (SGPA) and cumulative grade point average (CGPA) using course credits and grade points.
Transcript Generation: Retrieves historical enrolment and grade records to produce a student's academic history.
The proposed relational database name is:
```text
southern_tech_university_db
```
3. Technologies Used
Technology	Purpose
MySQL / MariaDB	Relational database management
phpMyAdmin / CLI	Database administration and SQL execution
SQL	Database creation, querying, and optimisation
Laragon / XAMPP	Local development environment
Git	Version control
GitHub	Source-code and portfolio management
NoSQL database technology	Advanced data modelling
Mermaid	ER diagrams and database modelling
4. Portfolio Activities
The portfolio is organised into five practical activities.
Portfolio 1 — Database Design and Modelling
Case study and problem definition
Entity identification and entity-relationship diagram (ERD) structure
Relational schema covering `Department`, `AdminUser`, `Lecturer`, `Student`, `Course`, and `Enrollment`
Primary and foreign keys with referential actions such as `ON DELETE CASCADE` and `ON DELETE SET NULL`, where appropriate
Integrity constraints, uniqueness rules, and key definitions
Normalisation up to Third Normal Form (3NF)
Portfolio 2 — Query Processing and Optimisation
Multi-table SQL joins and aggregation queries
Query execution plan analysis using `EXPLAIN`
Index inspection and query performance tuning
Evidence-based analysis of query execution and optimisation
Portfolio 3 — Transactions and Concurrency
ACID transactions using `BEGIN`, `COMMIT`, and `ROLLBACK`
Transaction isolation levels
Concurrency control using techniques such as `SELECT ... FOR UPDATE`
Discussion of consistency and concurrent updates
Portfolio 4 — NoSQL and Advanced Data Models
Document-oriented NoSQL modelling
Flexible structures for academic activity logs and transcript data
Comparison of relational and document-oriented approaches
Portfolio 5 — Distributed and Cloud Databases
Database replication and sharding
CAP theorem trade-offs
Distributed database considerations for scaling a high-traffic academic portal
Availability, consistency, and performance considerations
5. Repository Structure
The repository is intended to follow this structure:
```text
advanced-database-portfolio/
│
├── README.md
│
├── portfolio-1-database-design/
│   ├── case-study-description.md
│   ├── ER-diagram.md
│   ├── relational-schema.sql
│   ├── seed_data.sql
│   ├── keys-and-constraints.md
│   └── normalisation.md
│
├── portfolio-2-query-optimisation/
│
├── portfolio-3-transactions-concurrency/
│
├── portfolio-4-nosql/
│
└── portfolio-5-distributed-cloud/
```
Individual portfolio folders will contain the relevant SQL scripts, documentation, diagrams, screenshots, execution-plan evidence, and practical results as each activity is completed.
6. Database and Implementation Note
The database name and entity names in this case study describe the proposed Southern Technical University Academic Portal.
Ensure that the README, SQL scripts, relational schema, diagrams, and evidence all refer to the same database design. If the practical implementation uses a different database name or schema, update the relevant documentation to reflect the actual implementation rather than implying that the proposed database has already been created.
7. Author
Denyefa Cletus Wari
MIT 8103 – Advanced Database Systems
Practical Database Portfolio: Southern Technical University Academic Portal
