---
tags:
  - database/nosql
  - database/vector
  - database/pgvector
  - database/common-topic
category: nosql
created: 2026-06-15
---

# Vector Databases & pgvector (Advanced Deep Dive)

This document details the geometric properties of high-dimensional vector spaces, the graph mathematics of HNSW and IVF indices, and the hardware-level optimizations that enable fast vector operations.

---

## 1. High-Dimensional Vector Geometry & Hardware Acceleration

### The Curse of Dimensionality in Vector Search
In high-dimensional spaces (e.g., $D = 1536$), geometric intuitions break down. 

As dimensions $D \to \infty$, the distance between any two random vectors in a unit hypercube converges to a constant value:
$$\lim_{D \to \infty} \frac{\text{Distance}_{\text{Max}} - \text{Distance}_{\text{Min}}}{\text{Distance}_{\text{Min}}} = 0$$

This means that in very high dimensions, all points appear to be almost equidistant from each other when using Euclidean ($L_2$) distance. 

For this reason, **Cosine Similarity** (which measures the orientation/angle between vectors rather than their spatial coordinate difference) is more robust for comparing semantic meaning:
$$\cos(\theta) = \frac{\mathbf{A} \cdot \mathbf{B}}{\|\mathbf{A}\| \|\mathbf{B}\|}$$

### SIMD Hardware Acceleration
Calculating vector distances requires millions of operations. For a 1536-dimensional vector, a single dot product requires $1536$ multiplications and $1535$ additions.

Modern CPUs accelerate this using **Single Instruction, Multiple Data (SIMD)** vector registers (e.g., Intel AVX-512, ARM Neon):
*   **AVX-512:** Can hold sixteen 32-bit floating-point numbers in a single register.
*   **Fused Multiply-Accumulate (FMA):** A CPU instruction that executes:
    $$d = a \times b + c$$
    in a single CPU clock cycle.
*   By loading 16 dimensions of Vector A and Vector B into registers, the CPU calculates 16 dimensions of the dot product in a single cycle, achieving up to $16\times$ speedups.

---

## 2. HNSW & IVF Index Mathematics

To avoid $O(N)$ flat table scans, databases build Approximate Nearest Neighbor (ANN) indexes.

### HNSW Graph Layering Probability
**Hierarchical Navigable Small World (HNSW)** assigns vector nodes to graph layers ($L_0, L_1, \dots$) where $L_0$ contains all nodes and higher layers contain exponentially fewer nodes.

```text
Layer 2 (Top, coarse search)      [Entry Point] --------> Node A
                                                             |
                                                             v (Drop layer)
Layer 1 (Medium resolution)                         Node A -> Node B -> Node C
                                                                          |
                                                                          v (Drop layer)
Layer 0 (Bottom, fine search)                                  Node C -> Node D -> [Target]
```

To assign the maximum layer $l$ for an inserted vector, we use a decaying probability distribution:
$$l = \lfloor -\ln(\text{uniform}(0,1)) \times m_L \rfloor$$
Where the normalization factor $m_L$ is:
$$m_L = \frac{1}{\ln(M)}$$
*   $M$: The maximum number of bidirectional connection links (edges) allowed per node (typically set between 16 and 64).
*   *Search Path:* Greedy search walks the top layer until it hits a local minimum (no closer neighbors), then drops to the corresponding node in the lower layer and repeats, terminating at $L_0$.

### IVF Partitioning & Voronoi Cells
**Inverted File (IVF)** indexes use k-means clustering to partition the vector space into $C$ **Voronoi cells** (defined by centroids $\mu_i$):

$$\text{Voronoi Cell } V_i = \{ x \in \mathbb{R}^d \mid \|x - \mu_i\| \le \|x - \mu_j\| \;\; \forall j \neq i \}$$

```text
+-------------------+-------------------+
|      o (Centroid) |      o (Centroid) |
|   x      x        |         x         |
|      x (Vectors)  |    x        x     |
+-------------------+-------------------+
|      o (Centroid) |      o (Centroid) |
|   x               |        x      x   |
|        x     x    |   x               |
+-------------------+-------------------+
```

*   *Search Path:* 
    1.  The query vector is compared to the $C$ centroids.
    2.  The closest $P$ centroids are selected ($P$ is the **probe count** or `nprobe`).
    3.  Only the vectors mapped to those $P$ centroids are scanned, bypassing $99\%$ of the database.

---

## 3. pgvector Page Layout & Search Mechanics

In PostgreSQL, indexes must map onto the standard **8KB Page Buffer** architecture:

```text
+-----------------------------------------------------------------------+
| Postgres Page Header                                                  |
+-----------------------------------------------------------------------+
| Item Pointers (Offsets to index tuple headers)                        |
+-----------------------------------------------------------------------+
| ... HNSW Tuple:                                                       |
| [Vector ID (8B) | Layer (2B) | Edge Count (2B) | Edge List Array...] |
+-----------------------------------------------------------------------+
```

*   **HNSW Index Tuple Layout:** Every node in the HNSW graph is stored as a tuple inside an 8KB index page. The tuple stores the original vector ID, the node's maximum layer, and an array of pointers (tuples IDs `(Page, Offset)`) representing the outgoing edges (neighbor nodes) for each layer.
*   **Buffer Traversal:** When running a search, the index executor traverses the graph by reading the starting page, parsing the edge array, and loading the pages corresponding to those target edges into the shared buffer pool.

---

## 4. End-to-End Python Pipeline using SentenceTransformers

This production-ready Python example connects to PostgreSQL, downloads an embedding model, generates real 384-dimensional semantic embeddings, and executes vector scans using `pgvector`:

```python
import psycopg2
from psycopg2.extras import execute_values
from sentence_transformers import SentenceTransformer

# 1. Initialize SentenceTransformer (Downloads all-MiniLM-L6-v2)
# Generates 384-dimensional dense vectors
model = SentenceTransformer('all-MiniLM-L6-v2')

# Connect to Postgres
conn = psycopg2.connect("dbname=postgres user=postgres password=secret host=localhost")
cur = conn.cursor()

# 2. Setup DB schema
cur.execute("CREATE EXTENSION IF NOT EXISTS vector;")
cur.execute("""
    CREATE TABLE IF NOT EXISTS knowledge_base (
        id SERIAL PRIMARY KEY,
        text_content TEXT NOT NULL,
        embedding vector(384)
    );
""")
conn.commit()

# 3. Create HNSW index for Cosine Distance
cur.execute("""
    CREATE INDEX IF NOT EXISTS idx_knowledge_hnsw 
    ON knowledge_base USING hnsw (embedding vector_cosine_ops);
""")
conn.commit()

# 4. Data Insertion Pipeline
documents = [
    "ACID transactions guarantee database consistency during system crashes.",
    "B-Trees use a slotted page layout to organize variable-length records.",
    "Saga orchestrators persist execution states to handle coordinator crashes.",
    "Consistent hashing rings assign keys to virtual nodes on a circle."
]

# Generate real vector embeddings
embeddings = model.encode(documents)

# Format payload: (text, vector string representation)
insert_data = [
    (doc, str(emb.tolist())) 
    for doc, emb in zip(documents, embeddings)
]

execute_values(
    cur,
    "INSERT INTO knowledge_base (text_content, embedding) VALUES %s",
    insert_data
)
conn.commit()

# 5. Semantic Search Query
user_query = "How do databases recover from a power outage?"
query_embedding = model.encode(user_query).tolist()

cur.execute("""
    SELECT text_content, embedding <=> %s::vector AS distance
    FROM knowledge_base
    ORDER BY distance ASC
    LIMIT 2;
""", (str(query_embedding),))

print(f"\nUser Query: '{user_query}'")
print("Top Semantic Matches:")
for content, distance in cur.fetchall():
    print(f"- {content} (Cosine Distance: {distance:.4f})")

cur.close()
conn.close()
```
*Note: Cosine Distance ranges from 0.0 (identical vectors) to 2.0 (opposite vectors).*
