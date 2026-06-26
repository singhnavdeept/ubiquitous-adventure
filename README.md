# 🚀 Ubiquitous Adventure: The Incremental Learning Journey

Welcome to the **Ubiquitous Adventure** repository! This is a living knowledge base and workspace dedicated to the philosophy of **incremental learning**—the idea that small, consistent, daily deep dives compound into massive expertise over time.

> *"The secret of getting ahead is getting started. The secret of getting started is breaking your complex overwhelming tasks into small manageable tasks, and starting on the first one."*

---

## 🎯 The Core Philosophy

1.  **Deep Work Over Surface Scanning**: We don't just learn *how* to use a tool; we dive into *why* it was built and *how* it operates under the hood.
2.  **Applied Knowledge**: Theoretical notes are immediately followed by practical projects (e.g., pairing Golang concurrency theory with a Concurrent Seat Booking project).
3.  **Compound Growth**: Writing atomic notes, system design teardowns, and architecture specs ensures that yesterday's learnings become today's foundations.

---

## 📂 Repository Structure

This workspace is categorized into specialized domains of learning:

### 🤖 1. AI / Machine Learning
*   **[`/AI - ML`](./AI%20-%20ML/)**: The primary home for all AI and ML study material.
    *   **[`/AI - ML/Topics`](./AI%20-%20ML/Topics/)**: Structured deep-dive series covering core ML engineering concepts:
        *   `01 Fundamentals of RAG` — Retrieval-Augmented Generation architecture and patterns.
        *   `02 Chunking Strategies` — How to split documents for optimal vector retrieval.
        *   `03 Reranking System` — Cross-encoder reranking for improved retrieval precision.
        *   `04 LLM Internals - Transformer and KV Cache` — Attention mechanisms and inference optimization.
        *   `05 RAG vs Fine-Tuning and Quantization` — When to fine-tune vs. augment, and model compression.
        *   `06 Agentic Systems - ReAct, Tools, and Memory` — Building autonomous reasoning agents.
        *   `07 Vector Databases - Internals and Tradeoffs` — HNSW, IVF, ANN algorithms, and database internals.
        *   `08 MLOps - Serving, RAGAS Evaluation, and Monitoring` — Production ML pipelines and evaluation.
    *   **[`/AI - ML/ML Interviews`](./AI%20-%20ML/ML%20Interviews/)**: ML system design interview walkthroughs.
        *   `Build a Visual Search System` — End-to-end Pinterest-style visual search design covering representation learning, contrastive training (SimCLR/MoCo/InfoNCE), nDCG evaluation, and ANN serving (IVF-PQ, HNSW, Faiss).
    *   **[`/AI - ML/Llamaindex`](./AI%20-%20ML/Llamaindex/)**: Framework-specific notes on LlamaIndex for RAG pipelines.
    *   `Different frameworks.md` — Comparative analysis of AI/ML frameworks.
    *   `Ml algorithms Distribution.md` — Overview of ML algorithm families and use-case distributions.

### 🧠 2. Architecture & Systems
*   **[`/DEEP dive`](./DEEP%20dive/)**: Comprehensive, highly-detailed teardowns of modern systems, frameworks, and tools.
    *   *Includes: Redis Internals, Uber System Design, High-Concurrency Ticket Booking, Dropbox Architecture.*
*   **[`/System Design`](./System%20Design/)**: General system design patterns, scalability principles, and architectural trade-offs.
    *   `Back of the envelope.md` — Estimation frameworks: latency numbers, storage calculations, QPS sizing.

### 💻 3. Software Engineering & Languages
*   **[`/GOLANG`](./GOLANG/)**: Deep explorations into Go mechanics — from basic syntax to advanced concurrency, HTTP servers, and gRPC.
    *   **[`/GOLANG/Notes`](./GOLANG/Notes/)**: Phase-by-phase structured Go backend mastery notes:
        *   *Phase 1: Go Language Fundamentals* — Types, control flow, functions, closures.
        *   *Phase 2: Concurrency* — Goroutines, channels, the M:N scheduler, sync primitives.
        *   *Phase 3: HTTP Servers & REST APIs* — `net/http`, middleware, routing patterns.
        *   *Phase 4: Databases* — SQL drivers, `sqlx`, connection pooling, migrations.
        *   *Phase 5: Authentication & Security* — JWT, OAuth2, bcrypt, HTTPS.
        *   *Phase 6: Testing* — Table-driven tests, mocks, benchmarks.
        *   *Phase 7: gRPC & Protocol Buffers* — Protobuf schemas, streaming, interceptors.
        *   *Phase 8: Microservices Patterns* — Service mesh, circuit breakers, service discovery.
        *   *Phase 9: Deployment & DevOps* — Docker, Kubernetes, CI/CD.
        *   *Phase 10: Advanced Go Performance* — pprof, escape analysis, memory optimization.
    *   **[`/GOLANG/Reugular topics`](./GOLANG/Reugular%20topics/)**: Standalone deep dives on specific Go concepts.
        *   `Structs.md` — Memory layout, embedding/composition, struct tags, reflection, alignment padding, and interview Q&A.
    *   `golang_execution_and_binary_notes.md` — How Go compiles and links binaries, runtime bootstrapping.
    *   `Complete Go Backend Mastery Roadmap.md` — The source roadmap document.
*   **[`/DSA`](./DSA/)**: Data Structures and Algorithms practice.

### 🗄️ 4. Data & Infrastructure
*   **[`/Databases`](./Databases/)**: Relational/NoSQL storage engines, page/block file layouts, vector databases (pgvector), query optimizations, and execution planning.
    *   *Recent: Updated Cassandra notes (NoSQL deep dive).*
*   **[`/Big Data`](./Big%20Data/) & [`/Data Engineering`](./Data%20Engineering/)**: Distributed data processing and pipelines.
*   **[`/Tools`](./Tools/)**: CI/CD pipelines, container orchestration, API testing, and automation (Docker, Kubernetes, Jenkins, Postman/REST APIs).

### 🛠️ 5. Applied Projects
*   **[`/Projects`](./Projects/)**: The proving ground where theory becomes code.
    *   *Examples: Concurrent Seat Booking System, Docker Cleanup Daemon, MdMaker.*

### 📝 6. Personal Knowledge Management (PKM)
*   **[`/Atomic Notes`](./Atomic%20Notes/) & [`/DailyNotes`](./DailyNotes/)**: Daily scratchpads and Zettelkasten-style interconnected thoughts.
*   **[`/Backend (theory)`](./Backend%20(theory)/)**: Backend engineering theory: protocols, distributed systems fundamentals.

---

## 📈 The Incremental Process

1.  **Read & Research**: Take raw information and distill it into `/Atomic Notes`.
2.  **Deep Dive**: Consolidate atomic notes into comprehensive, structured documents in `/DEEP dive` or domain folders.
3.  **Build**: Validate the deep dive by building a real-world application in `/Projects`.
4.  **Refine**: Update notes based on practical bugs, bottlenecks, and engineering challenges faced during the build phase.

---

## 🗂️ Recent Changes

| Date | Change |
| :--- | :--- |
| 2026-06-26 | Added `AI - ML/` folder — new home for all AI/ML notes (migrated and expanded from `AiWorkflows/`) |
| 2026-06-26 | Added `AI - ML/ML Interviews/Build a Visual Search System.md` — Pinterest-style visual search system design with full ML depth |
| 2026-06-26 | Added `System Design/Back of the envelope.md` — estimation and sizing reference |
| 2026-06-25 | Added `GOLANG/Reugular topics/Structs.md` — in-depth Go structs deep dive with memory layout, tags, embedding, and interview Q&A |
| 2026-06-25 | Expanded `GOLANG/Notes/` — all 10 phase notes with Obsidian properties, code examples, and interview questions |
| 2026-06-25 | Updated `Databases/NO SQL/Cassandra.md` |
| 2026-06-25 | Updated `Projects/MdMaker documentation.md` |

---

*Stay consistent. The compound interest of knowledge is the most powerful force in software engineering.*
