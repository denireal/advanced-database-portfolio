# Execution Plans and Query Analysis: Luma Polytechnic

## 1. Query 1: Transcript Generation (Nested Loop Joins)
**Command:** `EXPLAIN FORMAT=JSON [Query 1];`

### Execution Plan Analysis
The Cost-Based Optimizer (CBO) selects a **Nested Loop Join** strategy. 
- **Driving Table:** `students`. The `WHERE s.matric_no = '...'` clause uses the `uq_students_matric` unique index. Access type is `const` (or `eq_ref`), examining exactly 1 row.
- **Joined Tables:** `programmes`, `registrations`, `course_offerings`, `courses`, `academic_terms`, `grades`, `grade_scale`.
- **Access Types:** 
  - `eq_ref` is used for joins on Primary Keys (e.g., `course_offerings.offering_id = registrations.offering_id`). This is the fastest join type in MySQL, reading exactly one row per combination.
  - `ref` is used for Foreign Key lookups (e.g., `students.programme_id = programmes.programme_id`).
- **Performance Verdict:** Highly optimized. The InnoDB Clustered Index (B+Tree) on Primary Keys ensures that secondary index lookups on Foreign Keys resolve in $O(\log N)$ time. Total rows examined is minimal.

## 2. Query 2: Seat Availability (Composite Index Utilization)
**Command:** `EXPLAIN ANALYZE [Query 2];`

### Execution Plan Analysis
- **Target Index:** `idx_reg_offering_status` on `registrations(offering_id, status)`.
- **Access Type:** `ref`. The optimizer uses the `offering_id` to locate the specific offering, and the `status = 'REGISTERED'` filter is applied directly within the index tree.
- **Index Condition Pushdown (ICP):** Because both `offering_id` and `status` are in the composite index, MySQL pushes the `status` condition down to the storage engine. The engine filters rows at the index level before reading the actual table rows (clustered index lookup), drastically reducing I/O.
- **Aggregation:** The `GROUP BY` operates on the pre-filtered result set.

## 3. Query 3: View Resolution (TEMPTABLE Algorithm)
**Command:** `EXPLAIN FORMAT=JSON [Query 3];`

### Execution Plan Analysis
- **View Resolution:** The `v_semester_gpa` view contains a `GROUP BY` clause. According to MySQL 8.0 documentation, views with aggregation cannot use the `MERGE` algorithm. The CBO is forced to use the `TEMPTABLE` algorithm.
- **Execution Flow:** 
  1. MySQL materializes the entire `v_transcript` join into an internal InnoDB temporary table.
  2. It groups the data by `student_id` and `term_id` to calculate the GPA.
  3. The outer query then filters this temporary table for `gpa < 2.00`.
- **Performance Bottleneck:** Materializing the temporary table requires significant memory/disk I/O and CPU cycles for sorting and grouping. For a dataset of 100,000 students, this query will exhibit high latency.

## 4. Query 5: Suboptimal Query & Index Optimization
**Baseline Command:** `EXPLAIN SELECT ... FROM students WHERE entry_year = 2026 AND status = 'ACTIVE';`
- **Baseline Result:** `type: ALL` (Full Table Scan). The `rows` column shows the total number of students in the table. `Extra: Using where`. The storage engine must read every single row from the clustered index to evaluate the `WHERE` clause.

**Optimization Command:** 
```sql
CREATE INDEX idx_students_year_status ON students(entry_year, status);
EXPLAIN SELECT ... FROM students WHERE entry_year = 2026 AND status = 'ACTIVE';
