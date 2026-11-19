---
title: "Vector Databases: Internals, Indexing & Trade-Offs"
tags:
  - GenAI
  - vector-databases
  - hnsw
  - ivf
  - database-internals
  - faiss-pinecone-qdrant
  - interview-prep
created: 2026-05-29
type: study-note
---

# Vector Databases: Internals, Indexing & Trade-Offs

---

## 1. Vector Indexing Internals

Traditional database indexes (B-Trees) search for exact matches in one-dimensional sorted lists. Vector databases, however, search for **Approximate Nearest Neighbors (ANN)** in high-dimensional vector spaces (typically 384 to 1536 dimensions). Flat brute-force scanning ($O(N)$ complexity) is too slow for production; thus, databases construct specialized indexes.

```
       HNSW (Graph-Based)                       IVF (Cluster-Based)
       
     Layer 2 (Sparsest)                     [Centroid A]     [Centroid B]
       o-----------o                             o                o
       |           |                            / \              / \
     Layer 1 (Medium)                          *   *            *   *
       o-----o-----o                          (Clusters of nearest vectors)
       |     |     |
     Layer 0 (All Vectors)
     o-o-o-o-o-o-o-o-o
```

### A. Hierarchical Navigable Small World (HNSW)
HNSW is a graph-based indexing algorithm inspired by **probabilistic skip lists**.
* **The Architecture**: It constructs a multi-layer graph. 
  * The **bottom layer (Layer 0)** contains all vectors as nodes, connected by edges to their nearest neighbors.
  * Each **higher layer** contains a sparser subset of vectors, creating "express lanes" to bridge large distances in the vector space.
* **The Search Path**:
  1. The search starts at the entry point of the top layer.
  2. The algorithm traverses the graph greedily, moving to nodes closer to the query vector.
  3. When it reaches a local minimum (no closer neighbors in the current layer), it steps down to the corresponding node in the next layer.
  4. This process repeats until it reaches Layer 0, where it performs local routing to find the closest vectors.
* **Trade-off**: High search speed ($O(\log N)$) and excellent recall accuracy. However, building the graph is slow, and it requires **extremely high RAM usage** to keep the graph structure in memory.

### B. Inverted File Index (IVF)
IVF is a cluster-based index designed to narrow the search space.
* **The Architecture**:
  1. The database uses **K-Means clustering** to divide the vector space into $C$ distinct regions (Voronoi cells), identifying a centroid for each region.
  2. It constructs an "inverted list" mapping each centroid to the IDs of the vectors located within its region.
* **The Search Path**:
  1. At query time, the system compares the query vector to all $C$ centroids.
  2. It identifies the $n$ closest centroids (defined by the parameter `nprobe`).
  3. The database scans **only** the vectors linked to those $n$ selected centroids, completely ignoring the rest of the database.
* **Trade-off**: Lower memory footprint and faster index build times compared to HNSW. However, search accuracy depends heavily on the `nprobe` parameter (higher `nprobe` improves recall but increases search latency).

### C. Product Quantization (PQ)
PQ is a lossy compression technique that allows high-dimensional vectors to fit into limited RAM.
* **The Architecture**:
  1. A vector of dimension $D$ is split into $M$ smaller sub-vectors of dimension $d = D/M$.
  2. For each sub-vector subspace, K-means clustering is run to find a set of centroids (typically 256 centroids, represented by 1 byte).
  3. The original floating-point sub-vectors are replaced by the 1-byte index of their nearest centroid.
  4. This compresses a 1024-dimensional float32 vector ($4096$ bytes) down to a $256$-byte codebook index representation.
* **Trade-off**: Reduces RAM usage by up to $95\%$, enabling billions of vectors to fit in memory. However, it introduces quantization noise, slightly degrading retrieval recall.

---

## 2. Vector Database Engine Trade-offs

When choosing a vector database engine, engineers balance hosting topologies, indexing speeds, metadata filtering capabilities, and cost.

| Database | Architecture Type | Indexing Strengths | Key Trade-offs | Best Use Case |
| :--- | :--- | :--- | :--- | :--- |
| **FAISS** (Meta) | In-memory Library | Pure, low-level execution (CPU/GPU). | No real-time updates, no built-in metadata filtering, no persistence (requires custom code to serialize vectors). | Running high-performance offline index builds or embedding jobs. |
| **Pinecone** | Managed Cloud Service | Cloud-native, autoscaling, serverless. | Expensive, vendor lock-in, closed-source, cannot run locally or offline. | Standard production deployments for teams wanting a managed service with no DevOps overhead. |
| **Qdrant** | Open-source Server / Embedded | Written in Rust. Fast, supports HNSW, payload filtering. | High RAM consumption (like all HNSW engines) when running large datasets locally. | Local-first, hybrid, or privacy-preserving enterprise setups requiring robust metadata payloads. |

---

## 3. Key Interview Q&As

### Q1: What is the "curse of dimensionality" in vector search?
**Answer**: In high-dimensional spaces (e.g., $D > 500$), the volume of the space grows exponentially. This causes the distance between *any* two points to converge to a nearly identical value. Standard distance metrics (like Euclidean distance) lose their discriminative power because the distance to the nearest neighbor becomes almost equal to the distance to the furthest neighbor. This makes clustering and indexing difficult, requiring cosine similarity or specialized inner-product indexing.

### Q2: How does metadata filtering work in vector databases (Pre-filtering vs. Post-filtering vs. Single-stage)?
**Answer**:
* **Post-filtering**: The database runs a vector search first (e.g., returns top 100 nearest vectors) and then filters out rows that do not match the metadata criteria. *Risk*: If few rows match the metadata, you may end up with 0 results.
* **Pre-filtering**: The database runs a metadata query first to find all matching rows, then performs a brute-force vector search over those matching records. *Risk*: Can be slow if millions of rows match the metadata, bypassing the vector index.
* **Single-stage (Iterative Filtering)**: The database traverses the vector index (like the HNSW graph) and checks the metadata criteria at each node step, routing only through nodes that satisfy both the spatial similarity and metadata constraints. This is the most efficient modern approach.

### Q3: Why does HNSW require so much memory, and how do you optimize it?
**Answer**: HNSW keeps a multi-layered graph in memory where every vector is a node containing pointers to its adjacent neighbors. These edge pointers consume significant RAM in addition to the raw vector floating-point arrays.
* *Optimizations*:
  1. Apply **Product Quantization (PQ)** or scalar quantization (compressing Float32 to Int8) to reduce weight memory footprints.
  2. Tweak the graph construction parameters: lower the maximum number of connections per node ($M$) and the size of the dynamic candidate list ($efConstruction$).
  3. Offload index segments to SSDs using memory-mapped files (MMAP).
