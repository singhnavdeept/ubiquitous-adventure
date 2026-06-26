# LlamaIndex — Complete Guide for Multi-Agent Systems with Ollama

> **Stack context:** This guide is written for a system using **LlamaIndex + LangChain + CrewAI** with **Ollama** as the local LLM backend. Every concept is explained from raw data ingestion all the way to multi-agent orchestration.

---

## Table of Contents

1. [What is LlamaIndex?](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#1-what-is-llamaindex)
2. [Installation & Project Setup](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#2-installation--project-setup)
3. [Connecting Ollama (Local LLM)](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#3-connecting-ollama-local-llm)
4. [Data Ingestion — Fetching Raw Data](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#4-data-ingestion--fetching-raw-data)
5. [Documents & Nodes — The Data Model](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#5-documents--nodes--the-data-model)
6. [Transformations & Chunking](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#6-transformations--chunking)
7. [Embeddings](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#7-embeddings)
8. [Indexes — Storing & Structuring Data](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#8-indexes--storing--structuring-data)
9. [Storage — Persisting Everything](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#9-storage--persisting-everything)
10. [Retrievers — Searching the Index](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#10-retrievers--searching-the-index)
11. [Query Engines — Full Q&A Pipeline](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#11-query-engines--full-qa-pipeline)
12. [Chat Engines — Conversational Memory](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#12-chat-engines--conversational-memory)
13. [Response Synthesis](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#13-response-synthesis)
14. [RAG Pipeline — End-to-End](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#14-rag-pipeline--end-to-end)
15. [Tools — Giving Agents Capabilities](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#15-tools--giving-agents-capabilities)
16. [LlamaIndex Agents](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#16-llamaindex-agents)
17. [Multi-Agent Systems with LlamaIndex](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#17-multi-agent-systems-with-llamaindex)
18. [Integrating with CrewAI](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#18-integrating-with-crewai)
19. [Integrating with LangChain](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#19-integrating-with-langchain)
20. [Observability & Debugging](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#20-observability--debugging)
21. [Full Multi-Agent Project Structure](https://claude.ai/chat/85c6027d-c3cc-4e4d-8d06-b9971a7364c1#21-full-multi-agent-project-structure)

---

## 1. What is LlamaIndex?

LlamaIndex is a **data framework for LLM applications**. Its job is to bridge the gap between your raw data (PDFs, databases, websites, APIs, code, etc.) and your LLM, so the LLM can reason over that data intelligently.

In a multi-agent system, LlamaIndex handles the **data layer**:

```
Raw Data Sources
      │
      ▼
  LlamaIndex
  ┌─────────────────────────────────┐
  │  Ingest → Chunk → Embed → Store │  ← Data pipeline
  │  Retrieve → Synthesize → Answer │  ← Query pipeline
  │  Tools → Agents → Orchestrate   │  ← Agent layer
  └─────────────────────────────────┘
      │
      ▼
  Your LLM (Ollama)
```

**Core pillars:**

|Pillar|What it does|
|---|---|
|**Data Connectors**|Load data from any source (files, APIs, DBs, web)|
|**Indexes**|Structure data for fast retrieval|
|**Query Engines**|Answer questions over indexed data|
|**Agents**|LLM-powered reasoning loops that use tools|
|**Pipelines**|Chain all steps into workflows|

---

## 2. Installation & Project Setup

### Install core packages

```bash
# Core LlamaIndex
pip install llama-index

# Ollama integration
pip install llama-index-llms-ollama
pip install llama-index-embeddings-ollama

# Common data loaders
pip install llama-index-readers-file          # PDF, DOCX, CSV, etc.
pip install llama-index-readers-web           # Web scraping
pip install llama-index-readers-database      # SQL databases

# Vector stores (pick one)
pip install llama-index-vector-stores-chroma  # ChromaDB (recommended for local)
pip install llama-index-vector-stores-faiss   # FAISS

# For multi-agent
pip install llama-index-agent-openai          # ReAct agent base
pip install crewai
pip install langchain langchain-community
```

### Project structure

```
my_multiagent_project/
├── data/                    # Raw input files
│   ├── pdfs/
│   ├── csvs/
│   └── web_cache/
├── storage/                 # Persisted indexes
│   ├── chroma_db/
│   └── index_store/
├── agents/                  # Agent definitions
│   ├── research_agent.py
│   ├── analysis_agent.py
│   └── writer_agent.py
├── tools/                   # LlamaIndex tools
│   ├── search_tool.py
│   └── db_tool.py
├── pipelines/               # Data pipelines
│   └── ingest_pipeline.py
├── config.py                # LLM + embedding settings
└── main.py                  # Entry point
```

---

## 3. Connecting Ollama (Local LLM)

### Start Ollama first

```bash
# Pull a model (do this before running any code)
ollama pull llama3
ollama pull nomic-embed-text   # For embeddings

# Verify it's running
ollama list
```

### Configure LlamaIndex to use Ollama

```python
# config.py
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core import Settings

# --- LLM ---
llm = Ollama(
    model="llama3",          # or "mistral", "phi3", "gemma", etc.
    base_url="http://localhost:11434",
    request_timeout=300.0,   # Increase for slow hardware
    temperature=0.1,         # Low = more deterministic (good for agents)
    context_window=8192,
)

# --- Embeddings ---
embed_model = OllamaEmbedding(
    model_name="nomic-embed-text",
    base_url="http://localhost:11434",
    ollama_additional_kwargs={"mirostat": 0},
)

# --- Set globally (applies to ALL LlamaIndex operations) ---
Settings.llm = llm
Settings.embed_model = embed_model
Settings.chunk_size = 512        # Tokens per chunk
Settings.chunk_overlap = 50      # Overlap between chunks
```

> **Important:** Once you set `Settings.llm` and `Settings.embed_model`, every index, query engine, and agent you create will use them automatically. You don't need to pass them every time.

---

## 4. Data Ingestion — Fetching Raw Data

This is where everything starts. LlamaIndex has **connectors (Readers)** for almost every data source.

### 4.1 Load from local files

```python
from llama_index.core import SimpleDirectoryReader

# Load all files in a directory (PDF, TXT, DOCX, CSV, MD, HTML...)
documents = SimpleDirectoryReader(
    input_dir="./data/",
    recursive=True,               # Include subdirectories
    required_exts=[".pdf", ".txt", ".md"],   # Filter by extension
    filename_as_id=True,          # Use filename as document ID
).load_data()

print(f"Loaded {len(documents)} documents")
```

### 4.2 Load a specific PDF

```python
from llama_index.readers.file import PDFReader

reader = PDFReader()
documents = reader.load_data(file="./data/report.pdf")
```

### 4.3 Load from a website / URL

```python
from llama_index.readers.web import SimpleWebPageReader

# Single or multiple URLs
documents = SimpleWebPageReader(html_to_text=True).load_data(
    urls=[
        "https://example.com/article1",
        "https://example.com/article2",
    ]
)
```

### 4.4 Load from a database (SQL)

```python
from llama_index.readers.database import DatabaseReader

reader = DatabaseReader(
    uri="postgresql://user:pass@localhost:5432/mydb"
    # or: "sqlite:///./mydb.sqlite"
)

# Convert SQL query results into documents
documents = reader.load_data(
    query="SELECT title, content, date FROM articles WHERE status = 'published'"
)
```

### 4.5 Load from CSV / Excel

```python
from llama_index.readers.file import CSVReader, PandasCSVReader

# Each row becomes a Document
reader = PandasCSVReader(concat_rows=False)
documents = reader.load_data(file="./data/products.csv")
```

### 4.6 Load from Wikipedia

```python
from llama_index.readers.wikipedia import WikipediaReader

reader = WikipediaReader()
documents = reader.load_data(
    pages=["Artificial intelligence", "Machine learning", "LlamaIndex"]
)
```

### 4.7 Load from custom API / JSON

```python
from llama_index.core import Document

# Manually create documents from any source (API response, custom DB, etc.)
import requests

response = requests.get("https://api.example.com/articles")
articles = response.json()

documents = [
    Document(
        text=article["content"],
        metadata={
            "title": article["title"],
            "author": article["author"],
            "date": article["published_at"],
            "source": "my_api",
        }
    )
    for article in articles
]
```

---

## 5. Documents & Nodes — The Data Model

Understanding how LlamaIndex represents data is critical.

### Documents

A `Document` is raw loaded data — one file, one webpage, one DB row. It has:

```python
from llama_index.core import Document

doc = Document(
    text="This is the full text content of the document...",
    metadata={
        "filename": "report.pdf",
        "page": 1,
        "source": "internal",
        "category": "finance",
    },
    doc_id="unique-id-001",       # Optional: custom ID
    excluded_llm_metadata_keys=["filename"],    # Don't send these to LLM
    excluded_embed_metadata_keys=["page"],      # Don't embed these
)

print(doc.text)
print(doc.metadata)
print(doc.doc_id)
```

### Nodes

A `Node` is a **chunk** of a Document after it has been split. It is the actual unit stored in the index.

```python
from llama_index.core.schema import TextNode, NodeRelationship, RelatedNodeInfo

# Nodes are usually created automatically by the pipeline
# But you can create them manually:
node = TextNode(
    text="This is a chunk of text from the document...",
    metadata={"source": "report.pdf", "page": 2},
    node_id="node-001",
)

# Nodes track relationships (previous/next chunk, parent document)
print(node.node_id)
print(node.metadata)
print(node.relationships)   # Links to parent Document, prev/next Node
```

**Document → Nodes flow:**

```
Document (full file)
    │
    ▼  [Splitter]
Node 1 (chunk 1) ←→ Node 2 (chunk 2) ←→ Node 3 (chunk 3)
    │                    │                    │
    └────────────────────┴────────────────────┘
             All linked back to parent Document
```

---

## 6. Transformations & Chunking

Before nodes go into an index, they go through a **transformation pipeline** that splits, cleans, and enriches them.

### 6.1 Text Splitters

```python
from llama_index.core.node_parser import (
    SentenceSplitter,       # Split by sentence boundaries (most common)
    TokenTextSplitter,      # Split by token count
    SemanticSplitterNodeParser,  # Split by semantic similarity (best quality)
    MarkdownNodeParser,     # Split Markdown by headings
    CodeSplitter,           # Split code by function/class
)

# Sentence splitter (recommended default)
splitter = SentenceSplitter(
    chunk_size=512,         # Max tokens per chunk
    chunk_overlap=50,       # Overlap to maintain context
)

nodes = splitter.get_nodes_from_documents(documents)
print(f"Created {len(nodes)} nodes from {len(documents)} documents")
```

### 6.2 Semantic Splitter (best for RAG quality)

```python
from llama_index.core.node_parser import SemanticSplitterNodeParser

# Splits at natural semantic boundaries using embeddings
splitter = SemanticSplitterNodeParser(
    buffer_size=1,
    breakpoint_percentile_threshold=95,
    embed_model=Settings.embed_model,
)

nodes = splitter.get_nodes_from_documents(documents)
```

### 6.3 Metadata Extractors (enrich nodes automatically)

```python
from llama_index.core.extractors import (
    TitleExtractor,          # Extract/infer a title for each chunk
    QuestionsAnsweredExtractor,  # Generate questions this chunk answers
    SummaryExtractor,        # Add a summary to each chunk's metadata
    KeywordExtractor,        # Extract keywords
)
from llama_index.core.ingestion import IngestionPipeline

pipeline = IngestionPipeline(
    transformations=[
        SentenceSplitter(chunk_size=512, chunk_overlap=50),
        TitleExtractor(nodes=5),              # Uses LLM
        QuestionsAnsweredExtractor(questions=3),  # Uses LLM
        KeywordExtractor(keywords=10),        # Uses LLM
        Settings.embed_model,                 # Embed each node
    ]
)

nodes = pipeline.run(documents=documents)

# Now each node has rich metadata like:
# node.metadata["questions_this_excerpt_can_answer"] = "What is ...?"
# node.metadata["excerpt_keywords"] = "AI, agents, LlamaIndex"
```

---

## 7. Embeddings

Embeddings are vector representations of text that capture semantic meaning. They power similarity search.

### How it works

```
Text: "How do agents work?"
         │
         ▼  [Embedding Model (nomic-embed-text)]
Vector: [0.021, -0.134, 0.872, ..., 0.003]  (768 dimensions)
```

Two semantically similar texts → similar vectors → close in vector space.

### Using embeddings in LlamaIndex

```python
from llama_index.embeddings.ollama import OllamaEmbedding

embed_model = OllamaEmbedding(
    model_name="nomic-embed-text",
    base_url="http://localhost:11434",
)

# Embed a single string
vector = embed_model.get_text_embedding("How do multi-agents work?")
print(f"Embedding dimension: {len(vector)}")  # e.g., 768

# Embed multiple strings (batch)
vectors = embed_model.get_text_embedding_batch([
    "LlamaIndex is a data framework",
    "Ollama runs models locally",
    "CrewAI orchestrates agents",
])
```

> You almost never call embed functions directly. LlamaIndex calls them automatically when you build an index or run a query. Just set `Settings.embed_model` and forget about it.

---

## 8. Indexes — Storing & Structuring Data

An **Index** is the core data structure. It stores your nodes and enables retrieval.

### 8.1 VectorStoreIndex (most common — for RAG)

Stores embeddings. Retrieval = find nodes whose vectors are closest to the query vector.

```python
from llama_index.core import VectorStoreIndex

# Build index from documents (splits → embeds → stores automatically)
index = VectorStoreIndex.from_documents(
    documents,
    show_progress=True,
)

# Build from pre-processed nodes
index = VectorStoreIndex(nodes)
```

### 8.2 SummaryIndex (for summarization tasks)

Stores all nodes sequentially. Good for "summarize this entire document" queries.

```python
from llama_index.core import SummaryIndex

index = SummaryIndex.from_documents(documents)
```

### 8.3 KeywordTableIndex (keyword-based retrieval)

Uses BM25-style keyword matching. No embeddings needed.

```python
from llama_index.core import KeywordTableIndex

index = KeywordTableIndex.from_documents(documents)
```

### 8.4 KnowledgeGraphIndex (for relational data)

Extracts entity-relationship triplets and builds a graph.

```python
from llama_index.core import KnowledgeGraphIndex

index = KnowledgeGraphIndex.from_documents(
    documents,
    max_triplets_per_chunk=5,
)
```

### 8.5 Using ChromaDB as vector store (persistent)

```python
import chromadb
from llama_index.vector_stores.chroma import ChromaVectorStore
from llama_index.core import VectorStoreIndex, StorageContext

# Create ChromaDB client (persistent on disk)
chroma_client = chromadb.PersistentClient(path="./storage/chroma_db")
chroma_collection = chroma_client.get_or_create_collection("my_data")

# Wrap in LlamaIndex vector store
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
storage_context = StorageContext.from_defaults(vector_store=vector_store)

# Build index backed by ChromaDB
index = VectorStoreIndex.from_documents(
    documents,
    storage_context=storage_context,
    show_progress=True,
)
```

---

## 9. Storage — Persisting Everything

Without persistence, you re-embed all your data every restart (slow and wasteful). LlamaIndex has a full storage system.

### What gets stored

|Store|What it holds|
|---|---|
|`VectorStore`|Embedding vectors for each node|
|`DocStore`|Full node text and metadata|
|`IndexStore`|Index structure and metadata|
|`KeyValueStore`|Arbitrary key-value data|

### Save index to disk

```python
from llama_index.core import VectorStoreIndex, StorageContext

# Build the index
index = VectorStoreIndex.from_documents(documents)

# Persist to disk
index.storage_context.persist(persist_dir="./storage/index_store")
print("Index saved!")
```

### Load index from disk (skip re-embedding)

```python
from llama_index.core import StorageContext, load_index_from_storage

# Load from disk (fast — no re-embedding)
storage_context = StorageContext.from_defaults(
    persist_dir="./storage/index_store"
)
index = load_index_from_storage(storage_context)
print("Index loaded from disk!")
```

### Smart load: build if not exists, load if exists

```python
import os
from llama_index.core import (
    VectorStoreIndex, StorageContext, load_index_from_storage, SimpleDirectoryReader
)

PERSIST_DIR = "./storage/index_store"

if not os.path.exists(PERSIST_DIR):
    # First run: build and save
    print("Building index for the first time...")
    documents = SimpleDirectoryReader("./data").load_data()
    index = VectorStoreIndex.from_documents(documents)
    index.storage_context.persist(persist_dir=PERSIST_DIR)
else:
    # Subsequent runs: load from disk
    print("Loading index from disk...")
    storage_context = StorageContext.from_defaults(persist_dir=PERSIST_DIR)
    index = load_index_from_storage(storage_context)
```

---

## 10. Retrievers — Searching the Index

A **Retriever** is the search engine of LlamaIndex. It finds relevant nodes given a query.

### 10.1 Default vector retriever

```python
# Get retriever from index
retriever = index.as_retriever(similarity_top_k=5)  # Return top 5 nodes

# Search
query = "How do multi-agent systems work?"
nodes = retriever.retrieve(query)

for node in nodes:
    print(f"Score: {node.score:.4f}")
    print(f"Text:  {node.node.text[:200]}")
    print(f"Meta:  {node.node.metadata}")
    print("---")
```

### 10.2 BM25 Retriever (keyword-based, no embeddings)

```python
from llama_index.retrievers.bm25 import BM25Retriever

bm25_retriever = BM25Retriever.from_defaults(
    nodes=nodes,       # All your nodes
    similarity_top_k=5,
)

results = bm25_retriever.retrieve("agent tools llamaindex")
```

### 10.3 Hybrid Retriever (vector + BM25 — best quality)

```python
from llama_index.core.retrievers import QueryFusionRetriever

hybrid_retriever = QueryFusionRetriever(
    retrievers=[
        index.as_retriever(similarity_top_k=5),   # Vector search
        bm25_retriever,                            # Keyword search
    ],
    similarity_top_k=5,
    num_queries=4,          # Generates 4 query variations for better recall
    mode="reciprocal_rerank",
    use_async=True,
)

nodes = hybrid_retriever.retrieve("how do agents use tools?")
```

### 10.4 Auto-Merging Retriever (hierarchical)

Retrieves child chunks but returns parent chunks for more context.

```python
from llama_index.core.node_parser import HierarchicalNodeParser
from llama_index.core.retrievers import AutoMergingRetriever

# Parse into hierarchy: large chunks → medium → small
node_parser = HierarchicalNodeParser.from_defaults(
    chunk_sizes=[2048, 512, 128]  # parent → middle → child
)
all_nodes = node_parser.get_nodes_from_documents(documents)

# Build index with all nodes
storage_context = StorageContext.from_defaults()
storage_context.docstore.add_documents(all_nodes)
index = VectorStoreIndex(
    nodes=[n for n in all_nodes if isinstance(n, IndexNode)],
    storage_context=storage_context,
)

# Auto-merging retriever: retrieves small nodes but returns parent context
base_retriever = index.as_retriever(similarity_top_k=6)
retriever = AutoMergingRetriever(
    base_retriever,
    storage_context=storage_context,
    verbose=True,
)
```

### 10.5 Metadata Filters (filter before vector search)

```python
from llama_index.core.vector_stores import MetadataFilter, MetadataFilters, FilterOperator

# Only search documents from a specific source or category
filters = MetadataFilters(
    filters=[
        MetadataFilter(key="source", value="internal", operator=FilterOperator.EQ),
        MetadataFilter(key="category", value="finance", operator=FilterOperator.EQ),
    ]
)

retriever = index.as_retriever(
    similarity_top_k=5,
    filters=filters,
)
```

---

## 11. Query Engines — Full Q&A Pipeline

A **Query Engine** combines the retriever + LLM into a single interface. You give it a question, it gives you an answer.

### 11.1 Basic query engine

```python
# Build query engine from index
query_engine = index.as_query_engine(
    similarity_top_k=5,
    streaming=False,
)

response = query_engine.query("What are the main advantages of multi-agent systems?")

print(response.response)              # The answer text
print(response.source_nodes)          # Which nodes were used
for node in response.source_nodes:
    print(f"  Source: {node.node.metadata.get('filename', 'unknown')}")
    print(f"  Score:  {node.score:.4f}")
```

### 11.2 Sub-question query engine (complex multi-part questions)

```python
from llama_index.core.query_engine import SubQuestionQueryEngine
from llama_index.core.tools import QueryEngineTool

# Wrap multiple indexes as tools
tools = [
    QueryEngineTool.from_defaults(
        query_engine=finance_index.as_query_engine(),
        name="finance_data",
        description="Financial reports and revenue data",
    ),
    QueryEngineTool.from_defaults(
        query_engine=product_index.as_query_engine(),
        name="product_data",
        description="Product documentation and feature specs",
    ),
]

# This engine breaks complex questions into sub-questions automatically
query_engine = SubQuestionQueryEngine.from_defaults(
    query_engine_tools=tools,
    verbose=True,
)

response = query_engine.query(
    "Compare the revenue growth with product launch dates and identify correlation"
)
```

### 11.3 RouterQueryEngine (routes to the right index)

```python
from llama_index.core.query_engine import RouterQueryEngine
from llama_index.core.selectors import LLMSingleSelector

router_engine = RouterQueryEngine(
    selector=LLMSingleSelector.from_defaults(),
    query_engine_tools=tools,   # Same tools from above
    verbose=True,
)

# LLM decides which tool to use based on the question
response = router_engine.query("What are our Q3 revenue numbers?")
# → Automatically routes to finance_data tool
```

---

## 12. Chat Engines — Conversational Memory

Chat engines maintain conversation history so users can ask follow-up questions.

```python
from llama_index.core.memory import ChatMemoryBuffer

# Create chat engine with memory
chat_engine = index.as_chat_engine(
    chat_mode="condense_plus_context",  # Best mode for RAG + memory
    memory=ChatMemoryBuffer.from_defaults(token_limit=4000),
    verbose=True,
)

# Conversation loop
response1 = chat_engine.chat("What is LlamaIndex?")
print(response1.response)

response2 = chat_engine.chat("How does it handle multi-agent systems?")
# The "it" refers to LlamaIndex — engine knows from context
print(response2.response)

response3 = chat_engine.chat("Can you summarize what we discussed?")
print(response3.response)

# Reset memory if needed
chat_engine.reset()
```

**Chat modes:**

|Mode|Description|
|---|---|
|`best`|Automatically picks best mode|
|`condense_question`|Condenses chat history into a single question, then retrieves|
|`context`|Retrieves context first, then responds|
|`condense_plus_context`|Condenses history + retrieves context (recommended)|
|`simple`|No retrieval, just LLM with memory|
|`react`|ReAct agent with memory|

---

## 13. Response Synthesis

After retrieval, a **Response Synthesizer** combines the retrieved nodes with the query to generate the final answer.

```python
from llama_index.core.response_synthesizers import (
    ResponseMode,
    get_response_synthesizer,
)

synthesizer = get_response_synthesizer(
    response_mode=ResponseMode.TREE_SUMMARIZE,  # See modes below
    verbose=True,
)

query_engine = RetrieverQueryEngine(
    retriever=retriever,
    response_synthesizer=synthesizer,
)
```

**Response modes:**

|Mode|When to use|
|---|---|
|`REFINE`|Iteratively refines answer through each node (slow, thorough)|
|`COMPACT`|Packs as many nodes as possible per LLM call (fast, default)|
|`TREE_SUMMARIZE`|Builds a tree of summaries (best for large docs)|
|`SIMPLE_SUMMARIZE`|Single LLM call with all nodes truncated|
|`ACCUMULATE`|Queries each node separately, accumulates results|
|`NO_TEXT`|Returns nodes only, no LLM call|

---

## 14. RAG Pipeline — End-to-End

This is the full production RAG pipeline putting everything together.

```python
# rag_pipeline.py
import os
from llama_index.core import (
    VectorStoreIndex, SimpleDirectoryReader,
    StorageContext, load_index_from_storage, Settings
)
from llama_index.core.ingestion import IngestionPipeline
from llama_index.core.node_parser import SentenceSplitter
from llama_index.core.extractors import TitleExtractor, KeywordExtractor
from llama_index.core.retrievers import QueryFusionRetriever
from llama_index.retrievers.bm25 import BM25Retriever
from llama_index.core.query_engine import RetrieverQueryEngine
from llama_index.core.response_synthesizers import get_response_synthesizer, ResponseMode
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
import chromadb
from llama_index.vector_stores.chroma import ChromaVectorStore

PERSIST_DIR = "./storage"

# ── Step 1: Configure LLM & Embeddings ─────────────────────────────────────
Settings.llm = Ollama(model="llama3", request_timeout=300.0, temperature=0.1)
Settings.embed_model = OllamaEmbedding(model_name="nomic-embed-text")
Settings.chunk_size = 512
Settings.chunk_overlap = 50

# ── Step 2: Load Raw Data ───────────────────────────────────────────────────
def load_documents():
    return SimpleDirectoryReader("./data", recursive=True).load_data()

# ── Step 3: Process & Embed ─────────────────────────────────────────────────
def run_ingestion_pipeline(documents):
    pipeline = IngestionPipeline(
        transformations=[
            SentenceSplitter(chunk_size=512, chunk_overlap=50),
            TitleExtractor(nodes=5),
            KeywordExtractor(keywords=8),
            Settings.embed_model,
        ]
    )
    return pipeline.run(documents=documents, show_progress=True)

# ── Step 4: Build or Load Index ─────────────────────────────────────────────
def get_index():
    chroma_client = chromadb.PersistentClient(path=f"{PERSIST_DIR}/chroma")
    collection = chroma_client.get_or_create_collection("rag_store")
    vector_store = ChromaVectorStore(chroma_collection=collection)

    if os.path.exists(f"{PERSIST_DIR}/index"):
        print("Loading existing index...")
        storage_context = StorageContext.from_defaults(
            persist_dir=f"{PERSIST_DIR}/index",
            vector_store=vector_store,
        )
        return load_index_from_storage(storage_context)
    else:
        print("Building new index...")
        documents = load_documents()
        nodes = run_ingestion_pipeline(documents)
        storage_context = StorageContext.from_defaults(vector_store=vector_store)
        index = VectorStoreIndex(nodes, storage_context=storage_context)
        index.storage_context.persist(persist_dir=f"{PERSIST_DIR}/index")
        return index

# ── Step 5: Build Hybrid Retriever ──────────────────────────────────────────
def get_retriever(index, nodes):
    vector_retriever = index.as_retriever(similarity_top_k=5)
    bm25_retriever = BM25Retriever.from_defaults(nodes=nodes, similarity_top_k=5)

    return QueryFusionRetriever(
        retrievers=[vector_retriever, bm25_retriever],
        similarity_top_k=5,
        num_queries=3,
        mode="reciprocal_rerank",
    )

# ── Step 6: Build Query Engine ──────────────────────────────────────────────
def get_query_engine(retriever):
    synthesizer = get_response_synthesizer(response_mode=ResponseMode.TREE_SUMMARIZE)
    return RetrieverQueryEngine(retriever=retriever, response_synthesizer=synthesizer)

# ── Usage ───────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    index = get_index()
    query_engine = index.as_query_engine(similarity_top_k=5)

    response = query_engine.query("Summarize the main findings in the documents")
    print(response.response)
```

---

## 15. Tools — Giving Agents Capabilities

Tools are what agents use to take actions. LlamaIndex has several tool types.

### 15.1 QueryEngineTool (search a knowledge base)

```python
from llama_index.core.tools import QueryEngineTool, ToolMetadata

search_tool = QueryEngineTool(
    query_engine=query_engine,
    metadata=ToolMetadata(
        name="knowledge_base_search",
        description=(
            "Search the internal knowledge base for information about "
            "company products, policies, and technical documentation. "
            "Use this when you need factual information from our data."
        ),
    ),
)
```

### 15.2 FunctionTool (any Python function)

```python
from llama_index.core.tools import FunctionTool
import requests

def search_web(query: str) -> str:
    """Search the web for current information."""
    # Your web search implementation
    response = requests.get(f"https://api.duckduckgo.com/?q={query}&format=json")
    results = response.json()
    return str(results.get("AbstractText", "No results found"))

def calculate(expression: str) -> str:
    """Evaluate a mathematical expression. Input should be a valid Python math expression."""
    try:
        result = eval(expression)  # Use a safe eval in production
        return str(result)
    except Exception as e:
        return f"Error: {e}"

def get_current_date() -> str:
    """Get the current date and time."""
    from datetime import datetime
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# Wrap Python functions as tools
web_tool = FunctionTool.from_defaults(fn=search_web)
calc_tool = FunctionTool.from_defaults(fn=calculate)
date_tool = FunctionTool.from_defaults(fn=get_current_date)
```

### 15.3 Tool from index (shortcut)

```python
# Combine into a list for your agent
all_tools = [search_tool, web_tool, calc_tool, date_tool]
```

---

## 16. LlamaIndex Agents

Agents in LlamaIndex are **reasoning loops** — the LLM decides which tools to use, uses them, observes results, and repeats until it has a final answer.

### 16.1 ReAct Agent

ReAct = **Re**asoning + **Act**ing. The LLM alternates between thinking and tool calls.

```python
from llama_index.core.agent import ReActAgent

agent = ReActAgent.from_tools(
    tools=all_tools,
    llm=Settings.llm,
    verbose=True,          # Print reasoning steps
    max_iterations=10,     # Safety limit
    context="""
    You are a research assistant with access to a knowledge base and web search.
    Always search the knowledge base first before searching the web.
    Provide detailed, accurate answers with sources.
    """,
)

response = agent.chat("What are the Q3 financial results and how do they compare to last year?")
print(response.response)
```

**What ReAct looks like internally:**

```
User: "What are the Q3 results?"
  │
  ├─ Thought: I need to search the knowledge base for Q3 financial data
  ├─ Action: knowledge_base_search("Q3 financial results")
  ├─ Observation: [retrieved nodes with Q3 data]
  │
  ├─ Thought: I have Q3 data. Now I need last year's data to compare
  ├─ Action: knowledge_base_search("Q2 last year financial results")
  ├─ Observation: [retrieved nodes with previous year data]
  │
  ├─ Thought: I have all the data needed. I can now write the answer.
  └─ Final Answer: "Q3 revenue was $X, up Y% from last year..."
```

### 16.2 Function Calling Agent (faster, more reliable)

```python
from llama_index.core.agent import FunctionCallingAgent

agent = FunctionCallingAgent.from_tools(
    tools=all_tools,
    llm=Settings.llm,
    verbose=True,
    allow_parallel_tool_calls=True,  # Run multiple tools simultaneously
)
```

### 16.3 Agent with memory (multi-turn)

```python
from llama_index.core.memory import ChatMemoryBuffer

memory = ChatMemoryBuffer.from_defaults(token_limit=6000)

agent = ReActAgent.from_tools(
    tools=all_tools,
    llm=Settings.llm,
    memory=memory,
    verbose=True,
)

# Multi-turn conversation
r1 = agent.chat("Search for information about our product roadmap")
r2 = agent.chat("Now compare that to what competitors are doing")
r3 = agent.chat("Based on this, what should our priorities be?")
```

### 16.4 Agent with custom system prompt

```python
from llama_index.core.agent import ReActAgent
from llama_index.core.llms import ChatMessage, MessageRole

system_prompt = """
You are a senior data analyst agent specialized in business intelligence.

Your capabilities:
- Search internal knowledge bases for company data
- Search the web for market information
- Calculate and analyze numerical data

Your behavior:
- Always cite your sources
- Be precise with numbers
- If data is missing, say so explicitly
- Structure your answers clearly
"""

agent = ReActAgent.from_tools(
    tools=all_tools,
    llm=Settings.llm,
    verbose=True,
    system_prompt=system_prompt,
)
```

---

## 17. Multi-Agent Systems with LlamaIndex

LlamaIndex supports hierarchical multi-agent systems where agents can call other agents as tools.

### 17.1 Agent-as-Tool pattern

```python
from llama_index.core.agent import ReActAgent
from llama_index.core.tools import FunctionTool, QueryEngineTool

# ── Specialist Agent 1: Research Agent ────────────────────────────────────
research_agent = ReActAgent.from_tools(
    tools=[search_tool, web_tool],
    llm=Settings.llm,
    system_prompt="You are a research specialist. Find and compile accurate information.",
    verbose=True,
)

# ── Specialist Agent 2: Analysis Agent ─────────────────────────────────────
analysis_agent = ReActAgent.from_tools(
    tools=[calc_tool],
    llm=Settings.llm,
    system_prompt="You are a data analyst. Analyze data and provide insights.",
    verbose=True,
)

# ── Wrap agents as tools for the orchestrator ───────────────────────────────
def run_research(query: str) -> str:
    """Research agent: finds and compiles information on any topic."""
    response = research_agent.chat(query)
    return response.response

def run_analysis(data: str) -> str:
    """Analysis agent: analyzes data and extracts insights from it."""
    response = analysis_agent.chat(f"Analyze this data: {data}")
    return response.response

research_tool = FunctionTool.from_defaults(fn=run_research, name="research_agent")
analysis_tool = FunctionTool.from_defaults(fn=run_analysis, name="analysis_agent")

# ── Orchestrator Agent ──────────────────────────────────────────────────────
orchestrator = ReActAgent.from_tools(
    tools=[research_tool, analysis_tool],
    llm=Settings.llm,
    system_prompt="""
    You are an orchestrator agent. You delegate tasks to specialist agents:
    - Use research_agent to gather information
    - Use analysis_agent to analyze and extract insights
    Combine their outputs into comprehensive final answers.
    """,
    verbose=True,
)

# One call triggers a chain of agents
response = orchestrator.chat(
    "Research our Q3 sales data and analyze the growth trends"
)
print(response.response)
```

### 17.2 Multiple indexes, one agent

```python
# Different indexes for different data domains
finance_index = VectorStoreIndex.from_documents(finance_docs)
product_index = VectorStoreIndex.from_documents(product_docs)
support_index = VectorStoreIndex.from_documents(support_docs)

# Each index gets a tool with clear description
tools = [
    QueryEngineTool.from_defaults(
        query_engine=finance_index.as_query_engine(),
        name="finance_search",
        description="Search financial data: revenue, costs, forecasts, KPIs",
    ),
    QueryEngineTool.from_defaults(
        query_engine=product_index.as_query_engine(),
        name="product_search",
        description="Search product documentation, features, roadmap, specs",
    ),
    QueryEngineTool.from_defaults(
        query_engine=support_index.as_query_engine(),
        name="support_search",
        description="Search customer support tickets, FAQs, known issues",
    ),
    FunctionTool.from_defaults(fn=search_web, name="web_search"),
    FunctionTool.from_defaults(fn=calculate, name="calculator"),
]

# Single agent with access to all data domains
agent = ReActAgent.from_tools(tools=tools, llm=Settings.llm, verbose=True)

response = agent.chat(
    "What product features drove the most support tickets in Q3, "
    "and what was the financial impact of the related refunds?"
)
```

---

## 18. Integrating with CrewAI

Use LlamaIndex's knowledge retrieval power inside CrewAI agents.

```python
# agents/crewai_research_agent.py
from crewai import Agent, Task, Crew, Process
from crewai.tools import BaseTool
from llama_index.core import VectorStoreIndex, StorageContext, load_index_from_storage, Settings
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from pydantic import Field

# ── Setup LlamaIndex ────────────────────────────────────────────────────────
Settings.llm = Ollama(model="llama3", request_timeout=300.0)
Settings.embed_model = OllamaEmbedding(model_name="nomic-embed-text")

storage_context = StorageContext.from_defaults(persist_dir="./storage/index_store")
index = load_index_from_storage(storage_context)
query_engine = index.as_query_engine(similarity_top_k=5)

# ── Wrap LlamaIndex as a CrewAI Tool ────────────────────────────────────────
class KnowledgeBaseSearchTool(BaseTool):
    name: str = "knowledge_base_search"
    description: str = (
        "Search the internal knowledge base. Use this to find company-specific "
        "information, documents, reports, and proprietary data. "
        "Input should be a search query string."
    )

    def _run(self, query: str) -> str:
        response = query_engine.query(query)
        sources = [
            node.node.metadata.get("filename", "unknown")
            for node in response.source_nodes
        ]
        return f"Answer: {response.response}\n\nSources: {sources}"

# ── CrewAI Agents using LlamaIndex tool ─────────────────────────────────────
kb_tool = KnowledgeBaseSearchTool()

researcher = Agent(
    role="Senior Research Analyst",
    goal="Find accurate and comprehensive information from the knowledge base",
    backstory="Expert at searching and synthesizing information from large document collections",
    tools=[kb_tool],
    llm="ollama/llama3",         # CrewAI uses its own LLM config
    verbose=True,
    allow_delegation=False,
)

writer = Agent(
    role="Business Report Writer",
    goal="Transform research findings into clear, professional reports",
    backstory="Expert business writer with experience in creating executive summaries",
    tools=[],                    # Writer doesn't need search
    llm="ollama/llama3",
    verbose=True,
)

# ── Tasks ───────────────────────────────────────────────────────────────────
research_task = Task(
    description="Search the knowledge base and compile all information about {topic}",
    expected_output="A comprehensive summary of findings with sources",
    agent=researcher,
)

writing_task = Task(
    description="Write a professional report based on the research findings",
    expected_output="A 3-paragraph executive summary report",
    agent=writer,
    context=[research_task],    # Writer receives researcher's output
)

# ── Crew ─────────────────────────────────────────────────────────────────────
crew = Crew(
    agents=[researcher, writer],
    tasks=[research_task, writing_task],
    process=Process.sequential,
    verbose=True,
)

result = crew.kickoff(inputs={"topic": "Q3 product performance and customer feedback"})
print(result.raw)
```

---

## 19. Integrating with LangChain

LlamaIndex can expose query engines as LangChain tools, or use LangChain components inside LlamaIndex.

### 19.1 Use LlamaIndex query engine as a LangChain tool

```python
from langchain.tools import Tool
from langchain.agents import create_react_agent, AgentExecutor
from langchain_community.llms import Ollama as LangchainOllama
from langchain import hub

# LlamaIndex query engine (already built)
query_engine = index.as_query_engine(similarity_top_k=5)

# Wrap as LangChain Tool
llamaindex_tool = Tool(
    name="knowledge_base_search",
    description=(
        "Search the internal knowledge base for company information. "
        "Input should be a question or search query."
    ),
    func=lambda q: str(query_engine.query(q)),
)

# LangChain agent
llm = LangchainOllama(model="llama3", base_url="http://localhost:11434")
prompt = hub.pull("hwchase17/react")

langchain_tools = [llamaindex_tool]
agent = create_react_agent(llm, langchain_tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=langchain_tools, verbose=True)

result = agent_executor.invoke({"input": "What are the key findings from our research data?"})
print(result["output"])
```

### 19.2 Use LangChain text splitter inside LlamaIndex

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter
from llama_index.core.node_parser import LangchainNodeParser

# Use LangChain's splitter inside LlamaIndex pipeline
lc_splitter = RecursiveCharacterTextSplitter(
    chunk_size=512,
    chunk_overlap=50,
)

node_parser = LangchainNodeParser(lc_splitter)
nodes = node_parser.get_nodes_from_documents(documents)
```

---

## 20. Observability & Debugging

### 20.1 Enable verbose logging

```python
import logging
logging.basicConfig(level=logging.DEBUG)

# Or per-module
logging.getLogger("llama_index").setLevel(logging.DEBUG)
```

### 20.2 Callbacks — trace every step

```python
from llama_index.core.callbacks import CallbackManager, LlamaDebugHandler

# Debug handler logs all events
debug_handler = LlamaDebugHandler(print_trace_on_end=True)
callback_manager = CallbackManager([debug_handler])

Settings.callback_manager = callback_manager

# Now build your index and query engine as usual
# Every LLM call, embedding, retrieval will be logged
```

### 20.3 Inspect retrieved nodes

```python
response = query_engine.query("Your question")

print("=== ANSWER ===")
print(response.response)

print("\n=== SOURCE NODES ===")
for i, node in enumerate(response.source_nodes):
    print(f"\nNode {i+1}:")
    print(f"  Score:    {node.score:.4f}")
    print(f"  Source:   {node.node.metadata.get('filename', 'N/A')}")
    print(f"  Text:     {node.node.text[:300]}...")
```

---

## 21. Full Multi-Agent Project Structure

Here is how everything connects in a complete project:

```python
# main.py — Full system entry point
import os
from config import setup_settings
from llama_index.core import (
    VectorStoreIndex, SimpleDirectoryReader,
    StorageContext, load_index_from_storage
)
from llama_index.core.agent import ReActAgent
from llama_index.core.tools import QueryEngineTool, FunctionTool
from llama_index.core.memory import ChatMemoryBuffer

# ── 1. Global Settings ──────────────────────────────────────────────────────
setup_settings()  # Sets Ollama LLM + embeddings globally

# ── 2. Build / Load Indexes ─────────────────────────────────────────────────
def get_or_build_index(data_dir: str, persist_dir: str) -> VectorStoreIndex:
    if os.path.exists(persist_dir):
        storage_context = StorageContext.from_defaults(persist_dir=persist_dir)
        return load_index_from_storage(storage_context)
    docs = SimpleDirectoryReader(data_dir, recursive=True).load_data()
    index = VectorStoreIndex.from_documents(docs, show_progress=True)
    index.storage_context.persist(persist_dir=persist_dir)
    return index

finance_index  = get_or_build_index("./data/finance",  "./storage/finance")
product_index  = get_or_build_index("./data/product",  "./storage/product")
support_index  = get_or_build_index("./data/support",  "./storage/support")

# ── 3. Build Tools ──────────────────────────────────────────────────────────
def web_search(query: str) -> str:
    """Search the web for current information not in the knowledge base."""
    return f"Web search results for: {query}"  # Replace with real implementation

tools = [
    QueryEngineTool.from_defaults(
        query_engine=finance_index.as_query_engine(similarity_top_k=5),
        name="finance_search",
        description="Search financial reports, revenue data, KPIs, budgets",
    ),
    QueryEngineTool.from_defaults(
        query_engine=product_index.as_query_engine(similarity_top_k=5),
        name="product_search",
        description="Search product docs, features, roadmap, technical specs",
    ),
    QueryEngineTool.from_defaults(
        query_engine=support_index.as_query_engine(similarity_top_k=5),
        name="support_search",
        description="Search customer support tickets, FAQs, issue reports",
    ),
    FunctionTool.from_defaults(fn=web_search, name="web_search"),
]

# ── 4. Build Agent ──────────────────────────────────────────────────────────
agent = ReActAgent.from_tools(
    tools=tools,
    verbose=True,
    max_iterations=15,
    memory=ChatMemoryBuffer.from_defaults(token_limit=6000),
    system_prompt="""
    You are an intelligent business assistant with access to internal company data
    and the web. Always search relevant knowledge bases before the web.
    Cite your sources. Be precise and structured in your answers.
    """,
)

# ── 5. Run ──────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("Multi-Agent System Ready. Type 'exit' to quit.\n")
    while True:
        query = input("You: ").strip()
        if query.lower() in ["exit", "quit"]:
            break
        response = agent.chat(query)
        print(f"\nAgent: {response.response}\n")
```

---

## Data Flow Summary

```
Raw Files / APIs / DBs / Web
          │
          ▼
   SimpleDirectoryReader / Readers
   (loads → Documents)
          │
          ▼
   IngestionPipeline
   ├─ SentenceSplitter     → Documents → Nodes (chunks)
   ├─ TitleExtractor       → adds metadata to Nodes
   ├─ KeywordExtractor     → adds metadata to Nodes
   └─ OllamaEmbedding      → adds vectors to Nodes
          │
          ▼
   VectorStoreIndex (ChromaDB)
   (persisted to disk)
          │
          ▼
   Retriever (Hybrid: Vector + BM25)
   (given a query → returns top-k relevant Nodes)
          │
          ▼
   Response Synthesizer
   (Nodes + Query → Ollama LLM → Final Answer)
          │
          ▼
   QueryEngineTool
   (wraps the above as an agent tool)
          │
          ▼
   ReActAgent
   (Ollama decides: which tool, with what input, based on query)
          │
          ▼
   Multi-Agent Orchestrator
   (delegates to specialist agents / tools)
          │
          ▼
   Final Response to User / CrewAI / LangChain
```

---

## Key Reference

| Class                   | Role                             |
| ----------------------- | -------------------------------- |
| `SimpleDirectoryReader` | Load files from disk             |
| `Document`              | Raw loaded data unit             |
| `TextNode`              | Chunked piece of a Document      |
| `SentenceSplitter`      | Split Documents → Nodes          |
| `IngestionPipeline`     | Full transform + embed pipeline  |
| `OllamaEmbedding`       | Convert text → vectors locally   |
| `VectorStoreIndex`      | Store + search embeddings        |
| `StorageContext`        | Manage all storage backends      |
| `VectorIndexRetriever`  | Search by vector similarity      |
| `BM25Retriever`         | Search by keywords               |
| `QueryFusionRetriever`  | Hybrid vector + BM25 search      |
| `RetrieverQueryEngine`  | Retriever + LLM = full Q&A       |
| `ChatEngine`            | Q&A with conversation memory     |
| `QueryEngineTool`       | Wrap query engine as agent tool  |
| `FunctionTool`          | Wrap any Python function as tool |
| `ReActAgent`            | Reasoning + acting agent loop    |
| `ChatMemoryBuffer`      | Conversation history for agents  |
| `Settings`              | Global LLM + embedding config    |