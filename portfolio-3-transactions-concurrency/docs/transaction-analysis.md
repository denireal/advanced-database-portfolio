# Portfolio 3: Transaction and Concurrency Analysis

## 1. Aim
The activity examines transaction durability and atomicity through `COMMIT` and `ROLLBACK`, and investigates isolation and concurrency control using a dedicated InnoDB demonstration table.

## 2. Commit and rollback
In Test A, an update temporarily reduced the balance of account 1 by 100.00. The change was then rolled back. Record the observed balance before and after `ROLLBACK`:

- Balance inside the transaction: **[enter observed value]**
- Balance after `ROLLBACK`: **[enter observed value]**

In Test B, a 50.00 reduction was committed. Record the observed balance after `COMMIT`:

- Balance after `COMMIT`: **[enter observed value]**

`ROLLBACK` cancels the uncommitted change in the transaction, whereas `COMMIT` makes the transaction's changes permanent.

## 3. Atomic transaction
Test C transfers 100.00 from account 1 to account 2 within one transaction. Both updates are committed together. The intended property is atomicity: the transfer should not be left half-completed if the transaction is rolled back before commit.

Record the actual balances before and after the transfer:
- Account 1: **[enter observed values]**
- Account 2: **[enter observed values]**

## 4. Isolation test
Test D uses two sessions and `REPEATABLE READ`. Session A reads account 1, while Session B updates and commits the same row. Session A then reads again before committing.

- First value read by Session A: **[enter observed value]**
- Value read again by Session A: **[enter observed value]**
- Value seen by a new transaction after commit: **[enter observed value, if tested]**

Under InnoDB `REPEATABLE READ`, ordinary consistent reads within the same transaction normally continue to use the transaction's snapshot. Actual results should be verified in the configured MySQL environment.

## 5. Concurrency control
Test E uses `SELECT ... FOR UPDATE` to lock account 2 in Session A. Session B attempts to update that row while the lock is held. Record whether Session B waited and whether its update completed after Session A committed.

- Was Session B blocked while the lock was held? **[yes/no; describe what you observed]**
- Did Session B's update complete after Session A committed? **[enter observed result]**

This illustrates pessimistic row locking: conflicting updates are coordinated by the database rather than being allowed to proceed simultaneously without control.

## 6. Limitations
These are small, controlled demonstrations using a dedicated lab table. They illustrate transaction behaviour but do not measure performance or prove how every production workload will behave. The concurrency test requires two independent database sessions. Do not claim a blocking result unless it was observed.

## 7. Conclusion
The practical demonstrates transaction control and concurrency concepts relevant to operations such as registering students for course offerings or updating academic records. Complete this conclusion using the actual screenshots and results collected during testing: **[summarise your observed commit, rollback, isolation, and locking results]**.
