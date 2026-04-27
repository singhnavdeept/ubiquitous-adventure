

> **Goal:** Systematic mastery of competitive programming from Div. 2 A/B to Div. 1 D/E level.  
> **Difficulty Scale:** ⭐ = 800–1200 | ⭐⭐ = 1200–1600 | ⭐⭐⭐ = 1600–2000 | ⭐⭐⭐⭐ = 2000–2400 | ⭐⭐⭐⭐⭐ = 2400+  
> **Legend:** ✅ Solved | 🔁 Revisit | ❌ Unsolved

---

## 📋 Table of Contents

1. [Implementation & Brute Force](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#1-implementation--brute-force)
2. [Math & Number Theory](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#2-math--number-theory)
3. [Sorting & Greedy](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#3-sorting--greedy)
4. [Binary Search](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#4-binary-search)
5. [Two Pointers & Sliding Window](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#5-two-pointers--sliding-window)
6. [Prefix Sums & Difference Arrays](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#6-prefix-sums--difference-arrays)
7. [Recursion & Backtracking](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#7-recursion--backtracking)
8. [Data Structures — STL & Basic](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#8-data-structures--stl--basic)
9. [Stacks, Queues & Deques](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#9-stacks-queues--deques)
10. [Hashing & Maps](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#10-hashing--maps)
11. [Strings & String Algorithms](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#11-strings--string-algorithms)
12. [Graphs — BFS & DFS](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#12-graphs--bfs--dfs)
13. [Shortest Paths](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#13-shortest-paths)
14. [Trees & Tree DP](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#14-trees--tree-dp)
15. [Dynamic Programming — 1D & 2D](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#15-dynamic-programming--1d--2d)
16. [DP on Intervals & Bitmask](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#16-dp-on-intervals--bitmask)
17. [Segment Trees & BIT (Fenwick)](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#17-segment-trees--bit-fenwick)
18. [Divide & Conquer](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#18-divide--conquer)
19. [Disjoint Set Union (DSU)](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#19-disjoint-set-union-dsu)
20. [Game Theory](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#20-game-theory)
21. [Flows & Matching](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#21-flows--matching)
22. [Geometry](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#22-geometry)
23. [Advanced Topics](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#23-advanced-topics)
24. [Mixed Bag — Contest Grinders](https://claude.ai/chat/371f658b-228b-4f5f-a9c3-3fb225920e79#24-mixed-bag--contest-grinders)

---

## 1. Implementation & Brute Force

> **Focus:** Simulation, careful reading, edge cases. Master these before anything else.

| #   | Problem                                                                            | Rating | Tag       | Status | Notes                 |
| --- | ---------------------------------------------------------------------------------- | ------ | --------- | ------ | --------------------- |
| 1   | [Theatre Square — 1A](https://codeforces.com/problemset/problem/1/A)               | ⭐      | Math/Impl | ❌      | Classic first problem |
| 2   | [Way Too Long Words — 71A](https://codeforces.com/problemset/problem/71/A)         | ⭐      | Strings   | ❌      |                       |
| 3   | [Team — 231A](https://codeforces.com/problemset/problem/231/A)                     | ⭐      | Impl      | ❌      |                       |
| 4   | [Bit++ — 282A](https://codeforces.com/problemset/problem/282/A)                    | ⭐      | Impl      | ❌      |                       |
| 5   | [Next Round — 158A](https://codeforces.com/problemset/problem/158/A)               | ⭐      | Impl      | ❌      |                       |
| 6   | [Petya and Strings — 196A](https://codeforces.com/problemset/problem/196/A)        | ⭐      | Impl      | ❌      |                       |
| 7   | [Domino piling — 50A](https://codeforces.com/problemset/problem/50/A)              | ⭐      | Math      | ❌      |                       |
| 8   | [Soldier and Bananas — 546A](https://codeforces.com/problemset/problem/546/A)      | ⭐      | Math      | ❌      |                       |
| 9   | [Football — 96A](https://codeforces.com/problemset/problem/96/A)                   | ⭐      | Strings   | ❌      |                       |
| 10  | [Even Odds — 318A](https://codeforces.com/problemset/problem/318/A)                | ⭐      | Math      | ❌      |                       |
| 11  | [Stones on the Table — 266A](https://codeforces.com/problemset/problem/266/A)      | ⭐      | Impl      | ❌      |                       |
| 12  | [Helpful Maths — 339A](https://codeforces.com/problemset/problem/339/A)            | ⭐      | Sorting   | ❌      |                       |
| 13  | [George and Accommodation — 467A](https://codeforces.com/problemset/problem/467/A) | ⭐      | Impl      | ❌      |                       |
| 14  | [Brain's Photo — 707A](https://codeforces.com/problemset/problem/707/A)            | ⭐      | Impl      | ❌      |                       |
| 15  | [Minimum Difficulty — 1033A](https://codeforces.com/problemset/problem/1033/A)     | ⭐      | Impl      | ❌      |                       |

---

## 2. Math & Number Theory

> **Focus:** GCD/LCM, primes, modular arithmetic, combinatorics, Euler's totient.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|16|[Beautiful Matrix — 263B](https://codeforces.com/problemset/problem/263/B)|⭐⭐|Math|❌||
|17|[Modular Exponentiation — 913A](https://codeforces.com/problemset/problem/913/A)|⭐|Math|❌||
|18|[Primes or Palindromes — 568B](https://codeforces.com/problemset/problem/568/B)|⭐⭐|Prime Sieve|❌||
|19|[Bear and Prime 100 — 680B](https://codeforces.com/problemset/problem/680/B)|⭐⭐|Primes|❌||
|20|[GCD and LCM — 75C](https://codeforces.com/problemset/problem/75/C)|⭐⭐|Math|❌||
|21|[Neko's Maze Game — 1152D](https://codeforces.com/problemset/problem/1152/D)|⭐⭐⭐|Math|❌||
|22|[Power Sequence — 1036D](https://codeforces.com/problemset/problem/1036/D)|⭐⭐⭐|Math|❌||
|23|[Counting Divisors — 1033D](https://codeforces.com/problemset/problem/1033/D)|⭐⭐⭐|Number Theory|❌||
|24|[Primitive Root — 284A](https://codeforces.com/problemset/problem/284/A)|⭐⭐|Math|❌||
|25|[Pie or Pi — 598A](https://codeforces.com/problemset/problem/598/A)|⭐|Math|❌||
|26|[Vasya and Beautiful Arrays — 1209E](https://codeforces.com/problemset/problem/1209/E)|⭐⭐⭐|Math|❌||
|27|[Euler's function practice — 776E](https://codeforces.com/problemset/problem/776/E)|⭐⭐⭐⭐|Number Theory|❌||
|28|[Coprime Integers — 1139B](https://codeforces.com/problemset/problem/1139/B)|⭐⭐|Math|❌||
|29|[Sum of Divisors — 1535E](https://codeforces.com/problemset/problem/1535/E)|⭐⭐⭐|Number Theory|❌||
|30|[Factorial and Divisors — 913D](https://codeforces.com/problemset/problem/913/D)|⭐⭐⭐|Math|❌||

---

## 3. Sorting & Greedy

> **Focus:** Exchange argument, interval scheduling, activity selection.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|31|[Vasya's Dad — 1042A](https://codeforces.com/problemset/problem/1042/A)|⭐|Greedy|❌||
|32|[Vanya and Cards — 628C](https://codeforces.com/problemset/problem/628/C)|⭐⭐|Greedy|❌||
|33|[New Year and the Marvellous Strings — 908B](https://codeforces.com/problemset/problem/908/B)|⭐⭐|Greedy|❌||
|34|[Queue at School — 545C](https://codeforces.com/problemset/problem/545/C)|⭐⭐|Simulation|❌||
|35|[Coins for Change — 1196C](https://codeforces.com/problemset/problem/1196/C)|⭐⭐|Greedy|❌||
|36|[Choosing Teams — 432A](https://codeforces.com/problemset/problem/432/A)|⭐|Greedy|❌||
|37|[Greg and Array — 296B](https://codeforces.com/problemset/problem/296/B)|⭐⭐|Greedy|❌||
|38|[Vasya's Seven — 1066A](https://codeforces.com/problemset/problem/1066/A)|⭐|Sort|❌||
|39|[Largest Number — 908A](https://codeforces.com/problemset/problem/908/A)|⭐|Greedy|❌||
|40|[Antenna — 1236D](https://codeforces.com/problemset/problem/1236/D)|⭐⭐⭐|Greedy/DP|❌||
|41|[Restore Permutation — 1234D](https://codeforces.com/problemset/problem/1234/D)|⭐⭐⭐|Greedy|❌||
|42|[Minimum LCM — 1225B](https://codeforces.com/problemset/problem/1225/B)|⭐⭐|Greedy|❌||
|43|[Divide Candies — 1213A](https://codeforces.com/problemset/problem/1213/A)|⭐|Math/Greedy|❌||
|44|[Sorting by Subsequences — 723E](https://codeforces.com/problemset/problem/723/E)|⭐⭐⭐|Sort/Cycles|❌||
|45|[Array Partition — 785C](https://codeforces.com/problemset/problem/785/C)|⭐⭐⭐|Sort/Binary Search|❌||

---

## 4. Binary Search

> **Focus:** Binary search on answer, parametric search, search in rotated arrays.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|46|[Magic Powder - 1 — 670D1](https://codeforces.com/problemset/problem/670/D1)|⭐⭐|Binary Search|❌||
|47|[Preparing for Printing — 1065B](https://codeforces.com/problemset/problem/1065/B)|⭐⭐|Binary Search|❌||
|48|[Kuro and GCD and XOR and SUM — 979D](https://codeforces.com/problemset/problem/979/D)|⭐⭐⭐|BS + DS|❌||
|49|[Sagheer, the Hausmeister — 812E](https://codeforces.com/problemset/problem/812/E)|⭐⭐⭐⭐|BS + DP|❌||
|50|[Renting Bikes — 363D](https://codeforces.com/problemset/problem/363/D)|⭐⭐⭐|Binary Search|❌||
|51|[Two Melodies — 850E](https://codeforces.com/problemset/problem/850/E)|⭐⭐⭐⭐|BS + DP|❌||
|52|[Parallel Parking — 287B](https://codeforces.com/problemset/problem/287/B)|⭐⭐|Binary Search|❌||
|53|[Ternary Search — 578C](https://codeforces.com/problemset/problem/578/C)|⭐⭐⭐|Ternary Search|❌||
|54|[Factory Machines — 1070B](https://codeforces.com/problemset/problem/1070/B)|⭐⭐|Binary Search|❌||
|55|[Log Splitting — 1213F](https://codeforces.com/problemset/problem/1213/F)|⭐⭐⭐⭐|Binary Search|❌||
|56|[Nauuo and Permutation — 1172E](https://codeforces.com/problemset/problem/1172/E)|⭐⭐⭐⭐|BS + Greedy|❌||
|57|[Jury Marks — 851C](https://codeforces.com/problemset/problem/851/C)|⭐⭐⭐|Binary Search|❌||
|58|[Hossein and BFS — 1167E](https://codeforces.com/problemset/problem/1167/E)|⭐⭐⭐|BS + BFS|❌||
|59|[Good Subarrays — 1398C](https://codeforces.com/problemset/problem/1398/C)|⭐⭐|Binary Search|❌||
|60|[Maximum Median — 1201C](https://codeforces.com/problemset/problem/1201/C)|⭐⭐⭐|Binary Search|❌||

---

## 5. Two Pointers & Sliding Window

> **Focus:** Fixed/variable window, frequency maps, monotonic conditions.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|61|[Colorful Stones — 1040B](https://codeforces.com/problemset/problem/1040/B)|⭐⭐|Two Pointers|❌||
|62|[Find Pair — 160C](https://codeforces.com/problemset/problem/160/C)|⭐⭐|Sorting|❌||
|63|[K-Good Segment — 616D](https://codeforces.com/problemset/problem/616/D)|⭐⭐⭐|Two Pointers|❌||
|64|[Nicknames — 499B](https://codeforces.com/problemset/problem/499/B)|⭐⭐|Sliding Window|❌||
|65|[Lucky Mask — 121C](https://codeforces.com/problemset/problem/121/C)|⭐⭐|Two Pointers|❌||
|66|[Ehab and Prefix MEX — 1364D](https://codeforces.com/problemset/problem/1364/D)|⭐⭐⭐|Two Pointers|❌||
|67|[Bear and Shift — 660E](https://codeforces.com/problemset/problem/660/E)|⭐⭐⭐⭐|Sliding Window|❌||
|68|[Vasya and String — 831D](https://codeforces.com/problemset/problem/831/D)|⭐⭐⭐|Sliding Window|❌||
|69|[Pony and Salary — 525E](https://codeforces.com/problemset/problem/525/E)|⭐⭐⭐|Two Pointers|❌||
|70|[Petya and Array — 1042D](https://codeforces.com/problemset/problem/1042/D)|⭐⭐⭐|Two Pointers|❌||

---

## 6. Prefix Sums & Difference Arrays

> **Focus:** Range queries, 2D prefix sums, range updates.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|71|[Little Girl and Maximum Sum — 276C](https://codeforces.com/problemset/problem/276/C)|⭐⭐|Prefix Sum|❌||
|72|[Mean of Array — 1367B](https://codeforces.com/problemset/problem/1367/B)|⭐⭐|Prefix Sum|❌||
|73|[Greg and Array — 296B](https://codeforces.com/problemset/problem/296/B)|⭐⭐|Diff Array|❌||
|74|[Ants — 704B](https://codeforces.com/problemset/problem/704/B)|⭐⭐⭐|Prefix Sum|❌||
|75|[Tourist — 587E](https://codeforces.com/problemset/problem/587/E)|⭐⭐⭐|2D Prefix|❌||
|76|[Divisibility by 25 — 988D](https://codeforces.com/problemset/problem/988/D)|⭐⭐|Prefix|❌||
|77|[Count Pairs — 1189D](https://codeforces.com/problemset/problem/1189/D)|⭐⭐⭐|Prefix|❌||
|78|[Number of Pairs — 1189C](https://codeforces.com/problemset/problem/1189/C)|⭐⭐|Prefix|❌||
|79|[Arpa and a Game — 850A](https://codeforces.com/problemset/problem/850/A)|⭐⭐|Prefix|❌||
|80|[Fixed Point — 1187C](https://codeforces.com/problemset/problem/1187/C)|⭐⭐⭐|Prefix + BS|❌||

---

## 7. Recursion & Backtracking

> **Focus:** Pruning, permutations, subsets, constraint propagation.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|81|[Vitaly and Strings — 518C](https://codeforces.com/problemset/problem/518/C)|⭐⭐|Backtracking|❌||
|82|[All Subsets — 550C](https://codeforces.com/problemset/problem/550/C)|⭐⭐|Backtracking|❌||
|83|[Puzzles — 697C](https://codeforces.com/problemset/problem/697/C)|⭐⭐|Recursion|❌||
|84|[Powers of Two — 1303D](https://codeforces.com/problemset/problem/1303/D)|⭐⭐⭐|Recursion|❌||
|85|[Kleptomania — 1091C](https://codeforces.com/problemset/problem/1091/C)|⭐⭐⭐|Backtracking|❌||

---

## 8. Data Structures — STL & Basic

> **Focus:** Ordered sets, priority queues, policy-based trees, multisets.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|86|[Ehab and Another Construction — 1249C](https://codeforces.com/problemset/problem/1249/C)|⭐⭐|Set|❌||
|87|[Vasya and Multisets — 407E](https://codeforces.com/problemset/problem/407/E)|⭐⭐⭐|Multiset|❌||
|88|[Kalila and Dimna in the Logging Industry — 319C](https://codeforces.com/problemset/problem/319/C)|⭐⭐⭐⭐|Heap|❌||
|89|[Order Book — 572B](https://codeforces.com/problemset/problem/572/B)|⭐⭐|Map|❌||
|90|[Pashmak and Parmida's problem — 459E](https://codeforces.com/problemset/problem/459/E)|⭐⭐⭐|BIT + Map|❌||
|91|[Permutation Restoration — 1327C](https://codeforces.com/problemset/problem/1327/C)|⭐⭐⭐|Greedy + DS|❌||
|92|[Stars — 1293B](https://codeforces.com/problemset/problem/1293/B)|⭐⭐|Ordered Set|❌||
|93|[Eshik and Apples — 1253D](https://codeforces.com/problemset/problem/1253/D)|⭐⭐⭐|DS|❌||
|94|[Dima and Bacteria — 292B](https://codeforces.com/problemset/problem/292/B)|⭐⭐|Map/Set|❌||
|95|[Berland Supermarket — 1209B](https://codeforces.com/problemset/problem/1209/B)|⭐⭐|Priority Queue|❌||

---

## 9. Stacks, Queues & Deques

> **Focus:** Monotonic stack, sliding window max/min, next greater element.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|96|[Maximum Width — 319B](https://codeforces.com/problemset/problem/319/B)|⭐⭐|Stack|❌||
|97|[Nested Segments — 652E](https://codeforces.com/problemset/problem/652/E)|⭐⭐⭐|Stack|❌||
|98|[Glass Carving — 749D](https://codeforces.com/problemset/problem/749/D)|⭐⭐⭐|Ordered Set|❌||
|99|[Longest Regular Bracket Sequence — 5E](https://codeforces.com/problemset/problem/5/E)|⭐⭐⭐|Stack|❌|Classic|
|100|[Stack of Presents — 1748B](https://codeforces.com/problemset/problem/1748/B)|⭐⭐|Stack|❌||
|101|[Queue in the Bank — 816B](https://codeforces.com/problemset/problem/816/B)|⭐⭐|Queue|❌||
|102|[Deque Operations — 344E](https://codeforces.com/problemset/problem/344/E)|⭐⭐⭐|Deque|❌||
|103|[Supermarket — 1583E](https://codeforces.com/problemset/problem/1583/E)|⭐⭐⭐|Mono Stack|❌||
|104|[Maximum of Minimums — 1154G](https://codeforces.com/problemset/problem/1154/G)|⭐⭐⭐⭐|Mono Stack|❌||
|105|[Nikita and Stack — 960F](https://codeforces.com/problemset/problem/960/F)|⭐⭐⭐|Stack + Seg Tree|❌||

---

## 10. Hashing & Maps

> **Focus:** Frequency maps, rolling hash, anagram detection.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|106|[Mahmoud and Ehab and the MEX — 862C](https://codeforces.com/problemset/problem/862/C)|⭐⭐|Hashing|❌||
|107|[Arpa's letter-marked tree — 850C](https://codeforces.com/problemset/problem/850/C)|⭐⭐⭐|Hashing|❌||
|108|[Maps and Legends — 327E](https://codeforces.com/problemset/problem/327/E)|⭐⭐⭐|Hashing|❌||
|109|[Mahmoud and Ehab and the Xors — 862E](https://codeforces.com/problemset/problem/862/E)|⭐⭐⭐⭐|Hashing|❌||
|110|[Vasya and a Tree — 1017E](https://codeforces.com/problemset/problem/1017/E)|⭐⭐⭐⭐|Map + DFS|❌||

---

## 11. Strings & String Algorithms

> **Focus:** KMP, Z-function, Aho-Corasick, suffix arrays, hashing.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|111|[Password — 126E](https://codeforces.com/problemset/problem/126/E)|⭐⭐⭐|KMP/Z|❌||
|112|[Palindrome Degree — 906E](https://codeforces.com/problemset/problem/906/E)|⭐⭐⭐|Palindrome|❌||
|113|[Shortest period — 581E](https://codeforces.com/problemset/problem/581/E)|⭐⭐⭐|Z-Function|❌||
|114|[Palindrome Partition — 906F](https://codeforces.com/problemset/problem/906/F)|⭐⭐⭐⭐|Palindrome|❌||
|115|[Vasya and String — 831D](https://codeforces.com/problemset/problem/831/D)|⭐⭐⭐|Strings|❌||
|116|[Lena and Queries — 360E](https://codeforces.com/problemset/problem/360/E)|⭐⭐⭐|Strings|❌||
|117|[Berland SU Computer Network — 847J](https://codeforces.com/problemset/problem/847/J)|⭐⭐⭐|Z-Function|❌||
|118|[A Lot of Games — 570E](https://codeforces.com/problemset/problem/570/E)|⭐⭐⭐|Aho-Corasick|❌||
|119|[Prefixes and Suffixes — 432E](https://codeforces.com/problemset/problem/432/E)|⭐⭐⭐|KMP|❌||
|120|[Censoring — 700E](https://codeforces.com/problemset/problem/700/E)|⭐⭐⭐|KMP + Stack|❌||

---

## 12. Graphs — BFS & DFS

> **Focus:** Connected components, bipartiteness, cycle detection, BFS on grids.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|121|[Checkposts — 342E](https://codeforces.com/problemset/problem/342/E)|⭐⭐⭐|SCC|❌||
|122|[Fox and Graph — 512E](https://codeforces.com/problemset/problem/512/E)|⭐⭐⭐|Graph|❌||
|123|[Labyrinth — 1063B](https://codeforces.com/problemset/problem/1063/B)|⭐⭐|BFS|❌||
|124|[Ice Cave — 540C](https://codeforces.com/problemset/problem/540/C)|⭐⭐|BFS/DFS|❌||
|125|[Bear and Graph Removal — 660F](https://codeforces.com/problemset/problem/660/F)|⭐⭐⭐|Graph|❌||
|126|[Cycle in Graph — 1217D](https://codeforces.com/problemset/problem/1217/D)|⭐⭐⭐|DFS/Cycle|❌||
|127|[Kefa and Park — 580C](https://codeforces.com/problemset/problem/580/C)|⭐⭐|BFS|❌||
|128|[New Year Transportation — 500B](https://codeforces.com/problemset/problem/500/B)|⭐⭐|DFS|❌||
|129|[Wizard's Tour — 860E](https://codeforces.com/problemset/problem/860/E)|⭐⭐⭐⭐|DFS|❌||
|130|[Berland and the Shortest Path — 1217E](https://codeforces.com/problemset/problem/1217/E)|⭐⭐⭐|BFS + Graph|❌||
|131|[Network Construction — 690F](https://codeforces.com/problemset/problem/690/F)|⭐⭐⭐⭐|Graph|❌||
|132|[Tourist — 660G](https://codeforces.com/problemset/problem/660/G)|⭐⭐⭐⭐|DFS + Block-cut|❌||
|133|[President and Roads — 567E](https://codeforces.com/problemset/problem/567/E)|⭐⭐⭐|Bridges|❌||
|134|[Biconnected Graph — 962F](https://codeforces.com/problemset/problem/962/F)|⭐⭐⭐⭐|Biconnected|❌||
|135|[Topological Sort — 510C](https://codeforces.com/problemset/problem/510/C)|⭐⭐|Topo Sort|❌||

---

## 13. Shortest Paths

> **Focus:** Dijkstra, Bellman-Ford, Floyd-Warshall, 0-1 BFS, SPFA.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|136|[Dijkstra's Algorithm — 20C](https://codeforces.com/problemset/problem/20/C)|⭐⭐⭐|Dijkstra|❌|Classic|
|137|[KATHTHI — SPOJ](https://www.spoj.com/problems/KATHTHI/)|⭐⭐|0-1 BFS|❌||
|138|[Shortest Path with Obstacle — 1547G](https://codeforces.com/problemset/problem/1547/G)|⭐⭐|Dijkstra|❌||
|139|[Edges in MST — 160D](https://codeforces.com/problemset/problem/160/D)|⭐⭐⭐|Kruskal|❌||
|140|[Bad Luck — 1279D](https://codeforces.com/problemset/problem/1279/D)|⭐⭐⭐|Dijkstra|❌||
|141|[Roads and Planes — 196E](https://codeforces.com/problemset/problem/196/E)|⭐⭐⭐⭐|Dijkstra + DAG|❌||
|142|[Bertown Roads — 258D](https://codeforces.com/problemset/problem/258/D)|⭐⭐⭐|Bridges|❌||
|143|[Minimum Spanning Tree — 1245D](https://codeforces.com/problemset/problem/1245/D)|⭐⭐⭐|Kruskal|❌||
|144|[Shortest Path in the King's Graph — 242C](https://codeforces.com/problemset/problem/242/C)|⭐⭐|BFS|❌||
|145|[Relay Race — 1209H](https://codeforces.com/problemset/problem/1209/H)|⭐⭐⭐|Dijkstra|❌||

---

## 14. Trees & Tree DP

> **Focus:** LCA, HLD, centroid decomposition, rerooting technique.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|146|[Distance in Tree — 161D](https://codeforces.com/problemset/problem/161/D)|⭐⭐|Tree DP|❌||
|147|[Misha and Forest — 501B](https://codeforces.com/problemset/problem/501/B)|⭐⭐|Tree/BFS|❌||
|148|[Arpa's letter-marked tree — 850C](https://codeforces.com/problemset/problem/850/C)|⭐⭐⭐|Tree DSU|❌||
|149|[Codeforces Tree — 570D](https://codeforces.com/problemset/problem/570/D)|⭐⭐⭐|LCA|❌||
|150|[Blood Cousins — 208E](https://codeforces.com/problemset/problem/208/E)|⭐⭐⭐|LCA|❌||
|151|[Trips — 600E](https://codeforces.com/problemset/problem/600/E)|⭐⭐⭐|Tree DP|❌||
|152|[Cardsboard — 1286E](https://codeforces.com/problemset/problem/1286/E)|⭐⭐⭐|Tree|❌||
|153|[Tree Diameter — 1187E](https://codeforces.com/problemset/problem/1187/E)|⭐⭐⭐|Tree|❌||
|154|[HLD — 342E (Xenia and Tree)](https://codeforces.com/problemset/problem/342/E)|⭐⭐⭐⭐|HLD|❌||
|155|[Centroid Decomposition — 840D](https://codeforces.com/problemset/problem/840/D)|⭐⭐⭐⭐|Centroid|❌||
|156|[Virtual Tree — 613D](https://codeforces.com/problemset/problem/613/D)|⭐⭐⭐⭐|Virtual Tree|❌||
|157|[Rerooting — 916E](https://codeforces.com/problemset/problem/916/E)|⭐⭐⭐⭐|Rerooting|❌||
|158|[Heavy Path — 396C](https://codeforces.com/problemset/problem/396/C)|⭐⭐⭐|HLD|❌||
|159|[Flea — 776D](https://codeforces.com/problemset/problem/776/D)|⭐⭐⭐|Tree|❌||
|160|[Longest Path in Tree — 1017E](https://codeforces.com/problemset/problem/1017/E)|⭐⭐⭐⭐|Tree DP|❌||

---

## 15. Dynamic Programming — 1D & 2D

> **Focus:** LCS, LIS, knapsack, matrix chain, digit DP.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|161|[Longest Increasing Subsequence — 340E](https://codeforces.com/problemset/problem/340/E)|⭐⭐⭐|LIS|❌||
|162|[Woodcutters — 545C](https://codeforces.com/problemset/problem/545/C)|⭐⭐|Greedy/DP|❌||
|163|[Vasya and a Tree — 1017E](https://codeforces.com/problemset/problem/1017/E)|⭐⭐⭐|DP|❌||
|164|[Knapsack — 1066C](https://codeforces.com/problemset/problem/1066/C)|⭐⭐|Knapsack|❌||
|165|[DP on Subsets — 580E](https://codeforces.com/problemset/problem/580/E)|⭐⭐⭐⭐|Bitmask DP|❌||
|166|[Yet Another DP — 1236E](https://codeforces.com/problemset/problem/1236/E)|⭐⭐⭐|DP|❌||
|167|[LCS — 463E](https://codeforces.com/problemset/problem/463/E)|⭐⭐⭐|LCS|❌||
|168|[Vasya and Socks — 460B](https://codeforces.com/problemset/problem/460/B)|⭐⭐|DP|❌||
|169|[Tourist — 538C](https://codeforces.com/problemset/problem/538/C)|⭐⭐⭐|DP|❌||
|170|[Fibonacci Digit — 1264E](https://codeforces.com/problemset/problem/1264/E)|⭐⭐⭐⭐|Digit DP|❌||
|171|[Digit DP Classic — 55D](https://codeforces.com/problemset/problem/55/D)|⭐⭐⭐|Digit DP|❌||
|172|[Buying Jewels — 1264C](https://codeforces.com/problemset/problem/1264/C)|⭐⭐|DP|❌||
|173|[Team — 1063C](https://codeforces.com/problemset/problem/1063/C)|⭐⭐|DP|❌||
|174|[Grid DP — 598E](https://codeforces.com/problemset/problem/598/E)|⭐⭐⭐|Grid DP|❌||
|175|[Beautiful People — 1264E](https://codeforces.com/problemset/problem/1264/E)|⭐⭐⭐⭐|LIS + DP|❌||

---

## 16. DP on Intervals & Bitmask

> **Focus:** Matrix chain, optimal BST, TSP, SOS DP.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|176|[Brackets — 3D](https://codeforces.com/problemset/problem/3/D)|⭐⭐⭐|Interval DP|❌||
|177|[Treasure Island — 1201E](https://codeforces.com/problemset/problem/1201/E)|⭐⭐⭐⭐|Bitmask DP|❌||
|178|[Ant Man — 704D](https://codeforces.com/problemset/problem/704/D)|⭐⭐⭐⭐|Interval DP|❌||
|179|[SOS DP — 1208F](https://codeforces.com/problemset/problem/1208/F)|⭐⭐⭐⭐|SOS|❌||
|180|[Traveling Salesman — 311E](https://codeforces.com/problemset/problem/311/E)|⭐⭐⭐|Bitmask|❌||

---

## 17. Segment Trees & BIT (Fenwick)

> **Focus:** Point update range query, lazy propagation, merge sort tree.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|181|[Powerful Array — 86D](https://codeforces.com/problemset/problem/86/D)|⭐⭐⭐⭐|Mo's Algo|❌||
|182|[Number of Inversions — 1406E](https://codeforces.com/problemset/problem/1406/E)|⭐⭐⭐|BIT|❌||
|183|[Fenwick Tree Classic — 380C](https://codeforces.com/problemset/problem/380/C)|⭐⭐⭐|BIT|❌||
|184|[Sereja and Brackets — 380E](https://codeforces.com/problemset/problem/380/E)|⭐⭐⭐|Seg Tree|❌||
|185|[Codeforces 339D — Xenia and Bit Operations](https://codeforces.com/problemset/problem/339/D)|⭐⭐⭐|Seg Tree|❌||
|186|[Lazy Propagation — 558E](https://codeforces.com/problemset/problem/558/E)|⭐⭐⭐|Seg Lazy|❌||
|187|[Ynoi 2015 — CF896C](https://codeforces.com/problemset/problem/896/C)|⭐⭐⭐⭐|Seg Tree|❌||
|188|[Persistent Segment Tree — 786C](https://codeforces.com/problemset/problem/786/C)|⭐⭐⭐⭐|Persist ST|❌||
|189|[Merge Sort Tree — 600F](https://codeforces.com/problemset/problem/600/F)|⭐⭐⭐⭐|Merge ST|❌||
|190|[Segment Beats — 1290E](https://codeforces.com/problemset/problem/1290/E)|⭐⭐⭐⭐⭐|Seg Beats|❌|Advanced|

---

## 18. Divide & Conquer

> **Focus:** D&C optimization DP, SQRT decomposition, offline queries.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|191|[SQRT Decomposition — 940F](https://codeforces.com/problemset/problem/940/F)|⭐⭐⭐⭐|SQRT|❌||
|192|[Mo's Algorithm — 375D](https://codeforces.com/problemset/problem/375/D)|⭐⭐⭐⭐|Mo|❌||
|193|[D&C DP — 1093G](https://codeforces.com/problemset/problem/1093/G)|⭐⭐⭐⭐|D&C DP|❌||
|194|[Offline LCA — 342E](https://codeforces.com/problemset/problem/342/E)|⭐⭐⭐⭐|D&C|❌||
|195|[Alien Trick — 1603F](https://codeforces.com/problemset/problem/1603/F)|⭐⭐⭐⭐⭐|Alien|❌|Hard|

---

## 19. Disjoint Set Union (DSU)

> **Focus:** Path compression, union by rank, rollback DSU, DSU on tree.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|196|[Friends and Enemies — 1249C](https://codeforces.com/problemset/problem/1249/C)|⭐⭐|DSU|❌||
|197|[Mahmoud and Ehab — 862D](https://codeforces.com/problemset/problem/862/D)|⭐⭐⭐|DSU|❌||
|198|[Arpa's DSU — 850D](https://codeforces.com/problemset/problem/850/D)|⭐⭐⭐|DSU on Tree|❌||
|199|[Spanning Tree Queries — 1213G](https://codeforces.com/problemset/problem/1213/G)|⭐⭐⭐⭐|DSU|❌||
|200|[Codeforces Round DSU — 600D](https://codeforces.com/problemset/problem/600/D)|⭐⭐⭐|DSU|❌||
|201|[Edges in MST — 160D](https://codeforces.com/problemset/problem/160/D)|⭐⭐⭐|DSU + Sort|❌||
|202|[DSU Rollback — 813F](https://codeforces.com/problemset/problem/813/F)|⭐⭐⭐⭐|Rollback DSU|❌||
|203|[Dsu on Tree (small-to-large) — 600E](https://codeforces.com/problemset/problem/600/E)|⭐⭐⭐⭐|DSU Tree|❌||
|204|[Connected Components — 587D](https://codeforces.com/problemset/problem/587/D)|⭐⭐⭐|DSU|❌||
|205|[Bipartite DSU — 901C](https://codeforces.com/problemset/problem/901/C)|⭐⭐⭐|DSU|❌||

---

## 20. Game Theory

> **Focus:** Nim, Sprague-Grundy, combinatorial game theory.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|206|[Stones — 768E](https://codeforces.com/problemset/problem/768/E)|⭐⭐⭐|Nim|❌||
|207|[Vasya and Petya's Game — 577B](https://codeforces.com/problemset/problem/577/B)|⭐⭐|Game Theory|❌||
|208|[Game with Powers — 850G](https://codeforces.com/problemset/problem/850/G)|⭐⭐⭐⭐|Sprague-Grundy|❌||
|209|[A - XOR Nim — 1527A](https://codeforces.com/problemset/problem/1527/A)|⭐⭐|Nim/XOR|❌||
|210|[Turning Turtles — 317C3](https://codeforces.com/problemset/problem/317/C3)|⭐⭐⭐|Grundy|❌||

---

## 21. Flows & Matching

> **Focus:** Max flow, min cut, bipartite matching, Hungarian algorithm.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|211|[Optimal Ordering — 868F](https://codeforces.com/problemset/problem/868/F)|⭐⭐⭐⭐|Flow|❌||
|212|[Bipartite Matching — 1139E](https://codeforces.com/problemset/problem/1139/E)|⭐⭐⭐⭐|Matching|❌||
|213|[MincostMaxflow — 704D](https://codeforces.com/problemset/problem/704/D)|⭐⭐⭐⭐|MCMF|❌||
|214|[Students and Exams — 978G](https://codeforces.com/problemset/problem/978/G)|⭐⭐⭐⭐|Flow|❌||
|215|[Flows in Grid — 1043G](https://codeforces.com/problemset/problem/1043/G)|⭐⭐⭐⭐⭐|Flow|❌|Hard|

---

## 22. Geometry

> **Focus:** Convex hull, line intersection, point-in-polygon, rotating calipers.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|216|[Convex Hull — 19E](https://codeforces.com/problemset/problem/19/E)|⭐⭐⭐|Convex Hull|❌||
|217|[Rotating Calipers — 799G](https://codeforces.com/problemset/problem/799/G)|⭐⭐⭐⭐|Geometry|❌||
|218|[Points and Lines — 961G](https://codeforces.com/problemset/problem/961/G)|⭐⭐⭐⭐|Geometry|❌||
|219|[Triangle — 600G](https://codeforces.com/problemset/problem/600/G)|⭐⭐⭐⭐|Geometry|❌||
|220|[Segments — 1208H](https://codeforces.com/problemset/problem/1208/H)|⭐⭐⭐⭐⭐|Geometry|❌|Hard|

---

## 23. Advanced Topics

> **Focus:** FFT, NTT, matrix exponentiation, linear sieve, treap, link-cut tree.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|221|[Polynomial Multiplication — 632E](https://codeforces.com/problemset/problem/632/E)|⭐⭐⭐⭐|FFT|❌||
|222|[Matrix Exponentiation — 185E](https://codeforces.com/problemset/problem/185/E)|⭐⭐⭐⭐|Matrix Exp|❌||
|223|[Fibonacci — 509E](https://codeforces.com/problemset/problem/509/E)|⭐⭐⭐|Matrix Exp|❌||
|224|[Treap — 702F](https://codeforces.com/problemset/problem/702/F)|⭐⭐⭐⭐|Treap|❌||
|225|[Link-Cut Tree — 117E](https://codeforces.com/problemset/problem/117/E)|⭐⭐⭐⭐⭐|LCT|❌|Expert|
|226|[Count Inversions NTT — 1096G](https://codeforces.com/problemset/problem/1096/G)|⭐⭐⭐⭐|NTT|❌||
|227|[Flow on Trees — 1239D](https://codeforces.com/problemset/problem/1239/D)|⭐⭐⭐⭐|Flow + Tree|❌||
|228|[Sqrt Decomp Advanced — 786E](https://codeforces.com/problemset/problem/786/E)|⭐⭐⭐⭐⭐|SQRT|❌||
|229|[Sprague-Grundy on Graph — 850G](https://codeforces.com/problemset/problem/850/G)|⭐⭐⭐⭐|SG|❌||
|230|[Chinese Remainder Theorem — 906G](https://codeforces.com/problemset/problem/906/G)|⭐⭐⭐⭐|CRT|❌||

---

## 24. Mixed Bag — Contest Grinders

> **Focus:** Recent Div. 2 B–D / Div. 1 A–C problems for timed practice.

|#|Problem|Rating|Tag|Status|Notes|
|---|---|---|---|---|---|
|231|[Lost Array — 1374E](https://codeforces.com/problemset/problem/1374/E)|⭐⭐⭐|Mixed|❌||
|232|[Sliding Average — 1418D](https://codeforces.com/problemset/problem/1418/D)|⭐⭐⭐|Mixed|❌||
|233|[Minimize the Maximum — 1468H](https://codeforces.com/problemset/problem/1468/H)|⭐⭐⭐⭐|Mixed|❌||
|234|[XOR and Distance — 1469E](https://codeforces.com/problemset/problem/1469/E)|⭐⭐⭐|Trie|❌||
|235|[Knapsack for All Subsets — 1442E](https://codeforces.com/problemset/problem/1442/E)|⭐⭐⭐|DP|❌||
|236|[Maximize Divisors — 1445D](https://codeforces.com/problemset/problem/1445/D)|⭐⭐⭐|Math|❌||
|237|[Move Brackets — 1374B](https://codeforces.com/problemset/problem/1374/B)|⭐⭐|Greedy|❌||
|238|[Array Beauty — 1264D](https://codeforces.com/problemset/problem/1264/D)|⭐⭐⭐|BS + Math|❌||
|239|[Binary String Reconstruction — 1516C](https://codeforces.com/problemset/problem/1516/C)|⭐⭐|Greedy|❌||
|240|[Chocolate Bunny — 1407C](https://codeforces.com/problemset/problem/1407/C)|⭐⭐⭐|Greedy|❌||
|241|[Close Tuples — 1462E](https://codeforces.com/problemset/problem/1462/E)|⭐⭐⭐|Math + Comb|❌||
|242|[Triple Operations — 1436E](https://codeforces.com/problemset/problem/1436/E)|⭐⭐⭐|Math|❌||
|243|[Multiset — 1477F](https://codeforces.com/problemset/problem/1477/F)|⭐⭐⭐⭐|DS + BS|❌||
|244|[Sifid and Strange Subsequences — 1473E](https://codeforces.com/problemset/problem/1473/E)|⭐⭐⭐|Greedy|❌||
|245|[Nastia Plays with a Tree — 1477E](https://codeforces.com/problemset/problem/1477/E)|⭐⭐⭐⭐|Tree|❌||
|246|[Phoenix and Towers — 1515G](https://codeforces.com/problemset/problem/1515/G)|⭐⭐⭐⭐|Graph|❌||
|247|[XOR-ranges — 1535E](https://codeforces.com/problemset/problem/1535/E)|⭐⭐⭐|XOR|❌||
|248|[Consecutive Points Segment — 1530D](https://codeforces.com/problemset/problem/1530/D)|⭐⭐⭐|Math|❌||
|249|[A-B Palindrome — 1540C](https://codeforces.com/problemset/problem/1540/C)|⭐⭐|Strings|❌||
|250|[Ball in Berland — 1547E](https://codeforces.com/problemset/problem/1547/E)|⭐⭐⭐|Math + Graph|❌||
|251|[Nastia and a Beautiful Matrix — 1567E](https://codeforces.com/problemset/problem/1567/E)|⭐⭐⭐⭐|DS|❌||
|252|[Lucky Permutation — 1574E](https://codeforces.com/problemset/problem/1574/E)|⭐⭐⭐|DSU|❌||
|253|[Gardener and the Array — 1575D](https://codeforces.com/problemset/problem/1575/D)|⭐⭐|Greedy|❌||
|254|[Road to Zero — 1586E](https://codeforces.com/problemset/problem/1586/E)|⭐⭐⭐|Math|❌||
|255|[Mocha and Stars — 1559E](https://codeforces.com/problemset/problem/1559/E)|⭐⭐⭐⭐|DP|❌||
|256|[New Year's Eve — 1570E](https://codeforces.com/problemset/problem/1570/E)|⭐⭐⭐|Greedy|❌||
|257|[Vasya and Array — 1579E](https://codeforces.com/problemset/problem/1579/E)|⭐⭐⭐|DP|❌||
|258|[Permutation Compression — 1584E](https://codeforces.com/problemset/problem/1584/E)|⭐⭐⭐|Greedy|❌||
|259|[MEX and Increments — 1588E](https://codeforces.com/problemset/problem/1588/E)|⭐⭐⭐|Greedy + DS|❌||
|260|[Swap and Flip — 1594E](https://codeforces.com/problemset/problem/1594/E)|⭐⭐⭐|BFS|❌||
|261|[Minimum Cost to Make Arrays Identical — 1598E](https://codeforces.com/problemset/problem/1598/E)|⭐⭐⭐|Math|❌||
|262|[Mocha and Hiking — 1559B](https://codeforces.com/problemset/problem/1559/B)|⭐⭐|Greedy|❌||
|263|[XOR Inverse — 1614D](https://codeforces.com/problemset/problem/1614/D)|⭐⭐⭐⭐|Trie|❌||
|264|[Minimize the Diameter — 1617E](https://codeforces.com/problemset/problem/1617/E)|⭐⭐⭐⭐|Tree + BS|❌||
|265|[Strange Beauty — 1555E](https://codeforces.com/problemset/problem/1555/E)|⭐⭐⭐|DP + Math|❌||
|266|[XOR Subsequences — 1622F](https://codeforces.com/problemset/problem/1622/F)|⭐⭐⭐⭐|Trie + DP|❌||
|267|[Best Coupon — 1626E](https://codeforces.com/problemset/problem/1626/E)|⭐⭐⭐|Greedy|❌||
|268|[Sorting by Pairs — 1620E](https://codeforces.com/problemset/problem/1620/E)|⭐⭐⭐⭐|Graph|❌||
|269|[Permutation and XOR — 1624F](https://codeforces.com/problemset/problem/1624/F)|⭐⭐⭐⭐|Math|❌||
|270|[Power Sums — 1628E](https://codeforces.com/problemset/problem/1628/E)|⭐⭐⭐⭐|Math|❌||
|271|[Sum of Medians — 1632E](https://codeforces.com/problemset/problem/1632/E)|⭐⭐⭐⭐|DP|❌||
|272|[String Coloring — 1634E](https://codeforces.com/problemset/problem/1634/E)|⭐⭐⭐|Graph|❌||
|273|[2-SAT Classic — 1200F](https://codeforces.com/problemset/problem/1200/F)|⭐⭐⭐⭐|2-SAT|❌||
|274|[Building a Tree — 1641D](https://codeforces.com/problemset/problem/1641/D)|⭐⭐⭐|Tree|❌||
|275|[Graph Coloring — 1638E](https://codeforces.com/problemset/problem/1638/E)|⭐⭐⭐|Graph|❌||
|276|[Carry Segment — 1644E](https://codeforces.com/problemset/problem/1644/E)|⭐⭐⭐⭐|Seg Tree|❌||
|277|[Fill the Bag — 1380C](https://codeforces.com/problemset/problem/1380/C)|⭐⭐|Greedy + Bits|❌||
|278|[Minimum Spanning Tree for Each Edge — 1442F](https://codeforces.com/problemset/problem/1442/F)|⭐⭐⭐⭐|MST|❌||
|279|[Constructive Solutions — 1553E](https://codeforces.com/problemset/problem/1553/E)|⭐⭐⭐|Constructive|❌||
|280|[Number of Pairs — 1647E](https://codeforces.com/problemset/problem/1647/E)|⭐⭐⭐|Math|❌||
|281|[Sum on Segments — 1650E](https://codeforces.com/problemset/problem/1650/E)|⭐⭐⭐⭐|Seg Tree|❌||
|282|[Circle of Monsters — 1333D](https://codeforces.com/problemset/problem/1333/D)|⭐⭐⭐|Greedy|❌||
|283|[Count of Integers — 1651E](https://codeforces.com/problemset/problem/1651/E)|⭐⭐⭐|Digit DP|❌||
|284|[Pair of Topics — 1324D](https://codeforces.com/problemset/problem/1324/D)|⭐⭐|Sorting|❌||
|285|[Min Cost String — 1648D](https://codeforces.com/problemset/problem/1648/D)|⭐⭐⭐|Math|❌||
|286|[Colorful Graph — 1654E](https://codeforces.com/problemset/problem/1654/E)|⭐⭐⭐|Graph|❌||
|287|[Bus in Capital — 1468G](https://codeforces.com/problemset/problem/1468/G)|⭐⭐⭐⭐|Tree|❌||
|288|[Graph Coloring — 1659E](https://codeforces.com/problemset/problem/1659/E)|⭐⭐⭐|Graph|❌||
|289|[Build a Tree — 1641C](https://codeforces.com/problemset/problem/1641/C)|⭐⭐⭐|Constructive|❌||
|290|[Array and Segments — 1370E](https://codeforces.com/problemset/problem/1370/E)|⭐⭐⭐|Seg Tree|❌||
|291|[MEX of Sequence — 1508E](https://codeforces.com/problemset/problem/1508/E)|⭐⭐⭐|Greedy|❌||
|292|[Distinct Colors — 1543E](https://codeforces.com/problemset/problem/1543/E)|⭐⭐⭐|DSU on Tree|❌||
|293|[Another LCS — 1582F](https://codeforces.com/problemset/problem/1582/F)|⭐⭐⭐⭐|LCS|❌||
|294|[Stack Exterminable — 1582G](https://codeforces.com/problemset/problem/1582/G)|⭐⭐⭐⭐|Stack + Hash|❌||
|295|[Prefix XOR — 1600E](https://codeforces.com/problemset/problem/1600/E)|⭐⭐⭐|XOR/Math|❌||
|296|[Weird Matrix — 1362C](https://codeforces.com/problemset/problem/1362/C)|⭐⭐|Matrix|❌||
|297|[Median Smoothing — 1037E](https://codeforces.com/problemset/problem/1037/E)|⭐⭐⭐|Greedy|❌||
|298|[New Year Segments — 1089G](https://codeforces.com/problemset/problem/1089/G)|⭐⭐⭐⭐|Seg Tree|❌||
|299|[Function — 1033F](https://codeforces.com/problemset/problem/1033/F)|⭐⭐⭐⭐|Math|❌||
|300|[Product of Three — 1699D](https://codeforces.com/problemset/problem/1699/D)|⭐⭐⭐|Math/Greedy|❌||

---

## 📊 Progress Tracker

|Section|Total|Solved|% Done|
|---|---|---|---|
|Implementation & Brute Force|15|0|0%|
|Math & Number Theory|15|0|0%|
|Sorting & Greedy|15|0|0%|
|Binary Search|15|0|0%|
|Two Pointers & Sliding Window|10|0|0%|
|Prefix Sums & Difference Arrays|10|0|0%|
|Recursion & Backtracking|5|0|0%|
|Data Structures — STL & Basic|10|0|0%|
|Stacks, Queues & Deques|10|0|0%|
|Hashing & Maps|5|0|0%|
|Strings & String Algorithms|10|0|0%|
|Graphs — BFS & DFS|15|0|0%|
|Shortest Paths|10|0|0%|
|Trees & Tree DP|15|0|0%|
|Dynamic Programming|15|0|0%|
|DP on Intervals & Bitmask|5|0|0%|
|Segment Trees & BIT|10|0|0%|
|Divide & Conquer|5|0|0%|
|DSU|10|0|0%|
|Game Theory|5|0|0%|
|Flows & Matching|5|0|0%|
|Geometry|5|0|0%|
|Advanced Topics|10|0|0%|
|Mixed Bag — Contest Grinders|70|0|0%|
|**TOTAL**|**300**|**0**|**0%**|

---

## 🗺️ Recommended Study Order

```
Week 1–2  → Sections 1–3  (Implementation, Math, Greedy)
Week 3–4  → Sections 4–6  (Binary Search, Two Pointers, Prefix Sums)
Week 5–6  → Sections 7–10 (Recursion, DS, Stacks, Hashing)
Week 7–8  → Sections 11–13 (Strings, Graphs, Shortest Paths)
Week 9–10 → Sections 14–16 (Trees, DP, Bitmask DP)
Week 11–12→ Sections 17–19 (Seg Trees, D&C, DSU)
Week 13–14→ Sections 20–22 (Game Theory, Flows, Geometry)
Week 15+  → Sections 23–24 (Advanced + Mixed Bag Contest Grind)
```

---

## 💡 Tips

- **Aim for CF rating 1600–2000** — that's competitive programmer tier.
- **Participate in live rounds** — virtual contests don't count the same.
- **After solving, read editorial** — even correct solutions can be improved.
- **Tag-based grinding** beats random problem solving every time.
- **Track your weak topics** and revisit ❌ and 🔁 problems every 2 weeks.

---

_Last updated: April 2026 | 300 problems across 24 topics_