---
title: "Databases: Transaction Isolation Levels & Concurrency Anomalies"
tags:
  - databases
  - sql
  - transactions
  - acid
  - anomalies
  - isolation-levels
  - interview-prep
created: 2026-05-29
type: study-note
---

# Transaction Isolation & Concurrency Anomalies

---

## 1. Concurrency Anomalies: The Phenomena

When multiple database transactions run concurrently, race conditions can occur. These race conditions (anomalies) degrade database integrity. Standard SQL and modern engines define isolation levels based on which anomalies they prevent.

```
       TRANSACTION A                                TRANSACTION B
             |                                            |
    1. Read Balance ($100)                                |
             |                                  2. Update Balance ($100 -> $150)
             |                                  3. COMMIT!
    4. Read Balance ($150)                        |
   (Fuzzy / Non-Repeatable Read!)                 v
```

### 1. Dirty Write
* **Definition**: Transaction A overwrites a value written by concurrent Transaction B before Transaction B has committed.
* **Why it is dangerous**: 
  * If Transaction B later aborts, the database must roll back. In rolling back B's changes, it will also overwrite or discard A's updates.
  * Violates the core atomic property of transactions.
  * *Example*: Alice sets name to "Bob" on a record. Before she commits, Charlie sets the name to "Dave". If Alice aborts, the database reverts the record back to the original name, wiping out Charlie's update even if Charlie commits.

### 2. Dirty Read
* **Definition**: Transaction A reads data that has been modified by Transaction B, but has not yet been committed.
* **Why it is dangerous**: If Transaction B aborts and rolls back its changes, the data read by Transaction A is "garbage" data that technically never existed.
* **Example**: Alice transfers $100 to Bob. The system adds $100 to Bob's account but hasn't deducted it from Alice yet. Charlie reads Bob's balance and sees the extra $100. Alice's transaction then aborts due to insufficient funds. The database rolls back Bob's balance, but Charlie has already acted on the dirty read.

### 3. Non-Repeatable Read (Fuzzy Read)
* **Definition**: Transaction A reads a row value. Transaction B updates or deletes that row and commits. Transaction A re-reads the row and finds that the value has changed (or the row is deleted).
* **Scope**: Affects **existing single rows**.

### 4. Phantom Read
* **Definition**: Transaction A runs a query matching a search condition (e.g., `WHERE age > 30`). Transaction B inserts a **new row** matching that condition and commits. Transaction A re-runs the query and finds new "phantom" rows in the result set.
* **Scope**: Affects **range queries** (multiple rows).

### 5. Lost Update
* **Definition**: Transaction A and Transaction B read the same row balance concurrently. Both calculate a new value locally and write it back. The last write silently overwrites the first write, losing one of the updates.
* **Example**:
  1. Account balance is $100.
  2. Trans A reads balance ($100), adds $50 locally.
  3. Trans B reads balance ($100), adds $30 locally.
  4. Trans A writes balance = $150 and commits.
  5. Trans B writes balance = $130 and commits.
  6. *Result*: Balance is $130 instead of $180. Trans A's $50 update is lost.

### 6. Read Skew (Non-repeatable read across tables)
* **Definition**: A user reads different parts of the database at different times and sees inconsistent data states because a concurrent transaction committed updates in between.
* **Example**: Alice has $100 in checking, $100 in savings. Trans A reads checking ($100). Trans B transfers $50 from savings to checking and commits. Trans A reads savings ($50). Trans A thinks Alice only has $150 total, which is inconsistent.

### 7. Write Skew
* **Definition**: A generalization of Lost Update. Two concurrent transactions read the same data, evaluate a constraint, and update **different** rows, violating the global constraint.
* **Example**: A hospital requires at least one doctor on active call. Doctors Alice and Bob are both on call. 
  1. Both request leave.
  2. Trans A (Alice) checks if active doctor count $\ge 2$. It is.
  3. Trans B (Bob) checks if active doctor count $\ge 2$. It is.
  4. Trans A updates Alice to "on leave" and commits.
  5. Trans B updates Bob to "on leave" and commits.
  6. *Result*: Both doctors are on leave, leaving 0 active doctors.

---

## 2. Standard SQL Isolation Levels

To prevent these anomalies, the SQL-92 standard defines four isolation levels.

| Isolation Level      |  Dirty Read   | Non-Repeatable Read | Phantom Read  | Typical Implementation      |
| :------------------- | :-----------: | :-----------------: | :-----------: | :-------------------------- |
| **Read Uncommitted** |    Allowed    |       Allowed       |    Allowed    | No read locks.              |
| **Read Committed**   | **Prevented** |       Allowed       |    Allowed    | Short-lived read locks.     |
| **Repeatable Read**  | **Prevented** |    **Prevented**    |    Allowed    | Long-lived read locks.      |
| **Serializable**     | **Prevented** |    **Prevented**    | **Prevented** | Range/Next-Key locks (2PL). |

---

## 3. Modern Isolation Levels & MVCC Snapshot Isolation

Many modern databases (PostgreSQL, Oracle, MySQL InnoDB) do not use pure lock-based isolation. They use **[[Multi-Version Concurrency Control (MVCC)]]** to implement **Snapshot Isolation (SI)**.

### Snapshot Isolation
* **Core Principle**: *"Readers never block writers, and writers never block readers."*
* **How it works**: When a transaction starts, it receives a logical timestamp. The transaction reads a consistent "snapshot" of the database as of that timestamp. Any commits by concurrent transactions after this timestamp are ignored.
* **Anomalies Prevented**: Snapshot Isolation prevents Dirty Reads, Non-Repeatable Reads, Read Skew, and Lost Updates (using write conflict detection).
* **The Catch**: **Snapshot Isolation does NOT prevent Write Skew**. It is not fully Serializable.

---

## 4. Key Placement Interview Q&As

### Q1: What is the difference between a Non-Repeatable Read and a Phantom Read?
**Answer**:
* **Non-Repeatable Read**: Affects a **single existing row**. A transaction reads a row, a concurrent transaction *updates* that row's columns and commits, and the first transaction reads the row again to find different column values. Prevented by locking the row.
* **Phantom Read**: Affects a **set of rows matching a range query**. A transaction queries a range (e.g., `salary > 50000`), a concurrent transaction *inserts a new row* matching that range and commits, and the first transaction runs the query again, finding new "phantom" records. Prevented by range/gap locking.

### Q2: How does Write Skew occur, and how do you prevent it in Snapshot Isolation?
**Answer**: Write skew occurs when two concurrent transactions read the same state, verify a rule, and update *different* keys, resulting in a state that violates the rule (e.g., the two doctors taking leave simultaneously).
* **Prevention**:
  1. Force serializability: Run the database at the **Serializable** isolation level.
  2. Explicit locking: Force a read-lock on the checked rows using `SELECT ... FOR UPDATE` to serialize the transactions.
  3. Materialize conflicts: Create dummy rows representing the constraint and lock them.

### Q3: Why does Read Committed isolation still allow Non-Repeatable Reads?
**Answer**: Under Read Committed isolation, the database only guarantees that you read committed data. It implements this by acquiring a shared read lock *only when reading* a row, and **releasing the lock immediately after the read completes**. If Transaction A reads a row, releases the lock, and Transaction B updates that row and commits, Transaction A can read the row again and see the updated value within the same transaction.
