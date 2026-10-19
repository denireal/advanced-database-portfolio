Statement of Concurrency Operation: Course Registration "Last Seat" Race Condition
1. The Scenario
In the Luma Polytechnic system, a specific course offering (offering_id = 1) has exactly one seat remaining (capacity = 1). Two students (Session A and Session B) attempt to register for this exact course at the exact same millisecond.
2. The Concurrency Issue (The Race Condition)
Without concurrency control, both sessions would execute a SELECT to check the capacity simultaneously. Both would read capacity = 1, both would determine that a seat is available, and both would proceed to INSERT a registration. This results in an overbooked course (2 students registered for 1 seat), violating the fundamental business rule of the system. This is a classic "Lost Update" race condition.
3. The Concurrency Control Mechanism: Pessimistic Locking
To prevent this, the database utilizes Pessimistic Locking via Exclusive Locks (X-Locks) provided by the InnoDB storage engine.
4. The Execution Sequence
Step 1 (Session A - Acquires Lock): Student A's session initiates a transaction (START TRANSACTION;) and executes an UPDATE (or SELECT ... FOR UPDATE) on the course_offerings row. InnoDB immediately places an Exclusive Lock (X-Lock) on this specific row.
Step 2 (Session B - Blocked): Student B's session simultaneously initiates a transaction and attempts to access the exact same row. Because Session A holds the Exclusive Lock, Session B's query is blocked. It enters a waiting state and cannot read or modify the row. (This is the state captured in the concurrency-evidence.png screenshot).
Step 3 (Session A - Commits): Session A successfully inserts the registration record, updates the capacity to 0, and executes COMMIT;. This releases the Exclusive Lock.
Step 4 (Session B - Resumes and Fails): Once the lock is released, Session B's query finally executes. It now reads the updated row and sees capacity = 0. The application logic (or a database trigger/check constraint) rejects the registration. Session B executes ROLLBACK; or COMMIT; without adding a student.
5. Isolation Level Context
This operation relies on InnoDB's default REPEATABLE READ isolation level, which enforces Strict Two-Phase Locking (2PL). Locks are held until the transaction is fully committed, ensuring that no other transaction can read or write to the locked row until the first transaction is completely finished, thereby guaranteeing data consistency and preventing overbooking.
