# Case Study Description: Luma Polytechnic Student Records and Results Management System

## 1. Introduction

Luma Polytechnic is a simulated Nigeria's Federal Polytechnic that requires a structured database to manage student information, academic programmes, course registrations, lecturer assignments, and examination results. The institution needs a reliable relational database that supports accurate record keeping, efficient data retrieval, and consistent academic information.

This project designs and implements a Student Records and Results Management System using MySQL 8.0.16.

## 2. Problem Statement

Managing student and academic records using disconnected files or manual processes can lead to data duplication, inconsistent information, inaccurate results, and difficulties retrieving records. Without appropriate database constraints, invalid registrations and assessment scores may also be recorded.

Luma Polytechnic therefore requires a centralized relational database that maintains data integrity and supports common academic operations.

## 3. Aim and Objectives

The aim is to design and implement a relational database for managing student academic records.

The objectives are to:

- Store student details and institutional matriculation numbers.
- Organize departments and academic programmes.
- Maintain lecturer and course information.
- Record academic sessions, semesters, and course offerings.
- Manage student registrations for offered courses.
- Store continuous assessment and examination scores.
- Automatically calculate total scores, letter grades, and grade points.
- Enforce primary-key, foreign-key, uniqueness, and score-validation constraints.
- Support reliable SQL queries for retrieving academic information.

## 4. Scope of the System

The database covers the following entities:

1. Departments
2. Programmes
3. Students
4. Lecturers
5. Courses
6. Academic terms
7. Course offerings
8. Registrations
9. Grades

The system focuses on the relational data structure and database operations. It does not implement a complete student-facing web application, payment system, or learning management system.

## 5. Proposed Solution

The database is implemented in MySQL using relational tables connected through primary and foreign keys. Unique constraints help prevent duplicate institutional identifiers, while CHECK constraints restrict assessment scores to their permitted ranges.

Generated columns calculate total scores, letter grades, and grade points according to the rules implemented in the database schema. Appropriate indexes support record identification and selected query operations.

## 6. Expected Benefits

The proposed system is intended to:

- Improve the consistency of student and academic records.
- Reduce unnecessary data duplication through normalization.
- Maintain referential integrity between related records.
- Reject invalid assessment scores.
- Simplify the retrieval of registrations and examination results.
- Provide a foundation for future query optimization, transaction processing, NoSQL, and distributed database exercises.

## 7. Database Platform

**DBMS:** MySQL 8.0.16  
**Administration tool:** phpMyAdmin  
**Storage engine:** InnoDB, where specified in the implementation

## 8. Conclusion

The Luma Polytechnic case study provides a practical basis for demonstrating relational database design, normalization, constraint enforcement, SQL querying, and data integrity. The implementation establishes the foundation for the subsequent advanced database portfolios.
