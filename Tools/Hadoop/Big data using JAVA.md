---
tags:
Date: 2026-05-23
---


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