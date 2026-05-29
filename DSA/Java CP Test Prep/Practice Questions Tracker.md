---
title: "Java DSA & CP Test Prep Tracker"
tags:
  - dsa
  - java
  - competitive-programming
  - test-prep
  - trees
  - graphs
  - heaps
  - union-find
created: 2026-05-29
type: study-note
---

# Java DSA & CP Test Practice Tracker

This tracker contains curated practice problems on LeetCode and GeeksforGeeks (GFG) matching your test syllabus. It also includes key **Java-specific notes** to help you transition from Python.

---

## 💡 Essential Java Cheat Sheet for Python Transition

### 1. Heaps (Priority Queue)
In Python, you use `heapq`. In Java, you use `java.util.PriorityQueue`.
* **Min Heap** (Default):
  ```java
  PriorityQueue<Integer> minHeap = new PriorityQueue<>();
  minHeap.add(10); // Insert
  int top = minHeap.peek(); // Access minimum element
  int removed = minHeap.poll(); // Remove minimum element
  ```
* **Max Heap**:
  ```java
  PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
  // Or using a custom comparator lambda:
  PriorityQueue<Integer> maxHeap2 = new PriorityQueue<>((a, b) -> b - a);
  ```

### 2. Graph Representations (Adjacency List)
In Python, you use a dictionary of lists. In Java, you use arrays of lists or nested lists.
```java
// List of Lists representation
List<List<Integer>> adj = new ArrayList<>();
for (int i = 0; i < V; i++) {
    adj.add(new ArrayList<>());
}
// Adding an edge from u to v
adj.get(u).add(v);
```

### 3. Tree Nodes (Java Class Syntax)
Unlike Python's dynamic classes, Java requires explicit types.
```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int val) {
        this.val = val;
        this.left = null;
        this.right = null;
    }
}
```

---

## 📂 Practice Problems Tracker

---

### Unit 1: Heaps (Priority Queues)

| Topic | Problem Description | Source & Link | Status |
| :--- | :--- | :--- | :---: |
| **Heap Basics** | Implement Min Heap operations manually. | 🟢 [GFG: Min Heap Implementation](https://www.geeksforgeeks.org/problems/min-heap/1) | `- [ ]` |
| | Implement Max Heap operations manually. | 🟢 [GFG: Max Heap Implementation](https://www.geeksforgeeks.org/problems/binary-heap-operations/1) | `- [ ]` |
| **K'th Largest** | Find the Kth largest element in an array. | 🟡 [LeetCode 215: Kth Largest Element](https://leetcode.com/problems/kth-largest-element-in-an-array/) <br> 🟢 [GFG: K Largest Elements](https://www.geeksforgeeks.org/problems/k-largest-elements3736/1) | `- [ ]` |
| **Nearly Sorted** | Sort an almost sorted array where each element is at most $k$ away. | 🟢 [GFG: Nearly Sorted Algorithm](https://www.geeksforgeeks.org/problems/nearly-sorted-1587115620/1) | `- [ ]` |
| **Rope Connection** | Connect $n$ ropes with minimum cost (Huffman coding principle). | 🟢 [GFG: Minimum Cost of Ropes](https://www.geeksforgeeks.org/problems/minimum-cost-of-ropes-1587115620/1) | `- [ ]` |

---

### Unit 2: Disjoint Set Union (DSU)

| Topic | Problem Description | Source & Link | Status |
| :--- | :--- | :--- | :---: |
| **Union-Find** | Basic Union-Find with rank and path compression. | 🟢 [GFG: Disjoint Set (Union-Find)](https://www.geeksforgeeks.org/problems/disjoint-set-union-find/1) | `- [ ]` |
| **Connected Components** | Count connected groups using DSU. | 🟡 [LeetCode 547: Number of Provinces](https://leetcode.com/problems/number-of-provinces/) | `- [ ]` |

---

### Unit 3: Binary Trees

| Topic | Problem Description | Source & Link | Status |
| :--- | :--- | :--- | :---: |
| **Inorder** | Iterative (non-recursive) Inorder Traversal. | 🟢 [LeetCode 94: Binary Tree Inorder](https://leetcode.com/problems/binary-tree-inorder-traversal/) | `- [ ]` |
| **Preorder** | Iterative (non-recursive) Preorder Traversal. | 🟢 [LeetCode 144: Binary Tree Preorder](https://leetcode.com/problems/binary-tree-preorder-traversal/) | `- [ ]` |
| **Postorder** | Iterative (non-recursive) Postorder Traversal. | 🟢 [LeetCode 145: Binary Tree Postorder](https://leetcode.com/problems/binary-tree-postorder-traversal/) | `- [ ]` |
| **Level Order** | Breadth-First search traversal of tree. | 🟡 [LeetCode 102: Binary Tree Level Order](https://leetcode.com/problems/binary-tree-level-order-traversal/) | `- [ ]` |
| **Reconstruction** | Generate Postorder from Inorder and Preorder. | 🟡 [GFG: Postorder from Inorder/Preorder](https://www.geeksforgeeks.org/problems/postorder-traversal-from-given-inorder-and-preorder-traversals/1) | `- [ ]` |

---

### Unit 4: Advanced Binary Tree Problems

| Topic | Problem Description | Source & Link | Status |
| :--- | :--- | :--- | :---: |
| **Inorder Successor**| Populate inorder successor for all nodes. | 🟡 [GFG: Populate Inorder Successor](https://www.geeksforgeeks.org/problems/populate-inorder-successor-for-all-nodes/1) | `- [ ]` |
| **Spiral Level Order** | Level order traversal in zig-zag/spiral form. | 🟡 [LeetCode 103: Zigzag Level Order](https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/) <br> 🟡 [GFG: Spiral Level Order](https://www.geeksforgeeks.org/problems/level-order-traversal-in-spiral-form/1) | `- [ ]` |
| **Boundary Traversal**| Traverse leaves, left boundary, and right boundary. | 🔴 [GFG: Boundary Traversal](https://www.geeksforgeeks.org/problems/boundary-traversal-of-binary-tree/1) | `- [ ]` |
| **LCA** | Find Lowest Common Ancestor. | 🟡 [LeetCode 236: LCA of a Binary Tree](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/) <br> 🟡 [GFG: LCA in Binary Tree](https://www.geeksforgeeks.org/problems/lowest-common-ancestor-in-a-binary-tree/1) | `- [ ]` |
| **Diameter** | Length of the longest path between any two nodes. | 🟢 [LeetCode 543: Diameter of Tree](https://leetcode.com/problems/diameter-of-binary-tree/) <br> 🟡 [GFG: Diameter of a Binary Tree](https://www.geeksforgeeks.org/problems/diameter-of-a-binary-tree/1) | `- [ ]` |
| **Height Balanced** | Determine if height difference of left/right subtrees $\le 1$. | 🟢 [LeetCode 110: Balanced Binary Tree](https://leetcode.com/problems/balanced-binary-tree/) | `- [ ]` |
| **BST to Min Heap** | Convert a BST into a Min Heap satisfying structure constraints. | 🟡 [GFG: Convert BST to Min Heap](https://www.geeksforgeeks.org/problems/convert-bst-to-min-heap/1) | `- [ ]` |

---

### Unit 5: Graph Algorithms (Representations & Eulerian/Hamiltonian)

| Topic | Problem Description | Source & Link | Status |
| :--- | :--- | :--- | :---: |
| **BFS** | Breadth-First Search traversal of a graph. | 🟢 [GFG: BFS of Graph](https://www.geeksforgeeks.org/problems/bfs-traversal-of-graph/1) | `- [ ]` |
| **DFS** | Depth-First Search traversal of a graph. | 🟢 [GFG: DFS of Graph](https://www.geeksforgeeks.org/problems/depth-first-traversal-for-a-graph/1) | `- [ ]` |
| **Eulerian** | Check if graph contains Eulerian Path/Circuit. | 🟡 [GFG: Eulerian Path and Circuit](https://www.geeksforgeeks.org/problems/eulerian-path-and-circuit/1) | `- [ ]` |
| **Hamiltonian** | Check if graph contains a Hamiltonian Path. | 🟡 [GFG: Hamiltonian Path](https://www.geeksforgeeks.org/problems/hamiltonian-path3822/1) | `- [ ]` |

---

### Unit 6: Advanced Graph Problems & Algorithms

| Topic | Problem Description | Source & Link | Status |
| :--- | :--- | :--- | :---: |
| **Dijkstra** | Shortest path from source on positive weighted graph. | 🟡 [GFG: Dijkstra Algorithm](https://www.geeksforgeeks.org/problems/implementing-dijkstra-set-1-adjacency-matrix/1) | `- [ ]` |
| **Bellman-Ford** | Shortest path from source with negative weights (and cycle check). | 🟡 [GFG: Bellman-Ford Vector](https://www.geeksforgeeks.org/problems/distance-from-the-source-bellman-ford-vector/1) | `- [ ]` |
| **MST** | Prim's or Kruskal's Minimum Spanning Tree. | 🟡 [GFG: Minimum Spanning Tree](https://www.geeksforgeeks.org/problems/minimum-spanning-tree/1) | `- [ ]` |
| **Graph Coloring** | Check if graph is colorable using $m$ colors (backtracking). | 🔴 [GFG: m Coloring Problem](https://www.geeksforgeeks.org/problems/m-coloring-problem-1587115620/1) | `- [ ]` |
| **Bipartite** | Check if graph nodes can be split into 2 independent sets. | 🟡 [LeetCode 785: Is Graph Bipartite?](https://leetcode.com/problems/is-graph-bipartite/) <br> 🟡 [GFG: Bipartite Graph](https://www.geeksforgeeks.org/problems/bipartite-graph/1) | `- [ ]` |
| **Cycle Detection** | Detect cycles in undirected and directed graphs. | 🟡 [GFG: Cycle in Undirected Graph](https://www.geeksforgeeks.org/problems/detect-cycle-in-an-undirected-graph/1) <br> 🟡 [GFG: Cycle in Directed Graph](https://www.geeksforgeeks.org/problems/detect-cycle-in-a-directed-graph/1) | `- [ ]` |
| **Strongly Connected**| Find SCCs using Kosaraju's Algorithm. | 🟡 [GFG: Kosaraju's Algorithm](https://www.geeksforgeeks.org/problems/strongly-connected-components-kosarajus-algo/1) | `- [ ]` |
| **0/1 BFS** | Shortest path/distance to nearest cell with value 1. | 🟡 [LeetCode 542: 01 Matrix](https://leetcode.com/problems/01-matrix/) <br> 🟡 [GFG: Distance of nearest cell having 1](https://www.geeksforgeeks.org/problems/distance-of-nearest-cell-having-1-1587115620/1) | `- [ ]` |
| **Snake & Ladder** | Find the minimum moves to win the game (BFS on grid). | 🟡 [LeetCode 909: Snakes and Ladders](https://leetcode.com/problems/snakes-and-ladders/) <br> 🟡 [GFG: Snake and Ladder Problem](https://www.geeksforgeeks.org/problems/snake-and-ladder-problem4816/1) | `- [ ]` |
