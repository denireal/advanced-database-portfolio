# Transactions and Concurrency Control Analysis

## 1. ACID Properties in the Academic Portal
To maintain database reliability during concurrent user operations (such as hundreds of students registering for courses simultaneously during portal opening hours), transactions must satisfy ACID properties:
* **Atomicity:** All operations within a course registration or grade entry block execute successfully, or the entire transaction is rolled back.
* **Consistency:** Database constraints (such as primary keys, unique sessions, and check constraints on scores) are preserved before and after execution.
* **Isolation:** Concurrent transactions execute independently without interfering with each other.
* **Durability:** Once a transaction is committed, changes are permanently saved even in the event of a system crash.

---

## 2. Concurrency Phenomena & Isolation Levels
Without proper transaction isolation, concurrent database access can introduce anomalies:
1. **Dirty Read:** Reading uncommitted data from another concurrent transaction that later rolls back.
2. **Non-Repeatable Read:** Retrieving a row twice within a transaction and getting different values because another transaction modified and committed changes in between.
3. **Phantom Read:** Observing new rows appearing or disappearing in a range query because another transaction inserted or deleted rows concurrently.

### SQL Isolation Levels Used:
* **`REPEATABLE READ` (Default in MySQL/InnoDB):** Prevents dirty reads and non-repeatable reads by utilizing multi-version concurrency control (MVCC) and next-key locking.
* **`SERIALIZABLE`:** The strictest isolation level. It places range locks on reads, completely preventing phantom reads at the cost of concurrency throughput.

---

## 3. Concurrency Control Mechanism (`SELECT ... FOR UPDATE`)
During high-stakes operations like grade entries or slot reservations, race conditions can occur if two administrative users modify the same record simultaneously. 
* **Implementation:** We utilize pessimistic locking via `SELECT ... FOR UPDATE`. This locks the specific record rows until the active transaction completes (`COMMIT` or `ROLLBACK`), blocking other transactions from altering or overwriting the data until safety is guaranteed.
