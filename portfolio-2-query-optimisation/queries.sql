USE southern_tech_university_db;

-- -------------------------------------------------------------
-- QUERY 1: Student Academic Profile & Departmental Mapping
-- Joins Students, Departments, and calculates total registered courses
-- -------------------------------------------------------------
SELECT 
    s.matric_no,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    d.dept_name,
    s.admission_year,
    COUNT(e.course_id) AS total_courses_enrolled
FROM Student s
LEFT JOIN Department d ON s.dept_id = d.dept_id
LEFT JOIN Enrollment e ON s.student_id = e.student_id
GROUP BY s.student_id, s.matric_no, s.first_name, s.last_name, s.email, d.dept_name, s.admission_year;


-- -------------------------------------------------------------
-- QUERY 2: Comprehensive Course Registration & Grading Report
-- Joins Enrollments, Students, Courses, and Departments with letter grades
-- -------------------------------------------------------------
SELECT 
    s.matric_no,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.course_title,
    c.credits,
    e.semester,
    e.academic_session,
    e.score,
    e.grade
FROM Enrollment e
INNER JOIN Student s ON e.student_id = s.student_id
INNER JOIN Course c ON e.course_id = c.course_id
ORDER BY e.academic_session DESC, s.matric_no ASC;


-- -------------------------------------------------------------
-- QUERY 3: Advanced GPA & Performance Ranking Using Window Functions
-- Ranks students within their department based on average score
-- -------------------------------------------------------------
SELECT 
    d.dept_name,
    s.matric_no,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    ROUND(AVG(e.score), 2) AS average_score,
    RANK() OVER (PARTITION BY d.dept_id ORDER BY AVG(e.score) DESC) AS departmental_rank
FROM Student s
INNER JOIN Department d ON s.dept_id = d.dept_id
INNER JOIN Enrollment e ON s.student_id = e.student_id
GROUP BY d.dept_id, d.dept_name, s.student_id, s.matric_no, s.first_name, s.last_name;
