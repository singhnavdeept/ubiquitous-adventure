---
tags:
  - concept/remembring
  - theory
  - "#mapper"
banner: a_cat_lying_on_a_piano.jpg
Date: 16-April-2026
---

## 🏗️ Core Foundation



- **[[1.1 Data Models]]** — relational, document, key-value, graph, columnar
- **[[1.2 Schema design & Normalization]]** — normalization (1NF–5NF), denormalization
- **[[1.3 Data types]]** — numeric, text, date/time, JSON, arrays, enums
- **[[1.4 Constraints]]** — primary key, foreign key, unique, check, not null
- **[[1.5 Indexes]]** — B-tree, hash, GiST, GIN, covering indexes, composite indexes

---

## 🔍 Querying

- **[[2.1 SQL fundamentals]]** — SELECT, JOIN, GROUP BY, ORDER BY, HAVING
- **[[2.2 Window Functions]]** — ROW_NUMBER, RANK, LEAD/LAG, PARTITION BY
- **CTEs** — recursive and non-recursive (`WITH` clauses)
- **Subqueries** — correlated vs non-correlated
- **Aggregations** — ROLLUP, CUBE, GROUPING SETS
- **Full-text search** — tsvector, tsquery, relevance ranking
- **Execution plans** — EXPLAIN, EXPLAIN ANALYZE, query cost

---

## ⚙️ Storage & Internals

- **Storage engines** — InnoDB, RocksDB, WiredTiger, LSM trees
- **Page/block storage** — how data is laid out on disk
- **Heap files vs clustered storage**
- **Write-Ahead Log (WAL)** — durability, crash recovery, log replay
- **Buffer pool / shared buffers** — caching pages in memory
- **Vacuuming / compaction** — reclaiming dead rows (MVCC cleanup)
- **Checkpointing** — flushing dirty pages to disk

---

## 🔐 Transactions & Consistency

- **ACID properties** — Atomicity, Consistency, Isolation, Durability
- **Isolation levels** — Read Uncommitted, Read Committed, Repeatable Read, Serializable
- **Concurrency anomalies** — dirty reads, phantom reads, non-repeatable reads
- **MVCC** — Multi-Version Concurrency Control
- **Optimistic vs pessimistic locking**
- **Deadlocks** — detection and prevention
- **Two-phase commit (2PC)** — distributed transactions
- **Savepoints** — partial rollbacks

---

## 📐 Distributed Systems Concepts

- **CAP theorem** — Consistency, Availability, Partition Tolerance
- **BASE** — Basically Available, Soft state, Eventually consistent
- **Sharding** — horizontal partitioning across nodes (hash vs range sharding)
- **Replication** — primary-replica, multi-primary, synchronous vs async
- **Consensus algorithms** — Raft, Paxos
- **Distributed transactions** — saga pattern, outbox pattern
- **Idempotency** — safe retries in distributed operations
- **Vector clocks / Lamport timestamps** — ordering events

---

## 🧩 Partitioning

- **Horizontal partitioning** — splitting rows across tables/nodes
- **Vertical partitioning** — splitting columns
- **Range, hash, list partitioning**
- **Partition pruning** — query optimization with partitions
- **Time-based partitioning** — common for logs/events

---

## 📈 Performance & Optimization

- **Query optimization** — planner statistics, cost models
- **Index strategies** — partial indexes, expression indexes, index-only scans
- **Connection pooling** — PgBouncer, HikariCP
- **Caching layers** — Redis, Memcached in front of DB
- **Slow query analysis** — pg_stat_statements, slow query log
- **N+1 problem** — and how to fix it
- **Materialized views** — pre-computed query results
- **Denormalization trade-offs**

---

## 🔄 Replication & High Availability

- **Streaming replication** — WAL shipping to replicas
- **Logical replication** — table-level, used for migrations/CDC
- **Failover & leader election**
- **Read replicas** — scaling reads
- **Lag monitoring** — replica lag and its impact

---

## 🛡️ Reliability & Operations

- **Backup strategies** — full, incremental, point-in-time recovery (PITR)
- **pg_dump / mysqldump / snapshot backups**
- **Change Data Capture (CDC)** — Debezium, logical decoding
- **Migrations** — schema versioning, zero-downtime migrations
- **Connection limits & overflow handling**

---

## 🧠 Advanced & Specialized

- **Time-series databases** — TimescaleDB, InfluxDB
- **Graph databases** — Neo4j, property graphs
- **Vector databases** — pgvector, Pinecone (for AI/ML)
- **NewSQL** — CockroachDB, Spanner, YugabyteDB
- **Event sourcing & CQRS** — storing state as events
- **Multitenancy patterns** — schema-per-tenant, row-level security
- **Row-Level Security (RLS)** — Postgres policies
- **Audit logging** — tracking who changed what

---

## 🔗 Ecosystem & Tooling

- **ORMs** — Prisma, SQLAlchemy, Hibernate — and their pitfalls
- **Query builders** — Knex, JOOQ
- **Database proxies** — RDS Proxy, ProxySQL
- **Observability** — metrics, tracing slow queries, pg_stat_* views
- **Schema diffing tools** — Liquibase, Flyway, Atlas

