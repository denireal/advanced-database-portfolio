-- =====================================================================
-- MIT 8103 - Portfolio 2: Query Processing and Optimisation
-- =====================================================================
USE luma_db;

-- QUERY 1: Full Academic Transcript (Heavy JOIN Operation)
-- Tests Nested Loop Joins using Primary and Foreign Key indexes.
SELECT s.matric_no, s.full_name, c.course_code, c.title, g.total_score, gs.grade_letter
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN course_offerings o ON r.offering_id = o.offering_id
JOIN courses c ON o.course_id = c.course_id
JOIN grades g ON r.registration_id = g.registration_id
JOIN grade_scale gs ON g.total_score BETWEEN gs.min_score AND gs.max_score
WHERE s.matric_no = 'LP/26/CSC/0001' AND r.status = 'REGISTERED';

-- QUERY 2: Class List & Seat Availability (Aggregation & Composite Index)
-- Tests the idx_reg_offering_status composite index created in Portfolio 1.
SELECT c.course_code, c.title, o.capacity, COUNT(r.registration_id) AS registered
FROM course_offerings o
JOIN courses c ON o.course_id = c.course_id
JOIN registrations r ON o.offering_id = r.offering_id AND r.status = 'REGISTERED'
GROUP BY o.offering_id, c.course_code, c.title, o.capacity;

-- QUERY 3: Students at Academic Risk (View Resolution)
-- Tests how the optimizer handles the v_semester_gpa view.
SELECT student_id, matric_no, full_name, gpa 
FROM v_semester_gpa 
WHERE gpa < 2.00;

-- QUERY 4: Index Optimization Test (Before & After)
-- Intentionally suboptimal. Forces a Full Table Scan before indexing.
SELECT student_id, matric_no, full_name 
FROM students 
WHERE entry_year = 2026 AND status = 'ACTIVE';
