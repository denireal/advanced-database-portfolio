# Brief Performance Analysis

## 1. InnoDB Clustered Indexes
The database uses InnoDB, which stores table data physically sorted by the Primary Key (Clustered Index). When Query 1 joins tables using Primary Keys (like `registration_id`), MySQL performs direct pointer lookups. This eliminates secondary row-ID lookups, making Primary Key joins exceptionally fast.

## 2. Composite Indexes and Left-Most Prefix
In Portfolio 1, we added `idx_reg_offering_status (offering_id, status)`. This perfectly optimizes Query 2 because the query filters by both columns. However, due to the "Left-Most Prefix Rule", this index would not help a query that *only* filters by `status = 'REGISTERED'`, as the B-Tree is sorted by `offering_id` first.

## 3. View Materialization Bottlenecks
Query 3 reveals a performance bottleneck. Because the `v_semester_gpa` view contains aggregation (`GROUP BY`), MySQL is forced to use the `TEMPTABLE` algorithm. It writes the aggregated results to a temporary table before filtering. For a production system with 50,000 students, this would cause high CPU and I/O latency. The DBA solution is to replace the view with a physical summary table updated by triggers or scheduled events.

## 4. Cost-Based Optimizer (CBO)
MySQL's CBO uses table statistics (updated via `ANALYZE TABLE`) to estimate the cost of different execution paths. In Query 4, before the index was added, the CBO calculated that a Full Table Scan was the only option. Once the index was added, the CBO recalculated the cost and chose the Index Lookup because reading a few hundred index nodes is cheaper than reading 5,000 full data rows.
