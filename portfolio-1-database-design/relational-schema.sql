
-- MIT 8103 Advanced Database Systems
-- Portfolio 1: Relational Schema
-- Case Study: Student Academic Management and Result Processing System
-- Database: sarms_db
-- DBMS: MySQL / MariaDB

CREATE DATABASE IF NOT EXISTS sarms_db;
USE sarms_db;

CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_code VARCHAR(20) NOT NULL UNIQUE,
    department_name VARCHAR(150) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE programmes (
    programme_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    programme_code VARCHAR(20) NOT NULL UNIQUE,
    programme_name VARCHAR(150) NOT NULL,
    award_type ENUM('ND','HND','CERTIFICATE') NOT NULL,
    duration_years TINYINT NOT NULL,
    CHECK (duration_years BETWEEN 1 AND 5),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    programme_id INT NOT NULL,
    matric_no VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender VARCHAR(20),
    date_of_birth DATE,
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(30),
    admission_year YEAR,
    academic_level ENUM('ND1','ND2','HND1','HND2') NOT NULL,
    status ENUM('Active','Graduated','Suspended','Withdrawn')
        NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (programme_id)
        REFERENCES programmes(programme_id)
);

CREATE TABLE lecturers (
    lecturer_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    staff_no VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    academic_rank VARCHAR(80),
    status VARCHAR(30) DEFAULT 'Active',
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_title VARCHAR(200) NOT NULL,
    credit_unit TINYINT NOT NULL,
    level VARCHAR(20) NOT NULL,
    semester_type VARCHAR(20) NOT NULL,
    CHECK (credit_unit BETWEEN 1 AND 6),
    FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

CREATE TABLE academic_sessions (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    session_name VARCHAR(20) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('Upcoming','Active','Closed') NOT NULL DEFAULT 'Upcoming',
    CHECK (end_date > start_date)
);

CREATE TABLE semesters (
    semester_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id INT NOT NULL,
    semester_name VARCHAR(20) NOT NULL,
    UNIQUE (session_id, semester_name),
    FOREIGN KEY (session_id)
        REFERENCES academic_sessions(session_id)
);

CREATE TABLE course_offerings (
    offering_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    lecturer_id INT NOT NULL,
    status VARCHAR(30) DEFAULT 'Active',
    UNIQUE (course_id, semester_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id),
    FOREIGN KEY (lecturer_id) REFERENCES lecturers(lecturer_id)
);

CREATE TABLE course_registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    offering_id INT NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Registered','Dropped','Completed')
        NOT NULL DEFAULT 'Registered',
    UNIQUE (student_id, offering_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (offering_id) REFERENCES course_offerings(offering_id)
);

CREATE TABLE results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    registration_id INT NOT NULL UNIQUE,
    ca_score DECIMAL(5,2) NOT NULL DEFAULT 0,
    exam_score DECIMAL(5,2) NOT NULL DEFAULT 0,
    total_score DECIMAL(5,2)
        GENERATED ALWAYS AS (ca_score + exam_score) STORED,
    grade VARCHAR(2),
    grade_point DECIMAL(3,2),
    remark VARCHAR(100),
    result_status ENUM('Draft','Submitted','Approved')
        NOT NULL DEFAULT 'Draft',
    entered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (ca_score BETWEEN 0 AND 40),
    CHECK (exam_score BETWEEN 0 AND 60),
    CHECK (grade_point IS NULL OR grade_point BETWEEN 0 AND 4),
    FOREIGN KEY (registration_id)
        REFERENCES course_registrations(registration_id)
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Administrator','Registry Officer','Lecturer',
              'HOD','Dean','Student','Auditor') NOT NULL,
    status ENUM('Active','Inactive') NOT NULL DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id VARCHAR(100),
    old_value JSON,
    new_value JSON,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
