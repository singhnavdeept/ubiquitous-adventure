---
title: "Databases: Concurrency Control & Database Locking"
tags:
  - databases
  - sql
  - locks
  - 2pl
  - concurrency-control
  - gap-locks
  - interview-prep
created: 2026-05-29
type: study-note
---

# Database Locks & Concurrency Control

---

## 1. Shared (S) and Exclusive (X) Locks

Locking is the primary pessimistic mechanism used by database engines to enforce transactional isolation.

* **Shared Lock (S / Read Lock)**: Acquired by a transaction that wants to read a row. Multiple transactions can hold shared locks on the same row concurrently.
* **Exclusive Lock (X / Write Lock)**: Acquired by a transaction that wants to update or delete a row. Only one transaction can hold an exclusive lock. It blocks all other transactions from acquiring any lock (S or X) on that row.

### Lock Compatibility Matrix

| Lock Requested | Shared (S) | Exclusive (X) |
| :--- | :---: | :---: |
| **Shared (S)** | **Compatible (Ok)** | Conflict (Block) |
| **Exclusive (X)** | Conflict (Block) | Conflict (Block) |

---

## 2. Hierarchical Locking & Intent Locks

To perform DDL operations (like dropping a table or altering a schema), the database engine must lock the entire table. However, checking every single row to see if a transaction holds a lock would be highly inefficient ($O(N)$ complexity).
To solve this, databases use **Intent Locks** at higher levels of the storage hierarchy (e.g., table level).

```
                      [ Table Level ]  <--- (Intent Locks: IS / IX)
                             |
                      [ Page Level ]
                             |
                       [ Row Level ]   <--- (S / X Locks)
```

### Types of Intent Locks:
* **Intent Shared (IS)**: Indicates that a transaction intends to set Shared (S) locks on individual rows inside the table.
* **Intent Exclusive (IX)**: Indicates that a transaction intends to set Exclusive (X) locks on individual rows inside the table.

### Hierarchical Lock Compatibility Matrix:

| Lock Held \ Requested | IS | IX | S | SIX | X |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Intent Shared (IS)** | **Ok** | **Ok** | **Ok** | **Ok** | Block |
| **Intent Exclusive (IX)** | **Ok** | **Ok** | Block | Block | Block |
| **Shared (S)** | **Ok** | Block | **Ok** | Block | Block |
| **Shared + Intent Exclusive (SIX)**| **Ok** | Block | Block | Block | Block |
| **Exclusive (X)** | Block | Block | Block | Block | Block |

* *Rule*: Before a transaction can acquire an S-lock on a row, it must first acquire an **IS** or **IX** lock on the parent table. Before it can acquire an X-lock on a row, it must acquire an **IX** lock on the parent table.

---

## 3. Two-Phase Locking (2PL)

**Two-Phase Locking (2PL)** is a protocol that guarantees **Serializability**. It dictates how locks are acquired and released during a transaction's lifecycle.

```
       Lock Count
          ^
          |        /---------\  (Commit / Rollback)
          |       /           \
          |      /             \
          |     /               \
          +----+-----------------+------> Time
             Growing Phase    Shrinking Phase
```

### The Two Phases:
1. **Growing Phase**: A transaction may acquire locks but cannot release any.
2. **Shrinking Phase**: A transaction may release locks but cannot acquire any new ones.

---

### 2PL Variants

#### 1. Strict 2PL
* **Rule**: The transaction must hold all **Exclusive (X) locks** until it commits or aborts. Shared (S) locks can be released during the shrinking phase.
* **Why it matters**: Prevents **Cascading Aborts**. If Transaction A updates a row, releases the lock, and Transaction B reads it and commits before A aborts, the database cannot easily roll back A without violating B's committed state.

#### 2. Rigorous (Strong Strict) 2PL
* **Rule**: The transaction must hold **both Shared (S) and Exclusive (X) locks** until it commits or aborts. No shrinking phase is allowed prior to commit.
* **Why it matters**: Easiest to implement and guarantees strict serializability, but reduces concurrent performance.

---

## 4. Gap Locks & Next-Key Locks (MySQL InnoDB)

Under the **Repeatable Read** isolation level, MySQL InnoDB uses Gap Locking to prevent **Phantom Reads** without requiring full table locks.

```
Index Values:      [ 10 ]               [ 20 ]               [ 30 ]
                         \             /      \             /
Gaps:                     ( Gap: 11-19 )       ( Gap: 21-29 )
```

### A. Gap Lock
* **Definition**: A lock placed on a gap *between* index records, or on the gap before the first or after the last index record.
* **Purpose**: Prevents other transactions from inserting new values into the gap. E.g., a gap lock on the range `(10, 20)` blocks another transaction from running `INSERT INTO table (id) VALUES (15)`.

### B. Next-Key Lock
* **Definition**: A combination of a **Record Lock** on the index record and a **Gap Lock** on the gap *before* that index record.
* **Example**: If an index contains values 10, 20, and 30, the next-key locks cover:
  * `( -∞, 10 ]`
  * `( 10, 20 ]`
  * `( 20, 30 ]`
  * `( 30, +∞ )`

---

## 5. Optimistic vs. Pessimistic Concurrency Control

| Dimension | Pessimistic Concurrency Control | Optimistic Concurrency Control (OCC) |
| :--- | :--- | :--- |
| **Core Assumption** | Conflicts are highly likely; lock early. | Conflicts are rare; validate late. |
| **Locking Overhead** | High: Blocks reads/writes using S/X locks. | Low: No locks held during read phase. |
| **Conflict Resolution** | Transactions block and wait. | Fails at commit; forces transaction abort & retry. |
| **Best Suited For** | High-conflict, write-heavy environments. | Low-conflict, read-heavy environments. |

---

## 6. Deadlock Handling

Since pessimistic locking causes transactions to wait, cycles of dependency can occur (Deadlocks).

```
Transaction A (Holds Lock on Row 1) -------> Requests Lock on Row 2 (Held by B)
       ^                                                    |
       |                                                    v
Requests Lock on Row 1 (Held by A) <------- Transaction B (Holds Lock on Row 2)
```

### A. Deadlock Prevention Algorithms
To prevent deadlocks, transactions are assigned timestamps when they start.

#### 1. Wait-Die Scheme (Non-preemptive)
* If **Older** requests resource held by **Younger**: Older is allowed to **wait**.
* If **Younger** requests resource held by **Older**: Younger **dies** (aborts and restarts).

#### 2. Wound-Wait Scheme (Preemptive)
* If **Older** requests resource held by **Younger**: Older **wounds** Younger (forces Younger to abort and release the lock).
* If **Younger** requests resource held by **Older**: Younger is allowed to **wait**.

---

## 7. Key Placement Interview Q&As

### Q1: What is the purpose of Intent Locks in hierarchical database locking?
**Answer**: Intent locks (IS/IX) are set at the table level to indicate that a transaction has locked (or intends to lock) individual rows inside that table. They prevent table-level locks (e.g., from DDL queries) from conflicting with row-level locks without requiring the database engine to scan all rows in the table.

### Q2: How does MySQL InnoDB prevent Phantom Reads under the Repeatable Read isolation level?
**Answer**: InnoDB uses **Next-Key Locks** (which combine record locks with gap locks). When a query scans a range of index values, InnoDB locks not only the matching index records but also the gaps between them. This prevents other concurrent transactions from inserting new rows into those gaps, eliminating phantom reads.

### Q3: Under what traffic conditions is Optimistic Concurrency Control (OCC) preferred over Pessimistic locking?
**Answer**: OCC is preferred in **read-heavy, low-conflict environments** (e.g., catalog browsing or content management systems). Because it avoids locking overhead during reads, it maximizes throughput. However, in high-conflict, write-heavy environments (e.g., flash sales or ticket bookings), OCC leads to excessive transaction aborts and retries, degrading performance. Pessimistic locking is preferred in those cases.
