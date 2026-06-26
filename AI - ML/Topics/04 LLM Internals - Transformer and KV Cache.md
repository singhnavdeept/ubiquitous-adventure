---
title: "LLM Internals: Transformer Architecture & KV Cache"
tags:
  - GenAI
  - LLM-internals
  - transformer
  - attention
  - kv-cache
  - interview-prep
created: 2026-05-29
type: study-note
---

# LLM Internals: Transformer Architecture & KV Cache

---

## 1. Transformer Architecture: Core Math & Intuition

The Transformer model (introduced by Vaswani et al. in *Attention Is All You Need*) is a sequence-to-sequence model that replaces recurrence with **Self-Attention**. 

```
                                  +-------------------+
                                  |    Input Token    |
                                  +-------------------+
                                            |
                                 [Embedding + Position]
                                            |
                                            v
                                  +-------------------+
                                  |   Linear Layers   |
                                  +---+---+---+-------+
                                      |   |   |
                                      v   v   v
                                      Q   K   V  (Query, Key, Value Matrices)
                                      |   |   |
                                      +---+---+
                                          |
                                          v
                                   [ Q . K^T ]  (Dot Product Similarity)
                                          |
                                          v
                                    [ / sqrt(d) ]  (Scale)
                                          |
                                          v
                                     [ Softmax ]   (Attention Weights)
                                          |
                                          v
                              [ Weight . V ]  (Weighted Sum of Values)
                                          |
                                          v
                                  +-------------------+
                                  |    Output Node    |
                                  +-------------------+
```

### A. Query, Key, and Value Vectors
Every input token is embedded into a vector $x_i \in \mathbb{R}^{d_{\text{model}}}$. It is then projected into three separate vector spaces using weight matrices $W_Q, W_K, W_V \in \mathbb{R}^{d_{\text{model}} \times d_k}$:
* **Query ($q_i$)**: *"What am I looking for?"* (Represents the active token seeking context).
* **Key ($k_i$)**: *"What content do I contain?"* (Acts as the index tag that other tokens search against).
* **Value ($v_i$)**: *"What actual information do I yield?"* (Contains the actual semantic payload written to the output state).

### B. Scaled Dot-Product Attention
The mathematically defined self-attention layer aggregates values across the sequence:

$$\text{Attention}(Q, K, V) = \text{softmax}\left(\frac{QK^T}{\sqrt{d_k}}\right)V$$

#### Why divide by $\sqrt{d_k}$? (The Scaling Factor)
For large projection dimensions $d_k$, the dot products grow large in magnitude. 
* **The Math**: If components of $q$ and $k$ are independent random variables with mean 0 and variance 1, their dot product $q \cdot k = \sum_{i=1}^{d_k} q_i k_i$ has mean 0 and variance $d_k$.
* **The Problem**: Large dot products push the $\text{softmax}$ function into regions with extremely small gradients (vanishing gradient problem).
* **The Solution**: Dividing by $\sqrt{d_k}$ scales the variance back to 1, ensuring stable gradients during training.

### C. Multi-Head Attention (MHA)
Instead of performing attention once on the full $d_{\text{model}}$ dimensions, **Multi-Head Attention** splits the query, key, and value vectors into $h$ lower-dimensional heads ($d_k = d_{\text{model}} / h$).
* **Intuition**: Allows the model to jointly attend to information from different representation subspaces at different positions. For example, one head might track subject-verb agreement, while another resolves pronoun references.
* **Math**:
  $$\text{MultiHead}(Q, K, V) = \text{Concat}(\text{head}_1, \dots, \text{head}_h)W^O$$
  $$\text{where } \text{head}_i = \text{Attention}(QW_i^Q, KW_i^K, VW_i^V)$$

### D. Normalization Layers: Pre-LN vs. Post-LN
The location of Layer Normalization (`LayerNorm`) is critical for training deep architectures:

* **Post-LN (Original Transformer)**:
  $$x_{l+1} = \text{LN}(x_l + \text{SubLayer}(x_l))$$
  * *Trade-off*: Normalization occurs on the residual path. Gradients decay exponentially near the input layers, making deep networks (>16 layers) unstable to train without a long warm-up phase.
* **Pre-LN (Modern LLMs like LLaMA/GPT-3)**:
  $$x_{l+1} = x_l + \text{SubLayer}(\text{LN}(x_l))$$
  * *Trade-off*: Normalization occurs on the sub-layer input path. The residual connection remains clean, allowing gradients to flow unimpeded directly from the output to the input. This enables stable training of 100B+ parameter models.

---

## 2. Positional Encoding: Sinusoidal vs. RoPE vs. ALiBi

Since Transformers process all tokens simultaneously (bag-of-words property), we must explicitly inject order information.

### A. Sinusoidal Positional Encoding (Absolute)
Uses fixed mathematical curves (sine and cosine waves of different frequencies) added directly to input embeddings:
$$PE_{(pos, 2i)} = \sin\left(\frac{pos}{10000^{2i/d_{\text{model}}}}\right)$$
* *Limitation*: Strict absolute coordinates. Generalizes poorly to sequence lengths longer than those observed during training.

### B. Rotary Position Embedding (RoPE)
Modern models (LLaMA, Mistral, Gemma) apply a rotation matrix to the Query and Key vectors in the 2D complex plane:
$$R_{\Theta, m}^d = \text{diag}\left(R_{\theta_1, m}, R_{\theta_2, m}, \dots, R_{\theta_{d/2}, m}\right)$$
* **Why it excels**:
  1. It encodes **relative position directly** through the rotation difference: the dot product of rotated query $q_m$ and rotated key $k_n$ depends only on their relative distance $m-n$.
  2. It naturally decays attention strength as distance increases.
  3. It allows **context window extension** via interpolation techniques (like RoPE Scaling / YaRN).

### C. ALiBi (Attention with Linear Biases)
Instead of adding position vectors to the embeddings, ALiBi subtracts a static, linear bias penalty directly from the attention matrix:
$$\text{Attention}(i, j) = \text{softmax}\left(q_i k_j^T - m \cdot |i - j|\right)$$
where $m$ is a head-specific slope.
* **Why it excels**: Excellent zero-shot context extrapolation. A model trained on 2K tokens can generalize to 32K at inference time without retraining.

---

## 3. Context Windows & The KV Cache

### The $O(L^2)$ Attention Bottleneck
The self-attention calculation requires multiplying the $Q$ and $K$ matrices:

$$\text{Attention Matrix Size} = [B, h, L, L]$$

For a sequence of length $L$, the storage and computational complexity scale quadratically ($O(L^2)$). At a sequence length of 32,000 tokens, the memory required to store the raw attention maps exceeds available GPU RAM.

---

### The KV Cache: Mechanics & Complexity
During **autoregressive generation**, the LLM generates tokens sequentially:
$$\text{Prompt: "The sky is" (Token 1, 2, 3)} \longrightarrow \text{Output: "blue" (Token 4)}$$

* **Without KV Cache**: To generate Token 5, the model must recompute the Query, Key, and Value vectors for all past tokens (Tokens 1, 2, 3, 4). This results in redundant $O(L^2)$ operations per token step.
* **With KV Cache**: Since the Key and Value vectors of past tokens (Tokens 1, 2, 3) are deterministic and do not change, we cache them in GPU memory. For Token 4, we only project and compute the $q_4, k_4, v_4$ vectors. We write $k_4, v_4$ to the cache and perform attention using:
  $$\text{Query} = q_4 \quad \text{against} \quad \text{Keys} = [k_1, k_2, k_3, k_4]$$
  This reduces execution complexity from $O(L^2)$ to **$O(L)$ sequential reads** per token step.

```
Step 1: Ingest Prompt ("The sky is")
  - Compute Q, K, V for all tokens.
  - Store Keys & Values in KV Cache.

Step 2: Generate Next Token ("blue")
  - Compute Q, K, V ONLY for "blue".
  - Append new K, V to KV Cache.
  - Compute attention using new Q against all K in cache.
```

---

### Step-by-Step Interview Sizing Sizing Calculation
*Interview Question: "How much GPU memory does the KV Cache consume for a LLaMA-7B model running FP16 precision, with a batch size of 4 and a context window of 2,048 tokens?"*

#### The General Sizing Formula:
$$\text{KV Cache Size (Bytes)} = 2 \times 2 \times n_{\text{layers}} \times n_{\text{heads}} \times d_{\text{head}} \times b \times l_{\text{seq}} \times \text{bytes-per-precision}$$

#### Variable Definitions:
* First $2$: We store both Key ($K$) and Value ($V$) matrices.
* Second $2$: For floating-point operations, each coordinate stores an active state (can be omitted if using raw parameter sizes).
* $n_{\text{layers}}$: Number of transformer blocks.
* $n_{\text{heads}}$: Number of attention heads (for MQA/GQA, use the number of Key-Value heads).
* $d_{\text{head}}$: Head dimension size ($d_{\text{model}} / n_{\text{heads}}$).
* $b$: Serving batch size.
* $l_{\text{seq}}$: Max sequence length.
* $\text{bytes-per-precision}$: $2$ bytes for FP16/BF16, $4$ bytes for FP32, $0.5$ bytes for INT4.

#### Step-by-Step Calculation for LLaMA-7B:
* **LLaMA-7B Configurations**:
  * $n_{\text{layers}} = 32$
  * $n_{\text{heads}} = 32$
  * $d_{\text{model}} = 4096 \implies d_{\text{head}} = 4096 / 32 = 128$
  * $b = 4$
  * $l_{\text{seq}} = 2048$
  * $\text{bytes-per-precision} = 2$ (FP16)

#### Substituting values:
$$\text{Size} = 2 \times (\text{Key & Value}) \times 32 \times 32 \times 128 \times 4 \times 2048 \times 2 \text{ bytes}$$
$$\text{Size} = 2 \times 32 \times 32 \times 128 \times 4 \times 2048 \times 2$$
$$\text{Size} = 2 \times 32 \times 32 \times 128 \times 4 \times 2048 \times 2 = 8,589,934,592 \text{ bytes}$$
$$\text{Size} \approx 8.59 \text{ GB}$$

> **Key Takeaway**: The model weights for LLaMA-7B consume ~14 GB of GPU VRAM. Serving it at a batch size of 4 with a 2K context window requires an additional ~8.6 GB *just* for the KV Cache. This highlights why memory capacity is the primary bottleneck in LLM serving.

---

## 4. Key Interview Q&As

### Q1: Why do we observe quadratic bottlenecking in Self-Attention?
**Answer**: In standard self-attention, every token in the sequence must calculate a similarity score with every other token in the sequence to build the attention matrix. For a sequence length of $L$, this results in an $L \times L$ matrix multiplication, yielding $O(L^2)$ space complexity to store the attention weights and $O(L^2 \cdot d)$ computational complexity.

### Q2: What is the difference between Multi-Head Attention (MHA), Multi-Query Attention (MQA), and Grouped-Query Attention (GQA)?
**Answer**:
* **MHA (Multi-Head Attention)**: Each query head has its own key and value head. KV Cache scales linearly with the number of heads.
* **MQA (Multi-Query Attention)**: All query heads share a **single** key and value head. This drastically reduces the KV cache size (by a factor equal to the number of heads) but can degrade model reasoning quality.
* **GQA (Grouped-Query Attention)**: A hybrid approach (used in LLaMA-3). Query heads are grouped (e.g., groups of 4), and each group shares a single key and value head. This balances memory savings with accuracy.

```
MHA:  Q1->K1,V1  Q2->K2,V2  Q3->K3,V3  Q4->K4,V4
MQA:  Q1, Q2, Q3, Q4  ======>  K1, V1
GQA:  [Q1, Q2]->K1,V1  [Q3, Q4]->K2,V2
```

### Q3: How do Rotary Position Embeddings (RoPE) enable context window extension?
**Answer**: RoPE encodes positions by rotating vectors in a 2D space. Because the coordinates are continuous rotation functions, we can interpolate the angles at inference time. If a model was trained on positions $[0, 2048]$ and we want to run it at $4096$, we can scale down the rotation frequency (e.g., dividing the position index by 2). The model sees rotation angles that match the range it was trained on, allowing it to process longer sequences.
