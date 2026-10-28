# Execution Plans

**Course:** MIT 8103 Advanced Database Systems  
**Case study:** Luma Polytechnic  
**Database:** `luma_db`  
**DBMS:** MySQL 8.0.16 / phpMyAdmin

This document records the `EXPLAIN` findings observed while testing the queries in Portfolio 2. Screenshots of the actual phpMyAdmin output should be added to the repository as supporting evidence.

## 1. Baseline five-table join

The baseline query joins `students`, `registrations`, `course_offerings`, `courses`, and `academic_terms`, orders by `matric_number`, and limits the result to 20 rows.

| Table alias | Access type | Selected key | Estimated rows | Plan notes |
|---|---|---|---:|---|
| `at` | `index` | `uq_academic_term` | 2 | `Using index; Using temporary; Using filesort` |
| `co` | `ref` | `idx_offerings_term` | 1 | Reference to `at.term_id` |
| `c` | `eq_ref` | `PRIMARY` | 1 | Lookup by course primary key |
| `s` | `ALL` | None | 4 | `Using join buffer (flat, BNL join)` |
| `r` | `eq_ref` | `uq_student_offering` | 1 | Lookup using student and offering columns |

**Interpretation:** The recorded plan scanned the four-row `students` table and included a temporary-table/filesort note. The plan also used indexes for the offering, course, and registration lookups.

## 2. Filtered join by matriculation number

The filtered query uses:

```sql
WHERE s.matric_number = 'LP/2025/001'
```

| Table alias | Access type | Selected key | Estimated rows | Plan notes |
|---|---|---|---:|---|
| `s` | `const` | `uq_students_matric` | 1 | Unique matriculation-number lookup |
| `at` | `index` | `uq_academic_term` | 2 | `Using index` |
| `co` | `ref` | `idx_offerings_term` | 1 | Reference to `at.term_id` |
| `c` | `eq_ref` | `PRIMARY` | 1 | Lookup by course primary key |
| `r` | `eq_ref` | `uq_student_offering` | 1 | Uses the student and offering key columns |

**Interpretation:** The unique index `uq_students_matric` was selected. The filtered plan did not show the baseline plan's temporary-table/filesort note.

## 3. Unfiltered grades report

The grades report joins `grades`, `registrations`, `students`, `course_offerings`, and `courses`.

| Table alias | Access type | Selected key | Plan notes |
|---|---|---|---|
| `s` | `ALL` | None | Four student rows scanned; recorded output included a temporary/filesort note |
| `r` | `ref` | `uq_student_offering` | `Using index` |
| `co` | `eq_ref` | `PRIMARY` | Offering lookup by primary key |
| `g` | `eq_ref` | `uq_grade_registration` | Grade lookup by unique registration key |
| `c` | `ALL` | None | `Using where; Using join buffer (flat, BNL join)` |

**Interpretation:** Several joins used indexes, but MySQL scanned the small `students` and `courses` tables in the recorded plan.

## 4. Filtered grades report

The filtered grades report restricts the student to `LP/2025/001`.

| Table alias | Access type | Selected key | Estimated rows | Plan notes |
|---|---|---|---:|---|
| `s` | `const` | `uq_students_matric` | 1 | Unique lookup |
| `r` | `ref` | `uq_student_offering` | 3 | `Using index` |
| `co` | `eq_ref` | `PRIMARY` | — | Primary-key lookup |
| `g` | `eq_ref` | `uq_grade_registration` | — | Unique lookup by registration |
| `c` | `ALL` | None | 4 | `Using where; Using join buffer (flat, BNL join)` |

The filtered query returned two grade rows for the student: CST301 with total 83 and CST302 with total 87.

## 5. Alternative inner-join order

A version of the filtered grades query was rewritten to start from `students` and then join `registrations`, `grades`, `course_offerings`, and `courses`. The observed `EXPLAIN` output was the same as the filtered grades plan above.

**Conclusion:** The join-order rewrite did not change the observed plan. No performance improvement should be claimed from the rewrite on the available evidence.

## 6. Grade-score range query

Query condition:

```sql
WHERE total_score >= 80
ORDER BY total_score DESC
```

| Table | Access type | Possible key | Selected key | Estimated rows | Extra |
|---|---|---|---|---:|---|
| `grades` | `range` | `idx_grades_total_score` | `idx_grades_total_score` | 2 | `Using where` |

The plan confirms that MySQL selected the existing `idx_grades_total_score` index for range access. The query returned registration 4 with score 87.00 and registration 1 with score 83.00. The complete output should be retained as a screenshot; do not infer that sorting was eliminated unless the actual plan explicitly establishes that.

## Evidence screenshots to include

- `01-baseline-join-explain.png`
- `03-filtered-join-explain.png`
- `05-grades-report-explain.png`
- `07-filtered-grades-explain.png`
- `09-alternative-join-order-explain.png`
- `13-grade-score-index-explain.png`

Capture these from your own phpMyAdmin instance and check that the displayed plan matches this summary. If the output differs, update this document to reflect the actual result.
