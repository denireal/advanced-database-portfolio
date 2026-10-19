-- =====================================================================
-- MIT 8103 Advanced Database Systems - Portfolio 1
-- Luma Polytechnic - seed data
-- =====================================================================
USE luma_db;

INSERT INTO grade_scale (grade_letter,min_score,max_score,grade_point) VALUES
('A',75,100,4.00),('AB',70,74,3.50),('B',65,69,3.25),('BC',60,64,3.00),
('C',55,59,2.75),('CD',50,54,2.50),('D',45,49,2.25),('E',40,44,2.00),('F',0,39,0.00);

INSERT INTO departments (code,name) VALUES
('CSC','Computer Science'),('EEE','Electrical/Electronic Engineering');

INSERT INTO programmes (department_id,name,award,duration_years) VALUES
(1,'Computer Science','ND',2),(1,'Computer Science','HND',2),(2,'Electrical/Electronic Engineering','ND',2);

INSERT INTO lecturers (staff_no,full_name,email,department_id,academic_rank) VALUES
('LP/ST/001','Dr. Ngozi Eze','n.eze@lumapoly.example',1,'SENIOR_LECTURER'),
('LP/ST/002','Mr. Ibrahim Musa','i.musa@lumapoly.example',1,'LECTURER_I');

INSERT INTO students (matric_no,full_name,email,phone,date_of_birth,gender,programme_id,entry_year) VALUES
('LP/26/CSC/0001','Ada Okafor','ada@student.lumapoly.example','08030000001','2006-03-14','F',1,2026),
('LP/26/CSC/0002','Tunde Bello','tunde@student.lumapoly.example','08030000002','2005-11-02','M',1,2026),
('LP/26/CSC/0003','Efe Oghene','efe@student.lumapoly.example','08030000003','2006-07-21','F',1,2026);

INSERT INTO courses (department_id,course_code,title,credit_units,course_level) VALUES
(1,'COM111','Introduction to Computing',3,'ND1'),(1,'COM112','Programming Fundamentals',4,'ND1'),(1,'COM121','Database Design Basics',3,'ND1');

INSERT INTO academic_terms (session_label,semester,start_date,end_date,is_current) VALUES
('2026/2027','FIRST','2026-10-05','2027-02-12',TRUE);

INSERT INTO course_offerings (course_id,term_id,lecturer_id,capacity) VALUES
(1,1,1,150),(2,1,2,120),(3,1,1,100);

INSERT INTO registrations (student_id,offering_id) VALUES
(1,1),(1,2),(1,3),(2,1),(2,2),(3,1);

INSERT INTO grades (registration_id,ca_score,exam_score,entered_by) VALUES
(1,27,58,1),(2,22,48,2),(3,25,41,1),(4,18,35,1),(5,15,30,2),(6,28,66,1);

-- Quick verification
SELECT * FROM v_transcript ORDER BY matric_no, course_code;
SELECT * FROM v_semester_gpa;
SELECT * FROM v_cgpa;
