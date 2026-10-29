# NoSQL Implementation and Analysis

## 1. Aim
This demonstrates a document-oriented data model for Luma Polytechnic using MongoDB. Student details and related course results are stored together in each student document.

## 2. Document model
The `students` collection stores `student_id`, `matric_number`, names, programme, and a `registrations` array. Each embedded registration contains course code/title, continuous-assessment score, examination score, total score, letter grade, and grade point.

Embedding makes it possible to retrieve a student's details and embedded results in one document query. It is suitable when the application commonly reads a student's record together with their results.

## 3. Queries and aggregation
The practical included:
- a filter by `matric_number`;
- a nested-field filter for `registrations.letter_grade = "A"`;
- a nested-field range filter for `registrations.total_score >= 80`;
- an aggregation using `$unwind` and `$group` to calculate result count, average, highest, and lowest scores.

The reported aggregation result was four course-result entries, average total score 72, maximum 87, and minimum 53. `$unwind` excludes documents with an empty registrations array by default, so Chidi's document did not contribute to these metrics.

## 4. Index and Explain findings
An ascending index named `matric_number_1` was created on `matric_number`. Compass Explain reported an `IXSCAN` stage using this index, followed by `FETCH`. The query returned one document, examined one document, and examined one index key. The reported execution time was 0 ms.

This confirms index use for the tested lookup. With only four student documents, however, the result does not establish a meaningful performance improvement at larger scale; the timing is too small for a reliable benchmark.

## 5. Relational versus document model
The relational schema stores students, registrations, course offerings, courses, and grades in separate related tables. Retrieving a student's results requires joins across these tables.

The MongoDB model embeds registration results in a student document, simplifying reads that need the complete student record. The trade-off is potential duplication of course details across many student documents and more complex updates when shared course information changes. The relational design is more normalised, while the document model offers flexibility for data commonly accessed together.

## 6. Limitations and data quality
The collection contains four documents, so it demonstrates operations but is too small for robust performance benchmarking. Some fields in the illustrative data, including programme labels and Chidi's empty registrations array, should be validated against the original relational database before being described as authoritative.

## 7. Evidence to attach
Place genuine screenshots in `evidence/` using names such as:
- `01-database-created.png`
- `02-student-documents.png`
- `03-query-students-with-grade-A.png`
- `04-query-high-scoring-students.png`
- `05-aggregation-course-statistics.png`
- `06-matric-number-index.png`
- `07-indexed-query-explain.png`

Do not create placeholder screenshots or claim evidence that was not captured.
