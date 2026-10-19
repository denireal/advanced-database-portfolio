# Luma Polytechnic Database: Performance Analysis & Optimization Guide

This repository contains database performance diagnostics, execution plan evaluations, and indexing strategies designed for the **Luma Polytechnic Database** (Portfolio Project). 

---

## Executive Summary: Key Performance Findings

### 1. InnoDB Storage Engine and Clustered Indexes
The database utilizes the **InnoDB storage engine**, which organizes physical data using a **Clustered Index** based on the Primary Key. 
* **Impact on Joins:** When joining `registrations` to `grades` via `registration_id`, the database performs a direct pointer lookup to the physical row location. This eliminates secondary "row ID" lookups required by heap-organized tables (such as MyISAM or PostgreSQL), making Primary Key joins exceptionally fast.
* **Foreign Key Lookups:** Secondary indexes on Foreign Keys (e.g., `fk_reg_student`) store the Primary Key value in their leaf nodes, allowing the optimizer to perform **Index-Only Scans** for join conditions before fetching actual row data.

### 2. Composite Indexes and the Left-Most Prefix Rule
The composite index `idx_reg_offering_status (offering_id, status)` implemented on the `registrations` table handles specific query patterns:
* **Why it works for Query 2:** Query 2 joins on `offering_id` and filters on `status = 'REGISTERED'`. Because the index is ordered first by `offering_id` and then by `status`, the B-Tree satisfies both conditions in a single index traversal.
* **The Left-Most Prefix Limitation:** If a query executes `SELECT * FROM registrations WHERE status = 'REGISTERED'`, the optimizer **cannot** use this index efficiently, resulting in a Full Index Scan (often slower than a Full Table Scan). Due to low cardinality (only 2 distinct values: `REGISTERED`, `DROPPED`), a separate single-column index on `status` would likely be bypassed by the Cost-Based Optimizer (CBO) anyway.

### 3. View Materialization vs. Merging (`v_semester_gpa`)
The `v_semester_gpa` view represents a significant performance bottleneck:
* **The Problem:** Because the view definition incorporates `GROUP BY student_id, term_id`, MySQL's optimizer cannot merge the view's SQL into the outer query. It must execute the view, write aggregated results to an internal temporary table (disk-based if exceeding `tmp_table_size`), and query that temporary table.
* **The DBA Solution:** For high-concurrency production environments, relying on real-time view evaluation causes CPU spikes. The recommended architecture implements a **Summary Table** (`student_gpa_summary`) maintained via an `AFTER INSERT/UPDATE` trigger on the `grades` table (or a scheduled Event), trading minimal write latency for high-speed read performance.

### 4. Cost-Based Optimizer (CBO) and Statistics
MySQL 8.0 relies heavily on persistent InnoDB statistics (`mysql.innodb_index_stats`):
* **Cardinality:** For tables like `grade_scale` (9 rows), the CBO recognizes small dataset sizes and selects it as a driving table when filtered appropriately, as scanning 9 rows is vastly cheaper than scanning large student tables.
* **Filesort Operations:** Queries incorporating `ORDER BY total_credit_units_taught DESC` involve derived, aggregated values that do not exist in any index. The `EXPLAIN` output displays `Using filesort`, allocating a `sort_buffer_size` in memory. Result sets exceeding this buffer spill to disk and introduce severe I/O latency. Mitigate this by applying strict limits (e.g., `LIMIT 50`) or pre-calculating metrics in summary tables.

---

## File Structure
* `brief-performance-analysis.md` — Detailed technical breakdown of indexing, views, and CBO behavior.
* `schema.sql` — Base table schemas and constraints.
* `queries.sql` — Optimized execution scripts and JOIN patterns.
