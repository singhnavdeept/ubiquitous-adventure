---
title: "Database Storage Engines: The Engines Beneath Your Data"
date: "2026-06-15"
excerpt: "How InnoDB, RocksDB, and WiredTiger store your bytes on disk, and why the choice between B-trees and LSM trees defines your database's soul."
tags: ["storage-engines", "innodb", "rocksdb", "wiredtiger", "lsm-trees", "b-trees", "database-internals"]
---

# Database Storage Engines: The Engines Beneath Your Data

You can swap a storage engine and keep the same SQL interface. Same `SELECT`, same `INSERT`, radically different performance characteristics. This is the promise of pluggable storage engines in MySQL and MongoDB, and it's why understanding what happens between your query and the disk platter is not academic—it's the difference between a database that purrs at 50,000 writes per second and one that seizes up at 5,000.

Storage engines are not an implementation detail. They are the physics of your database.

---

## The Two Fundamental Families

Every storage engine worth discussing belongs to one of two families. They solve the same problem—mapping keys to values on persistent storage—in opposite ways.

| Family                        | Core Data Structure           | Write Pattern             | Read Pattern                                             | Representative Engines                                     |
| :---------------------------- | :---------------------------- | :------------------------ | :------------------------------------------------------- | :--------------------------------------------------------- |
| **B-Tree / Page-Oriented**    | B⁺-Tree with fixed-size pages | In-place updates (mostly) | Excellent point reads and range scans                    | InnoDB, WiredTiger (default), PostgreSQL heap              |
| **LSM-Tree / Log-Structured** | Memtable + SSTables on disk   | Sequential writes only    | Point reads good; range scans decent; read amplification | RocksDB, LevelDB, WiredTiger (LSM mode), Cassandra storage |

The choice between them is fundamentally a choice about which resource you want to optimize: **read I/O** or **write I/O**. You can
not have both perfectly.

---

## The B-Tree Engine: InnoDB Deep Dive

InnoDB is the default storage engine in MySQL and MariaDB. It has been battle-tested across billions of deployments, and its architecture has remained remarkably stable because it solves the OLTP problem so well.

### How Data Is Organized

InnoDB stores data in a **clustered B⁺-Tree index**. The primary key is the clustered index. The leaf pages of this B-tree contain the **entire row data**.

```
[Root Page]
    |
[Internal Pages]  → contain key ranges + child page pointers
    |
[Leaf Pages]      → contain actual rows, linked in a doubly-linked list
```

Because leaf pages are linked, a range scan `WHERE id BETWEEN 100 AND 200` follows the links without traversing internal pages again. This is why B⁺-trees, not plain B-trees, are used in databases.

### Page Structure (16KB Default)

Every page in InnoDB is 16KB. A page contains:

| Section | Purpose |
| :--- | :--- |
| Page Header (38 bytes) | Page type, page number, LSN for recovery |
| Infimum/Supremum Records | Dummy records marking the logical start and end of the page |
| User Records | Your actual rows, stored in primary key order |
| Free Space | Available for new inserts or updates |
| Page Directory | Sparse index of record offsets within the page for binary search |
| Page Trailer (8 bytes) | Checksum for detecting corruption |

### Secondary Indexes

A secondary index in InnoDB is a separate B⁺-tree where:
- The key is the indexed column(s).
- The value is the **primary key** of the matching row.

A query using a secondary index therefore requires **two B-tree traversals**: one in the secondary index to find the primary key, and one in the clustered index to fetch the row. This is the price of having only one physical copy of the row.

### MVCC: The Undo Log

InnoDB implements Multi-Version Concurrency Control using an **undo log**. When a row is updated, InnoDB:
1. Writes the old version to the undo log.
2. Updates the row in-place in the B-tree leaf page.
3. Tags the old version pointer in the row header.

A long-running `SELECT` can walk the undo log chain to see the version that was current when its transaction began. This is elegant, but it means updates still touch the B-tree leaf page—InnoDB does in-place updates, which fragments pages over time.

### The Doublewrite Buffer

InnoDB writes data twice to prevent torn pages. A torn page is a page partially written when the power fails, which corrupts the B-tree structure.

1. Write pages sequentially to the **doublewrite buffer** on disk (1MB extent).
2. fsync.
3. Write pages to their actual locations in the tablespace (random I/O).

On recovery, InnoDB checks page checksums. If a page is corrupt, it replaces it from the doublewrite buffer. This adds write overhead but guarantees page-level integrity.

### Adaptive Hash Index

InnoDB monitors access patterns. If it detects frequent lookups on the same secondary index, it builds an in-memory **hash index** keyed by the indexed value, mapping directly to the primary key. This turns a two-step lookup into one, but consumes buffer pool memory. It is fully automatic and cannot be tuned directly—only disabled.

---

## The LSM Engine: RocksDB Deep Dive

RocksDB began at Facebook as a fork of Google's LevelDB, optimized for SSD storage and high write throughput. It is embedded inside MyRocks (MySQL), MongoDB (as an alternative to WiredTiger), Kafka Streams, and countless other systems.

### The Core Idea: Write Everything Sequentially

LSM stands for **Log-Structured Merge-Tree**. The fundamental insight is that random disk writes are slow, but sequential writes are fast—even on SSDs. So RocksDB never overwrites data in place. Every write is an append.

### The Write Path

```text
[Write arrives]
    |
    v
[Write-Ahead Log (WAL)]   ← Sequential append for durability
    |
    v
[Active Memtable]         ← In-memory balanced tree (skip list by default)
    |
    v (when memtable is full, typically 64MB)
[Immutable Memtable]      ← Frozen, waiting to be flushed
    |
    v (background flush thread)
[SSTable on Disk (Level 0)] ← Sorted string table, immutable
```

An SSTable (Sorted String Table) is a file containing key-value pairs sorted by key, plus an index block for fast lookups. Once written, it is never modified.

### The Read Path and Read Amplification

A read for key `K` proceeds as follows:
1. Check Active Memtable.
2. Check each Immutable Memtable.
3. Check SSTables in Level 0 (worst case: all of them, since Level 0 files can overlap).
4. Check SSTables in Level 1+, using bloom filters to skip files that definitely don't contain `K`.

The read amplification—the number of files consulted—grows with the number of SSTables. This is the primary weakness of LSM trees.

### Compaction: The Background Magician

Compaction is the process of merging SSTables from Level N into Level N+1, discarding old versions of keys and deleted tombstones. It reduces read amplification and reclaims disk space.

RocksDB supports multiple compaction strategies:

| Strategy | Behavior | Best For |
| :--- | :--- | :--- |
| **Leveled** | Each level is 10x larger than the previous; files within a level are non-overlapping | General-purpose, read-heavy |
| **Tiered / Universal** | Merge files when enough accumulate, regardless of level | Write-heavy, time-series |
| **FIFO** | Drop oldest files when DB size exceeds limit | Event streaming, logs |

**Write amplification** is the hidden cost: a single byte written by the user may be rewritten many times during compaction. In the worst case (Leveled compaction, large database), write amplification can reach 20-30x. This is the primary weakness of LSM trees on spinning disks.

### Bloom Filters

RocksDB builds a bloom filter per SSTable. Before scanning a file, the filter is queried: "Is key K possibly in this file?" If the filter says no, the file is skipped entirely. This is critical for point lookup performance and is why tuning bloom filter bits-per-key (default 10) matters on read-heavy workloads.

### The WAL and Sync Tuning

RocksDB offers fine-grained control over durability:

```cpp
// Every write is synced to WAL before returning (safest, slowest)
write_options.sync = true;

// Writes go to OS buffer; synced periodically (fast, can lose recent writes)
write_options.sync = false;
```

For many applications, batching writes and syncing periodically is sufficient, and the throughput difference can be 10x.

---

## WiredTiger: The Hybrid

WiredTiger is MongoDB's default storage engine since version 3.2. It is neither a pure B-tree nor a pure LSM—it can be **configured as either**.

### B-Tree Mode (Default)

WiredTiger's B-tree implementation differs from InnoDB in key ways:

- **No clustered index:** Data is stored in B-trees by an internal record ID, not the user-visible primary key. All indexes (including `_id`) are secondary and store record IDs.
- **Copy-on-write pages:** Instead of in-place updates, WiredTiger writes updated pages to **new disk locations** and updates parent pointers. This avoids the need for a doublewrite buffer—a partially written page simply points to the old, intact location.
- **Checkpointing:** WiredTiger takes periodic snapshots of the B-tree state. Between checkpoints, durability is provided by the write-ahead log (journal).

### LSM Mode

WiredTiger can be configured with `--wiredTigerCollectionConfigString="type=lsm"` to use an LSM tree instead. This is optimized for write-heavy workloads where the operational simplicity of MongoDB is desired but InnoDB-like B-tree write amplification is unacceptable.

### Document-Level Concurrency

WiredTiger uses **optimistic concurrency control** at the document level. Transactions validate at commit time that no conflicting writes occurred. This gives higher throughput for workloads with low contention compared to InnoDB's row-level locking.

---

## The Decisive Comparison

### Write Amplification

| Engine | Amplification Factor | Notes |
| :--- | :--- | :--- |
| **InnoDB** | 2-3x | Doublewrite buffer + secondary index updates + page splits |
| **RocksDB (Leveled)** | 10-30x | Compaction rewrites data at each level transition |
| **RocksDB (Tiered)** | 5-10x | Fewer merges, but read amplification increases |
| **WiredTiger (B-Tree)** | 2-3x | Journal writes + checkpoint rewrites |

### Read Amplification

| Engine | Point Lookup | Range Scan | Notes |
| :--- | :--- | :--- | :--- |
| **InnoDB** | ~1-2 page reads | 1 seek + sequential reads | Buffered and predictable |
| **RocksDB** | Depends on bloom filter hit rate | May consult many SSTables | Bloom filters are critical |
| **WiredTiger (B-Tree)** | ~1-2 page reads | Sequential within page chain | Similar to InnoDB |

### Storage Space

| Engine | Space Efficiency | Notes |
| :--- | :--- | :--- |
| **InnoDB** | ~70% of raw data | Page fill factor ~15/16; fragmentation from updates |
| **RocksDB** | ~50-60% of raw data | SSTable compression (Snappy, Zstd) highly effective |
| **WiredTiger** | ~40-50% of raw data | Snappy compression by default; block-level compression |

---

## Selection Guide: Which Engine for Which Job?

| Workload | Recommended Engine | Reason |
| :--- | :--- | :--- |
| **OLTP (many small reads/writes)** | InnoDB | Predictable B-tree performance; mature MVCC |
| **High-volume writes (logs, IoT, events)** | RocksDB (LSM) | Sequential writes minimize disk I/O |
| **Mixed reads and writes, moderate scale** | WiredTiger (B-tree) | Good balance; MongoDB ecosystem |
| **Dense, rarely-updated analytics** | RocksDB (LSM) | Excellent compression; scan-friendly with tuning |
| **Strict ACID, many secondary indexes** | InnoDB | Clustered primary; well-tested foreign key support |
| **Embedded / edge device** | RocksDB | Small footprint; no separate server process needed |

---

## Configuration Parameters That Matter

### InnoDB

```
innodb_buffer_pool_size       = 70-80% of available RAM   -- Single most important parameter
innodb_log_file_size          = 2-4 GB                     -- Larger = less checkpoint pressure
innodb_flush_method           = O_DIRECT                   -- Avoids double-buffering with OS cache
innodb_io_capacity            = 2000 (SSD) / 200 (HDD)     -- Background I/O rate limit
innodb_page_size              = 16KB (default)             -- Changing requires full rebuild
```

### RocksDB

```
write_buffer_size             = 64MB-256MB                 -- Memtable size
max_write_buffer_number       = 3-4                        -- Immutable memtable count
level0_file_num_compaction_trigger = 4                     -- When to compact Level 0
max_bytes_for_level_base      = 512MB                      -- Level 1 target size
compression                   = kLZ4Compression / kZSTD    -- LZ4 faster; Zstd denser
bloom_filter_bits_per_key     = 10                         -- 10 = ~1% false positive rate
```

### WiredTiger

```
wiredTigerCacheSizeGB         = 50% of RAM                 -- Default is generous
wiredTigerJournalCompressor   = snappy                     -- Compress WAL entries
wiredTigerCollectionBlockCompressor = snappy               -- Block-level compression
wiredTigerCheckpointSizeMB    = 1-2 GB                     -- Dirty data before forced checkpoint
```

---

## The Engine Is a Choice, Not an Identity

MySQL and MongoDB both allow engine selection per-table. You can have `orders` in InnoDB for transactional integrity and `analytics_events` in MyRocks (RocksDB-based) for write throughput—both queryable from the same application.

The storage engine is not the database. It is the physical translation layer between your logical data model and the magnetic or flash cells that actually store the bits. Choose it with the same care you'd choose a foundation for a building: invisible when done right, catastrophic when done wrong.

---

*Further reading: "Designing Data-Intensive Applications" by Martin Kleppmann, Chapter 3 (Storage and Retrieval); MySQL Internals Manual; RocksDB Wiki (github.com/facebook/rocksdb).*