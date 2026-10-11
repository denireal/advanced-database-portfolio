-- =====================================================================
-- 04_verification_queries.sql : proves keys and constraints are enforced
-- Statements marked "EXPECT ERROR" MUST fail;
-- =====================================================================
USE sarms_db;

SELECT '--- A. Generated columns derive grade from raw scores ---' AS test;
SELECT registration_id, ca_score, exam_score, total_score, grade, grade_point
FROM results ORDER BY registration_id;

SELECT '--- B. UNIQUE: duplicate matric_no (EXPECT ERROR 1062) ---' AS test;
INSERT INTO students (programme_id, matric_no, first_name, last_name, gender,
                      date_of_birth, email, admission_year, academic_level)
VALUES (1, 'FPE/ND/CST/26/001', 'Dup', 'Licate', 'Male', '1990-01-01',
        'dup@stu.example', 2026, 100);

SELECT '--- C. UNIQUE: same student registers twice for one offering (EXPECT ERROR 1062) ---' AS test;
INSERT INTO course_registrations (student_id, offering_id) VALUES (1, 1);

SELECT '--- D. FK: student with non-existent programme (EXPECT ERROR 1452) ---' AS test;
INSERT INTO students (programme_id, matric_no, first_name, last_name, gender,
                      date_of_birth, email, admission_year, academic_level)
VALUES (999, 'XXX/26/999', 'No', 'Programme', 'Male', '1990-01-01',
        'noprog@stu.example', 2026, 100);

SELECT '--- E. CHECK: exam_score above 60 (EXPECT ERROR 4025 MariaDB / 3819 MySQL) ---' AS test;
INSERT INTO results (registration_id, ca_score, exam_score, entered_by)
VALUES (4, 20.00, 75.00, 3);

SELECT '--- F. CHECK: credit_unit outside 1-6 (EXPECT ERROR) ---' AS test;
INSERT INTO courses (department_id, course_code, course_title, credit_unit, level, semester_type)
VALUES (1, 'CSC999', 'Bad Credit Course', 9, 100, 'First');

SELECT '--- G. CHECK: session end_date before start_date (EXPECT ERROR) ---' AS test;
INSERT INTO academic_sessions (session_name, start_date, end_date)
VALUES ('2030/2031', '2031-08-31', '2030-09-01');

SELECT '--- H. CHECK: Student user without student_id (EXPECT ERROR) ---' AS test;
INSERT INTO users (username, password_hash, role)
VALUES ('orphan.student', 'hash', 'Student');

SELECT '--- I. UNIQUE: a second result for the same registration (EXPECT ERROR 1062) ---' AS test;
INSERT INTO results (registration_id, ca_score, exam_score, entered_by)
VALUES (1, 10.00, 10.00, 3);

SELECT '--- J. RESTRICT: delete a department that still has dependent rows (EXPECT ERROR 1451) ---' AS test;
DELETE FROM departments WHERE department_id = 1;

SELECT '--- K. NOT NULL: result without entered_by (EXPECT ERROR) ---' AS test;
INSERT INTO results (registration_id, ca_score, exam_score)
VALUES (4, 20.00, 20.00);

SELECT '--- L. Valid insert succeeds and grade is derived (EXPECT SUCCESS) ---' AS test;
INSERT INTO results (registration_id, ca_score, exam_score, entered_by)
VALUES (4, 38.00, 52.00, 3);
SELECT registration_id, total_score, grade, grade_point
FROM results WHERE registration_id = 4;

SELECT '--- M. CHECK: academic_level 700 is not an ND/HND level (EXPECT ERROR) ---' AS test;
INSERT INTO students (programme_id, matric_no, first_name, last_name, gender,
                      date_of_birth, email, admission_year, academic_level)
VALUES (1, 'FPE/ND/CST/26/099', 'Bad', 'Level', 'Male', '2006-01-01',
        'badlevel@stu.fpe.example', 2026, 700);

SELECT '--- N. Transcript-style join (all FKs resolve) ---' AS test;
SELECT s.matric_no, CONCAT(s.first_name,' ',s.last_name) AS student,
       c.course_code, c.credit_unit, r.total_score, r.grade, r.grade_point
FROM results r
JOIN course_registrations cr ON cr.registration_id = r.registration_id
JOIN students s              ON s.student_id       = cr.student_id
JOIN course_offerings o      ON o.offering_id      = cr.offering_id
JOIN courses c               ON c.course_id        = o.course_id
ORDER BY s.matric_no, c.course_code;
