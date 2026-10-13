# MIT 8103 Advanced Database Systems Portfolio
## Academic Portal Database Infrastructure & Architecture

**Institution:** Southern Technical University  
**Module:** MIT 8103 Advanced Database Systems  
**Project Type:** Enterprise Database Design and Architecture  
**Repository:** Academic Portfolio Submission  

---

## 📘 Executive Overview

This repository contains the complete five-portfolio submission for **MIT 8103 Advanced Database Systems**. The project presents the design, optimisation, security, scalability, and resilience strategies for a comprehensive enterprise-grade Academic Portal developed for Southern Technical University.

The solution integrates traditional relational database systems with modern NoSQL data models and distributed cloud database architectures, providing a realistic simulation of high-concurrency academic workloads. The portfolio demonstrates industry-standard approaches to database design, performance tuning, transaction management, data modelling, fault tolerance, and disaster recovery.

---

## 🎯 Learning Outcomes

This project demonstrates the ability to:
* Design and implement fully normalised relational databases (3NF)
* Enforce data integrity through primary keys, foreign keys, and constraints
* Optimise complex SQL queries using indexing and execution-plan analysis
* Implement transaction management and concurrency control mechanisms
* Model semi-structured and unstructured data using NoSQL technologies
* Design scalable distributed database architectures
* Apply replication, sharding, and consensus mechanisms
* Develop disaster recovery and business continuity strategies
* Evaluate trade-offs between consistency, availability, and partition tolerance

---

## 🛠 Technologies Used

### Relational Database Technologies
* MySQL 8.0 / phpMyAdmin
* SQL (DDL, DML, DCL, TCL)

### Query Optimisation & Performance
* B-Tree Indexes
* `EXPLAIN` Execution Plans
* Aggregation and Join Optimisation

### NoSQL Technologies
* MySQL JSON Documents
* Redis (Key-Value Storage)
* Cassandra (Column-Oriented Storage)
* Neo4j (Graph Database)

### Distributed Database Concepts
* Replica Sets
* Horizontal Sharding
* Raft Consensus
* Point-in-Time Recovery (PITR)
* Cloud-Based High Availability Architectures

### Development & Version Control
* Git / GitHub / Markdown Documentation

---

## 📂 Repository Structure

```text
advanced-database-portfolio/
│
├── portfolio-1-database-design/
│   ├── schema-definition.sql
│   ├── erd-diagram.png
│   └── seed-data.sql
│
├── portfolio-2-query-optimisation/
│   ├── complex-queries.sql
│   ├── explain-analysis.md
│   └── screenshots/
│
├── portfolio-3-transactions-concurrency/
│   ├── acid-transactions.sql
│   ├── concurrency-locking.sql
│   └── screenshots/
│
├── portfolio-4-nosql/
│   ├── nosql-model-design.md
│   ├── advanced-data-models.json
│   ├── implementation-evidence.md
│   └── screenshots/
│
├── portfolio-5-distributed-cloud/
│   ├── distributed-architecture.md
│   ├── disaster-recovery-strategy.md
│   └── deployment-evidence.md
│
└── README.md
```

---

## 📑 Portfolio Modules

### Portfolio 1: Relational Database Design
* **Objective:** Develop a robust and scalable relational database schema for the Academic Portal.
* **Key Features:** Entity-Relationship Modelling, Third Normal Form (3NF) Design, Referential Integrity Enforcement, Primary and Foreign Key Relationships, Domain and Business Rule Constraints.
* **Deliverables:** Database Schema Definition, Entity-Relationship Diagram (ERD), Sample Data Population Scripts.

### Portfolio 2: Query Optimisation & Indexing
* **Objective:** Improve query performance and database efficiency for analytical and operational workloads.
* **Key Features:** Complex Multi-Table Joins, Aggregation Queries, Strategic Index Design, Execution Plan Analysis, Query Cost Reduction.
* **Deliverables:** Optimised SQL Queries, `EXPLAIN` Reports, Performance Benchmark Evidence.

### Portfolio 3: Transactions & Concurrency Control
* **Objective:** Maintain consistency and reliability under concurrent user activity.
* **Key Features:** ACID Compliance, `COMMIT` and `ROLLBACK` Processing, Isolation Level Testing, Deadlock Prevention, Pessimistic Locking Techniques.
* **Deliverables:** Transaction Management Scripts, Concurrency Control Examples, Deadlock Handling Demonstrations.

### Portfolio 4: NoSQL & Advanced Data Models
* **Objective:** Extend the Academic Portal to support flexible and semi-structured data requirements.
* **Key Features:** Document-Oriented Data Models, JSON Storage and Retrieval, Key-Value Data Structures, Column-Family Models, Graph Database Relationships.
* **Technologies Demonstrated:** MySQL JSON, Redis, Cassandra, Neo4j.
* **Deliverables:** NoSQL Schema Designs, Multi-Model Data Examples, Implementation Evidence and Screenshots.

### Portfolio 5: Distributed & Cloud Databases
* **Objective:** Design a highly available and fault-tolerant distributed database environment.
* **Key Features:** Replication Strategies, Horizontal Sharding, Consensus Mechanisms, CAP Theorem Analysis, Disaster Recovery Planning.
* **Deliverables:** Distributed Architecture Design, Cloud Deployment Strategies, Recovery and Backup Procedures.

---

## 🏗 System Architecture

The Academic Portal architecture consists of four primary layers:
1. **Data Management Layer:** MySQL relational database, enforced integrity constraints, transaction processing.
2. **Advanced Data Layer:** JSON document storage, NoSQL integration, multi-model database support.
3. **Distributed Services Layer:** Replica sets, sharded clusters, fault-tolerant communication.
4. **Recovery & Continuity Layer:** Automated backups, Point-in-Time Recovery (PITR), disaster recovery failover procedures.

```text
Users
  │
  ▼
Academic Portal Application
  │
  ├── Relational Database Layer (MySQL)
  │
  ├── NoSQL Services Layer
  │     ├── Redis
  │     ├── Cassandra
  │     └── Neo4j
  │
  └── Distributed Cloud Layer
        ├── Replication
        ├── Sharding
        └── Disaster Recovery
```

---

## ⚙️ Getting Started

### Prerequisites
* MySQL 8.0+
* phpMyAdmin / pgAdmin
* Git
* Modern Web Browser

### Installation
Clone the repository:
```bash
git clone https://github.com/denireal/advanced-database-portfolio.git
cd advanced-database-portfolio
```

---

## 🚀 Running the Portfolio Components

* **Relational Database Setup:** Execute `schema-definition.sql` followed by `seed-data.sql` in `portfolio-1-database-design/`.
* **Query Optimisation:** Run `complex-queries.sql` and review `explain-analysis.md` in `portfolio-2-query-optimisation/`.
* **Transaction & Concurrency Testing:** Run `acid-transactions.sql` and `concurrency-locking.sql` in `portfolio-3-transactions-concurrency/`.
* **NoSQL Verification:** Execute JSON insertion and retrieval queries from `implementation-evidence.md` in `portfolio-4-nosql/`.
* **Distributed Architecture Review:** Review `distributed-architecture.md`, `disaster-recovery-strategy.md`, and `deployment-evidence.md` in `portfolio-5-distributed-cloud/`.

---

## 📊 Key Concepts Demonstrated

| Area | Topics Covered |
| :--- | :--- |
| **Database Design** | ERD, 3NF, Referential Integrity |
| **SQL Development** | DDL, DML, TCL |
| **Performance Tuning** | Indexing, Query Optimisation |
| **Transaction Processing** | ACID, Concurrency Control |
| **NoSQL Systems** | Document, KV, Column, Graph |
| **Distributed Databases** | Replication, Sharding |
| **Resilience** | Backup, Recovery, Fault Tolerance |
| **Cloud Computing** | Scalable Database Architectures |

---

## 📚 Academic Context

This repository was developed as part of the MIT 8103 Advanced Database Systems module. The project applies theoretical database concepts to a realistic enterprise scenario, bridging academic study with modern industry practices.

---

## 📧 Contact & Links

* **Email:** d.wari4944@miva.edu.ng  
* **Project Repository:** [Advanced Database Systems Portfolio](https://github.com/denireal/advanced-database-portfolio)

---

## 📜 Disclaimer

*This repository is part of a conceptual academic exercise.*  
Southern Technical University is a fictional institution created solely for educational and illustrative purposes. Any resemblance to real institutions, organisations, systems, or projects is purely coincidental. The contents are intended to demonstrate database design principles and advanced database management techniques for academic assessment purposes only.

---
*© 2026 Southern Technical University — MIT 8103 Advanced Database Systems Project*
