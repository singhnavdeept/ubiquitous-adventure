

#concept/practice 

# 🔢 Category 10: Advanced Strings & Tries

### 46. Longest Substring Without Repeating Characters

_Find the length of the longest substring without any repeating characters._

```cpp
#include <string>
#include <unordered_map>

using namespace std;

int lengthOfLongestSubstring(string s) {
    // --- Sliding Window with Hash Map (O(N) Time, O(min(N, Alphabet)) Space) ---

    // Map to store the most recent index of each character seen
    unordered_map<char, int> lastSeen;

    int maxLen = 0;
    int left = 0; // Left boundary of the window

    for (int right = 0; right < s.length(); ++right) {
        char c = s[right];

        // If the character was seen AND it's inside the current window,
        // shrink the window from the left past its previous occurrence.
        if (lastSeen.count(c) && lastSeen[c] >= left) {
            left = lastSeen[c] + 1;
        }

        lastSeen[c] = right; // Update last seen index

        maxLen = max(maxLen, right - left + 1); // Check current window length
    }

    return maxLen; // Time Complexity: O(N), Space Complexity: O(K) where K = charset size
}
```

---

### 47. Group Anagrams

_Group an array of strings into lists of anagrams._

```cpp
#include <vector>
#include <string>
#include <unordered_map>
#include <algorithm>

using namespace std;

vector<vector<string>> groupAnagrams(vector<string>& strs) {
    // --- Sort-as-Key HashMap (O(N * K log K) Time, O(N * K) Space) ---
    // N = number of strings, K = max length of a string

    unordered_map<string, vector<string>> groups;

    for (const string& s : strs) {
        string key = s;
        sort(key.begin(), key.end()); // Sorted string is a canonical key for all its anagrams

        groups[key].push_back(s); // Add original string to the correct group
    }

    vector<vector<string>> res;
    for (auto& pair : groups) {
        res.push_back(pair.second);
    }

    return res;
/*
*   Alternative Approaches:
*   1. Character Count Key (O(N * K) Time): Instead of sorting, use a frequency count
*      array of 26 chars as the key. Faster when K is large.
*/
}
```

---

### 48. Implement Trie (Prefix Tree)

_Implement insert, search, and startsWith operations._

```cpp
#include <string>
#include <array>

using namespace std;

class TrieNode {
public:
    array<TrieNode*, 26> children; // One slot for each lowercase letter
    bool isEndOfWord;

    TrieNode() : isEndOfWord(false) {
        children.fill(nullptr);
    }
};

class Trie {
private:
    TrieNode* root;

public:
    Trie() {
        root = new TrieNode();
    }

    // O(M) time where M is word length
    void insert(string word) {
        TrieNode* node = root;
        for (char c : word) {
            int idx = c - 'a';
            if (!node->children[idx]) {
                node->children[idx] = new TrieNode(); // Create node if missing
            }
            node = node->children[idx]; // Walk down to the next node
        }
        node->isEndOfWord = true; // Mark the terminal character
    }

    // O(M) — Returns true only if the whole word exists
    bool search(string word) {
        TrieNode* node = root;
        for (char c : word) {
            int idx = c - 'a';
            if (!node->children[idx]) return false;
            node = node->children[idx];
        }
        return node->isEndOfWord; // Must be a complete word, not just a prefix
    }

    // O(M) — Returns true if any word in the trie starts with the prefix
    bool startsWith(string prefix) {
        TrieNode* node = root;
        for (char c : prefix) {
            int idx = c - 'a';
            if (!node->children[idx]) return false;
            node = node->children[idx];
        }
        return true; // Path exists: prefix is valid
    }
};
```

---

### 49. Word Search II

_Given a board and a list of words, find all words in the board using a Trie._

```cpp
#include <vector>
#include <string>
#include <unordered_set>

using namespace std;

struct TrieNode {
    TrieNode* children[26] = {};
    string word = ""; // Non-empty signals a complete word at this node
};

class Solution {
private:
    void dfs(vector<vector<char>>& board, TrieNode* node, int r, int c, vector<string>& res) {
        // Out-of-bounds or already visited
        if (r < 0 || c < 0 || r >= board.size() || c >= board[0].size()) return;
        char ch = board[r][c];
        if (ch == '#' || !node->children[ch - 'a']) return; // No path in Trie

        TrieNode* next = node->children[ch - 'a'];

        if (!next->word.empty()) {
            res.push_back(next->word);
            next->word = ""; // Deduplicate: mark as found
        }

        board[r][c] = '#'; // Mark as visited (in-place)

        dfs(board, next, r + 1, c, res);
        dfs(board, next, r - 1, c, res);
        dfs(board, next, r, c + 1, res);
        dfs(board, next, r, c - 1, res);

        board[r][c] = ch; // Restore the cell (backtrack)
    }

public:
    vector<string> findWords(vector<vector<char>>& board, vector<string>& words) {
        // --- Trie + Backtracking DFS (O(M * N * 4^L) Time) ---

        TrieNode* root = new TrieNode();

        // Build Trie from words list
        for (const string& w : words) {
            TrieNode* cur = root;
            for (char c : w) {
                if (!cur->children[c - 'a'])
                    cur->children[c - 'a'] = new TrieNode();
                cur = cur->children[c - 'a'];
            }
            cur->word = w; // Store full word at terminal node
        }

        vector<string> res;
        for (int r = 0; r < board.size(); ++r) {
            for (int c = 0; c < board[0].size(); ++c) {
                dfs(board, root, r, c, res); // DFS from every cell
            }
        }

        return res;
    }
};
```

---

# 🔄 Category 11: Intervals & Greedy

### 50. Merge Intervals

_Merge all overlapping intervals._

```cpp
#include <vector>
#include <algorithm>

using namespace std;

vector<vector<int>> merge(vector<vector<int>>& intervals) {
    // --- Sort + Linear Scan (O(N log N) Time, O(N) Space) ---

    sort(intervals.begin(), intervals.end()); // Sort by start time

    vector<vector<int>> merged;
    merged.push_back(intervals[0]); // Start with the first interval

    for (int i = 1; i < intervals.size(); ++i) {
        // If current interval overlaps with the last merged one, extend it
        if (intervals[i][0] <= merged.back()[1]) {
            merged.back()[1] = max(merged.back()[1], intervals[i][1]);
        } else {
            // No overlap: simply add the new interval
            merged.push_back(intervals[i]);
        }
    }

    return merged;
}
```

---

### 51. Non-overlapping Intervals

_Find the minimum number of intervals to remove to make the rest non-overlapping._

```cpp
#include <vector>
#include <algorithm>

using namespace std;

int eraseOverlapIntervals(vector<vector<int>>& intervals) {
    // --- Greedy: Sort by End Time (O(N log N) Time, O(1) Space) ---

    sort(intervals.begin(), intervals.end(), [](const auto& a, const auto& b) {
        return a[1] < b[1]; // Sort by end time ascending
    });

    int removals = 0;
    int lastEnd = INT_MIN; // Tracks the end of the last kept interval

    for (const auto& interval : intervals) {
        if (interval[0] >= lastEnd) {
            // No overlap: keep this interval, update lastEnd
            lastEnd = interval[1];
        } else {
            // Overlap: remove this interval (greedy — keep the one with earlier end)
            removals++;
        }
    }

    return removals;
}
```

---

### 52. Meeting Rooms II

_Find the minimum number of meeting rooms required._

```cpp
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

int minMeetingRooms(vector<vector<int>>& intervals) {
    // --- Min-Heap on End Times (O(N log N) Time, O(N) Space) ---

    sort(intervals.begin(), intervals.end()); // Sort by start time

    // Min-heap storing end times of ongoing meetings
    priority_queue<int, vector<int>, greater<int>> endTimes;

    for (const auto& meeting : intervals) {
        // If the earliest-ending meeting finishes before this one starts,
        // we can reuse that room
        if (!endTimes.empty() && endTimes.top() <= meeting[0]) {
            endTimes.pop(); // Release the room
        }
        endTimes.push(meeting[1]); // Assign a room (or new room) ending at meeting[1]
    }

    return endTimes.size(); // Number of rooms in use = answer
/*
*   Alternative Approaches:
*   1. Two sorted arrays (starts and ends): Walk through both using two pointers.
*      Very elegant and avoids the heap entirely. Same O(N log N) complexity.
*/
}
```

---

### 53. Jump Game

_Given an array, determine if you can reach the last index._

```cpp
#include <vector>
#include <algorithm>

using namespace std;

bool canJump(vector<int>& nums) {
    // --- Greedy: Track the Maximum Reachable Index (O(N) Time, O(1) Space) ---

    int maxReach = 0; // Furthest index we can currently reach

    for (int i = 0; i < nums.size(); ++i) {
        if (i > maxReach) return false; // Current position is unreachable

        maxReach = max(maxReach, i + nums[i]); // Expand reach from current index

        if (maxReach >= nums.size() - 1) return true; // Early exit
    }

    return true;
}
```

---

### 54. Task Scheduler

_Find the minimum time to finish all tasks given a cooldown period n._

```cpp
#include <vector>
#include <algorithm>

using namespace std;

int leastInterval(vector<char>& tasks, int n) {
    // --- Greedy with Frequency Count (O(N) Time, O(1) Space) ---

    vector<int> freq(26, 0);
    for (char t : tasks) freq[t - 'A']++;

    sort(freq.begin(), freq.end(), greater<int>()); // Sort frequencies descending

    int maxFreq = freq[0]; // The most frequent task dictates the frame count

    // Count how many tasks share the maximum frequency (they all fill the last frame)
    int maxCount = 0;
    for (int f : freq) {
        if (f == maxFreq) maxCount++;
    }

    // Formula: (maxFreq - 1) full "frames" of size (n+1), plus the final partial frame
    int minTime = (maxFreq - 1) * (n + 1) + maxCount;

    // But if we have enough tasks to fill every slot, just return total task count
    return max(minTime, (int)tasks.size());
}
```

---

# 🧮 Category 12: Math & Bit Manipulation

### 55. Single Number

_Every element appears twice except one. Find it._

```cpp
#include <vector>

using namespace std;

int singleNumber(vector<int>& nums) {
    // --- XOR Trick (O(N) Time, O(1) Space) ---
    // XOR of a number with itself is 0. XOR of a number with 0 is itself.
    // So XOR-ing all elements cancels pairs, leaving only the unique one.

    int result = 0;
    for (int num : nums) {
        result ^= num; // Each duplicate cancels itself out
    }

    return result;
}
```

---

### 56. Number of 1 Bits (Hamming Weight)

_Count the number of 1-bits in an integer._

```cpp
int hammingWeight(uint32_t n) {
    // --- Brian Kernighan's Bit-Trick (O(Number of 1-bits) Time, O(1) Space) ---
    // n & (n-1) clears the lowest set bit of n. Repeat until n is 0.

    int count = 0;
    while (n != 0) {
        n = n & (n - 1); // Drop the lowest set bit
        count++;
    }

    return count;
/*
*   Alternative Approaches:
*   1. Built-in: return __builtin_popcount(n); — fastest in practice.
*   2. Bit-shift loop: shift n right 32 times, counting each 1-bit.
*/
}
```

---

### 57. Reverse Bits

_Reverse the bits of a 32-bit unsigned integer._

```cpp
#include <cstdint>

uint32_t reverseBits(uint32_t n) {
    // --- Bit-by-bit reversal (O(32) = O(1) Time, O(1) Space) ---

    uint32_t result = 0;

    for (int i = 0; i < 32; ++i) {
        result <<= 1;           // Shift result left to make room for the next bit
        result |= (n & 1);      // Take the LSB of n and append it to result
        n >>= 1;                // Discard the LSB of n
    }

    return result;
}
```

---

### 58. Missing Number

_Given [0..n] with one missing, find it._

```cpp
#include <vector>

using namespace std;

int missingNumber(vector<int>& nums) {
    // --- Gauss Sum Formula (O(N) Time, O(1) Space) ---
    // Sum of 0..n is n*(n+1)/2. Subtract actual sum to get the missing number.

    int n = nums.size();
    int expectedSum = n * (n + 1) / 2;
    int actualSum = 0;
    for (int num : nums) actualSum += num;

    return expectedSum - actualSum;
/*
*   Alternative Approaches:
*   1. XOR Approach: XOR all indices [0..n] with all values. The pair that doesn't
*      cancel is the missing number. Same complexity, no overflow risk.
*/
}
```

---

### 59. Power of Two

_Determine if a given integer is a power of two._

```cpp
bool isPowerOfTwo(int n) {
    // --- Single Bit-Check Trick (O(1) Time, O(1) Space) ---
    // Powers of two have exactly one 1-bit set.
    // n & (n - 1) clears the lowest set bit. If n > 0 and the result is 0, it's a power of two.

    return n > 0 && (n & (n - 1)) == 0;
}
```

---

# 🗂️ Category 13: Design Problems

### 60. LRU Cache

_Design a data structure for a Least Recently Used cache._

```cpp
#include <unordered_map>
#include <list>
#include <utility>

using namespace std;

class LRUCache {
private:
    int capacity;
    // Doubly-linked list stores {key, value} pairs — front = most recent, back = least recent
    list<pair<int,int>> order;
    // Hash map stores key -> iterator into the list for O(1) access
    unordered_map<int, list<pair<int,int>>::iterator> cache;

public:
    LRUCache(int capacity) : capacity(capacity) {}

    // O(1) average time
    int get(int key) {
        if (!cache.count(key)) return -1; // Key not found

        // Move accessed node to the front (most recently used)
        order.splice(order.begin(), order, cache[key]);

        return cache[key]->second;
    }

    // O(1) average time
    void put(int key, int value) {
        if (cache.count(key)) {
            // Update existing key and move to front
            cache[key]->second = value;
            order.splice(order.begin(), order, cache[key]);
        } else {
            if (order.size() == capacity) {
                // Evict the least recently used (back of list)
                cache.erase(order.back().first);
                order.pop_back();
            }
            // Insert new entry at the front
            order.push_front({key, value});
            cache[key] = order.begin();
        }
    }
};
```

---

### 61. Min Stack

_Design a stack that supports push, pop, top, and retrieving the minimum in O(1)._

```cpp
#include <stack>
#include <algorithm>

using namespace std;

class MinStack {
private:
    stack<int> mainStack; // Standard stack holding all elements
    stack<int> minStack;  // Auxiliary stack tracking current minimum at each level

public:
    void push(int val) {
        mainStack.push(val);

        // Push to minStack only the min so far — if minStack is empty, push val directly
        if (minStack.empty()) {
            minStack.push(val);
        } else {
            minStack.push(min(val, minStack.top())); // Track running minimum
        }
    }

    void pop() {
        mainStack.pop();
        minStack.pop(); // Both stacks stay in sync
    }

    int top() {
        return mainStack.top();
    }

    // O(1) — top of minStack always holds the current minimum
    int getMin() {
        return minStack.top();
    }
};
```

---

### 62. Design Add and Search Words Data Structure

_Support addWord and search (with '.' wildcard) operations._

```cpp
#include <string>

using namespace std;

struct TrieNode {
    TrieNode* children[26] = {};
    bool isEnd = false;
};

class WordDictionary {
private:
    TrieNode* root;

    // DFS with wildcard support
    bool dfs(const string& word, int idx, TrieNode* node) {
        if (!node) return false;

        if (idx == word.length()) return node->isEnd;

        char c = word[idx];

        if (c == '.') {
            // Try all possible children for the wildcard
            for (int i = 0; i < 26; ++i) {
                if (dfs(word, idx + 1, node->children[i])) return true;
            }
            return false;
        } else {
            return dfs(word, idx + 1, node->children[c - 'a']);
        }
    }

public:
    WordDictionary() {
        root = new TrieNode();
    }

    // O(M) — standard Trie insert
    void addWord(string word) {
        TrieNode* cur = root;
        for (char c : word) {
            if (!cur->children[c - 'a'])
                cur->children[c - 'a'] = new TrieNode();
            cur = cur->children[c - 'a'];
        }
        cur->isEnd = true;
    }

    // O(M) for normal words, O(M * 26^K) for wildcard-heavy patterns
    bool search(string word) {
        return dfs(word, 0, root);
    }
};
```

---

# 🌐 Category 14: Advanced Graphs

### 63. Dijkstra's Shortest Path

_Find the shortest path from a source to all nodes in a weighted graph._

```cpp
#include <vector>
#include <queue>
#include <climits>

using namespace std;

vector<int> dijkstra(int src, int n, vector<vector<pair<int,int>>>& adj) {
    // --- Min-Heap (Priority Queue) Approach (O((V + E) log V) Time) ---

    vector<int> dist(n, INT_MAX);
    dist[src] = 0;

    // Min-heap: {distance, node}
    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> pq;
    pq.push({0, src});

    while (!pq.empty()) {
        auto [d, u] = pq.top();
        pq.pop();

        if (d > dist[u]) continue; // Stale entry — skip

        for (auto [v, w] : adj[u]) {
            if (dist[u] + w < dist[v]) {
                dist[v] = dist[u] + w; // Relax the edge
                pq.push({dist[v], v});
            }
        }
    }

    return dist; // dist[i] = shortest distance from src to node i
/*
*   Note: Does NOT work with negative edge weights. Use Bellman-Ford for that.
*/
}
```

---

### 64. Pacific Atlantic Water Flow

_Find cells that can flow to both the Pacific and Atlantic oceans._

```cpp
#include <vector>
#include <queue>

using namespace std;

class Solution {
private:
    int rows, cols;
    vector<pair<int,int>> dirs = {{1,0},{-1,0},{0,1},{0,-1}};

    void bfs(vector<vector<int>>& heights, vector<vector<bool>>& reachable, queue<pair<int,int>>& q) {
        while (!q.empty()) {
            auto [r, c] = q.front();
            q.pop();

            for (auto [dr, dc] : dirs) {
                int nr = r + dr, nc = c + dc;
                // Only visit if in bounds, not visited, and height is non-decreasing (water flows uphill in BFS reverse)
                if (nr >= 0 && nc >= 0 && nr < rows && nc < cols
                    && !reachable[nr][nc]
                    && heights[nr][nc] >= heights[r][c]) {
                    reachable[nr][nc] = true;
                    q.push({nr, nc});
                }
            }
        }
    }

public:
    vector<vector<int>> pacificAtlantic(vector<vector<int>>& heights) {
        // --- Reverse BFS from Ocean Borders (O(M * N) Time, O(M * N) Space) ---
        rows = heights.size();
        cols = heights[0].size();

        vector<vector<bool>> pacific(rows, vector<bool>(cols, false));
        vector<vector<bool>> atlantic(rows, vector<bool>(cols, false));

        queue<pair<int,int>> pq, aq;

        // Seed borders for each ocean
        for (int r = 0; r < rows; ++r) {
            pq.push({r, 0});         pacific[r][0] = true;
            aq.push({r, cols - 1});  atlantic[r][cols - 1] = true;
        }
        for (int c = 0; c < cols; ++c) {
            pq.push({0, c});         pacific[0][c] = true;
            aq.push({rows - 1, c});  atlantic[rows - 1][c] = true;
        }

        bfs(heights, pacific, pq);
        bfs(heights, atlantic, aq);

        vector<vector<int>> res;
        for (int r = 0; r < rows; ++r) {
            for (int c = 0; c < cols; ++c) {
                if (pacific[r][c] && atlantic[r][c]) {
                    res.push_back({r, c});
                }
            }
        }

        return res;
    }
};
```

---

### 65. Redundant Connection

_Find and remove one edge to make the graph a tree (Union-Find)._

```cpp
#include <vector>

using namespace std;

class Solution {
private:
    vector<int> parent, rank_;

    int find(int x) {
        // Path compression: flatten the tree for O(alpha(N)) amortized
        if (parent[x] != x) parent[x] = find(parent[x]);
        return parent[x];
    }

    bool unite(int x, int y) {
        int px = find(x), py = find(y);
        if (px == py) return false; // Already connected — this edge is redundant

        // Union by rank to keep tree shallow
        if (rank_[px] < rank_[py]) swap(px, py);
        parent[py] = px;
        if (rank_[px] == rank_[py]) rank_[px]++;
        return true;
    }

public:
    vector<int> findRedundantConnection(vector<vector<int>>& edges) {
        // --- Union-Find / DSU (O(N * alpha(N)) Time, O(N) Space) ---
        int n = edges.size();
        parent.resize(n + 1);
        rank_.resize(n + 1, 0);

        for (int i = 1; i <= n; ++i) parent[i] = i; // Initialize each node as its own root

        for (const auto& edge : edges) {
            if (!unite(edge[0], edge[1])) {
                return edge; // This edge created a cycle — it's the redundant one
            }
        }

        return {};
    }
};
```

---

### 66. Graph Valid Tree

_Check if a given undirected graph is a valid tree (connected, no cycles)._

```cpp
#include <vector>

using namespace std;

class Solution {
private:
    vector<int> parent;

    int find(int x) {
        if (parent[x] != x) parent[x] = find(parent[x]);
        return parent[x];
    }

    bool unite(int x, int y) {
        int px = find(x), py = find(y);
        if (px == py) return false; // Cycle detected
        parent[px] = py;
        return true;
    }

public:
    bool validTree(int n, vector<vector<int>>& edges) {
        // --- Union-Find (O(N * alpha(N)) Time, O(N) Space) ---

        // A valid tree must have exactly n-1 edges
        if (edges.size() != n - 1) return false;

        parent.resize(n);
        for (int i = 0; i < n; ++i) parent[i] = i;

        for (const auto& e : edges) {
            if (!unite(e[0], e[1])) return false; // Cycle found
        }

        return true; // n-1 edges + no cycles = valid tree
    }
};
```

---

# 🔍 Category 15: Binary Search Variants

### 67. Search in Rotated Sorted Array

_Search a target in a sorted array that has been rotated at some pivot._

```cpp
#include <vector>

using namespace std;

int search(vector<int>& nums, int target) {
    // --- Modified Binary Search (O(log N) Time, O(1) Space) ---

    int left = 0, right = nums.size() - 1;

    while (left <= right) {
        int mid = left + (right - left) / 2;

        if (nums[mid] == target) return mid;

        // Determine which half is properly sorted
        if (nums[left] <= nums[mid]) {
            // Left half is sorted
            if (target >= nums[left] && target < nums[mid]) {
                right = mid - 1; // Target is in the sorted left half
            } else {
                left = mid + 1; // Target is in the rotated right half
            }
        } else {
            // Right half is sorted
            if (target > nums[mid] && target <= nums[right]) {
                left = mid + 1; // Target is in the sorted right half
            } else {
                right = mid - 1; // Target is in the rotated left half
            }
        }
    }

    return -1;
}
```

---

### 68. Find Minimum in Rotated Sorted Array

_Find the minimum element in a rotated sorted array._

```cpp
#include <vector>

using namespace std;

int findMin(vector<int>& nums) {
    // --- Binary Search on Pivot (O(log N) Time, O(1) Space) ---

    int left = 0, right = nums.size() - 1;

    while (left < right) {
        int mid = left + (right - left) / 2;

        if (nums[mid] > nums[right]) {
            // Minimum is in the right half (past the rotation point)
            left = mid + 1;
        } else {
            // Minimum is in the left half or at mid
            right = mid;
        }
    }

    return nums[left]; // `left` converges to the minimum
}
```

---

### 69. Kth Smallest Element in a Sorted Matrix

_Find the kth smallest element in an n x n matrix where each row and column is sorted._

```cpp
#include <vector>
#include <queue>

using namespace std;

int kthSmallest(vector<vector<int>>& matrix, int k) {
    // --- Min-Heap Approach (O(K log N) Time, O(N) Space) ---
    // N = number of rows

    int n = matrix.size();

    // Min-heap: {value, row, col}
    priority_queue<tuple<int,int,int>, vector<tuple<int,int,int>>, greater<>> pq;

    // Seed with the first element of each row
    for (int r = 0; r < n; ++r) {
        pq.push({matrix[r][0], r, 0});
    }

    int result = 0;
    for (int i = 0; i < k; ++i) {
        auto [val, r, c] = pq.top();
        pq.pop();
        result = val;

        // Push the next element in the same row if it exists
        if (c + 1 < n) {
            pq.push({matrix[r][c + 1], r, c + 1});
        }
    }

    return result;
/*
*   Alternative Approaches:
*   1. Binary Search on Value Range (O(N log(Max-Min)) Time, O(1) Space): More optimal
*      for very large matrices. Binary search the answer value and count elements <= mid.
*/
}
```

---

### 70. Find Peak Element

_A peak is an element greater than its neighbors. Return any peak index._

```cpp
#include <vector>

using namespace std;

int findPeakElement(vector<int>& nums) {
    // --- Binary Search (O(log N) Time, O(1) Space) ---
    // Key insight: if nums[mid] < nums[mid+1], there must be a peak to the right.

    int left = 0, right = nums.size() - 1;

    while (left < right) {
        int mid = left + (right - left) / 2;

        if (nums[mid] < nums[mid + 1]) {
            left = mid + 1; // Ascending slope — peak is to the right
        } else {
            right = mid; // Descending slope — peak is at mid or to the left
        }
    }

    return left; // left == right: the single peak index
}
```

---

# ⚡ Category 16: Stack & Queue Advanced

### 71. Daily Temperatures

_For each day, find how many days until a warmer temperature._

```cpp
#include <vector>
#include <stack>

using namespace std;

vector<int> dailyTemperatures(vector<int>& temperatures) {
    // --- Monotonic Decreasing Stack (O(N) Time, O(N) Space) ---

    int n = temperatures.size();
    vector<int> result(n, 0);
    stack<int> s; // Stack stores indices of unresolved days

    for (int i = 0; i < n; ++i) {
        // While current temperature is warmer than the day at the top of the stack
        while (!s.empty() && temperatures[i] > temperatures[s.top()]) {
            int idx = s.top();
            s.pop();
            result[idx] = i - idx; // Days waited = current index - stored index
        }
        s.push(i);
    }

    return result; // Remaining indices in stack naturally stay 0 (no warmer day found)
}
```

---

### 72. Largest Rectangle in Histogram

_Find the area of the largest rectangle in a histogram._

```cpp
#include <vector>
#include <stack>

using namespace std;

int largestRectangleArea(vector<int>& heights) {
    // --- Monotonic Increasing Stack (O(N) Time, O(N) Space) ---

    stack<int> s; // Stack stores indices in increasing height order
    int maxArea = 0;
    int n = heights.size();

    for (int i = 0; i <= n; ++i) {
        // Use 0 as a sentinel height at the end to flush all remaining bars
        int h = (i == n) ? 0 : heights[i];

        while (!s.empty() && h < heights[s.top()]) {
            int height = heights[s.top()];
            s.pop();

            // Width extends from the current top of stack to i
            int width = s.empty() ? i : i - s.top() - 1;
            maxArea = max(maxArea, height * width);
        }
        s.push(i);
    }

    return maxArea;
/*
*   Alternative Approaches:
*   1. Divide and Conquer (O(N log N) average, O(N^2) worst): Recursively find min bar as pivot.
*/
}
```

---

### 73. Sliding Window Maximum

_Return the maximum value in every sliding window of size k._

```cpp
#include <vector>
#include <deque>

using namespace std;

vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    // --- Monotonic Deque (O(N) Time, O(K) Space) ---
    // Deque stores indices; front always holds the index of the current window max.

    deque<int> dq; // Indices of useful elements, front = max
    vector<int> result;

    for (int i = 0; i < nums.size(); ++i) {
        // Remove indices outside the current window from the front
        if (!dq.empty() && dq.front() < i - k + 1) dq.pop_front();

        // Remove from back all indices with a value smaller than nums[i]
        // (they can never be the max while nums[i] is in the window)
        while (!dq.empty() && nums[dq.back()] < nums[i]) dq.pop_back();

        dq.push_back(i);

        // Start recording results once the first full window is formed
        if (i >= k - 1) result.push_back(nums[dq.front()]);
    }

    return result;
}
```

---

# 🌲 Category 17: Advanced Trees

### 74. Serialize and Deserialize Binary Tree

_Convert a tree to a string and back._

```cpp
#include <string>
#include <sstream>
#include <queue>

using namespace std;

struct TreeNode {
    int val;
    TreeNode *left, *right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

class Codec {
public:
    // --- BFS Level-Order Serialization (O(N) Time, O(N) Space) ---

    string serialize(TreeNode* root) {
        if (!root) return "";
        string result;
        queue<TreeNode*> q;
        q.push(root);

        while (!q.empty()) {
            TreeNode* node = q.front();
            q.pop();

            if (node) {
                result += to_string(node->val) + ",";
                q.push(node->left);
                q.push(node->right);
            } else {
                result += "null,"; // Sentinel for missing children
            }
        }
        return result;
    }

    TreeNode* deserialize(string data) {
        if (data.empty()) return nullptr;
        stringstream ss(data);
        string token;
        getline(ss, token, ',');
        TreeNode* root = new TreeNode(stoi(token));
        queue<TreeNode*> q;
        q.push(root);

        while (!q.empty()) {
            TreeNode* node = q.front();
            q.pop();

            if (getline(ss, token, ',') && token != "null") {
                node->left = new TreeNode(stoi(token));
                q.push(node->left);
            }
            if (getline(ss, token, ',') && token != "null") {
                node->right = new TreeNode(stoi(token));
                q.push(node->right);
            }
        }
        return root;
    }
};
```

---

### 75. Diameter of Binary Tree

_Find the length of the longest path between any two nodes in a tree._

```cpp
#include <algorithm>

using namespace std;

struct TreeNode {
    int val;
    TreeNode *left, *right;
};

class Solution {
private:
    int diameter = 0;

    int dfs(TreeNode* node) {
        if (!node) return 0;

        int leftHeight = dfs(node->left);
        int rightHeight = dfs(node->right);

        // The path through this node has length leftHeight + rightHeight
        diameter = max(diameter, leftHeight + rightHeight);

        // Return the longer single arm for the parent to use
        return 1 + max(leftHeight, rightHeight);
    }

public:
    int diameterOfBinaryTree(TreeNode* root) {
        dfs(root);
        return diameter; // Time Complexity: O(N), Space Complexity: O(H)
    }
};
```

---

### 76. Kth Smallest Element in a BST

_Find the kth smallest element using in-order traversal._

```cpp
struct TreeNode {
    int val;
    TreeNode *left, *right;
};

class Solution {
private:
    int count = 0;
    int result = 0;

    void inorder(TreeNode* node, int k) {
        if (!node || count >= k) return;

        inorder(node->left, k); // Visit left subtree first (smaller elements)

        count++;
        if (count == k) {
            result = node->val; // kth element found in sorted order
            return;
        }

        inorder(node->right, k);
    }

public:
    int kthSmallest(TreeNode* root, int k) {
        inorder(root, k);
        return result; // Time Complexity: O(H + K), Space Complexity: O(H)
    }
};
```

---

# 🔢 Category 18: Sorting Algorithms (Must Know Implementations)

### 77. Merge Sort

_Divide and conquer sorting algorithm._

```cpp
#include <vector>

using namespace std;

void merge(vector<int>& arr, int left, int mid, int right) {
    vector<int> temp;
    int i = left, j = mid + 1;

    while (i <= mid && j <= right) {
        if (arr[i] <= arr[j]) temp.push_back(arr[i++]);
        else temp.push_back(arr[j++]);
    }

    while (i <= mid) temp.push_back(arr[i++]);
    while (j <= right) temp.push_back(arr[j++]);

    for (int k = left; k <= right; ++k) {
        arr[k] = temp[k - left]; // Copy merged result back into original array
    }
}

void mergeSort(vector<int>& arr, int left, int right) {
    if (left >= right) return; // Base case: single element

    int mid = left + (right - left) / 2;
    mergeSort(arr, left, mid);    // Sort left half
    mergeSort(arr, mid + 1, right); // Sort right half
    merge(arr, left, mid, right); // Merge sorted halves
    // Time Complexity: O(N log N), Space Complexity: O(N)
}
```

---

### 78. Quick Sort

_Partition-based in-place sorting algorithm._

```cpp
#include <vector>

using namespace std;

int partition(vector<int>& arr, int left, int right) {
    int pivot = arr[right]; // Use last element as pivot
    int i = left - 1;

    for (int j = left; j < right; ++j) {
        if (arr[j] <= pivot) {
            swap(arr[++i], arr[j]); // Move element to the left partition
        }
    }

    swap(arr[i + 1], arr[right]); // Place pivot in its correct sorted position
    return i + 1; // Return pivot index
}

void quickSort(vector<int>& arr, int left, int right) {
    if (left >= right) return; // Base case

    int pivotIdx = partition(arr, left, right);
    quickSort(arr, left, pivotIdx - 1);  // Sort left of pivot
    quickSort(arr, pivotIdx + 1, right); // Sort right of pivot
    // Time Complexity: O(N log N) average, O(N^2) worst, Space: O(log N) call stack
}
```

---

# 🧩 Category 19: Bonus — Classic Patterns

### 79. Top K Frequent Elements

_Find the k most frequent elements in an array._

```cpp
#include <vector>
#include <unordered_map>
#include <queue>

using namespace std;

vector<int> topKFrequent(vector<int>& nums, int k) {
    // --- Min-Heap of size K (O(N log K) Time, O(N) Space) ---

    unordered_map<int, int> freq;
    for (int num : nums) freq[num]++;

    // Min-heap: {frequency, value}. Keeps only the K largest frequencies.
    priority_queue<pair<int,int>, vector<pair<int,int>>, greater<>> pq;

    for (auto& [val, count] : freq) {
        pq.push({count, val});
        if (pq.size() > k) pq.pop(); // Evict the least frequent if heap exceeds k
    }

    vector<int> result;
    while (!pq.empty()) {
        result.push_back(pq.top().second);
        pq.pop();
    }

    return result;
/*
*   Alternative Approaches:
*   1. Bucket Sort (O(N) Time): Use frequency as bucket index. Fastest possible approach.
*   2. nth_element / partial_sort (O(N) average): STL-based approach.
*/
}
```

---

### 80. Combination Sum

_Find all combinations that sum to a target (elements can be reused)._

```cpp
#include <vector>
#include <algorithm>

using namespace std;

class Solution {
private:
    void backtrack(vector<vector<int>>& res, vector<int>& current,
                   vector<int>& candidates, int target, int startIdx) {
        if (target == 0) {
            res.push_back(current); // Found a valid combination
            return;
        }
        if (target < 0) return; // Over-shot: prune this branch

        for (int i = startIdx; i < candidates.size(); ++i) {
            current.push_back(candidates[i]);
            backtrack(res, current, candidates, target - candidates[i], i); // Note: i (not i+1) allows reuse
            current.pop_back(); // Backtrack
        }
    }

public:
    vector<vector<int>> combinationSum(vector<int>& candidates, int target) {
        sort(candidates.begin(), candidates.end()); // Sorted for early pruning
        vector<vector<int>> res;
        vector<int> current;
        backtrack(res, current, candidates, target, 0);
        return res; // Time Complexity: O(N^(T/M)) where T=target, M=min candidate
    }
};
```

---

### 81. Rotate Image

_Rotate an n x n matrix 90 degrees clockwise in-place._

```cpp
#include <vector>
#include <algorithm>

using namespace std;

void rotate(vector<vector<int>>& matrix) {
    // --- Transpose + Reverse Rows (O(N^2) Time, O(1) Space) ---

    int n = matrix.size();

    // Step 1: Transpose the matrix (swap matrix[i][j] with matrix[j][i])
    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) {
            swap(matrix[i][j], matrix[j][i]);
        }
    }

    // Step 2: Reverse each row
    for (int i = 0; i < n; ++i) {
        reverse(matrix[i].begin(), matrix[i].end());
    }
    // Result: equivalent to a 90-degree clockwise rotation
}
```

---

### 82. Spiral Matrix

_Return all elements of an n x m matrix in spiral order._

```cpp
#include <vector>

using namespace std;

vector<int> spiralOrder(vector<vector<int>>& matrix) {
    // --- Boundary Shrink Approach (O(M * N) Time, O(1) Auxiliary Space) ---

    vector<int> result;
    int top = 0, bottom = matrix.size() - 1;
    int left = 0, right = matrix[0].size() - 1;

    while (top <= bottom && left <= right) {
        for (int c = left; c <= right; ++c) result.push_back(matrix[top][c]);    // Left → Right
        top++;

        for (int r = top; r <= bottom; ++r) result.push_back(matrix[r][right]);  // Top → Bottom
        right--;

        if (top <= bottom) {
            for (int c = right; c >= left; --c) result.push_back(matrix[bottom][c]); // Right → Left
            bottom--;
        }

        if (left <= right) {
            for (int r = bottom; r >= top; --r) result.push_back(matrix[r][left]);   // Bottom → Top
            left++;
        }
    }

    return result;
}
```

---

_Good luck with your technical round! Remember: clarify the problem, think out loud, start with brute force, then optimize._