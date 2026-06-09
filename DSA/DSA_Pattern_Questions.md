---
tags:
  - dsa
  - concept/practice
---


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

| #   | Problem                                                                                                                         | Topic                   |
| --- | ------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| 1   | [Two Sum](https://leetcode.com/problems/two-sum/)                                                                               | HashMap                 |
| 2   | [Best Time to Buy and Sell Stock](https://leetcode.com/problems/best-time-to-buy-and-sell-stock/)                               | Arrays                  |
| 3   | [Valid Anagram](https://leetcode.com/problems/valid-anagram/)                                                                   | HashMap                 |
| 4   | [Maximum Subarray](https://leetcode.com/problems/maximum-subarray/)                                                             | Kadane's                |
| 5   | [Product of Array Except Self](https://leetcode.com/problems/product-of-array-except-self/)                                     | Prefix/Suffix           |
| 6   | [3Sum](https://leetcode.com/problems/3sum/)                                                                                     | Two Pointers            |
| 7   | [Container With Most Water](https://leetcode.com/problems/container-with-most-water/)                                           | Two Pointers            |
| 8   | [Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/) | Sliding Window          |
| 9   | [Minimum Window Substring](https://leetcode.com/problems/minimum-window-substring/)                                             | Sliding Window          |
| 10  | [Binary Search](https://leetcode.com/problems/binary-search/)                                                                   | Binary Search           |
| 11  | [Search in Rotated Sorted Array](https://leetcode.com/problems/search-in-rotated-sorted-array/)                                 | Binary Search           |
| 12  | [Koko Eating Bananas](https://leetcode.com/problems/koko-eating-bananas/)                                                       | Binary Search on answer |
| 13  | [Reverse Linked List](https://leetcode.com/problems/reverse-linked-list/)                                                       | Linked List             |
| 14  | [Linked List Cycle](https://leetcode.com/problems/linked-list-cycle/)                                                           | Fast/Slow pointers      |
| 15  | [Reorder List](https://leetcode.com/problems/reorder-list/)                                                                     | Linked List             |
| 16  | [Valid Parentheses](https://leetcode.com/problems/valid-parentheses/)                                                           | Stack                   |
| 17  | [Daily Temperatures](https://leetcode.com/problems/daily-temperatures/)                                                         | Monotonic Stack         |
| 18  | [Largest Rectangle in Histogram](https://leetcode.com/problems/largest-rectangle-in-histogram/)                                 | Monotonic Stack         |
| 19  | [Invert Binary Tree](https://leetcode.com/problems/invert-binary-tree/)                                                         | Tree DFS                |
| 20  | [Binary Tree Level Order Traversal](https://leetcode.com/problems/binary-tree-level-order-traversal/)                           | Tree BFS                |
| 21  | [Lowest Common Ancestor of a Binary Tree](https://leetcode.com/problems/lowest-common-ancestor-of-a-binary-tree/)               | Tree DFS                |
| 22  | [Binary Tree Maximum Path Sum](https://leetcode.com/problems/binary-tree-maximum-path-sum/)                                     | Tree DFS hard           |
| 23  | [Validate Binary Search Tree](https://leetcode.com/problems/validate-binary-search-tree/)                                       | BST                     |
| 24  | [Climbing Stairs](https://leetcode.com/problems/climbing-stairs/)                                                               | DP 1D                   |
| 25  | [House Robber](https://leetcode.com/problems/house-robber/)                                                                     | DP 1D                   |
| 26  | [Coin Change](https://leetcode.com/problems/coin-change/)                                                                       | DP Knapsack             |
| 27  | [Longest Increasing Subsequence](https://leetcode.com/problems/longest-increasing-subsequence/)                                 | DP Subsequence          |
| 28  | [Longest Common Subsequence](https://leetcode.com/problems/longest-common-subsequence/)                                         | DP 2D                   |
| 29  | [Word Break](https://leetcode.com/problems/word-break/)                                                                         | DP + HashSet            |
| 30  | [Partition Equal Subset Sum](https://leetcode.com/problems/partition-equal-subset-sum/)                                         | DP 0/1 Knapsack         |
| 31  | [Number of Islands](https://leetcode.com/problems/number-of-islands/)                                                           | Graph DFS               |
| 32  | [Course Schedule](https://leetcode.com/problems/course-schedule/)                                                               | Topological Sort        |
| 33  | [Pacific Atlantic Water Flow](https://leetcode.com/problems/pacific-atlantic-water-flow/)                                       | Multi-source BFS        |
| 34  | [Redundant Connection](https://leetcode.com/problems/redundant-connection/)                                                     | Union-Find              |
| 35  | [Subsets](https://leetcode.com/problems/subsets/)[[Practice run 1#19. Subsets]]                                                 | Backtracking            |
| 36  | [Combination Sum](https://leetcode.com/problems/combination-sum/)                                                               | Backtracking            |
| 37  | [Permutations](https://leetcode.com/problems/permutations/)                                                                     | Backtracking            |
| 38  | [Merge Intervals](https://leetcode.com/problems/merge-intervals/)                                                               | Greedy Intervals        |
| 39  | [Find Median from Data Stream](https://leetcode.com/problems/find-median-from-data-stream/)                                     | Two Heaps               |
| 40  | [Implement Trie](https://leetcode.com/problems/implement-trie-prefix-tree/)                                                     | Trie                    |
|     |                                                                                                                                 |                         |

---

*Total: ~140 problems covering every major pattern. Master these and you will recognize the approach within the first 30 seconds of reading any OA question.*





> A complete guide to mastering system design questions — from fundamentals to advanced patterns, with a structured LeetCode-style progression.

---


## How to Approach Every Design Question

Before diving into topics, internalize this universal framework. Use it on every question:

```
1. Clarify Requirements (5 min)
   - Functional: What does the system do?
   - Non-functional: Scale, latency, availability, consistency?
   - Constraints: Read-heavy or write-heavy? DAU? QPS?

2. Estimate Scale (3 min)
   - Daily Active Users → QPS
   - Storage per day/year
   - Bandwidth (read + write)

3. High-Level Design (10 min)
   - Draw the core components: Client → API → Service → DB
   - Identify bottlenecks early

4. Deep Dive (15 min)
   - Pick 2-3 components to go deep on
   - Talk about tradeoffs, not just solutions

5. Wrap Up (5 min)
   - Failure modes, monitoring, future scaling
```

---

## Phase 1 — Data Structures You Must Design (Start Here)

These are the "LRU Cache"-style questions. Pure implementation + design combined. Master these first — they appear in both coding rounds and system design rounds.

### Order to attempt:

| #   | Problem                          | Platform      | Core Concept                       |
| --- | -------------------------------- | ------------- | ---------------------------------- |
| 1   | **LRU Cache**                    | LeetCode #146 | HashMap + Doubly Linked List       |
| 2   | **[[LFU Cache]]**                | LeetCode #460 | Min-heap or freq buckets           |
| 3   | **Design HashMap**               | LeetCode #706 | Hashing, chaining, open addressing |
| 4   | **Design Linked List**           | LeetCode #707 | Pointer manipulation               |
| 8   | **Design Twitter** (simplified)  | LeetCode #355 | Heap + following graph             |
| 9   | **Find Median from Data Stream** | LeetCode #295 | Two heaps                          |
| 10  | **Serialize & Deserialize BST**  | LeetCode #449 | Tree encoding                      |
| 11  | **Implement Trie**               | LeetCode #208 | Prefix trees                       |
| 12  | **Design Search Autocomplete**   | LeetCode #642 | Trie + ranking                     |
| 13  | **Design In-Memory File System** | LeetCode #588 | Trie on filesystem                 |
| 14  | **Design Hit Counter**           | LeetCode #362 | Sliding window, circular buffer    |
| 15  | **Time-Based Key-Value Store**   | LeetCode #981 | Binary search on timestamps        |

**Key insight:** For all of these, always discuss:

- Time complexity of each operation
- Space tradeoffs
- What happens at scale (this is where design begins)

---

## Phase 2 — Core Concepts to Study (Theory)

Study these topics before moving to full system design questions:

### 2.1 Caching

- Cache eviction policies: **LRU, LFU, FIFO, Random**
- Cache invalidation strategies: **write-through, write-back, write-around**
- Cache stampede / thundering herd
- Tools: Redis, Memcached
- **Key question to answer yourself:** When should you NOT cache?

### 2.2 Databases

- **SQL vs NoSQL** — when to use which
- Indexing (B-Tree, LSM-Tree)
- Sharding strategies: **range, hash, directory-based**
- Replication: **leader-follower, multi-leader, leaderless**
- CAP theorem and its practical meaning
- ACID vs BASE

### 2.3 Distributed Systems Fundamentals

- Consistent hashing — virtual nodes
- Quorum reads/writes (N, R, W)
- Vector clocks and conflict resolution
- Gossip protocol
- Heartbeats and failure detection

### 2.4 Scalability Patterns

- Horizontal vs vertical scaling
- Load balancing: Round robin, least connections, IP hash
- Database connection pooling
- Read replicas

### 2.5 Messaging & Async Processing

- Message queues (Kafka, RabbitMQ, SQS)
- Producer-consumer pattern
- Fan-out pattern
- Backpressure handling
- At-least-once vs exactly-once delivery

### 2.6 API Design

- REST vs GraphQL vs gRPC
- Rate limiting algorithms: **Token Bucket, Leaky Bucket, Fixed Window, Sliding Window Log**
- Pagination strategies
- Idempotency keys

### 2.7 Networking

- DNS resolution flow
- CDN (Content Delivery Networks)
- Long polling vs WebSockets vs SSE
- TCP vs UDP tradeoffs

---

## Phase 3 — Classic Full System Design Questions

Attempt these in order. Each one builds on previous concepts.

### Tier 1 — Foundational (Do These First)

#### 1. Design a URL Shortener (like bit.ly)

- Concepts: Hashing, Base62 encoding, DB schema, redirects, analytics
- Tricky parts: Collision handling, custom URLs, expiry

#### 2. Design a Rate Limiter

- Concepts: Token bucket / sliding window, distributed counter, Redis
- Tricky parts: Distributed rate limiting across servers

#### 3. Design a Key-Value Store (like Redis)

- Concepts: In-memory storage, persistence (AOF/RDB), replication, partitioning
- Tricky parts: Consistency during failures

#### 4. Design a Web Crawler

- Concepts: BFS/DFS, URL frontier, deduplication, politeness policy
- Tricky parts: Handling traps, distributed crawling

#### 5. Design Pastebin

- Concepts: Object storage, unique ID generation, expiry, access control
- Good starting point before tackling complex social systems

---

### Tier 2 — Intermediate

#### 6. Design a Notification System

- Concepts: Push vs pull, fan-out on write vs read, message queues, retry logic
- Tricky parts: Delivery guarantees, user preferences

#### 7. Design a News Feed (like Facebook/Twitter)

- Concepts: Fan-out, ranking algorithms, pagination
- Tricky parts: Celebrity problem (users with millions of followers)

#### 8. Design a Search Engine (typeahead / autocomplete)

- Concepts: Trie, ranking, personalization, distributed indexing
- Tricky parts: Real-time vs batch indexing

#### 9. Design Google Drive / Dropbox

- Concepts: Chunking, deduplication, sync protocol, conflict resolution
- Tricky parts: Delta sync, offline support

#### 10. Design a Chat System (like WhatsApp)

- Concepts: WebSockets, message ordering, read receipts, group messaging
- Tricky parts: Delivery guarantees, online/offline status

#### 11. Design YouTube / Video Streaming

- Concepts: Video transcoding, CDN, adaptive bitrate streaming, DAG processing pipeline
- Tricky parts: Encoding pipeline, resumable uploads

---

### Tier 3 — Advanced

#### 12. Design a Distributed Message Queue (like Kafka)

- Concepts: Log-structured storage, partitions, consumer groups, offset management
- Tricky parts: Exactly-once semantics, ordering guarantees

#### 13. Design a Proximity Service / Yelp

- Concepts: Geohashing, quadtree, spatial indexing
- Tricky parts: Dynamic data (moving users), radius search accuracy

#### 14. Design Uber / Lyft

- Concepts: Real-time location, matching algorithm, surge pricing, trip lifecycle
- Tricky parts: Consistency in ride matching, geospatial at scale

#### 15. Design a Distributed ID Generator (like Snowflake)

- Concepts: Timestamp + datacenter ID + sequence, clock skew
- Tricky parts: Monotonic IDs, NTP issues

#### 16. Design a Stock Exchange / Trading System

- Concepts: Order book, matching engine, low-latency, ACID transactions
- Tricky parts: Exactly-once trade execution, audit logs

#### 17. Design Google Maps

- Concepts: Graph algorithms (Dijkstra, A*), tile rendering, ETA prediction, map data storage
- Tricky parts: Real-time traffic, map updates at scale

#### 18. Design a Payment System

- Concepts: Idempotency, double-entry bookkeeping, distributed transactions, compliance
- Tricky parts: Consistency, fraud detection, rollback

---

## Phase 4 — Numbers Every Engineer Should Know

Memorize these. Use them in every estimation:

```
Latency (approximate):
  L1 cache reference       ~  0.5 ns
  Main memory reference    ~  100 ns
  SSD random read          ~  150 µs
  HDD random read          ~  10 ms
  Network round-trip (DC)  ~  500 µs
  Network round-trip (US)  ~  150 ms

Storage:
  1 char = 1 byte
  1 int  = 4 bytes
  1 UUID = 16 bytes
  1 image (avg) = ~300 KB
  1 video (1 min, 720p) ≈ 50 MB

Traffic math:
  1M users, 10 req/day = ~100 QPS
  1B users, 10 req/day = ~100,000 QPS
  
Availability:
  99%    = 87.6 hours downtime/year
  99.9%  = 8.76 hours downtime/year
  99.99% = 52.6 minutes downtime/year
```

---

## Phase 5 — Resources & Practice Plan

### Books

- **"Designing Data-Intensive Applications"** by Martin Kleppmann — read this cover to cover
- **"System Design Interview"** by Alex Xu (Vol 1 + 2) — great for interview prep
- **"The Art of Scalability"** by Abbott & Fisher

### Online Platforms

|Platform|What to use it for|
|---|---|
|**LeetCode**|Phase 1 problems (data structure design)|
|**Grokking System Design**|Structured walkthroughs|
|**ByteByteGo** (Alex Xu)|Visual breakdowns of classic systems|
|**High Scalability Blog**|Real-world architecture case studies|
|**Engineering blogs**|Netflix, Uber, Airbnb, Discord, Slack|

### Practice Schedule (8 Weeks)

```
Week 1-2:  Complete all Phase 1 LeetCode problems
Week 3:    Study Phase 2 theory (caching, databases, distributed systems)
Week 4:    Tier 1 design questions — do 2 per day with a timer
Week 5-6:  Tier 2 questions — go deep, write out your designs
Week 7:    Tier 3 questions — focus on tradeoffs
Week 8:    Mock interviews — practice talking out loud, whiteboarding
```

---

## Common Mistakes to Avoid

1. **Jumping into solutions without clarifying requirements.** Always ask 3-5 questions first.
2. **Designing for perfect scale from day 1.** Start simple, then evolve.
3. **Ignoring failure cases.** What happens when a node dies? When the DB is slow?
4. **Not knowing the numbers.** Estimation is a core skill, not optional.
5. **Being silent.** In interviews, thinking out loud IS the skill being evaluated.
6. **Over-engineering.** A simpler design you can defend > a complex one you cannot.

---

## The One Mental Model That Ties It All Together

Every system design question is fundamentally about **tradeoffs**:

```
Consistency  ←→  Availability
Latency      ←→  Throughput
Cost         ←→  Performance
Simplicity   ←→  Flexibility
```

Your job is not to find the "right" answer — it's to make informed tradeoffs and articulate WHY you made them. The interviewer wants to see how you think, not just what you know.

---




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