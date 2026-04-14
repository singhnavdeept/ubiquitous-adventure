# DSA Pattern Questions — Master List
### Topic-wise problems to cover every pattern inside each topic

> **How to use this list:** Work through one topic at a time, in order. Within each topic, problems are arranged from foundational → intermediate → advanced. Finishing a topic's list means you have seen every major pattern variation that topic can throw at you.

---

## Topic 1 — Arrays & Hash Maps

> **Patterns covered:** frequency counting, complement lookup, prefix sums, in-place manipulation, sorting tricks

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Two Sum](https://leetcode.com/problems/two-sum/) | Easy | HashMap complement |
| 2 | [Contains Duplicate](https://leetcode.com/problems/contains-duplicate/) | Easy | HashSet membership |
| 3 | [Valid Anagram](https://leetcode.com/problems/valid-anagram/) | Easy | Frequency count |
| 4 | [Move Zeroes](https://leetcode.com/problems/move-zeroes/) | Easy | In-place two-pointer |
| 5 | [Best Time to Buy and Sell Stock](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/) | Easy | Running min/max |
| 6 | [Maximum Subarray](https://leetcode.com/problems/maximum-subarray/) | Medium | Kadane's algorithm |
| 7 | [Product of Array Except Self](https://leetcode.com/problems/product-of-array-except-self/) | Medium | Prefix + suffix pass |
| 8 | [Group Anagrams](https://leetcode.com/problems/group-anagrams/) | Medium | Sort-as-key HashMap |
| 9 | [Top K Frequent Elements](https://leetcode.com/problems/top-k-frequent-elements/) | Medium | Frequency + heap/bucket |
| 10 | [Subarray Sum Equals K](https://leetcode.com/problems/subarray-sum-equals-k/) | Medium | Prefix sum + HashMap |
| 11 | [Longest Consecutive Sequence](https://leetcode.com/problems/longest-consecutive-sequence/) | Medium | HashSet streak counting |
| 12 | [Sort Colors](https://leetcode.com/problems/sort-colors/) | Medium | Dutch National Flag / 3-way partition |
| 13 | [Find All Duplicates in an Array](https://leetcode.com/problems/find-all-duplicates-in-an-array/) | Medium | Index marking trick |
| 14 | [Maximum Product Subarray](https://leetcode.com/problems/maximum-product-subarray/) | Medium | Track min and max simultaneously |
| 15 | [4Sum](https://leetcode.com/problems/4sum/) | Medium | Sorted + two nested loops + two pointers |

---

## Topic 2 — Two Pointers

> **Patterns covered:** converging pointers, fast & slow pointers, partition pointers, multi-sorted array merge

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Valid Palindrome](https://leetcode.com/problems/valid-palindrome/) | Easy | Converging pointers |
| 2 | [Reverse String](https://leetcode.com/problems/reverse-string/) | Easy | In-place swap |
| 3 | [Two Sum II (Sorted Array)](https://leetcode.com/problems/two-sum-ii-input-array-is-sorted/) | Medium | Converging on sorted array |
| 4 | [Remove Duplicates from Sorted Array](https://leetcode.com/problems/remove-duplicates-from-sorted-array/) | Easy | Slow/fast write pointer |
| 5 | [Container With Most Water](https://leetcode.com/problems/container-with-most-water/) | Medium | Converging + greedy move |
| 6 | [3Sum](https://leetcode.com/problems/3sum/) | Medium | Sort + fix one + converge |
| 7 | [Trapping Rain Water](https://leetcode.com/problems/trapping-rain-water/) | Hard | Two pointer with max tracking |
| 8 | [Boats to Save People](https://leetcode.com/problems/boats-to-save-people/) | Medium | Greedy converging |
| 9 | [Squares of a Sorted Array](https://leetcode.com/problems/squares-of-a-sorted-array/) | Easy | Converging fill from back |
| 10 | [3Sum Closest](https://leetcode.com/problems/3sum-closest/) | Medium | Fix one + converge + track closest |
| 11 | [Partition Labels](https://leetcode.com/problems/partition-labels/) | Medium | Last occurrence + greedy extend |
| 12 | [Next Permutation](https://leetcode.com/problems/next-permutation/) | Medium | Rightmost pivot + reverse suffix |

---

## Topic 3 — Sliding Window

> **Patterns covered:** fixed window, variable window (expand/shrink), window with frequency map, minimum/maximum window

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Maximum Average Subarray I](https://leetcode.com/problems/maximum-average-subarray-i/) | Easy | Fixed window, basic |
| 2 | [Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/) | Medium | Variable window + HashSet |
| 3 | [Permutation in String](https://leetcode.com/problems/permutation-in-string/) | Medium | Fixed window + frequency match |
| 4 | [Longest Repeating Character Replacement](https://leetcode.com/problems/longest-repeating-character-replacement/) | Medium | Variable window + max freq tracking |
| 5 | [Fruits Into Baskets](https://leetcode.com/problems/fruit-into-baskets/) | Medium | Variable window, at most K distinct |
| 6 | [Minimum Size Subarray Sum](https://leetcode.com/problems/minimum-size-subarray-sum/) | Medium | Variable window shrink for minimum |
| 7 | [Minimum Window Substring](https://leetcode.com/problems/minimum-window-substring/) | Hard | Variable window + need counter |
| 8 | [Sliding Window Maximum](https://leetcode.com/problems/sliding-window-maximum/) | Hard | Fixed window + monotonic deque |
| 9 | [Substring with Concatenation of All Words](https://leetcode.com/problems/substring-with-concatenation-of-all-words/) | Hard | Fixed window + word frequency map |
| 10 | [Find All Anagrams in a String](https://leetcode.com/problems/find-all-anagrams-in-a-string/) | Medium | Fixed window + frequency match |
| 11 | [Count Number of Nice Subarrays](https://leetcode.com/problems/count-number-of-nice-subarrays/) | Medium | Variable window + at-most trick |

---

## Topic 4 — Binary Search

> **Patterns covered:** classic search, rotated array, search on answer space, boundary/predicate search

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Binary Search](https://leetcode.com/problems/binary-search/) | Easy | Classic template |
| 2 | [First Bad Version](https://leetcode.com/problems/first-bad-version/) | Easy | Left boundary search |
| 3 | [Search Insert Position](https://leetcode.com/problems/search-insert-position/) | Easy | Leftmost insertion point |
| 4 | [Search in Rotated Sorted Array](https://leetcode.com/problems/search-in-rotated-sorted-array/) | Medium | Identify sorted half |
| 5 | [Find Minimum in Rotated Sorted Array](https://leetcode.com/problems/find-minimum-in-rotated-sorted-array/) | Medium | Binary search on pivot |
| 6 | [Find Peak Element](https://leetcode.com/problems/find-peak-element/) | Medium | Binary search on slope |
| 7 | [Search a 2D Matrix](https://leetcode.com/problems/search-a-2d-matrix/) | Medium | Flatten to 1D binary search |
| 8 | [Koko Eating Bananas](https://leetcode.com/problems/koko-eating-bananas/) | Medium | Binary search on answer |
| 9 | [Capacity To Ship Packages Within D Days](https://leetcode.com/problems/capacity-to-ship-packages-within-d-days/) | Medium | Binary search on answer |
| 10 | [Find K Closest Elements](https://leetcode.com/problems/find-k-closest-elements/) | Medium | Binary search left boundary of window |
| 11 | [Median of Two Sorted Arrays](https://leetcode.com/problems/median-of-two-sorted-arrays/) | Hard | Binary search on partition |
| 12 | [Split Array Largest Sum](https://leetcode.com/problems/split-array-largest-sum/) | Hard | Binary search on answer + greedy check |

---

## Topic 5 — Linked Lists

> **Patterns covered:** fast & slow pointers, reversal, dummy node, merge, cycle detection

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Reverse Linked List](https://leetcode.com/problems/reverse-linked-list/) | Easy | Iterative pointer reversal |
| 2 | [Merge Two Sorted Lists](https://leetcode.com/problems/merge-two-sorted-lists/) | Easy | Dummy node + merge |
| 3 | [Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/) | Easy | Floyd's slow/fast |
| 4 | [Middle of the Linked List](https://leetcode.com/problems/middle-of-the-linked-list/) | Easy | Slow/fast to find midpoint |
| 5 | [Remove Nth Node From End of List](https://leetcode.com/problems/remove-nth-node-from-end-of-list/) | Medium | Two pointers N apart |
| 6 | [Linked List Cycle II](https://leetcode.com/problems/linked-list-cycle-ii/) | Medium | Floyd's + cycle start detection |
| 7 | [Reorder List](https://leetcode.com/problems/reorder-list/) | Medium | Find mid + reverse second half + merge |
| 8 | [Palindrome Linked List](https://leetcode.com/problems/palindrome-linked-list/) | Easy | Slow/fast + reverse + compare |
| 9 | [Add Two Numbers](https://leetcode.com/problems/add-two-numbers/) | Medium | Carry simulation with dummy |
| 10 | [Copy List with Random Pointer](https://leetcode.com/problems/copy-list-with-random-pointer/) | Medium | HashMap old→new node mapping |
| 11 | [LRU Cache](https://leetcode.com/problems/lru-cache/) | Medium | Doubly linked list + HashMap |
| 12 | [Merge K Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/) | Hard | Min-heap across K lists |

---

## Topic 6 — Stacks & Queues

> **Patterns covered:** monotonic stack, min stack, valid brackets, BFS with queue, deque for sliding window

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Valid Parentheses](https://leetcode.com/problems/valid-parentheses/) | Easy | Stack bracket matching |
| 2 | [Implement Queue using Stacks](https://leetcode.com/problems/implement-queue-using-stacks/) | Easy | Two-stack FIFO simulation |
| 3 | [Min Stack](https://leetcode.com/problems/min-stack/) | Medium | Parallel min-tracking stack |
| 4 | [Next Greater Element I](https://leetcode.com/problems/next-greater-element-i/) | Easy | Monotonic decreasing stack |
| 5 | [Daily Temperatures](https://leetcode.com/problems/daily-temperatures/) | Medium | Monotonic stack with index |
| 6 | [Evaluate Reverse Polish Notation](https://leetcode.com/problems/evaluate-reverse-polish-notation/) | Medium | Operand stack |
| 7 | [Decode String](https://leetcode.com/problems/decode-string/) | Medium | Stack for nested expansion |
| 8 | [Largest Rectangle in Histogram](https://leetcode.com/problems/largest-rectangle-in-histogram/) | Hard | Monotonic increasing stack |
| 9 | [Maximal Rectangle](https://leetcode.com/problems/maximal-rectangle/) | Hard | Histogram per row + monotonic stack |
| 10 | [Car Fleet](https://leetcode.com/problems/car-fleet/) | Medium | Sort + monotonic stack on time |
| 11 | [Asteroid Collision](https://leetcode.com/problems/asteroid-collision/) | Medium | Stack with collision simulation |

---

## Topic 7 — Trees (Binary Trees & BST)

> **Patterns covered:** DFS pre/in/post order, BFS level order, path problems, LCA, BST property

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/) | Easy | Post-order DFS swap |
| 2 | [Maximum Depth of Binary Tree](https://leetcode.com/problems/maximum-depth-of-binary-tree/) | Easy | DFS height recursion |
| 3 | [Diameter of Binary Tree](https://leetcode.com/problems/diameter-of-binary-tree/) | Easy | DFS + global max update |
| 4 | [Balanced Binary Tree](https://leetcode.com/problems/balanced-binary-tree/) | Easy | DFS height + balance check |
| 5 | [Same Tree](https://leetcode.com/problems/same-tree/) | Easy | Simultaneous DFS |
| 6 | [Path Sum](https://leetcode.com/problems/path-sum/) | Easy | DFS with target reduction |
| 7 | [Binary Tree Level Order Traversal](https://leetcode.com/problems/binary-tree-level-order-traversal/) | Medium | BFS with level separation |
| 8 | [Binary Tree Right Side View](https://leetcode.com/problems/binary-tree-right-side-view/) | Medium | BFS last node per level |
| 9 | [Lowest Common Ancestor of a Binary Tree](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/) | Medium | Post-order return bubbling |
| 10 | [Binary Tree Maximum Path Sum](https://leetcode.com/problems/binary-tree-maximum-path-sum/) | Hard | DFS gain + global bending path |
| 11 | [Construct Binary Tree from Preorder and Inorder](https://leetcode.com/problems/construct-binary-tree-from-preorder-and-inorder-traversal/) | Medium | Divide and conquer on traversals |
| 12 | [Serialize and Deserialize Binary Tree](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/) | Hard | BFS encode + queue decode |
| 13 | [Validate Binary Search Tree](https://leetcode.com/problems/validate-binary-search-tree/) | Medium | DFS with min/max bounds |
| 14 | [Kth Smallest Element in a BST](https://leetcode.com/problems/kth-smallest-element-in-a-bst/) | Medium | In-order counter |
| 15 | [Binary Tree Zigzag Level Order Traversal](https://leetcode.com/problems/binary-tree-zigzag-level-order-traversal/) | Medium | BFS + direction flag |

---

## Topic 8 — Dynamic Programming

> **Patterns covered:** 1D linear DP, 2D string DP, knapsack (0/1 and unbounded), matrix DP, DP on sequences

### 8a — 1D / Linear DP

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Climbing Stairs](https://leetcode.com/problems/climbing-stairs/) | Easy | Fibonacci DP |
| 2 | [Min Cost Climbing Stairs](https://leetcode.com/problems/min-cost-climbing-stairs/) | Easy | Min-cost linear DP |
| 3 | [House Robber](https://leetcode.com/problems/house-robber/) | Medium | No-adjacent selection DP |
| 4 | [House Robber II](https://leetcode.com/problems/house-robber-ii/) | Medium | Circular array — run twice |
| 5 | [Decode Ways](https://leetcode.com/problems/decode-ways/) | Medium | 1D DP with 1/2-char decode check |
| 6 | [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/) | Medium | patience sort / binary search DP |
| 7 | [Maximum Product Subarray](https://leetcode.com/problems/maximum-product-subarray/) | Medium | Track min and max simultaneously |
| 8 | [Jump Game](https://leetcode.com/problems/jump-game/) | Medium | Greedy max-reach DP |
| 9 | [Jump Game II](https://leetcode.com/problems/jump-game-ii/) | Medium | BFS greedy min-jumps |
| 10 | [Word Break](https://leetcode.com/problems/word-break/) | Medium | DP[i] = any valid split |

### 8b — Knapsack & Combinations

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Coin Change](https://leetcode.com/problems/coin-change/) | Medium | Unbounded knapsack min-count |
| 2 | [Coin Change II](https://leetcode.com/problems/coin-change-ii/) | Medium | Unbounded knapsack count ways |
| 3 | [Partition Equal Subset Sum](https://leetcode.com/problems/partition-equal-subset-sum/) | Medium | 0/1 knapsack boolean |
| 4 | [Target Sum](https://leetcode.com/problems/target-sum/) | Medium | 0/1 knapsack count ways |
| 5 | [Combination Sum IV](https://leetcode.com/problems/combination-sum-iv/) | Medium | Unbounded knapsack ordered count |
| 6 | [Last Stone Weight II](https://leetcode.com/problems/last-stone-weight-ii/) | Medium | Minimize diff knapsack |

### 8c — 2D / String DP

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Unique Paths](https://leetcode.com/problems/unique-paths/) | Medium | Grid path count DP |
| 2 | [Unique Paths II](https://leetcode.com/problems/unique-paths-ii/) | Medium | Grid with obstacles |
| 3 | [Minimum Path Sum](https://leetcode.com/problems/minimum-path-sum/) | Medium | Grid min-cost DP |
| 4 | [Longest Common Subsequence](https://leetcode.com/problems/longest-common-subsequence/) | Medium | 2D string DP |
| 5 | [Edit Distance](https://leetcode.com/problems/edit-distance/) | Medium | 2D DP insert/delete/replace |
| 6 | [Longest Palindromic Substring](https://leetcode.com/problems/longest-palindromic-substring/) | Medium | Expand around center / 2D DP |
| 7 | [Palindromic Substrings](https://leetcode.com/problems/palindromic-substrings/) | Medium | Count centers expansion |
| 8 | [Distinct Subsequences](https://leetcode.com/problems/distinct-subsequences/) | Hard | 2D count DP |

---

## Topic 9 — Graphs

> **Patterns covered:** DFS/BFS on grid, cycle detection, topological sort, Union-Find, Dijkstra

### 9a — Grid / Island Problems

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Number of Islands](https://leetcode.com/problems/number-of-islands/) | Medium | DFS flood-fill |
| 2 | [Max Area of Island](https://leetcode.com/problems/max-area-of-island/) | Medium | DFS flood-fill + count |
| 3 | [Surrounded Regions](https://leetcode.com/problems/surrounded-regions/) | Medium | BFS from borders |
| 4 | [Pacific Atlantic Water Flow](https://leetcode.com/problems/pacific-atlantic-water-flow/) | Medium | Reverse BFS from both oceans |
| 5 | [Rotting Oranges](https://leetcode.com/problems/rotting-oranges/) | Medium | Multi-source BFS levels |

### 9b — General Graph DFS / BFS

| #   | Problem                                                                                                                                    | Difficulty | Pattern                       |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------ | ---------- | ----------------------------- |
| 1   | [Clone Graph](https://leetcode.com/problems/clone-graph/)                                                                                  | Medium     | DFS + HashMap old→new         |
| 2   | [Word Ladder](https://leetcode.com/problems/word-ladder/)                                                                                  | Hard       | BFS shortest transformation   |
| 3   | [Number of Connected Components in Undirected Graph](https://leetcode.com/problems/number-of-connected-components-in-an-undirected-graph/) | Medium     | DFS or Union-Find components  |
| 4   | [Graph Valid Tree](https://leetcode.com/problems/graph-valid-tree/)                                                                        | Medium     | Union-Find + edge count check |

### 9c — Topological Sort

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Course Schedule](https://leetcode.com/problems/course-schedule/) | Medium | Kahn's / DFS cycle detect |
| 2 | [Course Schedule II](https://leetcode.com/problems/course-schedule-ii/) | Medium | Kahn's — return order |
| 3 | [Alien Dictionary](https://leetcode.com/problems/alien-dictionary/) | Hard | Build graph from char order + topo sort |
| 4 | [Find Eventual Safe States](https://leetcode.com/problems/find-eventual-safe-states/) | Medium | Reverse graph + topo sort |

### 9d — Union-Find (DSU)

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Redundant Connection](https://leetcode.com/problems/redundant-connection/) | Medium | DSU cycle detection |
| 2 | [Accounts Merge](https://leetcode.com/problems/accounts-merge/) | Medium | DSU + group by root |
| 3 | [Number of Operations to Make Network Connected](https://leetcode.com/problems/number-of-operations-to-make-network-connected/) | Medium | DSU count components |

### 9e — Weighted Shortest Path

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Network Delay Time](https://leetcode.com/problems/network-delay-time/) | Medium | Dijkstra from single source |
| 2 | [Path With Minimum Effort](https://leetcode.com/problems/path-with-minimum-effort/) | Medium | Dijkstra on grid |
| 3 | [Cheapest Flights Within K Stops](https://leetcode.com/problems/cheapest-flights-within-k-stops/) | Medium | Bellman-Ford K iterations |

---

## Topic 10 — Backtracking

> **Patterns covered:** subsets, permutations, combinations, constraint satisfaction, pruning

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Subsets](https://leetcode.com/problems/subsets/) | Medium | Backtrack add at every node |
| 2 | [Subsets II](https://leetcode.com/problems/subsets-ii/) | Medium | Subsets + skip duplicates |
| 3 | [Permutations](https://leetcode.com/problems/permutations/) | Medium | Swap-based backtrack |
| 4 | [Permutations II](https://leetcode.com/problems/permutations-ii/) | Medium | Permutations + used[] + skip dup |
| 5 | [Combination Sum](https://leetcode.com/problems/combination-sum/) | Medium | Backtrack with reuse allowed |
| 6 | [Combination Sum II](https://leetcode.com/problems/combination-sum-ii/) | Medium | Backtrack no reuse + skip dup |
| 7 | [Letter Combinations of a Phone Number](https://leetcode.com/problems/letter-combinations-of-a-phone-number/) | Medium | Backtrack over digit→char mapping |
| 8 | [Palindrome Partitioning](https://leetcode.com/problems/palindrome-partitioning/) | Medium | Backtrack + palindrome check |
| 9 | [Generate Parentheses](https://leetcode.com/problems/generate-parentheses/) | Medium | Backtrack open/close count constraint |
| 10 | [N-Queens](https://leetcode.com/problems/n-queens/) | Hard | Backtrack + column/diagonal conflict sets |
| 11 | [Sudoku Solver](https://leetcode.com/problems/sudoku-solver/) | Hard | Backtrack + constraint propagation |
| 12 | [Word Search](https://leetcode.com/problems/word-search/) | Medium | Backtrack DFS on 2D grid |

---

## Topic 11 — Heaps & Priority Queues

> **Patterns covered:** top-K, K-way merge, two-heap median, scheduling

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Kth Largest Element in an Array](https://leetcode.com/problems/kth-largest-element-in-an-array/) | Medium | Min-heap size K / quickselect |
| 2 | [Top K Frequent Elements](https://leetcode.com/problems/top-k-frequent-elements/) | Medium | Freq map + min-heap size K |
| 3 | [K Closest Points to Origin](https://leetcode.com/problems/k-closest-points-to-origin/) | Medium | Max-heap size K |
| 4 | [Task Scheduler](https://leetcode.com/problems/task-scheduler/) | Medium | Greedy + max-heap on frequencies |
| 5 | [Find Median from Data Stream](https://leetcode.com/problems/find-median-from-data-stream/) | Hard | Two-heap (max + min) |
| 6 | [Merge K Sorted Lists](https://leetcode.com/problems/merge-k-sorted-lists/) | Hard | Min-heap across K lists |
| 7 | [Kth Smallest Element in a Sorted Matrix](https://leetcode.com/problems/kth-smallest-element-in-a-sorted-matrix/) | Medium | Min-heap row-by-row |
| 8 | [Reorganize String](https://leetcode.com/problems/reorganize-string/) | Medium | Max-heap greedy character placement |
| 9 | [Design Twitter](https://leetcode.com/problems/design-twitter/) | Medium | Min-heap K-way merge of feeds |

---

## Topic 12 — Greedy & Intervals

> **Patterns covered:** interval sort/merge, scheduling, greedy local choice, jump game variants

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Merge Intervals](https://leetcode.com/problems/merge-intervals/) | Medium | Sort by start + merge |
| 2 | [Insert Interval](https://leetcode.com/problems/insert-interval/) | Medium | Three-phase scan |
| 3 | [Non-overlapping Intervals](https://leetcode.com/problems/non-overlapping-intervals/) | Medium | Sort by end + greedy keep |
| 4 | [Meeting Rooms II](https://leetcode.com/problems/meeting-rooms-ii/) | Medium | Sort by start + min-heap ends |
| 5 | [Jump Game](https://leetcode.com/problems/jump-game/) | Medium | Greedy max-reach |
| 6 | [Jump Game II](https://leetcode.com/problems/jump-game-ii/) | Medium | Greedy BFS min-jumps |
| 7 | [Gas Station](https://leetcode.com/problems/gas-station/) | Medium | Circular greedy sum |
| 8 | [Hand of Straights](https://leetcode.com/problems/hand-of-straights/) | Medium | Sort + greedy group |
| 9 | [Task Scheduler](https://leetcode.com/problems/task-scheduler/) | Medium | Greedy idle-slot formula |
| 10 | [Minimum Number of Arrows to Burst Balloons](https://leetcode.com/problems/minimum-number-of-arrows-to-burst-balloons/) | Medium | Sort by end + greedy arrow placement |

---

## Topic 13 — Tries

> **Patterns covered:** insert/search/prefix, wildcard search, word search with trie pruning

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Implement Trie (Prefix Tree)](https://leetcode.com/problems/implement-trie-prefix-tree/) | Medium | Build trie node by node |
| 2 | [Design Add and Search Words Data Structure](https://leetcode.com/problems/design-add-and-search-words-data-structure/) | Medium | Trie + DFS for wildcard '.' |
| 3 | [Word Search II](https://leetcode.com/problems/word-search-ii/) | Hard | Trie + backtracking DFS on grid |
| 4 | [Replace Words](https://leetcode.com/problems/replace-words/) | Medium | Trie prefix lookup per word |
| 5 | [Longest Word in Dictionary](https://leetcode.com/problems/longest-word-in-dictionary/) | Medium | Trie build-level-by-level |

---

## Topic 14 — Bit Manipulation

> **Patterns covered:** XOR tricks, bit counting, power of 2, masking

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Single Number](https://leetcode.com/problems/single-number/) | Easy | XOR cancels pairs |
| 2 | [Number of 1 Bits](https://leetcode.com/problems/number-of-1-bits/) | Easy | Kernighan n & (n-1) |
| 3 | [Reverse Bits](https://leetcode.com/problems/reverse-bits/) | Easy | Bit-by-bit reversal |
| 4 | [Missing Number](https://leetcode.com/problems/missing-number/) | Easy | XOR or Gauss sum |
| 5 | [Power of Two](https://leetcode.com/problems/power-of-two/) | Easy | n & (n-1) == 0 check |
| 6 | [Counting Bits](https://leetcode.com/problems/counting-bits/) | Easy | DP on lowest bit |
| 7 | [Sum of Two Integers](https://leetcode.com/problems/sum-of-two-integers/) | Medium | XOR sum + AND carry |
| 8 | [Single Number II](https://leetcode.com/problems/single-number-ii/) | Medium | Bit count mod 3 |

---

## Topic 15 — Math & Matrix

> **Patterns covered:** spiral traversal, rotate, diagonal, simulation

| # | Problem | Difficulty | Pattern |
|---|---------|-----------|---------|
| 1 | [Rotate Image](https://leetcode.com/problems/rotate-image/) | Medium | Transpose + reverse rows |
| 2 | [Spiral Matrix](https://leetcode.com/problems/spiral-matrix/) | Medium | Boundary shrink simulation |
| 3 | [Set Matrix Zeroes](https://leetcode.com/problems/set-matrix-zeroes/) | Medium | Use first row/col as flags |
| 4 | [Happy Number](https://leetcode.com/problems/happy-number/) | Easy | Slow/fast cycle detection |
| 5 | [Pow(x, n)](https://leetcode.com/problems/powx-n/) | Medium | Fast exponentiation (halving) |
| 6 | [Plus One](https://leetcode.com/problems/plus-one/) | Easy | Carry propagation |
| 7 | [Count Primes](https://leetcode.com/problems/count-primes/) | Medium | Sieve of Eratosthenes |
| 8 | [Game of Life](https://leetcode.com/problems/game-of-life/) | Medium | In-place state encoding |

---

## Curated Fast-Track List (Top 40 if time is short)

> If you have less than 2 weeks, do only these. They cover the maximum number of patterns in minimum time.

| # | Problem | Topic |
|---|---------|-------|
| 1 | [Two Sum](https://leetcode.com/problems/two-sum/) | HashMap |
| 2 | [Best Time to Buy and Sell Stock](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/) | Arrays |
| 3 | [Valid Anagram](https://leetcode.com/problems/valid-anagram/) | HashMap |
| 4 | [Maximum Subarray](https://leetcode.com/problems/maximum-subarray/) | Kadane's |
| 5 | [Product of Array Except Self](https://leetcode.com/problems/product-of-array-except-self/) | Prefix/Suffix |
| 6 | [3Sum](https://leetcode.com/problems/3sum/) | Two Pointers |
| 7 | [Container With Most Water](https://leetcode.com/problems/container-with-most-water/) | Two Pointers |
| 8 | [Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/) | Sliding Window |
| 9 | [Minimum Window Substring](https://leetcode.com/problems/minimum-window-substring/) | Sliding Window |
| 10 | [Binary Search](https://leetcode.com/problems/binary-search/) | Binary Search |
| 11 | [Search in Rotated Sorted Array](https://leetcode.com/problems/search-in-rotated-sorted-array/) | Binary Search |
| 12 | [Koko Eating Bananas](https://leetcode.com/problems/koko-eating-bananas/) | Binary Search on answer |
| 13 | [Reverse Linked List](https://leetcode.com/problems/reverse-linked-list/) | Linked List |
| 14 | [Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/) | Fast/Slow pointers |
| 15 | [Reorder List](https://leetcode.com/problems/reorder-list/) | Linked List |
| 16 | [Valid Parentheses](https://leetcode.com/problems/valid-parentheses/) | Stack |
| 17 | [Daily Temperatures](https://leetcode.com/problems/daily-temperatures/) | Monotonic Stack |
| 18 | [Largest Rectangle in Histogram](https://leetcode.com/problems/largest-rectangle-in-histogram/) | Monotonic Stack |
| 19 | [Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/) | Tree DFS |
| 20 | [Binary Tree Level Order Traversal](https://leetcode.com/problems/binary-tree-level-order-traversal/) | Tree BFS |
| 21 | [Lowest Common Ancestor of a Binary Tree](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/) | Tree DFS |
| 22 | [Binary Tree Maximum Path Sum](https://leetcode.com/problems/binary-tree-maximum-path-sum/) | Tree DFS hard |
| 23 | [Validate Binary Search Tree](https://leetcode.com/problems/validate-binary-search-tree/) | BST |
| 24 | [Climbing Stairs](https://leetcode.com/problems/climbing-stairs/) | DP 1D |
| 25 | [House Robber](https://leetcode.com/problems/house-robber/) | DP 1D |
| 26 | [Coin Change](https://leetcode.com/problems/coin-change/) | DP Knapsack |
| 27 | [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/) | DP Subsequence |
| 28 | [Longest Common Subsequence](https://leetcode.com/problems/longest-common-subsequence/) | DP 2D |
| 29 | [Word Break](https://leetcode.com/problems/word-break/) | DP + HashSet |
| 30 | [Partition Equal Subset Sum](https://leetcode.com/problems/partition-equal-subset-sum/) | DP 0/1 Knapsack |
| 31 | [Number of Islands](https://leetcode.com/problems/number-of-islands/) | Graph DFS |
| 32 | [Course Schedule](https://leetcode.com/problems/course-schedule/) | Topological Sort |
| 33 | [Pacific Atlantic Water Flow](https://leetcode.com/problems/pacific-atlantic-water-flow/) | Multi-source BFS |
| 34 | [Redundant Connection](https://leetcode.com/problems/redundant-connection/) | Union-Find |
| 35 | [Subsets](https://leetcode.com/problems/subsets/) | Backtracking |
| 36 | [Combination Sum](https://leetcode.com/problems/combination-sum/) | Backtracking |
| 37 | [Permutations](https://leetcode.com/problems/permutations/) | Backtracking |
| 38 | [Merge Intervals](https://leetcode.com/problems/merge-intervals/) | Greedy Intervals |
| 39 | [Find Median from Data Stream](https://leetcode.com/problems/find-median-from-data-stream/) | Two Heaps |
| 40 | [Implement Trie](https://leetcode.com/problems/implement-trie-prefix-tree/) | Trie |

---

*Total: ~140 problems covering every major pattern. Master these and you will recognize the approach within the first 30 seconds of reading any OA question.*
