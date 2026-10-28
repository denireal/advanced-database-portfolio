Portfolio 1 - Database Design and Modelling

Course: MIT 8103 Advanced Database Systems

Case Study: Luma Polytechnic (Is a simulated Nigeria's Federal Polytechnic)

Database Platform: MySQL 8.0.16

Overview

This portfolio contains the relational database schema for the Student Records and Results Management System of Luma Polytechnic, a simulated Nigerian Institution.

The database was designed to cater for student admissions, program management, course registration, lecturer assignment, results computation and academic record keeping.

The database is developed on MySQL 8.0.16 using InnoDB Storage Engine with primary KEYs, foreign KEYs, UNIQUE KEYs, CHECK KEYs, Generated Columns and Indexing.

i. Contents

ii. Case Study Description

iii. Entity Relationship Diagram (ERD)

iv. Keys and Constraints

v. Normalization (1NF-3NF)

vi. SQL Schema

vii. Sample Data

Practical Implementation Evidence

Database Design and Features

– 9 Relational Tables
– 10 Foreign-Key Relationships
– UNIQUE constraints for Institutional Identifiers
– CHECK constraint for Score Validations
– generated columns for Total Score, Letter Grade and Grade Point
– Indexes for faster query response times Validation Tests Completed | Test | Result | |------|--------| | Database Creation | Passed | | Table Creation | Passed | | Sample Data Insertion | Passed | | Student Registration Query | Passed | | Grade Query | Passed | | Unique Matric Number Verification | Passed | | Foreign Key Verification | Passed | | Referential Integrity Check | Passed | | Invalid Registration Rejected | Passed | | Invalid CA Score Rejected | Passed | | Invalid Exam Score Rejected | Passed | Evidence Screenshots demonstrating successful implementation, relationship and constraint validations, query executions are provided in the 'evidence/' folder.

Conclusion

The database design is in Third Normal Form (3NF), has foreign KEYs enforcing Referential integrity, has UNIQUE KEYs preventing duplicate Institutional records, has CHECK KEYs validating assessment scores and has generated columns automatically computing grading values.

The design lays a solid foundation for subsequent portfolio work in query optimization, transactions, NoSQL modeling and distributed databases.
