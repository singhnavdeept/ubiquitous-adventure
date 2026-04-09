#problems/deepdive
# Solving "Redundant Connection" (LeetCode 684) using DSU

## Problem Statement (simplified)

We are given a graph that started as a tree (n nodes, n-1 edges) and then one extra edge is added. The graph has `n` nodes labelled `1` to `n`. The input is a list of `n` edges. We need to return the **last edge** that, if removed, makes the graph a tree (i.e., the edge that creates a cycle). If multiple edges could be removed, return the one that appears last in the input.

**Example:**  
`edges = [[1,2], [2,3], [3,4], [1,4], [1,5]]`  
Output: `[1,4]` because adding `[1,4]` creates a cycle (1-2-3-4-1) and it's the last such edge.

---

## Thought Process & Step-by-Step Reasoning

### Why DSU?
- A tree has exactly `n-1` edges and is acyclic.
- Adding one extra edge to a tree creates **exactly one cycle**.
- As we add edges one by one, the moment we see an edge whose two endpoints are **already connected** in the DSU, that edge completes a cycle.
- Because we want the **last** edge that creates a cycle (if multiple), we simply return the first edge for which `find(u) == find(v)` as we iterate from the beginning? Wait – careful: The problem says: "If there are multiple answers, return the answer that occurs last in the input." That means we should consider all edges, but the one we return must be the one that appears last among those that create cycles. However, in a graph that is a tree + one edge, there is **exactly one cycle** and therefore exactly one edge that creates a cycle. Actually, there could be more? Let's think:

If we add an extra edge to a tree, that edge creates exactly one cycle. But in the input order, earlier edges might have formed a tree, and the redundant edge is the one that creates the cycle. That redundant edge is unique. However, the problem statement says "If there are multiple answers" – that might refer to graphs that are not necessarily a tree+one edge? The problem guarantees that the input graph is a tree plus one extra edge, so there is exactly one cycle. But the cycle can contain multiple edges, and any one of them, if removed, would break the cycle. So there are multiple candidates. Which one to return? The one that appears last in the input.

So we cannot just return the first edge that creates a cycle – because that edge might be the first among the cycle edges, not the last. We need to consider **all** edges and find which one is the last in the input that is part of the cycle.

But there is a clever DSU approach: As we process edges in order, we skip adding an edge if it would form a cycle – that edge is a candidate. But if we skip it, we might miss later edges that also form a cycle? Actually in a tree+one-edge graph, there is only one cycle. So as we add edges, the first time we see an edge that creates a cycle, that edge is the only one that will create a cycle. So we can return it. Wait, that contradicts "multiple answers". Let's check LeetCode 684 carefully.

The problem says: "The given graph is a tree plus one edge." So the graph has exactly n edges and n nodes. The cycle length could be >2. Any edge in that cycle, if removed, makes the graph a tree. So there are multiple possible edges to remove. But we are asked to return the one that appears **last** in the input. So the first edge that creates a cycle is not necessarily the last in input among cycle edges. Example:

Edges: `[[1,2], [2,3], [3,1], [1,4]]`  
- Add 1-2 (ok)  
- Add 2-3 (ok)  
- Add 3-1 (creates cycle 1-2-3-1) -> this is a candidate (position 2, 0-index)  
- Add 1-4 (ok)  

Now the cycle edges are: [1,2], [2,3], [3,1]. The last in input among these is [3,1] (index 2). So we should return [3,1]. If we returned the first cycle edge we found, we'd return [3,1] anyway because it's the first cycle edge. So in this case it's the same. But consider another order:

Edges: `[[1,2], [1,3], [2,3], [1,4]]`  
- Add 1-2  
- Add 1-3  
- Add 2-3 -> creates cycle (1-2-3-1) -> candidate (index 2)  
- Add 1-4  

Cycle edges: [1,2], [1,3], [2,3]. Last in input is [2,3] (index 2). So again the first cycle edge is the last among cycle edges. Actually, because the cycle is formed only when the last edge of that cycle is added, that last edge is always the one that appears **last** among the cycle edges in the input order (since all previous edges in the cycle were added earlier). So the edge that causes the cycle is exactly the one we want. So we can just return the first edge for which `find(u)==find(v)`.

Thus the simple approach works: iterate edges, if they connect two already connected nodes, that edge is the redundant one. Return it.

So we'll implement that.

---

## Step-by-Step Algorithm

1. Initialize DSU with `n+1` nodes (since nodes are 1-indexed).
2. For each edge `[u, v]` in the given list:
   - If `find(u) == find(v)`, then adding this edge creates a cycle → return `[u, v]`.
   - Else, `union(u, v)`.
3. (The problem guarantees there will be a redundant edge, so we always find it inside the loop.)

---

## C++ Code with Detailed Comments

```cpp
#include <vector>
using namespace std;

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
        // Path compression: make every node point directly to the root
        if (parent[x] != x)
            parent[x] = find(parent[x]);
        return parent[x];
    }
    
    bool unite(int x, int y) {
        int rootX = find(x), rootY = find(y);
        if (rootX == rootY) return false; // already connected
        
        // Union by size: attach smaller tree under larger tree
        if (size[rootX] < size[rootY]) swap(rootX, rootY);
        parent[rootY] = rootX;
        size[rootX] += size[rootY];
        return true;
    }
    
    bool connected(int x, int y) {
        return find(x) == find(y);
    }
};

class Solution {
public:
    vector<int> findRedundantConnection(vector<vector<int>>& edges) {
        int n = edges.size(); // number of edges = number of nodes (since tree + one edge)
        DSU dsu(n + 1);       // nodes are 1..n, so size n+1, index 0 unused
        
        for (auto& edge : edges) {
            int u = edge[0], v = edge[1];
            // If u and v are already in the same component, this edge creates a cycle
            if (dsu.connected(u, v)) {
                return {u, v};
            }
            // Otherwise, merge their components
            dsu.unite(u, v);
        }
        // According to problem constraints, we will always return inside the loop
        return {};
    }
};
```

---

## Notes on Why Each Step is Done

| Code / Step | Why we do it |
|-------------|--------------|
| `DSU dsu(n + 1)` | Nodes are labelled from 1 to n. We ignore index 0 for simplicity. Using `n+1` avoids off-by-one errors. |
| `find` with path compression | Without path compression, `find` could be O(n) in worst case. Path compression makes future finds nearly O(1). |
| `unite` with union by size | Attaching the smaller tree under the larger one keeps tree height low. Combined with path compression, gives almost constant time. |
| `if (dsu.connected(u, v)) return {u, v};` | If two nodes are already connected, adding this edge creates a cycle. Because the graph started as a tree plus one edge, the first such edge we encounter is the redundant one (and it will be the last among cycle edges in input order, as reasoned). |
| `dsu.unite(u, v)` | Merges the two components after confirming they were separate. This builds the spanning forest. |

---

## Complexity Analysis

- **Time:** O(n * α(n)) ≈ O(n) for processing n edges. Each operation is nearly constant.
- **Space:** O(n) for parent and size arrays.

---

## Dry Run on Example

`edges = [[1,2], [2,3], [3,4], [1,4], [1,5]]`, n=5.

- Start: each node separate.
- Edge [1,2]: 1 and 2 not connected → union(1,2). Components: {1,2}, {3}, {4}, {5}
- Edge [2,3]: 2 in {1,2}, 3 in {3} → not connected → union. Now {1,2,3}, {4}, {5}
- Edge [3,4]: 3 in {1,2,3}, 4 in {4} → union. Now {1,2,3,4}, {5}
- Edge [1,4]: 1 and 4 both in same component → connected → return [1,4]. Correct.

---

## Final Thought

DSU is perfect for this problem because we only need to detect when adding an edge connects two already‑connected nodes – that’s exactly the redundant edge. The implementation is short and efficient.