# Portfolio 4: NoSQL and Advanced Data Models

## Case study
Luma Polytechnic (simulated polytechnic).

## Objective
Implement a document-oriented MongoDB model, query embedded student/course-result data, aggregate results, and demonstrate index use with MongoDB Compass Explain.

## Contents
- `data/students.json` — four student documents for import.
- `queries/mongodb-queries.js` — filters, index creation/verification, aggregation, and Explain query.
- `docs/nosql-analysis.md` — implementation and findings.
- `evidence/` — add genuine screenshots captured from your MongoDB Compass session.

## Running queries
Use the examples in `queries/mongodb-queries.js` in `mongosh`, or enter equivalent filters and aggregation stages in Compass. Compass's Filter field accepts a filter document, not the full `db.students.find(...)` command.

## Observations reported during the practical
- The collection contained four student documents.
- Filtering `registrations.letter_grade` for `A` returned Ada's document.
- Aggregation returned 4 course-result entries, average score 72, highest score 87, and lowest score 53.
- Explain showed `IXSCAN` using `matric_number_1`, followed by `FETCH`; one document and one index key were examined, and execution time was reported as 0 ms.

Re-capture and place the actual screenshots in `evidence/` before submission. The checklist is a guide, not proof that evidence files exist.

## Data limitations
Ada's two grades, Tunde's grade, and Zainab's grade match the values previously provided for this practical. Chidi's empty registrations array and the `Computer Science` programme label for each student are illustrative; verify them against the original relational database before presenting them as authoritative institutional data. Four documents are enough to demonstrate functionality, but not to benchmark production-scale performance.
