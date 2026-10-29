# Advanced Database Systems Portfolio (MIT 8103)

**Student Name:** Denyefa Cletus Wari  
**Programme:** Master of Information Technology  
**Course:** MIT 8103 – Advanced Database Systems  
**Database Case Study:** Luma Polytechnic (Simulated Student Records and Results System)  
**Relational DBMS:** MySQL 8.0 (InnoDB design; MariaDB used for local testing where applicable)  
**NoSQL DBMS:** MongoDB Atlas  
**Repository:** https://github.com/denireal/advanced-database-portfolio

---

## 1. Case Study Overview

### Organisation

Luma Polytechnic is a simulated federal institution used as the case study for this portfolio.

### System Description

The project models a student records and results management system that supports student information, academic programmes, course offerings, course registrations, assessment scores, and academic results.

### Primary Users

- Students
- Lecturers
- Academic Registry Staff
- Management

### Major Data Entities

The relational database contains nine main tables:

- Departments
- Programmes
- Students
- Lecturers
- Courses
- Academic Terms
- Course Offerings
- Registrations
- Grades

### Key Operations

The database supports student record management, course registration, score entry, grade computation, and academic reporting. The project also explores query optimisation, transaction processing, NoSQL data modelling, and distributed database concepts.

---

## 2. Project Objectives

The objectives of this portfolio are to:

1. Design and implement a relational database using appropriate entities, relationships, keys, and constraints.
2. Examine SQL query execution plans and evaluate indexing and query optimisation techniques.
3. Demonstrate transaction processing, commit and rollback operations, and transaction isolation behaviour.
4. Model student records in MongoDB and perform document queries, aggregation, and index-based lookups.
5. Explore cloud database connectivity and replica-set status using MongoDB Atlas.
6. Document the implementation, testing process, results, limitations, and lessons learned.

---

## 3. Repository Structure

The repository is organised around the five portfolio components of the MIT 8103 Continuous Assessment.

```text
advanced-database-portfolio/
│
├── portfolio-1-database-design/
│   ├── case-study-description.md
│   ├── ER-diagram.png
│   ├── keys-and-constraints.md
│   ├── normalization.md
│   ├── relational-schema.sql
│   └── seed_data.sql
│
├── portfolio-2-query-optimisation/
│   ├── sql-queries.sql
│   ├── query-results.png
│   ├── execution-plans.md
│   ├── indexing-optimisation-evidence.png
│   └── brief-performance-analysis.md
│
├── portfolio-3-transactions-concurrency/
│   ├── README.md
│   ├── sql/
│   ├── docs/
│   └── evidence/
│
├── portfolio-4-nosql/
│   ├── README.md
│   ├── students.json
│   ├── mongodb-queries.js
│   ├── nosql-analysis.md
│   └── evidence/
│
├── portfolio-5-distributed-cloud/
│   ├── README.md
│   ├── config/
│   ├── docs/
│   ├── tests/
│   └── evidence/
│
└── README.md
---

## 4. Tools and Technologies

| Tool or technology | Purpose |
|---|---|
| MySQL / MariaDB | Relational database design, SQL queries, constraints, and transaction tests |
| XAMPP and phpMyAdmin | Local database environment and database administration |
| MariaDB command-line client | Transaction and isolation testing |
| MongoDB Atlas | Cloud-hosted NoSQL database |
| MongoDB Compass | Document management, queries, aggregation, and index inspection |
| Git and GitHub | Version control, project organisation, and submission |
| Markdown and SQL scripts | Technical documentation and reproducible database operations |

**Environment note:** The relational schema was designed for MySQL 8.0.16 or later. During local practical work, the XAMPP/phpMyAdmin environment reported MariaDB. SQL behaviour and compatibility were therefore checked in the environment actually used. MySQL-specific behaviour should not be assumed to be identical across both systems.

---

## 5. Portfolio 1: Database Design and Modelling

This component covers the relational design of the Luma Polytechnic student records system.

The work includes:

- Identification of entities and their relationships.
- Relational schema implementation.
- Primary and foreign key constraints.
- Unique constraints and indexes.
- Referential integrity checks.
- Validation of assessment score ranges.
- Sample data for students, course registrations, and grades.

The grade records use continuous assessment and examination scores, with a generated total score and corresponding grade information where supported by the schema.

The design and testing evidence is available in `portfolio-1-database-design/`.

---

## 6. Portfolio 2: Query Processing and Optimisation

This component examines SQL query execution plans and the effect of filtering and indexing.

The practical work includes:

- Multi-table joins across students, registrations, course offerings, courses, and academic terms.
- Inspection of execution plans using `EXPLAIN`.
- Comparison of unfiltered and student-filtered queries.
- Examination of existing indexes and their use in query execution.
- A grade query filtering and ordering records by total score.
- Documentation of execution plans and observed results.

The tests showed index usage for selected filtered queries. Because the dataset was small, execution times were very short and the results do not establish a significant performance improvement at larger scale.

See `portfolio-2-query-optimisation/` for the SQL, plans, and analysis.

---

## 7. Portfolio 3: Transactions and Concurrency

This component explores transaction behaviour in the relational database.

The practical work includes:

- Transaction commit and rollback.
- Testing changes to account balances within transactions.
- A transfer operation involving two accounts.
- Inspection of the configured transaction isolation level.
- Comparison of data visibility between two database sessions before and after a commit.

The tests demonstrated that rollback reversed an uncommitted change and commit preserved a change. A two-session test also showed that one session did not see another session's uncommitted update in the tested scenario.

The isolation test reported `REPEATABLE-READ`. A blocking lock demonstration was not conclusively verified, so the project does not claim that lock blocking was successfully demonstrated.

See `portfolio-3-transactions-concurrency/` for scripts, analysis, and evidence.

---

## 8. Portfolio 4: NoSQL and Advanced Data Models

This component models student records in MongoDB using a document-oriented structure.

The practical work includes:

- Creating a MongoDB Atlas database and student collection.
- Storing student information and embedded course registration and result documents.
- Filtering students by matriculation number and grade.
- Querying registrations by total score.
- Using aggregation to calculate average, highest, and lowest total scores.
- Creating an index on `matric_number`.
- Inspecting query execution using MongoDB's explain functionality.

The aggregation test returned an average total score of 72 for the four registration records included in that test. The indexed matriculation-number query examined one document and one index key in the observed test.

The dataset was small, so these results demonstrate query functionality and index usage rather than large-scale performance.

See `portfolio-4-nosql/` for the sample documents, MongoDB queries, analysis, and evidence.

---

## 9. Portfolio 5: Distributed and Cloud Database Exercise

This component explores cloud database connectivity and MongoDB replica-set information using MongoDB Atlas.

The practical work includes:

- Connecting to the Atlas cluster through MongoDB Compass.
- Inspecting the cluster's reported hosts and primary information.
- Running a connectivity and server-information test.
- Inspecting replica-set status and available member information.
- Recording test results and configuration notes.

The observed server response identified a writable primary. The replica-set status output also showed healthy primary and secondary member records in the inspected results.

These observations demonstrate successful connectivity and the reported replica-set state at the time of testing. They do not, by themselves, prove failover behaviour, full cluster health across every member, or application-level high availability.

See `portfolio-5-distributed-cloud/` for test scripts or commands, configuration notes, and evidence.

**Security note:** Connection strings, database passwords, API keys, and other credentials must not be committed to this public repository.

---

## 10. Testing and Evidence

The portfolio includes implementation files, test scripts, execution plans, analysis documents, and screenshots where available.

Evidence is intended to demonstrate:

- Database schema and relationships.
- Constraint enforcement and referential integrity.
- SQL execution plans and index usage.
- Transaction commit and rollback outcomes.
- MongoDB queries, aggregation results, and index usage.
- Atlas connectivity and replica-set status.

Only evidence actually captured and included in the repository should be treated as submitted evidence. Test results should be interpreted in the context of the dataset size and environment used.

---

## 11. Technical Reflection

This project solidified my knowledge of advanced database concepts by implementing them within the context of a mock student records system. Since I already knew how to use relational databases, I was able to understand the components regarding schema design, SQL queries, keys, constraints, and transactions. But I was also able to gain knowledge of NoSQL, learning MongoDB's document model, embedded documents, aggregate pipeline, and indexing techniques.

And having gone through the cloud database tutorial, I now understand how to check connection status and view replica set status for a cloud-hosted database. But most importantly, this project reinforced the importance of testing theories practically rather than simply accepting them at face value.

And that the difference between a passed functional test versus a claim of high performance, high concurrency, or high availability, which requires more extensive proof.

---

## 12. Conclusion

This portfolio brings together relational database design, SQL query analysis, transaction processing, NoSQL data modelling, and a cloud database exercise. The implementation and evidence document the practical work completed for the five MIT 8103 portfolio components and identify the limitations of the tests performed.

**GitHub Repository:**  
https://github.com/denireal/advanced-database-portfolio
