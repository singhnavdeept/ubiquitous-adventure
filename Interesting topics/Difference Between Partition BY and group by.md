

This is a classic point of confusion because both `GROUP BY` and `PARTITION BY` operate on "groups" of rows. The critical difference is **what the database returns to you**.

- **`GROUP BY`** is an **aggregation tool**. It **collapses** many rows into one row per group.
- **`PARTITION BY`** is a **window/analytic tool**. It **preserves** every single original row and attaches a calculated value to each row based on its group.

To make this visceral, we'll use a **sizable e-commerce order dataset** and walk through both.

---

## The Dataset: `sales_transactions`

Let's assume we have 500 rows of raw transaction data for a small online store. Here's a representative sample of 12 rows (imagine 488 more like it).

| sale_id | sale_date  | region | product_category | rep   | amount  |
| :------ | :--------- | :----- | :--------------- | :---- | :------ |
| 1       | 2026-04-01 | North  | Electronics      | Alice | 250.00  |
| 2       | 2026-04-01 | North  | Furniture        | Bob   | 1200.00 |
| 3       | 2026-04-01 | South  | Electronics      | Carol | 300.00  |
| 4       | 2026-04-02 | North  | Electronics      | Alice | 150.00  |
| 5       | 2026-04-02 | North  | Furniture        | Bob   | 800.00  |
| 6       | 2026-04-02 | South  | Furniture        | Dave  | 950.00  |
| 7       | 2026-04-03 | South  | Electronics      | Carol | 450.00  |
| 8       | 2026-04-03 | East   | Office           | Eve   | 75.00   |
| 9       | 2026-04-04 | East   | Office           | Eve   | 125.00  |
| 10      | 2026-04-04 | North  | Electronics      | Alice | 400.00  |
| 11      | 2026-04-05 | North  | Furniture        | Bob   | 2200.00 |
| 12      | 2026-04-05 | South  | Electronics      | Carol | 175.00  |

---

## Part 1: `GROUP BY` – The Aggregator (Collapsing Rows)

**Goal:** *"Show me the **total sales** per region."*

### Query
```sql
SELECT 
    region, 
    SUM(amount) AS total_revenue,
    COUNT(*) AS transaction_count,
    AVG(amount) AS avg_transaction_value
FROM sales_transactions
GROUP BY region
ORDER BY region;
```

### Output (4 Rows Total)
| region | total_revenue | transaction_count | avg_transaction_value |
| :----- | :------------ | :---------------- | :-------------------- |
| East   | 200.00        | 2                 | 100.00                |
| North  | 5000.00       | 6                 | 833.33                |
| South  | 1875.00       | 4                 | 468.75                |
|        |               |                   |                       |

### Engineering Insight on `GROUP BY`
- **Cardinality Changed:** We started with 12 rows (500 in reality). We ended with **3 rows** (one per distinct region).
- **Lost Granularity:** I can no longer see `sale_id`, `rep`, or `product_category`. Those columns **cannot be selected** unless they are part of the `GROUP BY` clause or wrapped in an aggregate function.
- **Use Case:** **Reporting Dashboards, KPI Summaries.** This is for when the end user (CEO) wants to see the big picture, not the line items.

---

## Part 2: `PARTITION BY` – The Analyst (Preserving Rows)

**Goal:** *"Show me **every single sale**, but next to each sale, show me **how much that sale contributed to its region's total** and **how it ranked within the region**."*

### Query
```sql
SELECT 
    sale_id,
    region,
    rep,
    amount,
    -- Window Function 1: Total for the region (repeated on every row)
    SUM(amount) OVER (PARTITION BY region) AS region_total,
    -- Window Function 2: Percentage contribution of this sale to the region
    ROUND(100.0 * amount / SUM(amount) OVER (PARTITION BY region), 2) AS pct_of_region,
    -- Window Function 3: Rank by amount within the region (1 = highest)
    RANK() OVER (PARTITION BY region ORDER BY amount DESC) AS rank_in_region
FROM sales_transactions
ORDER BY region, amount DESC;
```

### Output (12 Rows Total – Same cardinality as input)
| sale_id | region | rep   | amount  | region_total | pct_of_region | rank_in_region |
| :------ | :----- | :---- | :------ | :----------- | :------------ | :------------- |
| 9       | East   | Eve   | 125.00  | **200.00**   | 62.50         | 1              |
| 8       | East   | Eve   | 75.00   | **200.00**   | 37.50         | 2              |
| 11      | North  | Bob   | 2200.00 | **5000.00**  | 44.00         | 1              |
| 2       | North  | Bob   | 1200.00 | **5000.00**  | 24.00         | 2              |
| 5       | North  | Bob   | 800.00  | **5000.00**  | 16.00         | 3              |
| 10      | North  | Alice | 400.00  | **5000.00**  | 8.00          | 4              |
| 1       | North  | Alice | 250.00  | **5000.00**  | 5.00          | 5              |
| 4       | North  | Alice | 150.00  | **5000.00**  | 3.00          | 6              |
| 6       | South  | Dave  | 950.00  | **1875.00**  | 50.67         | 1              |
| 7       | South  | Carol | 450.00  | **1875.00**  | 24.00         | 2              |
| 3       | South  | Carol | 300.00  | **1875.00**  | 16.00         | 3              |
| 12      | South  | Carol | 175.00  | **1875.00**  | 9.33          | 4              |

### Engineering Insight on `PARTITION BY`
- **Cardinality Preserved:** We still have 12 rows (500 in the full set). **No data was lost.**
- **Repeated Values:** The `region_total` is **repeated** for every row belonging to 'North'. This is the core mechanic of a window function.
- **Row-Level Context:** I can now easily write a query to find *"Which individual sales rep made the largest single sale in each region?"* without using a subquery.

---

## Part 3: The Killer Comparison – Solving the Same Problem Two Ways

**Scenario:** Management wants a report showing:
1. Every single sale.
2. The *difference* between that sale's amount and the **average** sale amount for its region.

### Solution A: Using `GROUP BY` + `JOIN` (Old School, Verbose)

```sql
WITH regional_avgs AS (
    SELECT region, AVG(amount) AS avg_amt
    FROM sales_transactions
    GROUP BY region
)
SELECT 
    s.sale_id, 
    s.region, 
    s.amount, 
    r.avg_amt,
    s.amount - r.avg_amt AS diff_from_avg
FROM sales_transactions s
JOIN regional_avgs r ON s.region = r.region;
```
- **Complexity:** Requires a CTE or subquery, a self-join, and two passes over the data (logically).

### Solution B: Using `PARTITION BY` (Modern, Elegant, Faster)

```sql
SELECT 
    sale_id, 
    region, 
    amount,
    AVG(amount) OVER (PARTITION BY region) AS avg_amt,
    amount - AVG(amount) OVER (PARTITION BY region) AS diff_from_avg
FROM sales_transactions;
```
- **Complexity:** One pass over the data. No joins. The optimizer loves this.

---

## Summary: When to Use Which?

| Feature | `GROUP BY` | `PARTITION BY` (Window Functions) |
| :--- | :--- | :--- |
| **Output Rows** | **Reduced** (1 per group) | **Same** as input (N rows) |
| **Selected Columns** | Only grouped columns or aggregates | **Any** column from the original row |
| **Primary Use** | **Reporting totals/averages** | **Analytics** (Ranking, Running Totals, Percentages) |
| **Performance** | Fast for pure aggregation | Fast for row-wise comparison without self-joins |
| **Analogy** | **A Pie Chart** (You see the slices, not the ingredients) | **A Spreadsheet** (You see every cell, with formula columns on the right) |

### The Final Rule of Thumb
- If the answer you need fits in **one row per category** (e.g., "Total sales per region"), use **`GROUP BY`**.
- If the answer you need is a **new column added to every single row** (e.g., "Rank each sale within its region"), use **`PARTITION BY`**.