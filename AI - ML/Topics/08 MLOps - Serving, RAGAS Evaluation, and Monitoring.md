---
title: "MLOps: Model Serving, RAGAS Evaluation & Production Monitoring"
tags:
  - MLOps
  - model-serving
  - vllm
  - ragas-evaluation
  - model-monitoring
  - interview-prep
created: 2026-05-29
type: study-note
---

# MLOps: Model Serving, RAGAS Evaluation & Production Monitoring

---

## 1. Model Serving: Latency, Throughput & Optimization

Deploying Large Language Models at scale requires managing heavy memory footprints and computationally intense autoregressive generation steps.

### A. Core Serving Metrics
* **Time to First Token (TTFT)**: The duration between the user submitting a prompt and the model generating its first output token.
  * *Nature*: **Prefill phase**. The model processes the entire input prompt context in parallel. This phase is compute-bound.
* **Tokens Per Second (TPS)**: The rate at which the model generates output tokens after the first token is returned.
  * *Nature*: **Decoding phase**. The model generates tokens autoregressively one by one, looking up the KV cache at each step. This phase is memory-bandwidth bound.

---

### B. Batching Techniques
* **Static Batching**: Traditional batching. Multiple requests are padded to match the longest prompt, processed together, and held until the longest request completes generation.
  * *Drawback*: High GPU idle time. If one user requests 10 tokens and another requests 1000 tokens, the GPU remains blocked until the 1000-token query finishes.
* **Continuous / Iterative Batching**: Modern batching (used in vLLM). It operates at the individual token iteration level rather than the request level. New requests are dynamically added to the active batch at any token generation step, and completed requests are evicted immediately.
  * *Benefit*: Increases throughput by up to $10\text{x}$ under heavy concurrent loads.

```
Static Batching:
Request A (10 tokens): [=====|                  ] (holds GPU until Request B completes)
Request B (30 tokens): [========================]

Continuous Batching:
Request A (10 tokens): [=====] (evicted immediately)
Request B (30 tokens): [========================] (continues generating)
Request C (injected):        [==================] (added mid-run)
```

---

### C. PagedAttention (vLLM)
In standard LLM serving, the KV cache size must be pre-allocated for the maximum possible context length (e.g., 2048 tokens), even if the request only runs for 10 tokens. This causes severe **memory fragmentation** (wasted VRAM space).
* **The Solution**: PagedAttention (introduced in vLLM) acts like virtual memory paging in operating systems. It divides the KV cache into fixed-size physical pages (e.g., 16 tokens). Pages do not need to be stored contiguously in GPU memory.
* **The Mechanism**: The serving engine maintains a Page Table mapping logical token sequences to non-contiguous physical pages. This eliminates fragmentation, reduces memory waste from $>60\%$ to $<4\%$, and allows the server to double its concurrent serving capacity.

---

## 2. Evaluation Metrics: The RAGAS Framework

Evaluating RAG pipelines is challenging because standard NLP metrics (like BLEU or ROUGE) measure word overlap against a reference text, which fails to evaluate factual correctness or reasoning in free-form LLM responses. **RAGAS** evaluates the pipeline using LLM-as-a-judge metrics.

```
       [ Context Recall ]              [ Faithfulness ]
      /                  \            /                \
Ground Truth --------> Retrieved Context --------> Generated Answer
                                \                  /
                                 [ Answer Relevance ]
```

### The Three Pillars of RAGAS Evaluation:

#### 1. Faithfulness (Groundedness)
* **What it measures**: Is the generated answer factually grounded *only* in the retrieved context? (Does it avoid hallucination?)
* **How it is calculated**:
  1. The LLM judge extracts individual statements from the generated answer: $S_1, S_2, \dots, S_n$.
  2. For each statement, the LLM verifies if it can be directly inferred from the retrieved context.
  $$\text{Faithfulness Score} = \frac{\text{Number of statements verified by context}}{\text{Total number of statements in generated answer}}$$

#### 2. Answer Relevance
* **What it measures**: Does the generated answer directly address the user's initial question? (Ignores factual truth; measures focus).
* **How it is calculated**:
  1. The LLM judge generates 3 synthetic questions ($Q'_1, Q'_2, Q'_3$) based on the generated answer.
  2. It computes the cosine similarity between the embeddings of the synthetic questions and the user's actual question ($Q$).
  $$\text{Answer Relevance} = \frac{1}{N} \sum_{i=1}^N \cos(Q'_i, Q)$$

#### 3. Context Recall
* **What it measures**: Did the retrieval engine fetch all the information necessary to construct the ground-truth answer?
* **How it is calculated**:
  1. The ground truth answer is split into individual statements: $G_1, G_2, \dots, G_k$.
  2. The LLM judge checks if each ground truth statement is present within the retrieved context.
  $$\text{Context Recall} = \frac{\text{Number of ground truth statements found in retrieved context}}{\text{Total number of ground truth statements}}$$

---

## 3. A/B Testing Models in Production

When deploying a new model version (e.g., swapping a LLaMA-2-7B backend with LLaMA-3-8B), engineers run A/B tests to monitor both business and system metrics.

### Sizing and Routing
* **Traffic Routing**: Traffic is split (e.g., $90\%$ Control (Model A) and $10\%$ Treatment (Model B)) at the API gateway layer using hashing keys (like `hash(user_id) % 10`).
* **Sizing Sample Size**: Calculate the minimum sample size using statistical power analysis (standard settings: significance level $\alpha = 0.05$, statistical power $\beta = 0.80$, and expected Minimum Detectable Effect (MDE)).

### Operational Metrics to Track:

| Category | Metric | Goal |
| :--- | :--- | :--- |
| **System / Latency** | Time to First Token (TTFT) | Ensure the new model doesn't degrade user experience (lower is better). |
| | P99 latency | Identify slow execution outliers. |
| **Financial / Cost** | Input/Output Token Count | Estimate VRAM and API cost shifts under scale. |
| **Business / Quality** | Task completion rate | Measure user conversion or output action rates. |
| | Implicit feedback | Track user thumbs-up/down, session duration, and edit rates. |

---

## 4. Monitoring & Guardrails: Hallucinations and Drift

Once deployed, models are vulnerable to decay due to changing user distributions or environmental states.

### A. Hallucination Detection
1. **Self-Consistency (Entropy Check)**: Generate the answer $N$ times at a high temperature ($T = 0.7$). If the outputs vary wildly (high entropy), the model is likely guessing/hallucinating. If the outputs are highly consistent, confidence is high.
2. **NLI (Natural Language Inference) Classifiers**: Run a small entailment model to verify if the generated sentence logically follows from the reference context.

---

### B. Drift Monitoring
* **Data Drift (Input Shift)**: User inputs change over time. 
  * *Detection*: Embed incoming user prompts and compute the cosine distance between the centroid of current prompts and historical baseline prompts. A growing distance indicates input drift.
* **Concept Drift (Output Shift)**: The relationship between the input data and the target output changes. For example, a code generation model starts producing outdated code styles because a new library version was released.
* **Semantic Drift (Task Shift)**: Users begin using the chatbot for entirely new tasks (e.g., shifting from customer support inquiries to programming help).

---

## 5. Key Interview Q&As

### Q1: Why does vLLM claim to improve serving throughput by 2-4x?
**Answer**: vLLM implements **PagedAttention**, which solves the memory bottleneck of the KV cache. Traditional serving pre-allocates contiguous memory for each request matching the maximum sequence length, wasting up to $60-80\%$ of GPU memory on unused padding. PagedAttention dynamically allocates KV cache space in non-contiguous 16-token pages, eliminating memory fragmentation. This allows the GPU to fit more concurrent requests, multiplying throughput.

### Q2: A RAG pipeline returns an answer that is factually incorrect, but the RAGAS Faithfulness score is 1.0. How is this possible?
**Answer**: The **Faithfulness** metric only measures if the generated answer is grounded *within the retrieved context*. If the retrieval engine fetched incorrect documents (e.g., outdated bank policies), and the LLM generated an answer that accurately reflected that incorrect information, the Faithfulness score remains 1.0 (since the LLM did not hallucinate *beyond* the context it was given). However, the **Context Recall** score would be low because the retrieved context failed to match the correct ground-truth information.

### Q3: How do you implement automated drift detection in a vector database index?
**Answer**:
1. Sample a sliding window of incoming user query vector embeddings (e.g., past 10,000 queries).
2. Calculate the average cosine distance (the semantic centroid) of this sample against a baseline query dataset from launch week.
3. If the average distance exceeds a predefined statistical threshold (using tests like the Kolmogorov-Smirnov test on coordinate distributions), trigger an alert indicating data drift.
4. Update the index or fine-tune embedding layers to realign the vector space.
