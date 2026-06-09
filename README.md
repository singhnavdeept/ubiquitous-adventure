# 🌌 Ubiquitous Adventure: Core CS, Backend, & Big Data Study Vault

Welcome to the **Ubiquitous Adventure** repository. This repository serves as a centralized, highly structured, and production-grade Computer Science study vault. It is designed for deep-dive technical interview preparation, placement tests, practical exams, and backend engineering mastery.

---

## 📂 Repository Directory Map

Below is a detailed layout of the repository, grouping files by domain and feature set:

```
ubiquitous-adventure/
├── 📁 Assets/                          # Centralized assets and technical diagrams
│   ├── PACELC_theorem.png              # Visual diagram mapping PACELC consistency bounds
│   └── Pasted Image *                  # Screenshots mapping DBMS/Hadoop behaviors
│
├── 📁 Backend (theory)/                 # Server-side architecture & Framework internals
│   ├── 📄 1.1 HTTP HTTPS.md             # Transport protocols, TLS handshakes, HTTP status codes
│   ├── 📄 Backend Engineering Roadmap.md # Full technical stack blueprint for backend career paths
│   ├── 📄 Spring Boot REST API Flow and Implementation.md # Tomcat, DispatcherServlet Request flow
│   └── 📄 Spring Data JPA CRUD Internals.md               # JpaRepository proxy, entity lifecycle states
│
├── 📁 Big Data/                        # Distributed storage, parallel processing & NoSQL
│   ├── 📄 1. Introduction to Hadoop and HDFS.md # Data locality, replication, NameNode/DataNode
│   ├── 📄 2. MapReduce and YARN.md      # Map/Reduce processing, YARN resource allocation
│   ├── 📄 3. Apache Hive.md             # Hive architecture, metastores, partitioning, bucketing
│   ├── 📄 3.1 Partitions and Buckets.md # Deep dive into partition and bucket performance gains
│   ├── 📄 3.2 Hive RDMS deep dive.md    # Interfacing relational databases with Hive schemas
│   ├── 📄 4. Apache HBase.md            # Column-oriented storage, LSM trees, RegionServers
│   ├── 📄 5. Apache Cassandra.md        # Ring topology, consistent hashing, Cassandra keyspaces
│   ├── 📄 5.1 Cassandra Practice questions.md # Exam Q&As on Cassandra architecture
│   ├── 📄 6. Apache Hive Clustering and Bucketing Problems.md # Step-by-step practical clustering
│   ├── 📄 Installation Guide.md         # WSL Ubuntu installation commands for Hadoop/Hive
│   ├── 📄 Sample question run 1.md      # Sample Hadoop exam questions
│   └── 📁 Hadoop/                       # Hive practical command references
│       ├── 📄 Big data using JAVA.md    # Java MapReduce API implementation examples
│       ├── 📄 Commands.md               # Core HDFS CLI commands reference
│       ├── 📄 Hive Commands.md          # 80/20 rule Hive DDL and DML queries
│       ├── 📄 Joins in Hive.md          # Map-side joins, bucket map joins, outer joins
│       ├── 📄 Loading Local Data into Hive Partitions.md # WSL absolute vs relative paths guide
│       └── 📄 hbase-hive-commands.md    # HBase table integrations inside Hive
│
├── 📁 Databases/                       # DBMS internals & transaction guarantees
│   └── 📁 NO SQL/                       # NoSQL Cassandra internals
│       └── 📄 Cassandra.md              # Gossip protocol, hint-handoffs, read/write repair
│
├── 📁 DEEP dive/                        # System architecture breakdowns
│   ├── 📄 README.md                    # Catalog of deep-dive cases
│   ├── 📄 Redis.md                     # Redis threading, persistence (AOF/RDB), cluster slots
│   └── 📄 Uber.md                      # Dispatch engines, geospatial indices (H3), WebSockets
│
├── 📁 DSA/                             # Data Structures & Algorithms (C++ Focus)
│   ├── 📁 Cpp CP Test Prep/             # Placement test practice trackers
│   │   └── 📄 Practice Questions Tracker.md # C++ STL priority_queue, DSU, and 50 LeetCode links
│   ├── 📁 Questions/                    # Topic-specific DSA interview questions
│   │   ├── 📄 Binary Tree top 5 questions.md
│   │   ├── 📄 Linked List top 5 question.md
│   │   └── 📁 Codeforces sol/           # Competitive programming solutions
│   ├── 📄 DSA_Pattern_Questions.md      # Sliding window, two-pointer, DFS/BFS graph patterns
│   └── 📄 Untitled.md                   # Scratch DSA problems notebook
│
├── 📁 Excalidraw/                      # System design and algorithm diagrams
│   └── 📄 *.excalidraw.md               # Interactive drawings mapping queues, trees, and servers
│
├── 📁 GOLANG/                          # Systems programming and microservices
│   └── 📁 Notes/                        # Multi-phase Go mastery program
│       ├── 📄 Phase_1_Go_Language_Fundamentals.md
│       ├── 📄 Phase_2_Concurrency.md     # Goroutines, Channels, Mutexes, Select blocks
│       ├── 📄 Phase_3_HTTP_Servers_REST_APIs.md
│       ├── 📄 Phase_4_Databases.md
│       ├── 📄 Phase_5_Authentication_Security.md
│       ├── 📄 Phase_6_Testing.md         # Unit testing, benchmarks, table-driven tests
│       ├── 📄 Phase_7_gRPC_Protocol_Buffers.md
│       ├── 📄 Phase_8_Microservices_Patterns.md
│       ├── 📄 Phase_9_Deployment_DevOps.md
│       └── 📄 Phase_10_Advanced_Go_Performance.md
│
├── 📁 Projects/                        # End-to-end sandbox software applications
│   ├── 📁 Docker Cleanup Daemon/        # Go-based daemon managing docker disk pruning
│   │   └── 📄 Project Architecture & Go Learning Guide.md
│   └── 📁 Resume Collector/             # Fullstack CV collector and parsing pipeline
│       └── 📄 Drawing *.excalidraw.md
│
├── 📄 Dictionary.md                    # Core computer science terminology glossary
└── 📄 Test BENCH.md                     # Sandbox testing notepad
```

---

## 🏛️ Core Technical Pillars

This vault organizes advanced computer science curriculum into five core modules:

### 1. Backend Engineering & Spring Boot Internals
Located in [Backend (theory)/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Backend%20(theory)), this module dissects the inner workings of enterprise-grade Java servers:
* **Spring Boot Request Flow**: Details the architectural sequence of an HTTP request. Tomcat accepts the network stream, routes it through the servlet filter chain, hands it off to `DispatcherServlet` (Front Controller), queries `HandlerMapping` and `HandlerAdapter`, executes the `@RestController`, delegates database operations, and converts Java DTOs to JSON using Jackson.
* **Spring Data JPA & Hibernate**: Covers the repository design pattern (`JpaRepository` proxy generation). Explains entity lifecycle states (**Transient**, **Persistent/Managed**, **Detached**, **Removed**) and demonstrates the power of **Dirty Checking** (how Hibernate automatically flushes database SQL updates on transaction commits without calling `save()`).

### 2. Big Data & Hadoop Ecosystem
Located in [Big Data/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data), this module covers large-scale distributed systems:
* **HDFS Storage**: Focuses on HDFS architecture (NameNode, Secondary NameNode, DataNodes), Block replication policies, and the principal of **Data Locality** (shipping computation code to where the data is stored instead of moving gigabytes of data over networks).
* **MapReduce & YARN**: Focuses on parallel data processing pipelines (Map, Shuffle-and-Sort, Reduce) and YARN resource mapping (ResourceManager, NodeManager, ApplicationMaster).
* **Apache Hive**: Explains SQL overlays on top of HDFS, detailed structures for **Static vs. Dynamic Partitioning** (optimizing subdirectories) and **Bucketing** (hash-based file segmentation).
* **NoSQL Engines**: Breaks down **HBase** (column-oriented, HFiles, Write-Ahead Logs, RegionServers) and **Cassandra** (fully distributed peer-to-peer ring, gossip protocol, write-repair, tunables).

### 3. Databases & Distributed Systems
Located in [Databases/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases) and integrated throughout notes:
* **Transaction Isolation Anomalies**: Deep dive into ACID anomalies including **Dirty Reads**, **Non-repeatable Reads**, **Phantom Reads**, **Write Skews**, and **Lost Updates** under standard ANSI SQL isolation levels.
* **Distributed Consensus**: Core consensus protocols like **Raft** and **Paxos** ensuring data alignment in multi-node clusters.
* **Consistency Theorems**: Breakdown of the **CAP Theorem** (Consistency vs. Availability under network partitions) and **PACELC Theorem** (balancing latency and consistency under normal operation).

### 4. C++ Data Structures & Algorithms
Located in [DSA/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA):
* **Placement Prep**: Curated [Practice Questions Tracker.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Cpp%20CP%20Test%20Prep/Practice%20Questions%20Tracker.md) featuring 50 non-premium LeetCode problems covering priority queues (Heaps), Disjoint Set Union (DSU), Binary Trees, and advanced Graph algorithms.
* **STL reference**: C++ syntax guides for defining custom comparators for `std::priority_queue` and optimizing DSU operations using **Union by Rank** and **Path Compression**.

### 5. Systems Programming in Go
Located in [GOLANG/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG):
* **Go Concurrency**: Mastery notes on CSP (Communicating Sequential Processes), Goroutines, Channels, Select blocks, Mutexes, and WaitGroups.
* **Microservices**: Deep-dive patterns into **gRPC** (Protocol Buffers, HTTP/2 multiplexing) and microservice architecture deployments.

---

## 🛠️ Sandbox Projects

The workspace includes active software projects designed to apply the theoretical backend concepts:

1. **Docker Cleanup Daemon**:
   - *Directory*: [Projects/Docker Cleanup Daemon/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Docker%20Cleanup%20Daemon)
   - *Purpose*: A systems-level Go daemon that runs in the background, monitors system disk usage, and triggers Docker API prunes automatically to clean up dangling images, unused volumes, and stopped containers when thresholds are exceeded.
2. **Resume Collector**:
   - *Directory*: [Projects/Resume Collector/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Resume%20Collector)
   - *Purpose*: A CV parsing and collection utility mapping candidate documents to structured schema pipelines.

---

## 📖 How to Navigate & Use this Vault

This folder is designed to be viewed using a Markdown renderer (like **VS Code Markdown Preview** or **Obsidian**). 

### Key Tips:
* **Interlinked Notes**: Files use Wiki-style links (e.g., `[[1.1 Data Models]]`) or clickable file URI links. Click on any file path inside a note to jump directly to it.
* **Diagram Rendering**: Ensure your markdown viewer supports **Mermaid diagrams** to render the request flow graphs and sequence flows correctly.
* **Code Blocks**: Every code block is fully typed and annotated line-by-line in Java, C++, Go, SQL, or YAML, making it easy to copy-paste code to local compilers for quick test runs.
