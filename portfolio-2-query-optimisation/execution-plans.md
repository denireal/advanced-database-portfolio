# Query Execution Plan & Optimisation Analysis

## 1. Inspecting Execution Plans with EXPLAIN
To evaluate how the MySQL query optimizer executes complex multi-table queries, the `EXPLAIN` statement is prefixed to query statements. This outputs an execution plan detailing:
* **`id`**: The sequence identifier of the query step.
* **`select_type`**: The type of SELECT query (e.g., SIMPLE, PRIMARY, SUBQUERY).
* **`table`**: The table reference being accessed.
* **`type`**: The join type or access method (e.g., `ALL`, `index`, `range`, `ref`, `eq_ref`, `const`). A type of `ALL` indicates a full table scan, which is a performance bottleneck on large tables.
* **`possible_keys`**: Indexes that the optimizer could potentially use.
* **`key`**: The actual index chosen and utilized by the optimizer.
* **`rows`**: The estimated number of rows the database engine must examine to execute that step.
* **`Extra`**: Additional execution details such as "Using index", "Using temporary", or "Using filesort".

---

## 2. Pre-Optimisation Analysis
When executing Query 2 (joining `Enrollment`, `Student`, and `Course`), running an `EXPLAIN` analysis reveals potential performance bottlenecks:
```sql
EXPLAIN 
SELECT s.matric_no, c.course_code, e.score 
FROM Enrollment e
JOIN Student s ON e.student_id = s.student_id
JOIN Course c ON e.course_id = c.course_id
WHERE e.academic_session = '2026/2027';
