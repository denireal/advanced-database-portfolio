# Execution Plans Analysis: Luma Polytechnic

## Query 1: Transcript Generation
**Command:** `EXPLAIN SELECT ...`
**Plan:** Nested Loop Join.
**Analysis:** The Cost-Based Optimizer (CBO) uses the `uq_students_matric` unique index to find the single student row instantly (`type: const`). It then uses the primary key indexes on `registrations`, `course_offerings`, and `grades` to perform `eq_ref` joins. This is the most efficient join type in MySQL, reading exactly one row per combination. Total rows examined is minimal.

## Query 2: Class List & Seat Availability
**Command:** `EXPLAIN SELECT ...`
**Plan:** Index Lookup and Aggregation.
**Analysis:** The query utilizes the composite index `idx_reg_offering_status (offering_id, status)` created in Portfolio 1. The `Extra` column shows `Using index`, indicating a Covering Index scan. MySQL reads the data directly from the index tree without touching the actual table rows, drastically reducing disk I/O during the `GROUP BY` aggregation.

## Query 3: View Resolution (Students at Risk)
**Command:** `EXPLAIN SELECT ...`
**Plan:** Temporary Table and Filesort.
**Analysis:** Because `v_semester_gpa` uses `GROUP BY`, MySQL cannot merge it into the outer query. The `EXPLAIN` output shows `Using temporary; Using filesort`. MySQL materializes the view into an internal temporary table, calculates the GPA for all students, and then filters for `gpa < 2.00`. This is computationally expensive on large datasets.

## Query 4: Index Optimization (Before & After)
**Before Index:** `EXPLAIN SELECT ... WHERE entry_year = 2026 AND status = 'ACTIVE';`
- **Result:** `type: ALL` (Full Table Scan). The `rows` column shows ~5,000. The database reads every row to check the `WHERE` clause.

**After Index:** `CREATE INDEX idx_year_status ON students(entry_year, status);` followed by `EXPLAIN`.
- **Result:** `type: ref` (Index Lookup). The `rows` examined drops from ~5,000 to only the matching records (e.g., ~1,600). The `Extra` column shows `Using index condition`, proving Index Condition Pushdown (ICP) is active.
