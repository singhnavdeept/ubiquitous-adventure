---
tags:
  - database/mysql
  - database/relational
  - database/internals
category: relational
created: 2026-06-15
---

# MySQL Architecture & InnoDB Overview

MySQL is the world's most popular open-source relational database. Understanding its architecture and default storage engine, InnoDB, is critical for backend engineers.

## 1. High-Level Architecture

MySQL uses a two-layer architecture that separates the core SQL server logic from how the data is stored and retrieved on disk:

```text
+-------------------------------------------------------------+
|                     Application Clients                     |
+-------------------------------------------------------------+
                              |
                              v (Connection Pooler)
+-------------------------------------------------------------+
|                      MySQL Server Layer                     |
|  - Connection Manager (Thread-per-connection)               |
|  - Parser & Preprocessor (AST creation)                     |
|  - Optimizer (Cost-based query optimizer)                   |
|  - Caching & Buffer Layers                                  |
+-------------------------------------------------------------+
                              |
                              v (Pluggable Storage Engine API)
+-----------------------------------+-------------------------+
|        InnoDB Engine              |      MyISAM / Memory    |
| (Clustered Index, MVCC, ACID)     |   (Table locks, Non-ACID)|
+-----------------------------------+-------------------------+
```

### Server Layer
Handles connections, authentication, query parsing, optimization, and logical functions (like window functions, views, and triggers).

### Storage Engine Layer
Implements the pluggable storage engine API. The engine is responsible for actual storage, retrieval, indexing, locking, and transaction consistency.

---

## 2. InnoDB Storage Engine Internals

InnoDB is the default, ACID-compliant storage engine for MySQL.

### Key Internals:
1. **Clustered Indexes (Primary Key):** InnoDB tables are organized on disk based on the primary key. The leaf nodes of the primary key index contain the actual row data (Clustered Index). Secondary indexes store the primary key values, not direct disk pointers.
2. **Buffer Pool:** A memory area where InnoDB caches table data and indexes. It uses a modified LRU (Least Recently Used) algorithm to keep hot pages in memory.
3. **Doublewrite Buffer:** Prevents data corruption caused by partial page writes (e.g., power loss during writing). Pages are written to a sequential Doublewrite buffer on disk before being flushed to their final data files.
4. **Redo Log (WAL) & Undo Log:**
   - **Redo Log:** Records physical changes to pages to guarantee durability (D in ACID). Used for crash recovery.
   - **Undo Log:** Stores older versions of rows to support rollbacks and MVCC (Multi-Version Concurrency Control).
