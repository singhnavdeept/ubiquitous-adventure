# 🚀 Ubiquitous Adventure: The Incremental Learning Vault

Welcome to **Ubiquitous Adventure**! This repository is a structured personal knowledge base and engineering workspace built in **Obsidian**. It reflects a philosophy of **incremental learning**—compounding daily deep dives in systems, backend architecture, algorithms, AI, and DevOps into durable expertise.

> *"The secret of getting ahead is getting started. The secret of getting started is breaking your complex overwhelming tasks into small manageable tasks, and starting on the first one."*

---

## 🎯 Core Principles

1. **First-Principles Depth**: We don't just memorize syntax or high-level APIs; we dive into internals (CPU cache mechanics, disk layouts, memory allocators, network runtimes, and distributed consensus).
2. **Theory Paired with Code**: Theoretical notes directly anchor practical implementations (e.g., Go concurrency primitives connected to distributed ticket booking with Redis).
3. **Connected & Navigable**: Every topic belongs to an intuitive domain bucket (max 2 levels deep) with clean wikilinks, visual diagrams, and Obsidian graph synergy.

---

## 🗂️ Knowledge Map & Domain Structure

```
ubiquitous-adventure/
├── 🤖 AI & ML/                 ← RAG architecture, LLM internals, MLOps & system designs
├── ⚙️ Backend/                 ← HTTP/HTTPS, Spring Boot, JPA, OS networking & REST API standards
├── 📊 Big Data/                ← Hadoop, Hive, HBase, Spark, Kafka & Data Engineering roadmap
├── 🗄️ Databases/               ← Relational internals, SQL optimization, NoSQL & Vector stores
├── 💻 DSA/                     ← Data structures, algorithm patterns, competitive programming
├── 🐹 Golang/                  ← 10-phase backend roadmap, concurrency, memory layout & binaries
├── ☁️  Cloud and DevOps/ ← AWS cloud infrastructure, Terraform IaC, CI/CD & DevSecOps
├── 📐 Low Level Design/        ← Design patterns and object-oriented architecture
├── 🚀 Projects/                ← Hands-on production systems, learning guides & vivas
├── 🏗️ System Design/           ← High-level architectures, scaling heuristics & deep dives
├── 🛠️ Tools/                   ← Production infrastructure (Docker, Kubernetes, Jenkins)
├── 📅 Daily Notes/             ← Daily study logs & incremental tracking
├── 🎨 Excalidraw/ & Assets/    ← Interactive visual diagrams, system blueprints & media
└── 📝 Templates/               ← Standardized templates for problems & daily tracking
```

---

### Detailed Domain Breakdown

#### 🤖 1. [AI & ML](./AI%20%26%20ML/)
Modern Retrieval-Augmented Generation (RAG), vector search systems, and LLM foundations:
* **[Topics](./AI%20%26%20ML/Topics/)**: Sequenced deep-dive curriculum:
  * `01 Fundamentals of RAG` — Core architectures, naive vs. advanced retrieval.
  * `02 Chunking Strategies` — Semantic, sentence-window, and hierarchical splitting.
  * `03 Reranking system` — Cross-encoders and reciprocal rank fusion.
  * `04 LLM Internals - Transformer and KV Cache` — Multi-head attention & KV cache optimization.
  * `05 RAG vs Fine-Tuning and Quantization` — Trade-offs, LoRA/QLoRA, and quantization.
  * `06 Agentic Systems - ReAct, Tools, and Memory` — ReAct loops, planning, and tool calling.
  * `07 Vector Databases - Internals and Tradeoffs` — HNSW, IVF, vector indexing.
  * `08 MLOps - Serving, RAGAS Evaluation, and Monitoring` — RAGAS metrics & model serving.
* **[ML Interviews](./AI%20%26%20ML/ML%20Interviews/)**:
  * `Build a visual Search System.md` — Large-scale Pinterest-style visual search (SimCLR/MoCo, ANN).
  * `PDF RAG System Design.md` — Reasoned stack for a 2 GB PDF RAG system (PyMuPDF, BGE-M3, Qdrant, Qwen3 on RTX 3090).
* **[Llamaindex](./AI%20%26%20ML/Llamaindex/)** & **Framework Comparisons**: Hands-on guides and architecture diagrams.

---

#### ⚙️ 2. [Backend](./Backend/)
Protocols, frameworks, and low-level communication:
* **Core Theory**: `HTTP and HTTPS.md`, `Kernel Networking Basics.md`, `Compiler Internals.md`, `Compile Time Output.md`, `Networking in Hurry.md`.
* **Java & Spring Ecosystem**: `Spring Boot REST API Flow and Implementation.md`, `Spring Data JPA CRUD Internals.md`.
* **[REST API](./Backend/REST%20API/)**: Protocol design, `REST API Request.md`, `REST API Status Codes.md`, and `Postman.md`.
* **Roadmap**: `Backend Engineering Roadmap.md`.

---

#### 🗄️ 3. [Databases](./Databases/)
Relational theory, query execution engines, distributed consistency, and NoSQL storage:
* **[Fundamentals](./Databases/Fundamentals/)**:
  * Data Models, Schema Design & Normalization, Data Types, Constraints.
  * Indexing deep dives (`Indexes.md`, `Indexes at Scale.md`).
  * Storage mechanics: `Storage Engines.md`, `Page and Block Storage.md`.
  * Distributed guarantees: `CAP Theorem.md`, `Distributed Consensus.md`, `Database Locks & Concurrency.md`, `MVCC.md`, `Transaction Isolation & Anomalies.md`, `Why Clusters Are Needed.md`.
* **[SQL](./Databases/SQL/)**: `SQL Fundamentals.md`, `Window Functions.md`, `CTEs.md`, `Aggregation.md`, `Full-text Search.md`, `Query Optimization & Execution Plans.md`, and `Partition BY vs Group BY.md`.
* **[NoSQL](./Databases/NoSQL/)**: `Cassandra.md`, `Partition and Clustering Key.md`, `Vector Databases & pgvector.md`.
* **Exam & Review Guides**: `GATE DBMS Guide.md`, `Topics To Cover.md`.

---

#### 📊 4. [Big Data](./Big%20Data/)
Distributed data processing, warehousing, and real-time streaming:
* **Core Curriculum**: Chapters on HDFS, MapReduce/YARN, Hive, HBase, Cassandra, and clustering.
* **[Labs](./Big%20Data/Labs/)**: Practical commands and Java ETLs (`Hadoop Commands.md`, `Hive Commands.md`, `HBase and Hive Commands.md`, `Big Data Using Java.md`).
* **Roadmap**: `Data Engineering Roadmap.md`.

---

#### 💻 5. [DSA (Data Structures & Algorithms)](./DSA/)
Problem-solving strategies, patterns, and competitive programming:
* **[Guides](./DSA/Guides/)**: `DSA Java Guide.md`, `Python DSA Guide.md`, `DSA Pattern Questions.md`, `How to Approach DSA.md`.
* **[Questions](./DSA/Questions/)**: Core interview questions on Binary Trees, Graphs, Heaps, Linked Lists, LFU Cache, M-ary Tree locks, and Juspay analysis.
* **[Competitive](./DSA/Competitive/)**: `Codeforces Master Sheet.md`, `CPP Templates.md`, `Practice Questions Tracker.md`, plus clean source solutions in `Solutions/`.

---

#### 🐹 6. [Golang](./Golang/)
End-to-end Go backend engineering:
* **[Phases](./Golang/Phases/)**: Structured 10-phase path:
  1. *Fundamentals*, 2. *Concurrency & Scheduler*, 3. *HTTP & REST APIs*, 4. *Databases & Connection Pools*, 5. *Authentication & JWT*, 6. *Testing & Benchmarking*, 7. *gRPC & Protobuf*, 8. *Microservice Patterns*, 9. *Deployment & DevOps*, 10. *Advanced Go Performance & Memory Allocations*.
* **Deep Dives**: `Structs.md` (memory alignment, padding, reflection), `Execution and Binaries.md`, and `Roadmap.md`.

---

#### 🏗️ 7. [System Design](./System%20Design/) & [Low Level Design](./Low%20Level%20Design/)
Architectural principles for high-throughput, fault-tolerant distributed systems:
* **Foundations**: `Scaling to Millions.md`, `Back of the envelope.md`, `Rate limiter.md`, `Cascading Failures.md`, `consistent hashing.md`.
* **[Deep Dives](./System%20Design/Deep%20Dives/)**: Detailed production case studies:
  * `Dropbox.md` — Block storage, sync protocol, and metadata architecture.
  * `Uber.md` — Geohashing, dispatch system, and real-time location streaming.
  * `Stripe Monolith.md` — Idempotency engines, payment state machines, and safe deployments.
  * `Redis.md` — Single-threaded event loops, RESP protocol, replication, and persistence (RDB/AOF).
  * `High Concurrency Booking.md` — Distributed locking and hot-row race condition mitigations.
* **Low Level Design**: `Design Patterns.md` (Creational, Structural, Behavioral patterns).

---

#### ☁️ 8. [INT378 Cloud and DevOps](./INT378%20Cloud%20and%20DevOps/)
Complete academic and professional cloud engineering curriculum:
* **Theory Units**: Cloud Infrastructure (Unit 1), IaC (Unit 2), CI/CD (Unit 3), Observability (Unit 4), DevSecOps & Security (Unit 5), Serverless & FinOps (Unit 6).
* **Labs & Code**: 11 end-to-end practical labs with Terraform configs, CloudFormation templates, Dockerfiles, and Jenkins pipelines.
* **DevOps Rabbit Holes**: Container runtime syscalls, packet lifecycle, Kubernetes pod networking, and distributed failure modes.

---

#### 🛠️ 9. [Tools](./Tools/)
Production deployment and containerization toolchains:
* **[Docker](./Tools/Docker/)**: Storyboards, lifecycle, commands, and layer caching.
* **[Kubernetes](./Tools/Kubernetes/)**: Architecture, control plane components, pods, services, and workloads.
* **[Jenkins](./Tools/Jenkins/)**: CI/CD pipelines, Nginx deployment automation, and webhook setups.

---

#### 🚀 10. [Projects](./Projects/)
Where theory is proven in working code:
1. **Concurrent Seat Booking**: High-concurrency ticket reservation engine solving race conditions with distributed Redis locks.
2. **HN-HIT Predictor**: End-to-end ML scoring engine with automated CI/CD and Dockerized deployment.
3. **Docker Cleanup Daemon**: Custom Go background daemon monitoring container disk pressure and cleaning stale images.
4. **Data Warehousing in MySQL**: Star/Snowflake schema data pipeline and analytics layer.
5. **MdMaker**: Automated Markdown-to-HTML database publishing platform backed by Jenkins and Docker.
6. **Resume Collector**: Multi-candidate ingestion pipeline and schemas.

---

## 📈 Learning Workflow

1. **Ingest & Summarize**: Capture new insights into topic-specific files.
2. **Synthesize & Cross-Link**: Link related concepts using Obsidian wikilinks (e.g. connecting MVCC in database theory with isolation anomaly examples).
3. **Build & Benchmark**: Validate the architecture through projects in `/Projects`.
4. **Refine**: Continuously prune dead ends and standardize notes for rapid interview review and real-world system design.

---

*Stay consistent. The compound interest of knowledge is the most powerful force in software engineering.*
