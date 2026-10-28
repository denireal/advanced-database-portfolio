# Portfolio 3: Transaction and Concurrency Analysis

## 1. Aim

This practical examines transaction atomicity and durability through `COMMIT` and `ROLLBACK`, and investigates isolation and concurrency control using a dedicated InnoDB demonstration table. The tests were conducted using MariaDB through the XAMPP command-line client, with two independent database sessions connected to `luma_db`. The `transaction_lab` table was used to avoid modifying the main institutional data.

## 2. Commit and Rollback

### Test A: ROLLBACK

An update reduced the balance of account 1, Student Services Fund, by 100.00 within a transaction. The balance observed inside the transaction was 900.00. After `ROLLBACK` was executed, the balance returned to 1000.00.

- Balance inside the transaction: **900.00**
- Balance after `ROLLBACK`: **1000.00**

This test demonstrated that an uncommitted update can be reversed, restoring the previously committed value.

### Test B: COMMIT

An update reduced the balance of account 1 by 50.00. After `COMMIT` was executed, the balance was 950.00.

- Balance after `COMMIT`: **950.00**

This test demonstrated that the update was committed and persisted in the database.

`ROLLBACK` cancels uncommitted changes in a transaction, whereas `COMMIT` makes the transaction's changes permanent.

## 3. Atomic Transaction

Test C was designed to transfer 100.00 from account 1 to account 2 within one transaction. Both updates should be committed together, demonstrating atomicity: the transfer should not be left half-completed if the transaction is rolled back before commit.


## 4. Isolation Test

The isolation test used two independent MariaDB command-line sessions connected to `luma_db`. Session A updated the Student Services Fund balance within a transaction, while Session B queried the same account before the transaction was committed.

The observed results were:

| Observation | Session | Balance |
|---|---|---:|
| Before the update, previously committed value | Session B | 990.00 |
| After the update, before commit | Session A | 890.00 |
| Before commit, while Session A's change was uncommitted | Session B | 990.00 |
| After Session A executed `COMMIT` | Session B | 890.00 |

These results demonstrated that Session A could see its own update while Session B continued to see the previously committed value. After the commit, Session B could see the updated balance.

The configured transaction isolation level was checked using:

```sql
SELECT @@tx_isolation;
```

The server returned:

```text
REPEATABLE-READ
```

This confirms that the configured isolation level was `REPEATABLE-READ`. The observed two-session results demonstrate the visibility of committed and uncommitted changes in this test.

## 5. Concurrency Control and Row Locking

An additional test attempted to use `SELECT ... FOR UPDATE` through phpMyAdmin. However, the second session's update completed immediately, and blocking was not observed. Consequently, this test does not establish that row-lock blocking was successfully demonstrated.

- Was Session B blocked while the lock was held? **No blocking was observed.**
- Did Session B's update complete? **Yes. The update reported one row affected.**
- Was successful lock-based blocking demonstrated? **No.**

The initial phpMyAdmin test may not have maintained the intended transaction across separate requests. This is a possible explanation, not a confirmed cause. The subsequent command-line isolation test used two independent MariaDB sessions and provided the primary evidence of concurrency behaviour.

`SELECT ... FOR UPDATE` is intended to request a row lock that coordinates conflicting operations while a transaction remains active. However, the attempted test should not be presented as proof that blocking occurred.

## 6. Final Verification

After the isolation test and commit, the final balance query returned:

| Account ID | Account Name | Final Balance |
|---:|---|---:|
| 1 | Student Services Fund | 890.00 |
| 2 | Library Resources Fund | 500.00 |

These values represent the final state observed after the tests. The first account's balance reflects the committed 100.00 deduction in the isolation test. The second account remained at 500.00.

## 7. Limitations

The practical used a small, controlled demonstration table rather than the institution's operational records. It illustrates transaction behaviour but does not measure performance or establish how every production workload will behave.

The concurrency test required two independent database sessions. The command-line test successfully demonstrated the visibility of committed and uncommitted changes. However, the attempted `SELECT ... FOR UPDATE` test did not demonstrate blocking. The transfer test's final results also remain unverified.

Conclusions in this report are limited to the operations and outputs actually observed. Screenshots should be included to substantiate the reported results.

## 8. Conclusion

The practical demonstrated transaction control using `COMMIT` and `ROLLBACK`, verified the configured `REPEATABLE-READ` isolation level, and observed how two independent MariaDB sessions accessed committed and uncommitted changes. Session A observed its updated balance of 890.00, while Session B continued to observe the previously committed balance of 990.00. After Session A committed the transaction, Session B observed 890.00.

The attempted row-locking test did not demonstrate blocking, and the atomic transfer test remains unverified. These limitations have been stated explicitly rather than treating the intended outcomes as successful test results.

The results illustrate the importance of transaction management and isolation for database operations such as student registration and academic record updates, where concurrent access must not compromise data consistency.
