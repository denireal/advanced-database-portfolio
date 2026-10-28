-- Portfolio 3: COMMIT and ROLLBACK

CREATE TABLE IF NOT EXISTS transaction_lab (
    account_id INT PRIMARY KEY,
    account_name VARCHAR(60) NOT NULL,
    balance DECIMAL(10,2) NOT NULL
) ENGINE=InnoDB;

-- Reset only the dedicated lab table so the examples are repeatable.
DELETE FROM transaction_lab;

INSERT INTO transaction_lab (account_id, account_name, balance)
VALUES
    (1, 'Student Services Fund', 1000.00),
    (2, 'Library Resources Fund', 500.00);

-- TEST A: ROLLBACK
-- Expected: balance returns to 1000.00 after ROLLBACK.
START TRANSACTION;
UPDATE transaction_lab
SET balance = balance - 100.00
WHERE account_id = 1;
SELECT account_id, account_name, balance
FROM transaction_lab
WHERE account_id = 1;
ROLLBACK;

SELECT account_id, account_name, balance
FROM transaction_lab
WHERE account_id = 1;

-- TEST B: COMMIT
-- Expected: balance becomes 950.00 and remains 950.00 after COMMIT.
START TRANSACTION;
UPDATE transaction_lab
SET balance = balance - 50.00
WHERE account_id = 1;
SELECT account_id, account_name, balance
FROM transaction_lab
WHERE account_id = 1;
COMMIT;

SELECT account_id, account_name, balance
FROM transaction_lab
WHERE account_id = 1;

-- TEST C: ATOMIC TRANSFER WITH COMMIT
-- Expected: account 1 decreases by 100.00 and account 2 increases by 100.00.
START TRANSACTION;
UPDATE transaction_lab
SET balance = balance - 100.00
WHERE account_id = 1;
UPDATE transaction_lab
SET balance = balance + 100.00
WHERE account_id = 2;
SELECT account_id, account_name, balance
FROM transaction_lab
ORDER BY account_id;
COMMIT;

SELECT account_id, account_name, balance
FROM transaction_lab
ORDER BY account_id;
