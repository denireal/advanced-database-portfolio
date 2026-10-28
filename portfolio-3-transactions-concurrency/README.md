# Portfolio 3: Transactions and Concurrency

## Objective
This portfolio demonstrates transaction control with `COMMIT` and `ROLLBACK`, transaction isolation, and a concurrency-control mechanism. The examples use a small, dedicated InnoDB table named `transaction_lab` so that the experiments do not alter the main Luma Polytechnic tables.

## Files
- `sql/transactions.sql` — creates the lab table and demonstrates commit and rollback.
- `sql/isolation-and-concurrency.sql` — provides two-session isolation and row-locking experiments.
- `docs/transaction-analysis.md` — report template for interpreting the observed results.
- `evidence/evidence-checklist.md` — screenshots and output to capture.

## How to run
1. In phpMyAdmin, select the `luma_db` database.
2. Open `sql/transactions.sql`, copy its contents into the SQL tab, and execute the setup and transaction examples in order. If your phpMyAdmin version does not accept several statements together, run each labelled block separately.
3. Run the two-session tests in `sql/isolation-and-concurrency.sql` using two separate database sessions/windows. Do not run both sessions in the same SQL tab.
4. Capture your actual outputs and add them to `evidence/`.
5. Record only results you personally observed. Execution timing and concurrency outcomes can vary by session setup.

## Safety note
The examples operate on `transaction_lab`, not on student registrations or grades. The setup script resets this dedicated lab table, so rerunning it resets the demonstration data. Do not run the reset statement against any production or assessment table.

## Expected evidence
Show the commands and results for a committed change, a rolled-back change, a repeatable-read test, and a row-locking/concurrency-control test. The evidence checklist identifies the recommended screenshots.
