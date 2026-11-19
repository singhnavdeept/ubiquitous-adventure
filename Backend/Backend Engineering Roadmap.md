# Backend Engineering Roadmap 

> A topic-wise itinerary from absolute basics to production-ready backend engineering, including Kafka. Projects are placed at natural skill checkpoints.

---

## Phase 0 — Foundations (Week 1–2)

### 0.1 How the Internet Works

- DNS resolution, IP addresses, ports
- HTTP/HTTPS — request/response cycle, status codes, headers
- TCP vs UDP — when and why
- Client-server model

### 0.2 Linux & Terminal Basics

- File system navigation (`ls`, `cd`, `cat`, `grep`, `find`)
- File permissions (`chmod`, `chown`)
- Process management (`ps`, `kill`, `top`)
- Shell scripting basics (variables, loops, conditionals)
- SSH, SCP

### 0.3 Git & Version Control

- `init`, `clone`, `add`, `commit`, `push`, `pull`
- Branching — `branch`, `checkout`, `merge`, `rebase`
- Resolving merge conflicts
- `.gitignore`, tagging, stashing
- GitHub — PRs, Issues, forks

---

## Phase 1 — Programming Language for Backend (Week 3–5)

> Pick **one**. If you're going Java route (from the video), learn Java here. If Python (your current stack), this phase is largely done.

### 1.1 Core Language (Java or Python)

- Data types, variables, operators
- Control flow — if/else, loops, switch
- Functions / methods
- OOP — classes, objects, inheritance, polymorphism, encapsulation, abstraction
- Exception handling
- File I/O
- Collections — List, Map, Set, Queue

### 1.2 Build Tools

- **Java path:** Maven or Gradle (dependency management, build lifecycle)
- **Python path:** pip, virtual environments, `pyproject.toml`

### 1.3 Testing Basics

- Unit testing concepts
- **Java:** JUnit + Mockito
- **Python:** pytest
- Writing testable code — why it matters

---

## Phase 2 — Data Structures & Algorithms (Week 4–8, parallel)

> Run this parallel to other phases. 1–2 problems daily.

### 2.1 Core Data Structures

- Arrays, Strings
- Linked Lists (singly, doubly)
- Stacks, Queues, Deques
- Hash Maps, Hash Sets
- Trees — Binary Tree, BST, Tries
- Heaps / Priority Queues
- Graphs — adjacency list/matrix

### 2.2 Core Algorithms

- Sorting — Merge Sort, Quick Sort, Heap Sort
- Binary Search and its variations
- Two Pointers, Sliding Window
- Recursion and Backtracking
- BFS, DFS
- Dynamic Programming — memoization, tabulation
- Greedy algorithms

### 2.3 Complexity Analysis

- Big O — time and space
- Best/average/worst case reasoning

> **Practice Platform:** LeetCode — Easy → Medium. Focus on patterns, not grinding.

---

## Phase 3 — Databases (Week 6–9)

### 3.1 Relational Databases (SQL)

- What is a relational database — tables, rows, columns, keys
- SQL basics — `SELECT`, `INSERT`, `UPDATE`, `DELETE`
- Joins — INNER, LEFT, RIGHT, FULL OUTER
- Aggregations — `GROUP BY`, `HAVING`, window functions
- Indexes — why they matter, B-tree, composite indexes
- Transactions — ACID properties
- Normalization — 1NF, 2NF, 3NF
- Stored procedures, views, triggers

**Tool:** PostgreSQL (recommended) or MySQL

### 3.2 Database Internals (Conceptual)

- How indexes work under the hood
- Query execution plans — `EXPLAIN ANALYZE`
- Write-Ahead Logging (WAL)
- MVCC — Multi-Version Concurrency Control
- Connection pooling

### 3.3 NoSQL Databases

- Why NoSQL — use cases vs SQL
- Document stores — MongoDB (CRUD, aggregation pipeline, indexes)
- Key-value stores — Redis
    - Caching patterns — cache-aside, write-through
    - Redis data types — Strings, Hashes, Lists, Sets, Sorted Sets
    - TTL, pub/sub, Lua scripting basics
- When to use which database

### 3.4 ORM Concepts

- What is an ORM and why it exists
- N+1 query problem and how to avoid it
- **Java path:** Hibernate / Spring Data JPA
- **Python path:** SQLAlchemy / Django ORM

---

## 🏗️ Project 1 — Library Management REST API (After Phase 3)

**What you build:** A REST API for managing books, authors, and members of a library.

**Covers:**

- Full CRUD for Books, Authors, Members
- SQL database with proper schema (foreign keys, indexes)
- Redis caching for frequent book lookups
- Pagination, filtering, sorting
- Input validation and error handling

**Stack:** Python (FastAPI/Django) + PostgreSQL + Redis, OR Java (Spring Boot) + PostgreSQL + Redis

**Deliverable:** GitHub repo with README, Postman collection, Docker Compose setup

---

## Phase 4 — REST API Design & Development (Week 9–12)

### 4.1 API Design Principles

- REST constraints — statelessness, uniform interface, layered system
- Resource naming conventions
- HTTP methods semantics — GET, POST, PUT, PATCH, DELETE
- Status codes — 2xx, 3xx, 4xx, 5xx and when to use each
- Versioning strategies — URI, header, query param
- Pagination — offset-based, cursor-based, keyset

### 4.2 Request/Response Handling

- JSON serialization/deserialization
- Input validation and sanitization
- Error response standards (RFC 7807 — Problem Details)
- File uploads, multipart forms
- Rate limiting concepts

### 4.3 API Documentation

- OpenAPI / Swagger specification
- Writing good API docs — auto-generation vs manual
- Postman collections

### 4.4 Authentication & Authorization

- Sessions vs tokens
- JWT — structure (header.payload.signature), signing, validation, expiry
- OAuth 2.0 — authorization code flow, client credentials, refresh tokens
- API keys
- RBAC — Role-Based Access Control
- Common security pitfalls — storing passwords (bcrypt), SQL injection, CSRF, XSS headers

### 4.5 Web Frameworks Deep Dive

- **Python path:** Django + DRF (you already know this — go deeper into DRF internals, custom serializers, throttling, permissions)
- **Java path:** Spring Boot, Spring MVC, Spring REST

---

## Phase 5 — Messaging & Event Streaming with Kafka (Week 12–15)

### 5.1 Why Messaging Systems Exist

- Synchronous vs asynchronous communication
- Problems with direct service-to-service calls
- Event-driven architecture — benefits and trade-offs

### 5.2 Kafka Fundamentals

- Core concepts — producers, consumers, brokers, topics, partitions, offsets
- Kafka vs traditional message queues (RabbitMQ, SQS)
- Topic partitioning — why it enables parallelism
- Consumer groups — load balancing and fault tolerance
- Replication — leader, followers, ISR (In-Sync Replicas)
- Retention policies — time-based, size-based

### 5.3 Kafka Producers

- Producer API basics
- Serializers — JSON, Avro, Protobuf
- Acknowledgment levels — `acks=0`, `acks=1`, `acks=all`
- Idempotent producers
- Batching, compression, linger.ms

### 5.4 Kafka Consumers

- Consumer API basics
- Manual vs auto offset commit — at-most-once, at-least-once, exactly-once semantics
- Consumer lag and monitoring
- Rebalancing — what triggers it, how to minimize impact

### 5.5 Kafka Streams & ksqlDB (Conceptual)

- Stream processing concepts — stateless vs stateful
- Kafka Streams API — map, filter, groupBy, aggregate
- ksqlDB for SQL-style stream queries
- When to use Kafka Streams vs a separate stream processor

### 5.6 Kafka Operations

- Setting up Kafka with Docker
- Kafka Connect — source and sink connectors
- Schema Registry with Avro
- Monitoring — consumer lag, throughput, partition skew
- Kafka in production — replication factor, partition count decisions

---

## 🏗️ Project 2 — Real-Time Order Processing System (After Phase 5)

**What you build:** An e-commerce order pipeline with async processing.

**Architecture:**

- Order Service → publishes `order.placed` events to Kafka
- Inventory Service → consumes events, checks/updates stock, publishes `inventory.confirmed` or `inventory.failed`
- Notification Service → consumes events, sends email/SMS simulation
- All services expose REST APIs

**Covers:**

- Producer + Consumer implementation
- Consumer groups for parallel processing
- Dead Letter Queue (DLQ) for failed messages
- Idempotency handling
- Docker Compose with Kafka, Zookeeper, Schema Registry

**Deliverable:** GitHub repo with architecture diagram (draw.io or Mermaid), README with setup instructions

---

## Phase 6 — System Design (Week 15–20)

### 6.1 Scalability Fundamentals

- Vertical vs horizontal scaling
- Load balancing — round-robin, least connections, consistent hashing
- Stateless vs stateful services — why stateless scales better
- CAP theorem — Consistency, Availability, Partition Tolerance
- BASE vs ACID

### 6.2 Caching

- Cache invalidation strategies — TTL, LRU, LFU
- Cache stampede and how to prevent it (mutex locking, probabilistic early expiry)
- CDN — what it caches, how it helps
- Distributed caching — Redis Cluster

### 6.3 Database Scaling

- Read replicas — how replication lag affects reads
- Sharding — horizontal partitioning, shard keys, hotspots
- Database partitioning — range, hash, list
- Connection pooling at scale — PgBouncer
- CQRS — Command Query Responsibility Segregation

### 6.4 Distributed Systems Concepts

- Consistency models — strong, eventual, causal
- Distributed transactions — 2PC, Saga pattern (choreography vs orchestration)
- Idempotency — why it matters in distributed systems
- Circuit breaker pattern
- Bulkhead pattern
- Backpressure handling

### 6.5 Designing Real Systems

Practice designing these end-to-end:

- URL Shortener
- Rate Limiter
- Notification System
- Chat Application
- Search Autocomplete
- Social Media Feed
- Ride-Sharing Backend
- Video Streaming Platform

**Framework for each:** Clarify → Estimate scale → High-level design → Deep dive components → Identify bottlenecks → Iterate

### 6.6 API Gateway & Service Mesh

- What an API gateway does — routing, auth, rate limiting, logging
- Service mesh concepts — sidecar proxy, service discovery, mTLS

---

## Phase 7 — Microservices (Week 18–22)

### 7.1 Microservices vs Monolith

- When microservices make sense (and when they don't)
- Domain-Driven Design basics — bounded contexts, aggregates, ubiquitous language
- Service decomposition strategies

### 7.2 Inter-Service Communication

- Synchronous — REST, gRPC
- Asynchronous — Kafka, message queues
- API gateway pattern
- Service discovery — DNS-based, client-side (Eureka), server-side

### 7.3 Microservices Patterns

- Saga pattern for distributed transactions
- Outbox pattern — reliably publishing events from a database write
- CQRS in microservices
- Strangler Fig — migrating monolith to microservices incrementally
- Shared database anti-pattern — why each service should own its data

### 7.4 Observability

- The three pillars — Logs, Metrics, Traces
- Structured logging — JSON logs, log levels, correlation IDs
- Metrics — counters, gauges, histograms (Prometheus + Grafana)
- Distributed tracing — OpenTelemetry, Jaeger
- Health checks — liveness vs readiness probes

---

## Phase 8 — Containerization & DevOps (Week 20–24)

### 8.1 Docker

- Images vs containers — layered filesystem
- Writing Dockerfiles — multi-stage builds, minimizing image size
- Docker Compose for local dev
- Networking — bridge, host, overlay
- Volumes — data persistence
- Docker best practices — non-root user, .dockerignore, pinning base image versions

### 8.2 CI/CD

- What CI/CD solves
- GitHub Actions — writing workflows (test → build → deploy)
- Jenkins (if Java path) — Jenkinsfile, pipelines
- Pipeline stages — lint, test, build image, push to registry, deploy

### 8.3 Cloud Basics (Pick one: AWS / Azure / GCP)

- Core services — compute (EC2/VM), storage (S3/Blob), database (RDS/Cloud SQL)
- IAM — users, roles, policies, least privilege
- VPC — subnets, security groups, NAT gateway
- Managed Kafka — MSK (AWS) or Event Hubs (Azure)
- Deploying a containerized service

### 8.4 Infrastructure as Code (Conceptual)

- Terraform basics — providers, resources, state, modules
- Why IaC matters — reproducibility, version control, drift detection

### 8.5 Logging & Monitoring in Production

- Centralized logging — ELK Stack (Elasticsearch, Logstash, Kibana) or CloudWatch
- Alerting — when to alert, avoiding alert fatigue
- Dashboards — key metrics to track for a backend service (latency, error rate, throughput, saturation)

---

## 🏗️ Project 3 — Microservices E-Commerce Platform (After Phase 8)

**What you build:** A production-grade (simplified) e-commerce backend.

**Services:**

- User Service — registration, login, JWT issuance
- Product Service — catalog, inventory
- Order Service — place orders, saga-based transaction
- Notification Service — Kafka consumer, email simulation
- API Gateway — routing, auth middleware

**Infrastructure:**

- Docker Compose / Kubernetes (basic)
- Kafka for async communication (Order → Notification, Order → Inventory)
- PostgreSQL per service (separate schemas or DBs)
- Redis for session/cache
- Prometheus + Grafana for metrics
- GitHub Actions CI pipeline

**Deliverable:** GitHub repo with architecture diagram, API docs (Swagger), README with how to run locally, a brief writeup explaining design decisions (this becomes your LinkedIn content)

---

## Phase 9 — Interview Preparation (Ongoing from Week 16)

### 9.1 Coding Interviews

- LeetCode Medium — focus on Arrays, Strings, Trees, Graphs, DP
- Sliding window, two pointers, binary search patterns
- Time yourself — 20–25 min per problem
- Mock interviews — Pramp, interviewing.io

### 9.2 System Design Interviews

- Practice with a timer — 45 min per system
- Use the framework: Clarify → Estimate → Design → Dive deep → Trade-offs
- Study real-world architectures — Uber, Netflix, WhatsApp engineering blogs

### 9.3 Behavioral Interviews

- STAR format — Situation, Task, Action, Result
- Prepare stories for: a project you're proud of, a conflict you resolved, a failure you learned from, a time you handled ambiguity
- Know your resume projects deeply — every design decision, every trade-off

---

## Content Creation Strategy (YouTube + LinkedIn)

### What to Post

- **YouTube:** "Building X from scratch" style videos. Show real code, real mistakes, real debugging. Don't make polished tutorials — make engineering journals.
- **LinkedIn:** Written posts — "Today I learned why Kafka consumer groups matter for horizontal scaling" with a simple diagram. 3–4 sentences + image beats long essays.

### Posting Cadence

- LinkedIn — 2–3x per week (learning reflections, project updates, concepts explained simply)
- YouTube — 1 video per project milestone (not per topic)

### Content Ideas by Phase

- Phase 3 complete → "I built my first REST API and here's what I got wrong about database indexes"
- Project 1 complete → "Library API walkthrough — how I implemented Redis caching"
- Phase 5 complete → "Kafka in 10 minutes — explained with an order processing example"
- Project 2 complete → "I built a real-time order pipeline with Kafka — here's the architecture"
- Project 3 complete → "Building a microservices platform solo — what I'd do differently"

### Golden Rule

Post about what you **just figured out**, not what you've known forever. Authenticity beats polish every time.

---

## Timeline Summary

|Phase|Topic|Duration|
|---|---|---|
|0|Foundations (Internet, Linux, Git)|Week 1–2|
|1|Language + Build Tools + Testing|Week 3–5|
|2|DSA (parallel, ongoing)|Week 4–8+|
|3|Databases (SQL, NoSQL, Redis, ORM)|Week 6–9|
|🏗️|Project 1 — Library API|End of Week 9|
|4|REST API Design + Auth + Frameworks|Week 9–12|
|5|Kafka — Fundamentals to Operations|Week 12–15|
|🏗️|Project 2 — Order Processing System|End of Week 15|
|6|System Design|Week 15–20|
|7|Microservices Patterns + Observability|Week 18–22|
|8|Docker + CI/CD + Cloud + IaC|Week 20–24|
|🏗️|Project 3 — E-Commerce Microservices|End of Week 24|
|9|Interview Prep (parallel from Week 16)|Ongoing|

---

> **Remember:** You don't need to finish everything before applying. After Project 2 (Week 15), your profile is strong enough to start sending applications. Keep building while interviewing.