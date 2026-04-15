#concept/practice 


## 1. What is DSU?

**Disjoint Set Union** (also called **Union-Find**) is a data structure that keeps track of elements partitioned into disjoint (non‑overlapping) sets.  
It supports two main operations:

- **Find** – determine which set a particular element belongs to (returns a representative / root).
- **Union** – merge two sets into one.

In **graph problems** DSU is extremely useful for:
- Maintaining connected components dynamically.
- Detecting cycles in an undirected graph.
- Finding if two nodes are in the same component.
- Building MST (Kruskal’s algorithm).

---

## 2. Core Idea – Representing Sets as Trees

We can think of each set as a **tree**:
- Each element has a **parent** pointer.
- The **root** of the tree is the representative of the set.
- Initially, every element is its own parent (each element is a separate set).

Example with 5 elements:  
`parent[0] = 0, parent[1] = 1, ..., parent[4] = 4`.

---

## 3. Basic Operations (Naive Implementation)

```cpp
vector<int> parent;

void makeSet(int n) {
    parent.resize(n);
    for (int i = 0; i < n; i++)
        parent[i] = i;
}

int find(int x) {
    if (parent[x] == x)
        return x;
    return find(parent[x]);   // climb up recursively
}

void unionSets(int x, int y) {
    int rootX = find(x);
    int rootY = find(y);
    if (rootX != rootY)
        parent[rootY] = rootX;   // attach one root under the other
}
```

**Problem with naive approach:**  
The tree can become a tall chain → `find` takes O(n) in worst case.

---

## 4. Optimisations (make DSU near‑constant time)

### 4.1 Path Compression (flatten the tree)

During `find`, we make every visited node point directly to the root.  
This dramatically speeds up future finds.

```cpp
int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);   // compress path
    return parent[x];
}
```

### 4.2 Union by Rank / Size

Keep trees shallow by attaching the smaller tree under the larger one.

- **Union by rank**: store the "height" (rank) of each tree. Attach the shorter tree under the taller one.
- **Union by size**: store the number of elements. Attach the smaller set under the larger one.

Both give almost identical performance. I’ll use **size** because it’s intuitive.

```cpp
vector<int> parent, sz;   // sz[i] = size of set whose root is i

void makeSet(int n) {
    parent.resize(n);
    sz.resize(n, 1);
    for (int i = 0; i < n; i++)
        parent[i] = i;
}

int find(int x) {
    if (parent[x] != x)
        parent[x] = find(parent[x]);
    return parent[x];
}

void unionSets(int x, int y) {
    int rootX = find(x);
    int rootY = find(y);
    if (rootX == rootY) return;
    
    if (sz[rootX] < sz[rootY]) {
        swap(rootX, rootY);
    }
    parent[rootY] = rootX;
    sz[rootX] += sz[rootY];
}
```

---

## 5. Complexity

With **both** path compression and union by rank/size:

- **Amortised time** per operation: **O(α(n))**  
  where α(n) is the inverse Ackermann function – it grows so slowly that for all practical inputs it’s ≤ 4.  
  → effectively **constant time**.

---

## 6. Complete C++ DSU Class (my template)

```cpp
class DSU {
private:
    vector<int> parent, size;
public:
    DSU(int n) {
        parent.resize(n);
        size.assign(n, 1);
        for (int i = 0; i < n; i++) parent[i] = i;
    }
    
    int find(int x) {
        if (parent[x] != x)
            parent[x] = find(parent[x]);
        return parent[x];
    }
    
    bool unite(int x, int y) {
        int rx = find(x), ry = find(y);
        if (rx == ry) return false;   // already in same set
        if (size[rx] < size[ry]) swap(rx, ry);
        parent[ry] = rx;
        size[rx] += size[ry];
        return true;
    }
    
    bool connected(int x, int y) {
        return find(x) == find(y);
    }
    
    int getSize(int x) {
        return size[find(x)];
    }
};
```

---

## 7. Applying DSU to Graphs

### 7.1 Cycle Detection in an Undirected Graph

For each edge `(u, v)`:
- If `find(u) == find(v)` → a cycle exists.
- Else `union(u, v)`.

```cpp
bool hasCycle(vector<pair<int,int>>& edges, int n) {
    DSU dsu(n);
    for (auto [u, v] : edges) {
        if (!dsu.unite(u, v))
            return true;   // cycle found
    }
    return false;
}
```

### 7.2 Kruskal’s Minimum Spanning Tree

Sort edges by weight. Iterate from smallest to largest – if the two vertices are in different components, take the edge and union them.  
DSU makes this incredibly efficient.

```cpp
int kruskalMST(vector<tuple<int,int,int>>& edges, int n) {
    sort(edges.begin(), edges.end());   // weight first
    DSU dsu(n);
    int totalWeight = 0, edgesTaken = 0;
    for (auto [w, u, v] : edges) {
        if (dsu.unite(u, v)) {
            totalWeight += w;
            edgesTaken++;
            if (edgesTaken == n-1) break;
        }
    }
    return totalWeight;
}
```

---

## 8. Things I Learned in Between (Tips & Pitfalls)

- **0‑based vs 1‑based indexing** – be careful. I usually store parent array of size `n` and map input to `0..n-1`.
- **DSU does NOT support splitting sets** – it only merges. If you need to undo unions, you need a persistent / rollback DSU.
- **Path compression makes the tree flat** but it also means you can’t rely on parent pointers for anything except `find`.
- **Union by size** is my favourite – easy to implement and gives the same guarantee as rank.
- **Memory**: just two integer arrays, very cheap.
- **Edge cases**: empty graph, self‑loops (an edge from a node to itself always creates a cycle – DSU can detect that because `find(u)==find(v)` will be true immediately).
- **When you call `find()` on a node, it updates the parent of every node along the path** – that’s the whole magic.

---

## 9. Practice Problems (to really understand DSU)

1. **Number of Provinces** (LeetCode 547) – classic count components.
2. **Redundant Connection** (LeetCode 684) – find the first edge that creates a cycle.
3. **Accounts Merge** (LeetCode 721) – DSU on strings (use a hash map).
4. **Kruskal’s MST** – implement from scratch on a small graph.
5. **Detect cycle in a 2D grid** – DSU on flattened indices.

---

## 10. Final Summary (for my revision)

| Operation | Without optimisation | With path compression + union by size |
|-----------|---------------------|----------------------------------------|
| Find      | O(n) (chain)        | O(α(n)) ≈ O(1)                         |
| Union     | O(n)                | O(α(n))                                |

**DSU is my go‑to tool whenever I need to maintain disjoint sets under union operations.**  
It’s simple to code, lightning fast, and appears in many graph problems – especially connectivity, cycles, and MST.
