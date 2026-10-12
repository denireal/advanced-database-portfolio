
CREATE DATABASE IF NOT EXISTS southern_tech_university_db;
USE southern_tech_university_db;

-- 1. Department Table
CREATE TABLE Department (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) UNIQUE NOT NULL,
    head_of_dept VARCHAR(100) NOT NULL
);

-- 2. Lecturer Table
CREATE TABLE Lecturer (
    lecturer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dept_id INT,
    CONSTRAINT fk_lecturer_dept FOREIGN KEY (dept_id) 
        REFERENCES Department(dept_id) ON DELETE SET NULL
);

-- 3. Student Table
CREATE TABLE Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    matric_no VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dept_id INT,
    admission_year INT NOT NULL,
    CONSTRAINT fk_student_dept FOREIGN KEY (dept_id) 
        REFERENCES Department(dept_id) ON DELETE SET NULL
);

-- 4. Course Table
CREATE TABLE Course (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(15) UNIQUE NOT NULL,
    course_title VARCHAR(150) NOT NULL,
    credits INT CHECK (credits > 0),
    dept_id INT,
    CONSTRAINT fk_course_dept FOREIGN KEY (dept_id) 
        REFERENCES Department(dept_id) ON DELETE CASCADE
);

-- 5. Enrollment Table (Mapping Students to Courses with Grades)
CREATE TABLE Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    academic_session VARCHAR(20) NOT NULL,
    score DECIMAL(5,2) CHECK (score BETWEEN 0.00 AND 100.00),
    grade CHAR(2),
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) 
        REFERENCES Student(student_id) ON DELETE CASCADE,
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) 
        REFERENCES Course(course_id) ON DELETE CASCADE,
    CONSTRAINT uc_student_course_session UNIQUE (student_id, course_id, semester, academic_session)
);