#concept/remembring

### When to use what — and what you give up in exchange

---

## How to Read This Guide

Each section covers a problem type or algorithm family. For every approach you will see:

- **Time** and **Space** complexity
- **When to pick it** — the conditions that make it the right tool
- **What you give up** — the hidden costs or limitations
- **Interview signal** — what choosing this approach tells the interviewer

---

## Part 1 — Searching & Lookup

---

### 1.1 Linear Search vs Binary Search vs HashMap

|Approach|Time|Space|Best For|
|---|---|---|---|
|Linear scan|O(N)|O(1)|Unsorted, small input|
|Binary search|O(log N)|O(1)|Sorted array, read-heavy|
|HashMap|O(1) avg|O(N)|Repeated lookups, complement problems|

**Linear search** is the fallback. It needs no preprocessing and works on anything — sorted, unsorted, linked lists — but does not scale. Use it only when the dataset is tiny or structure is unavailable.

**Binary search** is fast but demands a sorted structure. The classic mistake is forgetting that maintaining a sorted array through insertions costs O(N) per insert (shifting), which can wipe out the log N savings entirely if you are also frequently writing.

**HashMap** trades memory for speed. Lookups are O(1) on average but degrade to O(N) in the worst case (hash collisions). Also, iterating a HashMap in sorted order requires an extra sort step. For Two Sum and similar complement-finding problems, a HashMap is almost always the correct instinct.

**Interview signal:** Jumping to binary search on an unsorted array is a red flag. Always verify the sorted precondition first.

---

### 1.2 HashSet vs Sorting for Duplicate/Membership Checks

| Approach    | Time       | Space            | Notes                        |
| ----------- | ---------- | ---------------- | ---------------------------- |
| Sort + scan | O(N log N) | O(1) or O(log N) | Modifies input order         |
| HashSet     | O(N) avg   | O(N)             | Preserves order, uses memory |

When you need to check for duplicates or membership, sorting first is space-optimal but destroys the original ordering. If the problem requires preserving insertion order or you cannot modify the array, a HashSet is the right call even though it costs O(N) extra space.

**The rule of thumb:** If space is tight and order does not matter, sort. If you need O(1) lookups repeatedly without altering input, HashSet.

---

## Part 2 — Array Traversal Patterns

---

### 2.1 Brute Force (Nested Loops) vs Two Pointers vs Sliding Window

|Approach|Time|Space|Requirement|
|---|---|---|---|
|Nested loops|O(N²)|O(1)|None|
|Two pointers|O(N)|O(1)|Sorted array or specific structure|
|Sliding window|O(N)|O(1) to O(K)|Contiguous subarray/substring|

**Nested loops** are the naive baseline. They are always correct but never optimal for large N. State them during interviews to show you understand the problem, then immediately work toward improvement.

**Two pointers** collapses O(N²) to O(N) for problems involving pairs (Two Sum on sorted array, 3Sum, Container With Most Water). The key requirement is that the array must be sorted, OR the structure must guarantee that moving one pointer in one direction is always the right move. Without this monotonic property, two pointers break.

**Sliding window** is the right pattern when the problem asks for an optimal contiguous window (longest/shortest substring, maximum sum subarray of size K). There are two variants:

- Fixed-size window (simpler): just advance both pointers together
- Variable-size window (harder): expand the right pointer to include, shrink the left pointer to exclude

**What you give up with two pointers / sliding window:** You must carefully reason about when to move which pointer. Getting this wrong silently produces an incorrect answer.

---

### 2.2 Prefix Sum vs Running Variable

|Approach|Time (build)|Time (query)|Space|
|---|---|---|---|
|Running variable|O(N)|—|O(1)|
|Prefix sum array|O(N)|O(1)|O(N)|

A **running variable** (like in Kadane's algorithm) is perfect when you process the array once and never need to revisit previous sums. It costs O(1) space.

A **prefix sum array** is the right choice when you need range sum queries repeatedly. After O(N) preprocessing, each query `sum(i, j)` is answered in O(1) as `prefix[j] - prefix[i-1]`. If you have Q queries, the total cost is O(N + Q) instead of O(N * Q).

**Tradeoff:** Prefix sum pays O(N) space upfront for fast repeated queries. If you only query once, a simple scan is better.

---

## Part 3 — Recursion & Stack

---

### 3.1 Recursion vs Iteration

|Approach|Time|Space|Risk|
|---|---|---|---|
|Recursion|Same|O(H) call stack|Stack overflow on deep input|
|Iteration|Same|O(H) explicit stack|More verbose, harder to write|

Recursion is elegant and maps naturally to tree/graph problems. The hidden cost is the call stack — each recursive frame takes memory. For a balanced binary tree of N nodes, height H = O(log N), so the stack is small. For a skewed tree (essentially a linked list), H = O(N), and deep recursion can cause a stack overflow in production.

**Iterative DFS** using an explicit stack avoids stack overflow and is preferred in production. In interviews, recursive solutions are usually acceptable unless the interviewer specifically asks for an iterative approach or the input can be arbitrarily deep.

**Interview signal:** Mentioning "this could stack overflow on a skewed tree" and offering an iterative alternative shows depth.

---

### 3.2 DFS vs BFS

|Approach|Time|Space|Best For|
|---|---|---|---|
|DFS|O(V + E)|O(H) — depth|Path existence, backtracking, topological sort|
|BFS|O(V + E)|O(W) — width|Shortest path (unweighted), level-order, nearest neighbor|

**DFS** dives deep before going wide. It uses memory proportional to the depth of the search tree. It is the natural choice for: detecting cycles, topological sort, solving mazes (any path), and all backtracking problems (subsets, permutations).

**BFS** explores level by level. It guarantees the shortest path in an unweighted graph — DFS does not. BFS uses memory proportional to the width of the tree, which can be enormous for wide graphs (think a tree with branching factor 1000).

**The classic mistake:** Using DFS to find the shortest path in an unweighted graph. DFS finds _a_ path, not necessarily the shortest one.

**Choosing between them:**

- "Shortest path / minimum steps / nearest" → BFS
- "Any path / all paths / cycle detection / ordering" → DFS

---

## Part 4 — Dynamic Programming

---

### 4.1 Top-Down (Memoization) vs Bottom-Up (Tabulation)

|Approach|Time|Space|Best For|
|---|---|---|---|
|Top-down (memo)|O(States)|O(States) + call stack|Natural recursion, sparse state space|
|Bottom-up (table)|O(States)|O(States), often optimizable|Dense state space, no recursion overhead|

**Top-down memoization** starts from the problem and breaks it down. It is easy to reason about because it follows the natural recursive structure of the problem. It only computes states that are actually needed (lazy evaluation), which helps when many states are unreachable. The downside is the overhead of recursive function calls and the O(depth) call stack.

**Bottom-up tabulation** fills a table iteratively starting from base cases. It is often faster in practice due to no function call overhead and better cache locality. Crucially, it allows space optimization — when dp[i] only depends on dp[i-1] and dp[i-2], you can discard old rows and use O(1) space instead of O(N).

**Space optimization** is only possible with bottom-up. If an interviewer asks to optimize space complexity, switch to bottom-up.

**Interview signal:** Starting with a recursive + memo solution, then converting to bottom-up and optimizing space, is the gold standard approach for DP problems.

---

### 4.2 1D DP vs 2D DP

|Approach|Space|When to Use|
|---|---|---|
|1D DP|O(N) or O(W)|Single-sequence problems (LIS, coin change, house robber)|
|2D DP|O(M × N)|Two-sequence problems (LCS, edit distance) or grid problems|

The number of dimensions in your DP table matches the number of "changing variables" in your state. If the answer depends on one index (position in one array), use 1D. If it depends on two indices (position in two arrays, or row and column in a grid), use 2D.

**Space optimization for 2D DP:** If dp[i][j] only depends on dp[i-1][...], you can often reduce to two 1D arrays (current row and previous row), cutting space from O(M×N) to O(N). For some problems (like 0/1 Knapsack), you can further reduce to a single 1D array by iterating in the right direction.

---

### 4.3 Knapsack Loop Order: Why It Matters

In the **0/1 Knapsack** (each item used at most once), iterating the capacity from HIGH to LOW prevents using the same item twice:

```
for each item:
    for w from W down to weight[i]:   ← backwards prevents reuse
        dp[w] = max(dp[w], dp[w - weight[i]] + value[i])
```

In **Unbounded Knapsack / Coin Change** (items can be reused), iterate LOW to HIGH:

```
for each coin:
    for w from coin up to amount:     ← forwards allows reuse
        dp[w] += dp[w - coin]
```

Getting this direction wrong is the single most common DP bug. The reasoning: when filling dp[w] with a forward loop, dp[w - coin] has already been updated in the current pass, so it can include the current item again. With a backward loop, dp[w - coin] still reflects the state before the current item was considered.

---

## Part 5 — Trees

---

### 5.1 Recursive DFS vs Iterative BFS on Trees

Most tree problems have a natural recursive DFS solution. The tradeoffs mirror section 3.1/3.2, but with a tree-specific note:

For **level-order** problems (level averages, zigzag traversal, right side view), BFS with a queue is almost always cleaner than a DFS that tracks depth. The BFS solution naturally separates levels; a DFS solution must simulate level separation with depth tracking.

For **path problems** (path sum, max path sum, diameter), recursive DFS with return values is cleaner. The key insight is that the recursive function solves a _subproblem_ (best result rooted at this node) and passes information up the call stack to a global answer variable.

---

### 5.2 BST Property: When It Helps and When It Does Not

A Binary Search Tree gives you O(log N) search, insert, and delete — but only on a **balanced** BST. A BST that grows from sorted input degenerates into a linked list with O(N) height, making all operations O(N).

| Structure        | Search   | Insert   | Space |
| ---------------- | -------- | -------- | ----- |
| Sorted array     | O(log N) | O(N)     | O(N)  |
| BST (balanced)   | O(log N) | O(log N) | O(N)  |
| BST (degenerate) | O(N)     | O(N)     | O(N)  |
| HashMap          | O(1) avg | O(1) avg | O(N)  |

Use a BST (or its self-balancing variants like AVL/Red-Black trees) when you need sorted order AND fast insert/delete. If you only need fast lookup and do not care about order, a HashMap beats a BST.

**Kth Smallest in BST:** The BST property means an in-order traversal yields sorted order for free. Kth smallest is simply the kth node visited in-order. No sorting required — this is the BST's biggest gift.

---

## Part 6 — Graphs

---

### 6.1 Adjacency List vs Adjacency Matrix

|Representation|Space|Edge Query|Neighbor Iteration|Best For|
|---|---|---|---|---|
|Adjacency list|O(V + E)|O(degree)|O(degree)|Sparse graphs|
|Adjacency matrix|O(V²)|O(1)|O(V)|Dense graphs, edge weight lookup|

Almost all interview graph problems use **adjacency lists** because real-world graphs are sparse (E << V²). Adjacency matrices waste memory and make neighbor iteration slow (you must scan the whole row even if only 2 neighbors exist).

Use an adjacency matrix when: V is small (under a few hundred), you need O(1) edge-weight lookups, or the problem is inherently grid-based (grids are implicit adjacency matrices).

---

### 6.2 BFS vs Dijkstra for Shortest Path

|Algorithm|Edge Weights|Time|Space|
|---|---|---|---|
|BFS|Unweighted (or uniform)|O(V + E)|O(V)|
|Dijkstra|Non-negative weights|O((V + E) log V)|O(V)|
|Bellman-Ford|Any weights (incl. negative)|O(V × E)|O(V)|

**BFS** finds the shortest path in an unweighted graph. Each edge has cost 1. Do not use Dijkstra here — it works, but it is overkill and wastes log V factor.

**Dijkstra** handles non-negative weighted graphs. It fails silently with negative edges — it may find a non-optimal path and never detect the error.

**Bellman-Ford** handles negative weights and detects negative cycles. It is much slower (O(V×E)) and is only needed when negative edges exist.

**Interview pattern:** If you see "minimum cost path" with weights → Dijkstra. If you see "minimum steps/hops" → BFS. Mixing these up is a common mistake.

---

### 6.3 Union-Find vs DFS for Cycle Detection / Connectivity

|Approach|Time|Space|Best For|
|---|---|---|---|
|DFS|O(V + E)|O(V)|Directed OR undirected, single query|
|Union-Find (DSU)|O(α(N)) per op|O(V)|Undirected, incremental edge addition|

**DFS cycle detection** works on both directed and undirected graphs. For directed graphs, you track nodes in the current recursion stack to catch back edges. For undirected graphs, you track the parent to avoid false positives from the edge you just came from.

**Union-Find** is faster per operation (near O(1) amortized with path compression + union by rank) and is the natural choice for **dynamic connectivity** — when edges are added one at a time and you repeatedly ask "are X and Y connected?" It does not directly support directed graphs or extracting the actual path.

**The practical rule:** If edges arrive incrementally and you need fast connectivity queries → Union-Find. If you need the full cycle or work on directed graphs → DFS.

---

### 6.4 Topological Sort: DFS vs Kahn's Algorithm (BFS)

Both produce a valid topological ordering in O(V + E).

|Approach|Detects Cycle|Returns Ordering|Notes|
|---|---|---|---|
|DFS post-order|Yes (via recursion stack)|Reverse of finish times|Elegant, recursive|
|Kahn's (BFS)|Yes (incomplete output)|Direct queue order|Iterative, easier to modify|

**DFS topological sort** uses the finish time of each node. When a node finishes (all descendants processed), prepend it to the result. A back edge (visiting a node currently in the recursion stack) means a cycle exists.

**Kahn's algorithm** starts with all nodes of in-degree zero, processes them like BFS, and decrements neighbor in-degrees. If the final count of processed nodes equals V, no cycle exists. If fewer, a cycle was present.

**Practical preference:** Kahn's is easier to reason about iteratively and makes cycle detection trivial (just check the count). DFS is more compact. Both are acceptable in interviews — pick the one you can implement without bugs.

---

## Part 7 — Heaps & Priority Queues

---

### 7.1 Sorting vs Heap for Top-K Problems

|Approach|Time|Space|Best For|
|---|---|---|---|
|Full sort|O(N log N)|O(1) or O(N)|Small N, or you need all elements sorted|
|Min-heap of size K|O(N log K)|O(K)|Large N, small K|
|Quickselect|O(N) avg|O(1)|Finding Kth element only, not ordering|

When K is much smaller than N, a heap of size K is significantly faster than full sorting. The idea: maintain a min-heap of the top K seen so far. For each new element, if it is larger than the heap's min, evict the min and insert the new element.

**Quickselect** is the fastest for finding a single Kth element but does not produce a sorted top-K list and has O(N²) worst case (though randomized pivot keeps it O(N) in practice). Use it only when asked specifically for the Kth element and not the full sorted top-K.

---

### 7.2 Min-Heap vs Max-Heap Choice

The choice depends on what you want to quickly evict:

- **Top-K largest elements** → use a **min-heap** of size K. The smallest of your top-K sits at the top, so you can quickly compare and evict it when a larger element arrives.
- **Top-K smallest elements** → use a **max-heap** of size K. The largest of your top-K is evicted when a smaller element arrives.

This is counterintuitive at first. The mental model: the heap's root is your "weakest member" — the one most at risk of being evicted. You want to evict the opposite of what you are collecting.

**Median of a stream:** Use a max-heap for the lower half and a min-heap for the upper half. The two roots are always the two middle elements. Rebalancing after each insertion keeps the size difference at most 1, giving O(1) median and O(log N) insertion.

---

## Part 8 — Strings

---

### 8.1 Two-Pointer vs HashMap for Substring Problems

|Approach|Time|Space|Notes|
|---|---|---|---|
|Sliding window (two pointer)|O(N)|O(K) — window contents|Works for fixed/variable window|
|HashMap|O(N)|O(N)|Better when you need counts/positions|

Sliding window and HashMap are not mutually exclusive — the best sliding window solutions often use a HashMap inside the window to track character counts. The outer structure is two pointers; the inner bookkeeping uses a HashMap.

**For fixed-size windows** (exactly K characters), the window size is constant and you slide both pointers together.

**For variable-size windows** (longest/shortest with some property), you expand the right pointer greedily and shrink the left pointer when the window becomes invalid.

The invariant to maintain: at any point, the window between `left` and `right` should either be valid (then try to expand) or invalid (then shrink).

---

### 8.2 Sorting Strings vs Trie for Prefix/Grouping Problems

|Approach|Time (build)|Query|Space|
|---|---|---|---|
|Sorting|O(N · K log K)|Scan: O(N · K)|O(1) extra|
|Trie|O(N · K)|O(K) per word|O(N · K)|

**Sorting** is simpler and sufficient when you need to group anagrams (sort each string to get a key) or find common prefixes (sort the array, compare first and last). No data structure overhead.

**Trie** is the right choice when you need fast prefix searches, autocomplete, or word existence checks across a dictionary. After O(N·K) build time, each prefix query is O(K) — independent of how many words are in the trie. Sorting cannot match this for repeated prefix queries.

**The crossover point:** If you have a fixed word list and many prefix queries, build a Trie. If you have a one-time grouping task, sort.

---

## Part 9 — Backtracking

---

### 9.1 When Backtracking Is the Right Tool (And When DP Is Better)

Backtracking and DP are both used for "explore all possibilities" problems, but they solve different subclasses.

|Criteria|Use Backtracking|Use DP|
|---|---|---|
|Need to list all solutions|Yes|No (DP gives count/optimal)|
|Subproblems overlap|No|Yes|
|State is path-dependent|Yes|No|
|Goal: count or optimize|Sometimes|Always|

**Backtracking** is correct when you need the actual solutions (all subsets, all permutations, all valid partitions). It explores all possibilities but prunes branches early when a constraint is violated. It cannot be memoized effectively when the state includes the current path, because two branches with the same remaining choices but different histories are not equivalent.

**DP** is correct when subproblems overlap and you only need a count or optimal value (not the paths themselves). "Number of ways to make change" is DP — you do not need to enumerate every combination. "All combinations that sum to target" is backtracking — you need the actual lists.

**The tell:** If the question asks "how many ways" or "minimum/maximum", think DP. If it asks "list all" or "find all valid", think backtracking.

---

### 9.2 Pruning Strategies in Backtracking

Backtracking without pruning is just brute force. Pruning is what makes it tractable.

**Sort the input first.** Sorting enables two forms of pruning:

1. Skip duplicate values to avoid identical branches (Group Anagrams, 3Sum, Subsets II).
2. Stop iterating early when the remaining candidates already exceed the target (Combination Sum).

**Track a running total.** Instead of computing sums after building each path, maintain a running sum. When it exceeds the target, prune immediately without exploring deeper.

**Use constraint propagation.** In N-Queens and Sudoku, maintain sets of which rows, columns, and diagonals are occupied. Check the constraint in O(1) rather than re-scanning the whole board.

**The cost of not pruning:** Without pruning, Combination Sum would be O(N^target) in the worst case. With sorting + early termination, it becomes O(N^(target/min_candidate)) — exponentially better.

---

## Part 10 — Sorting

---

### 10.1 Merge Sort vs Quick Sort vs Heap Sort

|Algorithm|Time (avg)|Time (worst)|Space|Stable|Best For|
|---|---|---|---|---|---|
|Merge sort|O(N log N)|O(N log N)|O(N)|Yes|Linked lists, guaranteed worst-case|
|Quick sort|O(N log N)|O(N²)|O(log N)|No|Arrays, cache-friendly, fastest in practice|
|Heap sort|O(N log N)|O(N log N)|O(1)|No|In-place with guaranteed O(N log N)|

**Merge sort** is the standard choice for linked lists (no random access needed) and whenever a stable sort is required. Its O(N) space is the main downside for large arrays.

**Quick sort** is the fastest in practice due to excellent cache locality (in-place, accesses contiguous memory). The O(N²) worst case occurs on already-sorted or reverse-sorted input — randomizing the pivot avoids this. This is why most standard library sort implementations are based on Quick Sort (introsort, which switches to Heap Sort when recursion depth exceeds a threshold).

**Heap sort** is the only comparison sort that is both in-place and worst-case O(N log N). It is rarely the fastest in practice due to poor cache behavior but is useful when memory is strictly limited.

**Interview signal:** Knowing _why_ Quick Sort beats Merge Sort in practice (cache locality) despite identical asymptotic complexity is a strong signal of understanding beyond Big-O.

---

### 10.2 Counting Sort / Bucket Sort vs Comparison Sort

|Algorithm|Time|Space|Requirement|
|---|---|---|---|
|Comparison sort (any)|O(N log N)|Varies|None|
|Counting sort|O(N + K)|O(K)|Integer keys in range [0, K]|
|Bucket sort|O(N + K) avg|O(N + K)|Uniformly distributed values|

**Counting sort** breaks the O(N log N) lower bound by not making comparisons. It is optimal when the range of values K is small relative to N. For example, sorting N = 10,000 elements with values in [0, 100], counting sort is O(10,100) ≈ O(N) — vastly faster than O(N log N).

The constraint is strict: values must be integers (or mappable to integers) in a bounded range. It is useless for arbitrary strings or large ranges.

**In interview context:** Counting sort appears as a sub-step in problems like "Sort Colors" (Dutch National Flag), where values are only {0, 1, 2}. Recognizing that comparison sort is overkill and applying a linear-time approach is a strong signal.

---

## Part 11 — Space Complexity Deep Dive

---

### 11.1 In-Place vs Out-of-Place: When to Care

Many problems can be solved in-place (O(1) extra space) or out-of-place (O(N) extra space). The in-place solution is often trickier to implement correctly.

**Cases where in-place is worth the complexity:**

- Memory is genuinely constrained (embedded systems, streaming data)
- The interviewer explicitly asks for O(1) space
- The problem structure naturally allows it (two-pointer swap, reverse in-place)

**Cases where out-of-place is fine:**

- The problem creates new output by definition (returning a new array)
- The in-place solution would require O(N log N) time vs O(N) for out-of-place (sometimes the space-time tradeoff goes the wrong way)

**The often-overlooked cost:** Recursive solutions always use O(H) stack space even if you think of them as "in-place". For tree problems, this is O(log N) for balanced and O(N) for skewed trees. True O(1) space on a tree requires Morris traversal — rarely needed in interviews.

---

### 11.2 The Space-Time Tradeoff in Practice

The most common space-time tradeoff in DSA problems:

|Optimization|Time gained|Space cost|Example|
|---|---|---|---|
|Precompute prefix sums|Query: O(N) → O(1)|O(N)|Range sum queries|
|Build HashMap/HashSet|Search: O(N) → O(1)|O(N)|Two Sum, grouping|
|Memoization table|Exponential → Polynomial|O(States)|All DP problems|
|Build adjacency list|—|O(V + E)|All graph problems|
|Precompute frequency array|Loop: O(N) → O(1) per query|O(K)|Anagram checks|

The pattern is always: **pay memory upfront to avoid recomputation later**. This is the core idea behind every caching and DP optimization.

**When the tradeoff is not worth it:** If the preprocessed structure is queried only once, you saved zero time and wasted space. Always ask: "how many times will I use this?"

---

## Part 12 — Quick Reference: Problem → Best Approach

|Problem Pattern|First Instinct|Why|
|---|---|---|
|Find pair summing to target|HashMap|O(1) complement lookup|
|Subarray with max sum|Kadane's (DP, O(1) space)|No need for full DP table|
|Shortest path, unweighted|BFS|Guarantees minimum hops|
|Shortest path, weighted|Dijkstra|Min-heap gives greedy optimality|
|Detect cycle, undirected|Union-Find|O(α) per edge, clean|
|Detect cycle, directed|DFS + recursion stack|Union-Find can't handle direction|
|Top-K elements|Min-heap of size K|O(N log K) vs O(N log N) for sort|
|Sliding window, any property|Two pointers + HashMap|O(N) vs O(N²) brute force|
|All combinations/subsets|Backtracking|Must enumerate; DP only gives count|
|Count ways / min cost|DP|Overlapping subproblems|
|Prefix queries|Trie|O(K) per query vs O(N·K) scan|
|Connectivity, dynamic edges|Union-Find|Amortized O(α) per operation|
|Interval scheduling|Sort by end time + greedy|Classic exchange argument|
|Kth smallest in BST|In-order DFS|BST property gives sorted order free|
|Matrix BFS (islands, walls)|BFS/DFS + visited set|Standard grid traversal|

---

_Remember: In an interview, the process matters as much as the answer. State the tradeoffs out loud. Tell the interviewer what you are giving up before you commit to an approach._