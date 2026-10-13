Advanced Database Systems Portfolio (MIT 8103)
Institution: Southern Technical University  
Project: Academic Portal Database Infrastructure & Architecture
---
Executive Overview
This repository contains the complete five-portfolio submission for MIT 8103 Advanced Database Systems. The project designs, optimizes, secures, and scales a comprehensive enterprise-grade Academic Portal for Southern Technical University.
The architecture bridges traditional relational database integrity (MySQL / phpMyAdmin) with flexible document-oriented NoSQL schemas and distributed cloud fault tolerance, simulating real-world workloads under high concurrency.
---
Repository Structure & Table of Contents
```text
advanced-database-portfolio/
│
├── portfolio-1-database-design/
│   ├── schema-definition.sql       # 3NF Normalized relational DDL scripts
│   ├── erd-diagram.png             # Entity-Relationship Diagram
│   └── seed-data.sql               # Initial test data (Students, Depts, Courses)
│
├── portfolio-2-query-optimisation/
│   ├── complex-queries.sql         # Multi-table joins and aggregation queries
│   ├── explain-analysis.md         # Execution plan and index performance reports
│   └── screenshots/                # Toad / phpMyAdmin query performance evidence
│
├── portfolio-3-transactions-concurrency/
│   ├── acid-transactions.sql       # Isolation levels, COMMIT, and ROLLBACK scripts
│   ├── concurrency-locking.sql     # SELECT ... FOR UPDATE pessimistic locking
│   └── screenshots/                # Evidence of deadlock handling & constraint interception
│
├── portfolio-4-nosql/
│   ├── nosql-model-design.md       # Document model schema specification
│   ├── advanced-data-models.json   # Multi-model examples (Document, KV, Column, Graph)
│   ├── implementation-evidence.md  # MySQL JSON implementation queries
│   └── screenshots/                # nosql-query-execution.png
│
├── portfolio-5-distributed-cloud/
│   ├── distributed-architecture.md # Replication sets, Raft consensus, and Sharding
│   ├── disaster-recovery-strategy.md # RPO/RTO metrics and PITR backup protocols
│   └── deployment-evidence.md      # Cloud topology & cluster verification logs
│
└── README.md                       # Master repository documentation
```
---
Summary of Portfolio Modules
1. Relational Database Design (`portfolio-1-database-design/`)
Core Focus: Establishing structural integrity, domain constraints, and foreign key relationships.
Normality: Fully normalized to Third Normal Form (3NF) to eliminate update anomalies across student registrations, academic departments, and grade records.
2. Query Optimization & Indexing (`portfolio-2-query-optimisation/`)
Core Focus: Performance tuning for complex aggregation reports and transcript searches.
Techniques: B-tree index creation on high-cardinality foreign keys and lookup attributes (`matric_no`, `dept_id`), evaluated via `EXPLAIN` execution plans.
3. Transactions & Concurrency Control (`portfolio-3-transactions-concurrency/`)
Core Focus: Enforcing ACID properties under heavy concurrent user traffic.
Techniques: Explicit transaction boundaries (`START TRANSACTION`, `COMMIT`, `ROLLBACK`), isolation level configuration (`REPEATABLE READ`), and pessimistic row-level locking (`FOR UPDATE`) to prevent race conditions during course allocation.
4. NoSQL & Advanced Data Models (`portfolio-4-nosql/`)
Core Focus: Handling semi-structured academic transcripts and multi-model paradigms.
Techniques: Utilizing MySQL's native `JSON` document data type for denormalized student transcripts, alongside architectural designs for Redis key-value session caches, Cassandra audit logs, and Neo4j curriculum graph models.
5. Distributed & Cloud Databases (`portfolio-5-distributed-cloud/`)
Core Focus: High availability, horizontal scaling, and disaster recovery.
Techniques: Replica set topologies with automatic failover, hashed `matric_no` sharding keys, CAP theorem strategic balancing (CP for grades, AP for portals), and stringent Recovery Point/Time Objectives ($\text{RPO} < 5\text{s}$, $\text{RTO} < 2\text{min}$).
---
Running the Scripts
Relational Setup: Import `portfolio-1-database-design/schema-definition.sql` and `seed-data.sql` into your MySQL / phpMyAdmin environment.
Optimization & Concurrency: Execute scripts in Portfolios 2 and 3 sequentially to test query performance and transaction safety controls.
NoSQL JSON Verification: Run the JSON insertion scripts in Portfolio 4 to validate document storage and native extraction operators.
---
© 2026 Southern Technical University — MIT 8103 Advanced Database Systems Project
