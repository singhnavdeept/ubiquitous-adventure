# Hive + HBase Exam Cheat Sheet

---

## HIVE

### Setup (run once before anything)

```bash
# Hadoop and Hive must be running
sudo service ssh start
start-dfs.sh && start-yarn.sh
hive
```

---

### Create Table

```sql
CREATE TABLE employee_details (
  emp_id      INT,
  emp_name    STRING,
  salary      FLOAT,
  joining_date DATE,
  is_active   BOOLEAN
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```

For Set C schema (with department):

```sql
CREATE TABLE employee_details (
  employee_id   INT,
  employee_name STRING,
  age           INT,
  department    STRING,
  salary        DOUBLE,
  joining_date  STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;
```

---

### Load Data from Local File → Hive

**Step 1 — Create a CSV file on your local machine:**

```bash
# In Ubuntu terminal (outside hive)
cat > /tmp/employees.csv << EOF
1,Alice,75000,2021-06-15,true
2,Bob,45000,2020-03-10,true
3,Charlie,90000,2019-11-20,false
4,Diana,62000,2022-01-05,true
5,Eve,30000,2023-07-01,true
EOF
```

**Step 2 — Load into Hive table:**

```sql
-- LOCAL means from your Linux filesystem (not HDFS)
LOAD DATA LOCAL INPATH '/tmp/employees.csv'
INTO TABLE employee_details;

-- To overwrite existing data:
LOAD DATA LOCAL INPATH '/tmp/employees.csv'
OVERWRITE INTO TABLE employee_details;
```

> That's it. No HDFS steps needed when using `LOCAL`.

---

### INSERT (direct values — slower but works in exam)

```sql
INSERT INTO TABLE employee_details VALUES
(1, 'Alice',   75000.0, '2021-06-15', true),
(2, 'Bob',     45000.0, '2020-03-10', true),
(3, 'Charlie', 90000.0, '2019-11-20', false),
(4, 'Diana',   62000.0, '2022-01-05', true),
(5, 'Eve',     30000.0, '2023-07-01', true);
```

---

### SELECT Queries

```sql
-- All records
SELECT * FROM employee_details;
FILr
SELECT * FROM employee_details WHERE salary > 50000;

-- Only name and joining date
SELECT emp_name, joining_date FROM employee_details;

-- Convert joining_date (STRING) to timestamp
SELECT emp_name, CAST(joining_date AS TIMESTAMP) AS join_ts
FROM employee_details;

-- If joining_date is DATE type:
SELECT emp_name, CAST(joining_date AS TIMESTAMP) FROM employee_details;
```

---

### product_sales Queries (Set A Q2)

```sql
CREATE TABLE product_sales (
  sale_id    INT,
  product_id INT,
  category   STRING,
  quantity   INT,
  price      FLOAT,
  sale_date  DATE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Total revenue per category
SELECT category, SUM(quantity * price) AS total_revenue
FROM product_sales
GROUP BY category;

-- Top 3 highest-selling products by revenue
SELECT product_id, SUM(quantity * price) AS revenue
FROM product_sales
GROUP BY product_id
ORDER BY revenue DESC
LIMIT 3;

-- Month-wise sales trend
SELECT MONTH(sale_date) AS month, SUM(quantity * price) AS monthly_revenue
FROM product_sales
GROUP BY MONTH(sale_date);

-- Products where quantity > average quantity
SELECT * FROM product_sales
WHERE quantity > (SELECT AVG(quantity) FROM product_sales);
```

---

### Partitioning

```sql
-- Enable dynamic partition
SET hive.exec.dynamic.partition = true;
SET hive.exec.dynamic.partition.mode = nonstrict;

-- Create partitioned table (partition column NOT in main schema)
CREATE TABLE product_sales_partitioned (
  sale_id    INT,
  product_id INT,
  category   STRING,
  quantity   INT,
  price      FLOAT
)
PARTITIONED BY (sale_date STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Move data from original table into partitioned table
INSERT INTO TABLE product_sales_partitioned
PARTITION (sale_date)
SELECT sale_id, product_id, category, quantity, price, sale_date
FROM product_sales;

-- Query a specific partition (fast — skips other partitions)
SELECT * FROM product_sales_partitioned WHERE sale_date = '2024-01-15';
```

---

### Bucketing

```sql
SET hive.enforce.bucketing = true;

CREATE TABLE emp_bucketed (
  emp_id   INT,
  emp_name STRING,
  salary   FLOAT
)
CLUSTERED BY (emp_id) INTO 4 BUCKETS
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

INSERT INTO TABLE emp_bucketed
SELECT emp_id, emp_name, salary FROM employee_details;
```

---

## HBASE

### Start HBase

```bash
sudo service ssh start
start-dfs.sh        # Hadoop HDFS must be up
start-hbase.sh
hbase shell
```

---

### All Shell Commands You Need

```
# Create table with column families
create 'students', 'personal', 'academic'

# Insert (put 'table', 'rowkey', 'family:column', 'value')
put 'students', '2001', 'personal:name',  'Emma'
put 'students', '2001', 'personal:age',   '22'
put 'students', '2001', 'personal:email', 'emma@example.com'
put 'students', '2001', 'academic:course','CS'
put 'students', '2001', 'academic:year',  '2024'

put 'students', '2002', 'personal:name',  'Ryan'
put 'students', '2002', 'personal:age',   '21'
put 'students', '2002', 'personal:email', 'ryan@example.com'
put 'students', '2002', 'academic:course','Mechanical'
put 'students', '2002', 'academic:year',  '2025'

put 'students', '2003', 'personal:name',  'Sophia'
put 'students', '2003', 'personal:age',   '23'
put 'students', '2003', 'personal:email', 'sophia@example.com'
put 'students', '2003', 'academic:course','Electrical'
put 'students', '2003', 'academic:year',  '2023'

# Scan all records
scan 'students'

# Get specific row
get 'students', '2002'

# Get specific columns only (row 2002 — email and course)
get 'students', '2002', 'personal:email'
get 'students', '2002', 'academic:course'

# Update (same as put — overwrites)
put 'students', '2003', 'personal:email', 'sophia123@example.com'

# Delete a specific column
delete 'students', '2001', 'academic:course'
delete 'students', '2001', 'academic:year'

# Delete an entire column family for a row
# HBase shell has no direct "delete family for one row" command
# Use deleteall to delete entire row, or delete each column manually:
delete 'students', '2001', 'academic:course'
delete 'students', '2001', 'academic:year'

# Delete entire row
deleteall 'students', '2001'

# Disable and drop table
disable 'students'
drop 'students'

# Utility
list
describe 'students'
count 'students'
```

---

### Load Data from Local File → HBase

HBase has no `LOAD DATA` like Hive. Two practical options:

**Option 1 — Shell script (simplest for exam):**

```bash
# Create the data file
cat > /tmp/students.txt << EOF
2001,Emma,22,emma@example.com,CS,2024
2002,Ryan,21,ryan@example.com,Mechanical,2025
2003,Sophia,23,sophia@example.com,Electrical,2023
EOF

# Write a shell script to load it
while IFS=',' read -r id name age email course year; do
  echo "put 'students', '$id', 'personal:name', '$name'"
  echo "put 'students', '$id', 'personal:age', '$age'"
  echo "put 'students', '$id', 'personal:email', '$email'"
  echo "put 'students', '$id', 'academic:course', '$course'"
  echo "put 'students', '$id', 'academic:year', '$year'"
done < /tmp/students.txt | hbase shell
```

**Option 2 — Java API (if exam asks for it):**

```java
// See Java API section below
```

---

### HBase Java API

Add to pom.xml (or include hbase-client jar in classpath):

```xml
<dependency>
  <groupId>org.apache.hbase</groupId>
  <artifactId>hbase-client</artifactId>
  <version>2.4.17</version>
</dependency>
```

**Full working example — covers all operations:**

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.*;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;
import java.io.IOException;

public class HBaseStudentOps {

    static Connection getConnection() throws IOException {
        Configuration config = HBaseConfiguration.create();
        config.set("hbase.zookeeper.quorum", "localhost");
        config.set("hbase.zookeeper.property.clientPort", "2181");
        return ConnectionFactory.createConnection(config);
    }

    // CREATE TABLE
    public static void createTable() throws IOException {
        try (Connection conn = getConnection();
             Admin admin = conn.getAdmin()) {
            TableName tableName = TableName.valueOf("students");
            if (!admin.tableExists(tableName)) {
                TableDescriptorBuilder builder =
                    TableDescriptorBuilder.newBuilder(tableName);
                builder.setColumnFamily(
                    ColumnFamilyDescriptorBuilder.of("personal"));
                builder.setColumnFamily(
                    ColumnFamilyDescriptorBuilder.of("academic"));
                admin.createTable(builder.build());
                System.out.println("Table created.");
            }
        }
    }

    // INSERT (PUT)
    public static void insertRecord() throws IOException {
        try (Connection conn = getConnection();
             Table table = conn.getTable(TableName.valueOf("students"))) {
            Put put = new Put(Bytes.toBytes("2001"));
            put.addColumn(Bytes.toBytes("personal"), Bytes.toBytes("name"),
                          Bytes.toBytes("Emma"));
            put.addColumn(Bytes.toBytes("personal"), Bytes.toBytes("age"),
                          Bytes.toBytes("22"));
            put.addColumn(Bytes.toBytes("academic"), Bytes.toBytes("course"),
                          Bytes.toBytes("CS"));
            table.put(put);
            System.out.println("Record inserted.");
        }
    }

    // READ (GET)
    public static void getRecord() throws IOException {
        try (Connection conn = getConnection();
             Table table = conn.getTable(TableName.valueOf("students"))) {
            Get get = new Get(Bytes.toBytes("2001"));
            Result result = table.get(get);
            String name = Bytes.toString(
                result.getValue(Bytes.toBytes("personal"),
                                Bytes.toBytes("name")));
            System.out.println("Name: " + name);
        }
    }

    // SCAN ALL
    public static void scanAll() throws IOException {
        try (Connection conn = getConnection();
             Table table = conn.getTable(TableName.valueOf("students"));
             ResultScanner scanner = table.getScanner(new Scan())) {
            for (Result result : scanner) {
                System.out.println("Row: " + Bytes.toString(result.getRow()));
                String name = Bytes.toString(
                    result.getValue(Bytes.toBytes("personal"),
                                    Bytes.toBytes("name")));
                System.out.println("  Name: " + name);
            }
        }
    }

    // DELETE a column
    public static void deleteColumn() throws IOException {
        try (Connection conn = getConnection();
             Table table = conn.getTable(TableName.valueOf("students"))) {
            Delete delete = new Delete(Bytes.toBytes("2001"));
            delete.addColumn(Bytes.toBytes("academic"),
                             Bytes.toBytes("course"));
            table.delete(delete);
            System.out.println("Column deleted.");
        }
    }

    // DELETE entire row
    public static void deleteRow() throws IOException {
        try (Connection conn = getConnection();
             Table table = conn.getTable(TableName.valueOf("students"))) {
            Delete delete = new Delete(Bytes.toBytes("2001"));
            table.delete(delete);
            System.out.println("Row deleted.");
        }
    }

    // UPDATE — same as INSERT (put overwrites)
    public static void updateRecord() throws IOException {
        try (Connection conn = getConnection();
             Table table = conn.getTable(TableName.valueOf("students"))) {
            Put put = new Put(Bytes.toBytes("2003"));
            put.addColumn(Bytes.toBytes("personal"), Bytes.toBytes("email"),
                          Bytes.toBytes("sophia123@example.com"));
            table.put(put);
            System.out.println("Record updated.");
        }
    }

    public static void main(String[] args) throws IOException {
        createTable();
        insertRecord();
        getRecord();
        scanAll();
        updateRecord();
        deleteColumn();
    }
}
```

---

## Key Things to Remember

|Concept|One-liner|
|---|---|
|Hive partition column|NOT listed in main schema; goes in `PARTITIONED BY`|
|Hive bucketing column|IS listed in schema; goes in `CLUSTERED BY`|
|LOAD DATA LOCAL|Reads from Linux filesystem, not HDFS|
|HBase update|Just `put` again on same row+column — overwrites|
|HBase delete column family for one row|Delete each column manually|
|Java API update|Same as insert — `Put` on existing row key|
|`Bytes.toBytes()`|Wraps every value in HBase Java API|
|`HBaseConfiguration.create()`|Always first line of Java API code|