-- A. Baseline five-table join: inspect plan, then run without EXPLAIN for results.
EXPLAIN
SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       at.session_name, at.semester_name, r.registration_status
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
JOIN academic_terms at ON co.term_id = at.term_id
ORDER BY s.matric_number
LIMIT 20;

SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       at.session_name, at.semester_name, r.registration_status
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
JOIN academic_terms at ON co.term_id = at.term_id
ORDER BY s.matric_number
LIMIT 20;

-- B. Filtered join for a real matriculation number in this dataset.
EXPLAIN
SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       at.session_name, at.semester_name, r.registration_status
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
JOIN academic_terms at ON co.term_id = at.term_id
WHERE s.matric_number = 'LP/2025/001'
ORDER BY s.matric_number
LIMIT 20;

SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       at.session_name, at.semester_name, r.registration_status
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
JOIN academic_terms at ON co.term_id = at.term_id
WHERE s.matric_number = 'LP/2025/001'
ORDER BY s.matric_number
LIMIT 20;

-- C. Grades report plan and results.
EXPLAIN
SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       g.ca_score, g.exam_score, g.total_score, g.letter_grade, g.grade_point
FROM grades g
JOIN registrations r ON g.registration_id = r.registration_id
JOIN students s ON r.student_id = s.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
ORDER BY s.matric_number;

SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       g.ca_score, g.exam_score, g.total_score, g.letter_grade, g.grade_point
FROM grades g
JOIN registrations r ON g.registration_id = r.registration_id
JOIN students s ON r.student_id = s.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
ORDER BY s.matric_number;

-- D. Filtered grades report.
EXPLAIN
SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       g.ca_score, g.exam_score, g.total_score, g.letter_grade, g.grade_point
FROM grades g
JOIN registrations r ON g.registration_id = r.registration_id
JOIN students s ON r.student_id = s.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
WHERE s.matric_number = 'LP/2025/001'
ORDER BY s.matric_number;

SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       g.ca_score, g.exam_score, g.total_score, g.letter_grade, g.grade_point
FROM grades g
JOIN registrations r ON g.registration_id = r.registration_id
JOIN students s ON r.student_id = s.student_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
WHERE s.matric_number = 'LP/2025/001'
ORDER BY s.matric_number;

-- E. Alternative join order. Recorded EXPLAIN plan was unchanged.
EXPLAIN
SELECT s.matric_number, s.first_name, s.last_name, c.course_code, c.course_title,
       g.ca_score, g.exam_score, g.total_score, g.letter_grade, g.grade_point
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN grades g ON r.registration_id = g.registration_id
JOIN course_offerings co ON r.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
WHERE s.matric_number = 'LP/2025/001'
ORDER BY s.matric_number;

-- F. Existing indexes.
SHOW INDEX FROM students;
SHOW INDEX FROM registrations;
SHOW INDEX FROM courses;
SHOW INDEX FROM grades;

-- G. Range query on the existing total-score index.
EXPLAIN
SELECT registration_id, ca_score, exam_score, total_score, letter_grade, grade_point
FROM grades
WHERE total_score >= 80
ORDER BY total_score DESC;

SELECT registration_id, ca_score, exam_score, total_score, letter_grade, grade_point
FROM grades
WHERE total_score >= 80
ORDER BY total_score DESC;

-- H. Table sizes for interpreting optimizer choices.
SELECT 'students' AS table_name, COUNT(*) AS row_count FROM students
UNION ALL SELECT 'registrations', COUNT(*) FROM registrations
UNION ALL SELECT 'course_offerings', COUNT(*) FROM course_offerings
UNION ALL SELECT 'courses', COUNT(*) FROM courses
UNION ALL SELECT 'grades', COUNT(*) FROM grades;
