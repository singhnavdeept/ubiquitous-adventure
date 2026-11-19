---
tags:
Date: 2026-05-23
---
	kkkkk

## 
create table using java api

```java 
create table using java api

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Admin;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.HColumnDescriptor;


public class Insertlp {

    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();

        Connection con = ConnectionFactory.createConnection(conf);

        Admin admin = con.getAdmin();

        TableName tableName = TableName.valueOf("rp");

        if (admin.tableExists(tableName)) {
            System.out.println("table is already existing");
        } else {

            HTableDescriptor tableDescriptor = new HTableDescriptor(tableName);

            tableDescriptor.addFamily(new HColumnDescriptor("lpfamily"));

            admin.createTable(tableDescriptor);

            System.out.println("Table has been created successfully");
        }

	con.close();
    }
}
```


```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.Connection;
import org.apache.hadoop.hbase.client.ConnectionFactory;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.client.Table;

public class Insertlp {

    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();

        Connection con = ConnectionFactory.createConnection(conf);

        Table table = con.getTable(TableName.valueOf("rp"));

        Put p = new Put("101".getBytes());

        p.addColumn("lpfamily".getBytes(),"name1".getBytes(),"Shubham".getBytes());

        p.addColumn("lpfamily".getBytes(),"name2".getBytes(),"Aman".getBytes());

        p.addColumn("lpfamily".getBytes(),"marks".getBytes(),"77".getBytes());

        table.put(p);

        System.out.println("Data Inserted Successfully");

        table.close();
        con.close();
    }
}
```



```java 
deletion using java api

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;

public class Insertlp {

    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();

        Connection con =ConnectionFactory.createConnection(conf);

        Table table =con.getTable(TableName.valueOf("rp"));

        Delete d = new Delete("101".getBytes());

        d.addColumns("info".getBytes(), "name".getBytes());

	table.delete(d);

        System.out.println("daya delete successfully");

        con.close();
    }
}
```



Here are all the operations following that exact template style:

**pom.xml dependency first:**

```xml
<dependency>
    <groupId>org.apache.hbase</groupId>
    <artifactId>hbase-client</artifactId>
    <version>2.4.17</version>
</dependency>
```

---

**Insert (Put)**

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;

public class InsertRecord {
    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();
        Connection con = ConnectionFactory.createConnection(conf);

        Table table = con.getTable(TableName.valueOf("students"));
                                                                                                                            
        Put put = new Put(Bytes.toBytes("2001"));
        put.addColumn(Bytes.toBytes("personal"), Bytes.toBytes("name"),  Bytes.toBytes("Emma"));
        put.addColumn(Bytes.toBytes("personal"), Bytes.toBytes("age"),   Bytes.toBytes("22"));
        put.addColumn(Bytes.toBytes("academic"), Bytes.toBytes("course"), Bytes.toBytes("CS"));
        put.addColumn(Bytes.toBytes("academic"), Bytes.toBytes("year"),  Bytes.toBytes("2024"));

        table.put(put);
        System.out.println("Record inserted successfully");

        con.close();
    }
}
```

---

**Get (Read single row)**

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;

public class GetRecord {
    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();
        Connection con = ConnectionFactory.createConnection(conf);

        Table table = con.getTable(TableName.valueOf("students"));

        Get get = new Get(Bytes.toBytes("2001"));
        Result result = table.get(get);

        String name   = Bytes.toString(result.getValue(Bytes.toBytes("personal"), Bytes.toBytes("name")));
        String course = Bytes.toString(result.getValue(Bytes.toBytes("academic"), Bytes.toBytes("course")));

        System.out.println("Name: "   + name);
        System.out.println("Course: " + course);

        con.close();
    }
}
```

---

**Scan (Read all rows)**

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;

public class ScanTable {
    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();
        Connection con = ConnectionFactory.createConnection(conf);

        Table table = con.getTable(TableName.valueOf("students"));

        Scan scan = new Scan();
        ResultScanner scanner = table.getScanner(scan);

        for (Result result : scanner) {
            String rowKey = Bytes.toString(result.getRow());
            String name   = Bytes.toString(result.getValue(Bytes.toBytes("personal"), Bytes.toBytes("name")));
            String course = Bytes.toString(result.getValue(Bytes.toBytes("academic"), Bytes.toBytes("course")));
            System.out.println("Row: " + rowKey + " | Name: " + name + " | Course: " + course);
        }

        scanner.close();
        con.close();
    }
}
```

---

**Update (same as Put — just overwrite)**

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;

public class UpdateRecord {
    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();
        Connection con = ConnectionFactory.createConnection(conf);

        Table table = con.getTable(TableName.valueOf("students"));

        Put put = new Put(Bytes.toBytes("2003"));
        put.addColumn(Bytes.toBytes("personal"), Bytes.toBytes("email"), Bytes.toBytes("sophia123@example.com"));

        table.put(put);
        System.out.println("Record updated successfully");

        con.close();
    }
}
```

---

**Delete (single column)**

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;
import org.apache.hadoop.hbase.util.Bytes;

public class DeleteColumn {
    public static void main(String[] args) throws Exception {

        Configuration conf = HBaseConfiguration.create();
        Connection con = ConnectionFactory.createConnection(conf);

        Table table = con.getTable(TableName.valueOf("students"));

        Delete delete = new Delete(Bytes.toBytes("2001"));
        delete.addColumn(Bytes.toBytes("academic"), Bytes.toBytes("course"));

        table.delete(delete);
        System.out.println("Column deleted successfully");

        con.close();
    }
}
```

---

**Delete entire row**

```java
        Delete delete = new Delete(Bytes.toBytes("2001"));
        // no addColumn = deletes entire row
        table.delete(delete);
        System.out.println("Row deleted successfully");
```

---

**One thing to note for IntelliJ** — HBase client pulls in a lot of transitive dependencies. If you get classpath conflicts, add this to your pom.xml:

```xml
<dependency>
    <groupId>org.apache.hbase</groupId>
    <artifactId>hbase-client</artifactId>
    <version>2.4.17</version>
    <exclusions>
        <exclusion>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-log4j12</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```