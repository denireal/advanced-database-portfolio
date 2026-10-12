# MIT 8103 Advanced Database Systems

## Practical Database Portfolio

### Southern Technical University Academic Portal

---

## 1. Project Overview

This repository contains the practical database portfolio developed for **MIT 8103 – Advanced Database Systems**.

The project uses a realistic academic information system based on the **Southern Technical University Academic Portal**.

The system is designed to demonstrate practical application of advanced database concepts including database modelling, SQL query processing, query optimisation, transaction management, NoSQL data modelling, and distributed/cloud database concepts.

---

## 2. Case Study: Southern Technical University Academic Portal

### 2.1 Organisation Overview
Southern Technical University is a premier tertiary institution focused on engineering, technology, and applied sciences. The university manages thousands of students across multiple academic departments, tracking their full lifecycle from admission and course registration to grade processing and graduation.

### 2.2 Nature of the Business / System
The Academic Portal is a centralized online management system designed to streamline academic operations. It replaces legacy manual record-keeping with an automated, transaction-safe database environment that handles real-time course enrollments, continuous assessments, and GPA computations.

### 2.3 Database Users
- **Students:** Access the portal to register for semester courses, view lecture schedules, check semester grades, and monitor cumulative grade point averages (CGPA).
- **Lecturers:** Input continuous assessment and exam scores, manage course rosters, and track student performance.
- **Department Heads & Administrators:** Manage departmental course offerings, assign lecturing staff, resolve registration conflicts, and generate official academic transcripts.

### 2.4 Major Data Stored
- **Departments:** Administrative units, departmental names, and head of department details.
- **Admin Users:** Secure system operators, registrars, and Deans featuring role-based access control, 2FA credentials, account lifecycle status, and departmental restrictions.
- **Lecturers:** Faculty member profiles, contact information, and departmental affiliations.
- **Students:** Student profiles, matriculation numbers, admission years, and departmental details.
- **Courses:** Course codes, titles, credit units, and owning departments.
- **Enrollments:** Mapping table connecting students to courses taken during specific semesters and sessions, including scores and computed letter grades.

### 2.5 Key Operations Supported
- **Course Registration:** Allowing students to enroll in approved courses for a given semester and academic session.
- **Grade Entry:** Permitting authorized lecturers to post and update student marks.
- **GPA Computation:** Calculating semester GPA (SGPA) and cumulative GPA (CGPA) based on course credits and grade points.
- **Transcript Generation:** Querying historic enrollment and grade records to produce a complete student academic history.

The relational database is named:
```text
southern_tech_university_db
