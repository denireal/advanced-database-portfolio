
-- ============================================================
-- MIT 8103: ADVANCED DATABASE SYSTEMS
-- PORTFOLIO 2: DATABASE QUERIES AND PERFORMANCE ANALYSIS
-- Database: sarms_db
-- ============================================================


-- ============================================================
-- STUDENT ACADEMIC PROFILE QUERY
-- Purpose:
-- Retrieve student details together with their programme
-- and the department responsible for the programme.
-- ============================================================

SELECT
    s.student_id,
    s.matric_no,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.gender,
    s.email,
    s.phone,
    s.admission_year,
    s.academic_level,
    s.status AS student_status,
    p.programme_code,
    p.programme_name,
    p.award_type,
    d.department_code,
    d.department_name
FROM students AS s
INNER JOIN programmes AS p
    ON s.programme_id = p.programme_id
INNER JOIN departments AS d
    ON p.department_id = d.department_id
ORDER BY
    s.matric_no;


-- ============================================================
-- COURSE REGISTRATION AND TEACHING ASSIGNMENT QUERY
-- Purpose:
-- Retrieve course registrations alongside student details,
-- course information, assigned lecturers, semester, and
-- academic session.
-- ============================================================

SELECT
    cr.registration_id,
    s.matric_no,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.academic_level,
    c.course_code,
    c.course_title,
    c.credit_unit,
    CONCAT(l.first_name, ' ', l.last_name) AS lecturer_name,
    sem.semester_name,
    a.session_name,
    cr.registration_date,
    cr.status AS registration_status,
    co.status AS offering_status
FROM course_registrations AS cr
INNER JOIN students AS s
    ON cr.student_id = s.student_id
INNER JOIN course_offerings AS co
    ON cr.offering_id = co.offering_id
INNER JOIN courses AS c
    ON co.course_id = c.course_id
INNER JOIN lecturers AS l
    ON co.lecturer_id = l.lecturer_id
INNER JOIN semesters AS sem
    ON co.semester_id = sem.semester_id
INNER JOIN academic_sessions AS a
    ON sem.session_id = a.session_id
ORDER BY
    a.session_name DESC,
    sem.semester_name,
    s.matric_no,
    c.course_code;


-- ============================================================
-- STUDENT RESULTS AND GRADE ANALYSIS QUERY
-- Purpose:
-- Retrieve students' course results, assessment scores,
-- grades, grade points, and result approval status.
-- ============================================================

SELECT
    s.matric_no,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.academic_level,
    c.course_code,
    c.course_title,
    c.credit_unit,
    sem.semester_name,
    a.session_name,
    r.ca_score,
    r.exam_score,
    r.total_score,
    r.grade,
    r.grade_point,
    r.remark,
    r.result_status
FROM results AS r
INNER JOIN course_registrations AS cr
    ON r.registration_id = cr.registration_id
INNER JOIN students AS s
    ON cr.student_id = s.student_id
INNER JOIN course_offerings AS co
    ON cr.offering_id = co.offering_id
INNER JOIN courses AS c
    ON co.course_id = c.course_id
INNER JOIN semesters AS sem
    ON co.semester_id = sem.semester_id
INNER JOIN academic_sessions AS a
    ON sem.session_id = a.session_id
ORDER BY
    a.session_name DESC,
    sem.semester_name,
    s.matric_no,
    c.course_code;
