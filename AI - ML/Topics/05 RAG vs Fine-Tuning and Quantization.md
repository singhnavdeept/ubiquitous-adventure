---
title: "LLM Internals: RAG vs. Fine-Tuning & Quantization"
tags:
  - GenAI
  - LLM-internals
  - rag-vs-finetuning
  - quantization
  - prompt-engineering
  - interview-prep
created: 2026-05-29
type: study-note
---

# LLM Internals: RAG vs. Fine-Tuning & Quantization

---

## 1. RAG vs. Fine-Tuning: Core Architectural Decisions

When adapting a Large Language Model to proprietary data or domain-specific tasks, engineers must decide between **Retrieval-Augmented Generation (RAG)** and **Fine-Tuning**.

```
                           +------------------------+
                           |  adaptation challenge  |
                           +-----------+------------+
                                       |
                   +-------------------+-------------------+
                   |                                       |
                   v                                       v
    [ requires new knowledge? ]               [ requires style/format? ]
                   |                                       |
         +---------+---------+                   +---------+---------+
         |                   |                   |                   |
         v                   v                   v                   v
      [ RAG ]         [ Fine-Tuning ]     [ Fine-Tuning ]         [ RAG ]
  (Dynamic data,      (Static data,       (Custom output,       (Standard LLM
   citations)          specialized)        style shifts)         sufficient)
```

### Key Trade-Off Matrix

| Dimension | Retrieval-Augmented Generation (RAG) | Fine-Tuning (e.g., LoRA / QLoRA) |
| :--- | :--- | :--- |
| **Knowledge Type** | **External / Dynamic**: Excels at retrieving real-time, changing data. | **Internal / Structural**: Excels at learning style, tone, format, and syntax. |
| **Hallucination Control** | **High**: The model is forced to ground its answers in the provided context. | **Low**: The model relies on parametric memory; prone to hallucination. |
| **Source Citation** | **Yes**: Can directly point to source documents and page numbers. | **No**: Answers are drawn from internal weights; cannot cite sources. |
| **Data Update Velocity** | **Instant**: Just update the files in your vector database. | **Slow**: Requires running a new training loop (hours/days). |
| **Computational Cost** | **Low setup, high run-time**: Setup is just indexing. Run-time requires long context prompts. | **High setup, low run-time**: High compute needed to train. Run-time prompts are shorter. |
| **Vocabulary Adaptation** | **Weak**: Cannot easily learn new technical terms or complex acronyms. | **Strong**: Teaches the model new jargon and domain-specific acronyms. |

### When to Use Which
* **Choose RAG if**: You have a database of 10,000 corporate PDFs that update daily, your answers must be 100% factual, and the model must print the source URL or document page for every fact it states.
* **Choose Fine-Tuning if**: You need the model to output valid JSON matching a complex schema 100% of the time, or you want the model to mimic a specific author's writing style, or you need to train a model to output syntax for a proprietary programming language.

### The Hybrid Pattern (The Production Standard)
In production, a common design pattern is to use **both**:
1. **Fine-tune** a small model (e.g., Mistral-7B) to become an expert at a specific format (like structuring inputs/outputs or JSON parsing) and to understand domain jargon.
2. **Apply RAG** over the fine-tuned model to supply the factual, real-time knowledge context.

---

## 2. Quantization Basics: Math & Formats

Quantization is the process of mapping continuous, high-precision floating-point numbers to lower-precision representations (e.g., compressing 16-bit floats into 4-bit integers) to reduce memory usage and accelerate inference.

### The Quantization Math
To convert a floating-point value $r$ (FP32/FP16) to an integer value $q$ (INT8/INT4), we use a scale factor $S$ and an integer zero-point $Z$:

$$q = \text{round}\left(\frac{r}{S}\right) + Z$$

* **Scale ($S$)**: A floating-point number that maps the range of the float values to the range of the integer values.
  $$S = \frac{r_{\text{max}} - r_{\text{min}}}{q_{\text{max}} - q_{\text{min}}}$$
* **Zero-Point ($Z$)**: An integer offset ensuring that a real value of $0.0$ maps exactly to a quantized integer value (crucial for maintaining padding states).
  $$Z = \text{round}\left(\frac{-r_{\text{min}}}{S}\right) + q_{\text{min}}$$

To **dequantize** the value back to float for computation:
$$\hat{r} = S \cdot (q - Z)$$

---

### Quantization Paradigms
1. **Post-Training Quantization (PTQ)**: Quantization is applied to a pre-trained model's weights using a calibration dataset without any further training. Fast to run, but can lead to accuracy loss in very small models.
2. **Quantization-Aware Training (QAT)**: The model simulates quantization errors during the training process (using straight-through estimators). It maintains higher accuracy but is computationally expensive.

---

### Quantization Formats for Deployment

* **GGUF (GPT-Generated Unified Format)**:
  * *Architecture*: Designed for **local CPU/Mac deployment** via `llama.cpp`. It bundles model weights, tokenizer configs, and metadata into a single file.
  * *Key Feature*: Supports **CPU offloading** — if you have a 16GB GPU but the model needs 20GB, you can load 12GB onto the GPU VRAM and run the remaining 8GB on CPU system memory.
* **GPTQ (Generalized Post-Training Quantization)**:
  * *Architecture*: A **GPU-optimized** quantization algorithm. It uses second-order optimization (Hessian matrices) to quantize weights to 4-bit or 3-bit.
  * *Key Feature*: Highly optimized for massive batch processing on GPU serving engines (like vLLM).
* **AWQ (Activation-aware Weight Quantization)**:
  * *Architecture*: Observes weight activations during inference. It finds that not all weights are equal: $1\%$ of weights are highly sensitive ("salient weights") and control model performance.
  * *Key Feature*: Protects this salient $1\%$ from aggressive quantization while compressing the remaining $99\%$ to 4-bit. This achieves near-zero loss in accuracy compared to standard FP16 baselines.

---

## 3. Prompt Engineering Patterns

### A. Few-Shot Prompting
Few-shot prompting provides the model with explicit input-output examples to guide its behavior, formatting, and style.

```text
Classify the sentiment of the following movie reviews.

Review: "The acting was stale and the plot was predictable."
Sentiment: Negative

Review: "A visual masterpiece that kept me on the edge of my seat."
Sentiment: Positive

Review: "It was okay, but had pacing issues in the second act."
Sentiment: Neutral

Review: "I fell asleep 20 minutes in."
Sentiment:
```
* **Why it works**: It activates the model's in-context learning capabilities, establishing structural expectations.

### B. Chain-of-Thought (CoT) Prompting
Chain-of-Thought prompts the LLM to output its intermediate reasoning steps before delivering the final answer.

```text
Question: A farmer has 15 apples. He sells 3 to a neighbor, gives 2 to his sister, and buys 5 more from the market. How many apples does he have now?

Reasoning: Let's break this down step-by-step:
1. The farmer starts with 15 apples.
2. He sells 3, so: 15 - 3 = 12 apples remaining.
3. He gives 2 to his sister: 12 - 2 = 10 apples remaining.
4. He buys 5 more: 10 + 5 = 15 apples total.

Answer: The farmer has 15 apples.
```
* **Why it works**: Forcing the model to generate reasoning tokens ($T_{\text{reasoning}}$) allows the self-attention layer to build richer compute states before generating the final token ($T_{\text{answer}}$), boosting logical and arithmetic accuracy.

### C. System Prompts
System prompts establish the overarching personality, formatting rules, context constraints, and guardrails for the entire chat session.

```text
System Prompt:
You are a banking system assistant. You only answer questions using the provided bank database context.
Format all monetary values as USD (e.g., $100.00).
If the user asks a question unrelated to banking, say: "I am only authorized to assist with banking inquiries."
```

---

## 4. Key Interview Q&As

### Q1: Why is RAG generally preferred over Fine-Tuning for real-time information retrieval?
**Answer**: Fine-tuning updates the static parametric weights of the model, which is slow (takes hours to run training loops) and expensive. If information changes frequently, fine-tuning is impractical. RAG separates storage from reasoning: you can update the vector store instantly, and the model receives the new facts directly within its prompt context, ensuring up-to-date and citeable answers.

### Q2: What is the math behind symmetric vs. asymmetric quantization?
**Answer**:
* **Symmetric Quantization**: Maps the float range $[-r_{\text{max}}, r_{\text{max}}]$ symmetrically to $[-127, 127]$. The zero-point $Z$ is fixed at $0$. This simplifies calculations but wastefully represents asymmetrical ranges (e.g., if all activation values are positive).
* **Asymmetric Quantization**: Maps $[r_{\text{min}}, r_{\text{max}}]$ to the full integer range $[q_{\text{min}}, q_{\text{max}}]$ using a calculated offset zero-point $Z$. This is more precise but adds computational overhead during dequantization.

### Q3: Why does Chain-of-Thought prompting improve LLM performance on math tasks?
**Answer**: Autoregressive models predict the next token based on all previous tokens. If we ask the model to output the final answer immediately, it has only a single forward pass to compute a complex answer. By forcing it to output the reasoning steps first, the model writes its calculations to the context window. When it finally computes the answer, it can attend to its own written-out calculations, reducing the load on its internal hidden states.
