USE sarms_db;

-- ---------------------------------------------------------------------
-- 1. academic_sessions  (e.g. 2026/2027)
-- ---------------------------------------------------------------------
CREATE TABLE academic_sessions (
  session_id    INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  session_name  VARCHAR(9)    NOT NULL,              -- '2026/2027'
  start_date    DATE          NOT NULL,
  end_date      DATE          NOT NULL,
  status        ENUM('Upcoming','Active','Closed') NOT NULL DEFAULT 'Upcoming',
  CONSTRAINT pk_academic_sessions PRIMARY KEY (session_id),
  CONSTRAINT uq_session_name UNIQUE (session_name),
  CONSTRAINT ck_session_dates CHECK (end_date > start_date)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. semesters  (First / Second within an academic session)
-- ---------------------------------------------------------------------
CREATE TABLE semesters (
  semester_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  session_id     INT UNSIGNED NOT NULL,
  semester_name  ENUM('First','Second') NOT NULL,
  CONSTRAINT pk_semesters PRIMARY KEY (semester_id),
  CONSTRAINT uq_semester_per_session UNIQUE (session_id, semester_name),
  CONSTRAINT fk_semesters_session FOREIGN KEY (session_id)
    REFERENCES academic_sessions (session_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. departments
-- ---------------------------------------------------------------------
CREATE TABLE departments (
  department_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  department_code  VARCHAR(10)  NOT NULL,
  department_name  VARCHAR(100) NOT NULL,
  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_departments PRIMARY KEY (department_id),
  CONSTRAINT uq_department_code UNIQUE (department_code),
  CONSTRAINT uq_department_name UNIQUE (department_name)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. programmes
-- ---------------------------------------------------------------------
CREATE TABLE programmes (
  programme_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  department_id   INT UNSIGNED NOT NULL,
  programme_code  VARCHAR(15)  NOT NULL,
  programme_name  VARCHAR(120) NOT NULL,
  award_type      ENUM('ND','HND','Certificate') NOT NULL,
  duration_years  TINYINT UNSIGNED NOT NULL,
  CONSTRAINT pk_programmes PRIMARY KEY (programme_id),
  CONSTRAINT uq_programme_code UNIQUE (programme_code),
  CONSTRAINT ck_programme_duration CHECK (duration_years BETWEEN 1 AND 5),
  CONSTRAINT fk_programmes_department FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. students
-- ---------------------------------------------------------------------
CREATE TABLE students (
  student_id       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  programme_id     INT UNSIGNED NOT NULL,
  matric_no        VARCHAR(20)  NOT NULL,
  first_name       VARCHAR(50)  NOT NULL,
  last_name        VARCHAR(50)  NOT NULL,
  gender           ENUM('Male','Female','Other') NOT NULL,
  date_of_birth    DATE         NOT NULL,
  email            VARCHAR(120) NOT NULL,
  phone            VARCHAR(20)  NULL,
  admission_year   YEAR         NOT NULL,
  academic_level   SMALLINT UNSIGNED NOT NULL,       -- 100=ND1, 200=ND2, 300=HND1, 400=HND2
  status           ENUM('Active','Suspended','Graduated','Withdrawn')
                   NOT NULL DEFAULT 'Active',
  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_students PRIMARY KEY (student_id),
  CONSTRAINT uq_students_matric UNIQUE (matric_no),
  CONSTRAINT uq_students_email  UNIQUE (email),
  CONSTRAINT ck_students_level CHECK (academic_level IN (100,200,300,400)),
  CONSTRAINT fk_students_programme FOREIGN KEY (programme_id)
    REFERENCES programmes (programme_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. lecturers
-- ---------------------------------------------------------------------
CREATE TABLE lecturers (
  lecturer_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  department_id  INT UNSIGNED NOT NULL,
  staff_no       VARCHAR(20)  NOT NULL,
  first_name     VARCHAR(50)  NOT NULL,
  last_name      VARCHAR(50)  NOT NULL,
  email          VARCHAR(120) NOT NULL,
  academic_rank  ENUM('Assistant Lecturer','Lecturer III','Lecturer II',
                      'Lecturer I','Senior Lecturer','Principal Lecturer',
                      'Chief Lecturer') NOT NULL,
  status         ENUM('Active','On Leave','Retired') NOT NULL DEFAULT 'Active',
  CONSTRAINT pk_lecturers PRIMARY KEY (lecturer_id),
  CONSTRAINT uq_lecturers_staff_no UNIQUE (staff_no),
  CONSTRAINT uq_lecturers_email    UNIQUE (email),
  CONSTRAINT fk_lecturers_department FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 7. courses
-- ---------------------------------------------------------------------
CREATE TABLE courses (
  course_id      INT UNSIGNED NOT NULL AUTO_INCREMENT,
  department_id  INT UNSIGNED NOT NULL,
  course_code    VARCHAR(10)  NOT NULL,              -- e.g. COM111
  course_title   VARCHAR(150) NOT NULL,
  credit_unit    TINYINT UNSIGNED NOT NULL,
  level          SMALLINT UNSIGNED NOT NULL,
  semester_type  ENUM('First','Second','Both') NOT NULL,
  CONSTRAINT pk_courses PRIMARY KEY (course_id),
  CONSTRAINT uq_courses_code UNIQUE (course_code),
  CONSTRAINT ck_courses_credit CHECK (credit_unit BETWEEN 1 AND 6),
  CONSTRAINT ck_courses_level  CHECK (level IN (100,200,300,400)),
  CONSTRAINT fk_courses_department FOREIGN KEY (department_id)
    REFERENCES departments (department_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 8. programme_courses  (M:N programmes <-> courses: the curriculum)
-- ---------------------------------------------------------------------
CREATE TABLE programme_courses (
  programme_id   INT UNSIGNED NOT NULL,
  course_id      INT UNSIGNED NOT NULL,
  course_status  ENUM('Core','Elective') NOT NULL DEFAULT 'Core',
  CONSTRAINT pk_programme_courses PRIMARY KEY (programme_id, course_id),
  CONSTRAINT fk_pc_programme FOREIGN KEY (programme_id)
    REFERENCES programmes (programme_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pc_course FOREIGN KEY (course_id)
    REFERENCES courses (course_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 9. course_offerings  (a course delivered in a semester by a lecturer)
-- Scope decision: one lecturer and one section per offering.
-- ---------------------------------------------------------------------
CREATE TABLE course_offerings (
  offering_id   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  course_id     INT UNSIGNED NOT NULL,
  semester_id   INT UNSIGNED NOT NULL,
  lecturer_id   INT UNSIGNED NOT NULL,
  max_capacity  SMALLINT UNSIGNED NOT NULL DEFAULT 100,
  status        ENUM('Open','Closed','Cancelled') NOT NULL DEFAULT 'Open',
  CONSTRAINT pk_course_offerings PRIMARY KEY (offering_id),
  CONSTRAINT uq_offering_course_semester UNIQUE (course_id, semester_id),
  CONSTRAINT ck_offering_capacity CHECK (max_capacity > 0),
  CONSTRAINT fk_offerings_course FOREIGN KEY (course_id)
    REFERENCES courses (course_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_offerings_semester FOREIGN KEY (semester_id)
    REFERENCES semesters (semester_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_offerings_lecturer FOREIGN KEY (lecturer_id)
    REFERENCES lecturers (lecturer_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 10. course_registrations  (resolves students <-> course_offerings M:N)
-- ---------------------------------------------------------------------
CREATE TABLE course_registrations (
  registration_id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  student_id         INT UNSIGNED NOT NULL,
  offering_id        INT UNSIGNED NOT NULL,
  registration_date  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status             ENUM('Registered','Dropped','Completed')
                     NOT NULL DEFAULT 'Registered',
  CONSTRAINT pk_course_registrations PRIMARY KEY (registration_id),
  CONSTRAINT uq_registration_student_offering UNIQUE (student_id, offering_id),
  CONSTRAINT fk_reg_student FOREIGN KEY (student_id)
    REFERENCES students (student_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_reg_offering FOREIGN KEY (offering_id)
    REFERENCES course_offerings (offering_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 11. users  (system accounts, linked to a student OR a lecturer)
-- ---------------------------------------------------------------------
CREATE TABLE users (
  user_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  username       VARCHAR(50)  NOT NULL,
  password_hash  VARCHAR(255) NOT NULL,
  role           ENUM('Admin','Registrar','Lecturer','Student') NOT NULL,
  student_id     INT UNSIGNED NULL,
  lecturer_id    INT UNSIGNED NULL,
  status         ENUM('Active','Locked','Disabled') NOT NULL DEFAULT 'Active',
  created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_users PRIMARY KEY (user_id),
  CONSTRAINT uq_users_username UNIQUE (username),
  CONSTRAINT uq_users_student  UNIQUE (student_id),
  CONSTRAINT uq_users_lecturer UNIQUE (lecturer_id),
  -- The role decides which profile link must exist
  CONSTRAINT ck_users_role_link CHECK (
       (role = 'Student'  AND student_id IS NOT NULL AND lecturer_id IS NULL)
    OR (role = 'Lecturer' AND lecturer_id IS NOT NULL AND student_id IS NULL)
    OR (role IN ('Admin','Registrar') AND student_id IS NULL AND lecturer_id IS NULL)),
  -- RESTRICT (not CASCADE): MySQL forbids CHECK constraints on columns
  -- that have CASCADE / SET NULL referential actions.
  CONSTRAINT fk_users_student FOREIGN KEY (student_id)
    REFERENCES students (student_id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_users_lecturer FOREIGN KEY (lecturer_id)
    REFERENCES lecturers (lecturer_id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 12. results  (1 : 0..1 with course_registrations)
-- total_score, grade and grade_point are GENERATED columns: the DBMS
-- derives them from ca_score + exam_score, so they can never contradict
-- the raw scores (see docs/normalisation.md).
-- Grading scale: NBTE-style 4-point scale with letter codes (A, AB, B, BC,
-- C, CD, D, E, F). ASSUMPTION: confirm the exact bands and points against
-- your institution's approved scale and edit BOTH CASE expressions below.
-- ---------------------------------------------------------------------
CREATE TABLE results (
  result_id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  registration_id  INT UNSIGNED NOT NULL,
  ca_score         DECIMAL(5,2) NOT NULL,
  exam_score       DECIMAL(5,2) NOT NULL,
  total_score      DECIMAL(5,2) GENERATED ALWAYS AS (ca_score + exam_score) STORED,
  grade            VARCHAR(2) GENERATED ALWAYS AS (
                     CASE WHEN ca_score + exam_score >= 75 THEN 'A'
                          WHEN ca_score + exam_score >= 70 THEN 'AB'
                          WHEN ca_score + exam_score >= 65 THEN 'B'
                          WHEN ca_score + exam_score >= 60 THEN 'BC'
                          WHEN ca_score + exam_score >= 55 THEN 'C'
                          WHEN ca_score + exam_score >= 50 THEN 'CD'
                          WHEN ca_score + exam_score >= 45 THEN 'D'
                          WHEN ca_score + exam_score >= 40 THEN 'E'
                          ELSE 'F' END) STORED,
  grade_point      DECIMAL(3,2) GENERATED ALWAYS AS (
                     CASE WHEN ca_score + exam_score >= 75 THEN 4.00
                          WHEN ca_score + exam_score >= 70 THEN 3.50
                          WHEN ca_score + exam_score >= 65 THEN 3.25
                          WHEN ca_score + exam_score >= 60 THEN 3.00
                          WHEN ca_score + exam_score >= 55 THEN 2.75
                          WHEN ca_score + exam_score >= 50 THEN 2.50
                          WHEN ca_score + exam_score >= 45 THEN 2.25
                          WHEN ca_score + exam_score >= 40 THEN 2.00
                          ELSE 0.00 END) STORED,
  remark           VARCHAR(255) NULL,
  result_status    ENUM('Draft','Submitted','Approved','Published')
                   NOT NULL DEFAULT 'Draft',
  entered_by       INT UNSIGNED NOT NULL,
  entered_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_results PRIMARY KEY (result_id),
  CONSTRAINT uq_results_registration UNIQUE (registration_id),
  CONSTRAINT ck_results_ca   CHECK (ca_score   BETWEEN 0 AND 40),
  CONSTRAINT ck_results_exam CHECK (exam_score BETWEEN 0 AND 60),
  CONSTRAINT fk_results_registration FOREIGN KEY (registration_id)
    REFERENCES course_registrations (registration_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_results_entered_by FOREIGN KEY (entered_by)
    REFERENCES users (user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 13. audit_logs  (append-only trail of changes)
-- ---------------------------------------------------------------------
CREATE TABLE audit_logs (
  audit_id     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id      INT UNSIGNED NOT NULL,
  action       ENUM('INSERT','UPDATE','DELETE','LOGIN','LOGOUT') NOT NULL,
  table_name   VARCHAR(64)  NOT NULL,
  record_id    BIGINT UNSIGNED NULL,
  old_value    JSON NULL,
  new_value    JSON NULL,
  action_time  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_audit_logs PRIMARY KEY (audit_id),
  CONSTRAINT fk_audit_user FOREIGN KEY (user_id)
    REFERENCES users (user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Secondary indexes on foreign keys / frequent filters.
-- InnoDB already indexes FK columns that lead a UNIQUE key:
-- semesters.session_id, course_offerings.course_id,
-- course_registrations.student_id.
-- ---------------------------------------------------------------------
CREATE INDEX idx_programmes_department ON programmes (department_id);
CREATE INDEX idx_students_programme    ON students (programme_id);
CREATE INDEX idx_lecturers_department  ON lecturers (department_id);
CREATE INDEX idx_courses_department    ON courses (department_id);
CREATE INDEX idx_pc_course             ON programme_courses (course_id);
CREATE INDEX idx_offerings_semester    ON course_offerings (semester_id);
CREATE INDEX idx_offerings_lecturer    ON course_offerings (lecturer_id);
CREATE INDEX idx_reg_offering          ON course_registrations (offering_id);
CREATE INDEX idx_results_entered_by    ON results (entered_by);
CREATE INDEX idx_audit_user_time       ON audit_logs (user_id, action_time);
CREATE INDEX idx_audit_table_record    ON audit_logs (table_name, record_id);
