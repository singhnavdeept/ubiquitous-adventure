---
title: "Distributed Systems: The CAP Theorem & PACELC Extension"
tags:
  - databases
  - distributed-systems
  - cap-theorem
  - pacelc
  - study-guide
created: 2026-05-29
type: study-note
---

# The CAP Theorem & PACELC: Theory, Trade-offs, and Database Selection

---

## 1. What is the CAP Theorem?

Formulated by Eric Brewer in 2000 and mathematically proved by Seth Gilbert and Nancy Lynch in 2002, the **CAP Theorem** is a foundational principle in distributed systems design. 

It states that any distributed data store can simultaneously provide at most two of the following three guarantees:

```
                            +-----------------------+
                            |      CAP Theorem      |
                            +-----------+-----------+
                                        |
             +--------------------------+--------------------------+
             |                          |                          |
             v                          v                          v
      [ Consistency (C) ]       [ Availability (A) ]    [ Partition Tolerance (P) ]
     (Linearizability:          (Every non-failing       (System operates
      latest write or            node returns a           despite dropped
      an error)                  non-error response)      network packets)
```

1. **Consistency (C)**: Specifically refers to **Linearizability (Strong Consistency)**. Every read operation must return the most recent write or result in an error. The system behaves as if there is only a single, atomic copy of the data.
   > [!IMPORTANT]
   > Do not confuse **Consistency in CAP** with **Consistency in ACID** (RDBMS transactions). 
   > * *CAP Consistency* = Single-copy register behavior (all nodes see the exact same state at the same time).
   > * *ACID Consistency* = Database integrity (transactions transition the database from one valid state to another, preserving constraints like foreign keys).
2. **Availability (A)**: Every non-failing node must return a non-error response for every received request.
   > [!NOTE]
   > Availability in CAP is a strict binary: returning a stale or outdated record is considered "available," but returning a timeout, an error, or blocking the request is considered "unavailable."
3. **Partition Tolerance (P)**: The system continues to operate despite an arbitrary number of messages being dropped or delayed by the network between nodes (a network partition).

---

## 2. The Inevitability of "P" (The CAP Choice Reality)

In distributed systems, **network partitions are a physical inevitability**. Switch failures, network congestion, fiber-optic cable cuts, and garbage collection pauses will eventually divide your cluster into isolated segments.

```
       Segment A (Active Client)                 Segment B (Isolated Client)
     +--------------------------+              +--------------------------+
     | Node 1 (Value = "Blue")  |              | Node 2 (Value = "Green") |
     +--------------------------+              +--------------------------+
                  \                                  /
                   \                                /
                    \----x---[ NETWORK PARTITION ]-/
```

Because you cannot choose "no partitions," **the choice is never "CA"**. If the network partitions, you have exactly two choices:

### Choice 1: CP (Consistency + Partition Tolerance)
* **Behavior**: If Node 1 and Node 2 cannot communicate, Node 2 will refuse to answer a read request (or will throw an error) because it cannot verify if Node 1 has received a newer write.
* **Trade-off**: The system preserves absolute data correctness but **sacrifices availability**.

### Choice 2: AP (Availability + Partition Tolerance)
* **Behavior**: If a partition occurs, Node 2 will immediately answer the read request with its local, potentially stale data ("Green"), even if Node 1 just wrote "Blue".
* **Trade-off**: The system remains highly responsive but **sacrifices consistency** (eventual consistency).

---

## 3. Beyond CAP: The PACELC Theorem

In 2012, Daniel Abadi noted that CAP only describes system behavior **during a network partition**. What about normal operation, which constitutes $99.9\%$ of a database's lifecycle?

The **PACELC Theorem** extends CAP by adding **Latency (L)** and **Consistency (C)** trade-offs:

$$\text{If there is a } \mathbf{P}\text{artition, trade-off } \mathbf{A}\text{vailability vs. } \mathbf{C}\text{onsistency};$$
$$\text{Else (}\mathbf{E}\text{), trade-off } \mathbf{L}\text{atency vs. } \mathbf{C}\text{onsistency}.$$


![[PACELC_theorem.png]]
### Common PACELC Database Classifications:

* **MongoDB (PA/EL)**: 
  * *If Partition*: Sacrifices Availability to maintain Consistency (primary step-down and secondaries election).
  * *Normal state*: Sacrifices Consistency to maintain low Latency (reads/writes are served by the primary node without waiting for synchronous replication, unless configured with high write concern).
* **Cassandra (PA/EL)**:
  * *If Partition*: Highly Available (AP).
  * *Normal state*: Achieves low Latency (EL) by default because client operations write locally without waiting for global node consensus.
* **Relational DBs / Spanner (PC/EC)**:
  * *If Partition*: Chooses Consistency (PC) over Availability.
  * *Normal state*: Chooses Consistency (EC) over Latency (uses two-phase commits and synchronous replication, meaning writes block until remote nodes acknowledge).

---

## 4. How to Choose: Database Comparison & Decision Tree

### A. Database Characteristics

| Database | CAP Classification | PACELC Classification | Replication Model | Ideal Use Case |
| :--- | :--- | :--- | :--- | :--- |
| **PostgreSQL / MySQL** | **CP** (Configurable to AP) | **PC/EC** (Synchronous) <br>**PA/EL** (Asynchronous) | Single Master / Multi-Replica | Standard business applications, relational schemas, strict financial ledger accounting. |
| **Cassandra** | **AP** | **PA/EL** | Masterless Peer-to-Peer | High-volume time-series, log ingestion, IoT metrics where write downtime is unacceptable. |
| **MongoDB** | **CP** | **PA/EL** | Replica Sets (Single Active Primary) | Document storage, content management, semi-structured catalogs requiring rapid updates. |
| **HBase** | **CP** | **PC/EC** | Single Master / HRegionServers on HDFS | Real-time, sparse column lookup on massive Hadoop clusters. |
| **CockroachDB / Spanner** | **CP** | **PC/EC** | Raft / Paxos consensus consensus | Globally distributed transactional SQL databases with strict consistency. |

---

### B. Architectural Decision Tree

Use this flow to select the correct architecture for your system design interviews:

```
                                     [ Architecture Choice ]
                                                |
                       +------------------------+------------------------+
                       |                                                 |
            [ Is write correctness critical? ]   [Is write downtime unacceptable?]
                       |                                                 |
             +---------+---------+                             +---------+--------+
             |                   |                             |         
             v                   v                             v                  v
          [ Yes ]              [ No ]                       [ Yes ]          [ No ]
         (Billing,           (Likes, Feeds,          (IoT logs,         (Inventory,
          Ledgers)            Social logs)             Metrics)          Catalogs)
             |                   |                             |                  |
             v                   v                             v                  v
          [ CP ]              [ AP ]                        [ AP ]           [ CP ]
```

#### Scenario 1: Financial Transaction Ledger
* *Requirement*: You cannot show a user an incorrect account balance. If a network split occurs, you must block transactions.
* *Decision*: **CP (PC/EC)**. Use a relational database with synchronous replication or a distributed SQL database (CockroachDB/Raft).

#### Scenario 2: Social Media Feed / "Likes" Counter
* *Requirement*: If a network partition occurs between US and EU, users must still be able to hit the "Like" button. It is acceptable if the count takes 10 seconds to synchronize across regions.
* *Decision*: **AP (PA/EL)**. Use Cassandra or DynamoDB with eventual consistency.

#### Scenario 3: Real-Time Inventory Management
* *Requirement*: You cannot sell the same physical ticket to two different users (double-booking).
* *Decision*: **CP (PC/EC)**. Better to show an "Error: System Busy" page (sacrificing availability) than to sell one seat to two customers.

---

## 5. Key Interview Q&As

### Q1: Why is a "CA" database physically impossible?
**Answer**: A "CA" database claims to guarantee both consistency and availability without partition tolerance. However, a network partition is a physical hardware constraint caused by network cable cuts or switch failures. If a partition occurs, nodes *cannot* communicate. In this state, a database *must* make a choice: either answer queries using stale local data (violating Consistency) or refuse to answer (violating Availability). It is impossible to preserve both when communication is severed.

### Q2: What is the relation between ACID and CAP?
**Answer**: 
* **ACID** describes properties of database transactions on a **single logical system** (primarily focused on concurrency control, locking, and crash recovery).
* **CAP** describes properties of data replicas in a **distributed system** over a network. 
* Only **Consistency** overlaps in terminology, but they mean different things: ACID Consistency means database rules (constraints, keys) are maintained, while CAP Consistency means all nodes read the same value (linearizability).

### Q3: How does Cassandra achieve high Availability (AP) during a partition, and how does it reconcile data later?
**Answer**: Cassandra uses a masterless peer-to-peer ring. During a partition, clients can write to any available node. The active node stores the write locally and registers a **Tombstone** or **Hinted Handoff** (a record indicating a write is pending for the partitioned node). When communication is restored, Cassandra reconciles data asynchronously using:
1. **Read Repair**: When a client reads, Cassandra queries multiple replicas, compares timestamps, returns the newest, and writes the updated value back to stale nodes.
2. **Anti-Entropy Node Sync**: A background process running Merkle Trees to identify and sync data differences.
