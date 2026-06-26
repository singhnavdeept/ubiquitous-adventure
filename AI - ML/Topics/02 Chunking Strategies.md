
---

# Chunking Strategies for RAG: A Complete Expert Reference

## 1. What Is Chunking and Why Does It Matter?

Chunking is the process of dividing large source documents into smaller, semantically manageable segments (chunks) before embedding and indexing them in a vector database. In a RAG pipeline, chunking sits between document loading and embedding generation. It is the *single most consequential preprocessing decision* in RAG: get chunking right, and retrieval is precise, context-complete, and efficient; get it wrong, and the rest of the pipeline—no matter how sophisticated the embedding model, vector database, or LLM—underperforms.

**Why chunking is essential:**

1. **Context-window limits.** All LLMs have a finite context window. Without chunking, the model cannot ingest an entire document in one prompt. Chunking breaks documents into pieces that fit within the model's token limit.

2. **Semantic dilution in long texts.** Embedding a very long, multi-topic text into a single fixed-dimensional vector causes information loss: the vector averages across diverse themes, losing fine-grained details. Chunking preserves semantic specificity.

3. **Retrieval precision.** A well-chunked document yields chunks that each represent one coherent idea. When a user query matches a chunk, the retrieved content is on-point, improving both retrieval relevance and the LLM's ability to generate an accurate, grounded answer.

4. **Efficiency.** Embedding and searching many small vectors is computationally cheaper than processing enormous monolithic vectors, and it enables more efficient use of the vector database's approximate nearest-neighbour (ANN) index.

The challenge: a chunk that is too small loses context; a chunk that is too large dilutes semantic precision and may exceed token limits. The "art" of chunking is finding the right balance for a specific document type, embedding model, and query pattern.

---

## 2. The Fundamental Chunking Trade-off

Every chunking strategy navigates a core tension, which can be summarised as the **specificity–context axis**:

| Chunk Size | Specificity | Context | Typical Problem |
|------------|-------------|---------|-----------------|
| **Small** (e.g., 1–3 sentences, 64–128 tokens) | High: each chunk captures a precise fact or idea | Low: surrounding context is lost | Missing context degrades answer quality; related information may be split across chunks |
| **Medium** (e.g., 256–512 tokens) | Moderate | Moderate | The "default" sweet spot for many applications |
| **Large** (e.g., 1,000+ tokens, full pages) | Low: multiple topics conflated in one vector | High: full context preserved | Retrieval precision suffers; vector "forgets" details; LLM processing cost increases |

This trade-off is fundamental to fixed-dimensional embeddings: as chunk size grows, a fixed-size vector must compress increasingly diverse information, inevitably losing fine-grained details. The optimal chunk size is therefore **query-dependent**—a fact that motivates several adaptive chunking strategies discussed later.

---

## 3. Taxonomy of Chunking Strategies

Chunking strategies can be organised along a spectrum from **static, rule-based** to **dynamic, AI-driven**:

```
Fixed-Size → Structure-Aware → Semantic → Model-Based → Adaptive/Multi-Scale
    │              │              │            │              │
  Simplest    Uses document    Embedding-   LLM-guided    Query-dependent
  lowest cost  hierarchy       similarity   segmentation  dynamic selection
```

Below, each family is examined in depth.

---

## 4. Fixed-Size Chunking (Character/Token-Based)

### 4.1 Description

The simplest strategy: split text into segments of a preset character or token count, optionally with a fixed overlap between adjacent chunks. No document structure or semantics are considered.

**Variants:**
- **Character-based:** Split every *N* characters.
- **Token-based:** Split every *N* tokens (more embedding-model-aware, since token counts are what actually matter for context windows).

### 4.2 Implementation

In LangChain, fixed-size splitting is provided by the `CharacterTextSplitter`:

```python
from langchain_text_splitters import CharacterTextSplitter

splitter = CharacterTextSplitter(
    separator=" ",        # split on word boundaries
    chunk_size=200,       # characters per chunk
    chunk_overlap=0       # no overlap
)
chunks = splitter.split_documents(documents)
```

### 4.3 Advantages
- **Trivial to implement:** no dependencies on NLP models or document structure.
- **Fast and cheap:** purely procedural; zero inference cost.
- **Deterministic:** same document always produces identical chunks.

### 4.4 Limitations
- **Context-blind:** chunks may split sentences mid-word (if separator is a single character) or mid-thought.
- **No semantic coherence:** a chunk may contain fragments of multiple unrelated ideas, or divide a single logical unit across two chunks.
- **Retrieval quality suffers:** studies consistently show that pure fixed-size chunking underperforms structure-aware and semantic alternatives in retrieval tasks.

### 4.5 When to Use
- Prototyping and rapid experimentation.
- Corpora where documents are already uniformly short (e.g., tweets, product reviews).
- As a performance baseline for evaluating more sophisticated strategies.

---

## 5. Structure-Aware / Recursive Character Text Splitting

### 5.1 Description

This family of methods respects the **natural structural hierarchy** of documents: sections, paragraphs, sentences, and finally individual characters. When splitting, the algorithm attempts to break at the most meaningful structural boundary first, falling back to finer-grained boundaries only when necessary.

LangChain's `RecursiveCharacterTextSplitter` is the canonical implementation and is widely recommended as the **default starting point** for general-purpose RAG systems.

### 5.2 How It Works

The splitter is configured with a priority-ordered list of separators, e.g., for general text:

```
["\n\n", "\n", ". ", " ", ""]
```

Algorithm:
1. Try to split the text at the first separator (double-newline, i.e., paragraph breaks).
2. If the resulting chunks are within the `chunk_size` limit, keep them.
3. If any chunk is still too large, recursively split it using the next separator in the list (single newline, then sentence boundaries, then word boundaries).
4. Apply `chunk_overlap` between adjacent chunks to preserve cross-boundary context.

### 5.3 Language-Specific Variants

LangChain provides language-aware splitters that understand the structural conventions of specific document types and programming languages. These use bespoke separator hierarchies that respect syntax boundaries (function/class definitions, code blocks, headers).

| Language Splitter | Key Structural Boundaries | Use Case |
|-------------------|--------------------------|----------|
| `Language.MARKDOWN` | Headers (`#`, `##`), code fences, paragraphs | Documentation, blog posts, READMEs |
| `Language.PYTHON` | Function/class definitions, indentation blocks | Code analysis, code-QA |
| `Language.JS` | Functions, blocks, statements | Web application code |
| `Language.HTML` | Tags, sections | Web content |
| `Language.LATEX` | Sections, environments | Academic papers |

```python
from langchain_text_splitters import RecursiveCharacterTextSplitter, Language

# Markdown-aware splitting
splitter = RecursiveCharacterTextSplitter.from_language(
    language=Language.MARKDOWN,
    chunk_size=300,
    chunk_overlap=0
)
chunks = splitter.split_text(markdown_text)

# Python code-aware splitting
python_splitter = RecursiveCharacterTextSplitter.from_language(
    language=Language.PYTHON,
    chunk_size=300,
    chunk_overlap=0
)
```

### 5.4 Empirical Evidence

Recursive character splitting is one of the best-performing methods across multiple benchmarks:
- In a systematic evaluation of four chunking families on editorial content, **recursive chunking consistently outperformed** fixed-size, semantic, and LLM-based methods across all metrics.
- In a large-scale chemistry-domain study across 25 chunking configurations, **recursive token-based chunking (R100-0)** was the top performer, offering strong results with minimal resource overhead.
- The ChromaDB team's research evaluation found that recursive character splitting provides a strong baseline across diverse document types.

### 5.5 When to Use
- **Default recommendation for most production RAG systems.**
- Documents with clear structural hierarchy (reports, articles, manuals).
- When a balance of simplicity, speed, and retrieval quality is needed.
- As a strong baseline before experimenting with more complex methods.

---

## 6. Document-Structure-Specific Chunking

### 6.1 Description

For certain document types, custom chunking logic can exploit domain-specific structure that generic recursive splitting cannot. This approach tailors the chunking algorithm to the known format of the source documents.

### 6.2 Strategies by Document Type

| Document Type | Specialised Chunking Approach |
|---------------|-------------------------------|
| **PDFs with tables** | Preserve table headers with each chunk; store table context as metadata so tables can be reconstructed. |
| **HTML** | Split on `<section>`, `<header>`, `<article>` tags; preserve DOM hierarchy.
| **Markdown** | Split on `#` headers; treat code blocks as atomic units.
| **Legal documents** | Split on article/section/clause numbering; preserve citation chains.
| **Scientific papers** | Split on section headings (Abstract, Introduction, Methods, Results, Discussion); handle LaTeX math blocks atomically.
| **Dialog/Transcriptions** | Split on speaker turns; preserve multi-turn context.

### 6.3 Key Principle: Metadata Preservation

Regardless of the splitting method, attaching rich metadata to each chunk is critical: source filename, page number, section heading, document date, author, and any domain-specific taxonomy tags. This metadata enables **filtered retrieval** (e.g., "search only in 2024 reports") and **source citation** in the final answer.

---

## 7. Semantic Chunking

### 7.1 Description

Semantic chunking uses an **embedding model** to measure the semantic relatedness between consecutive sentences (or sentence-groups) and splits only where a significant drop in similarity is detected. This produces chunks that are *semantically coherent*—each chunk represents one "topic" or "idea unit."

The core insight: rather than splitting by arbitrary character counts, split where the *topic changes*. This yields variable-length chunks whose size adapts to the document's natural topic structure.

### 7.2 Algorithm (Standard Approach)

1. **Sentence segmentation.** Split the document into individual sentences.
2. **Sequential embedding.** Embed each sentence (or group of sentences) using a sentence-transformer model.
3. **Similarity computation.** Compute the cosine similarity between the embeddings of consecutive sentence-groups.
4. **Breakpoint detection.** Identify points where the similarity falls below a threshold (typically defined as a number of standard deviations below the mean similarity). These are the chunk boundaries.
5. **Chunk assembly.** Group sentences between breakpoints into chunks.

### 7.3 Implementation

In LangChain, semantic chunking is available through the `SemanticChunker` (in `langchain_experimental`):

```python
from langchain_experimental.text_splitter import SemanticChunker
from langchain_openai import OpenAIEmbeddings

semantic_splitter = SemanticChunker(
    embeddings=OpenAIEmbeddings(),
    breakpoint_threshold_type="percentile",  # or "standard_deviation", "interquartile"
    breakpoint_threshold_amount=0.7          # sensitivity
)
chunks = semantic_splitter.create_documents([text])
```

### 7.4 Semantic Chunking Variants

| Variant | Description |
|---------|-------------|
| **Sequential Semantic Chunking** | Keep sentences in original order; split at similarity drop points. Preserves document flow. |
| **Cluster Semantic Chunking** | Ignore original order; cluster all sentences by embedding similarity. Produces topically pure chunks but destroys narrative order. Suitable for FAQ-style corpora. |
| **Propositions-based (Dense X Retrieval)** | Decompose text into atomic, self-contained "propositions" (factual statements) and use these as retrieval units rather than raw text chunks. This is the finest granularity possible. |

### 7.5 Empirical Evidence

Semantic chunking's performance relative to recursive methods depends heavily on the domain and embedding model:

- In open-domain QA (Natural Questions), **sentence-based chunking matched semantic chunking** in quality up to ~5,000 tokens of context, suggesting that for general text, the additional cost of semantic chunking may not be justified.
- In domain-specific retrieval (DLR study across 7 arXiv domains), **sentence splitting with a 512-token window achieved the highest token-level IoU**, outperforming more complex semantic strategies.
- Semantic chunking excels when the document has **no clear structural markers** (e.g., plain text narratives, conversation transcripts) and when semantic topic boundaries are the only reliable splitting signal.

### 7.6 Cost Considerations

Semantic chunking requires running every sentence through an embedding model *during indexing*, which adds significant cost and latency compared to rule-based methods. The trade-off: higher indexing cost for potentially better retrieval coherence on unstructured documents.

---

## 8. Model-Based / Agentic Chunking

### 8.1 Description

Model-based chunking uses a **language model** (typically a smaller, instruction-tuned LLM) to make chunking decisions. The model reads the document and identifies semantically coherent segment boundaries based on content understanding, much like a human editor would. This is also called **agentic chunking**.

Unlike semantic chunking (which uses embedding similarity heuristics), agentic chunking leverages the LLM's deeper reasoning about topic shifts, narrative structure, and argument flow.

### 8.2 How It Works

The most common architecture follows a **split-then-merge** pattern:

1. **Mini-chunk creation.** First, split the document into sentence-level or small fixed-size "mini-chunks" with unique IDs. This ensures that no sentence is cut mid-way.
2. **LLM-guided grouping.** Pass the mini-chunks (with their IDs) to an LLM with a structured prompt instructing it to group consecutive mini-chunks into coherent sections. The prompt typically specifies:
   - What constitutes a good chunk (semantic coherence, appropriate length).
   - Maximum token limit per chunk.
   - The output format (e.g., a list of chunk-ID-ranges).
3. **Assembly.** Reconstruct the final chunks from the LLM's grouping instructions, attaching traceability metadata (which mini-chunks are in each final chunk).

### 8.3 Implementation Considerations

| Parameter | Recommendation |
|-----------|---------------|
| **Model choice** | A capable 7–8B instruction-tuned model is generally sufficient. Smaller models (1–3B) may produce unreliable chunking. Route chunking to a smaller model independently of the main agent. |
| **Prompt design** | Provide clear, specific instructions with hard constraints on chunk size and output structure. Include examples of good vs. bad chunking. |
| **Guardrails** | Implement hard caps on group size to prevent token overload. Maintain a deterministic fallback splitter for error cases. |
| **Cost** | Each chunking pass invokes the LLM, which is expensive at scale. Cache chunking results per document version to avoid redundant work. |

### 8.4 Leading Implementations

| Tool | Description |
|------|-------------|
| **LumberChunker** | Uses an LLM to iteratively identify content transition points in long-form narrative documents. Research paper with available implementation. |
| **Agno's AgenticChunking** | Supports custom prompts for domain-specific chunking logic; allows routing chunking to a smaller/cheaper model independently. |
| **LangChain + watsonx.ai** | Reference architecture combining recursive splitting with LLM-guided semantic grouping. |

### 8.5 When to Use
- **Long, complex narrative documents** where topic boundaries are subtle and not reflected in formatting (e.g., legal opinions, literary analysis, long-form journalism).
- **Documents where answers span multiple parts** of the text, and preserving narrative connections is critical.
- **High-stakes applications** where retrieval completeness is paramount and chunking cost is secondary.
- When iterative refinement is needed: LLM-based chunking enables "chain-of-thought" chunking with self-correction.

### 8.6 Caveats

- **Cost:** LLM-based chunking is orders of magnitude more expensive than rule-based methods.
- **Latency:** Indexing large corpora can take hours rather than seconds.
- **Non-determinism:** The same document may produce different chunks across runs (depending on sampling temperature).
- **Empirical performance:** Some studies find that LLM-based chunking does not consistently outperform recursive methods, particularly on structured documents.

---

## 9. Advanced & Emerging Strategies

### 9.1 Late Chunking (Jina AI)

Conventional chunking embeds each chunk independently. **Late chunking** defers the chunking step: first, the entire document is processed by the embedding model's transformer layers, producing token-level contextualised representations. *Then*, chunk boundaries are applied in the latent (embedding) space, and pooling is applied within each chunk to produce the final chunk embedding.

**Key advantage:** Each chunk embedding retains awareness of the full document context because the transformer's attention mechanism operated over the entire document before chunking. This addresses the "context loss" problem of traditional pre-embedding chunking.

**Cost:** Requires running the embedding model's transformer over the full document, which is memory-intensive for long documents. Mitigated by optimised implementations (e.g., Jina's v2/v3 embedding API).

### 9.2 Meta-Chunking (Multi-Resolution)

**Meta-chunking** indexes the same document at **multiple chunk granularities simultaneously** (e.g., small chunks of 100 tokens, medium of 300, large of 500). At retrieval time, the system can either:
- Select the chunk size dynamically based on the query.
- Aggregate results from multiple chunk sizes using fusion algorithms.

**AI21's multi-scale approach** demonstrated that indexing at multiple chunk sizes and aggregating results with Reciprocal Rank Fusion (RRF) improves retrieval by **1–37% across benchmarks**. This is a practical, model-free way to handle the fact that different queries need different chunk sizes.

### 9.3 Contextual Retrieval (Anthropic)

Anthropic's approach: enrich each chunk with **document-level context** before embedding. A small LLM prepends a concise summary of the full document to each chunk before it is embedded. This gives every chunk awareness of its broader context while maintaining the retrieval precision of small chunks.

### 9.4 Hierarchical / Recursive Retrieval

Rather than committing to a single chunk size, this strategy stores chunks at multiple levels of a document hierarchy (sentence → paragraph → section → chapter) and performs retrieval in a **coarse-to-fine** manner:
1. Retrieve at the most granular level.
2. Expand to parent chunks when context is needed.
3. Optionally, synthesise across retrieved chunks using agentic reasoning.

### 9.5 Late Interaction Retrieval (ColBERT-style)

Rather than embedding full chunks into single vectors, ColBERT-style models embed each token and perform late interaction between query tokens and chunk tokens at retrieval time. This provides token-level relevance matching within chunks, effectively decoupling chunk size from embedding compression loss.

---

## 10. Chunk Size and Overlap: What the Evidence Says

### 10.1 Chunk Size

Research consistently suggests that chunk size is **query-dependent**—there is no universally optimal value.

| Chunk Size (tokens) | Best For |
|---------------------|----------|
| **64–128** | Highly specific factoid QA (e.g., "What is the boiling point of water?"), dense X retrieval |
| **256–512** | General-purpose RAG; the most common production setting. Frequently cited as a good starting point. |
| **512–1024** | Queries requiring broader context (e.g., summarisation, multi-hop reasoning) |
| **1024+** | Long-context models; narrative understanding; legal/contract analysis |

**Key findings from systematic evaluations:**
- In an open-domain QA study, semantic quality **peaked at small contexts (~2,500 tokens)** while exact-match metrics improved with larger contexts, suggesting that the optimal context volume depends on the evaluation criterion.
- A chemistry-domain study found that **recursive token-based chunking (R100-0, i.e., 100 tokens, no overlap)** was the top performer among 25 configurations.
- Microsoft's Azure guidance recommends starting with **~512 tokens and small overlaps (~10%)** and tuning based on document type and query patterns.

### 10.2 Chunk Overlap

Overlap between adjacent chunks is intended to prevent information loss at chunk boundaries. However, recent empirical evidence challenges its value:

**The case against overlap:**
- A systematic study on Natural Questions found that **overlap provided no measurable benefit and increased indexing cost** (more chunks to embed and store).
- The ChromaDB research team's evaluation similarly questioned the default inclusion of significant overlap, finding that it rarely improves retrieval metrics enough to justify the overhead.

**The case for overlap:**
- In domain-specific technical documents (DLR study), **200-token overlap with a 512-token window achieved the highest token-level IoU** (Intersection over Union ≈ 0.099).
- Overlap is more valuable when chunk sizes are small relative to the semantic units in the document.

**Practical guidance:** Use minimal overlap (0–10% of chunk size) as a default. Consider larger overlap (up to 20–25%) only for corpora where information frequently spans chunk boundaries (e.g., highly technical content with interleaved definitions and explanations).

---

## 11. Chunking and the Embedding Model: A Joint Decision

The choice of embedding model is tightly coupled with chunking strategy. Key considerations:

1. **Embedding model's context limit.** Most sentence-transformers have a **maximum input length** (typically 512 tokens for `bge-small-en`, 8,192 for `text-embedding-3-large`). Chunks must stay within this limit, or they will be truncated, losing information.

2. **Embedding model's sweet spot.** Some models are optimised for short texts (e.g., `all-MiniLM-L6-v2` excels at sentence-level) while others handle longer passages well. Mismatched chunk size and embedding model degrade performance.

3. **Stability across domains.** The DLR study found that **smaller embedding models delivered more stable cross-domain performance** than larger models when paired with fixed-size chunking, suggesting that simpler embedding-chunking combinations are more robust.

4. **Retrieval-optimised embeddings.** Models like Nomic and Intfloat E5 variants substantially outperform domain-specialised models like SciBERT in RAG settings, even in domain-specific corpora. This finding holds across chunking strategies.

---

## 12. Chunking for Non-Text Content

### 12.1 Images and Media

For documents with embedded images:
- **Extract and describe:** Use a vision-capable model to generate a text description of each image, then chunk and embed the description alongside the surrounding text.
- **Multi-modal embedding:** Alternatively, use a multi-modal embedding model (e.g., CLIP) that can directly embed images without intermediate text descriptions. This approach is gaining ground as multi-modal LLMs mature.

**Cost note:** Generating image descriptions via LLMs is expensive. Microsoft's guidance recommends using a lightweight vision classifier (e.g., Azure AI Vision) to filter which images are worth processing before invoking an LLM for description generation.

### 12.2 Tables

Tables pose a unique challenge: their meaning depends on both cell values and the relationships encoded by headers and structure.

**Best practice:** Preserve table headers with each chunk and store structural metadata (column names, row labels) so that tables can be reconstructed or queried in a structured way during retrieval. Some systems convert tables to a structured text format (e.g., "Column: Year | Value: 2023 | Amount: $1.2M") before chunking.

### 12.3 Code

Code requires language-aware splitting that respects syntax boundaries (functions, classes, logical blocks). LangChain's `RecursiveCharacterTextSplitter` with language-specific settings handles this by using language-appropriate separators (function definitions, class boundaries, import blocks).

---

## 13. Decision Framework: Choosing a Chunking Strategy

The following decision tree synthesises the evidence into a practical selection guide:

```
┌──────────────────────────────────────────────────────────────┐
│  START: What type of documents are you indexing?             │
├──────────────────────────────────────────────────────────────┤
│  Highly structured (headers, sections, clear hierarchy)?     │
│    ├─ YES → Use RecursiveCharacterTextSplitter               │
│    │        (language-aware if Markdown/Code)                │
│    │        chunk_size: 256–512 tokens, overlap: 0–10%      │
│    │        → INTERNAL TEST: Measure recall@k on gold Q&A    │
│    │
│    └─ NO (flat narrative, no structural markers)?            │
│       ├─ Short (< 5K words per document)?                    │
│       │   └─ YES → Recursive split (sentence-level) is fine  │
│       │
│       └─ Long, complex?                                      │
│          ├─ Budget-constrained?                              │
│          │   └─ YES → Semantic Chunking                      │
│          │          (embedding-similarity-based)              │
│          │                                                   │
│          └─ High budget, high stakes?                        │
│              └─ YES → Agentic/LLM-based Chunking             │
│                      (+ fallback to recursive)               │
├──────────────────────────────────────────────────────────────┤
│  Consider hybrid: recursive as baseline; add semantic or     │
│  agentic chunking for critical document types only.          │
│                                                              │
│  Tune chunk size and overlap using a systematic evaluation   │
│  on your own queries (not just generic benchmarks).          │
│                                                              │
│  For production, monitor retrieval precision and LLM answer  │
│  quality after deployment; re-tune as queries evolve.         │
└──────────────────────────────────────────────────────────────┘
```

---

## 14. Evaluation: Measuring Chunking Quality

Evaluating chunking in isolation is difficult; its impact is indirect, mediated through retrieval and generation. The most robust approach is **end-to-end evaluation** on a representative query-answer dataset.

### 14.1 Key Metrics

| Metric | What It Measures | How to Compute |
|--------|-----------------|----------------|
| **Recall@k** | Fraction of queries where the correct chunk appears in the top-k retrieved results | Requires gold-labeled (query, relevant_chunk) pairs |
| **Token-level IoU** | Overlap between tokens in retrieved chunks and tokens in the gold reference passage | Intersection over Union in token space |
| **Document Localization** | Whether the retrieved chunk belongs to the correct source document | Binary accuracy of document identification |
| **Exact Match (EM)** | Whether the LLM's final answer exactly matches the ground truth | String comparison; sensitive to phrasing |
| **Semantic Similarity** | Semantic closeness of generated answer to reference answer | Cosine similarity of answer embeddings |
| **Hallucination Rate** | Frequency of generated statements not supported by the retrieved context | Human or LLM-as-judge evaluation |

### 14.2 Practical Evaluation Protocol

1. **Build a gold Q&A dataset:** Curate 50–200+ query-answer pairs representative of expected user queries. Document which chunks should be retrieved for each query.
2. **Run retrieval sweeps:** Vary chunking strategy, chunk size, overlap, and top-k. Measure retrieval metrics.
3. **Run generation sweeps:** For the best-performing retrieval configurations, run end-to-end generation and evaluate answer quality metrics.
4. **Statistical significance:** Ensure observed differences are statistically meaningful (many chunking comparisons in the literature report overlapping confidence intervals).

---

## 15. Summary

**Chunking is the foundational preprocessing step in RAG** that determines the granularity and semantic coherence of the retrieval units stored in the vector database. The choice of chunking strategy directly shapes retrieval precision, context completeness, indexing cost, and ultimately the quality of LLM-generated answers.

**Key takeaways:**

1. **There is no universal "best" chunking strategy.** The optimal choice depends on document structure, query patterns, embedding model, and budget constraints.

2. **Recursive character text splitting** (with language-aware settings for structured formats) is the **strongest default**—it consistently outperforms or matches more complex methods across benchmarks while remaining simple, fast, and deterministic. Start here.

3. **Chunk size is query-dependent.** Fixed-size chunks represent a compromise. Multi-scale indexing (storing multiple chunk granularities) or adaptive retrieval can address this limitation without requiring upfront commitment to a single size.

4. **Overlap provides marginal benefit at best** for most use cases. Start with 0–10% overlap; increase only if evaluation shows boundary-loss issues.

5. **Semantic chunking** (embedding-similarity-based splitting) is valuable for **unstructured narrative text** where structural boundaries are absent, but its additional indexing cost must be weighed against empirical retrieval improvement.

6. **Agentic/LLM-based chunking** offers the most nuanced, context-aware segmentation but is expensive and non-deterministic. Reserve it for high-stakes, complex documents where structural and semantic methods fall short.

7. **Always evaluate on your own data.** Generic benchmarks provide directional guidance, but chunking performance is highly sensitive to the specific document corpus and query distribution. A small, targeted evaluation on gold Q&A data is worth more than any general recommendation.

8. **Chunking is tightly coupled with the embedding model and retrieval strategy.** Think of (chunking × embedding × retrieval × generation) as an integrated pipeline to be co-optimised, not as independent decisions.

---
