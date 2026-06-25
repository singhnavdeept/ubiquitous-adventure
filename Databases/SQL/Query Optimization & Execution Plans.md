---
tags:
  - database/performance
  - database/sql
  - database/query-optimization
category: querying
created: 2026-06-15
---

# Query Optimization & Execution Plans (Advanced Deep Dive)

This document details the cost-based query optimizer internals, mathematical estimation of selectivity, internal join resource spills, and how ORMs execute lazy-loading queries.

---

## 1. Optimizer Internals: Cost Model & Frameworks

### Cost Formulations (PostgreSQL Cost Model)
The query optimizer is cost-based: it estimates the execution cost of various physical execution plans and selects the one with the lowest cost. Costs are measured in arbitrary units of single sequential page reads.

The primary cost parameters in PostgreSQL are:
*   `seq_page_cost` (default `1.0`): Cost to read a single page sequentially.
*   `random_page_cost` (default `4.0`): Cost to read a single page randomly (reflecting HDD seek times. On modern SSDs, this is often set to `1.1`–`1.5`).
*   `cpu_tuple_cost` (default `0.01`): CPU cost to process a single row.
*   `cpu_index_tuple_cost` (default `0.005`): CPU cost to process an index entry.
*   `cpu_operator_cost` (default `0.0025`): CPU cost to execute an operator or function (e.g., `WHERE` condition check).

#### Estimated Cost Formula for a Sequential Scan:
$$\text{Cost}_{\text{SeqScan}} = (N_{\text{pages}} \times \text{seq\_page\_cost}) + (N_{\text{tuples}} \times (\text{cpu\_tuple\_cost} + \text{cpu\_operator\_cost}))$$

*Example:* A table has $10,000$ pages and $1,000,000$ rows. The query is `SELECT * FROM table WHERE val = 5;`
$$\text{Cost}_{\text{SeqScan}} = (10,000 \times 1.0) + (1,000,000 \times (0.01 + 0.0025)) = 10,000 + 12,500 = 22,500\text{ units}$$

---

### Optimizer Frameworks: System R vs. Cascades
1.  **System R (Dynamic Programming):** 
    *   Iteratively constructs physical plans bottom-up. First, it determines access paths for single tables, then joins pairs, then triplets, building a tree of optimal sub-plans.
    *   *Limitation:* Search space grows exponentially ($O(2^N)$), making it slow for queries joining $> 10$ tables.
2.  **Cascades (Goal-Driven, Top-Down):**
    *   Uses a rule engine to transform a logical query tree into physical plans. It records equivalences in a shared memory structure called the **Memo**.
    *   It searches top-down, applying **Branch-and-Bound Pruning**: if a partially evaluated plan's cost exceeds the current best plan, it abandons the search tree early, allowing fast planning for complex queries.

---

## 2. Selectivity & Selectivity Estimation Mathematics

Selectivity ($S$) is the estimated fraction of rows from a table that satisfy a given filter predicate.

### 1. Equality Predicates ($A = \text{constant}$)
Without specific histograms, the optimizer assumes uniform distribution:
$$S = \frac{1}{N_{\text{distinct}}}$$
If the system catalog contains **Most Common Values (MCVs)** (from `ANALYZE`), the optimizer checks if the constant matches any MCV. If it does, $S$ equals the pre-recorded frequency of that value.

### 2. Joint Selectivity ($A = \text{val1} \land B = \text{val2}$)
The default behavior assumes columns are independent:
$$S(A \land B) = S(A) \times S(B)$$

#### The Correlation Failure:
If a table stores cars, and we filter `WHERE make = 'Porsche' AND model = '911'`, the independence assumption severely under-estimates the selectivity (since almost all 911s are Porsches). This leads the optimizer to expect very few rows, potentially choosing a slow Nested Loop scan over a Hash Join.

*   **Mitigation (Extended Statistics):** PostgreSQL allows developers to declare joint stats to capture dependencies:
    ```sql
    CREATE STATISTICS s_car_make_model (dependencies) ON make, model FROM cars;
    ```
    This computes a correlation coefficient to adjust the joint selectivity calculation.

---

## 3. Join Mechanics & Buffer Spills

When joins run, memory constraints (`work_mem` in PostgreSQL, `join_buffer_size` in MySQL) determine if operations remain in RAM or spill to disk.

```text
                  Hash Join Hash Phase
                           |
            Is Build Table Size < work_mem?
                   /               \
            (Yes) /                 \ (No)
                 v                   v
          [ In-Memory Hash ]   [ Hybrid Hash Join (Disk Spill) ]
          Build hash table      Hash rows into batches; 
          in RAM and probe      write batches to temp files.
                                Read batch-by-batch.
```

### Hash Join disk spills (Hybrid Hash Join)
A Hash Join consists of a **Build Phase** (hashing keys of the smaller table into memory) and a **Probe Phase** (scanning the larger table and checking the hash table).

*   If the build table exceeds `work_mem`, it splits into $2^k$ batches.
*   Only the first batch of the build table remains in memory. Remaining batches are written to disk as temporary files.
*   The probe table is scanned, and its rows are partitioned into matching batches on disk.
*   Finally, the engine processes each batch sequentially, reading the files back into memory one by one. This causes heavy disk write/read amplification.

### Merge Join sorts
A Merge Join requires both tables to be sorted on the join key. If an index does not provide this sort order, the engine executes an **External Merge Sort**:
*   Divides the table into chunks that fit in `work_mem`.
*   Sorts each chunk in RAM and writes the sorted run to disk.
*   Merges the sorted runs on disk using a tournament tree structure.

---

## 4. ORM Lazy Loading Internals

ORM systems (Hibernate, SQLAlchemy, Django) retrieve data on demand using **Lazy Loading**. Understanding the runtime implementation reveals why it triggers the N+1 problem.

### The Dynamic Proxy / Subclassing Pattern
When you fetch an object, the ORM doesn't instantiate the raw class; it compiles a **dynamic subclass** at runtime:

```python
# Conceptual Python representation of an ORM Lazy Loading Proxy
class UserProxy(User):
    def __init__(self, user_id, session):
        self._id = user_id
        self._session = session
        self._loaded = False

    # The magic getter intercepts access to any field
    def __getattribute__(self, name):
        # Prevent infinite recursion when checking metadata
        if name in ('_id', '_session', '_loaded', '__class__'):
            return object.__getattribute__(self, name)
            
        if not self._loaded:
            # Trigger lazy load query from database!
            print(f"[ORM Debug] Intercepted access to '{name}'. Querying DB...")
            data = self._session.execute("SELECT * FROM users WHERE id = %s", (self._id,))
            self._populate_fields(data)
            self._loaded = True
            
        return object.__getattribute__(self, name)
```

1.  **Instantiation:** The query `Order.objects.all()` returns `Order` instances, but the `.user` reference is populated with a `UserProxy` instance containing only the `user_id` and a database session pointer.
2.  **Interception:** When the loop accesses `order.user.name`, the proxy's `__getattribute__` intercepts the call, detects that `_loaded` is `False`, executes a SQL query to load the fields, and marks itself loaded.
3.  **The Loop Bottleneck:** If the parent list contains 1000 orders, this interception executes 1000 times, causing 1000 database roundtrips.
