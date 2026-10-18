# Normalisation: Luma Polytechnic (`lumapoly`)

**Portfolio 1:** Database Design and Modelling
This document shows how the 10-table design in `relational-schema.sql` was reached from an unnormalised result sheet.

---

## 1. Starting Point: Unnormalised Result Sheet

The registry's existing result sheet records everything for a student in one row:

| matric_no | student_name | programme | department | courses | course_titles | units | lecturers | session | semester | CA | exam | total | letter | point |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| LP/26/CSC/0001 | Ada Okafor | ND Computer Science | Computer Science | COM111, COM112 | Introduction to Computing, Programming Fundamentals | 3, 4 | Dr Eze, Mr Musa | 2026/2027 | FIRST | 27, 22 | 58, 48 | 85, 70 | A, AB | 4.00, 3.50 |

**Problems with this structure**

| Anomaly | Example |
|---|---|
| Multi-valued cells | Several courses, scores and grades in one cell make searching and calculating GPA impossible |
| Redundancy | Student, programme and course details are repeated for every course taken |
| Update anomaly | Renaming a course means editing every row that mentions it |
| Insert anomaly | A new course cannot be recorded until a student takes it |
| Delete anomaly | Deleting the only student on a course also deletes the course details |
| Inconsistent derived data | A typed `total`, `letter` or `point` can disagree with the scores |

---

## 2. First Normal Form (1NF)

**Rule:** every cell holds a single atomic value and there are no repeating groups.

**Action:** split the multi-valued cells so that there is one row per student, per course, per term.

```
RESULT (matric_no, course_code, session, semester,
        student_name, programme, department,
        course_title, credit_units,
        lecturer_name, lecturer_department,
        ca, exam, total, letter, grade_point)
```

**Candidate key:** `(matric_no, course_code, session, semester)`

The relation is now in 1NF, but it still holds a lot of repeated data.

---

## 3. Second Normal Form (2NF)

**Rule:** the relation is in 1NF and every non-key attribute depends on the *whole* composite key, not just part of it.

**Functional dependencies found**

| Determinant | Determines | Type |
|---|---|---|
| `matric_no` | `student_name, programme, department` | Partial (part of key only) |
| `course_code` | `course_title, credit_units` | Partial |
| `(course_code, session, semester)` | `lecturer_name, lecturer_department` | Partial (this is the course offering) |
| `(matric_no, course_code, session, semester)` | `ca, exam` | Full key (correct here) |

**Action:** move each partial dependency to its own relation.

```
STUDENT         (matric_no, student_name, programme, department)
COURSE          (course_code, course_title, credit_units)
COURSE_OFFERING (course_code, session, semester, lecturer_name, lecturer_department)
REGISTRATION    (matric_no, course_code, session, semester, ca, exam, total, letter, grade_point)
```

Course details are now stored once, and a new course can exist before anyone registers for it.

---

## 4. Third Normal Form (3NF)

**Rule:** the relation is in 2NF and there are no transitive dependencies (non-key attributes depending on other non-key attributes).

**Transitive dependencies found and removed**

| Transitive dependency | Resolution |
|---|---|
| `matric_no -> programme -> department` | New tables `programmes` and `departments`; `students` keeps only `programme_id` |
| `lecturer_name -> lecturer_department` | New table `lecturers` with a `department_id`; offerings keep only `lecturer_id` |
| `total -> letter -> grade_point` | Letter and point depend on the score band, not on the registration. They move to the `grade_scale` lookup table |
| `total = ca + exam` | Derivable, so `total_score` becomes a generated column that cannot be typed in |
| `session` and `semester` repeated across rows | New table `academic_terms`; offerings keep only `term_id` |

**Surrogate keys** (`student_id`, `course_id`, `offering_id` and so on) replace the long composite keys, so child tables carry a single-column foreign key. The natural identifiers stay as UNIQUE keys (`matric_no`, `course_code`, `(course_id, term_id)`).

**Final relations**

```
departments      (department_id, code, name)
programmes       (programme_id, department_id, name, award, duration_years)
students         (student_id, matric_no, full_name, email, phone, date_of_birth, gender,
                  programme_id, entry_year, status, created_at)
lecturers        (lecturer_id, staff_no, full_name, email, department_id, academic_rank)
courses          (course_id, department_id, course_code, title, credit_units, course_level)
academic_terms   (term_id, session_label, semester, start_date, end_date, is_current)
course_offerings (offering_id, course_id, term_id, lecturer_id, capacity)
registrations    (registration_id, student_id, offering_id, registered_at, status)
grades           (registration_id, ca_score, exam_score, total_score, entered_by, entered_at)
grade_scale      (grade_letter, min_score, max_score, grade_point)
```

Every non-key attribute now depends on the key, the whole key, and nothing but the key.

---

## 5. Boyce-Codd Normal Form (BCNF) Check

**Rule:** for every non-trivial functional dependency X -> Y, X must be a superkey.

| Table | Determinants | Superkey? |
|---|---|---|
| departments | `department_id`, `code`, `name` | Yes (PK and UNIQUE) |
| programmes | `programme_id`, `(name, award)` | Yes |
| students | `student_id`, `matric_no`, `email`, `phone` | Yes |
| lecturers | `lecturer_id`, `staff_no`, `email` | Yes |
| courses | `course_id`, `course_code` | Yes |
| academic_terms | `term_id`, `(session_label, semester)` | Yes |
| course_offerings | `offering_id`, `(course_id, term_id)` | Yes |
| registrations | `registration_id`, `(student_id, offering_id)` | Yes |
| grades | `registration_id` | Yes |
| grade_scale | `grade_letter`, `min_score` | Yes |

All determinants are candidate keys, so the schema is in BCNF.

---

## 6. Anomalies Resolved

| Anomaly | How the final design prevents it |
|---|---|
| Update | A course title or lecturer name is stored in one row only |
| Insert | Courses, lecturers and students can be added before any registration exists |
| Delete | Deleting a registration does not remove the student or course (RESTRICT on those keys) |
| Inconsistent derived data | Total is generated, and letters and GPA are computed from `grade_scale` in views |

---

## 7. Deliberate Design Decisions and Trade-offs

| Decision | Justification and trade-off |
|---|---|
| Course separated from course offering | A course is a permanent catalogue item; an offering is a term-specific event. Merging them would repeat titles and units every semester. |
| Registration separated from grade | Different lifecycles (early in the semester vs after exams) and different writers (student vs lecturer). A 1:0..1 table avoids NULL score columns on every registration. |
| Letter grade and grade point **not stored** | They are derived through `grade_scale`, so a grade can never disagree with its score. **Trade-off:** if the institution changes its scale, old results would be recalculated. In production I would add `effective_from` to the scale or snapshot the letter at entry time. |
| GPA and CGPA computed in views | Stored GPAs would go stale whenever a score is corrected. **Trade-off:** computation cost at read time, which is examined in Portfolio 2 and could be addressed with a summary table or materialised result. |
| `total_score` stored as a generated column | Guarantees consistency with CA and exam, and allows indexing. Storing it is not a normalisation violation because it is computed by the database and cannot diverge. |
| One lecturer per offering | Simplifies the model. Team teaching would need an `offering_lecturers` junction table. |
| Surrogate keys plus natural UNIQUE keys | Surrogates stay stable and compact; natural identifiers remain enforced for business use. |
| Single cascade (`grades` from `registrations`) | Academic data should not vanish silently; every other delete is blocked. |

---

## 8. Verification

The normalised design was loaded into MySQL 8.0 and tested with `seed_data.sql`:

```sql
SELECT * FROM v_transcript;
SELECT * FROM v_semester_gpa;
SELECT * FROM v_cgpa;
```

Check by hand: Ada Okafor (COM111 = 3 units, A; COM112 = 4 units, AB; COM121 = 3 units, B).
GPA = (3 x 4.00 + 4 x 3.50 + 3 x 3.25) / 10 = 3.575, displayed as **3.58**. The view should return the same value.
