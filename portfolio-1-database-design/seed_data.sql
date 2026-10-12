USE southern_tech_university_db;

-- 1. Insert Departments
INSERT INTO Department (dept_name, head_of_dept) VALUES
('Computer Science', 'Dr. Evelyn Vance'),
('Electrical Engineering', 'Prof. Marcus Brody'),
('Information Technology', 'Dr. Sarah Lin');

-- 2. Insert Admin Users (Including self-referencing creator ID and departmental restrictions)
-- Note: SuperAdmin is created first with NULL created_by, then subsequent admins reference admin_id 1.
INSERT INTO AdminUser (username, password_hash, first_name, last_name, email, role, dept_id, is_2fa_enabled, totp_secret, status, created_by) VALUES
('super_admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System', 'Administrator', 'admin@southerntech.edu', 'SuperAdmin', NULL, TRUE, 'JBSWY3DPEHPK3PXP', 'Active', NULL),
('registrar_jane', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane', 'Adamu', 'registrar@southerntech.edu', 'Registrar', NULL, TRUE, 'GEZDGNBVGY3TQOJQ', 'Active', 1),
('cs_dean', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Evelyn', 'Vance', 'e.vance@southerntech.edu', 'Dean', 1, FALSE, NULL, 'Active', 1);

-- 3. Insert Lecturers
INSERT INTO Lecturer (first_name, last_name, email, dept_id) VALUES
('Alan', 'Turing', 'a.turing@southerntech.edu', 1),
('Grace', 'Hopper', 'g.hopper@southerntech.edu', 1),
('Nikola', 'Tesla', 'n.tesla@southerntech.edu', 2),
('Ada', 'Lovelace', 'a.lovelace@southerntech.edu', 3);

-- 4. Insert Students
INSERT INTO Student (matric_no, first_name, last_name, email, dept_id, admission_year) VALUES
('STU/2024/001', 'Denyefa', 'Wari', 'd.wari@student.southerntech.edu', 1, 2024),
('STU/2024/002', 'Chinedu', 'Okafor', 'c.okafor@student.southerntech.edu', 1, 2024),
('STU/2024/003', 'Amina', 'Bello', 'a.bello@student.southerntech.edu', 2, 2024),
('STU/2024/004', 'Oluwaseun', 'Adeyemi', 'o.adeyemi@student.southerntech.edu', 3, 2024);

-- 5. Insert Courses
INSERT INTO Course (course_code, course_title, credits, dept_id) VALUES
('CSC8103', 'Advanced Database Systems', 3, 1),
('CSC8201', 'Machine Learning and AI', 4, 1),
('ENG8102', 'Advanced Circuit Analysis', 3, 2),
('IT8101', 'Cloud Computing Architectures', 3, 3);

-- 6. Insert Enrollments
INSERT INTO Enrollment (student_id, course_id, semester, academic_session, score, grade) VALUES
(1, 1, 'First Semester', '2026/2027', 88.50, 'A'),
(1, 2, 'First Semester', '2026/2027', 76.00, 'B'),
(2, 1, 'First Semester', '2026/2027', 65.25, 'C'),
(2, 4, 'First Semester', '2026/2027', 82.00, 'A'),
(3, 3, 'First Semester', '2026/2027', 91.00, 'A'),
(4, 4, 'First Semester', '2026/2027', 74.50, 'B');