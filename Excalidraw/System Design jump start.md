---

excalidraw-plugin: parsed
tags: [excalidraw]

---
==⚠  Switch to EXCALIDRAW VIEW in the MORE OPTIONS menu of this document. ⚠== You can decompress Drawing data with the command palette: 'Decompress current Excalidraw file'. For more info check in plugin settings under 'Saving'


# Excalidraw Data

## Text Elements
Below is a **flow‑based System Design roadmap** built specifically for a wide Excalidraw canvas. It moves from the smallest possible system (1 user) outward to global, distributed scale, then folds back into **how you actually answer an interview question**. Every block includes **why it exists, how it works, when to use it, and where the deep‑dive hooks are** so you can manually expand the “in‑depth” parts yourself.

---

## The Natural Flow (draw this as the main spine)

```
1 User → 10 Users → 1K Users → 100K Users → 1M+ Users → Global & Resilient → Interview Execution
```

Each arrow is a **breakpoint**: a new problem appears, and the next set of building blocks exists to solve it. That is the “engineering mindset” thread—every component answers a visible pain point, not a buzzword.

---

## Phase 1: The Single‑User Baseline (Everything starts here)

**Mental model:** `[Browser] → [Server] → [Database]`. Every system you design is a variation of this. Do **not** start at “1M users”—start at 1 user and watch where it breaks.

| Topic | What to learn (why / how / when) | Interview orientation & deep‑dive hook |
|---|---|---|
| **Request–response cycle & DNS** | Why DNS exists (names → IPs), how a request travels: DNS → TCP/TLS → HTTP → server → DB. **When** it matters: every design starts with “how does the client reach you?” | Interviewers expect you to trace a request end‑to‑end. Deep dive: DNS caching layers, TTL, GeoDNS. |
| **Client–server architecture** | Separation of concerns, stateless vs stateful servers. **Why:** stateless servers enable horizontal scaling later. | “Why stateless?” is a common early filter. |
| **HTTP/HTTPS, TCP/IP, UDP** | HTTP semantics (methods, status codes), TCP reliability vs UDP speed. **When** to choose UDP (streaming, gaming) vs TCP (APIs). | Deep dive: HTTP/1.1 vs HTTP/2 vs HTTP/3 (QUIC), connection pooling. |
| **Latency vs throughput** | Latency = time per request; throughput = requests per unit time. **Why:** you optimize for different things; a low‑latency system can have low throughput and vice versa. | Interview prompt: “Is this system latency‑sensitive or throughput‑sensitive?” |
| **Vertical vs horizontal scaling** | Vertical = bigger machine; horizontal = more machines. **When:** vertical is simpler but has a ceiling; horizontal is harder but elastic. | Deep dive: why horizontal scaling forces you to solve **shared state** and **concurrency**. |

**Breakpoint 1 → 10:** shared state, concurrent writes, slow queries, basic contention appear. The next phase exists because of these problems.

---

## Phase 2: Scaling to Thousands (Traffic becomes visible)

**Mental model shift:** `[Users] → [Load Balancer] → [App 1 / App 2] → [Database]`. Your job is no longer “build features”—it is **decide what breaks first**.

### 2.1 Traffic Distribution

| Topic | Why it exists | How it works | When to use / Trade‑off | Deep‑dive hooks |
|---|---|---|---|---|
| **Load Balancer (L4 vs L7)** | A single server cannot absorb traffic or tolerate failure. | L4 routes by IP/port; L7 routes by HTTP content (path, headers, cookies). Algorithms: round‑robin, least connections, IP hash. | L7 for API‑aware routing; L4 for raw throughput. Trade‑off: L7 is more CPU‑expensive but enables smarter routing. | Health checks, sticky sessions, global server load balancing (GSLB). |
| **API Gateway** | Clients should not talk to dozens of microservices directly; you need a single entry point for auth, rate limiting, and routing. | Reverse proxy that sits in front of services. | **When:** microservices or multiple client types (web, mobile, third‑party). | Rate limiting algorithms (token bucket, leaky bucket), auth offloading, request aggregation. |
| **Reverse Proxy (Nginx / HAProxy)** | TLS termination, caching, compression, and hiding internal topology. | Sits between client and origin servers. | Often paired with load balancers; reverse proxy ≠ load balancer (though overlap exists). | Forward proxy vs reverse proxy—a classic interview differentiator. |
| **CDN** | Users are geographically far from origin; static assets should not hit your servers. | Edge PoPs cache content close to users; origin pull on miss. | **When:** static assets, video, global audiences. Trade‑off: cache invalidation and cost. | Push vs pull CDN, TTL strategy, dynamic content acceleration. |

### 2.2 Caching (The First Real Multiplier)

**Why:** databases are slow and expensive; most reads repeat. Caching turns repeated reads into memory hits. **When:** read‑heavy systems, expensive computations, session data.

| Pattern | How it works | When to use | Trade‑off / deep‑dive |
|---|---|---|---|
| **Cache‑aside (lazy loading)** | App checks cache → miss → reads DB → writes cache. | General‑purpose default. | Stale data risk; deep dive: TTL + write‑through invalidation. |
| **Read‑through** | Cache itself loads from DB on miss. | Simplify app logic. | Cache library coupling. |
| **Write‑through** | Write to cache and DB synchronously. | Strong consistency needs. | Higher write latency. |
| **Write‑behind (write‑back)** | Write to cache, async flush to DB. | Write‑heavy, tolerate some loss. | Durability risk—deep dive: what happens on cache crash? |
| **Eviction policies** | LRU, LFU, FIFO, TTL. | Every cache. | Deep dive: why LRU is common, when LFU fails. |

**Interview orientation:** caching is almost always a deep‑dive target. Be ready to explain **cache stampede / thundering herd**, **hot keys**, and **cache penetration (Bloom filters)**.

### 2.3 Databases: The First Storage Decision

**Why:** not all data is the same shape or access pattern. The database choice is an **access‑pattern decision**, not a religion.

| Topic | Why / How / When | Deep‑dive hook |
|---|---|---|
| **SQL vs NoSQL** | SQL: structured, joins, ACID, strong consistency. NoSQL: flexible schema, horizontal scale, eventual consistency. **When:** access patterns drive choice—not “SQL is old”. | Deep dive: pick a specific workload and justify the choice with read/write ratio and consistency needs. |
| **Key‑value, document, wide‑column, graph** | Each NoSQL family optimizes a different access pattern. | Deep dive: why a graph DB for social networks, why wide‑column for time‑series. |
| **Indexing** | Without indexes, reads scan everything. Indexes trade write speed and storage for read speed. | Deep dive: B‑tree vs LSM‑tree—this is a **high‑value advanced topic**. |
| **Replication (leader–follower)** | Copies data for read scaling and fault tolerance. Leader handles writes, followers serve reads. | Deep dive: replication lag, read‑your‑writes, failover. |
| **Sharding / partitioning** | A single database cannot store or write infinite data. Sharding splits data across nodes. | Deep dive: shard key choice, hotspots, resharding, consistent hashing. |

**CAP theorem** belongs here as the **trade‑off lens**: under a network partition, you choose consistency or availability. **PACELC** extends it: even without a partition, you trade latency vs consistency. This is not a definition to memorize—it is a decision tool.

**Breakpoint 100K → 1M:** a single database cannot absorb write volume or storage; you need replication, sharding, and async flows.

---

## Phase 3: Synchronous → Asynchronous (Resilience under spikes)

**Why this phase exists:** synchronous chains break under traffic spikes. One slow downstream service cascades into a full outage. Async flows decouple components.

**Mental model:** `[Client] → [API] → [Queue] → [Worker] → [DB]`. This pattern appears everywhere: payments, emails, notifications, AI workflows.

| Topic | Why / How / When | Interview deep‑dive |
|---|---|---|
| **Message queues (RabbitMQ, SQS)** | Buffer work, smooth spikes, retry failures. | Delivery guarantees (at‑most‑once, at‑least‑once, exactly‑once), DLQ, idempotency. |
| **Event streaming (Kafka)** | Durable, ordered log for high‑throughput event pipelines. | Kafka internals: partitions, consumer groups, offset management, log retention. |
| **Pub/Sub & fan‑out** | One event triggers many independent consumers. | Fan‑out patterns, backpressure, poison messages. |
| **CQRS** | Separate read model from write model; optimize each independently. | **When:** read/write ratios are extreme or read models need different shapes. Trade‑off: eventual consistency between models. |
| **Event sourcing** | Store events, not just current state. | Replay, auditability, snapshots. Deep dive: when event sourcing is overkill. |
| **Background jobs / workers** | Offload long‑running tasks from the request path. | Worker scaling, task deduplication, visibility timeouts. |

**Engineering mindset point:** async is not “better”—it is a **trade of complexity for resilience**. You must now handle **idempotency**, **ordering**, and **duplicate delivery**.

---

## Phase 4: Distributed Systems Core (The “Why Hard” Layer)

**Why this phase exists:** once you have multiple machines, the network becomes unreliable, clocks disagree, and failures are partial. This is where senior‑level depth is tested.

### 4.1 The Hard Truths (must internalize)

- **Fallacies of distributed computing:** the network is not reliable, latency is not zero, bandwidth is not infinite, topology changes, transport costs are not zero.
- **Partial failure:** a node can be slow but not down; you cannot observe global state atomically.
- **Time is not global:** you cannot use wall‑clock time to order events across nodes.

### 4.2 Core Distributed Concepts

| Topic | Why / How / When | Interview orientation |
|---|---|---|
| **Consistency models** | Strong, eventual, causal—each is a contract about what a read can return. **When:** strong consistency for money/orders; eventual for feeds, likes, presence. | Be able to say *why* you chose one for a specific feature. |
| **Consensus (Raft / Paxos)** | Multiple nodes must agree on one truth (leader election, config, replicated log). Raft is designed for a log of entries; Paxos for single decisions. | Deep dive: why consensus is needed, what happens during a split brain. |
| **Leader election** | One node coordinates writes; others follow. | ZooKeeper/etcd patterns, fencing tokens. |
| **Quorum reads/writes** | R + W > N gives strong consistency in a replicated system. | Trade‑off: quorum latency vs consistency. |
| **Distributed locks** | Mutual exclusion across machines. | Deep dive: lock leases, Redis RedLock, fencing. |
| **Distributed transactions (2PC / Saga / Outbox)** | Multiple services must update data atomically. 2PC is blocking; Saga compensates; Outbox avoids dual writes. | Classic senior interview question: “How do you avoid a dual‑write problem?” |
| **Consistent hashing** | Adding/removing nodes should not reshuffle all keys. | Deep dive: virtual nodes, hotspot mitigation. |

**This phase is the highest‑value deep‑dive territory.** You do not need to implement Raft, but you must explain **what problem it solves and what it costs**.

---

## Phase 5: Architecture Patterns (How components compose)

| Pattern | Why / When | Trade‑off / interview note |
|---|---|---|
| **Monolith** | Simple, fast to build, easy to reason about. | **When:** early‑stage, small team. Do not dismiss it—interviewers respect “start monolith, split later.” |
| **Microservices** | Independent scaling, deployment, and team ownership. | Cost: network calls, distributed transactions, observability complexity. Deep dive: service boundaries (DDD). |
| **Serverless** | No server management, event‑driven scaling. | Cold starts, vendor lock‑in, execution limits. |
| **Event‑driven architecture** | Decouple producers from consumers. | Combines with queues/streams; deep dive: at‑least‑once + idempotency. |
| **API design (REST / gRPC / GraphQL)** | REST: simple, cacheable. gRPC: high‑performance, typed contracts. GraphQL: client‑specified data. | Interview framework expects **3–5 endpoints before architecture**. Deep dive: when gRPC beats REST, GraphQL N+1 problem. |

---

## Phase 6: Production & Operational Reality (Ownership mindset)

**Why this phase exists:** architecture affects cloud bills, on‑call stress, and uptime. Senior engineers think in **cost, failure, and observability**.

| Topic | What to learn | Interview angle |
|---|---|---|
| **Observability** | Metrics, logs, traces (the three pillars). | “How would you know this system is broken?” |
| **SLO / SLA / SLI** | Service level objectives vs agreements vs indicators. | Deep dive: error budgets. |
| **Rate limiting & throttling** | Protect downstream services. | Algorithms: token bucket, leaky bucket, sliding window. |
| **Circuit breakers & retries** | Stop cascading failures. | Deep dive: retry storms, jitter, idempotency. |
| **Multi‑region / disaster recovery** | Survive regional failures. | RPO/RTO trade‑offs. |
| **Security basics** | TLS, authN vs authZ, OWASP basics. | Often a quick filter, not a deep dive. |
| **Cost awareness** | Data transfer, managed services, storage tiers. | “Why not just use the biggest instance?” |

---

## Phase 7: The Interview Execution Layer (How you actually answer)

This is **not a separate technical topic**—it is the **operating system** for everything above.

### The 6‑Step / RESHADED Framework (use one consistently)

| Step | What you do | Why interviewers care |
|---|---|---|
| **1. Requirements (5 min)** | Clarify functional + non‑functional: scale, read/write ratio, latency SLA, consistency need, availability target. | Failed interviews often fail in the first 5 minutes by jumping to solutions. |
| **2. Estimation (3–5 min)** | QPS, peak QPS (2–3× average), storage, bandwidth. Use round numbers (86,400 sec/day ≈ 100K). | Demonstrates engineering maturity—numbers drive design. |
| **3. API design (5 min)** | Define 3–5 endpoints for core use cases **before** drawing architecture. | Forces clarity on what the system actually does. |
| **4. High‑level design (10 min)** | Draw clients, LB, app servers, DB, cache, queue—only as needed. Show request flow. | Tests decomposition and breadth. |
| **5. Deep dive (15 min)** | Go deep on 1–2 components the interviewer cares about (database, cache, queue, consistency). | This is where seniority is tested—depth over breadth. |
| **6. Evaluation & trade‑offs** | Identify bottlenecks, SPOFs, and what you would improve next. | Shows ownership and self‑awareness. |

**Critical interview truth:** there is no “right” architecture. Interviewers test **problem decomposition, technical breadth, technical depth, and communication**. Memorized diagrams do not work—**internalized frameworks and trade‑off reasoning do**.

---

## How to Use This on Excalidraw (canvas layout suggestion)

```
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 1: 1 USER → 10 USERS                                         │
│  [DNS] → [Client–Server] → [HTTP/TCP] → [Latency/Throughput]       │
│  Breakpoint: shared state, concurrent writes                        │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 2: 10 → 1K USERS                                             │
│  [Load Balancer] → [API Gateway] → [Cache] → [SQL vs NoSQL]        │
│  [Replication] → [Sharding] → [CAP/PACELC]                         │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 3: SYNC → ASYNC                                              │
│  [Queue] → [Kafka] → [CQRS] → [Event Sourcing] → [Workers]          │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 4: DISTRIBUTED CORE                                          │
│  [Fallacies] → [Consistency Models] → [Raft/Paxos] → [Quorums]     │
│  [Distributed Locks] → [2PC/Saga/Outbox] → [Consistent Hashing]     │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 5: ARCHITECTURE PATTERNS                                     │
│  [Monolith] → [Microservices] → [Serverless] → [Event‑Driven]      │
│  [REST/gRPC/GraphQL]                                                │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 6: PRODUCTION REALITY                                        │
│  [Observability] → [SLO/SLA] → [Rate Limiting] → [Circuit Breakers] │
│  [Multi‑Region] → [Security] → [Cost]                               │
└──────────────────────────────┬──────────────────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PHASE 7: INTERVIEW EXECUTION                                       │
│  Requirements → Estimation → API → HLD → Deep Dive → Trade‑offs    │
└─────────────────────────────────────────────────────────────────────┘
```

**Rules for deep‑diving manually:**
1. Pick **one box** per session.
2. Ask **“What breaks if I remove this?”** — that reveals the *why*.
3. Write the **trade‑off** on the canvas next to the box (e.g., “Cache: stale reads vs latency”).
4. Connect it **backward and forward**—what problem forced its existence, what new problem it creates.

---

## The 10 Deep‑Dive Topics That Come Up Most in Interviews

If you only go deep on a few things manually, choose these:

1. **Database sharding + consistent hashing** (hot keys, resharding).
2. **Caching patterns + invalidation + stampede**.
3. **CAP / PACELC applied to a specific feature** (not defined abstractly).
4. **Replication lag + read‑your‑writes**.
5. **Message queue delivery guarantees + idempotency**.
6. **Kafka partitions + consumer groups**.
7. **Raft / leader election** (conceptual, not implementation).
8. **Distributed transactions: Saga vs 2PC vs Outbox**.
9. **Rate limiting algorithms**.
10. **API design: REST vs gRPC vs GraphQL for a specific workload**.

---

This roadmap is designed so the **flow itself teaches the engineering mindset**: every phase exists because the previous phase created a problem that could no longer be ignored. When you draw it wide on Excalidraw, leave blank space next to each block—that is where your manual deep‑dives and trade‑off notes go. ^5ZzrhOvz

1. POSE the problem      → "10,000 users hit your server. What happens?" ^ZaMuITX8

2. LET them fail         → collect bad answers on the board ^TJFhT8XK

3. SHOW the symptom      → timeout, cascade, data loss, stale read ^q9fVHWvh

4. OFFER the solution    → one technology, one sentence why ^MuRURpXo

5. ASK "what did we just break?" → the next problem is born ^ooTy12oL

%%
## Drawing
```compressed-json
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
```
%%