# 🧠 Complete DSA in Java — Guide with Snippets & Containers

---

## 📦 Table of Contents

1. [Java Containers / Data Structures Overview](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#1-java-containers--data-structures-overview)
2. [Arrays](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#2-arrays)
3. [Strings](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#3-strings)
4. [ArrayList & LinkedList](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#4-arraylist--linkedlist)
5. [Stack](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#5-stack)
6. [Queue & Deque](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#6-queue--deque)
7. [HashMap & HashSet](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#7-hashmap--hashset)
8. [TreeMap & TreeSet](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#8-treemap--treeset)
9. [PriorityQueue (Min/Max Heap)](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#9-priorityqueue-minmax-heap)
10. [Linked List (Custom)](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#10-linked-list-custom)
11. [Binary Tree & BST](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#11-binary-tree--bst)
12. [Graph — Adjacency List](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#12-graph--adjacency-list)
13. [Sorting Algorithms](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#13-sorting-algorithms)
14. [Searching Algorithms](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#14-searching-algorithms)
15. [Recursion & Backtracking](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#15-recursion--backtracking)
16. [Dynamic Programming](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#16-dynamic-programming)
17. [Two Pointers](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#17-two-pointers)
18. [Sliding Window](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#18-sliding-window)
19. [Binary Search (Patterns)](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#19-binary-search-patterns)
20. [Graph Traversals — BFS & DFS](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#20-graph-traversals--bfs--dfs)
21. [Trie](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#21-trie)
22. [Union-Find (Disjoint Set)](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#22-union-find-disjoint-set)
23. [Segment Tree](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#23-segment-tree)
24. [Bit Manipulation Tricks](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#24-bit-manipulation-tricks)
25. [Complexity Cheat Sheet](https://claude.ai/chat/fdbfbbba-2187-479a-9e81-dc8408d030ae#25-complexity-cheat-sheet)

---

## 1. Java Containers / Data Structures Overview

```
Interface/Class          Use Case
──────────────────────────────────────────────────────────
int[] / int[][]          Fixed-size array, fast access
ArrayList<T>             Dynamic array (random access)
LinkedList<T>            Doubly linked list, queue/deque
Stack<T>                 LIFO stack
ArrayDeque<T>            Fast stack & queue (preferred)
PriorityQueue<T>         Min-heap (max-heap with comparator)
HashMap<K,V>             Key-value, O(1) avg
LinkedHashMap<K,V>       Key-value + insertion order
TreeMap<K,V>             Key-value + sorted keys, O(log n)
HashSet<T>               Unique elements, O(1) avg
TreeSet<T>               Unique + sorted, O(log n)
int[][]  (graph)         Adjacency matrix
List<List<Integer>>      Adjacency list
```

---

## 2. Arrays

```java
// Declaration
int[] arr = new int[5];
int[] arr = {1, 2, 3, 4, 5};
int[][] matrix = new int[3][4];

// Useful operations
Arrays.sort(arr);                          // O(n log n)
Arrays.sort(arr, 2, 5);                    // sort index [2,5)
Arrays.fill(arr, 0);                       // fill with value
int[] copy = Arrays.copyOf(arr, arr.length);
int[] range = Arrays.copyOfRange(arr, 1, 4); // [1,4)
System.out.println(Arrays.toString(arr));

// 2D sort by first element
int[][] intervals = {{3,4},{1,2},{2,3}};
Arrays.sort(intervals, (a, b) -> a[0] - b[0]);

// Binary search (must be sorted)
int idx = Arrays.binarySearch(arr, target);
```

---

## 3. Strings

```java
String s = "hello";

// Common methods
s.length()                    // 5
s.charAt(0)                   // 'h'
s.substring(1, 3)             // "el"
s.indexOf("ll")               // 2
s.contains("ell")             // true
s.startsWith("he")            // true
s.endsWith("lo")              // true
s.replace("l", "r")           // "herro"
s.toLowerCase() / toUpperCase()
s.trim()                      // strip whitespace
s.split(" ")                  // String[]
s.toCharArray()               // char[]
String.valueOf(42)            // "42"
Integer.parseInt("42")        // 42

// StringBuilder (mutable — use in loops!)
StringBuilder sb = new StringBuilder();
sb.append("hello");
sb.insert(0, "X");
sb.deleteCharAt(0);
sb.reverse();
sb.toString();

// Check if palindrome
boolean isPalin(String s) {
    int l = 0, r = s.length() - 1;
    while (l < r) {
        if (s.charAt(l++) != s.charAt(r--)) return false;
    }
    return true;
}

// Frequency count
int[] freq = new int[26];
for (char c : s.toCharArray()) freq[c - 'a']++;
```

---

## 4. ArrayList & LinkedList

```java
import java.util.*;

// ArrayList — O(1) access, O(n) insert/delete at index
List<Integer> list = new ArrayList<>();
list.add(10);
list.add(1, 5);              // insert at index 1
list.get(0);                 // 10
list.set(0, 99);             // update
list.remove(0);              // remove by index
list.remove(Integer.valueOf(5)); // remove by value
list.size();
list.contains(99);
Collections.sort(list);
Collections.reverse(list);
Collections.shuffle(list);
Collections.min(list);
Collections.max(list);

// LinkedList — O(1) insert/delete at ends
LinkedList<Integer> ll = new LinkedList<>();
ll.addFirst(1);
ll.addLast(3);
ll.peekFirst();  ll.peekLast();
ll.pollFirst();  ll.pollLast();

// Convert array <-> list
List<Integer> fromArr = new ArrayList<>(Arrays.asList(1,2,3));
Integer[] toArr = list.toArray(new Integer[0]);
```

---

## 5. Stack

```java
// Prefer ArrayDeque over Stack<T>
Deque<Integer> stack = new ArrayDeque<>();
stack.push(1);       // addFirst
stack.push(2);
stack.peek();        // top element → 2
stack.pop();         // removes top → 2
stack.isEmpty();

// Classic pattern: Balanced Parentheses
boolean isValid(String s) {
    Deque<Character> stack = new ArrayDeque<>();
    for (char c : s.toCharArray()) {
        if (c == '(' || c == '[' || c == '{') {
            stack.push(c);
        } else {
            if (stack.isEmpty()) return false;
            char top = stack.pop();
            if (c == ')' && top != '(') return false;
            if (c == ']' && top != '[') return false;
            if (c == '}' && top != '{') return false;
        }
    }
    return stack.isEmpty();
}

// Monotonic Stack — Next Greater Element
int[] nextGreater(int[] nums) {
    int n = nums.length;
    int[] res = new int[n];
    Arrays.fill(res, -1);
    Deque<Integer> stack = new ArrayDeque<>(); // stores indices
    for (int i = 0; i < n; i++) {
        while (!stack.isEmpty() && nums[i] > nums[stack.peek()])
            res[stack.pop()] = nums[i];
        stack.push(i);
    }
    return res;
}
```

---

## 6. Queue & Deque

```java
// Queue — FIFO
Queue<Integer> q = new LinkedList<>();
q.offer(1);      // enqueue
q.offer(2);
q.peek();        // front → 1
q.poll();        // dequeue → 1
q.isEmpty();

// ArrayDeque — use as both Queue and Stack (faster)
Deque<Integer> dq = new ArrayDeque<>();
dq.offerFirst(0);  dq.offerLast(5);
dq.peekFirst();    dq.peekLast();
dq.pollFirst();    dq.pollLast();

// BFS template using Queue
void bfs(int start) {
    Queue<Integer> q = new LinkedList<>();
    boolean[] visited = new boolean[N];
    q.offer(start);
    visited[start] = true;
    while (!q.isEmpty()) {
        int node = q.poll();
        for (int neighbor : graph.get(node)) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                q.offer(neighbor);
            }
        }
    }
}
```

---

## 7. HashMap & HashSet

```java
// HashMap — O(1) avg get/put
Map<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.get("a");                        // 1
map.getOrDefault("b", 0);           // 0
map.containsKey("a");
map.containsValue(1);
map.remove("a");
map.size();
map.putIfAbsent("c", 3);
map.merge("a", 1, Integer::sum);     // add 1 to existing

// Iterate
for (Map.Entry<String, Integer> e : map.entrySet())
    System.out.println(e.getKey() + " -> " + e.getValue());
for (String key : map.keySet()) { }
for (int val : map.values()) { }

// Frequency map
Map<Character, Integer> freq = new HashMap<>();
for (char c : s.toCharArray())
    freq.merge(c, 1, Integer::sum);

// HashSet — O(1) avg add/contains
Set<Integer> set = new HashSet<>();
set.add(5);
set.contains(5);
set.remove(5);
set.size();
// Intersection
set.retainAll(otherSet);
// Union
set.addAll(otherSet);
// Difference
set.removeAll(otherSet);

// LinkedHashMap — preserves insertion order
Map<Integer, Integer> lhm = new LinkedHashMap<>();
```

---

## 8. TreeMap & TreeSet

```java
// TreeMap — sorted by key, O(log n)
TreeMap<Integer, String> tm = new TreeMap<>();
tm.put(3, "c"); tm.put(1, "a"); tm.put(2, "b");
tm.firstKey();          // 1
tm.lastKey();           // 3
tm.floorKey(2);         // 2 (≤ 2)
tm.ceilingKey(2);       // 2 (≥ 2)
tm.lowerKey(2);         // 1 (< 2)
tm.higherKey(2);        // 3 (> 2)
tm.headMap(2);          // keys < 2
tm.tailMap(2);          // keys ≥ 2
tm.subMap(1, 3);        // keys [1, 3)

// TreeSet — sorted unique elements, O(log n)
TreeSet<Integer> ts = new TreeSet<>();
ts.add(5); ts.add(1); ts.add(3);
ts.first();        // 1
ts.last();         // 5
ts.floor(4);       // 3 (≤ 4)
ts.ceiling(4);     // 5 (≥ 4)
ts.lower(3);       // 1
ts.higher(3);      // 5
ts.headSet(3);     // [1] (< 3)
ts.tailSet(3);     // [3, 5] (≥ 3)
```

---

## 9. PriorityQueue (Min/Max Heap)

```java
// Min-Heap (default)
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
minHeap.offer(5); minHeap.offer(1); minHeap.offer(3);
minHeap.peek();   // 1 (smallest)
minHeap.poll();   // 1

// Max-Heap
PriorityQueue<Integer> maxHeap = new PriorityQueue<>(Collections.reverseOrder());
// or: new PriorityQueue<>((a, b) -> b - a);

// Custom object heap
PriorityQueue<int[]> pq = new PriorityQueue<>((a, b) -> a[1] - b[1]); // sort by 2nd element

// K Largest Elements
int[] kLargest(int[] nums, int k) {
    PriorityQueue<Integer> minH = new PriorityQueue<>();
    for (int n : nums) {
        minH.offer(n);
        if (minH.size() > k) minH.poll();
    }
    return minH.stream().mapToInt(i->i).toArray();
}

// Dijkstra's shortest path uses min-heap
PriorityQueue<int[]> pq = new PriorityQueue<>((a,b) -> a[1] - b[1]); // {node, dist}
```

---

## 10. Linked List (Custom)

```java
class ListNode {
    int val;
    ListNode next;
    ListNode(int val) { this.val = val; }
}

// Reverse a linked list
ListNode reverse(ListNode head) {
    ListNode prev = null, curr = head;
    while (curr != null) {
        ListNode next = curr.next;
        curr.next = prev;
        prev = curr;
        curr = next;
    }
    return prev;
}

// Detect cycle (Floyd's)
boolean hasCycle(ListNode head) {
    ListNode slow = head, fast = head;
    while (fast != null && fast.next != null) {
        slow = slow.next;
        fast = fast.next.next;
        if (slow == fast) return true;
    }
    return false;
}

// Find middle node
ListNode findMid(ListNode head) {
    ListNode slow = head, fast = head;
    while (fast != null && fast.next != null) {
        slow = slow.next;
        fast = fast.next.next;
    }
    return slow;
}

// Merge two sorted lists
ListNode merge(ListNode l1, ListNode l2) {
    ListNode dummy = new ListNode(0), curr = dummy;
    while (l1 != null && l2 != null) {
        if (l1.val <= l2.val) { curr.next = l1; l1 = l1.next; }
        else                  { curr.next = l2; l2 = l2.next; }
        curr = curr.next;
    }
    curr.next = (l1 != null) ? l1 : l2;
    return dummy.next;
}
```

---

## 11. Binary Tree & BST

```java
class TreeNode {
    int val;
    TreeNode left, right;
    TreeNode(int val) { this.val = val; }
}

// DFS traversals (recursive)
void inorder(TreeNode root) {          // Left → Root → Right
    if (root == null) return;
    inorder(root.left);
    System.out.print(root.val + " ");
    inorder(root.right);
}
void preorder(TreeNode root) {         // Root → Left → Right
    if (root == null) return;
    System.out.print(root.val + " ");
    preorder(root.left);
    preorder(root.right);
}
void postorder(TreeNode root) {        // Left → Right → Root
    if (root == null) return;
    postorder(root.left);
    postorder(root.right);
    System.out.print(root.val + " ");
}

// BFS Level Order
List<List<Integer>> levelOrder(TreeNode root) {
    List<List<Integer>> res = new ArrayList<>();
    if (root == null) return res;
    Queue<TreeNode> q = new LinkedList<>();
    q.offer(root);
    while (!q.isEmpty()) {
        int size = q.size();
        List<Integer> level = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            TreeNode node = q.poll();
            level.add(node.val);
            if (node.left != null) q.offer(node.left);
            if (node.right != null) q.offer(node.right);
        }
        res.add(level);
    }
    return res;
}

// Height of tree
int height(TreeNode root) {
    if (root == null) return 0;
    return 1 + Math.max(height(root.left), height(root.right));
}

// BST Insert
TreeNode insert(TreeNode root, int val) {
    if (root == null) return new TreeNode(val);
    if (val < root.val) root.left = insert(root.left, val);
    else root.right = insert(root.right, val);
    return root;
}

// BST Search
boolean search(TreeNode root, int val) {
    if (root == null) return false;
    if (root.val == val) return true;
    return val < root.val ? search(root.left, val) : search(root.right, val);
}

// Lowest Common Ancestor (BST)
TreeNode lca(TreeNode root, TreeNode p, TreeNode q) {
    if (p.val < root.val && q.val < root.val) return lca(root.left, p, q);
    if (p.val > root.val && q.val > root.val) return lca(root.right, p, q);
    return root;
}
```

---

## 12. Graph — Adjacency List

```java
// Build graph
int n = 5;
List<List<Integer>> graph = new ArrayList<>();
for (int i = 0; i < n; i++) graph.add(new ArrayList<>());
graph.get(0).add(1);
graph.get(1).add(0); // undirected

// Weighted graph
List<List<int[]>> wGraph = new ArrayList<>();
for (int i = 0; i < n; i++) wGraph.add(new ArrayList<>());
wGraph.get(0).add(new int[]{1, 5}); // edge 0→1 weight 5

// DFS (recursive)
boolean[] visited = new boolean[n];
void dfs(int node) {
    visited[node] = true;
    for (int neighbor : graph.get(node)) {
        if (!visited[neighbor]) dfs(neighbor);
    }
}

// BFS
void bfs(int start) {
    boolean[] visited = new boolean[n];
    Queue<Integer> q = new LinkedList<>();
    q.offer(start); visited[start] = true;
    while (!q.isEmpty()) {
        int node = q.poll();
        for (int nb : graph.get(node)) {
            if (!visited[nb]) { visited[nb] = true; q.offer(nb); }
        }
    }
}

// Topological Sort (Kahn's Algorithm — BFS)
int[] topoSort(int n, int[][] edges) {
    int[] indegree = new int[n];
    List<List<Integer>> g = new ArrayList<>();
    for (int i = 0; i < n; i++) g.add(new ArrayList<>());
    for (int[] e : edges) { g.get(e[0]).add(e[1]); indegree[e[1]]++; }
    Queue<Integer> q = new LinkedList<>();
    for (int i = 0; i < n; i++) if (indegree[i] == 0) q.offer(i);
    int[] order = new int[n]; int idx = 0;
    while (!q.isEmpty()) {
        int node = q.poll(); order[idx++] = node;
        for (int nb : g.get(node)) if (--indegree[nb] == 0) q.offer(nb);
    }
    return idx == n ? order : new int[0]; // empty if cycle
}

// Dijkstra's Shortest Path
int[] dijkstra(int src, int n, List<List<int[]>> g) {
    int[] dist = new int[n];
    Arrays.fill(dist, Integer.MAX_VALUE);
    dist[src] = 0;
    PriorityQueue<int[]> pq = new PriorityQueue<>((a,b) -> a[1]-b[1]);
    pq.offer(new int[]{src, 0});
    while (!pq.isEmpty()) {
        int[] curr = pq.poll();
        int node = curr[0], d = curr[1];
        if (d > dist[node]) continue;
        for (int[] nb : g.get(node)) {
            if (dist[node] + nb[1] < dist[nb[0]]) {
                dist[nb[0]] = dist[node] + nb[1];
                pq.offer(new int[]{nb[0], dist[nb[0]]});
            }
        }
    }
    return dist;
}
```

---

## 13. Sorting Algorithms

```java
// Bubble Sort — O(n²)
void bubbleSort(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n-1; i++)
        for (int j = 0; j < n-i-1; j++)
            if (arr[j] > arr[j+1]) { int t=arr[j]; arr[j]=arr[j+1]; arr[j+1]=t; }
}

// Selection Sort — O(n²)
void selectionSort(int[] arr) {
    for (int i = 0; i < arr.length-1; i++) {
        int min = i;
        for (int j = i+1; j < arr.length; j++) if (arr[j] < arr[min]) min = j;
        int t = arr[min]; arr[min] = arr[i]; arr[i] = t;
    }
}

// Insertion Sort — O(n²) avg, O(n) best
void insertionSort(int[] arr) {
    for (int i = 1; i < arr.length; i++) {
        int key = arr[i], j = i-1;
        while (j >= 0 && arr[j] > key) { arr[j+1] = arr[j]; j--; }
        arr[j+1] = key;
    }
}

// Merge Sort — O(n log n)
void mergeSort(int[] arr, int l, int r) {
    if (l >= r) return;
    int mid = l + (r-l)/2;
    mergeSort(arr, l, mid);
    mergeSort(arr, mid+1, r);
    merge(arr, l, mid, r);
}
void merge(int[] arr, int l, int mid, int r) {
    int[] tmp = Arrays.copyOfRange(arr, l, r+1);
    int i = 0, j = mid-l+1, k = l;
    while (i <= mid-l && j <= r-l) arr[k++] = tmp[i]<=tmp[j] ? tmp[i++] : tmp[j++];
    while (i <= mid-l) arr[k++] = tmp[i++];
    while (j <= r-l)   arr[k++] = tmp[j++];
}

// Quick Sort — O(n log n) avg
void quickSort(int[] arr, int l, int r) {
    if (l >= r) return;
    int p = partition(arr, l, r);
    quickSort(arr, l, p-1);
    quickSort(arr, p+1, r);
}
int partition(int[] arr, int l, int r) {
    int pivot = arr[r], i = l-1;
    for (int j = l; j < r; j++)
        if (arr[j] <= pivot) { i++; int t=arr[i]; arr[i]=arr[j]; arr[j]=t; }
    int t=arr[i+1]; arr[i+1]=arr[r]; arr[r]=t;
    return i+1;
}

// Counting Sort — O(n+k), for small range integers
void countingSort(int[] arr, int max) {
    int[] cnt = new int[max+1];
    for (int x : arr) cnt[x]++;
    int i = 0;
    for (int v = 0; v <= max; v++) while (cnt[v]-- > 0) arr[i++] = v;
}
```

---

## 14. Searching Algorithms

```java
// Linear Search — O(n)
int linearSearch(int[] arr, int target) {
    for (int i = 0; i < arr.length; i++)
        if (arr[i] == target) return i;
    return -1;
}

// Binary Search — O(log n), array must be sorted
int binarySearch(int[] arr, int target) {
    int l = 0, r = arr.length - 1;
    while (l <= r) {
        int mid = l + (r-l)/2;
        if (arr[mid] == target) return mid;
        else if (arr[mid] < target) l = mid+1;
        else r = mid-1;
    }
    return -1;
}

// First occurrence of target
int firstOccurrence(int[] arr, int target) {
    int l = 0, r = arr.length-1, res = -1;
    while (l <= r) {
        int mid = l+(r-l)/2;
        if (arr[mid] == target) { res = mid; r = mid-1; }
        else if (arr[mid] < target) l = mid+1;
        else r = mid-1;
    }
    return res;
}

// Lower bound (first idx where arr[idx] >= target)
int lowerBound(int[] arr, int target) {
    int l = 0, r = arr.length;
    while (l < r) {
        int mid = l+(r-l)/2;
        if (arr[mid] < target) l = mid+1;
        else r = mid;
    }
    return l;
}
```

---

## 15. Recursion & Backtracking

```java
// Fibonacci (memoized)
Map<Integer,Long> memo = new HashMap<>();
long fib(int n) {
    if (n <= 1) return n;
    if (memo.containsKey(n)) return memo.get(n);
    long res = fib(n-1) + fib(n-2);
    memo.put(n, res);
    return res;
}

// Permutations
List<List<Integer>> permutations = new ArrayList<>();
void permute(int[] nums, List<Integer> curr, boolean[] used) {
    if (curr.size() == nums.length) { permutations.add(new ArrayList<>(curr)); return; }
    for (int i = 0; i < nums.length; i++) {
        if (used[i]) continue;
        used[i] = true; curr.add(nums[i]);
        permute(nums, curr, used);
        used[i] = false; curr.remove(curr.size()-1);
    }
}

// Subsets (Power Set)
List<List<Integer>> subsets(int[] nums) {
    List<List<Integer>> res = new ArrayList<>();
    backtrack(nums, 0, new ArrayList<>(), res);
    return res;
}
void backtrack(int[] nums, int start, List<Integer> curr, List<List<Integer>> res) {
    res.add(new ArrayList<>(curr));
    for (int i = start; i < nums.length; i++) {
        curr.add(nums[i]);
        backtrack(nums, i+1, curr, res);
        curr.remove(curr.size()-1);
    }
}

// N-Queens
List<List<String>> solveNQueens(int n) {
    List<List<String>> res = new ArrayList<>();
    char[][] board = new char[n][n];
    for (char[] row : board) Arrays.fill(row, '.');
    solveNQ(board, 0, res);
    return res;
}
void solveNQ(char[][] b, int row, List<List<String>> res) {
    if (row == b.length) {
        List<String> sol = new ArrayList<>();
        for (char[] r : b) sol.add(new String(r));
        res.add(sol); return;
    }
    for (int col = 0; col < b.length; col++) {
        if (isSafe(b, row, col)) {
            b[row][col] = 'Q';
            solveNQ(b, row+1, res);
            b[row][col] = '.';
        }
    }
}
boolean isSafe(char[][] b, int r, int c) {
    for (int i = 0; i < r; i++) if (b[i][c] == 'Q') return false;
    for (int i=r-1,j=c-1; i>=0&&j>=0; i--,j--) if (b[i][j] == 'Q') return false;
    for (int i=r-1,j=c+1; i>=0&&j<b.length; i--,j++) if (b[i][j] == 'Q') return false;
    return true;
}
```

---

## 16. Dynamic Programming

```java
// 1D DP — Climbing Stairs / Fibonacci style
int climbStairs(int n) {
    if (n <= 2) return n;
    int a = 1, b = 2;
    for (int i = 3; i <= n; i++) { int c = a+b; a=b; b=c; }
    return b;
}

// Coin Change — min coins
int coinChange(int[] coins, int amount) {
    int[] dp = new int[amount+1];
    Arrays.fill(dp, amount+1);
    dp[0] = 0;
    for (int i = 1; i <= amount; i++)
        for (int c : coins)
            if (c <= i) dp[i] = Math.min(dp[i], dp[i-c]+1);
    return dp[amount] > amount ? -1 : dp[amount];
}

// 0/1 Knapsack
int knapsack(int[] wt, int[] val, int W) {
    int n = wt.length;
    int[][] dp = new int[n+1][W+1];
    for (int i = 1; i <= n; i++)
        for (int w = 0; w <= W; w++) {
            dp[i][w] = dp[i-1][w];
            if (wt[i-1] <= w) dp[i][w] = Math.max(dp[i][w], dp[i-1][w-wt[i-1]] + val[i-1]);
        }
    return dp[n][W];
}

// Longest Common Subsequence
int lcs(String s1, String s2) {
    int m = s1.length(), n = s2.length();
    int[][] dp = new int[m+1][n+1];
    for (int i = 1; i <= m; i++)
        for (int j = 1; j <= n; j++)
            dp[i][j] = s1.charAt(i-1) == s2.charAt(j-1)
                       ? dp[i-1][j-1]+1 : Math.max(dp[i-1][j], dp[i][j-1]);
    return dp[m][n];
}

// Longest Increasing Subsequence — O(n log n)
int lis(int[] nums) {
    List<Integer> tails = new ArrayList<>();
    for (int x : nums) {
        int lo = 0, hi = tails.size();
        while (lo < hi) { int mid=(lo+hi)/2; if (tails.get(mid)<x) lo=mid+1; else hi=mid; }
        if (lo == tails.size()) tails.add(x);
        else tails.set(lo, x);
    }
    return tails.size();
}

// Matrix Chain Multiplication
int mcm(int[] dims) {
    int n = dims.length-1;
    int[][] dp = new int[n][n];
    for (int len = 2; len <= n; len++)
        for (int i = 0; i <= n-len; i++) {
            int j = i+len-1; dp[i][j] = Integer.MAX_VALUE;
            for (int k = i; k < j; k++)
                dp[i][j] = Math.min(dp[i][j], dp[i][k]+dp[k+1][j]+dims[i]*dims[k+1]*dims[j+1]);
        }
    return dp[0][n-1];
}
```

---

## 17. Two Pointers

```java
// Two Sum in sorted array
int[] twoSum(int[] arr, int target) {
    int l = 0, r = arr.length-1;
    while (l < r) {
        int sum = arr[l]+arr[r];
        if (sum == target) return new int[]{l, r};
        else if (sum < target) l++;
        else r--;
    }
    return new int[]{-1,-1};
}

// Container With Most Water
int maxWater(int[] h) {
    int l=0, r=h.length-1, max=0;
    while (l < r) {
        max = Math.max(max, Math.min(h[l],h[r])*(r-l));
        if (h[l] < h[r]) l++; else r--;
    }
    return max;
}

// Remove duplicates from sorted array
int removeDuplicates(int[] nums) {
    int k = 1;
    for (int i = 1; i < nums.length; i++)
        if (nums[i] != nums[i-1]) nums[k++] = nums[i];
    return k;
}

// 3Sum
List<List<Integer>> threeSum(int[] nums) {
    Arrays.sort(nums);
    List<List<Integer>> res = new ArrayList<>();
    for (int i = 0; i < nums.length-2; i++) {
        if (i > 0 && nums[i] == nums[i-1]) continue;
        int l = i+1, r = nums.length-1;
        while (l < r) {
            int sum = nums[i]+nums[l]+nums[r];
            if (sum == 0) {
                res.add(Arrays.asList(nums[i],nums[l],nums[r]));
                while (l<r && nums[l]==nums[l+1]) l++;
                while (l<r && nums[r]==nums[r-1]) r--;
                l++; r--;
            } else if (sum < 0) l++; else r--;
        }
    }
    return res;
}
```

---

## 18. Sliding Window

```java
// Fixed window — max sum of k elements
int maxSumFixed(int[] arr, int k) {
    int sum = 0;
    for (int i = 0; i < k; i++) sum += arr[i];
    int max = sum;
    for (int i = k; i < arr.length; i++) {
        sum += arr[i] - arr[i-k];
        max = Math.max(max, sum);
    }
    return max;
}

// Variable window — longest substring without repeating chars
int lengthOfLongestSubstring(String s) {
    Map<Character,Integer> map = new HashMap<>();
    int l=0, max=0;
    for (int r = 0; r < s.length(); r++) {
        char c = s.charAt(r);
        if (map.containsKey(c)) l = Math.max(l, map.get(c)+1);
        map.put(c, r);
        max = Math.max(max, r-l+1);
    }
    return max;
}

// Minimum window substring
String minWindow(String s, String t) {
    int[] need = new int[128]; int formed = t.length();
    for (char c : t.toCharArray()) need[c]++;
    int l=0, minLen=Integer.MAX_VALUE, start=0;
    for (int r = 0; r < s.length(); r++) {
        if (need[s.charAt(r)]-- > 0) formed--;
        while (formed == 0) {
            if (r-l+1 < minLen) { minLen=r-l+1; start=l; }
            if (++need[s.charAt(l++)] > 0) formed++;
        }
    }
    return minLen==Integer.MAX_VALUE ? "" : s.substring(start, start+minLen);
}
```

---

## 19. Binary Search (Patterns)

```java
// Search in rotated sorted array
int searchRotated(int[] nums, int target) {
    int l = 0, r = nums.length-1;
    while (l <= r) {
        int mid = l+(r-l)/2;
        if (nums[mid] == target) return mid;
        if (nums[l] <= nums[mid]) { // left half sorted
            if (nums[l] <= target && target < nums[mid]) r = mid-1;
            else l = mid+1;
        } else {                    // right half sorted
            if (nums[mid] < target && target <= nums[r]) l = mid+1;
            else r = mid-1;
        }
    }
    return -1;
}

// Find peak element
int findPeak(int[] nums) {
    int l = 0, r = nums.length-1;
    while (l < r) {
        int mid = l+(r-l)/2;
        if (nums[mid] > nums[mid+1]) r = mid;
        else l = mid+1;
    }
    return l;
}

// Binary search on answer — min days to make bouquets
boolean canMake(int[] b, int m, int k, int days) {
    int bouquets = 0, flowers = 0;
    for (int bloom : b) {
        if (bloom <= days) { if (++flowers == k) { bouquets++; flowers=0; } }
        else flowers = 0;
    }
    return bouquets >= m;
}
int minDays(int[] b, int m, int k) {
    int l = 1, r = (int)1e9, res = -1;
    while (l <= r) {
        int mid = l+(r-l)/2;
        if (canMake(b,m,k,mid)) { res=mid; r=mid-1; } else l=mid+1;
    }
    return res;
}
```

---

## 20. Graph Traversals — BFS & DFS

```java
// DFS — count islands
int numIslands(char[][] grid) {
    int count = 0;
    for (int i = 0; i < grid.length; i++)
        for (int j = 0; j < grid[0].length; j++)
            if (grid[i][j] == '1') { dfsGrid(grid,i,j); count++; }
    return count;
}
void dfsGrid(char[][] g, int i, int j) {
    if (i<0||i>=g.length||j<0||j>=g[0].length||g[i][j]!='1') return;
    g[i][j] = '0';
    int[] dx={0,0,1,-1}, dy={1,-1,0,0};
    for (int d=0;d<4;d++) dfsGrid(g, i+dx[d], j+dy[d]);
}

// BFS — shortest path in grid
int shortestPath(int[][] grid, int[] start, int[] end) {
    int m=grid.length, n=grid[0].length;
    int[][] dist = new int[m][n];
    for (int[] r : dist) Arrays.fill(r, -1);
    Queue<int[]> q = new LinkedList<>();
    q.offer(start); dist[start[0]][start[1]] = 0;
    int[] dx={0,0,1,-1}, dy={1,-1,0,0};
    while (!q.isEmpty()) {
        int[] curr = q.poll();
        if (curr[0]==end[0] && curr[1]==end[1]) return dist[end[0]][end[1]];
        for (int d=0;d<4;d++) {
            int nx=curr[0]+dx[d], ny=curr[1]+dy[d];
            if (nx>=0&&nx<m&&ny>=0&&ny<n&&grid[nx][ny]==0&&dist[nx][ny]==-1) {
                dist[nx][ny]=dist[curr[0]][curr[1]]+1;
                q.offer(new int[]{nx,ny});
            }
        }
    }
    return -1;
}
```

---

## 21. Trie

```java
class TrieNode {
    TrieNode[] children = new TrieNode[26];
    boolean isEnd;
}

class Trie {
    TrieNode root = new TrieNode();

    void insert(String word) {
        TrieNode node = root;
        for (char c : word.toCharArray()) {
            int i = c-'a';
            if (node.children[i] == null) node.children[i] = new TrieNode();
            node = node.children[i];
        }
        node.isEnd = true;
    }

    boolean search(String word) {
        TrieNode node = root;
        for (char c : word.toCharArray()) {
            int i = c-'a';
            if (node.children[i] == null) return false;
            node = node.children[i];
        }
        return node.isEnd;
    }

    boolean startsWith(String prefix) {
        TrieNode node = root;
        for (char c : prefix.toCharArray()) {
            int i = c-'a';
            if (node.children[i] == null) return false;
            node = node.children[i];
        }
        return true;
    }
}
```

---

## 22. Union-Find (Disjoint Set)

```java
class UnionFind {
    int[] parent, rank;

    UnionFind(int n) {
        parent = new int[n]; rank = new int[n];
        for (int i = 0; i < n; i++) parent[i] = i;
    }

    int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]); // path compression
        return parent[x];
    }

    boolean union(int x, int y) {
        int px = find(x), py = find(y);
        if (px == py) return false; // already connected
        if (rank[px] < rank[py]) parent[px] = py;
        else if (rank[px] > rank[py]) parent[py] = px;
        else { parent[py] = px; rank[px]++; }
        return true;
    }

    boolean connected(int x, int y) { return find(x) == find(y); }
}

// Kruskal's MST using Union-Find
int kruskal(int n, int[][] edges) { // edges: [u, v, weight]
    Arrays.sort(edges, (a,b) -> a[2]-b[2]);
    UnionFind uf = new UnionFind(n);
    int cost = 0, edgeCount = 0;
    for (int[] e : edges) {
        if (uf.union(e[0], e[1])) {
            cost += e[2]; edgeCount++;
            if (edgeCount == n-1) break;
        }
    }
    return edgeCount == n-1 ? cost : -1; // -1 if no MST
}
```

---

## 23. Segment Tree

```java
class SegmentTree {
    int[] tree;
    int n;

    SegmentTree(int[] arr) {
        n = arr.length;
        tree = new int[4*n];
        build(arr, 0, 0, n-1);
    }

    void build(int[] arr, int node, int l, int r) {
        if (l == r) { tree[node] = arr[l]; return; }
        int mid = l+(r-l)/2;
        build(arr, 2*node+1, l, mid);
        build(arr, 2*node+2, mid+1, r);
        tree[node] = tree[2*node+1] + tree[2*node+2]; // sum tree
    }

    void update(int node, int l, int r, int idx, int val) {
        if (l == r) { tree[node] = val; return; }
        int mid = l+(r-l)/2;
        if (idx <= mid) update(2*node+1, l, mid, idx, val);
        else update(2*node+2, mid+1, r, idx, val);
        tree[node] = tree[2*node+1] + tree[2*node+2];
    }

    int query(int node, int l, int r, int ql, int qr) {
        if (qr < l || r < ql) return 0;
        if (ql <= l && r <= qr) return tree[node];
        int mid = l+(r-l)/2;
        return query(2*node+1,l,mid,ql,qr) + query(2*node+2,mid+1,r,ql,qr);
    }

    // Public methods
    void update(int idx, int val) { update(0, 0, n-1, idx, val); }
    int query(int l, int r) { return query(0, 0, n-1, l, r); }
}
```

---

## 24. Bit Manipulation Tricks

```java
// Check if power of 2
boolean isPow2(int n) { return n > 0 && (n & (n-1)) == 0; }

// Count set bits (Brian Kernighan)
int countBits(int n) {
    int cnt = 0;
    while (n != 0) { n &= (n-1); cnt++; }
    return cnt;
}

// Get / Set / Clear bit at position i
int getBit(int n, int i)   { return (n >> i) & 1; }
int setBit(int n, int i)   { return n | (1 << i); }
int clearBit(int n, int i) { return n & ~(1 << i); }
int toggleBit(int n, int i){ return n ^ (1 << i); }

// XOR tricks
// a ^ a = 0, a ^ 0 = a
// Find single number (all others appear twice)
int singleNumber(int[] nums) { int x=0; for(int n:nums) x^=n; return x; }

// Swap without temp
a ^= b; b ^= a; a ^= b;

// Check even/odd
boolean isEven(int n) { return (n & 1) == 0; }

// Multiply / Divide by 2
int mul2 = n << 1;
int div2 = n >> 1;

// Subset enumeration using bits
// Enumerate all subsets of set {0..n-1}
for (int mask = 0; mask < (1<<n); mask++) {
    List<Integer> subset = new ArrayList<>();
    for (int i = 0; i < n; i++)
        if ((mask & (1<<i)) != 0) subset.add(i);
}
```

---

## 25. Complexity Cheat Sheet

```
Data Structure         Access    Search   Insert   Delete
──────────────────────────────────────────────────────────
Array                  O(1)      O(n)     O(n)     O(n)
ArrayList              O(1)      O(n)     O(1)*    O(n)
LinkedList             O(n)      O(n)     O(1)     O(1)
Stack (ArrayDeque)     O(n)      O(n)     O(1)     O(1)
Queue (ArrayDeque)     O(n)      O(n)     O(1)     O(1)
HashMap / HashSet      O(1)*     O(1)*    O(1)*    O(1)*
TreeMap / TreeSet      O(log n)  O(log n) O(log n) O(log n)
PriorityQueue          O(n)      O(n)     O(log n) O(log n)
Binary Search Tree     O(log n)* O(log n)*O(log n)*O(log n)*
Trie                   O(m)      O(m)     O(m)     O(m)
Segment Tree           —         O(log n) O(log n) O(log n)
Union-Find             —         O(α n)   O(α n)   —

* amortised / average case
m = length of key/string
α = inverse Ackermann ≈ O(1) practically

Algorithm              Best       Average    Worst      Space
──────────────────────────────────────────────────────────────
Bubble Sort            O(n)       O(n²)      O(n²)      O(1)
Selection Sort         O(n²)      O(n²)      O(n²)      O(1)
Insertion Sort         O(n)       O(n²)      O(n²)      O(1)
Merge Sort             O(n log n) O(n log n) O(n log n) O(n)
Quick Sort             O(n log n) O(n log n) O(n²)      O(log n)
Heap Sort              O(n log n) O(n log n) O(n log n) O(1)
Counting Sort          O(n+k)     O(n+k)     O(n+k)     O(k)
Binary Search          O(1)       O(log n)   O(log n)   O(1)
BFS / DFS              O(V+E)     O(V+E)     O(V+E)     O(V)
Dijkstra               —          O((V+E) log V) —      O(V)
```

---

_Happy Coding! 🚀 — Practice on LeetCode, Codeforces, and GeeksforGeeks._