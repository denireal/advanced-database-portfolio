
***

### `brief-performance-analysis.md`

```markdown
# Brief Performance Analysis: Luma Polytechnic Database

## 1. InnoDB Storage Engine and Clustered Indexes
The Luma Polytechnic database utilizes the InnoDB storage engine, which organizes data physically using a **Clustered Index** based on the Primary Key. 
- **Impact on Joins:** When Query 1 joins `registrations` to `grades` via `registration_id`, the database performs a direct pointer lookup to the physical row location. This eliminates the need for a secondary "row ID" lookup required by heap-organized tables (like MyISAM or PostgreSQL), making Primary Key joins exceptionally fast.
- **Foreign Key Lookups:** Secondary indexes on Foreign Keys (e.g., `fk_reg_student`) store the Primary Key value in their leaf nodes. This allows the optimizer to perform Index-Only Scans for the join condition before fetching the actual row data.

## 2. Composite Indexes and the Left-Most Prefix Rule
In Portfolio 1, we implemented `idx_reg_offering_status (offering_id, status)` on the `registrations` table. 
- **Why it works for Query 2:** Query 2 joins on `offering_id` and filters on `status = 'REGISTERED'`. Because the index is ordered first by `offering_id` and then by `status`, the B-Tree can satisfy both conditions in a single index traversal. 
- **The Left-Most Prefix Limitation:** If a user queries `SELECT * FROM registrations WHERE status = 'REGISTERED'`, the optimizer **cannot** use this index efficiently. It would require a Full Index Scan, which is often slower than a Full Table Scan. To optimize status-only queries, a separate single-column index on `status` would be required, though its low cardinality (only 2 distinct values: REGISTERED, DROPPED) might cause the CBO to ignore it anyway.

## 3. View Materialization vs. Merging
The `v_semester_gpa` view is a critical performance bottleneck. 
- **The Problem:** Because the view definition includes `GROUP BY student_id, term_id`, MySQL's optimizer cannot merge the view's SQL into the outer query. It must execute the view, write the aggregated results to an internal temporary table (on disk if it exceeds `tmp_table_size`), and then query that temporary table. 
- **The DBA Solution:** In a production environment with tens of thousands of students, relying on this view for real-time dashboards will cause CPU spikes. The optimal solution is to implement a **Summary Table** (e.g., `student_gpa_summary`) that is updated via an `AFTER INSERT/UPDATE` trigger on the `grades` table, or via a scheduled Event. This trades a small amount of write latency for massive read performance gains.

## 4. Cost-Based Optimizer (CBO) and Statistics
MySQL 8.0 uses a Cost-Based Optimizer that relies on InnoDB persistent statistics (`mysql.innodb_index_stats`). 
- **Cardinality:** For the `grade_scale` table, the CBO recognizes it has only 9 rows. In Query 1, it will likely use this table as a driving table if the query were rewritten to filter by `grade_letter = 'F'`, because scanning 9 rows is cheaper than scanning 100,000 students.
- **Filesort Operations:** Query 4 uses `ORDER BY total_credit_units_taught DESC`. Because `total_credit_units_taught` is an aggregated, derived value, it does not exist in any index. The `EXPLAIN` output will show `Using filesort`. The database must allocate a sort buffer (`sort_buffer_size`) in memory to sort the final result set. If the result set exceeds the buffer, it spills to disk, causing severe I/O latency. Limiting the result set (e.g., `LIMIT 50`) or pre-calculating workloads in a summary table mitigates this.
