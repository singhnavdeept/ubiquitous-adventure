---
title: "Page and Block Storage: How Data Is Laid Out on Disk"
date: "2026-06-15"
excerpt: "Inside the 16KB universes where your rows live—how databases organize pages, link them together, and why a single byte update can rewrite an entire block."
tags: ["storage-engines", "page-storage", "block-storage", "database-internals", "disk-layout", "innodb", "postgresql"]
---

# Page and Block Storage: How Data Is Laid Out on Disk

A database does not store rows. It stores pages. The row is an abstraction the storage engine constructs for you by reading a 16KB block of raw bytes from disk, parsing its internal structure, and extracting the slice that represents your data. If you do not understand the page, you do not understand why some queries are fast and some are slow—or why a single `UPDATE` can cascade into five disk writes.

This note covers the physical layout of data on disk: the page as the universal unit of I/O, how rows are arranged inside pages, how pages link together, and the engineering consequences of this design.

---

## Why Pages Exist

Operating systems read and write files in blocks (typically 4KB). Databases work in pages—typically 8KB or 16KB—which are multiples of the OS block size. The page is the **atomic unit of I/O**: the database never reads or writes less than one page. Every index traversal, every heap fetch, and every buffer pool lookup operates at page granularity.

**The implication:** If your row is 100 bytes, reading it still brings 16KB into memory. The database bets that nearby rows (spatial locality) will be accessed soon.

---

## Anatomy of a Page

Every database page, regardless of engine, has the same basic structure:

```text
┌──────────────────────────────┐
│       Page Header            │  ← Metadata: page type, page number, checksum, LSN
├──────────────────────────────┤
│       Item Pointers          │  ← Array of offsets pointing to actual rows
├──────────────────────────────┤
│       Free Space             │  ← Gap that shrinks as rows are inserted
│                              │
├──────────────────────────────┤
│       Row Data               │  ← Actual bytes, growing from the bottom upward
│       (grows upward)         │
└──────────────────────────────┘
│       Page Trailer           │  ← Optional checksum copy or parity info
└──────────────────────────────┘
```

**Critical detail:** Item pointers grow downward from the header. Row data grows upward from the footer. The page is full when the two meet. This dual-direction growth avoids fragmentation within a page until it is completely packed.

---

## The Page Header: The Meta-Layer

The header contains the information the database needs to manage the page itself—not the rows within it. Key fields:

| Field | Purpose |
| :--- | :--- |
| **Page Type** | Data page, index page, undo page, overflow page, etc. |
| **Page Number** | Unique identifier within the tablespace |
| **Checksum** | Detects torn or corrupted pages after crash |
| **LSN (Log Sequence Number)** | Last WAL entry that modified this page; critical for recovery |
| **Number of Items / Free Space Offset** | Where the free space begins |
| **Previous / Next Page** | For doubly-linked leaf page chains (range scans) |

---

## Row Storage Within a Page

### Fixed-Length vs. Variable-Length Rows

**Fixed-length rows** (rare): Every row has the same byte count. The database can compute row N's position directly. This is fast and dead simple.

**Variable-length rows** (dominant): Rows contain `VARCHAR`, `TEXT`, or nullable columns. The database uses an **offset array** (item pointers) at the top of the page. Each pointer stores the byte offset where that row begins.

To read row 5, the database:
1. Goes to item pointer slot 5.
2. Reads the offset.
3. Seeks to that offset in the page.
4. Parses the row header and column data.

If a row is deleted, the item pointer is marked as deleted but the slot remains. Physical space is reclaimed later (by `OPTIMIZE TABLE` in MySQL, `VACUUM` in PostgreSQL).

### The Row Header

Before any column data, the row has a header that stores:

| Field | Purpose |
| :--- | :--- |
| **Row Type** | Normal, deleted, infimum, supremum, overflow pointer |
| **Next Record Offset** | Points to the next row in the page (used for heap traversal) |
| **Null Bitmap** | Which columns in this row are NULL |
| **Transaction ID** | (MVCC systems) Which transaction created this row |
| **Rollback Pointer** | (MVCC systems) Points to undo log for previous version |

### Null Handling

A column declared `NULL` does not occupy space. The null bitmap in the row header has one bit per nullable column. If bit is 0, the column is present; if 1, it is `NULL` and the data area omits it entirely.

**Engineer's note:** This is why `NOT NULL` declarations are not just safety checks—they eliminate the null bitmap overhead for that column across millions of rows.

---

## Page Types: One Page, Many Roles

Databases use the same 16KB structure for different purposes. Common page types:

| Page Type | Purpose | Structure |
| :--- | :--- | :--- |
| **Data Page (Leaf Page)** | Stores actual rows in a table or clustered index | Rows sorted by primary key; linked to next/prev leaf |
| **Index Page (Internal Page)** | Internal node of a B-tree | Keys + child page pointers; no row data |
| **Undo Page** | Stores old row versions for MVCC and rollback | Log-style; appended, not updated in-place |
| **Overflow Page (TOAST/BLOB Page)** | Stores large values that don't fit in a data page | Chained pages containing portions of a single value |
| **Bitmap Page (Allocation Map)** | Tracks which data pages are free or used | Bit array: 1 bit per data page |

---

## The Overflow Problem: TOAST, BLOBs, and Off-Page Storage

A single row in a relational database cannot span pages. The row must fit within the page's free space. But what happens when a `TEXT` column contains a 500KB document?

The answer is **off-page storage**:

**PostgreSQL (TOAST — The Oversized-Attribute Storage Technique):**
- If a row exceeds ~2KB (configurable), large columns are compressed and moved to a separate **TOAST table**.
- The original row stores a **TOAST pointer** (a physical address pointing to the TOAST table and row).
- Retrieving the row requires a second I/O to fetch the TOAST entry.

**InnoDB (Overflow Pages):**
- If a row exceeds ~8KB (half the 16KB page), InnoDB stores the first ~768 bytes of variable-length columns in the data page.
- The remaining bytes are written to separate **overflow pages**, linked via pointers in the row.

**Rule of thumb:** A row with TOAST/overflow columns costs **at minimum 2 I/O operations**—one for the data page and one for each TOAST entry. This is why `SELECT *` on a table with large `TEXT` columns is a performance disaster.

---

## Page Organization Across Files

### PostgreSQL: The Heap

PostgreSQL stores each table as one or more **heap files** on disk. Files are split into 1GB segments.

```text
/data/base/12345/67890           ← First 1GB segment
/data/base/12345/67890.1         ← Second 1GB segment
/data/base/12345/67890.2         ← Third segment
```

Inside each file, pages are numbered 0..N. The first page (page 0) is the **header page** containing metadata. All subsequent pages are data pages. Indexes are separate files with the same structure.

**PostgreSQL page size:** 8KB by default (compile-time constant; changing requires rebuilding the cluster).

### InnoDB: The Tablespace

InnoDB stores everything in a **tablespace**—a single large file (or multiple files) containing all tables and indexes.

```text
ibdata1                           ← System tablespace
/datadir/mydb/orders.ibd          ← File-per-table tablespace (recommended)
```

Within a tablespace, pages are organized into **extents** (1MB, or 64 consecutive 16KB pages). Extents are grouped into **segments** (one per index). Pages within a segment are physically scattered but logically linked via B-tree pointers.

**InnoDB page size:** 16KB by default (4KB, 8KB, 32KB, 64KB configurable). Larger pages reduce B-tree height but increase write amplification for small updates.

---

## The Free Space Map and Page Selection

When inserting a new row, the database must find a page with room. Walking every page is O(N) and absurd. Instead, databases maintain a **Free Space Map (FSM):**

- **PostgreSQL:** A separate FSM file (`tablename_fsm`) tracks approximate free space per page in a compact tree structure. The insert process queries the FSM, finds a page with sufficient room, and writes there.
- **InnoDB:** The extent descriptor and in-memory free list track which pages have room. InnoDB prefers inserting into the page where the key logically belongs (clustered index order), and will split the page if needed.

**The consequence:** Tables with random insert order (UUID primary keys) cause pages to be partially filled, then split, fragmenting the tablespace. Sequential inserts (auto-increment) achieve near-100% page fill.

---

## Page Splits: When 16KB Isn't Enough

When a page is full and a new row belongs in its logical middle (clustered index with random keys), the page splits:

1. Allocate a new page.
2. Move approximately half the rows to the new page.
3. Update parent index page to point to both pages.
4. Link the old and new pages in the leaf chain.

**Cost:** A page split writes at minimum 3 pages (old, new, parent), plus WAL entries. In a busy OLTP system with random inserts, page splits can dominate write I/O.

**PostgreSQL advantage:** Because PostgreSQL uses a heap (no clustered index), most inserts append to the last page. Page splits are rare except when a page fills up from any source.

---

## Page Recovery and Crash Safety

### Checksums

Every page has a checksum (CRC32 or similar) in its header. On read, the checksum is verified. If it fails, the database knows the page is corrupt—either from a torn write (power loss mid-write) or physical media degradation.

**InnoDB:** Uses the checksum + the doublewrite buffer (see storage engines note) for recovery.

**PostgreSQL:** Uses the checksum + WAL replay. If a page checksum fails, PostgreSQL fetches the page's last known good state from WAL and replays subsequent changes. If WAL is unavailable, the database refuses to start until the page is restored from backup.

### Full-Page Writes (PostgreSQL)

After a checkpoint, the first modification to a page writes the **entire 8KB page** to the WAL, not just the changed bytes. This guarantees that even if the on-disk page is torn, recovery can reconstruct it entirely from WAL.

**Trade-off:** Full-page writes double WAL volume after each checkpoint. This is the primary cause of WAL spikes in write-heavy PostgreSQL instances. Tuning `checkpoint_timeout` and `max_wal_size` is essentially about managing this spike.

---

## Locality and the Buffer Pool

The buffer pool (or shared buffers) caches pages in memory. The database does not cache rows—it caches pages.

**Implication 1:** A page containing 200 rows costs the same memory as a page containing 2 rows. Wide rows reduce cache efficiency.

**Implication 2:** Correlated indexes—an index whose order matches the physical row order—enable efficient range scans. The database reads pages sequentially, and most of the needed pages are already in memory from the previous read.

**Implication 3:** Index-only scans (covering indexes) avoid fetching heap pages entirely. This reduces buffer pool churn because index pages are typically smaller and more cache-dense than heap pages.

---

## Engineering Rules of Thumb

| Principle | Reason |
| :--- | :--- |
| **Page size is the I/O quantum** | Smaller pages = better for random access. Larger pages = better for sequential scans. Never change without testing. |
| **Rows cannot span pages** | TOAST and overflow pages are escape hatches. Use them; do not fight them. |
| **Sequential inserts fill pages fully** | 100% fill factor. UUID inserts can drop this to 65-75%. |
| **Index order should match insert order** | Clustered indexes with sequential keys eliminate page splits. |
| **A row's width determines cache efficiency** | Narrow rows = more rows per page = fewer I/O operations per query. |
| **Checksums save data; performance costs are negligible** | Always enable page checksums. The overhead is tiny. |

---

*The page is the universe in which your row exists. It has neighbors. It has a header. It can overflow, split, corrupt, or fill up. Databases do not abstract this away—they optimize within it. Learn the page, and you learn why everything is 16KB.*