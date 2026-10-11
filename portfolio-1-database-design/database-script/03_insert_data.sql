-- =====================================================================================
-- 03_insert_sample_data.sql : small seed dataset for FPE-SAMRPS
-- All names, matriculation numbers, and email addresses have been modified for privacy.
-- Matric format used: FPE/<ND|HND>/<DEPT>/<YY>/<serial>
-- =====================================================================================
USE sarms_db;

INSERT INTO academic_sessions (session_name, start_date, end_date, status) VALUES
  ('2025/2026', '2025-09-01', '2026-08-31', 'Closed'),
  ('2026/2027', '2026-09-01', '2027-08-31', 'Active');

INSERT INTO semesters (session_id, semester_name) VALUES
  (1,'First'), (1,'Second'), (2,'First'), (2,'Second');

INSERT INTO departments (department_code, department_name) VALUES
  ('CST', 'Computer Science'),
  ('ACC', 'Accountancy');

INSERT INTO programmes (department_id, programme_code, programme_name, award_type, duration_years) VALUES
  (1, 'ND-CST',  'National Diploma in Computer Science',        'ND',  2),
  (1, 'HND-CST', 'Higher National Diploma in Computer Science', 'HND', 2),
  (2, 'ND-ACC',  'National Diploma in Accountancy',             'ND',  2);

INSERT INTO lecturers (department_id, staff_no, first_name, last_name, email, academic_rank) VALUES
  (1, 'FPE/STF/001', 'Ada',   'Okafor', 'ada.okafor@fpe.example',  'Senior Lecturer'),
  (1, 'FPE/STF/002', 'Musa',  'Bello',  'musa.bello@fpe.example',  'Principal Lecturer'),
  (2, 'FPE/STF/003', 'Grace', 'Eze',    'grace.eze@fpe.example',   'Lecturer I');

INSERT INTO courses (department_id, course_code, course_title, credit_unit, level, semester_type) VALUES
  (1, 'COM111', 'Introduction to Computer Science', 3, 100, 'First'),
  (1, 'COM211', 'Database Design',                  3, 200, 'First'),
  (1, 'COM221', 'Systems Analysis and Design',      3, 200, 'Second'),
  (2, 'ACC111', 'Principles of Accounting I',       4, 100, 'First');

INSERT INTO programme_courses (programme_id, course_id, course_status) VALUES
  (1, 1, 'Core'), (1, 2, 'Core'), (1, 3, 'Core'),
  (3, 4, 'Core');

INSERT INTO course_offerings (course_id, semester_id, lecturer_id, max_capacity) VALUES
  (1, 3, 1, 2),     -- COM111, 2026/27 First, capacity 2 (reused in Portfolio 3)
  (2, 3, 2, 100),   -- COM211
  (4, 3, 3, 100);   -- ACC111

INSERT INTO students (programme_id, matric_no, first_name, last_name, gender,
                      date_of_birth, email, admission_year, academic_level) VALUES
  (1, 'FPE/ND/CST/26/001', 'Chidi', 'Nwosu', 'Male',   '2006-04-12', 'chidi.nwosu@stu.fpe.example', 2026, 100),
  (1, 'FPE/ND/CST/26/002', 'Amina', 'Yusuf', 'Female', '2007-08-30', 'amina.yusuf@stu.fpe.example', 2026, 100),
  (1, 'FPE/ND/CST/25/010', 'Tunde', 'Ajayi', 'Male',   '2005-01-20', 'tunde.ajayi@stu.fpe.example', 2025, 200),
  (3, 'FPE/ND/ACC/26/005', 'Ngozi', 'Obi',   'Female', '2006-11-02', 'ngozi.obi@stu.fpe.example',   2026, 100);

INSERT INTO users (username, password_hash, role, student_id, lecturer_id) VALUES
  ('admin',       '$2y$10$placeholderhashadmin000000000000000000000000000000000', 'Admin',     NULL, NULL),
  ('registrar',   '$2y$10$placeholderhashregistrar00000000000000000000000000000', 'Registrar', NULL, NULL),
  ('a.okafor',    '$2y$10$placeholderhashlecturer100000000000000000000000000000', 'Lecturer',  NULL, 1),
  ('chidi.nwosu', '$2y$10$placeholderhashstudent1000000000000000000000000000000', 'Student',   1,    NULL);

INSERT INTO course_registrations (student_id, offering_id) VALUES
  (1, 1), (2, 1), (3, 2), (4, 3);

-- Raw scores only: total_score, grade and grade_point are generated.
INSERT INTO results (registration_id, ca_score, exam_score, entered_by, result_status) VALUES
  (1, 32.00, 45.50, 3, 'Published'),   -- 77.50 -> A  (4.00)
  (2, 25.00, 45.00, 3, 'Published'),   -- 70.00 -> AB (3.50)
  (3, 15.00, 20.00, 3, 'Published');   -- 35.00 -> F  (0.00)

INSERT INTO audit_logs (user_id, action, table_name, record_id, old_value, new_value) VALUES
  (3, 'INSERT', 'results', 1, NULL,
   JSON_OBJECT('registration_id', 1, 'ca_score', 32.00, 'exam_score', 45.50));
