-- Portfolio 3: Isolation and concurrency experiments
-- Prerequisite: run transactions.sql first.

-- SESSION A: run these statements one at a time, leaving the transaction open.
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
SELECT balance FROM transaction_lab WHERE account_id = 1;
-- Pause here. Run Session B's update and COMMIT.
SELECT balance FROM transaction_lab WHERE account_id = 1;
-- Under REPEATABLE READ, this second consistent read should show the same
-- snapshot value as the first read. Then close the transaction:
COMMIT;

-- SESSION B: run after Session A has performed its FIRST SELECT.
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;
UPDATE transaction_lab
SET balance = balance + 25.00
WHERE account_id = 1;
COMMIT;
-- In Session A, run the second SELECT before its COMMIT.

-- =========================================================
-- TEST E: ROW LOCKING WITH SELECT ... FOR UPDATE
-- Reset account 2 to a known value first if needed:
-- UPDATE transaction_lab SET balance = 500.00 WHERE account_id = 2;
-- Run Session A and Session B in separate sessions.
-- =========================================================

-- SESSION A:
START TRANSACTION;
SELECT account_id, balance
FROM transaction_lab
WHERE account_id = 2
FOR UPDATE;
-- The selected row is locked by this transaction. Keep the transaction open.

-- SESSION B (while Session A is still open):
START TRANSACTION;
UPDATE transaction_lab
SET balance = balance + 10.00
WHERE account_id = 2;
-- This UPDATE should wait for Session A to release its row lock.
-- After observing the wait, return to Session A and run:
-- COMMIT;
-- The blocked UPDATE in Session B can then proceed; run COMMIT in Session B.

-- SESSION A: release the lock
COMMIT;

-- SESSION B: after its UPDATE completes
COMMIT;
SELECT account_id, balance
FROM transaction_lab
WHERE account_id = 2;
