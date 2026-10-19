-- =====================================================================
-- MIT 8103 - Portfolio 2: Query Processing and Optimisation
-- =====================================================================
USE luma_db;

-- QUERY 1: Full Academic Transcript Generation (Heavy Join Operation)
-- Objective: Retrieve a complete transcript for a specific student.
-- Optimization Focus: Demonstrates Nested Loop Joins using Primary and Foreign Key indexes.
SELECT 
    s.matric_no, 
    s.full_name, 
    p.name AS programme_name, 
    t.session_label, 
    t.semester, 
    c.course_code, 
    c.title, 
    c.credit_units, 
    g.total_score, 
    gs.grade_letter, 
    gs.grade_point
FROM students s
JOIN programmes p ON s.programme_id = p.programme_id
JOIN registrations r ON s.student_id = r.student_id
JOIN course_offerings o ON r.offering_id = o.offering_id
JOIN courses c ON o.course_id = c.course_id
JOIN academic_terms t ON o.term_id = t.term_id
JOIN grades g ON r.registration_id = g.registration_id
JOIN grade_scale gs ON g.total_score BETWEEN gs.min_score AND gs.max_score
WHERE s.matric_no = 'LP/26/CSC/0001' 
  AND r.status = 'REGISTERED'
ORDER BY t.session_label, t.semester, c.course_code;

-- QUERY 2: Class List and Seat Availability (Composite Index Utilization)
-- Objective: Calculate registered vs available seats for the current term.
-- Optimization Focus: Leverages the composite index idx_reg_offering_status (offering_id, status).
SELECT 
    c.course_code, 
    c.title, 
    l.full_name AS lecturer, 
    o.capacity, 
    COUNT(r.registration_id) AS registered_count, 
    (o.capacity - COUNT(r.registration_id)) AS seats_available
FROM course_offerings o
JOIN courses c ON o.course_id = c.course_id
JOIN lecturers l ON o.lecturer_id = l.lecturer_id
JOIN registrations r ON o.offering_id = r.offering_id AND r.status = 'REGISTERED'
JOIN academic_terms t ON o.term_id = t.term_id
WHERE t.is_current = TRUE
GROUP BY o.offering_id, c.course_code, c.title, l.full_name, o.capacity;

-- QUERY 3: Students at Academic Risk (View Resolution & Derived Tables)
-- Objective: Identify students with a GPA < 2.0 in the current term.
-- Optimization Focus: Analyzes how the Cost-Based Optimizer (CBO) resolves the v_semester_gpa view.
SELECT 
    sg.student_id, 
    sg.matric_no, 
    sg.full_name, 
    sg.gpa
FROM v_semester_gpa sg
JOIN academic_terms t ON sg.term_id = t.term_id
WHERE t.is_current = TRUE AND sg.gpa < 2.00
ORDER BY sg.gpa ASC;

-- QUERY 4: Lecturer Workload Report (Aggregation & Filesort)
-- Objective: Calculate total credit units taught per lecturer in the current term.
-- Optimization Focus: Evaluates GROUP BY and ORDER BY operations on secondary indexes.
SELECT 
    l.staff_no, 
    l.full_name, 
    l.academic_rank,
    SUM(c.credit_units) AS total_credit_units_taught,
    COUNT(DISTINCT o.offering_id) AS number_of_courses
FROM lecturers l
JOIN course_offerings o ON l.lecturer_id = o.lecturer_id
JOIN courses c ON o.course_id = c.course_id
JOIN academic_terms t ON o.term_id = t.term_id
WHERE t.is_current = TRUE
GROUP BY l.lecturer_id, l.staff_no, l.full_name, l.academic_rank
ORDER BY total_credit_units_taught DESC;

-- QUERY 5: Intentional Suboptimal Query (For Indexing Optimization Evidence)
-- Objective: Find all active students who entered in a specific year.
-- Baseline: Forces a Full Table Scan on the students table.
-- Optimization: We will create an index to fix this in the execution plan analysis.
SELECT student_id, matric_no, full_name, email 
FROM students 
WHERE entry_year = 2026 AND status = 'ACTIVE';
