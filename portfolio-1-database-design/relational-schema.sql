-- =====================================================================
-- MIT 8103 Advanced Database Systems - Portfolio 1
-- Case study: Luma Polytechnic (simulated) - Student Records & Results
-- =====================================================================
DROP DATABASE IF EXISTS luma_db;
CREATE DATABASE luma_db CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE luma_db;

-- 1. departments
CREATE TABLE departments (
  department_id  SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code           VARCHAR(10)  NOT NULL,
  name           VARCHAR(120) NOT NULL,
  CONSTRAINT uq_dept_code UNIQUE (code),
  CONSTRAINT uq_dept_name UNIQUE (name)
) ENGINE=InnoDB;

-- 2. programmes
CREATE TABLE programmes (
  programme_id    SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  department_id   SMALLINT UNSIGNED NOT NULL,
  name            VARCHAR(120) NOT NULL,
  award           ENUM('ND','HND') NOT NULL,
  duration_years  TINYINT UNSIGNED NOT NULL DEFAULT 2,
  CONSTRAINT uq_prog_name_award UNIQUE (name, award),
  CONSTRAINT chk_prog_duration CHECK (duration_years BETWEEN 1 AND 4),
  CONSTRAINT fk_prog_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB;

-- 3. students
CREATE TABLE students (
  student_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  matric_no      VARCHAR(20)  NOT NULL,
  full_name      VARCHAR(120) NOT NULL,
  email          VARCHAR(150) NOT NULL,
  phone          VARCHAR(20)  NOT NULL,
  date_of_birth  DATE         NOT NULL,
  gender         ENUM('M','F') NOT NULL,
  programme_id   SMALLINT UNSIGNED NOT NULL,
  entry_year     SMALLINT UNSIGNED NOT NULL,
  status         ENUM('ACTIVE','DEFERRED','GRADUATED','WITHDRAWN') NOT NULL DEFAULT 'ACTIVE',
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_students_matric UNIQUE (matric_no),
  CONSTRAINT uq_students_email  UNIQUE (email),
  CONSTRAINT uq_students_phone  UNIQUE (phone),
  CONSTRAINT chk_students_email CHECK (email LIKE '%@%._%'),
  CONSTRAINT chk_students_entry CHECK (entry_year BETWEEN 2000 AND 2100),
  CONSTRAINT fk_students_prog FOREIGN KEY (programme_id) REFERENCES programmes(programme_id)
) ENGINE=InnoDB;

-- 4. lecturers
CREATE TABLE lecturers (
  lecturer_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  staff_no       VARCHAR(20)  NOT NULL,
  full_name      VARCHAR(120) NOT NULL,
  email          VARCHAR(150) NOT NULL,
  department_id  SMALLINT UNSIGNED NOT NULL,
  academic_rank  ENUM('ASSISTANT_LECTURER','LECTURER_II','LECTURER_I','SENIOR_LECTURER','PRINCIPAL_LECTURER','CHIEF_LECTURER') NOT NULL DEFAULT 'LECTURER_II',
  CONSTRAINT uq_lect_staff UNIQUE (staff_no),
  CONSTRAINT uq_lect_email UNIQUE (email),
  CONSTRAINT fk_lect_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB;

-- 5. courses
CREATE TABLE courses (
  course_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  department_id  SMALLINT UNSIGNED NOT NULL,
  course_code    VARCHAR(10)  NOT NULL,
  title          VARCHAR(200) NOT NULL,
  credit_units   TINYINT UNSIGNED NOT NULL,
  course_level   ENUM('ND1','ND2','HND1','HND2') NOT NULL,
  CONSTRAINT uq_course_code UNIQUE (course_code),
  CONSTRAINT chk_course_units CHECK (credit_units BETWEEN 1 AND 6),
  CONSTRAINT fk_course_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
) ENGINE=InnoDB;

-- 6. academic_terms
CREATE TABLE academic_terms (
  term_id        SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  session_label  CHAR(9) NOT NULL,
  semester       ENUM('FIRST','SECOND') NOT NULL,
  start_date     DATE NOT NULL,
  end_date       DATE NOT NULL,
  is_current     BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT uq_term UNIQUE (session_label, semester),
  CONSTRAINT chk_term_label CHECK (session_label REGEXP '^[0-9]{4}/[0-9]{4}$'),
  CONSTRAINT chk_term_dates CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- 7. course_offerings
CREATE TABLE course_offerings (
  offering_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  course_id    INT UNSIGNED NOT NULL,
  term_id      SMALLINT UNSIGNED NOT NULL,
  lecturer_id  INT UNSIGNED NOT NULL,
  capacity     SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT uq_offering UNIQUE (course_id, term_id),
  CONSTRAINT chk_offering_cap CHECK (capacity > 0),
  CONSTRAINT fk_off_course   FOREIGN KEY (course_id) REFERENCES courses(course_id),
  CONSTRAINT fk_off_term     FOREIGN KEY (term_id) REFERENCES academic_terms(term_id),
  CONSTRAINT fk_off_lecturer FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id)
) ENGINE=InnoDB;

-- 8. registrations
CREATE TABLE registrations (
  registration_id  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  student_id       INT UNSIGNED NOT NULL,
  offering_id      INT UNSIGNED NOT NULL,
  registered_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status           ENUM('REGISTERED','DROPPED') NOT NULL DEFAULT 'REGISTERED',
  CONSTRAINT uq_registration UNIQUE (student_id, offering_id),
  CONSTRAINT fk_reg_student  FOREIGN KEY (student_id) REFERENCES students(student_id),
  CONSTRAINT fk_reg_offering FOREIGN KEY (offering_id) REFERENCES course_offerings(offering_id)
) ENGINE=InnoDB;

-- 9. grade_scale
CREATE TABLE grade_scale (
  grade_letter  VARCHAR(2) PRIMARY KEY,
  min_score     TINYINT UNSIGNED NOT NULL,
  max_score     TINYINT UNSIGNED NOT NULL,
  grade_point   DECIMAL(3,2) NOT NULL,
  CONSTRAINT uq_scale_min UNIQUE (min_score),
  CONSTRAINT chk_scale_range CHECK (min_score <= max_score AND max_score <= 100),
  CONSTRAINT chk_scale_point CHECK (grade_point BETWEEN 0 AND 4)
) ENGINE=InnoDB;

-- 10. grades
CREATE TABLE grades (
  registration_id  BIGINT UNSIGNED PRIMARY KEY,
  ca_score         TINYINT UNSIGNED NOT NULL,
  exam_score       TINYINT UNSIGNED NOT NULL,
  total_score      TINYINT UNSIGNED GENERATED ALWAYS AS (ca_score + exam_score) STORED,
  entered_by       INT UNSIGNED NOT NULL,
  entered_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT chk_grade_ca   CHECK (ca_score   BETWEEN 0 AND 30),
  CONSTRAINT chk_grade_exam CHECK (exam_score BETWEEN 0 AND 70),
  CONSTRAINT fk_grade_reg  FOREIGN KEY (registration_id) REFERENCES registrations(registration_id) ON DELETE CASCADE,
  CONSTRAINT fk_grade_lect FOREIGN KEY (entered_by) REFERENCES lecturers(lecturer_id)
) ENGINE=InnoDB;

-- Supporting index for seat-count queries
CREATE INDEX idx_reg_offering_status ON registrations (offering_id, status);

-- Views
CREATE VIEW v_transcript AS
SELECT s.student_id, s.matric_no, s.full_name, t.term_id, t.session_label, t.semester,
       c.course_code, c.title, c.credit_units, g.total_score, gs.grade_letter, gs.grade_point
FROM grades g
JOIN registrations r  ON r.registration_id = g.registration_id
JOIN students s       ON s.student_id = r.student_id
JOIN course_offerings o ON o.offering_id = r.offering_id
JOIN courses c        ON c.course_id = o.course_id
JOIN academic_terms t ON t.term_id = o.term_id
JOIN grade_scale gs   ON g.total_score BETWEEN gs.min_score AND gs.max_score
WHERE r.status = 'REGISTERED';

CREATE VIEW v_semester_gpa AS
SELECT student_id, matric_no, full_name, term_id, session_label, semester,
       SUM(credit_units) AS units_taken,
       ROUND(SUM(credit_units * grade_point) / SUM(credit_units), 2) AS gpa
FROM v_transcript
GROUP BY student_id, matric_no, full_name, term_id, session_label, semester;

CREATE VIEW v_cgpa AS
SELECT student_id, matric_no, full_name,
       SUM(credit_units) AS total_units,
       ROUND(SUM(credit_units * grade_point) / SUM(credit_units), 2) AS cgpa
FROM v_transcript
GROUP BY student_id, matric_no, full_name;
