

### Fresh problems to build intuition. No Number of Islands. No Course Schedule.

> **How this file is structured:** Each problem teaches one specific graph instinct. Read the _"what this teaches you"_ line before coding — that's the point of the problem. Every solution is written in clean Python with line-by-line comments.

---

## 3 Python Graph Templates

Burn these into memory. Every problem below is a variation of one of these.

```python
# Template 1 — DFS on a grid (flood fill style)
dirs = [(0,1),(0,-1),(1,0),(-1,0)]

def dfs(grid, r, c, visited):
    if r < 0 or c < 0 or r >= len(grid) or c >= len(grid[0]):
        return           # out of bounds
    if visited[r][c] or grid[r][c] == 0:
        return           # already seen or blocked
    visited[r][c] = True
    for dr, dc in dirs:
        dfs(grid, r+dr, c+dc, visited)


# Template 2 — BFS (shortest path / level by level)
from collections import deque

def bfs(graph, start):
    visited = {start}
    q = deque([(start, 0)])      # (node, distance)
    while q:
        node, dist = q.popleft()
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                q.append((neighbor, dist + 1))


# Template 3 — DFS on adjacency list (general graph)
from collections import defaultdict

def build_graph(edges, directed=False):
    graph = defaultdict(list)
    for u, v in edges:
        graph[u].append(v)
        if not directed:
            graph[v].append(u)
    return graph

def dfs(node, graph, visited):
    visited.add(node)
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(neighbor, graph, visited)
```

---

## Stage 1 — Grid DFS (Warmup, pure mechanics)

---

### Problem 1 — Flood Fill

**Link:** https://leetcode.com/problems/flood-fill/ **Difficulty:** Easy **What this teaches you:** The most basic DFS on a grid. Identical to paint bucket in MS Paint. Once you feel comfortable here, every grid DFS problem is the same skeleton.

```python
def floodFill(image, sr, sc, color):
    original = image[sr][sc]

    # Edge case: if the original color is already the target, do nothing
    # (without this check, DFS recurses infinitely)
    if original == color:
        return image

    def dfs(r, c):
        # Bounds check + color check — stop if out of grid or not the original color
        if r < 0 or c < 0 or r >= len(image) or c >= len(image[0]):
            return
        if image[r][c] != original:
            return

        image[r][c] = color          # paint this cell

        # Spread in all 4 directions
        dfs(r+1, c)
        dfs(r-1, c)
        dfs(r, c+1)
        dfs(r, c-1)

    dfs(sr, sc)
    return image

# Time: O(M*N) — visit every cell at most once
# Space: O(M*N) — recursion stack in worst case (long snake path)
```

**Key Python habit:** No need to track a separate `visited` set here — painting the cell to the new color IS the visited marker.

---

### Problem 2 — Island Perimeter

**Link:** https://leetcode.com/problems/island-perimeter/ **Difficulty:** Easy **What this teaches you:** You don't always need DFS to solve a "grid graph" problem. Sometimes just counting boundaries is enough. This problem trains you to think about _what contributes to an answer_ rather than just blindly running DFS.

```python
def islandPerimeter(grid):
    rows, cols = len(grid), len(grid[0])
    perimeter = 0

    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == 1:
                # Each land cell contributes 4 sides by default
                perimeter += 4

                # Subtract shared edges with neighbors above and to the left
                # (checking all 4 would double-count)
                if r > 0 and grid[r-1][c] == 1:
                    perimeter -= 2   # shared top edge
                if c > 0 and grid[r][c-1] == 1:
                    perimeter -= 2   # shared left edge

    return perimeter

# Time: O(M*N), Space: O(1) — no recursion, no visited set
```

**The lesson:** Ask "do I even need DFS here?" before writing the template.

---

### Problem 3 — Count Sub Islands

**Link:** https://leetcode.com/problems/count-sub-islands/ **Difficulty:** Medium **What this teaches you:** DFS with a twist — you need to check a condition _across two grids simultaneously_ during the traversal. This pattern (DFS + external condition) appears in many harder problems.

```python
def countSubIslands(grid1, grid2):
    rows, cols = len(grid2), len(grid2[0])

    def dfs(r, c):
        # Returns True if this entire connected component in grid2
        # is fully contained inside grid1
        if r < 0 or c < 0 or r >= rows or c >= cols:
            return True      # off-grid counts as valid (no disqualifying land)
        if grid2[r][c] == 0:
            return True      # water in grid2, nothing to check

        grid2[r][c] = 0      # mark visited by sinking the cell

        # Check if this cell in grid2 is also land in grid1
        # NOTE: we do NOT short-circuit here — we must visit ALL cells of the island
        # in grid2 first (to mark them visited), even if one cell fails
        is_sub = grid1[r][c] == 1

        is_sub = dfs(r+1, c) and is_sub
        is_sub = dfs(r-1, c) and is_sub
        is_sub = dfs(r, c+1) and is_sub
        is_sub = dfs(r, c-1) and is_sub

        return is_sub

    count = 0
    for r in range(rows):
        for c in range(cols):
            if grid2[r][c] == 1:
                if dfs(r, c):
                    count += 1

    return count

# Time: O(M*N), Space: O(M*N) recursion stack
```

**The trap:** Writing `if not grid1[r][c]: return False` early exits DFS without visiting the rest of the island. The remaining cells stay unvisited and get counted again in the outer loop. Always complete the DFS before returning the result.

---

### Problem 4 — Max Area of Island

**Link:** https://leetcode.com/problems/max-area-of-island/ **Difficulty:** Medium **What this teaches you:** DFS that _returns a value_ — the size of the component. This return-value pattern is the foundation of all "compute something about a component" problems.

```python
def maxAreaOfIsland(grid):
    rows, cols = len(grid), len(grid[0])

    def dfs(r, c):
        if r < 0 or c < 0 or r >= rows or c >= cols or grid[r][c] == 0:
            return 0

        grid[r][c] = 0       # mark visited (sink the island)

        # Area = this cell (1) + area of all connected cells
        return 1 + dfs(r+1,c) + dfs(r-1,c) + dfs(r,c+1) + dfs(r,c-1)

    return max(dfs(r, c) for r in range(rows) for c in range(cols))
    # The generator inside max() is a clean Python trick — no need for a separate loop

# Time: O(M*N), Space: O(M*N)
```

---

## Stage 2 — BFS Fundamentals (Shortest Path on Grids)

---

### Problem 5 — Nearest Exit from Entrance in Maze

**Link:** https://leetcode.com/problems/nearest-exit-from-entrance-in-maze/ **Difficulty:** Medium **What this teaches you:** BFS = shortest path. The moment a problem says "minimum steps to reach" something, you should reach for BFS, not DFS. This problem makes that instinct concrete.

```python
from collections import deque

def nearestExit(maze, entrance):
    rows, cols = len(maze), len(maze[0])
    er, ec = entrance

    # Start BFS from the entrance
    q = deque([(er, ec, 0)])    # (row, col, steps)
    maze[er][ec] = '+'          # mark entrance as visited

    dirs = [(0,1),(0,-1),(1,0),(-1,0)]

    while q:
        r, c, steps = q.popleft()

        for dr, dc in dirs:
            nr, nc = r+dr, c+dc

            if 0 <= nr < rows and 0 <= nc < cols and maze[nr][nc] == '.':
                # Is this cell on the border? If so, it's an exit
                if nr == 0 or nc == 0 or nr == rows-1 or nc == cols-1:
                    return steps + 1     # BFS guarantees this is the SHORTEST path

                maze[nr][nc] = '+'       # mark visited
                q.append((nr, nc, steps+1))

    return -1    # no exit found

# Time: O(M*N), Space: O(M*N)
```

**Why BFS and not DFS here?** DFS finds _a_ path. BFS finds the _shortest_ path. If you used DFS you'd need to explore all paths and track the minimum — O(4^(M*N)) in the worst case.

---

### Problem 6 — Rotting Oranges

**Link:** https://leetcode.com/problems/rotting-oranges/ **Difficulty:** Medium **What this teaches you:** **Multi-source BFS** — starting BFS from _multiple_ nodes at once instead of one. This models "simultaneous spread" perfectly (fire, infection, water rising). It's a pattern that appears in dozens of problems in disguise.

```python
from collections import deque

def orangesRotting(grid):
    rows, cols = len(grid), len(grid[0])
    q = deque()
    fresh = 0

    # Seed the queue with ALL rotten oranges simultaneously
    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == 2:
                q.append((r, c, 0))   # (row, col, minutes_elapsed)
            elif grid[r][c] == 1:
                fresh += 1

    if fresh == 0:
        return 0     # nothing to rot

    dirs = [(0,1),(0,-1),(1,0),(-1,0)]
    minutes = 0

    while q:
        r, c, minutes = q.popleft()

        for dr, dc in dirs:
            nr, nc = r+dr, c+dc
            if 0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] == 1:
                grid[nr][nc] = 2     # rot it
                fresh -= 1
                q.append((nr, nc, minutes+1))

    return minutes if fresh == 0 else -1

# Time: O(M*N), Space: O(M*N)
```

**The multi-source BFS key insight:** By adding ALL starting points to the queue before the loop begins, you simulate them all spreading at the same time. BFS's level-by-level nature handles the timing automatically.

---

### Problem 7 — Shortest Path in Binary Matrix

**Link:** https://leetcode.com/problems/shortest-path-in-binary-matrix/ **Difficulty:** Medium **What this teaches you:** BFS with **8-directional** movement (diagonals included). Also teaches you to handle edge cases _before_ starting BFS (checking if start or end is blocked).

```python
from collections import deque

def shortestPathBinaryMatrix(grid):
    n = len(grid)

    # Edge case: start or end is blocked
    if grid[0][0] == 1 or grid[n-1][n-1] == 1:
        return -1

    # 8 directions (including diagonals)
    dirs = [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]

    q = deque([(0, 0, 1)])    # (row, col, path_length)
    grid[0][0] = 1            # mark visited

    while q:
        r, c, length = q.popleft()

        if r == n-1 and c == n-1:
            return length        # reached bottom-right

        for dr, dc in dirs:
            nr, nc = r+dr, c+dc
            if 0 <= nr < n and 0 <= nc < n and grid[nr][nc] == 0:
                grid[nr][nc] = 1     # mark visited immediately on enqueue
                q.append((nr, nc, length+1))

    return -1

# Time: O(N²), Space: O(N²)
```

**The marking trick:** Mark cells as visited when you _enqueue_ them, not when you _dequeue_ them. Marking on dequeue lets duplicate entries pile up in the queue (the same cell gets added multiple times before it's processed), blowing up time and space.

---

## Stage 3 — General Graph BFS/DFS (Adjacency List)

---

### Problem 8 — Find if Path Exists in Graph

**Link:** https://leetcode.com/problems/find-if-path-exists-in-graph/ **Difficulty:** Easy **What this teaches you:** How to build an adjacency list from an edge list in Python, and run your first BFS on a non-grid graph. This is the _Hello World_ of general graph problems.

```python
from collections import defaultdict, deque

def validPath(n, edges, source, destination):
    if source == destination:
        return True

    # Build undirected adjacency list
    graph = defaultdict(list)
    for u, v in edges:
        graph[u].append(v)
        graph[v].append(u)

    # BFS from source, looking for destination
    visited = {source}
    q = deque([source])

    while q:
        node = q.popleft()
        for neighbor in graph[node]:
            if neighbor == destination:
                return True
            if neighbor not in visited:
                visited.add(neighbor)
                q.append(neighbor)

    return False

# Time: O(V + E), Space: O(V + E)
```

---

### Problem 9 — Number of Provinces

**Link:** https://leetcode.com/problems/number-of-provinces/ **Difficulty:** Medium **What this teaches you:** Connected components on an adjacency _matrix_ (not a list). Also teaches the outer loop pattern — iterate all nodes, run DFS from any unvisited one, count how many times you start a fresh DFS.

```python
def findCircleNum(isConnected):
    n = len(isConnected)
    visited = set()

    def dfs(city):
        visited.add(city)
        for neighbor in range(n):
            # isConnected[city][neighbor] == 1 means they're directly connected
            if isConnected[city][neighbor] == 1 and neighbor not in visited:
                dfs(neighbor)

    provinces = 0
    for city in range(n):
        if city not in visited:
            dfs(city)       # explore the entire connected component
            provinces += 1  # each fresh DFS = one new province

    return provinces

# Time: O(N²) — we check all pairs, Space: O(N) for visited + recursion
```

**The outer loop pattern:** This exact pattern — "for each unvisited node, run DFS, count" — solves a huge number of connected-components problems. Memorise it.

---

### Problem 10 — All Paths From Source to Target

**Link:** https://leetcode.com/problems/all-paths-from-source-to-target/ **Difficulty:** Medium **What this teaches you:** DFS that **collects all paths**, not just checks existence. The key Python detail is appending a _copy_ of the current path to results — a C++ habit you might skip but can't in Python.

```python
def allPathsSourceTarget(graph):
    target = len(graph) - 1
    result = []

    def dfs(node, path):
        if node == target:
            result.append(path[:])   # COPY — not a reference
            return

        for neighbor in graph[node]:
            path.append(neighbor)
            dfs(neighbor, path)
            path.pop()               # backtrack

    dfs(0, [0])
    return result

# Time: O(2^N * N) — up to 2^N paths each of length N
# Space: O(N) for path + recursion stack
```

**Why `path[:]` and not just `path`?** In Python, lists are passed by reference. If you append `path` directly, all entries in `result` point to the same list object — which gets mutated as DFS continues. `path[:]` creates an independent copy.

---

### Problem 11 — Evaluate Division

**Link:** https://leetcode.com/problems/evaluate-division/ **Difficulty:** Medium **What this teaches you:** Graphs aren't always integers and grids. This problem builds a graph from _strings_, with _float weights_ on edges. It's the first time the "graph" isn't obvious from the problem description — you have to _see_ it.

```python
from collections import defaultdict, deque

def calcEquation(equations, values, queries):

    # Build a weighted directed graph
    # If a/b = k, add edge a→b with weight k and b→a with weight 1/k
    graph = defaultdict(dict)
    for (a, b), val in zip(equations, values):
        graph[a][b] = val
        graph[b][a] = 1.0 / val

    def bfs(src, dst):
        if src not in graph or dst not in graph:
            return -1.0
        if src == dst:
            return 1.0

        visited = {src}
        q = deque([(src, 1.0)])     # (current_node, accumulated_product)

        while q:
            node, product = q.popleft()
            if node == dst:
                return product
            for neighbor, weight in graph[node].items():
                if neighbor not in visited:
                    visited.add(neighbor)
                    q.append((neighbor, product * weight))   # multiply weights along path

        return -1.0

    return [bfs(src, dst) for src, dst in queries]

# Time: O((V+E) * Q) where Q = number of queries
# Space: O(V + E)
```

**The graph insight:** `a / b = k` means there's an edge from `a` to `b` with weight `k`. Division along a path becomes multiplication of edge weights. Once you see "variables with ratios between them" → think weighted graph + BFS.

---

### Problem 12 — Snakes and Ladders

**Link:** https://leetcode.com/problems/snakes-and-ladders/ **Difficulty:** Medium **What this teaches you:** BFS on a graph where the nodes are board positions and edges come from dice rolls. The tricky part is the board numbering — it's boustrophedon (alternating left-right direction). This tests your ability to model a real problem as a graph.

```python
from collections import deque

def snakesAndLadders(board):
    n = len(board)

    def cell_to_coords(cell):
        # Convert 1-indexed cell number to (row, col) in the board
        cell -= 1
        row = cell // n
        col = cell % n
        # Odd rows (from bottom) go right-to-left
        if row % 2 == 1:
            col = n - 1 - col
        # Board is given top-to-bottom, but cell 1 is bottom-left
        return (n - 1 - row, col)

    visited = {1}
    q = deque([(1, 0)])   # (cell_number, moves)

    while q:
        cell, moves = q.popleft()

        for dice in range(1, 7):   # roll 1 through 6
            next_cell = cell + dice
            if next_cell > n * n:
                break

            r, c = cell_to_coords(next_cell)

            # If there's a snake or ladder, follow it
            if board[r][c] != -1:
                next_cell = board[r][c]

            if next_cell == n * n:
                return moves + 1

            if next_cell not in visited:
                visited.add(next_cell)
                q.append((next_cell, moves + 1))

    return -1

# Time: O(N²), Space: O(N²)
```

**The modelling lesson:** Flatten the board to a 1D cell index, BFS over cell numbers as nodes, dice rolls as edges. Once you see it as a graph, the code writes itself.

---

## Stage 4 — Graph Coloring and Properties

---

### Problem 13 — Is Graph Bipartite?

**Link:** https://leetcode.com/problems/is-graph-bipartite/ **Difficulty:** Medium **What this teaches you:** **Graph coloring** — assigning colors to nodes so no two adjacent nodes share a color. This is the foundation of bipartite checking. BFS with a color array is cleaner than DFS for this pattern.

```python
from collections import deque

def isBipartite(graph):
    n = len(graph)
    color = [-1] * n      # -1 = uncolored, 0 = red, 1 = blue

    for start in range(n):
        if color[start] != -1:
            continue      # already colored in a previous component

        # BFS, coloring as we go
        q = deque([start])
        color[start] = 0

        while q:
            node = q.popleft()
            for neighbor in graph[node]:
                if color[neighbor] == -1:
                    # Color with opposite color
                    color[neighbor] = 1 - color[node]
                    q.append(neighbor)
                elif color[neighbor] == color[node]:
                    # Same color as current node — not bipartite
                    return False

    return True

# Time: O(V + E), Space: O(V)
```

**The `1 - color` trick:** Python one-liner to flip between 0 and 1. In C++ you'd write `color[node] == 0 ? 1 : 0`. This is one of those Python idioms worth memorising.

---

### Problem 14 — Possible Bipartition

**Link:** https://leetcode.com/problems/possible-bipartition/ **Difficulty:** Medium **What this teaches you:** Bipartite check on a graph built from _relationships_ (dislikes), not given directly as an adjacency list. The modelling step is the hard part — recognising that "people who dislike each other can't be in the same group" = bipartite graph problem.

```python
from collections import defaultdict, deque

def possibleBipartition(n, dislikes):
    # Build undirected graph from dislikes
    graph = defaultdict(list)
    for a, b in dislikes:
        graph[a].append(b)
        graph[b].append(a)

    color = {}   # person → group (0 or 1)

    for person in range(1, n + 1):
        if person in color:
            continue

        q = deque([person])
        color[person] = 0

        while q:
            node = q.popleft()
            for neighbor in graph[node]:
                if neighbor not in color:
                    color[neighbor] = 1 - color[node]
                    q.append(neighbor)
                elif color[neighbor] == color[node]:
                    return False    # conflict — same group, dislike each other

    return True

# Time: O(N + E), Space: O(N + E)
```

---

## Stage 5 — BFS Variants Worth Knowing Early

---

### Problem 15 — Walls and Gates (Multi-Source BFS)

**Link:** https://leetcode.com/problems/walls-and-gates/ **Difficulty:** Medium **What this teaches you:** Multi-source BFS where the sources are the _destinations_ (gates), not the starting points. BFS from all gates simultaneously fills every empty room with its distance to the nearest gate. Thinking in reverse is a recurring graph trick.

```python
from collections import deque

def wallsAndGates(rooms):
    if not rooms:
        return

    rows, cols = len(rooms), len(rooms[0])
    INF = 2147483647
    dirs = [(0,1),(0,-1),(1,0),(-1,0)]

    # Seed queue with ALL gates at once
    q = deque()
    for r in range(rows):
        for c in range(cols):
            if rooms[r][c] == 0:   # 0 = gate
                q.append((r, c))

    # BFS outward from all gates simultaneously
    while q:
        r, c = q.popleft()
        for dr, dc in dirs:
            nr, nc = r+dr, c+dc
            if 0 <= nr < rows and 0 <= nc < cols and rooms[nr][nc] == INF:
                rooms[nr][nc] = rooms[r][c] + 1   # distance from nearest gate
                q.append((nr, nc))

    # Result is in-place — no return needed

# Time: O(M*N), Space: O(M*N)
```

**Why start from gates, not rooms?** If you BFS from each room separately, you'd run O(M_N) BFS traversals = O(M²N²) total. Starting from all gates at once is a single O(M_N) pass.

---

### Problem 16 — 01 Matrix (Distance to Nearest 0)

**Link:** https://leetcode.com/problems/01-matrix/ **Difficulty:** Medium **What this teaches you:** Multi-source BFS again, but with the insight that you seed from the _targets_ (0s) and expand outward. This is the same reverse-source trick as Walls and Gates, applied to a different context.

```python
from collections import deque

def updateMatrix(mat):
    rows, cols = len(mat), len(mat[0])
    dist = [[float('inf')] * cols for _ in range(rows)]
    q = deque()

    # Seed all 0-cells as sources with distance 0
    for r in range(rows):
        for c in range(cols):
            if mat[r][c] == 0:
                dist[r][c] = 0
                q.append((r, c))

    dirs = [(0,1),(0,-1),(1,0),(-1,0)]

    while q:
        r, c = q.popleft()
        for dr, dc in dirs:
            nr, nc = r+dr, c+dc
            if 0 <= nr < rows and 0 <= nc < cols:
                # Only update if we found a shorter path
                if dist[r][c] + 1 < dist[nr][nc]:
                    dist[nr][nc] = dist[r][c] + 1
                    q.append((nr, nc))

    return dist

# Time: O(M*N), Space: O(M*N)
```

---

### Problem 17 — As Far from Land as Possible

**Link:** https://leetcode.com/problems/as-far-from-land-as-possible/ **Difficulty:** Medium **What this teaches you:** Multi-source BFS to find the _maximum_ shortest distance (not minimum). A small twist on the same pattern — you run the same BFS, but instead of stopping early, you let it run to completion and take the last distance seen.

```python
from collections import deque

def maxDistance(grid):
    n = len(grid)
    q = deque()

    # Seed all land cells
    for r in range(n):
        for c in range(n):
            if grid[r][c] == 1:
                q.append((r, c))

    # Edge case: all land or all water
    if len(q) == 0 or len(q) == n * n:
        return -1

    dirs = [(0,1),(0,-1),(1,0),(-1,0)]
    dist = -1

    while q:
        r, c = q.popleft()
        for dr, dc in dirs:
            nr, nc = r+dr, c+dc
            if 0 <= nr < n and 0 <= nc < n and grid[nr][nc] == 0:
                grid[nr][nc] = 1             # mark visited
                dist = max(dist, grid[r][c])  # ← wait, this is wrong!
                q.append((nr, nc))

    # Correct version — track level count
    # The last level processed = maximum distance
    return dist

# CORRECTED approach: track BFS level count
def maxDistanceCorrect(grid):
    n = len(grid)
    q = deque()

    for r in range(n):
        for c in range(n):
            if grid[r][c] == 1:
                q.append((r, c, 0))

    if len(q) == 0 or len(q) == n * n:
        return -1

    dirs = [(0,1),(0,-1),(1,0),(-1,0)]
    max_dist = -1

    while q:
        r, c, d = q.popleft()
        for dr, dc in dirs:
            nr, nc = r+dr, c+dc
            if 0 <= nr < n and 0 <= nc < n and grid[nr][nc] == 0:
                grid[nr][nc] = 1
                max_dist = d + 1
                q.append((nr, nc, d+1))

    return max_dist

# Time: O(N²), Space: O(N²)
```

---

## Stage 6 — DFS With State (Level Up)

---

### Problem 18 — Keys and Rooms

**Link:** https://leetcode.com/problems/keys-and-rooms/ **Difficulty:** Medium **What this teaches you:** DFS where nodes unlock access to other nodes. The graph _changes_ as you traverse it — rooms you haven't visited hold keys to other rooms. This models "you can only go somewhere if you have the right credential" — a pattern in real systems.

```python
def canVisitAllRooms(rooms):
    visited = set()

    def dfs(room):
        visited.add(room)
        for key in rooms[room]:        # each key in the room opens a new door
            if key not in visited:
                dfs(key)

    dfs(0)   # start in room 0 (always unlocked)

    return len(visited) == len(rooms)

# Time: O(V + E) where V = rooms, E = total keys
# Space: O(V) for visited + recursion stack
```

**The clean Python version with iterative DFS** (avoids recursion limit on large inputs):

```python
def canVisitAllRooms(rooms):
    visited = {0}
    stack = [0]

    while stack:
        room = stack.pop()
        for key in rooms[room]:
            if key not in visited:
                visited.add(key)
                stack.append(key)

    return len(visited) == len(rooms)
```

---

### Problem 19 — Find the Town Judge

**Link:** https://leetcode.com/problems/find-the-town-judge/ **Difficulty:** Easy **What this teaches you:** Graph problems disguised as logic puzzles. The judge has in-degree = n-1 and out-degree = 0. This teaches you to translate verbal descriptions into graph properties.

```python
def findJudge(n, trust):
    # Track how many people each person trusts (out-degree)
    # and how many people trust each person (in-degree)
    out_degree = [0] * (n + 1)
    in_degree  = [0] * (n + 1)

    for a, b in trust:
        out_degree[a] += 1   # a trusts someone
        in_degree[b]  += 1   # b is trusted by someone

    for person in range(1, n + 1):
        # Judge trusts nobody (out=0) and is trusted by everyone (in=n-1)
        if out_degree[person] == 0 and in_degree[person] == n - 1:
            return person

    return -1

# Time: O(E), Space: O(N)
```

**The translation:** "Trusts nobody" = out-degree 0. "Trusted by everyone else" = in-degree n-1. Graph degree properties solve verbal problems cleanly.

---

### Problem 20 — Reorder Routes to Make All Paths Lead to the City Zero

**Link:** https://leetcode.com/problems/reorder-routes-to-make-all-paths-lead-to-the-city-zero/ **Difficulty:** Medium **What this teaches you:** BFS on a directed graph where you need to reason about edge _direction_. The trick is to build the graph with both original and reverse edges, then BFS from node 0 and count how many edges are pointing _away_ from 0 (those need flipping).

```python
from collections import defaultdict, deque

def minReorder(n, connections):
    # Build graph with both directions
    # Original edges marked with weight 1 (need flipping if going away from 0)
    # Reverse edges marked with weight 0 (already pointing toward 0)
    graph = defaultdict(list)
    for u, v in connections:
        graph[u].append((v, 1))    # original direction (cost to flip = 1)
        graph[v].append((u, 0))    # reverse direction  (already correct = 0)

    visited = {0}
    q = deque([0])
    flips = 0

    while q:
        node = q.popleft()
        for neighbor, cost in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                flips += cost       # if edge points away from 0, count it
                q.append(neighbor)

    return flips

# Time: O(V + E), Space: O(V + E)
```

---

## Quick Reference — What Pattern Does Each Problem Teach?

|Problem|Core Pattern|Key Insight|
|---|---|---|
|Flood Fill|Basic grid DFS|Painting = visited marker|
|Island Perimeter|No DFS needed|Count boundary edges directly|
|Count Sub Islands|DFS across 2 grids|Don't short-circuit — visit all cells|
|Max Area of Island|DFS returning value|DFS that computes and returns|
|Nearest Exit|BFS = shortest path|Mark visited on enqueue not dequeue|
|Rotting Oranges|Multi-source BFS|Seed ALL sources before starting|
|Shortest Path Binary Matrix|BFS with diagonals|8-directional movement|
|Find if Path Exists|Build graph from edges|Hello world of general graphs|
|Number of Provinces|Connected components|Outer loop + DFS count|
|All Paths Source to Target|Collect all paths|`path[:]` to copy, not reference|
|Evaluate Division|Weighted graph from strings|See the graph in disguise|
|Snakes and Ladders|BFS with board mapping|Model problem as graph first|
|Is Graph Bipartite?|Graph coloring|`1 - color` flip trick|
|Possible Bipartition|Coloring from relationships|Build graph, then color|
|Walls and Gates|Reverse multi-source BFS|Start from targets, not sources|
|01 Matrix|Multi-source BFS|Nearest 0 = same trick|
|As Far from Land|BFS for max distance|Let BFS run to completion|
|Keys and Rooms|DFS with unlocking state|Iterative > recursive (stack safety)|
|Find the Town Judge|Degree properties|Translate words → in/out degree|
|Reorder Routes|Directed graph + BFS|Edge direction as cost|

---

_Work through these in order. By problem 10, the BFS and DFS templates will feel automatic. By problem 20, you'll start seeing graphs in problems that don't say "graph" anywhere._