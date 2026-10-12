-- -------------------------------------------------------------
-- PORTFOLIO 3: ACID Transactions and Concurrency Control
-- Database: southern_tech_university_db
-- -------------------------------------------------------------

USE southern_tech_university_db;

-- Set Transaction Isolation Level for Concurrency Control
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- =============================================================
-- SCENARIO A: Successful Transaction with COMMIT (Course Registration)
-- Ensures atomicity: registering a student and locking rows to 
-- prevent race conditions during high-concurrency portal access.
-- =============================================================

START TRANSACTION;

-- Step 1: Check if the student exists and lock the row
SELECT student_id, matric_no 
FROM Student 
WHERE student_id = 1 
FOR UPDATE;

-- Step 2: Check course availability and lock course row
SELECT course_id, course_code, credits 
FROM Course 
WHERE course_id = 2 
FOR UPDATE;

-- Step 3: Insert course enrollment record
INSERT INTO Enrollment (student_id, course_id, semester, academic_session, score, grade)
VALUES (1, 2, 'First Semester', '2026/2027', NULL, NULL);

-- Step 4: Commit transaction if all operations succeed
COMMIT;


-- =============================================================
-- SCENARIO B: Failed Transaction with ROLLBACK (Integrity Violation)
-- Simulates a unique constraint violation (duplicate registration) 
-- resulting in error handling and explicit rollback.
-- =============================================================

START TRANSACTION;

-- Attempting to register the same student for the same course in the same session.
-- This triggers a duplicate entry error on the unique constraint (uc_student_course_session).
INSERT INTO Enrollment (student_id, course_id, semester, academic_session, score, grade)
VALUES (1, 2, 'First Semester', '2026/2027', NULL, NULL);

-- If an error occurs or business logic fails, rollback changes to maintain consistency
ROLLBACK;
