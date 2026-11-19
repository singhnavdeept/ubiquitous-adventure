> hadoop-> hadoop 3.14 -> sbin -> start-all.cmd
> New command prompt -> StartNetworkServer -h 0.0.0.0
> New command prompt -> hive -> hive 'version' -> bin -> hive




==USE SEMICOLONS HERE==
`create database <name>;`
`show databases;C:\Users\ASUS\Desktop\Sem\BigDataFiles\hivefil`
`use <name>;`
`create table <table_name>`
`show tables;`
`describe <table_name>`
`insert into <table_name> values (<vallues>)`
`select * from <table_name>`


`create table customer(id int, fname string, lname string, city string)` -- ==don't use a semicolon here==
`row format delimited`
`fields terminated by ','`
`stored as textfile;`

`load data local inpath <filePath> into table <tableName>` -- parse local data into table in hive, follow-up for prev command


`alter table <tableName> rename to <newName>`
`alter table <tableName> add columns (<column_attributes>)`

---

==Example Queries==

`load data local in path 'D:\' into table customer`
`alter table <table_name> add columns (age int)`
`truncate table <table-name>`
`drop table <table-name>`
`select * from <table-name> from marks>90`
`select * from <table-name> where department!='math'`
`select * from <table-name> where department in ('CSE', 'PHYSICS')`
`select * from <table-name> where marks between 79 and 89`

---

==Array Hive==
`create table <table-name> ( name string, marks ARRAY<int>)`
`insert into <table-name> values ('john', array(20,30,25))`

If loading from local file:
`after table creation not semi colon`
write following lines after create table query
`row format delimited`
`fields terminated by ','`
`collection items terminated by ':'`
last line is for array items in the save local file, something like 1, John, 25, 30:50:60

command for local file loading:
`load data local inpath <local-path> into table <table-name>;`

---

==Map Hive==
```sql
create table <table-name>(
name string,
address Map<String, String>
);

insert into <table-name> values
('alice', map('age', '30', 'city', 'NY'));

select name, address['city'] from <table-name>
```

==Struct==
```sql
create table <table-name>(
id int,
personal_info struct<name:string, age:int>
);

insert into <table-name> values (
1,named_struct('name','bob','age',28)
);

select personal_info.name, personal_info.age from <table_name>;
``` 

Local Host -> Hive -> Warehouse

==Non Partitioned Table==
```sql
create table <table-name>(
roll_no int,
name string,
subject string,
marks int,
section string
)
>row format delimited
>fields terminated by ','
>stored as textfile;

load data local inpath "address__" into table <table_name>;
```


- **Partitioning** = **Organizing folders** (Splits data by a _category_).
    
- **Bucketing** = **Organizing files inside a folder** (Splits data by a _hash_).


==Partitioned Table==
`The column we're partitioning by we dont include in the column definition while partitioning, eg here we dont add department in the columns definition. Keep the partition column at the end, in the main table, because hive with partition with the last column`
```sql
create table <table_name>(
roll_no int,
name string,
subject string,
marks int,
) partitioned by (section string);
```

```sql
set hive.exec.dynamic.partition.mode=nonstrict;

insert overwrite table <partitioned_table_name> partition(section)
select roll_no, name, subject, marks, section from <table_name>;
```

==Bucketing==
```sql
create table student_marks(
roll_no int,
name string,
subject string,
marks int,
section string
)
>row format delimited
>fields terminated by ','
>stored as textfile;

load data local inpath "address__" into table <table_name>;
```

```sql
set hive.enforce.bucketing=true;

create table st_bucket(
rollno int,
name string,
subject string,
marks int,
section string
) clustered by (roll_no) into 3 buckets
>row format delimited
>fields terminated by ',';

insert overwrite table st_bucket select * from student_marks;

```

To check - localhost:9870->utilities->browser file directory-> search user->hive->warehouse->(check if buckets created)
or
>open new cmd terminal
>cd C:\hadoop\bin (**need to check)**
>hdfs dfs -ls "user/hive/warehouse/st_bucket"
>hdfs dfs -cat "user/hive/warehouse/st_bucket/000000_0"







Here’s the **20% of Hive commands that you’ll use 80% of the time**, grouped by purpose:

---

## 🔹 **1. Database Operations (DDL)**

```sql
-- Create a database
CREATE DATABASE IF NOT EXISTS sales_db
COMMENT 'Sales data warehouse'
LOCATION '/user/hive/warehouse/sales_db';

-- Use a database
USE sales_db;

-- Show current database
SELECT current_database();

-- List all databases
SHOW DATABASES;

-- Drop database (CASCADE drops tables inside too)
DROP DATABASE IF EXISTS sales_db CASCADE;
```

---

## 🔹 **2. Table Creation (The Workhorse)**

```sql
-- Simple table
CREATE TABLE IF NOT EXISTS orders (
    order_id INT,
    customer_id INT,
    amount DOUBLE,
    order_date DATE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Partitioned table (most common in production)
CREATE TABLE orders_part (
    order_id INT,
    customer_id INT,
    amount DOUBLE
)
PARTITIONED BY (order_date DATE)
STORED AS PARQUET;

-- External table (data outside Hive warehouse)
CREATE EXTERNAL TABLE logs (
    ip STRING,
    url STRING,
    ts TIMESTAMP
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
LOCATION '/user/data/logs';
```

---

## 🔹 **3. Loading & Inserting Data**

```sql
-- Load from HDFS/local file
LOAD DATA LOCAL INPATH '/home/user/orders.csv' 
INTO TABLE orders;

-- Load into a specific partition
LOAD DATA INPATH '/data/orders/date=2025-01-15' 
INTO TABLE orders_part 
PARTITION (order_date='2025-01-15');

-- Insert from query
INSERT OVERWRITE TABLE orders_part 
PARTITION (order_date='2025-01-16')
SELECT order_id, customer_id, amount 
FROM orders 
WHERE order_date = '2025-01-16';

-- Insert into multiple partitions (dynamic partitioning)
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE orders_part 
PARTITION (order_date)
SELECT order_id, customer_id, amount, order_date 
FROM orders;
```

---

## 🔹 **4. SELECT & Filtering (80% of Your Queries)**

```sql
-- Basic select
SELECT * FROM orders LIMIT 10;

-- Filter with WHERE
SELECT order_id, amount 
FROM orders 
WHERE order_date >= '2025-01-01' 
  AND amount > 100;

-- Aggregation (GROUP BY)
SELECT customer_id, 
       COUNT(*) as order_count, 
       SUM(amount) as total_spent
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 5;

-- Sorting
SELECT * FROM orders 
ORDER BY amount DESC 
LIMIT 100;

-- DISTINCT values
SELECT DISTINCT customer_id FROM orders;
```

---

## 🔹 **5. JOINs (Most Common Pattern)**

```sql
-- Inner join
SELECT o.order_id, o.amount, c.name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Left join
SELECT c.customer_id, c.name, COUNT(o.order_id) as order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Map-side join hint (for small tables)
SELECT /*+ MAPJOIN(c) */ o.order_id, o.amount, c.name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
```

---

## 🔹 **6. Table Management**

```sql
-- Show all tables
SHOW TABLES;

-- Describe table structure
DESCRIBE orders;
DESCRIBE FORMATTED orders;  -- detailed info

-- Show partitions
SHOW PARTITIONS orders_part;

-- Drop table
DROP TABLE IF EXISTS orders;

-- Truncate (delete all rows, keep structure)
TRUNCATE TABLE orders;

-- Rename table
ALTER TABLE orders RENAME TO orders_old;
```

---

## 🔹 **7. Partitions & Buckets (Maintenance)**

```sql
-- Add partition
ALTER TABLE orders_part 
ADD PARTITION (order_date='2025-02-01');

-- Drop partition
ALTER TABLE orders_part 
DROP PARTITION (order_date='2025-01-01');

-- Repair partitions (auto-detect from HDFS)
MSCK REPAIR TABLE orders_part;

-- Show partitions
SHOW PARTITIONS orders_part;
```

---

## 🔹 **8. Sampling & Debugging**

```sql
-- Bucket sampling (if table is bucketed)
SELECT * FROM orders TABLESAMPLE(BUCKET 1 OUT OF 4 ON order_id);

-- Percentage sampling
SELECT * FROM orders TABLESAMPLE(10 PERCENT);

-- Count rows (fast estimate)
SELECT COUNT(*) FROM orders;

-- Explain query plan
EXPLAIN SELECT * FROM orders WHERE amount > 100;
EXPLAIN EXTENDED SELECT * FROM orders WHERE amount > 100;
```

---

## 🔹 **9. Export/Import & Utilities**

```sql
-- Export query results to HDFS
INSERT OVERWRITE DIRECTORY '/user/output/orders_export'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT * FROM orders WHERE amount > 100;

-- Copy table structure
CREATE TABLE orders_backup LIKE orders;

-- Insert into new table from query
CREATE TABLE high_value_orders AS
SELECT * FROM orders WHERE amount > 1000;
```

---

## 🎯 **80/20 Rule Summary**

The commands you’ll type **hundreds of times per day**:
1. `SELECT ... FROM ... WHERE ... GROUP BY ... JOIN`
2. `CREATE TABLE ... PARTITIONED BY ... STORED AS PARQUET`
3. `INSERT OVERWRITE TABLE ... PARTITION (...) SELECT ...`
4. `SHOW PARTITIONS / DESCRIBE FORMATTED / EXPLAIN`

The **theory behind them** — partitioning, bucketing, map-side joins, file formats — is what you’ve already learned. These commands are just the surface-level syntax that applies those concepts.

Would you like to move to the next topic in your list, or practice any of these with a hands-on scenario?