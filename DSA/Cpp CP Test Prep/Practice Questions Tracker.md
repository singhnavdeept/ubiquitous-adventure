---
title: "C++ DSA & CP Test Prep Tracker"
tags:
  - dsa
  - cpp
  - competitive-programming
  - test-prep
  - trees
  - graphs
  - heaps
  - union-find
created: 2026-05-30
type: study-note
---

# C++ DSA & CP Test Practice Tracker

This tracker contains **50 curated non-premium LeetCode questions** matching your syllabus topics, along with a C++ DSA quick reference guide.

---

## 💡 C++ DSA Quick Reference (STL Integration)

### 1. Heaps (Priority Queues)
In C++, you use `<queue>`'s `std::priority_queue`.
* **Max Heap** (Default):
  ```cpp
  #include <queue>
  std::priority_queue<int> maxHeap;
  maxHeap.push(10); // Insert
  int top = maxHeap.top(); // Get maximum element (O(1))
  maxHeap.pop(); // Remove maximum element (O(log N))
  ```
* **Min Heap**:
  ```cpp
  #include <queue>
  #include <vector>
  std::priority_queue<int, std::vector<int>, std::greater<int>> minHeap;
  ```

### 2. Graph Representations (Adjacency List)
```cpp
#include <vector>

// V is the number of vertices
int V = 5;
std::vector<std::vector<int>> adj(V);

// Adding a directed edge from u to v
adj[u].push_back(v);

// Adding an undirected edge
adj[u].push_back(v);
adj[v].push_back(u);
```

### 3. Tree Nodes (Struct Definition)
```cpp
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};
```

---

## 📂 50 Curated Non-Premium LeetCode Questions

---

### Unit 1: Heaps (Priority Queues) — 8 Questions

| No. | Topic | LeetCode Problem | Difficulty | Link | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| 1 | **Max Heap** | Last Stone Weight (LC 1046) | Easy | [LeetCode 1046](https://leetcode.com/problems/last-stone-weight/) | `- [ ]` |
| 2 | **Kth Largest** | Kth Largest Element in an Array (LC 215) | Medium | [LeetCode 215](https://leetcode.com/problems/kth-largest-element-in-an-array/) | `- [ ]` |
| 3 | **Frequency Sorting**| Top K Frequent Elements (LC 347) | Medium | [LeetCode 347](https://leetcode.com/problems/top-k-frequent-elements/) | `- [ ]` |
| 4 | **Multi-way Merge** | Kth Smallest Element in a Sorted Matrix (LC 378) | Medium | [LeetCode 378](https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/) | `- [ ]` |
| 5 | **Two-Heap Pattern** | Find Median from Data Stream (LC 295) | Hard | [LeetCode 295](https://leetcode.com/problems/find-median-from-data-stream/) | `- [ ]` |
| 6 | **Min-Cost Tasking** | Single-Threaded CPU (LC 1834) | Medium | [LeetCode 1834](https://leetcode.com/problems/single-threaded-cpu/) | `- [ ]` |
| 7 | **Custom Sorting** | The K Weakest Rows in a Matrix (LC 1337) | Easy | [LeetCode 1337](https://leetcode.com/problems/the-k-weakest-rows-in-a-matrix/) | `- [ ]` |
| 8 | **Greedy Scheduler** | Task Scheduler (LC 621) | Medium | [LeetCode 621](https://leetcode.com/problems/task-scheduler/) | `- [ ]` |

---

### Unit 2: Disjoint Set Union (DSU) — 7 Questions

| No. | Topic | LeetCode Problem | Difficulty | Link | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| 9 | **Components** | Number of Provinces (LC 547) | Medium | [LeetCode 547](https://leetcode.com/problems/number-of-provinces/) | `- [ ]` |
| 10 | **Cycle Detection** | Redundant Connection (LC 684) | Medium | [LeetCode 684](https://leetcode.com/problems/redundant-connection/) | `- [ ]` |
| 11 | **Set Merging** | Accounts Merge (LC 721) | Medium | [LeetCode 721](https://leetcode.com/problems/accounts-merge/) | `- [ ]` |
| 12 | **Grid Union** | Most Stones Removed with Same Row/Col (LC 947) | Medium | [LeetCode 947](https://leetcode.com/problems/most-stones-removed-with-same-row-or-column/) | `- [ ]` |
| 13 | **Equivalence Check**| Satisfiability of Equality Equations (LC 990) | Medium | [LeetCode 990](https://leetcode.com/problems/satisfiability-of-equality-equations/) | `- [ ]` |
| 14 | **Network Redundancy**| Number of Ops to Connect Network (LC 1319) | Medium | [LeetCode 1319](https://leetcode.com/problems/number-of-operations-to-make-network-connected/) | `- [ ]` |
| 15 | **Component Sort** | Smallest String With Swaps (LC 1202) | Medium | [LeetCode 1202](https://leetcode.com/problems/smallest-string-with-swaps/) | `- [ ]` |

---

### Unit 3: Binary Trees — 8 Questions

| No. | Topic | LeetCode Problem | Difficulty | Link | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| 16 | **Inorder** | Binary Tree Inorder Traversal (LC 94) | Easy | [LeetCode 94](https://leetcode.com/problems/binary-tree-inorder-traversal/) | `- [ ]` |
| 17 | **Preorder** | Binary Tree Preorder Traversal (LC 144) | Easy | [LeetCode 144](https://leetcode.com/problems/binary-tree-preorder-traversal/) | `- [ ]` |
| 18 | **Postorder** | Binary Tree Postorder Traversal (LC 145) | Easy | [LeetCode 145](https://leetcode.com/problems/binary-tree-postorder-traversal/) | `- [ ]` |
| 19 | **Level Order** | Binary Tree Level Order Traversal (LC 102) | Medium | [LeetCode 102](https://leetcode.com/problems/binary-tree-level-order-traversal/) | `- [ ]` |
| 20 | **Reconstruction** | Construct Tree from Preorder & Inorder (LC 105) | Medium | [LeetCode 105](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/) | `- [ ]` |
| 21 | **Height** | Maximum Depth of Binary Tree (LC 104) | Easy | [LeetCode 104](https://leetcode.com/problems/maximum-depth-of-binary-tree/) | `- [ ]` |
| 22 | **Symmetry** | Same Tree (LC 100) | Easy | [LeetCode 100](https://leetcode.com/problems/same-tree/) | `- [ ]` |
| 23 | **Tree Mutation** | Invert Binary Tree (LC 226) | Easy | [LeetCode 226](https://leetcode.com/problems/invert-binary-tree/) | `- [ ]` |

---

### Unit 4: Advanced Binary Tree Problems — 9 Questions

| No. | Topic | LeetCode Problem | Difficulty | Link | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| 24 | **Spiral Order** | Binary Tree Zigzag Level Order (LC 103) | Medium | [LeetCode 103](https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/) | `- [ ]` |
| 25 | **LCA** | Lowest Common Ancestor of a Tree (LC 236) | Medium | [LeetCode 236](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/) | `- [ ]` |
| 26 | **Diameter** | Diameter of Binary Tree (LC 543) | Easy | [LeetCode 543](https://leetcode.com/problems/diameter-of-binary-tree/) | `- [ ]` |
| 27 | **Height Balanced** | Balanced Binary Tree (LC 110) | Easy | [LeetCode 110](https://leetcode.com/problems/balanced-binary-tree/) | `- [ ]` |
| 28 | **Structure Alter** | Flatten Binary Tree to Linked List (LC 114) | Medium | [LeetCode 114](https://leetcode.com/problems/flatten-binary-tree-to-linked-list/) | `- [ ]` |
| 29 | **Leaf Paths** | Path Sum (LC 112) | Easy | [LeetCode 112](https://leetcode.com/problems/path-sum/) | `- [ ]` |
| 30 | **Left Child Sum** | Sum of Left Leaves (LC 404) | Easy | [LeetCode 404](https://leetcode.com/problems/sum-of-left-leaves/) | `- [ ]` |
| 31 | **BST Validation** | Validate Binary Search Tree (LC 98) | Medium | [LeetCode 98](https://leetcode.com/problems/validate-binary-search-tree/) | `- [ ]` |
| 32 | **BST Kth Smallest**| Kth Smallest Element in a BST (LC 230) | Medium | [LeetCode 230](https://leetcode.com/problems/kth-smallest-element-in-a-bst/) | `- [ ]` |

---

### Unit 5: Graph Algorithms (Traversals & Euler/Hamilton) — 8 Questions

| No. | Topic | LeetCode Problem | Difficulty | Link | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| 33 | **Degree Analysis** | Find Center of Star Graph (LC 1791) | Easy | [LeetCode 1791](https://leetcode.com/problems/find-center-of-star-graph/) | `- [ ]` |
| 34 | **Connectivity** | Find if Path Exists in Graph (LC 1971) | Easy | [LeetCode 1971](https://leetcode.com/problems/find-if-path-exists-in-graph/) | `- [ ]` |
| 35 | **Path Generation** | All Paths From Source to Target (LC 797) | Medium | [LeetCode 797](https://leetcode.com/problems/all-paths-from-source-to-target/) | `- [ ]` |
| 36 | **Graph Cloning** | Clone Graph (LC 133) | Medium | [LeetCode 133](https://leetcode.com/problems/clone-graph/) | `- [ ]` |
| 37 | **Components BFS** | Number of Islands (LC 200) | Medium | [LeetCode 200](https://leetcode.com/problems/number-of-islands/) | `- [ ]` |
| 38 | **Reachability** | Keys and Rooms (LC 841) | Medium | [LeetCode 841](https://leetcode.com/problems/keys-and-rooms/) | `- [ ]` |
| 39 | **Grid Boundary DFS**| Pacific Atlantic Water Flow (LC 417) | Medium | [LeetCode 417](https://leetcode.com/problems/pacific-atlantic-water-flow/) | `- [ ]` |
| 40 | **Eulerian Path** | Reconstruct Itinerary (LC 332) | Hard | [LeetCode 332](https://leetcode.com/problems/reconstruct-itinerary/) | `- [ ]` |

---

### Unit 6: Advanced Graph Problems & Algorithms — 10 Questions

| No. | Topic | LeetCode Problem | Difficulty | Link | Status |
| :--- | :--- | :--- | :--- | :--- | :---: |
| 41 | **Dijkstra** | Network Delay Time (LC 743) | Medium | [LeetCode 743](https://leetcode.com/problems/network-delay-time/) | `- [ ]` |
| 42 | **Bellman-Ford** | Cheapest Flights Within K Stops (LC 787) | Medium | [LeetCode 787](https://leetcode.com/problems/cheapest-flights-within-k-stops/) | `- [ ]` |
| 43 | **Bipartite** | Is Graph Bipartite? (LC 785) | Medium | [LeetCode 785](https://leetcode.com/problems/is-graph-bipartite/) | `- [ ]` |
| 44 | **Directed Cycle** | Course Schedule (LC 207) | Medium | [LeetCode 207](https://leetcode.com/problems/course-schedule/) | `- [ ]` |
| 45 | **Topological Sort**| Course Schedule II (LC 210) | Medium | [LeetCode 210](https://leetcode.com/problems/course-schedule-ii/) | `- [ ]` |
| 46 | **0/1 BFS** | 01 Matrix (LC 542) | Medium | [LeetCode 542](https://leetcode.com/problems/01-matrix/) | `- [ ]` |
| 47 | **BFS on Grid** | Snakes and Ladders (LC 909) | Medium | [LeetCode 909](https://leetcode.com/problems/snakes-and-ladders/) | `- [ ]` |
| 48 | **Rooted Trees** | Minimum Height Trees (LC 310) | Medium | [LeetCode 310](https://leetcode.com/problems/minimum-height-trees/) | `- [ ]` |
| 49 | **BFS State Search**| Word Ladder (LC 127) | Hard | [LeetCode 127](https://leetcode.com/problems/word-ladder/) | `- [ ]` |
| 50 | **Bridges (SCC)** | Critical Connections in a Network (LC 1192)| Hard | [LeetCode 1192](https://leetcode.com/problems/critical-connections-in-a-network/) | `- [ ]` |
