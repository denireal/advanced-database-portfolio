-- =====================================================================
-- MIT 8103 - Portfolio 3: Transactions and Concurrency
-- =====================================================================
USE luma_db;

-- =====================================================================
-- SCENARIO 1: Explicit Transactions (COMMIT and ROLLBACK)
-- Context: A lecturer enters a grade, realizes it's wrong, and rolls back.
-- =====================================================================

-- 1. Start the transaction
START TRANSACTION;

-- 2. Insert a dummy grade for registration_id 1 (Ada Okafor, COM111)
-- Note: Registration 1 already has a grade, so we use a dummy ID for demonstration, 
-- or we can update an existing one. Let's update an existing score temporarily.
UPDATE grades SET ca_score = 20, exam_score = 40 WHERE registration_id = 1;

-- 3. Check the change (within the same session, you can see it)
SELECT registration_id, ca_score, exam_score, total_score FROM grades WHERE registration_id = 1;

-- 4. The lecturer realizes the mistake. ROLLBACK the changes.
ROLLBACK;

-- 5. Verify the data is restored to its original state.
SELECT registration_id, ca_score, exam_score, total_score FROM grades WHERE registration_id = 1;


-- =====================================================================
-- SCENARIO 2: Concurrency Control (Preventing the "Last Seat" Race Condition)
-- Context: Two students try to register for the last seat in a course simultaneously.
-- We use Pessimistic Locking (SELECT ... FOR UPDATE) to prevent overbooking.
-- =====================================================================

-- Setup: Temporarily set the capacity of Offering 1 to 1 to simulate the last seat.
UPDATE course_offerings SET capacity = 1 WHERE offering_id = 1;

-- (See Git Bash instructions below to run this across TWO sessions)


-- =====================================================================
-- SCENARIO 3: Isolation Levels (Demonstrating a Dirty Read)
-- Context: Reading uncommitted data from another transaction.
-- =====================================================================

-- Session A: Starts a transaction and updates a student's status, but DOES NOT commit.
START TRANSACTION;
UPDATE students SET status = 'DEFERRED' WHERE student_id = 2;

-- Session B: Changes isolation level to READ UNCOMMITTED and reads the data.
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT student_id, full_name, status FROM students WHERE student_id = 2; 
-- Result: Shows 'DEFERRED' even though Session A hasn't committed yet! (Dirty Read)

-- Cleanup: Rollback Session A and reset isolation level.
-- ROLLBACK; (Run in Session A)
-- SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ; (Run in Session B)
