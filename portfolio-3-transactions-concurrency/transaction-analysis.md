# Transaction and Concurrency Analysis: Luma Polytechnic

## 1. ACID Properties in Context
The `luma_db` database relies on the InnoDB storage engine, which fully supports ACID properties:
- **Atomicity:** Demonstrated in Scenario 1. The grade update and any subsequent triggers either fully succeed (`COMMIT`) or fully fail (`ROLLBACK`). 
- **Consistency:** Foreign key constraints and CHECK constraints ensure the database never enters an invalid state, even during a transaction.
- **Isolation:** Managed via isolation levels (Scenario 3). The default `REPEATABLE READ` prevents dirty reads and non-repeatable reads.
- **Durability:** Once a transaction is committed, the changes are written to the InnoDB redo log and are permanent, even if the server crashes.

## 2. The Concurrency Issue: "Last Seat" Race Condition
In a polytechnic, multiple students might try to register for a course with only one seat left at the exact same millisecond. 
- **The Problem (Lost Update):** If two sessions check the capacity (`SELECT capacity...`), both see `1 > 0`, and both proceed to `INSERT` a registration. The capacity is exceeded, violating business rules.
- **The Solution (Pessimistic Locking):** We use `SELECT ... FOR UPDATE`. This places an **Exclusive Lock (X-lock)** on the selected row in the `course_offerings` table. 

## 3. Isolation Levels and Locks
- **Scenario 2 (Pessimistic Locking):** When Session 1 runs `SELECT ... FOR UPDATE`, it locks the row. When Session 2 tries to read the same row with `FOR UPDATE`, it is forced to wait (block) until Session 1 finishes. This guarantees that only one student gets the last seat.
- **Scenario 3 (Dirty Read):** By setting the isolation level to `READ UNCOMMITTED`, Session 2 bypassed the standard locks and read data that Session 1 had not yet committed. In a production academic system, this is dangerous (e.g., seeing a grade that the lecturer is still typing and might delete). We rely on the default `REPEATABLE READ` to prevent this.
