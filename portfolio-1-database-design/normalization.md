# Database Normalization: Luma Polytechnic

## 1. Introduction

Normalization is the process of structuring relational tables to reduce unnecessary data duplication and prevent insertion, update, and deletion anomalies. The Luma Polytechnic Student Records and Results Management System uses separate tables for major academic entities and connects them through primary and foreign keys.

The design targets Third Normal Form (3NF).

## 2. First Normal Form (1NF)

A relation satisfies First Normal Form when each field contains a single value, each record can be uniquely identified, and repeating groups are avoided.

In the Luma Polytechnic database:

- Student information is stored as individual fields in the `students` table.
- Department details are stored in `departments`.
- Course information is stored in `courses`.
- Student course registrations are represented by individual records in `registrations`.
- Assessment results are represented in `grades`.

This structure avoids storing multiple courses or multiple grades as lists inside a single student record.

## 3. Second Normal Form (2NF)

Second Normal Form requires a table to satisfy 1NF and ensures that every non-key attribute depends on the whole candidate key, rather than only part of a composite key.

The design uses surrogate primary keys such as `student_id`, `course_id`, `programme_id`, and `registration_id`. Descriptive attributes are stored in the table representing the entity to which they belong.

For example, student names and email addresses are stored in `students`, while course titles are stored in `courses`. Registration-specific information is stored in `registrations`.

This arrangement helps avoid partial dependencies and separates attributes according to their logical ownership.

## 4. Third Normal Form (3NF)

Third Normal Form requires a table to satisfy 2NF and avoid inappropriate transitive dependencies among non-key attributes.

The database separates departments, programmes, students, lecturers, courses, academic terms, course offerings, registrations, and grades into distinct tables.

Examples include:

- Department details are stored in `departments`, rather than repeatedly recorded for every student or lecturer.
- Programme details are stored in `programmes`; students reference their programme through `programme_id`.
- Course details are stored in `courses`, while term-specific delivery and lecturer allocation are represented in `course_offerings`.
- Student participation in course offerings is recorded in `registrations`.
- Assessment results are stored in `grades`, associated with registrations through `registration_id`.

These relationships reduce duplicated descriptive information and support consistent updates.

## 5. Normalization Summary

| Normal Form | Design Application |
|---|---|
| 1NF | Attributes are stored as individual values, with repeating groups represented by related records. |
| 2NF | Entity attributes are associated with their relevant primary keys; surrogate keys simplify identification. |
| 3NF | Separate tables represent departments, programmes, courses, students, offerings, registrations, and grades to reduce transitive dependencies. |

## 6. Benefits of the Design

The normalized structure:

- Reduces unnecessary duplication of descriptive data.
- Helps prevent inconsistent updates.
- Makes relationships between academic records explicit.
- Supports referential integrity through foreign keys.
- Improves maintainability and makes future extension easier.

## 7. Conclusion

The Luma Polytechnic schema is designed to meet the principles of 1NF, 2NF, and 3NF through atomic attributes, clear entity identification, and separation of related academic entities. The implemented schema should be checked against its actual keys, dependencies, and constraints when evaluating formal normalization compliance.
