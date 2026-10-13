# Advanced Database Systems Portfolio (MIT 8103)

**Institution:** Southern Technical University  
**Project:** Academic Portal Database Infrastructure & Architecture  

---

## 📘 Executive Overview
This repository contains the complete five-portfolio submission for **MIT 8103 Advanced Database Systems**.  
The project designs, optimizes, secures, and scales a comprehensive enterprise-grade **Academic Portal** for Southern Technical University.

The architecture bridges traditional **relational database integrity** (MySQL / phpMyAdmin) with flexible **document-oriented NoSQL schemas** and **distributed cloud fault tolerance**, simulating real-world workloads under high concurrency.

---

## 📂 Repository Structure & Table of Contents
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
│   └── screenshots/                # Query performance evidence
│
├── portfolio-3-transactions-concurrency/
│   ├── acid-transactions.sql       # Isolation levels, COMMIT, and ROLLBACK scripts
│   ├── concurrency-locking.sql     # Pessimistic locking with SELECT ... FOR UPDATE
│   └── screenshots/                # Deadlock handling & constraint interception
│
├── portfolio-4-nosql/
│   ├── nosql-model-design.md       # Document model schema specification
│   ├── advanced-data-models.json   # Multi-model examples (Document, KV, Column, Graph)
│   ├── implementation-evidence.md  # MySQL JSON implementation queries
│   └── screenshots/                # NoSQL query execution evidence
│
├── portfolio-5-distributed-cloud/
│   ├── distributed-architecture.md # Replication sets, Raft consensus, and Sharding
│   ├── disaster-recovery-strategy.md # RPO/RTO metrics and PITR backup protocols
│   └── deployment-evidence.md      # Cloud topology & cluster verification logs
│
└── README.md                       # Master repository documentation

## 📑 Summary of Portfolio Modules

### **[Relational Database Design](ca://s?q=Relational_Database_Design_in_portfolio)**
- **Focus:** Structural integrity, domain constraints, foreign key relationships  
- **Normalization:** Fully normalized to **Third Normal Form (3NF)**  

### **[Query Optimization & Indexing](ca://s?q=Query_Optimization_and_Indexing_in_portfolio)**
- **Focus:** Performance tuning for aggregation reports and transcript searches  
- **Techniques:** B-tree indexes, `EXPLAIN` execution plan analysis  

### **[Transactions & Concurrency Control](ca://s?q=Transactions_and_Concurrency_Control_in_portfolio)**
- **Focus:** Enforcing **ACID properties** under concurrent traffic  
- **Techniques:** Transaction boundaries, isolation levels, pessimistic row-level locking  

### **[NoSQL & Advanced Data Models](ca://s?q=NoSQL_and_Advanced_Data_Models_in_portfolio)**
- **Focus:** Semi-structured transcripts and multi-model paradigms  
- **Techniques:** MySQL JSON, Redis KV caches, Cassandra audit logs, Neo4j curriculum graphs  

### **[Distributed & Cloud Databases](ca://s?q=Distributed_and_Cloud_Databases_in_portfolio)**
- **Focus:** High availability, scaling, disaster recovery  
- **Techniques:** Replica sets, sharding, CAP theorem balancing, RPO/RTO strategies  

---

## ⚙️ Running the Scripts
- **Relational Setup:** Import `schema-definition.sql` and `seed-data.sql` into MySQL / phpMyAdmin.  
- **Optimization & Concurrency:** Execute scripts in Portfolios 2 and 3 sequentially to test query performance and transaction safety.  
- **NoSQL JSON Verification:** Run JSON insertion scripts in Portfolio 4 to validate document storage and extraction operators.  

---

## 📧 Contact
Maintainer: Southern Technical University Academic Systems Team  
Email: your.email@example.com  
Project Link: [GitHub Repository](ca://s?q=Advanced_Database_Systems_Portfolio_GitHub)

##📜 Disclaimer
This repository is part of a conceptual academic exercise.
Southern Technical University is a fictional institution, created solely for illustrative and educational purposes.
No affiliation with any real-world university or organization is implied.
