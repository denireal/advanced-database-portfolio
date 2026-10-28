SELECT
    s.matric_number,
    c.course_code,
    g.ca_score,
    g.exam_score,
    g.total_score,
    g.letter_grade,
    g.grade_point
FROM grades AS g
JOIN registrations AS r
    ON g.registration_id = r.registration_id
JOIN students AS s
    ON r.student_id = s.student_id
JOIN course_offerings AS co
    ON r.offering_id = co.offering_id
JOIN courses AS c
    ON co.course_id = c.course_id
ORDER BY s.matric_number, c.course_code;
