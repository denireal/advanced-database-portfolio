# MIT 8103 Advanced Database Systems

## Practical Database Portfolio

### Federal Polytechnic Ekowe Student Academic Management and Result Processing System (FPE-SAMRPS)

---

## 1. Project Overview

This repository contains the practical database portfolio developed for **MIT 8103 – Advanced Database Systems**.

The project uses a realistic academic information system based on the **Federal Polytechnic Ekowe Student Academic Management and Result Processing System (FPE-SAMRPS)**.

The system is designed to demonstrate practical application of advanced database concepts including database modelling, SQL query processing, query optimisation, transaction management, NoSQL data modelling, and distributed/cloud database concepts.

---

## 2. Case Study

### Student Academic Management and Result Processing System

The case study models selected academic activities within a polytechnic environment, including:

* Student management
* Programme and department management
* Lecturer management
* Course management
* Academic sessions and semesters
* Course offerings
* Course registration
* Student results
* User management
* Audit logging

The relational database is named:

```text
sarms_db
```

---

## 3. Technologies Used

| Technology                | Purpose                                      |
| ------------------------- | -------------------------------------------- |
| MySQL / MariaDB           | Relational database management               |
| phpMyAdmin                | Database administration and SQL execution    |
| SQL                       | Database creation, querying and optimisation |
| WAMP                      | Local development environment                |
| Git                       | Version control                              |
| GitHub                    | Source-code and portfolio management         |
| NoSQL database technology | Advanced data modelling                      |
| Figma / FigJam            | ER diagram and database modelling            |

---

## 4. Portfolio Activities

The portfolio consists of five major practical activities.

### Portfolio 1 — Database Design and Modelling

This section covers:

* Case study and problem definition
* Entity identification
* Entity Relationship Diagram (ERD)
* Relational schema
* Primary and foreign keys
* Referential integrity
* Constraints
* Normalisation
* Third Normal Form (3NF)
* Database design rationale

---

### Portfolio 2 — Query Processing and Optimisation

This section demonstrates:

* Multi-table SQL queries
* JOIN operations
* Filtering and ordering
* Query execution plans
* `EXPLAIN`
* Index inspection
* Query optimisation
* Execution-plan comparison
* Performance considerations

Current evidence includes:

* Student academic profile query
* Course registration and teaching assignment query
* Original `EXPLAIN` execution plan
* Existing indexes on `course_registrations`
* Existing indexes on `lecturers`
* Filtered `EXPLAIN` execution plan

---

### Portfolio 3 — Transactions and Concurrency

This section will demonstrate:

* Transactions
* `COMMIT`
* `ROLLBACK`
* Transaction consistency
* Isolation levels
* Concurrency issues
* Locking/control mechanisms
* Practical transaction testing

---

### Portfolio 4 — NoSQL and Advanced Data Models

This section will demonstrate:

* NoSQL data modelling
* Document-oriented data structures
* Mapping relational data to a NoSQL model
* CRUD operations
* Suitability of NoSQL for selected academic data
* Comparison between relational and NoSQL approaches

---

### Portfolio 5 — Distributed and Cloud Databases

This section will examine:

* Distributed database concepts
* Data distribution
* Replication
* Sharding
* Availability
* Consistency
* Distributed database architecture
* Cloud database deployment considerations

---

## 5. Database Structure

The relational database currently contains the following major tables:

```text
departments
programmes
students
lecturers
courses
academic_sessions
semesters
course_offerings
course_registrations
results
users
audit_logs
```

The database design uses primary keys, foreign keys, unique constraints, check constraints and referential integrity rules to maintain data consistency.

---

## 6. Repository Structure

```text
advanced-database-portfolio/
│
├── README.md
│
├── database/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_insert_sample_data.sql
│   └── 04_verification_queries.sql
│
├── portfolio-1-database-design/
│   ├── ER_Diagram.png
│   ├── relational-schema.md
│   └── Portfolio_1.pdf
│
├── portfolio-2-query-optimisation/
│   ├── queries/
│   ├── screenshots/
│   └── Portfolio_2.pdf
│
├── portfolio-3-transactions-concurrency/
│   ├── queries/
│   ├── screenshots/
│   └── Portfolio_3.pdf
│
├── portfolio-4-nosql/
│   ├── queries/
│   ├── screenshots/
│   └── Portfolio_4.pdf
│
├── portfolio-5-distributed-cloud/
│   ├── queries/
│   ├── screenshots/
│   └── Portfolio_5.pdf
│
└── documentation/
    ├── final-portfolio.pdf
    └── reflection.md
```

---

## 7. Query Processing Evidence

Portfolio 2 currently includes the following SQL investigations.

### Figure 6 — Student Academic Profile

A multi-table query joining:

```text
students
programmes
departments
```

to produce a consolidated student academic profile.

### Figure 7 — Course Registration and Teaching Assignment

A seven-table query joining:

```text
course_registrations
students
course_offerings
courses
lecturers
semesters
academic_sessions
```

to produce a course registration and teaching assignment report.

### Figure 8 — Original EXPLAIN Plan

The execution plan for the course registration query is examined using:

```sql
EXPLAIN
```

The plan is used to identify access types, indexes, estimated rows and additional operations.

### Figure 9 — Course Registration Indexes

Existing indexes on:

```text
course_registrations
```

are examined using:

```sql
SHOW INDEX FROM course_registrations;
```

### Figure 10 — Lecturer Indexes

Existing indexes on:

```text
lecturers
```

are examined using:

```sql
SHOW INDEX FROM lecturers;
```

### Figure 11 — Filtered EXPLAIN Plan

The course registration query is filtered by:

```sql
WHERE a.session_id = 1
```

The resulting execution plan demonstrates improved access types for the filtered academic session, including `const` and `eq_ref` access.

---

## 8. Database Design Principles

The database design follows standard relational database principles, including:

* Atomic attributes
* Primary key identification
* Foreign key relationships
* Referential integrity
* Entity integrity
* Domain constraints
* Uniqueness constraints
* Normalisation
* Reduction of unnecessary redundancy
* Appropriate indexing
* Transactional consistency

---

## 9. Development and Version Control

The project is maintained using Git and GitHub.

Development is committed progressively as each portfolio activity is completed.

Example commit structure:

```text
Initialize MIT 8103 database portfolio
Complete Portfolio 1 database design and ER model
Add Portfolio 2 queries and execution plan analysis
Add transaction and concurrency experiments
Add NoSQL data model and implementation
Add distributed and cloud database exercise
Complete MIT 8103 practical portfolio
```

This provides a traceable development history of the practical work.

---

## 10. Academic Purpose

This repository is maintained as an academic practical portfolio for:

**MIT 8103 – Advanced Database Systems**

The project demonstrates the practical application of database concepts rather than relying solely on theoretical discussion.

All database experiments, SQL queries, execution plans, screenshots and implementation evidence are documented progressively throughout the project.

---

## 11. Author

**Denyefa Cletus Wari**

MIT 8103 – Advanced Database Systems


---

## 12. Status

**Project Status:** In Progress

Portfolio 1 and Portfolio 2 are currently under development. Subsequent portfolio activities will be added progressively as the practical exercises are completed.
