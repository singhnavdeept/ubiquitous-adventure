#concept/practice

### Part 1: What Are Heaps? (The Concept)

A **Heap** is a specialized **tree-based** data structure that satisfies the **Heap Property**.

**The Heap Property (The Golden Rule):**
- **Max-Heap:** For any given node `P`, the value of `P` is **greater than or equal to** the value of its children. (The root is the maximum element).
- **Min-Heap:** For any given node `P`, the value of `P` is **less than or equal to** the value of its children. (The root is the minimum element).

**Crucial Distinction:**
A heap is **NOT** a sorted array. It is **partially ordered**.
- In a sorted array: `[1, 2, 3, 4]` -> You know exactly where `2` is relative to `4`.
- In a Min-Heap: `[1, 4, 2, 8, 5, 3]` -> You only know **1 is the smallest**. You do **not** know if `4` is smaller than `3` unless you traverse the tree.

**Visual Shape (Structure Property):**
A Heap is always a **Complete Binary Tree**.
- All levels are completely filled except possibly the last level.
- The last level is filled **from left to right**.

```
     [10]          <-- Root (Max)
     /  \
   [5]  [8]        <-- Both smaller than parent (Max-Heap rule)
   / \   /
 [3] [2] [7]       <-- "Left-Justified" (Complete Tree rule)
```

### Part 2: How Are They Implemented? (The Code Secret)

While a heap is conceptually a tree, **we almost never implement it with Node objects and pointers** (like `Node left; Node right;`). That would be memory inefficient and slow.

**The Standard Implementation: An Array.**

Because a heap is a **Complete Binary Tree**, we can map every position in the tree to an index in an array.

**The Index Math:**
If a parent node is at index `i` (0-based array):
- **Left Child:** `(2 * i) + 1`
- **Right Child:** `(2 * i) + 2`
- **Parent:** `floor((i - 1) / 2)`

**Visualizing the Array Mapping:**
```
Tree:            [10]
                /   \
              [5]   [8]
              / \   /
            [3] [2] [7]

Array Index:   0    1    2    3    4    5
Array Value:  [10] [5]  [8]  [3]  [2]  [7]
```
*Check:* Index 1 (value 5) has left child at `(2*1)+1 = 3` (value 3). Correct.

---

### Part 3: Core Operations (How it Works)

The magic of heaps comes from two internal functions that fix the order when items are added or removed.

#### 1. Insertion (Push) -> `O(log n)`
**Algorithm:** *Percolate Up / Bubble Up / Heapify Up*
1. Add the new element to the **very end** of the array (bottom-rightmost empty spot).
2. Compare the new element with its parent.
3. If it violates the heap property (e.g., child > parent in a Max-Heap), **swap them**.
4. Repeat step 3 until the heap property is restored.

#### 2. Extraction (Pop / Poll) -> `O(log n)`
**Algorithm:** *Percolate Down / Sink Down / Heapify Down*
1. **Goal:** Remove the root (index 0).
2. **Swap:** Take the *last* element in the array and move it to the root position.
3. **Remove Last:** Delete the old root (which is now at the end).
4. **Fix the Top:** Compare the new root with its children. If it is smaller than a child (Max-Heap), swap it with the **larger** child.
5. Repeat step 4 down the tree until the property is restored.

#### 3. Peek (Get Min/Max) -> `O(1)`
- Simply return `array[0]`. This is why heaps are fast.

#### 4. Build Heap (Heapify Array) -> `O(n)`
- If you have an unsorted array and want to turn it into a heap, you don't call Insert `n` times (which is `O(n log n)`).
- You call **Percolate Down** starting from the last non-leaf node backwards. This is mathematically `O(n)`.

---

### Part 4: Best Scenarios for Using Heaps

This is where the theory pays off. You use a Heap when you only care about the **"Extreme"** value (Min or Max) repeatedly.

| Scenario | Why Heap is Best |
| :--- | :--- |
| **1. Priority Queue** | This is the **canonical use case**. You have tasks with priorities. You always need the *highest priority* task next. Heap gives you `O(1)` access to it and `O(log n)` update. |
| **2. Finding Top-K Items** | **Scenario:** "Find the 10 most watched movies on Netflix." You don't need to sort *all* movies ($$O(n \log n)$$). Use a **Min-Heap** of size 10. As you stream data, if new item > heap min, pop the min and insert the new item. Time: $$O(n \log k)$$. |
| **3. Dijkstra's Algorithm (Shortest Path)** | In graph theory, you constantly need to pick the "unvisited node with the smallest tentative distance." A Min-Heap makes this step `O(log n)` instead of scanning the whole list `O(n)`. |
| **4. Median Maintenance (Streaming Data)** | **Scenario:** You are receiving stock prices live. At any moment, hit "Calculate Median." You cannot re-sort the entire list every second. Solution: Use **Two Heaps** (One Max-Heap for lower half, One Min-Heap for upper half). |
| **5. Timer/Wake-up Services** | Operating systems and game engines use Min-Heaps to store timers. "Which timer expires *next*?" The root of the heap holds the answer. |
| **6. Huffman Coding (Compression)** | When building the optimal prefix tree for compression (ZIP files), you constantly need to merge the two nodes with the *lowest* frequencies. A Min-Heap is perfect for this. |

### Summary Comparison Table

| Feature | Heap | Sorted Array | Balanced BST (TreeMap) |
| :--- | :--- | :--- | :--- |
| **Find Min/Max** | `O(1)` | `O(1)` | `O(log n)` |
| **Insert** | `O(log n)` | `O(n)` | `O(log n)` |
| **Delete Min/Max** | `O(log n)` | `O(1)`* (if end) / `O(n)`* (if middle) | `O(log n)` |
| **Memory** | Low (Contiguous Array) | Low | High (Pointers) |


### The Core Concept: `heapify` (or `make_heap`)

When you have an unsorted array and you want to turn it into a valid **Max-Heap** (or Min-Heap), you don't need to call `push()` for every element one by one. Doing so would be `O(n log n)`.

The **Bottom-Up Heapify** algorithm achieves this in **O(n)** time.

### The Algorithm Logic (Step-by-Step)

A heap is a **Complete Binary Tree**. The leaf nodes (the last half of the array) are already valid heaps of size 1—they have no children, so they automatically satisfy the heap property.

Therefore, we only need to fix the **internal nodes** (parents).
We start from the **last non-leaf node** and move **backwards to the root**, applying a `heapifyDown` (also called `siftDown`) operation to each node.

**Finding the Starting Point:**
In a 0-indexed array of size `n`:
- Last element index: `n - 1`
- Parent of last element: `(n - 1 - 1) / 2` = `(n / 2) - 1`

**The Process:**
```text
Array: [3, 5, 9, 6, 8, 20, 10]

1. n = 7. Start index = (7/2) - 1 = 2. (Value: 9)
2. Check index 2 (9). Children are 20 and 10. Swap 9 with 20.
3. Check index 1 (5). Children are 6 and 8. Swap 5 with 8.
4. Check index 0 (3). Children are 8 and 20. Swap 3 with 20.
5. Re-check where 3 landed (index 2). Children are 9 and 10. Swap 3 with 10.

Result: [20, 8, 10, 6, 5, 9, 3] (Valid Max-Heap)
```

---

### Implementation in C++

There are two ways to do this in C++:

1. **The Standard Library Way** (Use this 99% of the time).
2. **The "From Scratch" Way** (Understanding the algorithm).

#### Method 1: Using `std::make_heap` (Recommended)

C++ provides a set of heap algorithms in `<algorithm>` that work directly on random-access containers (like `std::vector` or C-style arrays).

```cpp
#include <iostream>
#include <vector>
#include <algorithm> // for make_heap, push_heap, pop_heap

int main() {
    // 1. Start with unsorted data
    std::vector<int> data = {3, 5, 9, 6, 8, 20, 10};
    
    std::cout << "Before heapify: ";
    for (int x : data) std::cout << x << " ";
    
    // 2. Heapify in O(n) time
    std::make_heap(data.begin(), data.end());
    
    std::cout << "\nAfter heapify (Max-Heap): ";
    for (int x : data) std::cout << x << " ";
    
    // 3. To make a Min-Heap, use std::greater
    std::make_heap(data.begin(), data.end(), std::greater<int>{});
    std::cout << "\nMin-Heap version: ";
    for (int x : data) std::cout << x << " ";
    
    return 0;
}
// Output:
// Before heapify: 3 5 9 6 8 20 10 
// After heapify (Max-Heap): 20 8 10 6 5 9 3 
// Min-Heap version: 3 5 9 6 8 20 10 (Order depends on tree layout, root is 3)
```

#### Method 2: Manual Implementation (Educational)

This is exactly what `std::make_heap` does under the hood.

```cpp
#include <iostream>
#include <vector>

// Function to perform "Sift Down" (Heapify Down) at a given root index
void heapifyDown(std::vector<int>& arr, int n, int i) {
    int largest = i;       // Assume root is largest
    int left = 2 * i + 1;  // Left child index
    int right = 2 * i + 2; // Right child index

    // If left child is larger than root
    if (left < n && arr[left] > arr[largest])
        largest = left;

    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest])
        largest = right;

    // If largest is not root, swap and continue sifting down
    if (largest != i) {
        std::swap(arr[i], arr[largest]);
        heapifyDown(arr, n, largest); // Recursive call to fix the affected subtree
    }
}

// Function to build a Max-Heap from an array in O(n) time
void buildHeap(std::vector<int>& arr) {
    int n = arr.size();
    
    // Start from last non-leaf node and go up to root
    // Index of last non-leaf node = (n/2) - 1
    int startIdx = (n / 2) - 1;

    // Perform reverse level order traversal
    for (int i = startIdx; i >= 0; i--) {
        heapifyDown(arr, n, i);
    }
}

int main() {
    std::vector<int> arr = {3, 5, 9, 6, 8, 20, 10};
    
    std::cout << "Original Array: ";
    for (int x : arr) std::cout << x << " ";
    
    buildHeap(arr);
    
    std::cout << "\nManual Max-Heap: ";
    for (int x : arr) std::cout << x << " ";
    
    return 0;
}
// Output:
// Original Array: 3 5 9 6 8 20 10 
// Manual Max-Heap: 20 8 10 6 5 9 3 
```

### Why is Heapify O(n) and not O(n log n)?

This is a classic interview question and a common misconception.

If you insert `n` elements one by one using `push_heap` (`O(log n)` each), the total is **`O(n log n)`**.
But when you build from an existing array using the bottom-up method:

- **Half the nodes** (leaves) require **0** swaps. (Level h)
- **Quarter of the nodes** require **1** swap. (Level h-1)
- **Eighth of the nodes** require **2** swaps. (Level h-2)

The total work is bounded by a geometric series:
$$\sum_{h=0}^{\log n} \frac{n}{2^{h+1}} \cdot h < n \sum_{h=0}^{\infty} \frac{h}{2^{h}} = 2n$$

Thus, **Time Complexity = O(n)**.

### Important C++ Note: Heap Order vs. Sorted Order

A common mistake in C++ is printing a heap expecting it to be sorted. **It is not.**

```cpp
std::vector<int> v = {1, 5, 2, 8, 3};
std::make_heap(v.begin(), v.end());
// v is now [8, 5, 2, 1, 3] -> 8 is at front, but rest is tree-order.

// To get sorted output from a heap, you must use sort_heap:
std::sort_heap(v.begin(), v.end()); // Modifies the heap into sorted ascending order
```

### Summary Table of C++ Heap Functions

| Function | Header | Description |
| :--- | :--- | :--- |
| `std::make_heap(begin, end)` | `<algorithm>` | Turns range into a **Max-Heap**. **O(n)** |
| `std::push_heap(begin, end)` | `<algorithm>` | Adds last element (pre-pushed via `push_back`) to heap. **O(log n)** |
| `std::pop_heap(begin, end)` | `<algorithm>` | Moves root to end of range. **O(log n)** |
| `std::sort_heap(begin, end)` | `<algorithm>` | Sorts the heap range (loses heap property). **O(n log n)** |
| `std::priority_queue<T>` | `<queue>` | Wrapper class that uses these algorithms internally. |

**Final Advice:** Unless you are in a coding interview or writing a custom container, always prefer `std::make_heap` or `std::priority_queue` over a hand-rolled implementation. They are optimized, exception-safe, and correct


To make a **Min-Heap** using the `heapify` process, the logic is almost identical to building a Max-Heap. The only difference is the **comparison direction**.

### The Core Change

- **Max-Heap Property:** Parent ≥ Children. (Swap if parent is *smaller* than child).
- **Min-Heap Property:** Parent ≤ Children. (Swap if parent is *larger* than child).

Everything else—starting index, `O(n)` complexity, array representation—remains exactly the same.

---

### Method 1: Using C++ Standard Library (`std::make_heap`)

This is the easiest and recommended way. You pass a **comparator** that tells the algorithm what "larger" means.

```cpp
#include <iostream>
#include <vector>
#include <algorithm> // make_heap, greater

int main() {
    std::vector<int> data = {3, 5, 9, 6, 8, 20, 10};
    
    // Option A: Max-Heap (default)
    // std::make_heap(data.begin(), data.end());
    
    // Option B: Min-Heap (using std::greater<int>)
    std::make_heap(data.begin(), data.end(), std::greater<int>{});
    
    std::cout << "Min-Heap (root is smallest): ";
    for (int x : data) std::cout << x << " ";
    // Output: 3 5 9 6 8 20 10 (Note: The array is heap-ordered, not sorted)
    // The root is data[0] = 3 (minimum)
    
    return 0;
}
```

**Important:** `std::greater<int>{}` tells `make_heap` to consider a value "larger" if it is **numerically greater**. This flips the heap property to maintain the *minimum* at the root.

---

### Method 2: Manual Implementation (For Understanding)

Here is the exact `heapifyDown` function from before, but modified for **Min-Heap**.

```cpp
#include <iostream>
#include <vector>

// Sift Down function for MIN-HEAP
void minHeapifyDown(std::vector<int>& arr, int n, int i) {
    int smallest = i;       // Assume root is smallest
    int left = 2 * i + 1;
    int right = 2 * i + 2;

    // CHANGED: Look for smaller child, not larger
    if (left < n && arr[left] < arr[smallest])   // < instead of >
        smallest = left;

    if (right < n && arr[right] < arr[smallest]) // < instead of >
        smallest = right;

    if (smallest != i) {
        std::swap(arr[i], arr[smallest]);
        minHeapifyDown(arr, n, smallest);
    }
}

// Build Min-Heap from array
void buildMinHeap(std::vector<int>& arr) {
    int n = arr.size();
    int startIdx = (n / 2) - 1; // Last non-leaf node

    for (int i = startIdx; i >= 0; i--) {
        minHeapifyDown(arr, n, i);
    }
}

int main() {
    std::vector<int> arr = {3, 5, 9, 6, 8, 20, 10};
    
    buildMinHeap(arr);
    
    std::cout << "Manual Min-Heap: ";
    for (int x : arr) std::cout << x << " ";
    // Output: 3 5 9 6 8 20 10 (root = 3)
    
    return 0;
}
```

### Visual Walkthrough of Min-Heapify

Let's trace the array `[3, 5, 9, 6, 8, 20, 10]`:

1. **Start at index 2** (value 9). Children: 20, 10. Both > 9. No swap.
2. **Index 1** (value 5). Children: 6, 8. Both > 5. No swap.
3. **Index 0** (value 3). Children: 5, 9. Both > 3. No swap.
Wait—this array **already happened to be a valid Min-Heap** by chance.

Let's use a different array that needs fixing: `[10, 20, 15, 12, 40, 25, 18]` (This is actually a Max-Heap). We want a Min-Heap.

- **Index 2** (15): Children 25, 18. Both > 15. Ok.
- **Index 1** (20): Children 12, 40. **12 is smaller!** Swap 20 with 12.
  - Now tree: `[10, 12, 15, 20, 40, 25, 18]`
- **Index 0** (10): Children 12, 15. Both > 10. Ok.

Final Min-Heap: `[10, 12, 15, 20, 40, 25, 18]` (Root is 10, smallest).

### Comparison: Max-Heap vs Min-Heap Code Changes

| Line in `heapifyDown` | Max-Heap | Min-Heap |
| :--- | :--- | :--- |
| **Variable Name** | `largest` | `smallest` |
| **Compare Left** | `arr[left] > arr[largest]` | `arr[left] < arr[smallest]` |
| **Compare Right** | `arr[right] > arr[largest]` | `arr[right] < arr[smallest]` |
| **Condition** | `largest != i` | `smallest != i` |

Everything else is identical.

### Full Example with Both Operations

To show that the heap actually works, here is a complete snippet that builds a Min-Heap, extracts the min, and prints sorted order using `pop_heap`.

```cpp
#include <iostream>
#include <vector>
#include <algorithm>

int main() {
    std::vector<int> v = {45, 10, 78, 23, 5, 99, 1};
    
    // 1. Build Min-Heap
    std::make_heap(v.begin(), v.end(), std::greater<int>{});
    
    std::cout << "Min-Heap: ";
    for (int x : v) std::cout << x << " "; // Root is 1
    std::cout << "\n";

    // 2. Extract elements in sorted order (ascending)
    std::cout << "Sorted Output: ";
    while (!v.empty()) {
        std::pop_heap(v.begin(), v.end(), std::greater<int>{}); // Moves min to back
        std::cout << v.back() << " "; // Print the min
        v.pop_back();                 // Remove it
    }
    // Output: 1 5 10 23 45 78 99
    return 0;
}
```

**Summary:** To turn a Max-Heap implementation into a Min-Heap, simply flip the comparison operators from `>` to `<`. In STL, pass `std::greater<T>()` as the comparator. The underlying `O(n)` heapify algorithm remains unchanged.



