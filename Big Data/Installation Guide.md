# Big Data Lab Setup on Ubuntu 22.04 (WSL)

## Version Compatibility Matrix

|Software|Version|Java Required|Notes|
|---|---|---|---|
|Ubuntu (WSL)|22.04 LTS|—|Base OS|
|Java (OpenJDK)|8|—|Common denominator for all tools below|
|Hadoop|3.3.6|Java 8/11|Latest stable 3.3.x; well tested on WSL|
|Apache Hive|3.1.3|Java 8|Works with Hadoop 3.3.6; Derby metastore|
|Apache HBase|2.4.17|Java 8/11|Stable; pseudo-distributed on HDFS|
|Apache Cassandra|4.1.x|Java 8/11|Lighter than 5.x; APT install|

> **Why Java 8?** Hive 3.x has known issues with Java 11+. Using Java 8 across the board avoids compatibility headaches for this academic lab setup.

---

## Prerequisites

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y ssh openssh-server pdsh wget curl net-tools
```

Start SSH (WSL doesn't run systemd by default):

```bash
sudo service ssh start
```

Set up passwordless SSH (required by Hadoop):

```bash
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
ssh localhost   # should connect without password; type 'exit' after
```

---

## Part 1 — Java 8

```bash
sudo apt install -y openjdk-8-jdk
java -version   # should show openjdk version "1.8.0_xxx"
```

Find JAVA_HOME (you'll need this for configs below):

```bash
readlink -f /usr/bin/java | sed "s:bin/java::"
# Typically: /usr/lib/jvm/java-8-openjdk-amd64/
```

---

## Part 2 — Apache Hadoop 3.3.6 (Pseudo-Distributed)

### Download & Extract

```bash
cd ~
wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz
tar -xzf hadoop-3.3.6.tar.gz
sudo mv hadoop-3.3.6 /usr/local/hadoop
sudo chown -R $USER:$USER /usr/local/hadoop
```

### Environment Variables

Add to `~/.bashrc`:

```bash
# Hadoop
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
```

```bash
source ~/.bashrc
hadoop version   # verify
```

### Configure Hadoop

**`/usr/local/hadoop/etc/hadoop/hadoop-env.sh`** — add/uncomment:

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
```

**`/usr/local/hadoop/etc/hadoop/core-site.xml`**:

```xml
<configuration>
  <property>
    <name>fs.defaultFS</name>
    <value>hdfs://localhost:9000</value>
  </property>
  <property>
    <name>hadoop.tmp.dir</name>
    <value>/usr/local/hadoop/tmp</value>
  </property>
</configuration>
```

**`/usr/local/hadoop/etc/hadoop/hdfs-site.xml`**:

```xml
<configuration>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
  <property>
    <name>dfs.namenode.name.dir</name>
    <value>file:///usr/local/hadoop/hdfs/namenode</value>
  </property>
  <property>
    <name>dfs.datanode.data.dir</name>
    <value>file:///usr/local/hadoop/hdfs/datanode</value>
  </property>
</configuration>
```

**`/usr/local/hadoop/etc/hadoop/mapred-site.xml`**:

```xml
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
  <property>
    <name>mapreduce.application.classpath</name>
    <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>
  </property>
</configuration>
```

**`/usr/local/hadoop/etc/hadoop/yarn-site.xml`**:

```xml
<configuration>
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
  <property>
    <name>yarn.nodemanager.env-whitelist</name>
    <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>
  </property>
</configuration>
```

### Create Directories & Format NameNode

```bash
mkdir -p /usr/local/hadoop/hdfs/namenode
mkdir -p /usr/local/hadoop/hdfs/datanode
mkdir -p /usr/local/hadoop/tmp
hdfs namenode -format
```

### Start / Stop Hadoop

```bash
# Start SSH first (always needed before starting Hadoop on WSL)
sudo service ssh start

start-dfs.sh
start-yarn.sh

# Verify processes
jps
# Should show: NameNode, DataNode, SecondaryNameNode, ResourceManager, NodeManager
```

Web UIs (open in Windows browser):

- HDFS NameNode: http://localhost:9870
- YARN ResourceManager: http://localhost:8088

```bash
# Stop
stop-yarn.sh
stop-dfs.sh
```

### HDFS Basic Commands

```bash
hdfs dfs -mkdir /user
hdfs dfs -mkdir /user/$USER
hdfs dfs -ls /
hdfs dfs -put localfile.txt /user/$USER/
hdfs dfs -cat /user/$USER/localfile.txt
```

### Word Count (MapReduce via CLI)

```bash
# Create input
echo "hello world hello hadoop world" > ~/wc_input.txt
hdfs dfs -mkdir -p /wc/input
hdfs dfs -put ~/wc_input.txt /wc/input/

# Run
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar \
  wordcount /wc/input /wc/output

# View output
hdfs dfs -cat /wc/output/part-r-00000
```

---

## Part 3 — MapReduce with YARN (Java Code)

### Project Structure

```
WordCount/
├── WordCount.java
└── (compile and jar here)
```

### WordCount.java

```java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import java.io.IOException;
import java.util.StringTokenizer;

public class WordCount {

  public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();
    public void map(Object key, Text value, Context context)
        throws IOException, InterruptedException {
      StringTokenizer itr = new StringTokenizer(value.toString());
      while (itr.hasMoreTokens()) {
        word.set(itr.nextToken());
        context.write(word, one);
      }
    }
  }

  public static class IntSumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
    private IntWritable result = new IntWritable();
    public void reduce(Text key, Iterable<IntWritable> values, Context context)
        throws IOException, InterruptedException {
      int sum = 0;
      for (IntWritable val : values) sum += val.get();
      result.set(sum);
      context.write(key, result);
    }
  }

  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
    Job job = Job.getInstance(conf, "word count");
    job.setJarByClass(WordCount.class);
    job.setMapperClass(TokenizerMapper.class);
    job.setCombinerClass(IntSumReducer.class);
    job.setReducerClass(IntSumReducer.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);
    FileInputFormat.addInputPath(job, new Path(args[0]));
    FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
```

### Compile & Run

```bash
mkdir wordcount_classes
javac -classpath $(hadoop classpath) -d wordcount_classes WordCount.java
jar -cvf wordcount.jar -C wordcount_classes .

hdfs dfs -rm -r /wc/output   # clean previous output
hadoop jar wordcount.jar WordCount /wc/input /wc/output
hdfs dfs -cat /wc/output/part-r-00000
```

> **Note:** For SumOfEven, Palindrome, Factorial, and Armstrong — follow the same structure: one Mapper class, one Reducer class, and a main driver. Only the map/reduce logic changes.

---

## Part 4 — Apache Hive 3.1.3

### Download & Extract

```bash
cd ~
wget https://archive.apache.org/dist/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
tar -xzf apache-hive-3.1.3-bin.tar.gz
sudo mv apache-hive-3.1.3-bin /usr/local/hive
sudo chown -R $USER:$USER /usr/local/hive
```

### Environment Variables

Add to `~/.bashrc`:

```bash
# Hive
export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin
```

```bash
source ~/.bashrc
```

### Fix Guava Conflict (common issue with Hive 3 + Hadoop 3)

```bash
rm $HIVE_HOME/lib/guava-19.0.jar
cp $HADOOP_HOME/share/hadoop/common/lib/guava-27.0-jre.jar $HIVE_HOME/lib/
```

### Configure Hive

**Create HDFS directories for Hive:**

```bash
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /tmp
hdfs dfs -chmod g+w /user/hive/warehouse
```

**`/usr/local/hive/conf/hive-site.xml`** (create this file):

```xml
<configuration>
  <property>
    <name>hive.metastore.warehouse.dir</name>
    <value>/user/hive/warehouse</value>
  </property>
  <property>
    <name>hive.metastore.db.type</name>
    <value>derby</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionURL</name>
    <value>jdbc:derby:;databaseName=/usr/local/hive/metastore_db;create=true</value>
  </property>
  <property>
    <name>javax.jdo.option.ConnectionDriverName</name>
    <value>org.apache.derby.jdbc.EmbeddedDriver</value>
  </property>
  <property>
    <name>hive.cli.print.header</name>
    <value>true</value>
  </property>
</configuration>
```

### Initialize Metastore & Launch

```bash
# Hadoop must be running before this
schematool -initSchema -dbType derby

hive
```

### Sample HiveQL Operations

```sql
-- Create database and table
CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

CREATE TABLE employees (
  id INT,
  name STRING,
  salary FLOAT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Load data (create a CSV first)
-- /tmp/emp.csv: 1,Alice,50000
LOAD DATA LOCAL INPATH '/tmp/emp.csv' INTO TABLE employees;

SELECT * FROM employees;
SELECT name, salary FROM employees WHERE salary > 40000;

-- Partitioning
CREATE TABLE emp_part (id INT, name STRING)
PARTITIONED BY (dept STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- Bucketing
CREATE TABLE emp_bucket (id INT, name STRING)
CLUSTERED BY (id) INTO 4 BUCKETS
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',';

-- Operators
SELECT COUNT(*), AVG(salary) FROM employees;
SELECT * FROM employees ORDER BY salary DESC;
```

---

## Part 5 — Apache HBase 2.4.17 (Pseudo-Distributed)

### Download & Extract

```bash
cd ~
wget https://archive.apache.org/dist/hbase/2.4.17/hbase-2.4.17-bin.tar.gz
tar -xzf hbase-2.4.17-bin.tar.gz
sudo mv hbase-2.4.17 /usr/local/hbase
sudo chown -R $USER:$USER /usr/local/hbase
```

### Environment Variables

Add to `~/.bashrc`:

```bash
# HBase
export HBASE_HOME=/usr/local/hbase
export PATH=$PATH:$HBASE_HOME/bin
```

```bash
source ~/.bashrc
```

### Configure HBase

**`/usr/local/hbase/conf/hbase-env.sh`** — add:

```bash
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HBASE_MANAGES_ZK=true
```

**`/usr/local/hbase/conf/hbase-site.xml`**:

```xml
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>hdfs://localhost:9000/hbase</value>
  </property>
  <property>
    <name>hbase.cluster.distributed</name>
    <value>true</value>
  </property>
  <property>
    <name>hbase.zookeeper.quorum</name>
    <value>localhost</value>
  </property>
  <property>
    <name>hbase.zookeeper.property.clientPort</name>
    <value>2181</value>
  </property>
  <property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>/usr/local/hbase/zookeeper</value>
  </property>
  <property>
    <name>dfs.replication</name>
    <value>1</value>
  </property>
</configuration>
```

### Start / Stop HBase

```bash
# Hadoop (HDFS) must be running first
start-hbase.sh

# Verify
jps   # should show HMaster, HRegionServer, HQuorumPeer in addition to Hadoop daemons

stop-hbase.sh
```

### HBase Shell Commands

```bash
hbase shell
```

```
# General Commands
status
version
whoami

# Table Operations
create 'students', 'info', 'grades'
list
describe 'students'

# CRUD
put 'students', 'row1', 'info:name', 'Alice'
put 'students', 'row1', 'info:age', '21'
put 'students', 'row1', 'grades:math', '95'

get 'students', 'row1'
get 'students', 'row1', 'info:name'

scan 'students'
scan 'students', {LIMIT => 5}

delete 'students', 'row1', 'info:age'
deleteall 'students', 'row1'

# Prefix Filter
scan 'students', {FILTER => "PrefixFilter('row')"}

# Single Column Value Filter
import org.apache.hadoop.hbase.filter.SingleColumnValueFilter
import org.apache.hadoop.hbase.filter.CompareFilter
import org.apache.hadoop.hbase.filter.BinaryComparator
scan 'students', {FILTER => "SingleColumnValueFilter('grades', 'math', =, 'binary:95')"}

# TTL — set at table/column family level (seconds)
alter 'students', {NAME => 'grades', TTL => 86400}   # 1 day TTL

# Count and disable/drop
count 'students'
disable 'students'
drop 'students'
```

### HBase Java API (pom.xml dependencies)

```xml
<dependency>
  <groupId>org.apache.hbase</groupId>
  <artifactId>hbase-client</artifactId>
  <version>2.4.17</version>
</dependency>
```

Basic Java snippet:

```java
Configuration config = HBaseConfiguration.create();
config.set("hbase.zookeeper.quorum", "localhost");
config.set("hbase.zookeeper.property.clientPort", "2181");

try (Connection connection = ConnectionFactory.createConnection(config);
     Table table = connection.getTable(TableName.valueOf("students"))) {

    // Put
    Put put = new Put(Bytes.toBytes("row2"));
    put.addColumn(Bytes.toBytes("info"), Bytes.toBytes("name"), Bytes.toBytes("Bob"));
    table.put(put);

    // Get
    Get get = new Get(Bytes.toBytes("row2"));
    Result result = table.get(get);
    byte[] value = result.getValue(Bytes.toBytes("info"), Bytes.toBytes("name"));
    System.out.println(Bytes.toString(value));
}
```

---

## Part 6 — Apache Cassandra 4.1.x

> Cassandra runs independently — no Hadoop required.

### Install Java 11 for Cassandra (alongside Java 8)

```bash
sudo apt install -y openjdk-11-jdk
```

Set Java 11 as active for Cassandra session (or use update-alternatives):

```bash
sudo update-alternatives --config java
# Select java-11 when prompted
```

> **Note:** Switch back to Java 8 (`sudo update-alternatives --config java`) when working with Hadoop/Hive/HBase.

### Add Cassandra Repository

```bash
sudo apt install -y curl gnupg

curl -o /etc/apt/keyrings/apache-cassandra.asc \
  https://downloads.apache.org/cassandra/KEYS

echo "deb [signed-by=/etc/apt/keyrings/apache-cassandra.asc] \
  https://debian.cassandra.apache.org 41x main" | \
  sudo tee /etc/apt/sources.list.d/cassandra.list

sudo apt update
```

### Install Cassandra

```bash
sudo apt install -y cassandra
```

### Start Cassandra (WSL — no systemd)

```bash
# Start manually (WSL doesn't have systemd by default)
sudo cassandra -R   # -R allows running as root if needed

# Or if running as non-root:
cassandra
```

Wait ~30 seconds, then verify:

```bash
nodetool status
# Look for: UN (Up/Normal) in the Status/State column
```

### Connect with cqlsh

```bash
cqlsh
```

### Cassandra Architecture Concepts Recap

|Concept|Description|
|---|---|
|Peer-to-peer|No master node; all nodes equal|
|Gossip Protocol|Nodes share state info every second|
|Replication Factor|Number of copies of each row across nodes|
|Consistency Level|How many replicas must respond (ONE, QUORUM, ALL)|
|Write Path|Commit log → Memtable → SSTable flush|
|Read Path|Memtable → Row cache → SSTable (Bloom filter first)|

### CQL Operations

```cql
-- Keyspace
CREATE KEYSPACE college
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE college;

-- Table
CREATE TABLE students (
  id UUID PRIMARY KEY,
  name TEXT,
  age INT,
  dept TEXT
);

-- Insert
INSERT INTO students (id, name, age, dept)
  VALUES (uuid(), 'Alice', 21, 'CS');

-- Query
SELECT * FROM students;
SELECT name, dept FROM students WHERE id = <uuid>;

-- Update / Delete
UPDATE students SET age = 22 WHERE id = <uuid>;
DELETE FROM students WHERE id = <uuid>;

-- Indexes
CREATE INDEX ON students (dept);
SELECT * FROM students WHERE dept = 'CS';

-- Consistency
CONSISTENCY QUORUM;
SELECT * FROM students;
```

---

## Quick Reference: Starting Everything

```bash
# 1. SSH (always first on WSL)
sudo service ssh start

# 2. Hadoop
start-dfs.sh && start-yarn.sh

# 3. HBase (after Hadoop)
start-hbase.sh

# 4. Hive — just run 'hive' (uses Derby embedded, no daemon)

# 5. Cassandra (separate terminal, Java 11 active)
cassandra

# Verify all running
jps
nodetool status   # for Cassandra
```

## Common WSL Gotchas

|Issue|Fix|
|---|---|
|SSH connection refused|`sudo service ssh start`|
|`JAVA_HOME` not set error|Check `~/.bashrc` is sourced; run `source ~/.bashrc`|
|NameNode not starting|Delete `hdfs/namenode` dir and re-format: `hdfs namenode -format`|
|HBase ZooKeeper fails|Make sure HDFS is running; check Windows Firewall allows Java|
|Cassandra won't start|Use Java 11 (`update-alternatives --config java`); wait 30s after starting|
|Hive Guava error|Replace `guava-19.0.jar` with Hadoop's `guava-27.0-jre.jar` in Hive lib|
|Hadoop Web UI not loading|Confirm ports 9870/8088 aren't blocked; try `http://127.0.0.1:9870`|