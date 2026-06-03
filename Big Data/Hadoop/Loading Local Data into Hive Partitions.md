---
title: "Loading Local Data into Apache Hive Partitions (WSL Ubuntu)"
tags:
  - big-data
  - hadoop
  - hive
  - partitioning
  - wsl
  - ubuntu
created: 2026-06-03
type: practical-guide
---

# 📂 Loading Local Data into Apache Hive Partitions (WSL Ubuntu)

This guide provides a step-by-step walkthrough of how to load local data files (stored inside your WSL Ubuntu home directory or Windows drive mounts) into Apache Hive partitioned tables. 

It illustrates both **Static Partitioning** and **Dynamic Partitioning** using a `student_db` database example.

---

## 💻 1. WSL Path Mapping (Windows vs. WSL Linux)

Since your Hive & Hadoop stack is running inside **Ubuntu on WSL**, you must specify local paths from Ubuntu's perspective:
* **WSL Local Path**: File is saved in your Ubuntu user home.
  * *Example Path*: `/home/ubuntu/data/student_cs.csv`
* **Windows Host Path**: File is saved on your Windows machine (e.g., your Desktop). WSL automatically mounts Windows drives under `/mnt/`.
  * *Example Path*: `/mnt/c/Users/navde/Desktop/student_cs.csv`

> [!WARNING]
> **Windows Carriage Return Issue (\r\n)**:
> Windows text editors use `\r\n` (CRLF) for newlines, while Unix uses `\n` (LF). If you load a CSV file edited in Windows directly into Hive, the final column will contain invisible `\r` (carriage return) characters, causing queries to fail or display garbage.
> 
> Before loading a Windows-saved CSV file, run this command in Ubuntu to clean it:
> ```bash
> tr -d '\r' < /mnt/c/Users/navde/Desktop/student_cs.csv > /home/ubuntu/student_cs.csv
> ```

---

## 🛠️ 2. Step 1: Prepare the Local Data Files

Create a temporary working folder in your WSL terminal and create sample data files.

```bash
mkdir -p /home/ubuntu/hive_data
cd /home/ubuntu/hive_data
```

### File A: `student_cs.csv` (Computer Science Department Data)
```csv
101,Navdeep Singh,92,3
102,Amanpreet Kaur,88,3
103,John Doe,74,2
```

### File B: `student_ece.csv` (Electronics Department Data)
```csv
201,Rajesh Kumar,75,4
202,Priya Sharma,82,4
203,Jane Smith,90,1
```

### File C: `students_all.csv` (Combined data containing department column for Dynamic Partitioning)
```csv
101,Navdeep Singh,92,3,CS
102,Amanpreet Kaur,88,3,CS
103,John Doe,74,2,CS
201,Rajesh Kumar,75,4,ECE
202,Priya Sharma,82,4,ECE
203,Jane Smith,90,1,ECE
```

---

## 🏛️ 3. Step 2: Create the Database in Hive

Launch your Hive CLI or Beeline client:
```bash
hive
```

Run the following SQL DDL query to create the database:
```sql
CREATE DATABASE IF NOT EXISTS student_db;
USE student_db;
```

---

## 📥 4. Method 1: Loading Data via Static Partitioning

Use **Static Partitioning** when you want to load data manually into a specific partition directory. You must explicitly state the partition key value in your load command.

### 1. Create a Partitioned Table
> [!IMPORTANT]
> In Hive, the partitioning column (`dept`) **must NOT** be declared in the main table column list. It is defined exclusively inside the `PARTITIONED BY` clause.

```sql
CREATE TABLE IF NOT EXISTS students_static (
    roll_no INT,
    name STRING,
    marks INT,
    year INT
)
PARTITIONED BY (dept STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```

### 2. Load the Local Data Files
Load each file into its specific department partition:

```sql
-- Load CS Students
LOAD DATA LOCAL INPATH '/home/ubuntu/hive_data/student_cs.csv' 
INTO TABLE students_static 
PARTITION (dept='CS');

-- Load ECE Students
LOAD DATA LOCAL INPATH '/home/ubuntu/hive_data/student_ece.csv' 
INTO TABLE students_static 
PARTITION (dept='ECE');
```
*Note: If the `LOCAL` keyword is omitted, Hive will look for the file inside the HDFS directory instead of the WSL local directory.*

### 3. Verify in Hive
Verify that the partition columns were correctly populated:
```sql
SELECT * FROM students_static;
```
*Output:*
```
101   Navdeep Singh   92   3   CS
102   Amanpreet Kaur  88   3   CS
103   John Doe        74   2   CS
201   Rajesh Kumar    75   4   ECE
202   Priya Sharma    82   4   ECE
203   Jane Smith      90   1   ECE
```

Check the active partitions:
```sql
SHOW PARTITIONS students_static;
```
*Output:*
```
dept=CS
dept=ECE
```

---

## ⚡ 5. Method 2: Loading Data via Dynamic Partitioning

If you have a large single file containing records belonging to many different categories (e.g. 50 different departments), loading them via static partitions is highly inefficient. 

**Dynamic Partitioning** allows Hive to inspect the data automatically at load time and split the rows into their respective partitions.

### 1. Create a Non-Partitioned Staging Table
First, create a flat, temporary staging table that matches the format of your combined data file (`students_all.csv`):

```sql
CREATE TABLE IF NOT EXISTS students_staging (
    roll_no INT,
    name STRING,
    marks INT,
    year INT,
    dept STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```

### 2. Load the Local Data into the Staging Table
```sql
LOAD DATA LOCAL INPATH '/home/ubuntu/hive_data/students_all.csv' 
INTO TABLE students_staging;
```

### 3. Create the Target Partitioned Table
Create the final destination table that will hold the partitioned data:

```sql
CREATE TABLE IF NOT EXISTS students_dynamic (
    roll_no INT,
    name STRING,
    marks INT,
    year INT
)
PARTITIONED BY (dept STRING)
STORED AS TEXTFILE;
```

### 4. Enable Dynamic Partitioning Properties
By default, dynamic partitioning is safe-guarded to prevent accidental massive partition creations. You must execute these session configurations:

```sql
-- Enable dynamic partitioning globally for the session
SET hive.exec.dynamic.partition=true;

-- Set mode to nonstrict (allows partitioning without declaring a static parent)
SET hive.exec.dynamic.partition.mode=nonstrict;
```

### 5. Load Staged Data dynamically into the Target Table
Execute an `INSERT` statement to route the data:

```sql
INSERT OVERWRITE TABLE students_dynamic 
PARTITION (dept)
SELECT roll_no, name, marks, year, dept 
FROM students_staging;
```

> [!IMPORTANT]
> **Column Positional Rule**:
> When inserting dynamically, the partition column (`dept`) **must be the final column** in your SELECT query list. Hive maps columns based on order position, not by name. The last column of the SELECT query is used to populate the partition key defined in the table.

---

## 🔍 6. How to Verify the Partitions inside WSL / HDFS

When you load data into a partitioned table, Hive physically restructures the directories on HDFS. 

Open a new Ubuntu terminal and run HDFS commands to inspect the warehouse folder:

```bash
# List directories in the warehouse
hdfs dfs -ls /user/hive/warehouse/student_db.db/students_dynamic
```

*Expected HDFS Output structure:*
```
Found 2 items
drwxr-xr-x   - ubuntu supergroup          0 2026-06-03 09:45 /user/hive/warehouse/student_db.db/students_dynamic/dept=CS
drwxr-xr-x   - ubuntu supergroup          0 2026-06-03 09:45 /user/hive/warehouse/student_db.db/students_dynamic/dept=ECE
```

As you can see, Hive created two separate subdirectory folders: `dept=CS` and `dept=ECE`. Any query specifying `WHERE dept='CS'` will scan *only* the files inside the `dept=CS` folder, bypassing the rest of the dataset completely, which speeds up query execution.
