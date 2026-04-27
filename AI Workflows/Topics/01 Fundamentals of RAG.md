




# End‑to‑End Journey of a User Query Through a Locally Orchestrated RAG Pipeline (ChromaDB‑Based)

The journey is structured into two major life‑cycle pipelines: the **Ingestion & Indexing Pipeline** (which prepares the knowledge base) and the **Inference & Query Pipeline** (which processes a live user query). Only the second pipeline runs at query time, but the first is what makes retrieval possible.

For concreteness, we assume a typical open‑source local stack, such as the one described in the Core Marine production case study: **Ollama** for local LLM inference, **LlamaIndex** (or **LangChain**) as the orchestration framework, a lightweight embedding model such as `BAAI/bge-small-en` or `nomic-embed-text` running locally, and **ChromaDB** as the vector store. The steps are universal regardless of whether you use LlamaIndex, LangChain, or custom Python orchestration.

---

## Pipeline 0 – Ingestion & Indexing (Offline, Run Once per Knowledge‑Base Update)

Before any query can be answered, the system must ingest documents, break them into semantically meaningful chunks, embed them, and store everything in ChromaDB. This pipeline is typically triggered once per document set or on an incremental refresh schedule.

### 0.1 Document Loading & Pre‑processing

*Goal: Convert a heterogeneous collection of documents into clean, structured text objects with metadata.*

A local RAG system starts with **one or more document directories** containing source files (PDF reports, Office documents, plain text, Markdown, etc.). The integrity of the text extracted here directly determines the quality of the final answers.

**Key steps:**

| Step                     | What Happens                                                                                                                                            | Why It Matters                                                                                                                                                                                     |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Format‑aware loading** | Specialised readers (`PyPDFLoader`, `Docx2txtLoader`, `TextLoader`, `UnstructuredReader`, etc.) parse each file into a raw text payload.                | Different file types need different extraction logic; a single library like LangChain’s document loaders or LlamaIndex’s `SimpleDirectoryReader` can dispatch to the correct parser automatically. |
| **Metadata extraction**  | Source filename, page number, heading hierarchy, creation date, and any internal document tags are captured alongside the text.                         | Metadata is critical for filtering (e.g., "only search in 2024 reports") and for citing sources in the final response.                                                                             |
| **Content cleaning**     | Normalisation of whitespace, removal of non‑printable characters, handling of tables/images (either extracting alt‑text or skipping), and optional OCR. | Reduces noise that would otherwise degrade embedding quality and retrieval precision.                                                                                                              |

> **In a local setup**, all of this happens on‑device; no data leaves the machine. The output is a list of `Document` objects, each containing raw text + metadata.

### 0.2 Chunking

*Goal: Split long documents into smaller, semantically self‑contained pieces that fit within the embedding model’s context window and later within the LLM’s prompt.*

**Chunking strategy** is arguably the single most impactful design decision in a RAG system. If chunks are too large, retrieval dilutes; if too small, context is lost. The following parameters are tuned:

| Parameter         | Typical Value / Approach                                         | Rationale                                                                                                                                                                              |
| ----------------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Chunk size**    | 256–1024 tokens (language‑dependent)                             | Must stay below the embedding model’s max input length (typically 512 tokens for many sentence‑transformers). Smaller chunks improve retrieval precision but may split coherent ideas. |
| **Chunk overlap** | 10–25% of chunk size (e.g., 25–50 tokens)                        | Prevents a sentence from being “cut in half” across chunk boundaries; improves recall at the cost of some duplication.                                                                 |
| **Split method**  | Recursive character splitting by paragraph, sentence, then token | Respects natural document structure while guaranteeing a hard token cap.                                                                                                               |

**Example** (from a real RAG system indexing journal text):
*“Journal entries in `./data` are chunked (256 tokens, 25‑token overlap) and embedded into a vector store using LlamaIndex.”*

A few advanced chunking techniques:
- **Semantic chunking**: uses an embedding model to detect topic shifts and split on semantic boundaries rather than fixed token counts.
- **Small‑to‑big / parent‑child**: stores small chunks for search but returns the larger parent passage in the prompt, preserving context.

### 0.3 Embedding Generation

*Goal: Convert each text chunk into a dense, fixed‑dimensional vector that captures its semantic meaning.*

For a fully local system, a small, efficient **sentence‑transformer model** is used rather than a paid API. Commonly used local embedding models include:

| Model | Dimension | Approx. Size | Strengths |
|-------|-----------|---------------|-----------|
| `BAAI/bge-small-en` (v1.5) | 384 | 130 MB | Excellent quality‑for‑size, widely used in open‑source RAG |
| `nomic-embed-text` | 768 | 275 MB | Good performance on technical documents, used in the Core Marine case |
| `all-MiniLM-L6-v2` | 384 | 90 MB | Fast, small, adequate for many general‑purpose setups |

**How it runs locally:**
1. The embedding model is loaded into memory (CPU or GPU) via HuggingFace `sentence-transformers` or the LlamaIndex/LangChain embedding wrappers.
2. Text chunks are fed through in batches (to exploit GPU parallelism if available).
3. Each chunk is mapped to a vector of floating‑point numbers.
4. The embedding model is **frozen** – it is never fine‑tuned in a basic RAG pipeline.

### 0.4 Storage in ChromaDB

*Goal: Persist the embeddings + metadata in a vector database that supports fast approximate nearest‑neighbour (ANN) search.*

**ChromaDB** is an open‑source, lightweight, persistent vector database designed for developer‑friendly local deployment. It can run **fully embedded** in the same Python process or as a standalone server, but in a local‑first RAG pipeline it is almost always used as a persistent local client.

**Storage model inside ChromaDB:**

```
ChromaDB Client (PersistentClient)
 ├── Collection: "my_documents"
 │   ├── Embedding Metadata: model name, dimension (e.g., 384)
 │   ├── Documents: list of chunk text strings
 │   ├── Embeddings: list of float vectors (the dense representations)
 │   ├── IDs: unique identifiers for each chunk
 │   └── Metadata: per-chunk metadata dict (source, page, etc.)
 └── On disk: stored as SQLite + Parquet files (persistent by default)
```

**Indexing workflow:**
1. A **PersistentClient** connects to a path on disk (e.g., `./chroma_db`).
2. A **collection** is created (or retrieved if already exists) with a consistent embedding function.
3. Chunks, embeddings, IDs, and metadata are inserted into the collection.
4. ChromaDB automatically builds an **ANN index** (using HNSW – Hierarchical Navigable Small World graphs) to enable sub‑millisecond similarity search even on medium‑sized collections.
5. The index is persisted to disk; subsequent queries load it directly without re‑embedding.

**Critical design note:** The embedding function **must** be exactly the same at query time that was used during ingestion. If you embed with `bge-small-en` but query with `nomic-embed-text`, the vector spaces are completely unaligned and retrieval will be nonsensical.

---

## Pipeline 1 – Inference & Query Processing (Runs in Real‑Time per User Request)

Now the knowledge base is ready. When a user types a question and hits enter, the following chain executes – typically in under 2–3 seconds on local hardware.

The orchestration framework (LlamaIndex or LangChain) provides a **Query Engine** abstraction that ties these steps together into a single `query(question)` call. The underlying sequence is:

```
User Query
    │
    ▼
[1. Query Embedding]
    │
    ▼
[2. Vector Similarity Search (ChromaDB)]
    │
    ▼
[3. (Optional) Re‑ranking]
    │
    ▼
[4. Context Augmentation / Prompt Assembly]
    │
    ▼
[5. LLM Generation (local, e.g., Ollama)]
    │
    ▼
[6. Post‑processing & Response]
    │
    ▼
Final Answer (streamed or returned to user)
```

### 1.1 Query Embedding

*What happens:* The raw user text (“What safety procedures apply to deep‑water operations?”) is run through the **exact same embedding model** used during ingestion.

*Output:* A single dense vector of dimension *d* (e.g., 384 floats for `bge-small-en`). This vector represents the *semantic meaning* of the query, not its literal keywords.

*Cost:* On a local CPU, embedding a short sentence takes ~5–20 ms. On a GPU, <1 ms.

### 1.2 Vector Similarity Search (Retrieval)

*What happens:* The query embedding is sent to ChromaDB’s `collection.query()` method. ChromaDB performs an ANN search (HNSW‑based) through the stored vectors, computing a similarity metric (typically cosine similarity) and returning the top‑*k* most similar chunks.

*Parameters:*

| Parameter | Typical Default | Meaning |
|-----------|-----------------|---------|
| `query_embeddings` | The vector from step 1.1 | The search target |
| `n_results` (top‑*k*) | 3–10 | How many candidate chunks to retrieve; trading recall for prompt length |
| `include` | `["documents", "metadatas", "distances"]` | What to return alongside the vectors |

*Output:* A list of (chunk_text, metadata, similarity_score) tuples, ranked by cosine similarity.

*Cost:* Highly optimised; typically <5–10 ms even for collections with hundreds of thousands of vectors when running locally.

> **Note on local vs. cloud**: Because ChromaDB is embedded in the same process, there is **no network round‑trip** for retrieval. This is a key architectural advantage over client‑server vector databases in local‑first deployments.

### 1.3 (Optional but Strongly Recommended) Re‑ranking

The initial ANN search is fast but approximate; it may return chunks that are lexically similar but not truly relevant to the question. A **cross‑encoder re‑ranker** is a small, discriminative transformer model that takes a `(query, chunk)` pair and outputs a relevance score – capturing fine‑grained semantic matching that embedding cosine similarity sometimes misses.

**Local re‑ranking example (from a real journal‑search RAG):**
*“A cross‑encoder (`cross-encoder/ms-marco-MiniLM-L-12-v2`) scores each (query, chunk) pair jointly and keeps the top 15 [out of 30 initial candidates].”*

**Workflow:**
1. Retrieve top‑*n* candidates (e.g., *n* = 30).
2. Pass each `(query, chunk)` pair through the cross‑encoder to get a relevance score.
3. Sort by score and keep the top‑*m* (e.g., *m* = 5–15).

**Cost:** This is the most computationally expensive retrieval step – the cross‑encoder must run on every candidate chunk – but with *n* ≤ 30 it is still <100 ms on a local CPU and near‑instant on a GPU. The cost is usually well worth the improvement in precision.

### 1.4 Context Augmentation / Prompt Assembly

*What happens:* The orchestrator constructs the final prompt that will be sent to the LLM. This is where the “Augmented” in RAG happens: the retrieved chunks are **injected into the prompt** as grounding context.

**A typical local RAG prompt template** (using LangChain‑style placeholders):

```text
You are a helpful assistant that answers questions based solely on the provided context.
If the answer cannot be found in the context, say "I don't have enough information to answer that."

Context:
{context}

Question: {question}

Answer:
```

The `{context}` variable is filled with the concatenated text of the top‑*k* chunks, often formatted with source markers:
```text
[Source: safety_manual.pdf, Section 3.2]
All offshore personnel must wear personal flotation devices when outside enclosed areas...
```

The orchestrator is also responsible for **prompt‑length management**: ensuring that context + question fit within the LLM’s context window (a concern especially with smaller local models that may have 4K–8K token limits).

### 1.5 LLM Generation (Local Inference)

*What happens:* The fully assembled prompt is sent to the **local LLM serving runtime** for autoregressive text generation. This is where the LLM reads the user’s question together with the retrieved context and produces a grounded answer.

**Local serving runtimes commonly used:**

| Runtime | Key Characteristics |
|---------|---------------------|
| **Ollama** | Simplest setup; one‑command model pull & serve; wraps llama.cpp; REST API on port 11434; widely used in local‑first RAG tutorials |
| **llama.cpp** | Highly optimised C++ inference; supports aggressive quantisation (GGUF format); ideal for CPU‑only or Apple Silicon Macs |
| **vLLM** | Highest throughput for GPU‑based serving; PagedAttention for KV‑cache efficiency; used in production‑grade setups |
| **HuggingFace Transformers** | Python‑native; easy integration; slower – best for prototyping |

**LLM selection (fully local):**

Common choices for a local, privacy‑preserving, fully offline RAG system include:

| Model | Size | Suitability |
|-------|------|-------------|
| Llama 3.2‑3B | ~2.5 GB (Q4) | Good quality‑for‑size; the Core Marine production system uses this for technical Q&A |
| Mistral 7B | ~4.4 GB (Q4) | Strong reasoning; popular open‑source choice |
| Command‑R (CR‑7B) | ~5 GB (Q4) | Designed for RAG; can use longer contexts |

The LLM receives the augmented prompt and performs standard autoregressive decoding (prefill + autoregressive token generation). The output is a stream of text tokens that constitute the answer.

**Key generation parameter:** `temperature` is typically set low (0.0–0.3) for factual Q&A to minimise hallucination beyond the provided context.

### 1.6 Post‑processing & Response

*What happens after the LLM produces tokens:*

1. **Decoding**: Tokens are detokenised back into readable text.
2. **Source citation extraction**: If the prompt template included source markers, the orchestrator may extract and format citations for the user.
3. **Streaming**: If the system supports streaming, generated text is yielded token‑by‑token or sentence‑by‑sentence to the frontend (a Dash web app, Streamlit interface, CLI, or REST API). This provides the user with progressive feedback.
4. **Logging/Observability**: The query, retrieved chunks, and generated answer are typically logged for evaluation and iteration.

---

## Putting It All Together: The Full Trace of a Single Query

Below is a concrete, annotated trace of a single user interaction, drawn from real implementation patterns.

```
┌─────────────────────────────────────────────────────────────┐
│ TIME │ STEP                          │ WHAT HAPPENS          │
├──────┼───────────────────────────────┼───────────────────────┤
│ T0   │ User types: "What is the      │ Frontend (Dash,       │
│      │ daily withdrawal limit on     │ Streamlit, or CLI)    │
│      │ the MaxSavers account?"       │ captures input.       │
│──────┼───────────────────────────────┼───────────────────────┤
│ T+2  │ Query embedding               │ Text → 384‑dim (or    │
│      │                               │ 768‑dim) vector via   │
│      │                               │ local bge‑small‑en.   │
│──────┼───────────────────────────────┼───────────────────────┤
│ T+5  │ ChromaDB ANN search           │ HNSW index returns    │
│      │ (k=6)                         │ top‑6 most similar    │
│      │                               │ chunks + metadata +   │
│      │                               │ scores.               │
│──────┼───────────────────────────────┼───────────────────────┤
│ T+10 │ Cross‑encoder re‑rank         │ Reduces 6 candidates  │
│      │ (optional)                    │ to the top 3 using    │
│      │                               │ MiniLM cross‑encoder. │
│──────┼───────────────────────────────┼───────────────────────┤
│ T+12 │ Prompt assembly               │ "Context: [chunk 1]   │
│      │                               │ [chunk 2] [chunk 3]   │
│      │                               │ Question: ...         │
│      │                               │ Answer:"              │
│──────┼───────────────────────────────┼───────────────────────┤
│ T+13 │ LLM inference (Ollama /       │ llama3.2:3b reads     │
│      │ llama.cpp)                    │ context + question,   │
│      │                               │ generates "The daily  │
│      │                               │ withdrawal limit is   │
│      │                               │ £500 per account      │
│      │                               │ holder [...]"         │
│──────┼───────────────────────────────┼───────────────────────┤
│ T+   │ Response streaming & render   │ Answer appears in UI  │
│ 800  │                               │ with source citations.│
│ ms   │                               │ Total elapsed: ~830   │
│      │                               │ ms (GPU) or 2–3 sec   │
│      │                               │ (CPU).                │
└──────────────────────────────────────────────────────────────┘
```

(Exact timings depend heavily on hardware, model size, and quantisation; the above is illustrative for a 7B‑class model on a mid‑range GPU.)

---

## Critical Architectural Considerations for Local Deployment

### 1. Why ChromaDB (Embedded Mode)

- **Zero network dependency**: No server process; the DB runs inside the Python process that queries it.
- **Persistence**: Data survives restarts; no need for container orchestration.
- **Simplicity**: Works out of the box without database credentials, certificates, or cloud configuration.
- **Performance adequacy**: For typical local document collections (up to hundreds of thousands of chunks), ChromaDB’s HNSW index provides retrieval in single‑digit milliseconds.

### 2. Orchestration Framework Role

Whether using **LlamaIndex** or **LangChain**, the framework provides:
- A unified `QueryEngine` that chains embedding, retrieval, augmentation, and generation.
- Document loaders, chunkers, and embedding wrappers that remove boilerplate.
- Prompt template management so system prompts and context formatting are consistent.
- (LlamaIndex) Built‑in support for re‑ranking, hybrid search, and iterative retrieval.

The Core Marine case study emphasises why orchestration matters: *“Without proper orchestration, even a fast language model cannot effectively retrieve relevant information from large document collections. … a RAG engine functions like a book’s index, allowing direct navigation to relevant content.”*

### 3. Memory & Storage Trade‑offs

- **Vector store size**: ~(number_of_chunks × embedding_dim × 4 bytes) for the raw vectors, plus index overhead. A 738,470‑vector index (Core Marine example) takes tens of GB.
- **Embedding model**: 100–300 MB, loaded once at startup.
- **LLM weights**: 2–8 GB for quantised 3B–7B models; 20+ GB for 13B and larger.
- **KV cache (during inference)**: Additional memory proportional to context length + generation length.

A typical local workstation with 32 GB RAM and a 12 GB GPU can comfortably run a 7B LLM + embedding model + ChromaDB for document collections up to ~200K chunks.

---

## Summary

The complete end‑to‑end journey of a user query in a locally orchestrated RAG system proceeds through **two pipelines**. The **offline ingestion pipeline** loads documents, cleans them, chunks them intelligently, embeds each chunk with a local sentence‑transformer, and stores the resulting vectors + metadata in a persistent ChromaDB collection. The **online inference pipeline** (triggered by each user query) embeds the question, searches ChromaDB for the most similar chunks, optionally re‑ranks them with a cross‑encoder, assembles an augmented prompt combining question + retrieved context, and sends it to a locally running LLM (via Ollama, llama.cpp, or vLLM). The LLM generates a grounded, source‑cited answer which is streamed to the user. The entire loop runs entirely on local hardware with no external API calls, guaranteeing data privacy and zero recurring inference cost while delivering response latency of a few hundred milliseconds to a few seconds, depending on hardware capability. The orchestration between these steps is handled by a framework (LlamaIndex or LangChain), with ChromaDB providing the core retrieval capability through persistent local HNSW‑based ANN search.

---

