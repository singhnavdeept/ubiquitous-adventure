****Multi-Version Concurrency Control (MVCC)**** is a technique used in databases to allow many users to read and update data at the same time without blocking each other.

Instead of overwriting a record when it is updated, the database creates a new version of that record. This means:

- Readers can continue viewing the ****old version**** safely.
- Writers update a ****new version**** without stopping others.
- No read/write blocking happens.

MVCC helps prevent conflicts and reduces the need for strict locking, which keeps the database fast and responsive even when many users are working at once.

![419337644](https://media.geeksforgeeks.org/wp-content/uploads/20251206124420281709/419337644.webp "Click to enlarge")

  

### ****Why MVCC Is Used****

Databases often face concurrency problems when multiple transactions try to read or modify the same data.  
MVCC solves these problems by ****keeping multiple versions**** of each record, allowing:

- Safe concurrent reads
- Non-blocking updates
- Smooth performance under heavy load

If two transactions try to update the same item at the same time, MVCC may require one of them to ****retry**** the operation, ensuring consistency.

## ****Types of MVCC in DBMS****

### ****1. Timestamp-Based MVCC****

Each transaction is given a ****unique timestamp****.  
This timestamp decides which version of a record the transaction is allowed to read or update.  
A newer transaction will only see versions created ****before**** its timestamp.

****Use-case:**** Systems that need strict ordering of transactions.

### ****2. Snapshot-Based MVCC****

When a transaction starts, the database gives it a ****snapshot**** of the entire data at that moment.  
The transaction works on this stable snapshot even if other transactions update data in the meantime.

****Use-case:**** Databases like PostgreSQL that want consistent reads without locking.

### ****3. History-Based MVCC****

The database keeps a ****full history**** of all versions of a record.  
This makes rollbacks easier because the system can simply move back to an earlier version.

****Use-case:**** Systems requiring detailed version tracking or auditing.

### ****4. Hybrid MVCC****

This combines two or more MVCC techniques to balance:

- Performance
- Storage usage
- Version visibility

Databases may mix timestamp rules, snapshots, and historical tracking depending on workload.

****Use-case:**** Modern DBMS optimizing for mixed read/write workloads.

## How MVCC Works

- ****Each record has a version number**** that shows which version is the latest.
- ****Read operations always use the newest committed version****, so multiple users can read the same data at the same time without waiting.
- ****Write operations don’t overwrite the existing record.**** Instead, the system creates a ****new copy**** of the record.
- While a new version is being created, ****other users can still read the old version**** without interruption.
- After the write is successfully completed, the ****version number increases****, and the new version becomes the current one.
- Every future read or update uses this latest version, and the same cycle continues whenever updates happen.

## Implementation of Multi-Version Concurrency Control

- MVCC uses ****timestamps (TS)**** and ****increasing transaction IDs**** to maintain transactional consistency. It stores ****multiple versions of a data object****, ensuring that a transaction ****never waits to read**** an object.

Each object ****P**** maintains multiple versions, and every version has:

- ****Read Timestamp (RTS)**** – the largest timestamp of any transaction that has read that version
- ****Write Timestamp (WTS)**** – the timestamp of the transaction that wrote that version

A transaction ****Ti**** always reads the ****latest version whose WTS ≤ TS(Ti)****.

### ****Write Rules****

A transaction can write only if:

TS(Ti)≥RTS(P)

If:

TS(Ti)<RTS(P)

then the write would overwrite a version already read by a newer transaction — so ****Ti is aborted and restarted****.

If the write is allowed, ****Ti creates a new version of object P****, and its:

WTS=RTS=TS(Ti)

This ensures both ****serializability**** and ****non-blocking reads****.

## Advantages of Multi-Version Concurrency Control (MVCC) in DBMS

Below are some advantages of Multi-Version Concurrency Control in DBMS

- ****The reduced read-and-write**** ****necessity for database locks:**** The database can support many read-and-write transactions without locking the entire system thanks to MVCC.
- ****Increased Concurrency:**** This Enables several users to use the system at once.
- ****Minimize read operation delays:**** By enabling concurrent read operations, MVCC helps to cut down on read times for data.
- ****Accuracy and consistency:**** Preserves data integrity over several concurrent transactions.

## Disadvantages of Multi-Version Concurrency Control (MVCC) in DBMS

Below are some disadvantages of Multi-Version Concurrency Control in DBMS

- ****Overhead:**** Keeping track of many data versions might result in overhead.
- ****Garbage collecting:**** To get rid of outdated data versions, MVCC needs effective garbage collecting systems.
- ****Increase the size of the**** ****database:**** Expand the capacity of the database since MVCC generates numerous copies of the records and/or tuples.
- ****Complexity:**** Compared to more straightforward locking systems, MVCC usage might be more difficult.