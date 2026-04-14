

### Everything you need to know to hit the ground running

> **Coming from C++?** Python will feel magical for DSA — less boilerplate, built-in data structures, and one-liners that replace 10 lines of C++. The tradeoff is slower raw speed, but on LeetCode/OA platforms that never matters at your level.

---

## Part 1 — The C++ → Python Mental Shift

The single biggest thing to unlearn: **stop thinking in types and memory**. Python handles all of that.

| C++ habit                     | Python equivalent                           |
| ----------------------------- | ------------------------------------------- |
| `vector<int> v;`              | `v = []`                                    |
| `unordered_map<int,int> m;`   | `m = {}` or `m = dict()`                    |
| `unordered_set<int> s;`       | `s = set()`                                 |
| `priority_queue<int> pq;`     | `import heapq` then `heapq.heappush(pq, x)` |
| `INT_MAX / INT_MIN`           | `float('inf')` / `float('-inf')`            |
| `v.push_back(x)`              | `v.append(x)`                               |
| `v.size()`                    | `len(v)`                                    |
| `sort(v.begin(), v.end())`    | `v.sort()` or `sorted(v)`                   |
| `auto [a, b] = pair;`         | `a, b = pair` (tuple unpacking)             |
| `for (int i = 0; i < n; i++)` | `for i in range(n):`                        |
| `nullptr`                     | `None`                                      |
| `true / false`                | `True / False`                              |
| No built-in swap              | `a, b = b, a`                               |

---

## Part 2 — Core Data Structures and Their Python Forms

---

### 2.1 Lists (your go-to array)

```python
# Creation
nums = [1, 2, 3, 4, 5]
zeros = [0] * n              # C++: vector<int>(n, 0)
matrix = [[0]*cols for _ in range(rows)]  # 2D array — NEVER use [[0]*cols]*rows

# Slicing — Python's superpower
nums[1:4]       # elements at index 1,2,3
nums[::-1]      # reversed copy
nums[::2]       # every other element
nums[-1]        # last element (no need for nums[n-1])
nums[-2:]       # last two elements

# Common operations
nums.append(x)          # add to end — O(1)
nums.pop()              # remove from end — O(1)
nums.pop(0)             # remove from front — O(N) ← slow, use deque instead
nums.insert(i, x)       # insert at index — O(N)
nums.remove(x)          # remove first occurrence of x — O(N)
x in nums               # membership check — O(N) ← use set for O(1)
nums.index(x)           # first index of x
nums.count(x)           # count occurrences of x
nums.reverse()          # in-place reverse
nums.sort()             # in-place sort
sorted(nums)            # returns new sorted list, original unchanged

# List comprehensions — replace most C++ for-loops that build arrays
squares = [x**2 for x in range(10)]
evens   = [x for x in nums if x % 2 == 0]
flat    = [x for row in matrix for x in row]  # flatten 2D to 1D
```

**The 2D array trap — never do this:**

```python
# WRONG — all rows share the same object
bad_matrix = [[0] * cols] * rows
bad_matrix[0][0] = 1   # changes ALL rows!

# CORRECT — each row is independent
good_matrix = [[0] * cols for _ in range(rows)]
```

---

### 2.2 Strings

```python
s = "hello world"

# Strings are immutable in Python — you cannot do s[0] = 'H'
# Convert to list, modify, then join back
chars = list(s)
chars[0] = 'H'
s = ''.join(chars)

# Common string operations
s.upper()             # "HELLO WORLD"
s.lower()             # "hello world"
s.strip()             # remove leading/trailing whitespace
s.split()             # split on whitespace → ['hello', 'world']
s.split(',')          # split on comma
' '.join(['a','b'])   # join list into string → "a b"
s.replace('l', 'r')   # replace all occurrences
s.startswith('he')    # True
s.endswith('ld')      # True
s.find('lo')          # index of first occurrence, -1 if not found
s.count('l')          # count occurrences
s[::-1]               # reverse a string

# Check character type
c.isalpha()   # is letter?
c.isdigit()   # is digit?
c.isalnum()   # is letter or digit?
c.islower()   # is lowercase?
c.isupper()   # is uppercase?

# Character to ASCII and back
ord('a')      # → 97
chr(97)       # → 'a'
ord(c) - ord('a')   # letter index (a=0, b=1, ..., z=25)

# String formatting (useful for debug output)
f"value is {x}, index is {i}"    # f-string — fastest

# Multiline string building — use list + join, not += in a loop
# BAD (O(N²)):  result = ""; for c in chars: result += c
# GOOD (O(N)):  result = ''.join(chars)
```

---

### 2.3 HashMap — `dict`

```python
# Creation
d = {}
d = dict()
d = {'a': 1, 'b': 2}

# Access
d['a']              # KeyError if missing
d.get('a', 0)       # returns 0 if key missing — use this in DSA
d.get('a')          # returns None if missing

# Modify
d['a'] = 1          # set
d['a'] += 1         # increment (KeyError if 'a' not in d — use defaultdict or get)
del d['a']          # delete key
d.pop('a', None)    # delete and return, no error if missing

# Check
'a' in d            # O(1) membership check
'd' not in d

# Iterate
for key in d:               # iterate keys
for key, val in d.items():  # iterate key-value pairs
for val in d.values():      # iterate values

# Most useful DSA tricks
from collections import defaultdict

# defaultdict — never worry about missing keys
freq = defaultdict(int)
for c in s:
    freq[c] += 1            # no KeyError, defaults to 0

graph = defaultdict(list)
graph[u].append(v)          # no KeyError, defaults to []

# Counter — frequency map in one line
from collections import Counter
freq = Counter(s)           # Counter({'l': 3, 'o': 2, ...})
freq = Counter(nums)
freq.most_common(3)         # top 3 most frequent elements
freq['x']                   # returns 0 if 'x' not in counter (no KeyError)

# Dict comprehension
freq = {c: s.count(c) for c in set(s)}
squared = {x: x**2 for x in range(5)}
```

---

### 2.4 HashSet — `set`

```python
# Creation
s = set()
s = {1, 2, 3}
s = set(nums)       # convert list to set — removes duplicates

# Operations — all O(1) average
s.add(x)
s.remove(x)         # KeyError if not present
s.discard(x)        # no error if not present — use this in DSA
x in s              # O(1) membership — this is why you use sets
len(s)

# Set operations (very useful)
a | b               # union
a & b               # intersection
a - b               # difference (elements in a but not b)
a ^ b               # symmetric difference (in a or b but not both)
a.issubset(b)       # a ⊆ b
a.issuperset(b)     # a ⊇ b

# Common DSA patterns
seen = set()
for x in nums:
    if x in seen:
        return True     # duplicate found
    seen.add(x)

# Remove duplicates while preserving order
seen = set()
result = [x for x in nums if not (x in seen or seen.add(x))]
```

---

### 2.5 Stack

Python lists work perfectly as stacks:

```python
stack = []

stack.append(x)     # push — O(1)
stack.pop()         # pop — O(1), raises IndexError if empty
stack[-1]           # peek top — O(1)
if stack:           # check non-empty
len(stack) == 0     # check empty

# Classic stack pattern — valid parentheses
def isValid(s):
    stack = []
    mapping = {')': '(', '}': '{', ']': '['}
    for c in s:
        if c in mapping:
            top = stack.pop() if stack else '#'
            if mapping[c] != top:
                return False
        else:
            stack.append(c)
    return not stack
```

---

### 2.6 Queue and Deque

```python
from collections import deque

# Use deque for any queue — not list (list.pop(0) is O(N))
q = deque()
q.append(x)         # enqueue right — O(1)
q.appendleft(x)     # enqueue left — O(1)
q.pop()             # dequeue right — O(1)
q.popleft()         # dequeue left — O(1)  ← BFS uses this
q[0]                # peek front
q[-1]               # peek back
len(q)
if q:               # non-empty check

# BFS template with deque
from collections import deque

def bfs(root):
    if not root:
        return []
    q = deque([root])
    result = []
    while q:
        node = q.popleft()
        result.append(node.val)
        if node.left:  q.append(node.left)
        if node.right: q.append(node.right)
    return result

# Deque as sliding window — O(1) from both ends
window = deque()
window.append(i)            # add to right
window.popleft()            # remove from left (expired window)
while window and nums[window[-1]] < nums[i]:
    window.pop()            # remove smaller elements from right
```

---

### 2.7 Heap (Priority Queue)

Python only has a min-heap. For max-heap, negate the values.

```python
import heapq

# Min-heap
heap = []
heapq.heappush(heap, x)     # push — O(log N)
heapq.heappop(heap)         # pop min — O(log N)
heap[0]                     # peek min — O(1), does NOT remove
heapq.heapify(lst)          # convert list to heap in-place — O(N)

# Max-heap trick — negate values
heapq.heappush(heap, -x)    # push negative
-heapq.heappop(heap)        # pop and negate back

# Heap with tuples — sorted by first element
heapq.heappush(heap, (priority, value))
heapq.heappush(heap, (distance, node))   # Dijkstra

# Top K elements
k_largest = heapq.nlargest(k, nums)      # O(N log K)
k_smallest = heapq.nsmallest(k, nums)   # O(N log K)

# Maintain a min-heap of size K (for top-K largest)
heap = []
for x in nums:
    heapq.heappush(heap, x)
    if len(heap) > k:
        heapq.heappop(heap)     # evict smallest, keeping K largest
# heap now contains the K largest elements

# Kth largest element
return heap[0]   # smallest of the K largest = Kth largest overall
```

---

### 2.8 Sorting

```python
# In-place sort (modifies original)
nums.sort()
nums.sort(reverse=True)

# Returns new sorted list (original unchanged)
sorted(nums)
sorted(nums, reverse=True)

# Custom sort key
nums.sort(key=lambda x: -x)            # sort descending
intervals.sort(key=lambda x: x[0])     # sort by first element
words.sort(key=lambda w: len(w))       # sort by length
words.sort(key=lambda w: (len(w), w))  # sort by length, then alphabetically

# Sort strings by frequency
freq = Counter(s)
chars = sorted(freq.keys(), key=lambda c: -freq[c])

# Stable sort — Python sort is always stable (preserves original order of equal elements)

# Useful: sort and get original indices
indexed = sorted(enumerate(nums), key=lambda x: x[1])
# [(original_index, value), ...]
```

---

## Part 3 — Python-Specific DSA Hacks

---

### 3.1 Two Pointers

```python
# Converging pointers
left, right = 0, len(nums) - 1
while left < right:
    # process nums[left] and nums[right]
    left += 1
    right -= 1

# Fast/slow pointers (linked list)
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next

# Write pointer (in-place modification)
write = 0
for read in range(len(nums)):
    if nums[read] != 0:
        nums[write] = nums[read]
        write += 1
```

---

### 3.2 Sliding Window

```python
# Fixed window
window_sum = sum(nums[:k])
max_sum = window_sum
for i in range(k, len(nums)):
    window_sum += nums[i] - nums[i - k]
    max_sum = max(max_sum, window_sum)

# Variable window — expand right, shrink left
left = 0
window = {}   # or Counter()
for right in range(len(s)):
    # expand: add s[right] to window
    window[s[right]] = window.get(s[right], 0) + 1

    while <window is invalid>:
        # shrink: remove s[left] from window
        window[s[left]] -= 1
        if window[s[left]] == 0:
            del window[s[left]]
        left += 1

    # record answer for current window [left, right]
    ans = max(ans, right - left + 1)
```

---

### 3.3 Binary Search

```python
# Classic template — never get the boundary wrong again
def binary_search(nums, target):
    left, right = 0, len(nums) - 1
    while left <= right:
        mid = (left + right) // 2      # no overflow in Python (unlimited int)
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

# Python has bisect — use it!
import bisect

bisect.bisect_left(nums, x)    # leftmost position to insert x (first index >= x)
bisect.bisect_right(nums, x)   # rightmost position to insert x (first index > x)
bisect.insort(nums, x)         # insert x in sorted order

# Binary search on answer space
def feasible(mid):
    # check if mid is a valid answer
    ...

left, right = min_possible, max_possible
while left < right:
    mid = (left + right) // 2
    if feasible(mid):
        right = mid         # try smaller
    else:
        left = mid + 1      # need larger
return left
```

---

### 3.4 Prefix Sums

```python
# Build prefix sum array
prefix = [0] * (len(nums) + 1)
for i, x in enumerate(nums):
    prefix[i+1] = prefix[i] + x

# Range sum query [l, r] in O(1)
range_sum = prefix[r+1] - prefix[l]

# One-liner using itertools
from itertools import accumulate
prefix = list(accumulate(nums, initial=0))   # [0, nums[0], nums[0]+nums[1], ...]

# Subarray sum equals K — prefix sum + HashMap
def subarraySum(nums, k):
    count = 0
    curr_sum = 0
    seen = defaultdict(int)
    seen[0] = 1
    for x in nums:
        curr_sum += x
        count += seen[curr_sum - k]
        seen[curr_sum] += 1
    return count
```

---

### 3.5 Trees

```python
# Standard TreeNode (LeetCode definition)
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

# DFS — recursive (most common)
def dfs(node):
    if not node:           # base case — cleaner than C++ nullptr check
        return
    # preorder: process node here
    dfs(node.left)
    # inorder: process node here
    dfs(node.right)
    # postorder: process node here

# DFS returning a value (e.g. height)
def height(node):
    if not node:
        return 0
    return 1 + max(height(node.left), height(node.right))

# DFS with a global variable
self.ans = 0
def dfs(node):
    if not node:
        return 0
    left = dfs(node.left)
    right = dfs(node.right)
    self.ans = max(self.ans, left + right)   # update global answer
    return 1 + max(left, right)              # return value for parent

# BFS level order
from collections import deque
def levelOrder(root):
    if not root: return []
    q = deque([root])
    result = []
    while q:
        level = []
        for _ in range(len(q)):          # process exactly one level
            node = q.popleft()
            level.append(node.val)
            if node.left:  q.append(node.left)
            if node.right: q.append(node.right)
        result.append(level)
    return result
```

---

### 3.6 Graphs

```python
# Build adjacency list
from collections import defaultdict
graph = defaultdict(list)
for u, v in edges:
    graph[u].append(v)
    graph[v].append(u)   # undirected

# DFS — iterative (avoids recursion limit)
def dfs(start):
    visited = set()
    stack = [start]
    while stack:
        node = stack.pop()
        if node in visited:
            continue
        visited.add(node)
        for neighbor in graph[node]:
            if neighbor not in visited:
                stack.append(neighbor)

# DFS — recursive
def dfs(node, visited):
    visited.add(node)
    for neighbor in graph[node]:
        if neighbor not in visited:
            dfs(neighbor, visited)

# BFS — shortest path
from collections import deque
def bfs(start, end):
    visited = {start}
    q = deque([(start, 0)])     # (node, distance)
    while q:
        node, dist = q.popleft()
        if node == end:
            return dist
        for neighbor in graph[node]:
            if neighbor not in visited:
                visited.add(neighbor)
                q.append((neighbor, dist + 1))
    return -1

# Grid DFS/BFS — 4-directional
directions = [(0,1),(0,-1),(1,0),(-1,0)]
def valid(r, c):
    return 0 <= r < rows and 0 <= c < cols

def dfs(r, c):
    if not valid(r, c) or grid[r][c] != '1':
        return
    grid[r][c] = '0'            # mark visited in-place
    for dr, dc in directions:
        dfs(r+dr, c+dc)

# Topological sort — Kahn's algorithm
from collections import deque
def topoSort(n, edges):
    in_degree = [0] * n
    graph = defaultdict(list)
    for u, v in edges:
        graph[u].append(v)
        in_degree[v] += 1
    q = deque([i for i in range(n) if in_degree[i] == 0])
    order = []
    while q:
        node = q.popleft()
        order.append(node)
        for neighbor in graph[node]:
            in_degree[neighbor] -= 1
            if in_degree[neighbor] == 0:
                q.append(neighbor)
    return order if len(order) == n else []   # [] means cycle exists

# Union-Find (DSU)
class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])  # path compression
        return self.parent[x]

    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px == py: return False
        if self.rank[px] < self.rank[py]: px, py = py, px
        self.parent[py] = px
        if self.rank[px] == self.rank[py]: self.rank[px] += 1
        return True
```

---

### 3.7 Dynamic Programming

```python
# 1D DP — bottom-up
dp = [0] * (n + 1)
dp[0] = base_case
for i in range(1, n + 1):
    dp[i] = # recurrence using dp[i-1], dp[i-2], etc.

# Space-optimized 1D DP (Fibonacci-style)
prev2, prev1 = 0, 1
for i in range(2, n + 1):
    curr = prev1 + prev2
    prev2, prev1 = prev1, curr

# 2D DP
dp = [[0] * (n + 1) for _ in range(m + 1)]
for i in range(1, m + 1):
    for j in range(1, n + 1):
        if s1[i-1] == s2[j-1]:
            dp[i][j] = 1 + dp[i-1][j-1]
        else:
            dp[i][j] = max(dp[i-1][j], dp[i][j-1])

# Memoization with @cache (Python 3.9+) — cleanest top-down DP
from functools import cache

@cache
def dp(i, j):
    if base_case: return ...
    return min(dp(i-1, j), dp(i, j-1)) + cost[i][j]

# Or use lru_cache
from functools import lru_cache

@lru_cache(maxsize=None)
def dp(i, remaining):
    if remaining == 0: return 0
    if i >= len(coins): return float('inf')
    # ...

# 0/1 Knapsack — iterate backwards
dp = [False] * (target + 1)
dp[0] = True
for num in nums:
    for j in range(target, num - 1, -1):    # backwards = no reuse
        dp[j] = dp[j] or dp[j - num]

# Unbounded Knapsack — iterate forwards
dp = [float('inf')] * (amount + 1)
dp[0] = 0
for coin in coins:
    for j in range(coin, amount + 1):       # forwards = reuse allowed
        dp[j] = min(dp[j], 1 + dp[j - coin])
```

---

### 3.8 Backtracking

```python
# General template
def backtrack(start, path):
    if <base_case>:
        result.append(path[:])    # append a COPY — important!
        return
    for i in range(start, len(nums)):
        if <pruning condition>:
            continue
        path.append(nums[i])      # choose
        backtrack(i + 1, path)    # explore (i+1 = no reuse, i = reuse)
        path.pop()                # un-choose

result = []
backtrack(0, [])

# Subsets
def subsets(nums):
    result = []
    def bt(start, path):
        result.append(path[:])
        for i in range(start, len(nums)):
            bt(i + 1, path + [nums[i]])
    bt(0, [])
    return result

# Permutations
def permute(nums):
    result = []
    def bt(path, used):
        if len(path) == len(nums):
            result.append(path[:])
            return
        for i in range(len(nums)):
            if used[i]: continue
            used[i] = True
            path.append(nums[i])
            bt(path, used)
            path.pop()
            used[i] = False
    bt([], [False]*len(nums))
    return result

# Skip duplicates pattern (for Subsets II, Permutations II)
nums.sort()
for i in range(start, len(nums)):
    if i > start and nums[i] == nums[i-1]:   # skip duplicate at same level
        continue
```

---

### 3.9 Linked Lists

```python
# Standard ListNode (LeetCode)
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next

# Reverse linked list
def reverse(head):
    prev, curr = None, head
    while curr:
        nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt
    return prev

# Dummy node pattern
dummy = ListNode(0)
dummy.next = head
curr = dummy
# ... manipulate list ...
return dummy.next

# Find middle (slow/fast)
slow = fast = head
while fast and fast.next:
    slow = slow.next
    fast = fast.next.next
# slow is now at the middle
```

---

## Part 4 — Python One-Liners That Replace C++ Boilerplate

```python
# Swap two variables — no temp variable
a, b = b, a

# Multiple assignment
x = y = z = 0

# Unpack into variables
first, *rest = [1, 2, 3, 4]    # first=1, rest=[2,3,4]
*init, last  = [1, 2, 3, 4]    # init=[1,2,3], last=4
a, b, *_ = [1, 2, 3, 4, 5]     # a=1, b=2, rest ignored

# Conditional expression (ternary)
val = x if condition else y

# Chained comparison (unique to Python)
1 <= x <= 10        # instead of x >= 1 and x <= 10
if 0 < row < rows and 0 < col < cols:   # bounds check in one line

# Max/min with default
max(a, b, c)
min(nums, default=0)
max(nums, key=lambda x: abs(x))   # max by absolute value

# Sum, any, all
total = sum(nums)
sum(x**2 for x in nums)           # generator — memory efficient
any(x > 0 for x in nums)          # True if any element is positive
all(x > 0 for x in nums)          # True if all elements are positive

# Enumerate — iterate with index (replaces for i in range(len()))
for i, val in enumerate(nums):
    print(i, val)

for i, val in enumerate(nums, start=1):   # start index at 1
    print(i, val)

# Zip — iterate two lists together
for a, b in zip(list1, list2):
    print(a, b)

# Zip longest
from itertools import zip_longest
for a, b in zip_longest(list1, list2, fillvalue=0):
    print(a, b)

# Reverse range
for i in range(n-1, -1, -1):       # n-1 down to 0
    ...

# Dictionary from two lists
d = dict(zip(keys, values))

# Flatten a list of lists
flat = [x for sublist in matrix for x in sublist]
# or
from itertools import chain
flat = list(chain.from_iterable(matrix))

# Count elements matching a condition
count = sum(1 for x in nums if x > 0)
count = sum(x > 0 for x in nums)   # True counts as 1

# Find index of max/min
max_idx = nums.index(max(nums))
min_idx = nums.index(min(nums))

# Remove duplicates preserving order
seen = set()
unique = [x for x in nums if not (x in seen or seen.add(x))]

# Transpose a matrix
transposed = list(map(list, zip(*matrix)))

# Rotate matrix 90° clockwise
rotated = list(zip(*matrix[::-1]))
```

---

## Part 5 — The `collections` Module (Your Best Friend)

```python
from collections import Counter, defaultdict, deque, OrderedDict

# Counter — frequency map
freq = Counter("abracadabra")   # Counter({'a': 5, 'b': 2, 'r': 2, 'c': 1, 'd': 1})
freq = Counter([1, 2, 2, 3, 3, 3])

freq.most_common(2)     # [('a', 5), ('b', 2)]
freq['z']               # 0 (no KeyError)
freq['a'] -= 1          # decrement
+freq                   # remove zero/negative counts

# Counter arithmetic
c1 = Counter("abc")
c2 = Counter("aab")
c1 + c2     # combine counts
c1 - c2     # subtract (drops zero/negative)
c1 & c2     # intersection (min of each)
c1 | c2     # union (max of each)

# Check if t is an anagram of s
Counter(s) == Counter(t)

# defaultdict — never check if key exists
graph = defaultdict(list)
graph[u].append(v)          # works even if u not in graph

freq = defaultdict(int)
freq[c] += 1                # works even if c not in freq

nested = defaultdict(lambda: defaultdict(int))   # nested defaultdict

# deque — use for all queues and sliding windows
from collections import deque
dq = deque([1, 2, 3])
dq.appendleft(0)    # O(1) left insert
dq.popleft()        # O(1) left remove
dq.append(4)        # O(1) right insert
dq.pop()            # O(1) right remove
dq.rotate(1)        # rotate right by 1
dq.rotate(-1)       # rotate left by 1

# OrderedDict — dict that remembers insertion order (useful for LRU Cache)
from collections import OrderedDict
cache = OrderedDict()
cache.move_to_end(key)          # move to end (most recently used)
cache.move_to_end(key, last=False)  # move to front (least recently used)
cache.popitem(last=False)       # remove from front (LRU eviction)
```

---

## Part 6 — The `heapq` Module (Priority Queue Patterns)

```python
import heapq

# Min-heap operations
heap = []
heapq.heappush(heap, val)
val = heapq.heappop(heap)       # removes and returns min
val = heap[0]                   # peek without removing
heapq.heapify(lst)              # O(N) in-place

# Max-heap — negate values
heapq.heappush(heap, -val)
val = -heapq.heappop(heap)

# Heap of tuples — compares by first element
heapq.heappush(heap, (dist, node))     # Dijkstra
heapq.heappush(heap, (freq, char))     # task scheduler

# If first elements are equal, Python compares second — can cause issues
# Fix: use a counter as tiebreaker
counter = 0
heapq.heappush(heap, (priority, counter, item))
counter += 1

# Merge K sorted lists — classic pattern
def mergeKLists(lists):
    heap = []
    for i, node in enumerate(lists):
        if node:
            heapq.heappush(heap, (node.val, i, node))
    dummy = ListNode(0)
    curr = dummy
    while heap:
        val, i, node = heapq.heappop(heap)
        curr.next = node
        curr = curr.next
        if node.next:
            heapq.heappush(heap, (node.next.val, i, node.next))
    return dummy.next

# Two heaps for median
import heapq
lower = []   # max-heap (negate)
upper = []   # min-heap

def addNum(num):
    heapq.heappush(lower, -num)
    heapq.heappush(upper, -heapq.heappop(lower))
    if len(upper) > len(lower):
        heapq.heappush(lower, -heapq.heappop(upper))

def findMedian():
    if len(lower) > len(upper):
        return -lower[0]
    return (-lower[0] + upper[0]) / 2
```

---

## Part 7 — Important Python Gotchas (C++ habits that break things)

---

### 7.1 Integer overflow does not exist

```python
# Python integers are unlimited size — no overflow ever
# No need for long long, no need for modulo tricks for intermediate values
# But LeetCode problems still ask for result % (10**9 + 7)
MOD = 10**9 + 7
result = (a * b) % MOD
```

---

### 7.2 Division behaves differently

```python
7 // 2      # 3   — integer division (floor)
7 / 2       # 3.5 — always float division
-7 // 2     # -4  — floors towards negative infinity (unlike C++ which truncates to 0!)

# Safe integer division (truncation like C++)
int(-7 / 2)     # -3   ← use this if you want C++ behaviour
```

---

### 7.3 Recursion limit

```python
# Python default recursion limit is 1000 — will hit RecursionError on deep trees
import sys
sys.setrecursionlimit(10**5)    # put this at the top of your solution

# Or better — use iterative DFS with explicit stack for deep recursion
```

---

### 7.4 Mutable default arguments are a trap

```python
# WRONG — list is shared across all calls
def bt(path=[]):
    path.append(1)   # modifies the shared default!

# CORRECT
def bt(path=None):
    if path is None: path = []
```

---

### 7.5 Copying lists and nested structures

```python
# Shallow copy — new list, same objects inside
copy1 = nums[:]
copy2 = list(nums)
copy3 = nums.copy()

# Deep copy — for nested structures (2D arrays, etc.)
import copy
deep = copy.deepcopy(matrix)

# In backtracking, always append a copy of the path
result.append(path[:])         # list
result.append(tuple(path))     # tuple (immutable, slightly faster)
```

---

### 7.6 `is` vs `==`

```python
# == compares value
# is  compares identity (same object in memory)

x == None   # works but not pythonic
x is None   # correct way to check for None

if not x:   # True if x is None, 0, [], {}, "", False — be careful!
if x is None:   # only True if x is exactly None
```

---

### 7.7 `and` / `or` short-circuit evaluation

```python
# Python and/or return one of the operands, not True/False
x = a or b      # returns a if a is truthy, else b
x = a and b     # returns a if a is falsy, else b

# Useful in DSA
node = node.left or node.right   # first non-None child
val = d.get(key) or default_val  # get value or default
```

---

## Part 8 — Speed Hacks for OA Platforms

```python
# Faster I/O for problems with large input (competitive programming)
import sys
input = sys.stdin.readline

# Use local variables in tight loops — faster than global
def solve():
    nums = [1, 2, 3]   # local — faster lookup than global

# List comprehension is faster than for-loop append
# SLOWER:
result = []
for x in nums:
    result.append(x * 2)
# FASTER:
result = [x * 2 for x in nums]

# Generator expressions save memory (don't build list in memory)
total = sum(x**2 for x in range(10**6))   # no list created

# Avoid repeated attribute lookup in tight loops
append = result.append   # cache method reference
for x in nums:
    append(x)            # faster than result.append(x) every iteration

# Use // for integer division, not int(x/y)
mid = (left + right) // 2   # faster than int((left+right)/2)

# String join is O(N), += is O(N²) — never build strings with +=
# SLOW: result = ""; for c in chars: result += c
# FAST: result = ''.join(chars)
```

---

## Part 9 — Quick Reference — Pattern to Python Template

|Pattern|What to import / use|
|---|---|
|Frequency count|`Counter(iterable)`|
|Default dict (graph, grouping)|`defaultdict(list)` or `defaultdict(int)`|
|Queue / BFS|`deque`, `.appendleft()`, `.popleft()`|
|Stack|plain `list`, `.append()`, `.pop()`|
|Min-heap|`heapq.heappush(h, x)`, `heapq.heappop(h)`|
|Max-heap|push `-x`, pop and negate|
|Sorted container|`import sortedcontainers` → `SortedList`|
|Memoized recursion|`@cache` or `@lru_cache(None)`|
|Prefix sums|`list(accumulate(nums, initial=0))`|
|Binary search|`bisect.bisect_left(nums, x)`|
|Infinity|`float('inf')`, `float('-inf')`|
|Character to index|`ord(c) - ord('a')`|
|All pairs|`from itertools import combinations, permutations`|
|Product of list|`from math import prod; prod(nums)`|
|GCD|`from math import gcd; gcd(a, b)`|
|Flatten list|`list(chain.from_iterable(matrix))`|
|Transpose matrix|`list(zip(*matrix))`|

---

## Part 10 — The `itertools` and `math` Modules

```python
from itertools import (
    combinations,       # C(n, r) — choose r items from n, no repetition, order doesn't matter
    permutations,       # P(n, r) — all orderings
    combinations_with_replacement,   # choose r with repetition
    product,            # cartesian product
    accumulate,         # prefix sums / running totals
    chain,              # flatten iterables
    groupby,            # group consecutive equal elements
    islice,             # slice an iterator
    repeat,             # repeat an element n times
)

# combinations
list(combinations([1,2,3], 2))   # [(1,2),(1,3),(2,3)]

# permutations
list(permutations([1,2,3]))      # all 6 orderings

# product — nested loop replacement
for i, j in product(range(3), range(3)):
    print(i, j)    # equivalent to two nested for loops

# accumulate — prefix sums
list(accumulate([1,2,3,4], initial=0))   # [0, 1, 3, 6, 10]

from math import (
    gcd,        # greatest common divisor
    lcm,        # least common multiple (Python 3.9+)
    floor,      # floor division
    ceil,       # ceiling division
    sqrt,       # square root
    log,        # logarithm
    inf,        # infinity (same as float('inf'))
    factorial,  # n!
    comb,       # C(n, r) — binomial coefficient
    perm,       # P(n, r) — permutations count
    isqrt,      # integer square root (floor of sqrt)
)

# Common uses
gcd(12, 8)          # 4
lcm(4, 6)           # 12
isqrt(17)           # 4  (floor of √17)
comb(10, 3)         # 120
```

---

## Appendix — C++ to Python Side-by-Side Cheatsheet

```
C++                                     Python
─────────────────────────────────────────────────────────────────
vector<int> v(n, 0)                     v = [0] * n
v.push_back(x)                          v.append(x)
v.pop_back()                            v.pop()
v.size()                                len(v)
v.empty()                               not v
v[i]                                    v[i]
v.front()                               v[0]
v.back()                                v[-1]
sort(v.begin(), v.end())                v.sort()
reverse(v.begin(), v.end())             v.reverse()
find(v.begin(), v.end(), x)             x in v (O(N))

unordered_map<int,int>                  dict() or {}
m[key]                                  d.get(key, default)
m.count(key)                            key in d
m.erase(key)                            del d[key] or d.pop(key, None)

unordered_set<int>                      set()
s.insert(x)                             s.add(x)
s.count(x)                              x in s
s.erase(x)                              s.discard(x)

priority_queue<int> pq                  heapq (min-heap by default)
pq.push(x)                              heapq.heappush(pq, x)
pq.top()                                pq[0]
pq.pop()                                heapq.heappop(pq)

INT_MAX                                 float('inf')
INT_MIN                                 float('-inf')

auto [a, b] = pair;                     a, b = pair
swap(a, b)                              a, b = b, a

cout << x << endl                       print(x)
cin >> x                                x = int(input())

nullptr                                 None
true / false                            True / False
```

---

_Welcome to Python. Once you stop missing semicolons, you'll never go back._