As a Python developer and data scientist, I approach these algorithmic problems much like I approach a messy dataset: it’s all about finding the underlying patterns, optimizing data access, and choosing the right data structures. Most of the problems you’ve listed fall under **Greedy Algorithms**, **Priority Queues (Heaps)**, or **Array Manipulation**. 

Here is a highly detailed, formatted breakdown of the intuition, approach, and production-ready Python code for each problem.

---

### 121. Best Time to Buy and Sell Stock
**The Problem**: Given an array of prices (think time-series data), find the maximum profit from exactly one buy and one sell operation.

*   **What moves us toward the answer**: We only care about the lowest price seen *so far* and the maximum profit we can achieve if we sell at the *current* price. 
*   **Intuition**: As we iterate through the time-series, we update our "historical minimum." Simultaneously, we calculate the gradient (difference) between today's price and that historical minimum. We keep a running maximum of these gradients.

```python
from typing import List

class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        min_price = float('inf')
        max_profit = 0
        
        for price in prices:
            # Update the lowest price encountered so far
            if price < min_price:
                min_price = price
            # Calculate profit if we sell today, and update max_profit
            elif price - min_price > max_profit:
                max_profit = price - min_price
                
        return max_profit

# Complexity: Time O(N) | Space O(1)
```

---

### 122. Best Time to Buy and Sell Stock II
**The Problem**: Similar to 121, but you can buy and sell multiple times.

*   **What moves us toward the answer**: Local gradients. Since we can transact infinitely, we want to capture *every single upward movement* in the stock price. 
*   **Intuition**: In data science, if we want the sum of all positive deltas in a time series, we just look at `current - previous`. If it's positive, we add it to our profit. We never hold a stock through a downward trend.

```python
class Solution:
    def maxProfit(self, prices: List[int]) -> int:
        total_profit = 0
        
        # Iterate starting from day 1 (second day)
        for i in range(1, len(prices)):
            # If the gradient is positive, "buy" yesterday and "sell" today
            if prices[i] > prices[i-1]:
                total_profit += prices[i] - prices[i-1]
                
        return total_profit

# Complexity: Time O(N) | Space O(1)
```

---

### 134. Gas Station
**The Problem**: Circular route of gas stations. Find the starting index to complete the circuit.

*   **What moves us toward the answer**: Prefix sums / Cumulative differences. 
*   **Intuition**: First, if the total gas available is less than total cost, it's mathematically impossible (return `-1`). If it *is* possible, a valid starting point must exist. We simulate the journey. If at any point our tank goes negative, it means *no station* from our starting point up to this current point can be a valid start. We immediately reset our starting point to the *next* station and reset our tank to 0.

```python
class Solution:
    def canCompleteCircuit(self, gas: List[int], cost: List[int]) -> int:
        # Quick mathematical check
        if sum(gas) < sum(cost):
            return -1
            
        current_tank = 0
        start_station = 0
        
        for i in range(len(gas)):
            current_tank += gas[i] - cost[i]
            
            # If we bottom out, reset start position to the next index
            if current_tank < 0:
                start_station = i + 1
                current_tank = 0
                
        return start_station

# Complexity: Time O(N) | Space O(1)
```

---

### 2202. Maximize the Topmost Element After K Moves
**The Problem**: Find the max element at the top of an array (stack) after exactly $K$ operations (popping or pushing back).

*   **What moves us toward the answer**: Extreme edge-case analysis.
*   **Intuition**: 
    1. If `N=1` and `K` is odd, we are forced to pop it, can't push it back -> empty -> return `-1`.
    2. We can examine elements up to index `K-1`. Why? We can pop `K-1` times and push the max of those back on the `K`th move.
    3. Alternatively, we can pop exactly `K` times, exposing the element at index `K`. 
    4. Note: We *cannot* leave the element at index `K-1` on top because doing `K-1` pops leaves it there, but we *must* make one more move (which ruins it).

```python
class Solution:
    def maximumTop(self, nums: List[int], k: int) -> int:
        n = len(nums)
        
        # Edge case: single element and odd moves forces an empty array
        if n == 1 and k % 2 == 1:
            return -1
            
        # If k > n, we can pop everything and just push the absolute max back
        if k > n:
            return max(nums)
            
        # We can put back the max of the first k-1 elements
        max_popped = max(nums[:k-1]) if k > 1 else -1
        
        # Or we pop k elements and expose the element at index k
        element_at_k = nums[k] if k < n else -1
        
        return max(max_popped, element_at_k)

# Complexity: Time O(min(N, K)) | Space O(1) (ignoring slicing overhead, which can be optimized)
```

---

### 621. Task Scheduler
**The Problem**: Execute tasks with a cooldown `n` for identical tasks. Find minimum CPU intervals.

*   **What moves us toward the answer**: Frequency counting and bounding logic.
*   **Intuition**: The most frequent task acts as a bottleneck. Suppose task `A` appears 3 times, `n=2`. The skeletal structure is `A _ _ A _ _ A`. The number of idle slots is determined by the max frequency. We calculate the mathematical bound of this skeleton. If we have so many other tasks that the idles are filled and we need to expand, the answer is just the length of all tasks!

```python
from collections import Counter

class Solution:
    def leastInterval(self, tasks: List[str], n: int) -> int:
        # Count frequencies of tasks
        counts = list(Counter(tasks).values())
        max_freq = max(counts)
        
        # How many tasks share this maximum frequency?
        max_freq_count = counts.count(max_freq)
        
        # Formula: (max_freq - 1) * (cooldown + 1) + tasks_with_max_freq
        # Think of it as constructing blocks of size (n+1)
        skeleton_length = (max_freq - 1) * (n + 1) + max_freq_count
        
        # If the skeleton is smaller than the total tasks, 
        # it means we had enough tasks to naturally space out everything without idles.
        return max(skeleton_length, len(tasks))

# Complexity: Time O(N) | Space O(1) (since only 26 uppercase English letters)
```

---

### 767. Reorganize String
**The Problem**: Rearrange characters so no two adjacent characters are the same.

*   **What moves us toward the answer**: A Max-Heap (Priority Queue) to always place the most frequent available character next.
*   **Intuition**: If any char's frequency is `> (length + 1) / 2`, it's impossible. Otherwise, we greedily pick the highest frequency character. To prevent picking it twice in a row, we "waitlist" it in a temporary variable until the *next* character is placed.

```python
import heapq
from collections import Counter

class Solution:
    def reorganizeString(self, s: str) -> str:
        freq = Counter(s)
        # Python's heapq is a min-heap, so we use negative frequencies
        max_heap = [[-count, char] for char, count in freq.items()]
        heapq.heapify(max_heap)
        
        prev = None
        res = []
        
        while max_heap or prev:
            # If heap is empty but we have a waitlisted char, it's impossible
            if prev and not max_heap:
                return ""
                
            # Pop the most frequent character
            count, char = heapq.heappop(max_heap)
            res.append(char)
            count += 1 # decrease frequency (closer to 0)
            
            # If we had a previous character waitlisted, push it back to the heap
            if prev:
                heapq.heappush(max_heap, prev)
                prev = None
                
            # If the current character still has remaining count, waitlist it
            if count != 0:
                prev = [count, char]
                
        return "".join(res)

# Complexity: Time O(N log K) where K is unique chars (K<=26, so O(N)) | Space O(K)
```

---

### 1054. Distant Barcodes
**The Problem**: Same as 767, but with an array of integers instead of strings. A solution is guaranteed to exist.

*   **What moves us toward the answer**: Sorting by frequency and striding through the array.
*   **Intuition**: While a heap works, since a solution is *guaranteed*, there is a faster, very data-science-friendly array manipulation approach. We sort elements by frequency. We fill all the **even indices** (0, 2, 4...) first, and then wrap around to fill the **odd indices** (1, 3, 5...). Because no element appears more than half the time, identical elements will never touch.

```python
class Solution:
    def rearrangeBarcodes(self, barcodes: List[int]) -> List[int]:
        # Count and sort by frequency descending
        count = Counter(barcodes)
        # Sort elements based on frequency (most frequent first)
        sorted_barcodes = sorted(barcodes, key=lambda x: (-count[x], x))
        
        res = [0] * len(barcodes)
        
        # Fill even indices
        res[0::2] = sorted_barcodes[:len(res[0::2])]
        # Fill odd indices
        res[1::2] = sorted_barcodes[len(res[0::2]):]
        
        return res

# Complexity: Time O(N log N) for sorting | Space O(N)
```

---

### 455. Assign Cookies
**The Problem**: Maximize number of children fed. Child $i$ needs cookie size $\ge g[i]$.

*   **What moves us toward the answer**: Sorting and Two Pointers.
*   **Intuition**: This is a classic greedy matching problem. We want to feed the least greedy children first, using the smallest possible cookies that satisfy them. We sort both the children's greed arrays and the cookie sizes, then use two pointers to match them up.

```python
class Solution:
    def findContentChildren(self, g: List[int], s: List[int]) -> int:
        g.sort() # Children's greed factor
        s.sort() # Cookie sizes
        
        child_ptr = 0
        cookie_ptr = 0
        
        # Traverse while we have children and cookies to consider
        while child_ptr < len(g) and cookie_ptr < len(s):
            if s[cookie_ptr] >= g[child_ptr]:
                # Cookie satisfies the child, move child pointer
                child_ptr += 1
            # Regardless, move to the next cookie (if it didn't fit, it's too small)
            cookie_ptr += 1
            
        return child_ptr # Number of satisfied children

# Complexity: Time O(N log N + M log M) | Space O(1) or O(N) depending on sorting algo
```

---

### 135. Candy
**The Problem**: Distribute candies so every child gets at least 1. Children with a higher rating than adjacent children get more candies. Find minimum candies.

*   **What moves us toward the answer**: Bi-directional array scanning (Forward fill, Backward fill).
*   **Intuition**: We can break the "adjacent" rule into two simpler rules: 
    1. Right child > Left child. 
    2. Left child > Right child. 
    We initialize an array of `1`s. We sweep left-to-right to fix rule 1. Then we sweep right-to-left, updating only if rule 2 is broken *and* the left child doesn't already have more candy. 

```python
class Solution:
    def candy(self, ratings: List[int]) -> int:
        n = len(ratings)
        candies = [1] * n
        
        # Forward pass: ensure higher rating child on the right gets more than left
        for i in range(1, n):
            if ratings[i] > ratings[i-1]:
                candies[i] = candies[i-1] + 1
                
        # Backward pass: ensure higher rating child on the left gets more than right
        for i in range(n-2, -1, -1):
            if ratings[i] > ratings[i+1]:
                # max() ensures we don't break the forward pass logic
                candies[i] = max(candies[i], candies[i+1] + 1)
                
        return sum(candies)

# Complexity: Time O(N) (two passes) | Space O(N)
```

---

### 406. Queue Reconstruction by Height
**The Problem**: Reconstruct a queue where each person is `[h, k]`. `h` is height, `k` is the number of people in front who have a height $\ge h$.

*   **What moves us toward the answer**: Sorting with a custom dual-key (descending by height, ascending by `k`), followed by dynamic insertion.
*   **Intuition**: Taller people are completely "blind" to shorter people. If we place the tallest people first, their `k` values map perfectly to their required array index! When we subsequently insert shorter people into the list, they simply push taller people back, which is fine because shorter people don't affect the `k` condition of taller people.

```python
class Solution:
    def reconstructQueue(self, people: List[List[int]]) -> List[List[int]]:
        # Sort: Height descending (-x[0]), K ascending (x[1])
        # Example: [7,0], [7,1], [6,1], [5,0], [5,2], [4,4]
        people.sort(key=lambda x: (-x[0], x[1]))
        
        queue = []
        for person in people:
            # person[1] is the exact index they belong in the current array
            queue.insert(person[1], person)
            
        return queue

# Complexity: Time O(N^2) due to list.insert() inside loop | Space O(N)
```