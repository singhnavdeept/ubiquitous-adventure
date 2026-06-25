# Graph Algorithms Masterclass (C++)

This is the ultimate reference guide for Graph Algorithms. It covers graph representations, traversals, shortest paths, disjoint sets, topological sorting, minimum spanning trees, strongly connected components, and graph coloring—complete with production-grade C++ implementations and Leetcode solutions.

---

## 1. Graph Representation

We use an **Adjacency List** to represent the graph efficiently.

```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <stack>
#include <algorithm>

using namespace std;

class Graph {
public:
    int V; // Number of vertices
    vector<vector<pair<int, int>>> adj; // adj[u] = {v, weight}

    Graph(int vertices) {
        V = vertices;
        adj.resize(V);
    }

    void addEdge(int u, int v, int weight = 1, bool isDirected = false) {
        adj[u].push_back({v, weight});
        if (!isDirected) {
            adj[v].push_back({u, weight});
        }
    }
};
```

---

## 2. Graph Traversals (BFS & DFS)

### Breadth-First Search (BFS)
Explores level-by-level using a **Queue**. Ideal for finding the shortest path in unweighted graphs.
*   **Time Complexity**: $O(V + E)$ where $V$ is vertices and $E$ is edges.
*   **Space Complexity**: $O(V)$ for the visited array and queue.

```cpp
    void bfsHelper(int startVertex, vector<bool>& visited) {
        queue<int> q;
        visited[startVertex] = true;
        q.push(startVertex);

        while (!q.empty()) {
            int u = q.front();
            q.pop();
            for (auto neighbor : adj[u]) {
                int v = neighbor.first;
                if (!visited[v]) {
                    visited[v] = true;
                    q.push(v);
                }
            }
        }
    }

    // Call this to ensure disconnected components are visited
    void BFS_All() {
        vector<bool> visited(V, false);
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                bfsHelper(i, visited);
            }
        }
    }
```

### Depth-First Search (DFS)
Explores deep into branches using recursion (Call Stack). Ideal for cycle detection and topological sorting.
*   **Time Complexity**: $O(V + E)$
*   **Space Complexity**: $O(V)$ (recursion stack depth in worst case).

```cpp
    void dfsHelper(int u, vector<bool>& visited) {
        visited[u] = true;
        for (auto neighbor : adj[u]) {
            int v = neighbor.first;
            if (!visited[v]) {
                dfsHelper(v, visited);
            }
        }
    }

    // Call this to ensure disconnected components are visited
    void DFS_All() {
        vector<bool> visited(V, false);
        for (int i = 0; i < V; i++) {
            if (!visited[i]) {
                dfsHelper(i, visited);
            }
        }
    }
```

---

## 3. Shortest Path: Dijkstra's Algorithm

Finds the shortest path from a start node to all other nodes in a graph with **non-negative** weights using a **Min-Heap** priority queue.
*   **Time Complexity**: $O(E \log V)$
*   **Space Complexity**: $O(V + E)$ for distance array and priority queue.
*   *Note: If the graph has negative weight edges, Dijkstra will fail. Use Bellman-Ford $O(V \times E)$ instead.*

```cpp
    vector<int> Dijkstra(int startVertex) {
        const int INF = 1e9;
        vector<int> dist(V, INF);
        priority_queue<pair<int, int>, vector<pair<int, int>>, greater<pair<int, int>>> pq;

        dist[startVertex] = 0;
        pq.push({0, startVertex});

        while (!pq.empty()) {
            int d = pq.top().first;
            int u = pq.top().second;
            pq.pop();

            if (d > dist[u]) continue;

            for (auto neighbor : adj[u]) {
                int v = neighbor.first;
                int weight = neighbor.second;

                if (dist[u] + weight < dist[v]) {
                    dist[v] = dist[u] + weight;
                    pq.push({dist[v], v});
                }
            }
        }
        return dist;
    }
```

---

## 4. Disjoint Set Union (DSU)

Used for dynamic connectivity. Implements **Path Compression** and **Union by Rank** to achieve $O(1)$ amortized time complexity.

```cpp
class DSU {
private:
    vector<int> parent, rank;
public:
    DSU(int n) {
        parent.resize(n);
        rank.assign(n, 0);
        for (int i = 0; i < n; i++) parent[i] = i;
    }
    
    int find(int x) {
        if (parent[x] != x)
            parent[x] = find(parent[x]); // Path Compression
        return parent[x];
    }
    
    bool unite(int x, int y) {
        int rootX = find(x), rootY = find(y);
        if (rootX == rootY) return false; 
        
        // Union by Rank
        if (rank[rootX] < rank[rootY]) {
            parent[rootX] = rootY;
        } else if (rank[rootX] > rank[rootY]) {
            parent[rootY] = rootX;
        } else {
            parent[rootY] = rootX;
            rank[rootX]++; 
        }
        return true;
    }
};
```

---

## 5. Topological Sorting: Kahn's Algorithm

**Concept**: A Topological Sort is a linear ordering of vertices in a Directed Acyclic Graph (DAG) such that for every directed edge $U \to V$, vertex $U$ comes before $V$. It is used for scheduling tasks with prerequisites.

**Kahn's Algorithm**: Uses BFS and an **In-Degree array**.
1. Calculate the in-degree (number of incoming edges) for all vertices.
2. Push all vertices with `in-degree == 0` into a queue.
3. Pop from the queue, add to the topological order, and decrement the in-degree of all its neighbors.
4. If a neighbor's in-degree becomes 0, push it to the queue.
5. If the topological order size $\neq V$, the graph has a cycle!

### Question: Course Schedule (Leetcode 207)
**Problem**: You have $N$ courses. `prerequisites[i] = [a, b]` means to take course `a` you must take course `b`. Can you finish all courses?

```cpp
class Solution {
public:
    bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
        vector<vector<int>> adj(numCourses);
        vector<int> inDegree(numCourses, 0);
        
        // Build graph and calculate in-degrees
        for (auto& pre : prerequisites) {
            int u = pre[1]; // Prerequisite
            int v = pre[0]; // Dependent course
            adj[u].push_back(v);
            inDegree[v]++;
        }
        
        queue<int> q;
        // Push courses with no prerequisites
        for (int i = 0; i < numCourses; i++) {
            if (inDegree[i] == 0) q.push(i);
        }
        
        int count = 0;
        while (!q.empty()) {
            int u = q.front();
            q.pop();
            count++;
            
            for (int v : adj[u]) {
                inDegree[v]--; // Remove the edge
                if (inDegree[v] == 0) {
                    q.push(v);
                }
            }
        }
        
        // If we processed all courses, there are no cycles
        return count == numCourses;
    }
};
```

---

## 6. Minimum Spanning Tree (MST): Kruskal's Algorithm

**Concept**: A Minimum Spanning Tree (MST) is a subset of edges in a weighted, undirected graph that connects all vertices without any cycles and with the minimum possible total edge weight.

**Kruskal's Algorithm**:
1. Sort all edges in non-decreasing order of their weight.
2. Iterate through the sorted edges.
3. Use **DSU** to check if adding the edge forms a cycle. If it doesn't (`dsu.unite()` returns true), add the edge to the MST.
4. Stop when we have added $V - 1$ edges. Time Complexity: $O(E \log E)$.

### Question: Min Cost to Connect All Points (Leetcode 1584)
**Problem**: Given points on a 2D plane, find the minimum cost to make all points connected. Cost is Manhattan distance.

```cpp
class Solution {
public:
    int minCostConnectPoints(vector<vector<int>>& points) {
        int n = points.size();
        vector<pair<int, pair<int, int>>> edges; // {weight, {u, v}}
        
        // 1. Build all possible edges (Complete Graph)
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                int dist = abs(points[i][0] - points[j][0]) + abs(points[i][1] - points[j][1]);
                edges.push_back({dist, {i, j}});
            }
        }
        
        // 2. Sort edges by weight
        sort(edges.begin(), edges.end());
        
        // 3. Kruskal's Algorithm using DSU
        DSU dsu(n);
        int mstWeight = 0;
        int edgesUsed = 0;
        
        for (auto& edge : edges) {
            int weight = edge.first;
            int u = edge.second.first;
            int v = edge.second.second;
            
            // If they are in different sets, adding this edge won't form a cycle
            if (dsu.unite(u, v)) {
                mstWeight += weight;
                edgesUsed++;
                if (edgesUsed == n - 1) break; // Optimization: Stop when MST is complete
            }
        }
        
        return mstWeight;
    }
};
```

---

## 7. Strongly Connected Components: Kosaraju's Algorithm

**Concept**: In a directed graph, a Strongly Connected Component (SCC) is a maximal subset of vertices where every vertex is reachable from every other vertex.

**Kosaraju's Algorithm**: Extremely elegant two-pass DFS approach.
*   **Time Complexity**: $O(V + E)$ (since it involves just two linear DFS passes).
*   **Space Complexity**: $O(V + E)$ to store the reversed graph and visited array.
1. **Pass 1**: Perform normal DFS on the graph. When a recursive DFS finishes for a node, push it to a `stack`. (This orders nodes by finish time).
2. **Reverse Graph**: Create a transposed graph where all edge directions are reversed.
3. **Pass 2**: Pop nodes from the stack one by one. If a node is unvisited, run DFS on the *reversed* graph starting from this node. Every node reached during this DFS call belongs to the **same SCC**.

### Implementation:
```cpp
void dfsPass1(int u, vector<vector<int>>& adj, vector<bool>& visited, stack<int>& st) {
    visited[u] = true;
    for (int v : adj[u]) {
        if (!visited[v]) dfsPass1(v, adj, visited, st);
    }
    st.push(u); // Push to stack after visiting all children
}

void dfsPass2(int u, vector<vector<int>>& revAdj, vector<bool>& visited) {
    visited[u] = true;
    cout << u << " "; // This node belongs to the current SCC
    for (int v : revAdj[u]) {
        if (!visited[v]) dfsPass2(v, revAdj, visited);
    }
}

void printSCCs(int V, vector<vector<int>>& adj) {
    stack<int> st;
    vector<bool> visited(V, false);
    
    // Step 1: Fill vertices in stack according to their finishing times
    for (int i = 0; i < V; i++) {
        if (!visited[i]) dfsPass1(i, adj, visited, st);
    }
    
    // Step 2: Create reversed graph
    vector<vector<int>> revAdj(V);
    for (int u = 0; u < V; u++) {
        for (int v : adj[u]) revAdj[v].push_back(u); // Reverse the edge
    }
    
    // Step 3: Process all vertices in order defined by Stack
    fill(visited.begin(), visited.end(), false);
    int sccCount = 0;
    
    while (!st.empty()) {
        int u = st.top();
        st.pop();
        
        if (!visited[u]) {
            sccCount++;
            cout << "SCC " << sccCount << ": ";
            dfsPass2(u, revAdj, visited);
            cout << endl;
        }
    }
}
```

---

## 8. M-Coloring Problem / Bipartite Graph Detection

**Concept**: A graph is **Bipartite** if its vertices can be colored using exactly 2 colors such that no two adjacent vertices share the same color. If a graph has an odd-length cycle, it CANNOT be bipartite.

**Algorithm**: Use BFS (or DFS). Color the starting node 0, color its neighbors 1, color their neighbors 0, and so on. If you ever find a neighbor that is already colored with the *same* color as the current node, the graph is not bipartite.

### Question: Is Graph Bipartite? (Leetcode 785)

```cpp
class Solution {
public:
    bool isBipartite(vector<vector<int>>& graph) {
        int n = graph.size();
        // -1 means uncolored, 0 and 1 are the two colors
        vector<int> color(n, -1);
        
        for (int i = 0; i < n; i++) {
            // If node is uncolored, start a BFS from it (handles disconnected graphs)
            if (color[i] == -1) {
                queue<int> q;
                q.push(i);
                color[i] = 0; // Start coloring with 0
                
                while (!q.empty()) {
                    int u = q.front();
                    q.pop();
                    
                    for (int v : graph[u]) {
                        // If uncolored, color with opposite color and push to queue
                        if (color[v] == -1) {
                            color[v] = 1 - color[u];
                            q.push(v);
                        } 
                        // If colored with the SAME color, graph is not bipartite
                        else if (color[v] == color[u]) {
                            return false;
                        }
                    }
                }
            }
        }
        return true; // Successfully colored entire graph
    }
};
```

---

## 9. Foundational Practice Questions

### Question A: Redundant Connection (Leetcode 684) - Cycle Detection
**Approach**: DSU. First edge where `find(u) == find(v)` is the cycle creator.
```cpp
class Solution {
public:
    vector<int> findRedundantConnection(vector<vector<int>>& edges) {
        int n = edges.size();
        DSU dsu(n + 1); 
        for (auto& edge : edges) {
            if (!dsu.unite(edge[0], edge[1])) return {edge[0], edge[1]};
        }
        return {};
    }
};
```

### Question B: Number of Provinces (Leetcode 547) - Connected Components
**Approach**: DSU. Start with $N$ provinces, decrement every time `dsu.unite()` is successful.
```cpp
class Solution {
public:
    int findCircleNum(vector<vector<int>>& isConnected) {
        int n = isConnected.size();
        DSU dsu(n);
        int provinces = n; 
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (isConnected[i][j] == 1 && dsu.unite(i, j)) {
                    provinces--;
                }
            }
        }
        return provinces;
    }
};
```
