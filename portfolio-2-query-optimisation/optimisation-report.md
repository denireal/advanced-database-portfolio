# Optimisation Report

## 1. Introduction

This report presents query-processing and optimisation tests for the Luma Polytechnic student registration and results database, implemented in MySQL 8.0.16 and accessed through phpMyAdmin. The tests focus on multi-table joins, filtering by student matriculation number, inspecting execution plans with `EXPLAIN`, and evaluating an existing index on grade totals.

## 2. Queries and execution plans

A baseline query joined `students`, `registrations`, `course_offerings`, `courses`, and `academic_terms`. It returned seven rows, and phpMyAdmin reported 0.0010 seconds. Its recorded execution plan included a full scan of `students` and a temporary-table/filesort note. A filtered version for `LP/2025/001` returned three rows and took 0.0009 seconds. In this plan, MySQL selected the unique index `uq_students_matric` for the student lookup.

The difference between the observed times was 0.0001 seconds. Since the queries return different row counts and the dataset is very small, this difference does not establish a significant performance improvement. The main defensible finding is that the filtered query's execution plan used the matriculation-number index.

## 3. Grades query and join-order test

The grades report joined `grades`, `registrations`, `students`, `course_offerings`, and `courses`. The unfiltered plan showed scans of the small `students` and `courses` tables and indexed lookups for several other joins, including the unique key `uq_grade_registration`.

Filtering the report to matriculation number `LP/2025/001` used `uq_students_matric` and indexed joins for registrations, offerings, and grades. The returned records were:

| Course | CA | Exam | Total | Letter grade | Grade point |
|---|---:|---:|---:|---|---:|
| CST301 — Advanced Database Systems | 25 | 58 | 83 | A | 5.00 |
| CST302 — Data Structures and Algorithms | 26 | 61 | 87 | A | 5.00 |

An alternative statement that placed `students` first in the inner-join sequence produced the same observed execution plan. This test did not demonstrate a plan change or a measurable improvement. It illustrates that changing the written order of inner joins does not necessarily change the execution plan chosen by MySQL.

## 4. Index evaluation

The `grades` table already had the index `idx_grades_total_score` on `total_score`. The query filtered rows using `total_score >= 80` and ordered them by score descending. `EXPLAIN` reported `type=range`, selected `idx_grades_total_score`, and estimated two rows. The executed query returned two rows:

| Registration ID | Total score | Letter grade | Grade point |
|---:|---:|---|---:|
| 4 | 87.00 | A | 5.00 |
| 1 | 83.00 | A | 5.00 |

phpMyAdmin reported an execution time of 0.0007 seconds. This confirms that MySQL selected the existing index for the range predicate. The available output does not justify claiming a quantified speedup or assuming that the index eliminated sorting.

The student table also had the unique index `uq_students_matric`, which was used by the filtered query. The recorded evidence did not establish a need to add a redundant index to `students`. The `courses` table already had a primary-key index on `course_id`; a full scan in this tiny table is not, by itself, evidence that another index is needed.

## 5. Dataset size and limitations

The five relevant tables contained 26 records:

| Table | Rows |
|---|---:|
| `students` | 4 |
| `registrations` | 7 |
| `course_offerings` | 5 |
| `courses` | 4 |
| `grades` | 6 |
| **Total** | **26** |

The small number of records affects optimizer decisions. MySQL can estimate that a full table scan costs less than index lookups for a table with only a few rows. The measured query times are also very short and may vary with server load, caching, and measurement overhead. Consequently, these tests should be treated as evidence of observed execution-plan behaviour and index selection rather than proof of substantial performance improvement at scale.

## 6. Conclusion

The tests demonstrated that MySQL used the unique matriculation-number index for selective student retrieval and the existing grade-total index for a range query. Several joins used primary or unique keys. Reordering the inner joins did not change the observed plan. The measured times were 0.0010 seconds for the baseline join, 0.0009 seconds for the filtered join, and 0.0007 seconds for the grade range query. Because only 26 rows were present across the five examined tables, the results do not quantify the likely benefit for a larger system.

## 7. Evidence and reproducibility

Include the SQL statements, genuine phpMyAdmin result screenshots, `EXPLAIN` screenshots, index output, and row-count output in the Portfolio 2 folder. Recommended screenshots are listed in `evidence/evidence-checklist.md` if that checklist is included in the repository. Verify that every screenshot corresponds to the query and results described here.

## 8. References and tools

- MySQL `EXPLAIN` output generated in the local `luma_db` database.
- MySQL index metadata obtained using `SHOW INDEX`.
- Query result and execution-time messages displayed by phpMyAdmin.

These are observations from the implementation environment. Do not present them as results from an external benchmark.
