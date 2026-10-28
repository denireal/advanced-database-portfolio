# Portfolio 3 Evidence Checklist

Capture your own phpMyAdmin screenshots after running the SQL. Do not use the expected results as substitutes for actual evidence.

- [ ] `01-lab-table-setup.png` — `transaction_lab` table and its two starting rows.
- [ ] `02-rollback-before-after.png` — balance inside the transaction and restored balance after `ROLLBACK`.
- [ ] `03-commit-result.png` — committed balance after `COMMIT`.
- [ ] `04-atomic-transfer.png` — both account balances before/after the committed transfer.
- [ ] `05-repeatable-read-session-a.png` — Session A's two reads in one transaction.
- [ ] `06-repeatable-read-session-b.png` — Session B's update and `COMMIT`.
- [ ] `07-row-lock-session-a.png` — Session A's `SELECT ... FOR UPDATE` and later `COMMIT`.
- [ ] `08-row-lock-session-b.png` — Session B's update waiting, then completing after the lock is released.

For two-session evidence, show enough of each session's SQL and result/status to explain the sequence. If phpMyAdmin does not make the waiting state visible, record what you actually observed and avoid claiming a wait that was not verified.
