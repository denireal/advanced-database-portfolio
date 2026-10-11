# Normalisation Explanation (UNF -> 1NF -> 2NF -> 3NF / BCNF)

## 1. Starting point: the paper result sheet (UNF)

Before the database, results were captured on a single sheet per student. One row of that sheet looks like this:

```
RESULT_SHEET(
  matric_no, student_name, programme_name, department_name,
  session_name, semester_name,
  { course_code, course_title, credit_unit, lecturer_name, lecturer_rank,
    ca_score, exam_score, total_score, grade, grade_point }
)
```

The braces `{ }` mark a **repeating group**: one student has many courses per semester. This is **unnormalised form (UNF)**.

## 2. First Normal Form (1NF): remove repeating groups

**Rule:** every attribute holds a single atomic value, and there are no repeating groups.

**Action:** give each course taken its own row, so the key becomes (`matric_no`, `session_name`, `semester_name`, `course_code`).

```
RESULT_ROW(
  matric_no, session_name, semester_name, course_code,
  student_name, programme_name, department_name,
  course_title, credit_unit, lecturer_name, lecturer_rank,
  ca_score, exam_score, total_score, grade, grade_point)
```

**Anomalies still present:** a student's name and programme are repeated on every course row, and a course title and credit unit are repeated for every student who takes it.

## 3. Second Normal Form (2NF): remove partial dependencies

**Rule:** in 1NF, and every non-key attribute depends on the *whole* key, not part of it.

Functional dependencies on the composite key (`matric_no`, `session_name`, `semester_name`, `course_code`):

| Determinant (part of key) | Dependent attributes | Problem |
|---|---|---|
| `matric_no` | student_name, programme_name, department_name | Depends on only part of the key |
| `course_code` | course_title, credit_unit | Depends on only part of the key |
| (`course_code`, `session_name`, `semester_name`) | lecturer_name, lecturer_rank | Depends on part of the key (not the student) |
| whole key | ca_score, exam_score, total_score, grade, grade_point | Full dependency (correct) |

**Action:** split the relation along these dependencies.

```
STUDENT(matric_no, student_name, programme_name, department_name)
COURSE(course_code, course_title, credit_unit)
OFFERING(course_code, session_name, semester_name, lecturer_name, lecturer_rank)
RESULT(matric_no, course_code, session_name, semester_name,
       ca_score, exam_score, total_score, grade, grade_point)
```

## 4. Third Normal Form (3NF): remove transitive dependencies

**Rule:** in 2NF, and no non-key attribute depends on another non-key attribute.

| Transitive dependency | Fix |
|---|---|
| `matric_no -> programme -> department_name` | Programme and department become their own relations; students reference the programme and **do not store the department at all** (it is reachable via the programme) |
| `lecturer_name -> lecturer_rank` (lecturer details repeated per offering) | `lecturers` relation keyed by `lecturer_id`; offerings reference it |
| `session_name -> start_date, end_date, status` | `academic_sessions` relation; `semesters` references it |
| `ca_score + exam_score -> total_score -> grade -> grade_point` | See section 5 |
| Many-to-many programme and course | Resolved with the `programme_courses` junction table |

After this step the schema is the 13-table design in [`relational-schema.md`](relational-schema.md).

## 5. The derived-attribute problem in `results`

`total_score = ca_score + exam_score`, `grade` is determined by `total_score`, and `grade_point` is determined by `grade`. These are chains of dependencies *between non-key attributes*, which breaks 3NF. If stored as ordinary columns, someone could update `exam_score` and forget `total_score` and `grade`, leaving a contradictory row (an update anomaly).

**Decision:** keep only the raw facts (`ca_score`, `exam_score`) as real data, and declare the other three as **`GENERATED ALWAYS ... STORED` columns**.

- The DBMS recomputes them on every insert or update, so they can never disagree with the raw scores.
- They cannot be written to directly.
- `STORED` (rather than `VIRTUAL`) materialises the values on disk, so transcript and GPA queries read them directly instead of recomputing the `CASE` expression on every row. The cost is extra storage and a little write overhead. Both variants can be indexed in InnoDB, so Portfolio 2 can compare them with `EXPLAIN` if you want evidence.

**Trade-offs acknowledged:**
- The grading scale is hard-coded in the column definition (generated columns cannot contain subqueries). If the polytechnic changes its approved scale, the table needs an `ALTER TABLE`. A `grading_scale` lookup table with a view would be more flexible but moves the derivation out of the table.
- Storing derived values is a deliberate, controlled denormalisation for read performance, and it is safe because the database, not application code, maintains them.

## 6. Final check: each relation against 3NF and BCNF

BCNF requires every determinant to be a candidate key. Each table's functional dependencies (FDs) are listed below, including alternate keys.

| Relation | Functional dependencies | 3NF | BCNF |
|---|---|---|---|
| academic_sessions | session_id -> all; session_name -> all | Yes | Yes |
| semesters | semester_id -> all; (session_id, semester_name) -> semester_id | Yes | Yes |
| departments | department_id -> all; department_code -> all; department_name -> all | Yes | Yes |
| programmes | programme_id -> all; programme_code -> all | Yes | Yes |
| students | student_id -> all; matric_no -> all; email -> all | Yes | Yes |
| lecturers | lecturer_id -> all; staff_no -> all; email -> all | Yes | Yes |
| courses | course_id -> all; course_code -> all | Yes | Yes |
| programme_courses | (programme_id, course_id) -> course_status | Yes | Yes |
| course_offerings | offering_id -> all; (course_id, semester_id) -> all | Yes | Yes |
| course_registrations | registration_id -> all; (student_id, offering_id) -> all | Yes | Yes |
| results | result_id -> all; registration_id -> all; (ca_score, exam_score) -> derived columns | Yes (derived columns are DBMS-maintained, see section 5) | Yes, apart from the controlled derivation |
| users | user_id -> all; username -> all; student_id -> all; lecturer_id -> all | Yes | Yes |
| audit_logs | audit_id -> all | Yes | Yes |

In every relation, each determinant is a (candidate) key. The one non-key determinant, `(ca_score, exam_score)` in `results`, is the managed derivation explained in section 5.

## 7. Deliberate decisions and exceptions worth knowing

1. **`students.academic_level` (current level) is a snapshot.** It could be derived from `admission_year` and the current session, but promotion is an administrative decision (repeats, carry-overs), so it is stored as a fact rather than computed.
2. **`audit_logs.old_value` / `new_value` hold JSON.** Storing a document in one column looks like a 1NF violation, but these are opaque point-in-time snapshots of *another* table's row, never joined or updated in place. This is a justified use of the JSON type and a natural link to Portfolio 4.
3. **One lecturer per offering.** `lecturer_id` sits directly in `course_offerings`, which is correct only because `(course_id, semester_id)` determines the lecturer. Team teaching would introduce a multi-valued dependency and require a separate `offering_lecturers` table (4NF).
4. **`courses.level` and `programme_courses`.** The course's own level is a property of the course. The programme-specific facts (core/elective) are in the junction table because they depend on the *pair* of programme and course.
5. **Denormalisation for performance** (for example copying `total_score` into a summary table for GPA) is *not* done in Portfolio 1. If Portfolio 2 shows a need, it will be introduced and justified with measured evidence.

## 8. Anomalies eliminated (summary)

| Anomaly in the UNF sheet | How the final design removes it |
|---|---|
| **Insertion:** cannot add a new course until a student takes it | `courses` stands alone; `course_offerings` and `course_registrations` are separate |
| **Update:** changing a lecturer's rank means editing hundreds of rows | Rank stored once in `lecturers` |
| **Deletion:** deleting a student's only result loses the course details | Course, lecturer and offering rows are independent of results |
| **Inconsistency:** total and grade disagree with the scores | Generated columns make this impossible |
