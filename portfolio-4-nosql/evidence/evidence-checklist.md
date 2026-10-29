# Portfolio 4 Evidence Checklist
- [ ] `01-database-created.png` — `luma_nosql` database and `students` collection.
- [ ] `02-student-documents.png` — all four student documents visible or count showing four.
- [ ] `03-query-students-with-grade-A.png` — filter `{"registrations.letter_grade":"A"}` and Ada result.
- [ ] `04-query-high-scoring-students.png` — filter `{"registrations.total_score":{"$gte":80}}` and result.
- [ ] `05-aggregation-course-statistics.png` — aggregation output: 4 results, average 72, max 87, min 53.
- [ ] `06-matric-number-index.png` — index list showing `matric_number_1`.
- [ ] `07-indexed-query-explain.png` — Explain showing `IXSCAN`, `FETCH`, and execution statistics.
