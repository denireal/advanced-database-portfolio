# Case Study Description: Luma Polytechnic

**Course:** MIT 8103 Advanced Database Systems | **Portfolio 1:** Database Design
**DBMS:** MySQL 8.0 (InnoDB) | **Database name:** `luma_db`

---

## 1. Selected Organisation

**Organisation / scenario:** Luma Polytechnic, a simulated Nigerian polytechnic that offers National Diploma (ND) and Higher National Diploma (HND) programmes. The polytechnic is fictional, and all names and data in this portfolio are made up purely for the continuous assignment.

**Nature of the business / system:** A student records and results database. It supports course registration, continuous assessment (CA) and examination scoring, GPA/CGPA computation, and transcript generation.

## 2. Users of the Database

| User | What they do with the database |
|---|---|
| Students | Register for courses, view results and transcripts |
| Lecturers | View class lists, enter CA and exam scores |
| Academic registry staff | Admit students; manage programmes, courses, terms and offerings |
| Heads of department and management | Review results, pass/fail rates and lecturer workload |

## 3. Major Data to Be Stored

- Departments and the programmes (ND/HND) they offer
- Students (matriculation number, personal details, programme, entry year, status)
- Lecturers (staff number, department, rank)
- Course catalogue (code, title, credit units, level)
- Academic sessions and semesters
- Course offerings (a course taught in a term by a lecturer, with seat capacity)
- Student course registrations
- CA and exam scores
- The grading scale (score band, letter grade, grade point)

## 4. Key Operations Supported

1. Admit and maintain student records
2. Offer courses in a semester with an assigned lecturer and capacity
3. Register students for courses
4. Enter CA and exam scores
5. Compute letter grades, semester GPA and CGPA
6. Generate a student transcript
7. Report on class lists, pass/fail rates and lecturer workload

## 5. Business Rules

These rules drive the keys, constraints and relationships in this design.

1. A department offers one or more programmes (ND or HND) and employs lecturers.
2. Each student belongs to exactly one programme and has a unique matriculation number.
3. A course is a catalogue entry (code, title, credit units, level). It exists independently of any semester.
4. A course is *offered* in a term (session plus semester) by one lecturer, with a seat capacity. A course is offered at most once per term.
5. A student registers for a given offering at most once.
6. Each registration has at most one score record: CA (0 to 30) plus exam (0 to 70), giving a total out of 100.
7. The letter grade and grade point come from the grading scale. They are derived and never typed in.
8. Semester GPA = sum(credit units x grade point) / sum(credit units). CGPA applies the same formula across all terms.

**Rules to be enforced with transactions or procedures in Portfolio 3:**
- Registrations must not exceed an offering's capacity.
- A student's registered credit units per semester must not exceed a cap (for example 24).
- Scores may only be entered by the lecturer assigned to that offering.

## 6. Grading Scale Used (simulated)

| Letter | Score band | Grade point |
|---|---|---|
| A | 75 to 100 | 4.00 |
| AB | 70 to 74 | 3.50 |
| B | 65 to 69 | 3.25 |
| BC | 60 to 64 | 3.00 |
| C | 55 to 59 | 2.75 |
| CD | 50 to 54 | 2.50 |
| D | 45 to 49 | 2.25 |
| E | 40 to 44 | 2.00 |
| F | 0 to 39 | 0.00 |

This is a simulated 4.0 scale in the style of Nigerian polytechnics. It is stored in the `grade_scale` table and can be changed without altering any other table.

## 7. Why This Case Study Suits the Whole Portfolio

| Portfolio | How Luma Polytechnic supports it |
|---|---|
| 1. Design and modelling | Clear entities, a many-to-many relationship (students and offerings), a 1:1 relationship (registration and grade), and a derived-data problem (grades and GPA) |
| 2. Query optimisation | Can be scaled to tens of thousands of students and over a million registrations for realistic transcript, GPA and class-list queries |
| 3. Transactions and concurrency | Last-seat registration race, credit-unit cap, concurrent score correction while transcripts are printed |
| 4. NoSQL | A transcript maps naturally to one document; student-course relationships suit a graph |
| 5. Distributed and cloud | Heavy read load on results-release day suits read replicas; sharding by programme or entry year can be discussed |

## 8. Related Files in This Folder

| File | Contents |
|---|---|
| `ER-diagram.png` | Entity-relationship diagram (crow's foot notation) |
| `keys-and-constraints.md` | Relational schema, keys, referential actions, constraints and constraint tests |
| `normalization.md` | Normalisation from an unnormalised result sheet to BCNF, with design trade-offs |
| `relational-schema.sql` | DDL: database, tables, constraints, indexes and views |
| `seed_data.sql` | Sample data and verification queries |
