SELECT
    s.matric_number,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.course_title,
    at.session_name,
    at.semester_name
FROM registrations AS r
JOIN students AS s
    ON r.student_id = s.student_id
JOIN course_offerings AS co
    ON r.offering_id = co.offering_id
JOIN courses AS c
    ON co.course_id = c.course_id
JOIN academic_terms AS at
    ON co.term_id = at.term_id
ORDER BY s.matric_number, c.course_code;
