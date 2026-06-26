---
title: "Visual Search System Design"
date: "2026-06-25"
excerpt: "A chapter-by-chapter breakdown of how to design a Pinterest-style visual search system — covering representation learning, contrastive training, evaluation metrics, and ANN serving infrastructure."
tags:
  - machine-learning
  - system-design
  - visual-search
  - computer-vision
  - representation-learning
  - contrastive-learning
  - vector-database
  - information-retrieval
  - interview-prep
  - MLOps
aliases:
  - "Pinterest Visual Search Design"
  - "Image Retrieval ML System"
  - "Visual Search Interview"
---

# Visual Search System Design

> [!info] What Is This?
> A system that helps users discover images that are visually similar to a selected image.
> In this chapter, we design a visual search system similar to **Pinterest's**.
> The system takes a query image (or a user-selected crop), and returns a ranked list of visually similar images from a corpus of billions.

---

## Clarifying Requirements

Here's a typical interaction between a candidate and an interviewer.

> **Candidate**: Should we rank the results from most similar to least similar?
> **Interviewer**: Images that appear first in the list should be more similar to the query image.

> **Candidate**: Should the system support videos, too?
> **Interviewer**: Let's focus only on images.

> **Candidate**: A platform like Pinterest allows users to select an image crop and retrieve similar images. Should we support that functionality?
> **Interviewer**: Yes.

> **Candidate**: Are the displayed images personalized to the user?
> **Interviewer**: For simplicity, let's not focus on personalization. A query image yields the same results, regardless of who searches for it.

> **Candidate**: Can the model use the metadata of the query image, such as image tags?
> **Interviewer**: In practice, the model uses image metadata. But for simplicity, let's assume we don't rely on the metadata, but only on the image pixels.

> **Candidate**: Can users perform other actions such as save, share, or like? These actions can help label training data.
> **Interviewer**: Great point. For simplicity, let's assume the only supported action is image clicks.

> **Candidate**: Should we moderate the images?
> **Interviewer**: It's important to keep the platform safe, but content moderation is out of scope.

> **Candidate**: We can construct training data online and label them based on user interactions. Is this the expected way to construct training data?
> **Interviewer**: Yes, that sounds reasonable.

> **Candidate**: How fast should the search be? Assuming we have 100-200 billion images on the platform, the system should be able to retrieve similar images quickly. Is that a reasonable assumption?
> **Interviewer**: Yes, that is a reasonable assumption.

### Summary of Requirements

We are asked to design a visual search system that:
- Retrieves images similar to a user's query image.
- Ranks them based on visual similarity (most similar first).
- Displays the ranked list to the user.
- Supports images only (no video or text queries).
- Does not require personalization.

---

## Frame the Problem as an ML Task

### Defining the ML Objective

A clear, measurable ML objective is: **accurately retrieve images that are visually similar to a query image.**

### Specifying the System's Input and Output

| | Description |
| :--- | :--- |
| **Input** | A query image (or a user-defined crop) provided by the user |
| **Output** | A list of visually similar images, ranked from most to least similar |

### Choosing the Right ML Category: Representation Learning

The output of the model is a set of **ranked** images that are similar to the query image — so this is fundamentally a **ranking problem**.

We use **representation learning** to solve it. In representation learning, a model is trained to transform input data (images) into compact vector representations called **embeddings**. These embeddings are learned so that:

- **Similar images** → embeddings that are **close together** in the embedding space.
- **Dissimilar images** → embeddings that are **far apart** in the embedding space.

> [!tip] Why Embeddings?
> Think of an embedding as a compression of an image into a coordinate in an N-dimensional space. Instead of comparing raw pixels (which is extremely expensive and brittle to cropping, lighting, color shifts), we compare coordinates in a learned semantic space. Two images of a golden retriever will land near each other in that space even if they were taken in different lighting.

#### How to Rank Images Using Representation Learning

1. Transform all platform images into embedding vectors and store them in an index.
2. At query time, transform the query image into its embedding $E_q$.
3. Compute **similarity scores** between $E_q$ and all stored embeddings using a distance metric (e.g., cosine similarity or dot product).
4. Rank images by their similarity scores — the closest embeddings rank highest.

$$\text{similarity}(E_q, E_i) = \frac{E_q \cdot E_i}{\|E_q\| \cdot \|E_i\|}$$

This is called **cosine similarity**. It measures the angle between two vectors in the embedding space, ranging from $-1$ (opposite) to $+1$ (identical direction).

---

## Data Preparation

### Data Engineering

Three primary data sources are available:

#### Images

Creators upload images; the system stores the images and their metadata such as owner ID, upload time, and tags.

| ID | Owner ID | Upload Time | Manual Tags |
| :--- | :--- | :--- | :--- |
| 1 | 8 | 1658451341 | Zebra |
| 2 | 5 | 1658451841 | Pasta, Food, Kitchen |
| 3 | 19 | 1658821820 | Children, Family, Party |

*Table: Image metadata*

#### Users

User data contains demographic attributes associated with users.

| **ID** | **Username** | **Age** | **Gender** | **City** | **Country** | **Email** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | johnduo | 26 | M | San Jose | USA | john@gmail.com |
| 2 | hs2008 | 49 | M | Paris | France | hsieh@gmail.com |
| 3 | alexish | 16 | F | Rio | Brazil | alexh@yahoo.com |

*Table: User data*

#### User-Image Interactions

Interaction data captures user behavior on the platform. The primary interaction types are **impressions** (image shown to the user) and **clicks** (user clicked the image).

| User ID | Query Image ID | Displayed Image ID | Position | Interaction Type | Location (lat, long) | Timestamp |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 8 | 2 | 6 | 1 | Click | 38.8951 -77.0364 | 1658450539 |
| 6 | 3 | 9 | 2 | Click | 38.8951 -77.0364 | 1658451341 |
| 91 | 5 | 1 | 2 | Impression | 41.9241 -89.0389 | 1658451365 |

*Table: User-image interaction data*

> [!note] Interaction data as a training signal
> Click data is a noisy but free training signal. When a user is shown a result and clicks it, that click is a weak signal that the clicked image is similar to the query. This "implicit feedback" is much cheaper than human annotation and scales naturally with platform traffic.

### Feature Engineering

Since we framed this as a representation learning problem where the model takes an **image as input**, we preprocess images before passing them to the model. Common image preprocessing operations:

- **Resizing**: Models require fixed image sizes (e.g., $224 \times 224$). Aspect ratios may be preserved by padding or center-cropping.
- **Pixel Scaling**: Normalize pixel values from $[0, 255]$ to $[0, 1]$.
- **Z-score Normalization**: Subtract the dataset-level channel mean $\mu$ and divide by channel standard deviation $\sigma$:

$$\hat{x} = \frac{x - \mu}{\sigma}$$

This ensures that each color channel has zero mean and unit variance, which stabilizes gradient flow during training.

- **Consistent Color Mode**: Ensure all images are in RGB format (discard CMYK, RGBA alpha channels, or grayscale where inappropriate).

> [!tip] Data Augmentation as both Preprocessing and Training Signal
> During training (not inference), we additionally apply **random augmentations** — crops, horizontal flips, color jitter, Gaussian blur — to create artificially similar image pairs for self-supervised contrastive training. This is the core of frameworks like **SimCLR** and **MoCo**.

---

## Model Development

### Model Selection

We choose **neural networks** because:
- Neural networks handle **unstructured data** (images, text) better than traditional ML models.
- Unlike many classical models, neural networks naturally produce **dense embedding vectors** usable for representation learning.

#### Architecture Choices

**CNN-based architectures** like ResNet and more recent **Transformer-based architectures** like ViT perform well with image inputs.

```
Input Image (H × W × 3)
        │
        ▼
┌──────────────────────────────────────┐
│  Convolution Layers (e.g., ResNet)   │  ← Extracts local spatial features
│  or Patch + Attention Layers (ViT)  │  ← Extracts global contextual features
└──────────────────────────────────────┘
        │
        ▼
┌──────────────────────────────────────┐
│  Fully Connected / Projection Head   │  ← Maps to a lower-dimensional embedding
└──────────────────────────────────────┘
        │
        ▼
  Embedding Vector E (size D)           ← e.g., D = 128, 256, or 512
```

> [!note] CNN vs. Vision Transformer (ViT)
> - **CNNs (ResNet, EfficientNet)**: Use sliding convolution windows to detect local patterns (edges, textures). They are highly parameter-efficient and perform well even on limited data. **Best for: latency-sensitive deployments.**
> - **ViTs (ViT-B/16, DeiT)**: Divide the image into fixed-size patches and process them with Multi-Head Self-Attention (MHSA). ViTs capture long-range dependencies across the entire image. They require more data and compute but achieve higher accuracy. **Best for: quality-critical deployments with large training sets.**

The number of convolution layers, the number of neurons in fully-connected layers, and the **size of the embedding vector** are hyperparameters chosen via experimentation.

### Model Training

A common technique for learning image representations is **contrastive training**. We provide the model with:
- A **query image** $q$
- One **similar (positive) image** $p$ to the query
- Several **dissimilar (negative) images** $\{n_1, n_2, \ldots, n_{N-1}\}$

During training, the model learns to produce embeddings where the positive image is much closer to the query than any negative image.

#### Constructing the Dataset

Each training data point contains:
- A query image $q$
- $N$ other images: one positive $p$, and $N-1$ negatives
- A ground truth label: the **index of the positive image**

To construct training data, we have three options for selecting the positive image:

##### Option 1 — Human Judgment

Human contractors manually identify similar images.

| Pros | Cons |
| :--- | :--- |
| Highly accurate | Very expensive |
| Clean labels | Slow and hard to scale |

##### Option 2 — User Clicks as Proxy for Similarity

When a user clicks on a displayed image, we treat the clicked image as a positive match for the query image. This click data is collected from interaction logs automatically.

| Pros | Cons |
| :--- | :--- |
| Free and scalable | Click signal is very noisy |
| No manual work | Sparse — many images never get clicked |

> [!warning] Noisy Supervision
> Users sometimes click on results out of curiosity, not because they are visually similar. This introduces **false positives** into the training set. If a model trains heavily on click data without cleaning, it may learn spurious correlations unrelated to visual similarity.

##### Option 3 — Self-Supervision (Data Augmentation)

We artificially create a positive image $p$ from the query image $q$ using **data augmentation** — applying random transformations such as:
- Random cropping
- Horizontal flipping
- Color jitter (brightness, contrast, saturation, hue)
- Gaussian blur
- Grayscale conversion

Frameworks like **SimCLR** and **MoCo** are built on this exact approach.

| Pros | Cons |
| :--- | :--- |
| Zero cost, no manual work | Augmented images ≠ truly distinct similar images |
| Not noisy — augmented images are always similar | Model may overfit to augmentation artifacts |
| Scales to billions of images | |

> [!info] SimCLR (Simple Framework for Contrastive Learning of Visual Representations)
> SimCLR creates two augmented views of the same image. The model is trained to maximize the similarity between embeddings of the two views while minimizing the similarity with embeddings of all other images in the batch (treated as negatives). This is a fully self-supervised approach — no human labels needed.

##### Which Approach Works Best?

In practice, we start with **self-supervision** (Option 3) for the following reasons:
1. There is no upfront cost — the process can be fully automated.
2. Frameworks like SimCLR have demonstrated strong performance when trained on large datasets.

Since we have access to **billions** of images, this approach is a good fit. We can then **fine-tune** using click data (after denoising it) or periodic human annotations to further close the quality gap.

> [!tip] Combining Methods
> The best systems combine all three approaches:
> 1. **Pre-train** with self-supervision on all available images.
> 2. **Fine-tune** with denoised click data (filter out clicks that seem irrelevant using heuristics like dwell time or re-click rate).
> 3. **Periodically audit** a small sample with human annotators to catch systematic errors.

### Choosing the Loss Function

The model takes images as input and produces an **embedding for each input image**. We denote the embedding of image $x$ as $E_x$.

The goal of training is to optimize the model parameters so that:
$$\text{sim}(E_q, E_p) \gg \text{sim}(E_q, E_{n_i}) \quad \forall i$$

i.e., the query-positive similarity is much higher than any query-negative similarity.

#### Contrastive Loss (InfoNCE / NT-Xent)

We compute the contrastive loss in three steps:

**Step 1 — Compute Similarities**: Calculate the dot product (or cosine similarity) between the query embedding $E_q$ and all other embeddings:

$$s_i = E_q \cdot E_i$$

> [!note] Euclidean Distance vs. Cosine Similarity
> **Euclidean distance** measures absolute distance in the embedding space: $d = \|E_q - E_i\|_2$. It works well in low dimensions, but suffers from the **curse of dimensionality** in high-dimensional spaces — all pairwise distances converge to the same value, making it hard to distinguish near from far.
> **Cosine similarity** is preferred for high-dimensional embeddings because it measures the **angle** between vectors, which is invariant to vector magnitude and more stable in high dimensions.

**Step 2 — Softmax**: Apply a softmax function over the computed similarity scores (scaled by temperature $\tau$):

$$p_i = \frac{\exp(s_i / \tau)}{\sum_j \exp(s_j / \tau)}$$

The temperature $\tau$ controls how "sharp" or "uniform" the distribution is. A lower $\tau$ makes the model more confident about hard positives and hard negatives.

**Step 3 — Cross-Entropy Loss**: The label vector has $1$ at the position of the positive image and $0$ everywhere else. We apply cross-entropy loss:

$$\mathcal{L} = -\log(p_{\text{positive}})$$

This penalizes the model when it assigns low probability to the correct (positive) image.

$$\mathcal{L}_{\text{InfoNCE}} = -\log \frac{\exp(\text{sim}(E_q, E_p) / \tau)}{\sum_{i=1}^{N} \exp(\text{sim}(E_q, E_i) / \tau)}$$

```
Embedding Layer Output:
 E_q = [0.2, -0.5, 0.8, ...]    (query)
 E_p = [0.3, -0.4, 0.7, ...]    (positive)
 E_n1= [0.9,  0.1, -0.2, ...]   (negative 1)
 E_n2= [-0.1, 0.8,  0.1, ...]   (negative 2)

Similarity Scores → Softmax → Cross-Entropy:
 sim(E_q, E_p)  = 0.95  → P(positive) = 0.90  [Ground Truth: 1]
 sim(E_q, E_n1) = 0.10  → P(n1)       = 0.05  [Ground Truth: 0]
 sim(E_q, E_n2) = 0.05  → P(n2)       = 0.05  [Ground Truth: 0]

Loss = -log(0.90) ≈ 0.105  (good — model is confident about the positive)
```

> [!tip] Using Pre-Trained Models
> Rather than training from scratch, consider leveraging a **pre-trained contrastive model** (e.g., a CLIP image encoder or a ResNet pre-trained on ImageNet with contrastive fine-tuning). Pre-trained models have already learned rich visual representations from massive datasets, dramatically reducing required training time and labeled data.

---

## Evaluation

### Offline Metrics

Offline evaluation is done with a labeled evaluation dataset. Each data point has:
- A query image
- Candidate images
- A **graded similarity score** (integer from $0$ to $5$) for each (query, candidate) pair
  - $0$: No similarity
  - $5$: Nearly identical visually and semantically

For each data point, we compare the ranking produced by the model against the ideal ranking (sorted by ground truth scores).

#### Mean Reciprocal Rank (MRR)

MRR measures the rank of the **first** relevant item in each output list:

$$\text{MRR} = \frac{1}{m} \sum_{i=1}^{m} \frac{1}{\text{rank}_i}$$

Where $m$ is the total number of output lists and $\text{rank}_i$ is the rank of the first relevant item in the $i$-th list.

> [!warning] Shortcoming of MRR
> MRR considers **only the first relevant item** and ignores all others. Two models with very different output quality can have the same MRR if their first relevant item appears at the same rank position. For visual search where we show many results, this is insufficient.

#### Recall@K

$$\text{Recall@K} = \frac{\text{Number of relevant items in top-K results}}{\text{Total relevant items in the full dataset}}$$

> [!warning] Shortcoming of Recall@K
> When the query image is a dog, there may be millions of dog images in the corpus. A system that returns 1,000 dog images when there are 10 million still has very low recall. The denominator is huge, making this metric impractical for open-domain visual search.
> Additionally, Recall@K does not measure **ranking quality** — it doesn't care whether the most similar image is shown first.

#### Precision@K

$$\text{Precision@K} = \frac{\text{Number of relevant items in top-K results}}{K}$$

> [!warning] Shortcoming of Precision@K
> Precision@K is not sensitive to **where** within the top-K list the relevant items appear. A list with the two relevant items at positions 1 and 2 has the same Precision@5 as a list with relevant items at positions 4 and 5. We lose ranking quality information.

#### Mean Average Precision (mAP)

**Average Precision (AP)** accounts for both precision and rank position. For a list of $K$ items:

$$\text{AP} = \frac{\sum_{k=1}^{K} \left( \text{Precision@k} \times \mathbb{1}[\text{item k is relevant}] \right)}{\text{Total relevant items}}$$

**Mean Average Precision (mAP)** averages AP over all $m$ query images:

$$\text{mAP} = \frac{1}{m} \sum_{i=1}^{m} \text{AP}_i$$

> [!warning] Shortcoming of mAP
> mAP assumes **binary** relevance — either an image is relevant or it is not. In visual search, similarity is graded (an image of a brown Labrador is more similar to a golden retriever than a photograph of a chair). Binary labels throw away this nuance.

#### Normalized Discounted Cumulative Gain (nDCG) ✅

**nDCG is the preferred metric** for visual search because it handles **graded relevance** and is sensitive to **rank position**.

**DCG (Discounted Cumulative Gain)**: Accumulates relevance scores from the top of the ranked list to the bottom, discounting items at lower ranks:

$$\text{DCG}_p = \sum_{i=1}^{p} \frac{\text{rel}_i}{\log_2(i + 1)}$$

Where $\text{rel}_i$ is the ground truth relevance score of the image at rank position $i$.

**IDCG (Ideal DCG)**: The DCG of the perfect ranking — items sorted by descending ground truth relevance.

**nDCG**: Normalizes the DCG against the ideal:

$$\text{nDCG}_p = \frac{\text{DCG}_p}{\text{IDCG}_p}$$

$\text{nDCG} \in [0, 1]$. A score of $1.0$ means the model produced the perfect ranking.

**Worked Example**:

Suppose the model returns 5 images in this order, with ground truth scores:

| Rank | Ground Truth Score ($\text{rel}_i$) | $\log_2(i+1)$ | Contribution |
| :--- | :--- | :--- | :--- |
| 1 | 0 | 1.000 | 0.000 |
| 2 | 5 | 1.585 | 3.155 |
| 3 | 1 | 2.000 | 0.500 |
| 4 | 4 | 2.322 | 1.722 |
| 5 | 2 | 2.585 | 0.774 |

$$\text{DCG}_5 = 0 + 3.155 + 0.500 + 1.722 + 0.774 = 6.151$$

The ideal ranking (5, 4, 2, 1, 0) gives:

$$\text{IDCG}_5 = \frac{5}{1.000} + \frac{4}{1.585} + \frac{2}{2.000} + \frac{1}{2.322} + \frac{0}{2.585} = 5 + 2.524 + 1 + 0.431 + 0 = 8.955$$

$$\text{nDCG}_5 = \frac{6.151}{8.955} \approx 0.687$$

> [!note] Shortcoming of nDCG
> nDCG requires **ground truth relevance scores**. These must be collected either via human annotation or via carefully constructed proxy labels. Where a good evaluation set doesn't exist, nDCG can't be computed reliably.

### Online Metrics

In production, we monitor the following live metrics:

**Click-Through Rate (CTR)**: The fraction of displayed images that users click on.

$$\text{CTR} = \frac{\text{Number of clicked images}}{\text{Total number of suggested images}}$$

A high CTR suggests that the system is returning visually relevant results. CTR is widely used in search and recommendation systems.

> [!warning] CTR Gaming
> CTR can be misleading if the top results are thumbnails with high contrast or unusual colors that attract clicks but are not actually similar. Always monitor CTR alongside engagement-depth metrics.

**Average time spent on suggested images**: Tracks how long users spend exploring the returned results daily, weekly, and monthly. When the search system is accurate, users engage more, and this metric increases.

---

## Serving

At serving time, the system returns a ranked list of similar images based on a query image. The serving layer consists of two distinct pipelines:
1. **Prediction pipeline** (online, latency-sensitive)
2. **Indexing pipeline** (offline, throughput-optimized)

### Prediction Pipeline

#### Embedding Generation Service

This service computes the embedding of the input query image:
1. Preprocesses the image (resize, normalize).
2. Passes it through the trained ML model (running on GPU/TPU instances).
3. Returns the embedding vector $E_q$.

The trained model is loaded from a model registry (e.g., MLflow, Vertex AI Model Registry) and served using a framework like TorchServe or TensorFlow Serving.

#### Nearest Neighbor Service

Once we have the query embedding $E_q$, we retrieve similar images from the embedding space using **Nearest Neighbor (NN) Search**.

**Formal definition**: Given a query point $q$ and a set of points $S$ in $N$-dimensional space, find the $K$ points in $S$ closest to $q$.

> [!note] Why Not Exact NN (Linear Search)?
> Exact NN — checking every single point — has time complexity $\mathcal{O}(N \times D)$ where $N$ is the number of images and $D$ is the embedding dimension.
> At 100 billion images with $D=256$, this means computing $25.6$ trillion multiplications per query. At sub-100ms latency requirements, this is completely infeasible. We need a smarter approach.

#### Re-Ranking Service

After the NN service returns a candidate set of $K$ images, the re-ranking service applies business logic before final presentation:
- Filters out **inappropriate or unsafe** content.
- Removes **private images** the user doesn't have permission to view.
- Removes **near-duplicate** images (same image watermarked or resized).
- Enforces **geographic content policies** (content blocked in certain regions).
- May apply a **lightweight re-ranking model** to further refine ordering.

### Indexing Pipeline

#### Indexing Service

All images on the platform must be indexed so the NN service can find them efficiently.

**Responsibilities of the indexing service**:
1. When a creator uploads a new image, it is sent to the indexing service via a message queue (e.g., Kafka).
2. The indexing service calls the embedding generation service to compute the image's embedding.
3. The embedding is inserted into the **index table** so it becomes discoverable by the NN service.

> [!note] Memory Overhead of Indexing
> Storing raw float32 embeddings for 100 billion images at $D=256$ dimensions requires:
> $$100 \times 10^9 \times 256 \times 4 \text{ bytes} = 102.4 \text{ TB}$$
> This is far too large for RAM. We use **vector quantization** and **product quantization** to compress embeddings significantly. See the ANN section below.

---

## Performance of Nearest Neighbor (NN) Algorithms

Nearest neighbor search is a core component of information retrieval, search, and recommendation systems. A slight improvement in its efficiency leads to significant overall performance improvement. Interviewers often deep-dive into this topic.

NN algorithms fall into two categories: **exact** and **approximate**.

### Exact Nearest Neighbor (Linear Search)

The simplest approach: compute the distance between the query point $q$ and every other point, then return the $K$ smallest distances.

$$\text{Time Complexity} = \mathcal{O}(N \times D)$$

Where $N$ is the total number of indexed images and $D$ is the embedding dimension.

At billion-scale $N$, linear time is far too slow for real-time search.

### Approximate Nearest Neighbor (ANN)

ANN algorithms trade a **small amount of accuracy** for dramatically faster search by using special data structures that avoid checking every point.

$$\text{Time Complexity} \approx \mathcal{O}(D \times \log N) \quad \text{(sublinear)}$$

ANN algorithms fall into three main categories:

#### Tree-Based ANN

Tree-based algorithms recursively partition the embedding space using hyperplanes (decision boundaries) to form a search tree. At query time, the algorithm traverses the tree to find the partition containing the query point, then searches only within that partition.

```
          Root Node
          /       \
   Left Branch   Right Branch
    /      \       /       \
  R1       R2   R3         R4
                 / \
               R5   R6
```

Typical algorithms:
- **Kd-tree**: Partitions by coordinate axis splits.
- **R-tree**: Partitions by bounding rectangles, well-suited for spatial data.
- **Annoy (Approximate Nearest Neighbor Oh Yeah)**: Builds multiple random-projection trees and searches across all of them.

> [!note] Tree-Based Limitation
> Tree-based methods degrade in very high-dimensional spaces (e.g., $D > 100$) due to the curse of dimensionality — the partition boundaries become ineffective and the algorithm degenerates toward linear search.

#### Locality-Sensitive Hashing (LSH)

LSH uses specialized hash functions to map high-dimensional points into **hash buckets**, such that similar points are likely to land in the **same bucket** with high probability.

At query time, we hash the query point $q$ and search only the points in the same bucket.

$$\text{LSH: } h(x) \approx h(x') \text{ with high probability if } x \approx x'$$

> [!info] Why LSH Works
> Standard hash functions (MD5, SHA-256) are designed to be collision-resistant — similar inputs produce very different outputs. LSH does the opposite: it intentionally creates collisions for nearby points. Random projections (e.g., SimHash, MinHash) are common implementations.

#### Clustering-Based ANN

These algorithms first cluster all points (e.g., using $K$-Means) into $C$ clusters. At query time:
1. Find the nearest cluster centroid(s) to $q$.
2. Search only the points within those clusters.

**Inverted File Index (IVF)** is the classic clustering-based approach:
- During indexing: run $K$-Means to create $C$ Voronoi cells. Each point is assigned to its nearest centroid.
- During search: probe the nearest $n_{\text{probe}}$ centroids (a tunable parameter) and search only within those cells.

> [!tip] Vector Quantization and Product Quantization (PQ)
> To reduce the RAM footprint for billions of vectors, we use compression:
>
> **Scalar/Vector Quantization**: Replace 32-bit floats with 8-bit integers, reducing memory by 4×.
>
> **Product Quantization (PQ)**: Split a $D$-dimensional vector into $M$ sub-vectors of size $D/M$. Run $K$-Means independently in each sub-space to produce $K^*$ centroid codes. Replace each sub-vector with the index of its nearest centroid. This can compress a 256-dim float32 vector (1024 bytes) down to $M \times \log_2(K^*)$ bits — often a **30–50× compression ratio**.
>
> **IVF-PQ** (Inverted File + Product Quantization) is the most widely deployed combination for billion-scale search.

### Which Algorithm Should We Use?

| | Exact NN | Tree-Based | LSH | Clustering-Based (IVF/IVF-PQ) | Graph-Based (HNSW) |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Accuracy** | 100% | High | Moderate | High | Very High |
| **Query Speed** | Slow (linear) | Fast (low-D) | Fast | Very Fast | Very Fast |
| **Memory** | $\mathcal{O}(ND)$ | High | Moderate | Low (with PQ) | High |
| **Build Time** | None | Moderate | Low | High (K-Means) | Very High |
| **High-D Performance** | Degrades | Degrades | OK | Good | Excellent |

For a visual search system at Pinterest scale:
- **Exact NN**: Good only for small datasets (< 1M images) or when exact results are legally required.
- **ANN**: The pragmatic choice. Results are approximate but the difference from exact NN is usually imperceptible to users.
- **For our system**: We use **IVF-PQ** for memory-efficient billion-scale indexing combined with **HNSW (Hierarchical Navigable Small World)** graphs for the highest-quality approximate search.

> [!info] HNSW (Hierarchical Navigable Small World)
> HNSW builds a multi-layer graph where:
> - The top layers have few nodes with long-range connections (for fast global navigation).
> - The bottom layers have all nodes with short-range connections (for fine-grained local search).
>
> Search starts at the top layer and greedily navigates toward the query point, progressively moving to lower layers. This achieves $\mathcal{O}(\log N)$ expected query time with extremely high recall.
>
> HNSW is implemented in **Faiss** (Meta AI) and **ScaNN** (Google) — the two most widely used production-grade ANN libraries.

---

## Further Reading & Libraries

- **Faiss** (Meta AI): [github.com/facebookresearch/faiss](https://github.com/facebookresearch/faiss) — supports IVF, IVF-PQ, HNSW at billion scale.
- **ScaNN** (Google): Optimized for high-recall ANN on TPUs and CPUs.
- **SimCLR**: Self-supervised contrastive learning framework (Chen et al., 2020).
- **MoCo** (Momentum Contrast): Memory-efficient self-supervised learning (He et al., 2020).
- **CLIP** (OpenAI): Cross-modal image-text embedding that can be adapted for visual search.

---

## Key Takeaways

| Design Decision | Recommendation |
| :--- | :--- |
| **ML Objective** | Representation learning — map images into an embedding space |
| **Model Architecture** | ResNet (efficiency) or ViT (quality); use pre-trained backbones |
| **Training Approach** | Self-supervised contrastive learning (SimCLR/MoCo) + fine-tune on click data |
| **Loss Function** | InfoNCE / NT-Xent contrastive loss with temperature scaling |
| **Offline Metric** | **nDCG** (handles graded relevance and rank sensitivity) |
| **Online Metric** | CTR + engagement time |
| **Indexing** | IVF-PQ for memory efficiency at billion scale |
| **Retrieval** | HNSW for high-recall ANN search; use Faiss or ScaNN |
| **Data Labeling** | Start with self-supervision, enrich with denoised click data |
| **Freshness** | Kafka-driven async indexing pipeline with near-real-time updates |