



## 1. SQL Query Input
You send a SQL statement to the database, for example:
```sql
SELECT customers.name, orders.amount
FROM customers
JOIN orders ON customers.id = orders.customer_id
WHERE orders.amount > 100
ORDER BY orders.amount DESC;
```

This text is received by the DBMS over a network protocol (e.g., TCP/IP, Unix socket) or via a local command‑line client.

---

## 2. Query Parsing (Lexical & Syntax Analysis)

### Lexical Analysis (Tokenizer)
- Breaks the query string into **tokens**: keywords (`SELECT`, `FROM`, `JOIN`, `WHERE`, `ORDER BY`), identifiers (`customers`, `name`, `orders.amount`), operators (`>`, `=`), literals (`100`), punctuation (`,` , `;`), etc.
- Detects illegal characters or malformed tokens – if any, returns a syntax error.

### Syntax Analysis (Parser)
- Checks the token sequence against the SQL grammar rules.
- Builds a **parse tree** (or abstract syntax tree – AST) that represents the query structure.  
  Example:  
  - `SELECT` clause → list of items (`customers.name`, `orders.amount`)  
  - `FROM` clause → `JOIN` node with two table references (`customers`, `orders`) and a join condition  
  - `WHERE` clause → comparison `>` between `orders.amount` and `100`  
  - `ORDER BY` clause → `orders.amount` with `DESC` direction  

If the grammar is violated (e.g., missing table name after `FROM`), a syntax error is returned.

---

## 3. Semantic Analysis (Binding / Validation)
The parse tree is transformed into a **query tree** (also called **logical query plan**) with symbols resolved.

- **Identifier resolution** – verify that tables (`customers`, `orders`) exist in the current schema, and columns (`name`, `amount`, `customer_id`) exist in those tables.  
- **Type checking** – `orders.amount > 100` must be a numeric comparison; `customers.name` must be a string.  
- **Privilege checking** – does the user have `SELECT` permission on these tables/columns?  
- **View expansion** – if `customers` is a view, its definition is substituted (recursively).  
- **Function and operator validation** – ensure any built‑in or user‑defined functions exist and argument types match.

A **catalog** (system tables) stores all metadata. The result of this phase is a **semantically correct logical query tree** with attached schema information.

---

## 4. Query Rewriting (Logical Optimisation)
The DBMS applies **transformations** that are always beneficial or semantically required:

- **Flattening subqueries** – convert `IN` / `EXISTS` into joins where possible.  
- **View merging** – combine view definitions with the outer query.  
- **Predicate pushdown** – move `WHERE` conditions closer to the table access (e.g., into a subquery).  
- **Constant folding** – replace `100 * 2` with `200`.  
- **Eliminate redundant operations** – e.g., `WHERE TRUE` or `JOIN ... ON TRUE`.  
- **Simplify expressions** – `amount > 10 AND amount > 20` → `amount > 20`.

The output is an **optimised logical query tree** – still declarative, but more efficient.

---

## 5. Query Optimisation (Physical Plan Generation)
This is the most complex phase. The **optimiser** takes the logical tree and generates **physical execution plans** – actual algorithms for each operation (table scans, joins, sorts). It then chooses the cheapest plan based on **cost estimation** using statistics.

### Steps inside the optimiser:

- **Plan enumeration** – possible join orders (e.g., customers ⨝ orders vs orders ⨝ customers), different join algorithms (Nested Loop, Hash Join, Merge Join), access paths (sequential scan, index scan, bitmap index scan).  
- **Cost model** – estimates I/O (disk reads/writes), CPU (comparisons, hash computation), network (if distributed). Uses table statistics: number of rows, distinct values, data distribution histograms, index depth.  
- **Dynamic programming / heuristics** – searches the plan space (often with pruning) to find the plan with minimal estimated cost.

Example decision:  
- If `orders.amount` has an index and only few rows satisfy `> 100`, the optimiser may choose **Index Scan** on `orders`, then **Nested Loop Join** to fetch matching `customers`.  
- If many rows satisfy the condition, a **Hash Join** after a full table scan might be cheaper.

The output is a **physical execution plan** – a tree of operators (e.g., `HashJoin`, `Sort`, `Project`, `Filter`, `IndexScan`).

---

## 6. Execution Plan Generation (Executable Code)
Some DBMSs (e.g., PostgreSQL, Oracle) generate **bytecode** or a **program** from the physical plan. Others (like MySQL) directly interpret the plan tree.

- The plan is passed to the **executor**, which may compile it into a more efficient internal representation (e.g., just‑in‑time compilation in recent versions of PostgreSQL or Spark SQL).  
- The executor also sets up **iterators** (also called “volcano style”): each operator implements `open()`, `next()`, `close()`. Data flows upward as `next()` calls.

---

## 7. Query Execution (Runtime)

The executor runs the physical plan. Data is read from storage (disk / buffer pool) and processed.

### Example physical plan for the sample query:

1. **Index Scan** on `orders` using index on `amount` → rows with `amount > 100` (produces `order_id`, `customer_id`, `amount`).  
2. **Hash Join** – build a hash table from the filtered orders (key = `customer_id`), then probe with `customers` table rows.  
3. **Project** – extract only `customers.name` and `orders.amount`.  
4. **Sort** – sort the projected rows by `amount DESC`.  
5. **Return** the sorted result set to the client.

### Execution details:
- **Buffer pool** – pages are cached to minimise disk I/O.  
- **Concurrency control** – locks (or MVCC snapshots) ensure read consistency without blocking writers.  
- **Memory management** – operators may spill to disk if intermediate results exceed memory (e.g., hash join builds temporary files).  
- **Parallelism** (if enabled) – some operators may be executed by multiple CPU cores or across nodes.

The executor pulls rows from the bottom (table access) and pushes them upward through operators. The final operator at the root collects results and sends them to the client.

---

## 8. Fetching and Returning the Output

As the root operator produces rows, the DBMS formats them according to the client’s protocol (e.g., PostgreSQL’s `RowDescription` message, MySQL’s result set packet).

- **Streaming** – rows are sent incrementally; the client can start seeing the first results before the query finishes (if the plan allows).  
- **Fetching** – the client may request a limited number of rows at a time (cursor `FETCH`).  
- **End‑of‑data** – when the last row is emitted, the executor sends an **EOF** (or a `CommandComplete` tag) with metadata like the number of rows.

The client application (e.g., `psql`, a JDBC driver) then displays the data in a tabular format, or processes it internally.

### Actual output for our example:

If the database contains:
- Customers: `(1, 'Alice')`, `(2, 'Bob')`, `(3, 'Carol')`
- Orders: `(101, 1, 50)`, `(102, 2, 150)`, `(103, 1, 200)`, `(104, 3, 120)`

The result set would be:
```
 name  | amount
-------+--------
 Alice | 200
 Bob   | 150
 Carol | 120
```

The client prints these rows, and the user sees the **actual output data**.

---

## 9. Cleanup & Transaction Handling

After the query finishes (or if it is cancelled/aborted):

- The executor releases memory, temporary files, and resources.  
- **Transaction commit/rollback** – if the query was part of a transaction, changes are either made durable (commit) or undone (rollback).  
- Locks are released, and the session returns to idle, ready for the next query.

---

## Summary Diagram (SQL Query Path)

```
SQL Query Text
      ↓
[Parser] → Parse Tree
      ↓
[Binder / Semantic Check] → Logical Query Tree (resolved)
      ↓
[Rewriter] → Optimised Logical Tree
      ↓
[Optimiser] → Physical Execution Plan (with cost estimates)
      ↓
[Executor / Runtime] → Row by row processing
      ↓
[Protocol / Client Fetch] → Formatted Result Set
      ↓
User sees actual output data
```

Each stage can produce errors (syntax, semantic, privilege, execution errors like division by zero or deadlock). Successful execution yields the **actual output data** – the rows that satisfy the query’s conditions, transformed and ordered as requested.