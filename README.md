# 🌌 Ubiquitous Adventure: The Master Computer Science, Backend, & Systems Vault

Welcome to the **Ubiquitous Adventure** repository. This is a production-grade, centralized learning vault and systems engineering playground. It consolidates comprehensive study notes, structured roadmap guides, competitive programming trackers, and hands-on sandbox projects spanning backend engineering, distributed databases, Big Data clusters, systems programming in Go, system design, and DevOps automation.

---

## 📂 Repository Directory Map

Below is the exhaustive, multi-level map of the repository, providing clickable links to every directory and key note file:

```
ubiquitous-adventure/
├── 📁 Assets/                          # Centralized assets and technical diagrams
│   ├── 🖼️ [PACELC_theorem.png](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Assets/PACELC_theorem.png)
│   └── 🖼️ Pasted Image *
│
├── 📁 APPLICATION Tracker/             # Job/application trackers and templates
│
├── 📁 AiWorkflows/                     # Prompting structures & AI agent orchestrations
│
├── 📁 Atomic Notes/                    # Interlinked slip-box style micro-notes
│
├── 📁 Backend (theory)/                 # Server-side architecture & Framework internals
│   ├── 📄 [HTTP HTTPS.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Backend%20(theory)/HTTP%20HTTPS.md)                # HTTP/1.x vs 2 vs 3, TLS handshakes, HTTP status codes
│   ├── 📄 [Backend Engineering Roadmap.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Backend%20(theory)/Backend%20Engineering%20Roadmap.md) # Full technical stack blueprint for backend career paths
│   ├── 📄 [Spring Boot REST API Flow and Implementation.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Backend%20(theory)/Spring%20Boot%20REST%20API%20Flow%20and%20Implementation.md) # Tomcat, DispatcherServlet request flow
│   └── 📄 [Spring Data JPA CRUD Internals.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Backend%20(theory)/Spring%20Data%20JPA%20CRUD%20Internals.md)               # JpaRepository proxy, entity lifecycle states
│
├── 📁 Big Data/                        # Distributed storage, parallel processing & NoSQL
│   ├── 📄 [1. Introduction to Hadoop and HDFS.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/1.%20Introduction%20to%20Hadoop%20and%20HDFS.md) # Data locality, replication, NameNode/DataNode
│   ├── 📄 [2. MapReduce and YARN.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/2.%20MapReduce%20and%20YARN.md)      # Map/Reduce processing, YARN resource allocation
│   ├── 📄 [3. Apache Hive.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/3.%20Apache%20Hive.md)             # Hive architecture, metastores, partitioning, bucketing
│   ├── 📄 [3.1 Partitions and Buckets.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/3.1%20Partitions%20and%20Buckets.md) # Deep-dive into partition and bucket performance gains
│   ├── 📄 [3.2 Hive RDMS deep dive.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/3.2%20Hive%20RDMS%20deep%20dive.md)    # Interfacing relational databases with Hive schemas
│   ├── 📄 [4. Apache HBase.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/4.%20Apache%20HBase.md)            # Column-oriented storage, LSM trees, RegionServers
│   ├── 📄 [5. Apache Cassandra.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/5.%20Apache%20Cassandra.md)        # Ring topology, consistent hashing, Cassandra keyspaces
│   ├── 📄 [5.1 Cassandra Practice questions.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/5.1%20Cassandra%20Practice%20questions.md) # Exam Q&As on Cassandra architecture
│   ├── 📄 [6. Apache Hive Clustering and Bucketing Problems.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/6.%20Apache%20Hive%20Clustering%20and%20Bucketing%20Problems.md) # Step-by-step practical clustering
│   ├── 📄 [Installation Guide.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Installation%20Guide.md)         # WSL Ubuntu installation commands for Hadoop/Hive
│   ├── 📄 [Sample question run 1.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Sample%20question%20run%201.md)      # Sample Hadoop exam questions
│   └── 📁 Hadoop/                       # Hive practical command references
│       ├── 📄 [Big data using JAVA.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Hadoop/Big%20data%20using%20JAVA.md)    # Java MapReduce API implementation examples
│       ├── 📄 [Commands.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Hadoop/Commands.md)               # Core HDFS CLI commands reference
│       ├── 📄 [Hive Commands.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Hadoop/Hive%20Commands.md)          # 80/20 rule Hive DDL and DML queries
│       ├── 📄 [Joins in Hive.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Hadoop/Joins%20in%20Hive.md)          # Map-side joins, bucket map joins, outer joins
│       ├── 📄 [Loading Local Data into Hive Partitions.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Hadoop/Loading%20Local%20Data%20into%20Hive%20Partitions.md) # WSL absolute vs relative paths guide
│       └── 📄 [hbase-hive-commands.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data/Hadoop/hbase-hive-commands.md)    # HBase table integrations inside Hive
│
├── 📁 DailyNotes/                       # Daily study journals and incremental logs
│   ├── 📄 [2026-05-27.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DailyNotes/2026-05-27.md)
│   └── 📄 [2026-05-29.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DailyNotes/2026-05-29.md)
│
├── 📁 Data Engineering/                 # General data engineering principles
│   └── 📄 [Data Engineering Roadmap.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Data%20Engineering/Data%20Engineering%20Roadmap.md)   # Modern data stack, storage, compute & pipelines
│
├── 📁 Databases/                       # DBMS internals & transaction guarantees
│   ├── 📄 [Topics To Cover.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/Topics%20To%20Cover.md)
│   ├── 📁 COMMON TOPICS/
│   │   ├── 📄 [1.1 Data Models.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/1.1%20Data%20Models.md)        # Relational, document, graph storage structures
│   │   ├── 📄 [1.2 Schema design & Normalization.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/1.2%20Schema%20design%20&%20Normalization.md) # Normal forms (1NF-BCNF) & denormalization
│   │   ├── 📄 [1.3 Data types.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/1.3%20Data%20types.md)         # Serialization, storage layout, precision bounds
│   │   ├── 📄 [1.4 Constraints.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/1.4%20Constraints.md)        # Keys, checks, triggers, foreign keys
│   │   ├── 📄 [1.5 Indexes.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/1.5%20Indexes.md)            # B-Tree, Hash, GiST, GIN, write amplification
│   │   ├── 📄 [1.5.1 Database Indexes at scale.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/1.5.1%20Database%20Indexes%20at%20scale.md) # Composite ordering, covering indexes (INCLUDE)
│   │   ├── 📄 [2.3 CTE.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/2.3%20CTE.md)                # Common Table Expressions, recursive query loops
│   │   ├── 📄 [CAP Theorem.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/CAP%20Theorem.md)            # Consistency, availability, partition tolerance
│   │   ├── 📄 [Database Locks & Concurrency.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/Database%20Locks%20&%20Concurrency.md) # Shared/exclusive locks, 2PL, deadlock detection
│   │   ├── 📄 [Distributed Consensus.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/Distributed%20Consensus.md)  # Consensus logs (Paxos, Raft consensus)
│   │   ├── 📄 [Multi-Version Concurrency Control (MVCC).md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/Multi-Version%20Concurrency%20Control%20(MVCC).md) # snapshot isolation, undo logs, visibility
│   │   ├── 📄 [SIMD (Single Instruction, Multiple Data).md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/SIMD%20(Single%20Instruction,%20Multiple%20Data).md) # Vectorized analytic processing
│   │   └── 📄 [Transaction Isolation & Anomalies.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS/Transaction%20Isolation%20&%20Anomalies.md) # ANSI levels, Dirty/Phantom reads, write skew
│   ├── 📁 NO SQL/
│   │   └── 📄 [Cassandra.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/NO%20SQL/Cassandra.md)              # Gossip, read/write repair, consistency tunables
│   └── 📁 SQL/
│       ├── 📄 [2.1 SQL fundamentals.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/SQL/2.1%20SQL%20fundamentals.md)   # Core DQL/DML queries
│       ├── 📄 [2.2 Window Functions.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/SQL/2.2%20Window%20Functions.md)   # Partition, order, rank, lead, lag
│       ├── 📄 [2.4 Aggregation.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/SQL/2.4%20Aggregation.md)        # Grouping set rollups, groupings
│       ├── 📄 [2.5 Full-text search.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/SQL/2.5%20Full-text%20search.md)   # Inverted indices, BM25, lexeme parsing
│       └── 📄 [MYSQL Overview.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/SQL/MYSQL%20Overview.md)         # InnoDB engines, redo/undo log architecture
│
├── 📁 DEEP dive/                        # System architecture breakdowns
│   ├── 📄 [README.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DEEP%20dive/README.md)                    # Catalog of deep-dive cases
│   ├── 📄 [Redis.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DEEP%20dive/Redis.md)                     # Redis threading, persistence (AOF/RDB), cluster slots
│   └── 📄 [Uber.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DEEP%20dive/Uber.md)                      # Dispatch engines, geospatial indices (H3), WebSockets
│
├── 📁 Django/                           # Python web development internals
│   ├── 📄 [CORS and CSRF.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Django/CORS%20and%20CSRF.md)              # Web security protocols and cross-origin resource sharing
│   ├── 📄 [Django and NoSQL Database Relation.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Django/Django%20and%20NoSQL%20Database%20Relation.md) # Non-relational mapping to Django ORM
│   ├── 📄 [Django In-Depth.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Django/Django%20In-Depth.md)            # MVT architecture, middleware chains, WSGI/ASGI handlers
│   ├── 📄 [SQL .query() vs .explain().md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Django/SQL%20.query()%20vs%20.explain().md) # Query optimization, query plan evaluation
│   └── 📄 [XSS.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Django/XSS.md)                        # Cross-site scripting vulnerabilities and auto-escaping
│
├── 📁 DSA/                             # Data Structures & Algorithms (C++ Focus)
│   ├── 📄 [Codeforces Master Sheet.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Codeforces%20Master%20Sheet.md)    # Competitive programming tracking & ratings
│   ├── 📄 [DSA_Pattern_Questions.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/DSA_Pattern_Questions.md)      # Sliding window, two-pointer, DFS/BFS graph patterns
│   ├── 📄 [Python DSA Guide.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Python%20DSA%20Guide.md)           # Python collections, deque, heapq, bisect references
│   ├── 📄 [Untitled.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Untitled.md)                   # Scratch notes
│   ├── 📁 Bare Basics/
│   │   ├── 📄 [How to.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Bare%20Basics/How%20to.md)                 # Basic algorithms setup
│   │   ├── 📄 [Juspay code analysis.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Bare%20Basics/Juspay%20code%20analysis.md)   # Thread-safe tree locking algorithms
│   │   └── 📄 [M-ary Tree Lock Unlock.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Bare%20Basics/M-ary%20Tree%20Lock%20Unlock.md) # Lock propagation on parent-child trees
│   ├── 📁 Cpp CP Test Prep/             # Placement test practice trackers
│   │   └── 📄 [Practice Questions Tracker.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Cpp%20CP%20Test%20Prep/Practice%20Questions%20Tracker.md) # C++ STL priority_queue, DSU, and 50 LeetCode links
│   ├── 📁 Patterns Answer/
│   │   ├── 📄 [Greedy.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Patterns%20Answer/Greedy.md)                 # Greedy paradigms, intervals, knapsack
│   │   ├── 📄 [Stack.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Patterns%20Answer/Stack.md)                  # Monotonic stack patterns, next greater element
│   │   └── 📄 [Untitled.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Patterns%20Answer/Untitled.md)
│   └── 📁 Questions/                    # Topic-specific DSA interview questions
│       ├── 📄 [03 Graphs question and solution.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/03%20Graphs%20question%20and%20solution.md)
│       ├── 📄 [Binary Tree top 5 questions.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/Binary%20Tree%20top%205%20questions.md)
│       ├── 📄 [DSU (Disjoint Set Union).md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/DSU%20(Disjoint%20Set%20Union).md) # Union by rank, path compression
│       ├── 📄 [Heaps Max-Heaps Min-Heaps Heapify.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/Heaps%20Max-Heaps%20Min-Heaps%20Heapify.md) # O(N) heap construction, heapify
│       ├── 📄 [LFU Cache.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/LFU%20Cache.md)              # Least Frequently Used cache implementation
│       ├── 📄 [Linked List top 5 question.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/Linked%20List%20top%205%20question.md)
│       ├── 📄 [MCQs on Binary Trees.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/MCQs%20on%20Binary%20Trees.md)
│       ├── 📄 [Practice run 1.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/Practice%20run%201.md)
│       └── 📄 [Practice Run 2.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Questions/Practice%20Run%202.md)
│
├── 📁 Excalidraw/                      # System design and algorithm diagrams
│   └── 📄 [*.excalidraw.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Excalidraw/)               # Interactive drawings mapping queues, trees, and servers
│
├── 📁 GOLANG/                          # Systems programming and microservices
│   ├── 📄 [Complete Go Backend Mastery Roadmap.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Complete%20Go%20Backend%20Mastery%20Roadmap.md)
│   └── 📁 Notes/                        # Multi-phase Go mastery program
│       ├── 📄 [Phase_1_Go_Language_Fundamentals.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_1_Go_Language_Fundamentals.md)
│       ├── 📄 [Phase_2_Concurrency.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_2_Concurrency.md)     # Goroutines, Channels, Mutexes, Select blocks
│       ├── 📄 [Phase_3_HTTP_Servers_REST_APIs.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_3_HTTP_Servers_REST_APIs.md)
│       ├── 📄 [Phase_4_Databases.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_4_Databases.md)
│       ├── 📄 [Phase_5_Authentication_Security.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_5_Authentication_Security.md)
│       ├── 📄 [Phase_6_Testing.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_6_Testing.md)         # Unit testing, benchmarks, table-driven tests
│       ├── 📄 [Phase_7_gRPC_Protocol_Buffers.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_7_gRPC_Protocol_Buffers.md)
│       ├── 📄 [Phase_8_Microservices_Patterns.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_8_Microservices_Patterns.md)
│       ├── 📄 [Phase_9_Deployment_DevOps.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_9_Deployment_DevOps.md)
│       └── 📄 [Phase_10_Advanced_Go_Performance.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG/Notes/Phase_10_Advanced_Go_Performance.md)
│
├── 📁 Interesting topics/              # Miscellaneous computer science details
│   ├── 📄 [Cascading Failures.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Interesting%20topics/Cascading%20Failures.md)         # Circuit breakers, retries, jitter
│   ├── 📄 [Componenets of AWS.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Interesting%20topics/Componenets%20of%20AWS.md)         # AWS infrastructure, IAM, VPC, S3, RDS, Lambda
│   ├── 📄 [Difference Between Partition BY and group by.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Interesting%20topics/Difference%20Between%20Partition%20BY%20and%20group%20by.md) # Window vs GROUP BY grouping
│   ├── 📄 [Giving Output at compile time.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Interesting%20topics/Giving%20Output%20at%20compile%20time.md) # Metaprogramming, constexpr evaluation
│   ├── 📄 [How a Compiler works.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Interesting%20topics/How%20a%20Compiler%20works.md)      # AST, lexical parsing, code generation
│   └── 📄 [Processing of SQL Query.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Interesting%20topics/Processing%20of%20SQL%20Query.md)   # SQL parser engines, query execution planner
│
├── 📁 Projects/                        # End-to-end sandbox software applications
│   ├── 📄 [MdMaker documentation.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/MdMaker%20documentation.md)      # Auto document builders
│   ├── 📄 [Project Notes.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Project%20Notes.md)
│   ├── 📁 Data Warehousing in Mysql/
│   │   └── 📄 [Architecture.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Data%20Warehousing%20in%20Mysql/Architecture.md)           # Star/snowflake architectures, ETL pipelines
│   ├── 📁 Docker Cleanup Daemon/        # Go-based daemon managing docker disk pruning
│   │   └── 📄 [Project Architecture & Go Learning Guide.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Docker%20Cleanup%20Daemon/Project%20Architecture%20&%20Go%20Learning%20Guide.md)
│   └── 📁 Resume Collector/             # Fullstack CV collector and parsing pipeline
│
├── 📁 System Design/                   # System scaling and pattern architectures
│   ├── 📄 [1.1 Scaling to Millions.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/System%20Design/1.1%20Scaling%20to%20Millions.md)    # Vertical vs horizontal, stateless web, geo-routing
│   └── 📄 [Rate limiter.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/System%20Design/Rate%20limiter.md)               # Token bucket, sliding window rate limiters
│
├── 📁 Templates/
│   ├── 📄 [Daily Notes.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Templates/Daily%20Notes.md)
│   └── 📄 [Leetcode.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Templates/Leetcode.md)
│
├── 📁 Tools/                           # Development and Operations tooling
│   ├── 📁 Docker/
│   │   ├── 📄 [Docker Storyboard.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools/Docker/Docker%20Storyboard.md)
│   │   └── 📄 [Major Commands.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools/Docker/Major%20Commands.md)
│   ├── 📁 Jenkins/
│   │   ├── 📄 [Deploy code for Nginx.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools/Jenkins/Deploy%20code%20for%20Nginx.md)
│   │   └── 📄 [Overview.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools/Jenkins/Overview.md)
│   └── 📁 Kubernetees/                  # Container orchestration engine
│       ├── 📄 [01 Intro to K8.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools/Kubernetees/01%20Intro%20to%20K8.md)
│       ├── 📄 [02 Commands of K8S.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools/Kubernetees/02%20Commands%20of%20K8S.md)
│       └── 📄 [03 Architecture of K8.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools/Kubernetees/03%20Architecture%20of%20K8.md)
│
├── 📄 [Dictionary.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Dictionary.md)                    # Core computer science terminology glossary
├── 📄 [Jenkinsfile](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Jenkinsfile)                      # Pipeline-as-code deployment definitions
├── 📄 LICENSE
└── 📄 [Test BENCH.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Test%20BENCH.md)                     # Sandbox testing notepad
```

---

## 🏛️ Core Technical Modules & Deep Dives

This section details the primary technical pillars, theoretical architectural concepts, and code implementations contained inside the vault.

### 1. Backend Engineering & Framework Internals
Located in [Backend (theory)/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Backend%20(theory)) and [Django/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Django), this module covers Java (Spring Boot) and Python (Django) server execution architectures.

#### A. Spring Boot REST Request Pipeline
Every REST request maps through a structured lifecycle container:
```
Client Request -> Tomcat (HTTP Connection) 
                    -> Filter Chain (CORS, Security Filters)
                      -> DispatcherServlet (Front Controller)
                        -> HandlerMapping (Finds matching @RestController)
                          -> HandlerAdapter (Executes handler method)
                            -> Controller -> Service -> Repository (Database)
                              -> ResponseEntity DTO
                                -> Jackson HTTPMessageConverter -> JSON Response
```
- **Filter vs Interceptor**: Filters intercept requests at the Servlet level (HTTP-level tasks like CORS or logging). Interceptors belong to Spring MVC context and run after HandlerMapping but before Controller execution (perfect for application-level authentication).
- **Global Exceptions**: Uses `@RestControllerAdvice` and `@ExceptionHandler` annotations to intercept standard exceptions (e.g., `EntityNotFoundException`) and rewrite response payloads into clean, structured JSON format with descriptive status codes (e.g., HTTP 404).

#### B. Spring Data JPA & Hibernate Entity Lifecycle
Spring Data JPA creates dynamic proxies for interfaces extending `JpaRepository` at runtime. Hibernate manages entities under four discrete lifecycle states:
1. **Transient**: Created locally using the `new` keyword. Not associated with a database row or session.
2. **Persistent (Managed)**: Linked to an active database session. Any updates to this object's fields trigger automatic SQL synchronization upon transaction commit (**Dirty Checking**) without invoking explicit database updates.
3. **Detached**: The session closes or entity is explicitly evicted. Field changes are no longer tracked or saved automatically.
4. **Removed**: Scheduled for deletion. Database `DELETE` query fires upon transaction commit.

#### C. Django MVC/MVT & Web Security
- **MVT Chain**: Request -> URL Dispatcher -> View (business logic querying Models) -> Template -> Response.
- **Middleware stack**: A chain of hook classes processed on every request/response. Order is critical (e.g., `SecurityMiddleware` -> `SessionMiddleware` -> `CommonMiddleware` -> `CsrfViewMiddleware` -> `AuthenticationMiddleware`).
- **Security Defenses**:
  - **CORS (Cross-Origin Resource Sharing)**: Prevents malicious scripts on domain A from reading data from domain B via headers (`Access-Control-Allow-Origin`).
  - **CSRF (Cross-Site Request Forgery)**: Django injects custom tokens into forms, validating request headers for state-changing HTTP operations (POST, PUT, DELETE).
  - **XSS (Cross-Site Scripting)**: Django templates auto-escape HTML variables unless marked explicitly as `|safe`.

---

### 2. Big Data Systems & NoSQL Databases
Located in [Big Data/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Big%20Data) and [Databases/NO SQL/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/NO%20SQL), this module covers distributed clusters and massive non-relational database architectures.

#### A. HDFS & YARN Execution
- **Data Locality**: Minimizes network bottleneck by sending compile-jar task codes to the specific DataNodes holding the targets block partitions, rather than copying massive datasets to a central master processor.
- **YARN Roles**: `ResourceManager` allocates cluster CPU/RAM resources globally. `NodeManager` monitors resource bounds on individual machines. `ApplicationMaster` coordinates execution tasks for specific jobs.

#### B. Apache Hive Partitioning & Joins
Hive executes SQL queries by compiling them to distributed MapReduce, Tez, or Spark jobs.
- **Partitioning vs Bucketing**:
  - **Partitioning**: Splits datasets physically into folders based on specific columns (e.g., `dept=CS/`). Reduces input scan directory sizes.
  - **Bucketing**: Distributes data within directories using hash functions into fixed bucket file segments (e.g., 4 buckets). Optimizes queries with equal bucket sizes via Map-side joins.
- **Dynamic Partitioning Staging**:
  ```sql
  -- Loading data dynamically through staging table execution
  SET hive.exec.dynamic.partition.mode=nonstrict;
  
  INSERT OVERWRITE TABLE student_partitioned PARTITION (dept)
  SELECT id, name, gpa, dept FROM student_staging;
  ```

#### C. NoSQL: Column-Families vs Consistent Ring Topologies
- **Apache HBase (Master-Worker)**: Relies on HDFS. Features column families where data is stored contiguously in memory buffers called `MemStore`. When full, memory is flushed to disk as immutable `HFiles`. Employs LSM-Trees to convert random writes to sequential disk writes.
- **Apache Cassandra (P2P Cluster)**: Decentralized ring topology utilizing consistent hashing. Gossip protocol handles node discovery and cluster state detection. Read/write concurrency is tunable per query (e.g., `QUORUM` requires responses from a majority of nodes).
  ```sql
  -- Cassandra Keyspace Definition Example
  CREATE KEYSPACE study_vault WITH replication = {
      'class': 'SimpleStrategy',
      'replication_factor': 3
  };
  ```

---

### 3. Database Internals & Transaction Guarantees
Located in [Databases/COMMON TOPICS/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/COMMON%20TOPICS) and [Databases/SQL/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Databases/SQL), this module covers isolation levels, indexing mechanics, and consensus.

#### A. Concurrency Anomalies & Isolation Levels
When multiple transactions execute concurrently, they can trigger data race anomalies.

| Isolation Level | Dirty Read | Non-Repeatable Read | Phantom Read | Write Skew | Implementation Mechanism |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Read Uncommitted** | Allowed | Allowed | Allowed | Allowed | No read locks; direct memory read |
| **Read Committed** | Prevented | Allowed | Allowed | Allowed | Short-lived read locks (released immediately) |
| **Repeatable Read** | Prevented | Prevented | Allowed | Allowed | Long-lived read locks held until commit |
| **Snapshot Isolation**| Prevented | Prevented | Prevented | Allowed | MVCC timestamp snapshots; write conflict detection |
| **Serializable** | Prevented | Prevented | Prevented | Prevented | Range/Next-Key locks (2PL) or Serializable SSI |

* **Write Skew**: Occurs when two transactions read overlapping datasets, verify a global constraint (e.g., "At least one doctor must remain on call"), and then update *different* keys, resulting in a state violating the constraint (e.g., both doctors successfully check out).

#### B. MVCC (Multi-Version Concurrency Control)
Readers do not block writers, and writers do not block readers. When a transaction writes to a row, it writes a new version of the row marked with its transaction ID. Concurrent readers read older row versions matching their starting logical timestamp, ensuring consistent reads without requiring transaction locks.

#### C. Database Indexing Systems
- **B-Trees**: Highly balanced, high-fanout trees. Node size matches database block page size (e.g., 8KB or 16KB). A 3-level tree can hold millions of keys, requiring only 3 page reads. Page splits occur when a block runs out of room.
- **GIN (Generalized Inverted Index)**: An inverted index mapping individual tokens (e.g., tags, search words) to a sorted list of matching Row IDs (posting lists). GIN merges these posting lists during query time via streaming intersection, facilitating fast `AND`/`OR` searches for JSONB columns.
- **Covering Indexes (`INCLUDE`)**: B-Trees that copy additional non-indexed columns directly into leaf nodes. This permits the database to resolve queries directly from the index (**Index-Only Scan**), completely bypassing the secondary random disk fetch (heap access).
  ```sql
  -- B-Tree Covering Index containing search keys + payload values
  CREATE INDEX idx_orders_covering ON orders (customer_id) INCLUDE (order_date, total_amount);
  ```

---

### 4. Systems Programming in Go
Located in [GOLANG/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/GOLANG), this module provides a multi-phase systems programming roadmap covering language fundamentals, concurrency structures, and advanced runtime behaviors.

#### A. The G-M-P Scheduler
Go does not map goroutines 1:1 to OS threads. It implements an M:N scheduling model:
- **G (Goroutine)**: Execution thread context. Starts with a tiny 2KB dynamic stack.
- **M (Machine)**: OS Kernel thread.
- **P (Processor)**: Logical execution context required to execute Go code (defaults to CPU core count).
- **Work-Stealing**: If an thread's (`M`) local run queue of goroutines runs dry, it attempts to steal half the goroutines from another processor's (`P`) local run queue. This reduces global locking overhead and balances CPU utilization across all cores.

#### B. Channels and Select timeouts
Channels are typed conduits backed by the `hchan` struct, which contains a circular buffer queue, a mutex lock, and waiting lists for paused sender/receiver goroutines.
```go
// Timeout Pattern using Channels and Select
select {
case res := <-apiChan:
    fmt.Println("Received payload:", res)
case <-time.After(3 * time.Second):
    fmt.Println("API failed: Request timeout exceeded.")
}
```

---

### 5. System Design & Scaling Architectures
Located in [System Design/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/System%20Design) and [Interesting topics/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Interesting%20topics), this module outlines strategies for scaling applications to millions of concurrent users.

#### A. Horizontal Scaling Strategy
To transition from a single server to millions of users, applications must be decoupled and scaled:
- **Stateless Web Tier**: User session data is removed from web server memory and stored in shared key-value stores (e.g., Redis or Cassandra). This permits the load balancer to route requests to any available web server, facilitating autoscaling.
- **Database Scaling**: Database replicas are added to distribute read load (Master-Slave replication). Writes are routed to the Master database and asynchronously replicated to Slaves.
- **GeoDNS Routing**: Resolves domain names to IP addresses based on the user's geographical location, routing them to the closest data center.

#### B. Rate Limiting Algorithms
Protects APIs from starvation and malicious attacks:
- **Token Bucket**: Accumulates tokens up to a maximum capacity at a fixed rate. Each request consumes a token. Allows bursts of traffic.
- **Leaky Bucket**: Queues requests in a FIFO buffer, processing them at a constant rate. Smooths out traffic spikes.
- **Sliding Window Log**: Logs request timestamps in a sorted set (e.g., Redis). Removes timestamps older than the window limit. Highly precise but memory-intensive.

#### C. Caching & Edge CDNs
- **Read-Through Caching**: The application queries the cache first. If a cache miss occurs, it queries the database, updates the cache, and returns the data.
- **CDN Edge Servers**: Geographically dispersed servers that cache static assets (JS, CSS, images) with a Time-to-Live (TTL) configuration. Bypasses the origin server for static asset delivery.
- **Resiliency**: Prevents cascading failures using **Circuit Breakers** (stops routing requests to failing downstream services once error thresholds are breached) and **Exponential Backoff with Jitter** (prevents thundering herd problems during service retries).

---

### 6. DevOps, CI/CD, & Infrastructure as Code
Located in [Tools/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Tools), this module documents containerization, orchestration, and infrastructure deployment pipelines.

#### A. Docker Internals
- **Linux Namespaces**: Isolates processes into independent virtual spaces (`PID` isolates processes, `net` isolates network interfaces, `mnt` isolates mount points).
- **Control Groups (cgroups)**: Restricts and limits hardware resource consumption (limits CPU cores, memory allocation, and I/O rates per container).
- **Union Filesystem (UnionFS)**: Implements copy-on-write (CoW) layer commits. Immutable base layers are shared, while container runtimes write only to a thin top layer.

#### B. Kubernetes Orchestration Architecture
- **Control Plane**:
  - `kube-apiserver`: Exposes the K8s API.
  - `etcd`: Distributed key-value store holding the cluster's state (utilizes Raft consensus).
  - `kube-scheduler`: Schedules pods onto healthy worker nodes.
  - `kube-controller-manager`: Runs controller processes (e.g., Node Controller, Deployment Controller).
- **Worker Node Components**:
  - `kubelet`: Agent running on each node ensuring containers are running inside pods as defined.
  - `kube-proxy`: Directs TCP/UDP streams to service endpoints across nodes.
- **Service Types**:
  - **ClusterIP**: Exposes the service internally on a cluster-private IP.
  - **NodePort**: Exposes the service on each node's IP at a static port (30000-32767).
  - **LoadBalancer**: Provisions an external load balancer in supported cloud environments.
  - **Headless**: Returns matching Pod IP addresses directly via DNS query instead of routing through a virtual proxy IP (useful for stateful clustering).

#### C. Infrastructure as Code (IaC)
- **Terraform**: Declarative engine. Calculates resource dependency graphs at execution time. Employs state locking (via S3 and DynamoDB) to prevent concurrent executions from corrupting infrastructure configurations.
- **Ansible**: Imperative configuration tool executing tasks agentlessly over SSH. Built around idempotent playbooks, ensuring that applying a configuration repeatedly yields the same system state without redundant executions.

---

### 7. Data Structures & Algorithms (DSA)
Located in [DSA/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA), this module contains placement trackers, algorithm paradigms, and custom implementation notes in C++ and Python.

- **Tree Locking Algorithms**: The [Juspay code analysis.md](file:///c:/Users/navde/Desktop/ubiquitous-adventure/DSA/Bare%20Basics/Juspay%20code%20analysis.md) file contains implementations of M-ary trees featuring lock and unlock operations. Parents check descendant lock status before acquiring locks, propagating state updates to ensure thread safety.
- **Disjoint Set Union (DSU)**: Standard disjoint sets optimized using **Union by Rank** (keeps tree depth minimal) and **Path Compression** (updates parent pointers directly to the root during queries), yielding near-constant $O(\alpha(N))$ time complexity.
- **Custom STL priority_queue Comparators**: In C++, defines custom structures with overloaded call operators (`operator()`) to control heap ordering:
  ```cpp
  struct CustomComparator {
      bool operator()(const Pair& a, const Pair& b) {
          return a.value > b.value; // Min-Heap ordering
      }
  };
  std::priority_queue<Pair, std::vector<Pair>, CustomComparator> minHeap;
  ```

---

## 🛠️ Sandbox Projects

The repository hosts active sandboxed applications designed to apply backend and distributed systems theory:

### 1. Docker Cleanup Daemon
- **Directory**: [Projects/Docker Cleanup Daemon/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Docker%20Cleanup%20Daemon)
- **Purpose**: A Go-based systems daemon utilizing the Docker SDK to monitor local system disk usage. When storage consumption exceeds configurable thresholds, it triggers pruning operations to remove dangling images, unused volumes, and stopped containers.

### 2. Resume Collector
- **Directory**: [Projects/Resume Collector/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Resume%20Collector)
- **Purpose**: A fullstack application designed to parse and organize candidate resumes into structured databases using ETL extraction pipelines.

### 3. Data Warehousing in MySQL
- **Directory**: [Projects/Data Warehousing in MySQL/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/Data%20Warehousing%20in%20Mysql)
- **Purpose**: Implements star and snowflake schemas in MySQL, showcasing analytic query optimization, staging database architectures, and ETL scripting.

### 4. MdMaker
- **Directory**: [Projects/MdMaker/](file:///c:/Users/navde/Desktop/ubiquitous-adventure/Projects/) (described in `MdMaker documentation.md`)
- **Purpose**: A documentation utility that scans directories and automatically generates markdown summaries.

---

## 📖 How to Navigate & Use this Vault

This folder is designed to be viewed using a Markdown renderer (like **VS Code Markdown Preview** or **Obsidian**). 

### Key Tips:
* **Interlinked Notes**: Files use Wiki-style links (e.g., `[[1.1 Data Models]]`) or clickable file URI links. Click on any file path inside a note to jump directly to it.
* **Diagram Rendering**: Ensure your markdown viewer supports **Mermaid diagrams** to render the request flow graphs and sequence flows correctly.
* **Code Blocks**: Every code block is fully typed and annotated line-by-line in Java, C++, Go, SQL, or YAML, making it easy to copy-paste code to local compilers for quick test runs.
