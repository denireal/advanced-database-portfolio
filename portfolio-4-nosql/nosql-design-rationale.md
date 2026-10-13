# NoSQL Document-Oriented Model Rationale

## 1. Overview of the NoSQL Model
In relational databases (Portfolio 1), generating a complete student academic transcript requires executing multi-table `INNER JOIN` queries across `Student`, `Department`, `Enrollment`, and `Course` tables. 

By contrast, the document-oriented model (`student-transcript.json`) embeds all semester logs, course scores, and departmental metadata directly inside a single cohesive JSON document per student.

## 2. Advantages of the Document Model for Academic Portals
* **High Read Performance for Transcripts:** Fetching an entire student transcript requires a single indexed lookup on `matric_no`, eliminating costly multi-table join operations.
* **Schema Flexibility:** Academic structures change over time (e.g., adding elective types, project scores, or internship logs). Document models accommodate varying fields across students without requiring expensive relational schema migrations (`ALTER TABLE`).
* **Natural Data Alignment:** Hierarchical data structures (such as a student having multiple sessions, and each session having multiple courses) map directly to nested JSON arrays and objects.

## 3. Comparison: Relational vs. NoSQL in University Systems
| Feature | Relational (MySQL / 3NF) | NoSQL (MongoDB / Document) |
| :--- | :--- | :--- |
| **Data Integrity** | Strict ACID enforcement via foreign keys and constraints | Eventual consistency; relational validation handled at application level |
| **Complex Queries** | Excellent for aggregations, cross-table reporting, and joins | Excellent for rapid single-object retrieval and hierarchical reads |
| **Scalability** | Scale-up (vertical scaling) primary approach | Scale-out (horizontal sharding) native architecture |
