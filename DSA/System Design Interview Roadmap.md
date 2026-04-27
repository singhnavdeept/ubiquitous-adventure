


> A complete guide to mastering system design questions — from fundamentals to advanced patterns, with a structured LeetCode-style progression.

---


## How to Approach Every Design Question

Before diving into topics, internalize this universal framework. Use it on every question:

```
1. Clarify Requirements (5 min)
   - Functional: What does the system do?
   - Non-functional: Scale, latency, availability, consistency?
   - Constraints: Read-heavy or write-heavy? DAU? QPS?

2. Estimate Scale (3 min)
   - Daily Active Users → QPS
   - Storage per day/year
   - Bandwidth (read + write)

3. High-Level Design (10 min)
   - Draw the core components: Client → API → Service → DB
   - Identify bottlenecks early

4. Deep Dive (15 min)
   - Pick 2-3 components to go deep on
   - Talk about tradeoffs, not just solutions

5. Wrap Up (5 min)
   - Failure modes, monitoring, future scaling
```

---

## Phase 1 — Data Structures You Must Design (Start Here)

These are the "LRU Cache"-style questions. Pure implementation + design combined. Master these first — they appear in both coding rounds and system design rounds.

### Order to attempt:

| #   | Problem                          | Platform      | Core Concept                       |
| --- | -------------------------------- | ------------- | ---------------------------------- |
| 1   | **LRU Cache**                    | LeetCode #146 | HashMap + Doubly Linked List       |
| 2   | **[[LFU Cache]]**                | LeetCode #460 | Min-heap or freq buckets           |
| 3   | **Design HashMap**               | LeetCode #706 | Hashing, chaining, open addressing |
| 4   | **Design Linked List**           | LeetCode #707 | Pointer manipulation               |
| 8   | **Design Twitter** (simplified)  | LeetCode #355 | Heap + following graph             |
| 9   | **Find Median from Data Stream** | LeetCode #295 | Two heaps                          |
| 10  | **Serialize & Deserialize BST**  | LeetCode #449 | Tree encoding                      |
| 11  | **Implement Trie**               | LeetCode #208 | Prefix trees                       |
| 12  | **Design Search Autocomplete**   | LeetCode #642 | Trie + ranking                     |
| 13  | **Design In-Memory File System** | LeetCode #588 | Trie on filesystem                 |
| 14  | **Design Hit Counter**           | LeetCode #362 | Sliding window, circular buffer    |
| 15  | **Time-Based Key-Value Store**   | LeetCode #981 | Binary search on timestamps        |

**Key insight:** For all of these, always discuss:

- Time complexity of each operation
- Space tradeoffs
- What happens at scale (this is where design begins)

---

## Phase 2 — Core Concepts to Study (Theory)

Study these topics before moving to full system design questions:

### 2.1 Caching

- Cache eviction policies: **LRU, LFU, FIFO, Random**
- Cache invalidation strategies: **write-through, write-back, write-around**
- Cache stampede / thundering herd
- Tools: Redis, Memcached
- **Key question to answer yourself:** When should you NOT cache?

### 2.2 Databases

- **SQL vs NoSQL** — when to use which
- Indexing (B-Tree, LSM-Tree)
- Sharding strategies: **range, hash, directory-based**
- Replication: **leader-follower, multi-leader, leaderless**
- CAP theorem and its practical meaning
- ACID vs BASE

### 2.3 Distributed Systems Fundamentals

- Consistent hashing — virtual nodes
- Quorum reads/writes (N, R, W)
- Vector clocks and conflict resolution
- Gossip protocol
- Heartbeats and failure detection

### 2.4 Scalability Patterns

- Horizontal vs vertical scaling
- Load balancing: Round robin, least connections, IP hash
- Database connection pooling
- Read replicas

### 2.5 Messaging & Async Processing

- Message queues (Kafka, RabbitMQ, SQS)
- Producer-consumer pattern
- Fan-out pattern
- Backpressure handling
- At-least-once vs exactly-once delivery

### 2.6 API Design

- REST vs GraphQL vs gRPC
- Rate limiting algorithms: **Token Bucket, Leaky Bucket, Fixed Window, Sliding Window Log**
- Pagination strategies
- Idempotency keys

### 2.7 Networking

- DNS resolution flow
- CDN (Content Delivery Networks)
- Long polling vs WebSockets vs SSE
- TCP vs UDP tradeoffs

---

## Phase 3 — Classic Full System Design Questions

Attempt these in order. Each one builds on previous concepts.

### Tier 1 — Foundational (Do These First)

#### 1. Design a URL Shortener (like bit.ly)

- Concepts: Hashing, Base62 encoding, DB schema, redirects, analytics
- Tricky parts: Collision handling, custom URLs, expiry

#### 2. Design a Rate Limiter

- Concepts: Token bucket / sliding window, distributed counter, Redis
- Tricky parts: Distributed rate limiting across servers

#### 3. Design a Key-Value Store (like Redis)

- Concepts: In-memory storage, persistence (AOF/RDB), replication, partitioning
- Tricky parts: Consistency during failures

#### 4. Design a Web Crawler

- Concepts: BFS/DFS, URL frontier, deduplication, politeness policy
- Tricky parts: Handling traps, distributed crawling

#### 5. Design Pastebin

- Concepts: Object storage, unique ID generation, expiry, access control
- Good starting point before tackling complex social systems

---

### Tier 2 — Intermediate

#### 6. Design a Notification System

- Concepts: Push vs pull, fan-out on write vs read, message queues, retry logic
- Tricky parts: Delivery guarantees, user preferences

#### 7. Design a News Feed (like Facebook/Twitter)

- Concepts: Fan-out, ranking algorithms, pagination
- Tricky parts: Celebrity problem (users with millions of followers)

#### 8. Design a Search Engine (typeahead / autocomplete)

- Concepts: Trie, ranking, personalization, distributed indexing
- Tricky parts: Real-time vs batch indexing

#### 9. Design Google Drive / Dropbox

- Concepts: Chunking, deduplication, sync protocol, conflict resolution
- Tricky parts: Delta sync, offline support

#### 10. Design a Chat System (like WhatsApp)

- Concepts: WebSockets, message ordering, read receipts, group messaging
- Tricky parts: Delivery guarantees, online/offline status

#### 11. Design YouTube / Video Streaming

- Concepts: Video transcoding, CDN, adaptive bitrate streaming, DAG processing pipeline
- Tricky parts: Encoding pipeline, resumable uploads

---

### Tier 3 — Advanced

#### 12. Design a Distributed Message Queue (like Kafka)

- Concepts: Log-structured storage, partitions, consumer groups, offset management
- Tricky parts: Exactly-once semantics, ordering guarantees

#### 13. Design a Proximity Service / Yelp

- Concepts: Geohashing, quadtree, spatial indexing
- Tricky parts: Dynamic data (moving users), radius search accuracy

#### 14. Design Uber / Lyft

- Concepts: Real-time location, matching algorithm, surge pricing, trip lifecycle
- Tricky parts: Consistency in ride matching, geospatial at scale

#### 15. Design a Distributed ID Generator (like Snowflake)

- Concepts: Timestamp + datacenter ID + sequence, clock skew
- Tricky parts: Monotonic IDs, NTP issues

#### 16. Design a Stock Exchange / Trading System

- Concepts: Order book, matching engine, low-latency, ACID transactions
- Tricky parts: Exactly-once trade execution, audit logs

#### 17. Design Google Maps

- Concepts: Graph algorithms (Dijkstra, A*), tile rendering, ETA prediction, map data storage
- Tricky parts: Real-time traffic, map updates at scale

#### 18. Design a Payment System

- Concepts: Idempotency, double-entry bookkeeping, distributed transactions, compliance
- Tricky parts: Consistency, fraud detection, rollback

---

## Phase 4 — Numbers Every Engineer Should Know

Memorize these. Use them in every estimation:

```
Latency (approximate):
  L1 cache reference       ~  0.5 ns
  Main memory reference    ~  100 ns
  SSD random read          ~  150 µs
  HDD random read          ~  10 ms
  Network round-trip (DC)  ~  500 µs
  Network round-trip (US)  ~  150 ms

Storage:
  1 char = 1 byte
  1 int  = 4 bytes
  1 UUID = 16 bytes
  1 image (avg) = ~300 KB
  1 video (1 min, 720p) ≈ 50 MB

Traffic math:
  1M users, 10 req/day = ~100 QPS
  1B users, 10 req/day = ~100,000 QPS
  
Availability:
  99%    = 87.6 hours downtime/year
  99.9%  = 8.76 hours downtime/year
  99.99% = 52.6 minutes downtime/year
```

---

## Phase 5 — Resources & Practice Plan

### Books

- **"Designing Data-Intensive Applications"** by Martin Kleppmann — read this cover to cover
- **"System Design Interview"** by Alex Xu (Vol 1 + 2) — great for interview prep
- **"The Art of Scalability"** by Abbott & Fisher

### Online Platforms

|Platform|What to use it for|
|---|---|
|**LeetCode**|Phase 1 problems (data structure design)|
|**Grokking System Design**|Structured walkthroughs|
|**ByteByteGo** (Alex Xu)|Visual breakdowns of classic systems|
|**High Scalability Blog**|Real-world architecture case studies|
|**Engineering blogs**|Netflix, Uber, Airbnb, Discord, Slack|

### Practice Schedule (8 Weeks)

```
Week 1-2:  Complete all Phase 1 LeetCode problems
Week 3:    Study Phase 2 theory (caching, databases, distributed systems)
Week 4:    Tier 1 design questions — do 2 per day with a timer
Week 5-6:  Tier 2 questions — go deep, write out your designs
Week 7:    Tier 3 questions — focus on tradeoffs
Week 8:    Mock interviews — practice talking out loud, whiteboarding
```

---

## Common Mistakes to Avoid

1. **Jumping into solutions without clarifying requirements.** Always ask 3-5 questions first.
2. **Designing for perfect scale from day 1.** Start simple, then evolve.
3. **Ignoring failure cases.** What happens when a node dies? When the DB is slow?
4. **Not knowing the numbers.** Estimation is a core skill, not optional.
5. **Being silent.** In interviews, thinking out loud IS the skill being evaluated.
6. **Over-engineering.** A simpler design you can defend > a complex one you cannot.

---

## The One Mental Model That Ties It All Together

Every system design question is fundamentally about **tradeoffs**:

```
Consistency  ←→  Availability
Latency      ←→  Throughput
Cost         ←→  Performance
Simplicity   ←→  Flexibility
```

Your job is not to find the "right" answer — it's to make informed tradeoffs and articulate WHY you made them. The interviewer wants to see how you think, not just what you know.

---

_Good luck. Start with LRU Cache and build from there._