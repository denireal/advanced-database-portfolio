# Brief Performance Analysis

**Course:** MIT 8103 Advanced Database Systems  
**Case study:** Luma Polytechnic  
**Database:** `luma_db`  
**DBMS:** MySQL 8.0.16 using phpMyAdmin

## Objective

This analysis compares selected query executions and interprets their MySQL execution plans. Because the database contains only a small sample dataset, measured execution times are treated as observations from this run, not as proof of a general performance improvement.

## Observed results

| Test | Rows returned | phpMyAdmin time | Main observation |
|---|---:|---:|---|
| Baseline five-table join | 7 | 0.0010 seconds | The plan included a full scan of `students` and a temporary-table/filesort note. |
| Filtered join for `LP/2025/001` | 3 | 0.0009 seconds | MySQL used the unique index `uq_students_matric`. |
| Filtered grades report for `LP/2025/001` | 2 | Not recorded here | The plan used the matriculation-number index and indexed joins for registrations, offerings, and grades. |
| Grade range query (`total_score >= 80`) | 2 | 0.0007 seconds | MySQL used `idx_grades_total_score` with range access. |

## Interpretation

The filtered join was 0.0001 seconds faster in this run than the baseline join. This difference is too small to support a strong performance claim, particularly because the baseline and filtered queries return different numbers of rows. The execution plan is more useful evidence that the selective student query used the unique index on `matric_number`.

For the grade range query, `EXPLAIN` reported `type=range`, selected `idx_grades_total_score`, and estimated two rows. The query returned two records in descending score order: 87.00 and 83.00, both with letter grade A. The reported 0.0007-second execution time is specific to this small test.

## Dataset limitation

The five tables used in the analysis contained 26 rows in total:

| Table | Rows |
|---|---:|
| `students` | 4 |
| `registrations` | 7 |
| `course_offerings` | 5 |
| `courses` | 4 |
| `grades` | 6 |
| **Total** | **26** |

MySQL may choose a full table scan when the table is very small and scanning it is estimated to be cheaper than using an index. Therefore, these results demonstrate observed index selection and optimizer behaviour, but they do not quantify the performance benefit expected for a larger database.

## Conclusion

The tests confirmed use of `uq_students_matric` for filtering a student by matriculation number and `idx_grades_total_score` for range filtering on grade totals. The recorded execution times are very small and should not be presented as evidence of a significant or scalable speedup. A larger dataset and repeated controlled measurements would be needed for a stronger performance comparison.
