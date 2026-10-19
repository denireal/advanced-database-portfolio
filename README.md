# Advanced Database Systems Portfolio (MIT 8103)
**Student Name:** Denyefa Cletus Wari 
**Programme:** Master of Information Technology  
**Database Case Study:** Luma Polytechnic (Simulated Student Records & Results System)  
**Target DBMS:** MySQL 8.0+ (InnoDB)

---

## 1. Case Study Overview
**Organisation:** Luma Polytechnic (a simulated Nigerian higher education institution).  
**Nature of the System:** A centralized student records and results database supporting course registration, continuous assessment (CA) and examination scoring, GPA/CGPA computation, and transcript generation.  
**Primary Users:** Students, Lecturers, Academic Registry Staff, and Management.  
**Major Data Stored:** Departments, programmes, students, lecturers, course catalogues, academic terms, course offerings, registrations, and grades.  
**Key Operations:** Admitting students, offering courses, registering students, entering scores, computing derived grades/GPA, and generating reports.

---

## 2. Repository Structure
This repository is organised progressively to reflect the five portfolio components required for the MIT 8103 Continuous Assessment.

```text
advanced-database-portfolio/
│
├── portfolio-1-database-design/
│   ├── case-study-description.md
│   ├── ER-diagram.png
│   ├── keys-and-constraints.md
│   ├── normalization.md
│   ├── relational-schema.sql    # DDL for luma_db
│   └── seed_data.sql            # Base sample data
│
├── portfolio-2-query-optimisation/
│   ├── sql-queries.sql
│   ├── query-results.png
│   ├── execution-plans.md
│   ├── indexing-optimisation-evidence.png
│   └── brief-performance-analysis.md
│
├── portfolio-3-transactions-concurrency/  # (In Progress)
├── portfolio-4-nosql/                     # (In Progress)
├── portfolio-5-distributed-cloud/         # (In Progress)
│
└── README.md

## 3. Setup and Installation Instructions
The **MySQL 8.0.16** was used and **Git Bash** configured on my system.

### Step 1: Clone the Repository
Open **Git Bash** and run the following commands to get the code:
```bash
git clone https://github.com/denireal/advanced-database-portfolio.git
cd advanced-database-portfolio
