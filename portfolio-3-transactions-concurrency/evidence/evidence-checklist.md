# Portfolio 3 Evidence Checklist

- [ ] `01-lab-table-setup.png` — `transaction_lab` table and its two starting rows.
- [ ] `02-rollback-before-after.png` — balance inside the transaction and restored balance after `ROLLBACK`.
- [ ] `03-commit-result.png` — committed balance after `COMMIT`.
- [ ] `04-atomic-transfer.png` — both account balances before/after the committed transfer.
- [ ] `05-repeatable-read-session-a.png` — Session A's two reads in one transaction.
- [ ] `06-repeatable-read-session-b.png` — Session B's update and `COMMIT`.
- [ ] `07-row-lock-session-a.png` — Session A's `SELECT ... FOR UPDATE` and later `COMMIT`.
- [ ] `08-row-lock-session-b.png` — Session B's update waiting, then completing after the lock is released.
