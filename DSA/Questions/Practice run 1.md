
---

# 📝 Category 1: Basic Array & Hash Map Manipulation

### 1. Valid Anagram
*Check if string $A$ can be formed by rearranging $B$.*

```cpp
#include <string>
#include <vector>

using namespace std;

bool isAnagram(string s, string t) {
    // If lengths are different, they cannot be anagrams
    if (s.length() != t.length()) return false;

    // Fixed-size frequency array for 26 lowercase English letters (Optimal O(1) space)
    vector<int> counts(26, 0);

    for (int i = 0; i < s.length(); i++) {
        counts[s[i] - 'a']++; // Increment count for char in 's'
        counts[t[i] - 'a']--; // Decrement count for char in 't'
    }

    // If strings are anagrams, every single position should net zero
    for (int val : counts) {
        if (val != 0) return false;
    }

    return true; // Time Complexity: O(N), Space Complexity: O(1)
}
```

---

### 2. Two Sum
*Find two numbers that sum to a target (use a Hash Map!).*

```cpp
#include <vector>
#include <unordered_map>

using namespace std;

vector<int> twoSum(vector<int>& nums, int target) {
    // Hash map to store {Value -> Index} for O(1) lookup
    unordered_map<int, int> seen;

    for (int i = 0; i < nums.size(); ++i) {
        int complement = target - nums[i]; // What we need to find

        // Check if we have already seen this complement earlier in the array
        if (seen.find(complement) != seen.end()) {
            return {seen[complement], i}; // Found! Return pair indices
        }

        seen[nums[i]] = i; // Save current number and index to lookup later
    }

    return {}; // Time Complexity: O(N), Space Complexity: O(N)
}
```

---

### 3. Maximum Subarray (Kadane’s Algorithm)
*Find the contiguous subarray with the largest sum.*

```cpp
#include <vector>
#include <algorithm>

using namespace std;

int maxSubArray(vector<int>& nums) {
    int maxSoFar = nums[0]; // Global max sum found
    int currentSum = nums[0]; // Running sum for current subarray

    for (int i = 1; i < nums.size(); ++i) {
        // Decide whether to attach current number to the existing subarray 
        // OR start a brand new subarray with the current number.
        currentSum = max(nums[i], currentSum + nums[i]);

        maxSoFar = max(maxSoFar, currentSum); // Update global max if needed
    }

    return maxSoFar; // Time Complexity: O(N), Space Complexity: O(1)
}
```

---

### 4. Move Zeroes
*Move all zeros to the end without changing the relative order of other elements.*

```cpp
#include <vector>

using namespace std;

void moveZeroes(vector<int>& nums) {
    int lastFoundNonZero = 0; // The slow pointer, marks non-zero index position

    // Loop with fast pointer `i`. When non-zero, push it forward to the slow pointer spot.
    for (int i = 0; i < nums.size(); i++) {
        if (nums[i] != 0) {
            nums[lastFoundNonZero++] = nums[i];
        }
    }

    // Now fill remaining positions at the end of array with 0.
    for (int i = lastFoundNonZero; i < nums.size(); i++) {
        nums[i] = 0;
    }
    // Time Complexity: O(N), Space Complexity: O(1) (In-Place)
}
```

---

### 5. Longest Common Prefix
*Find the longest common prefix string among an array of strings.*

```cpp
#include <vector>
#include <string>
#include <algorithm>

using namespace std;

string longestCommonPrefix(vector<string>& strs) {
    if (strs.empty()) return "";

    // Sort the strings array. This is extremely efficient because the smallest 
    // prefix must sit between the first and the very last string in sorting order.
    sort(strs.begin(), strs.end());

    string first = strs[0];
    string last = strs.back();
    string result = "";

    // We only need to find common characters between the first & last string
    for (int i = 0; i < first.length(); i++) {
        if (first[i] == last[i]) {
            result += first[i];
        } else {
            break; // Stop at first mismatch
        }
    }

    return result; // Time: O(N log N * Length_of_string) due to sort. Best practical approach.
}
```

---

# 🏃 Category 2: Two Pointers & Sliding Window

### 6. Container With Most Water
*Find two lines that together with the x-axis form a container that holds the most water.*

```cpp
#include <vector>
#include <algorithm>

using namespace std;

int maxArea(vector<int>& height) {
    int maxWater = 0;
    int left = 0;                 // Left-most wall
    int right = height.size() - 1; // Right-most wall

    while (left < right) {
        int width = right - left;
        // Water is bounded by the shorter wall
        int h = min(height[left], height[right]);
        
        maxWater = max(maxWater, h * width);

        // Move the pointer of the shorter wall inward, since a shorter wall can 
        // never capture more water for future, longer widths.
        if (height[left] < height[right]) {
            left++;
        } else {
            right--;
        }
    }

    return maxWater; // Time Complexity: O(N), Space Complexity: O(1)
}
```

---

### 7. Remove Duplicates from Sorted Array
*In-place removal.*

```cpp
#include <vector>

using namespace std;

int removeDuplicates(vector<int>& nums) {
    if (nums.empty()) return 0;

    int uniqueIdx = 1; // Pointer representing where to insert next unique number

    for (int i = 1; i < nums.size(); ++i) {
        // If current element is different from the previous, it's unique
        if (nums[i] != nums[i - 1]) {
            nums[uniqueIdx] = nums[i]; // Move it to its unique place
            uniqueIdx++;
        }
    }

    return uniqueIdx; // Number of unique elements. Time Complexity: O(N), Space: O(1)
}
```

---

### 8. Minimum Window Substring
*Find the smallest substring containing all characters of another string.*

```cpp
#include <string>
#include <vector>
#include <climits>

using namespace std;

string minWindow(string s, string t) {
    if (s.empty() || t.empty()) return "";

    // Array to map character counts for standard ASCII characters
    vector<int> target_map(128, 0);
    for (char c : t) target_map[c]++;

    int left = 0;                 // Slow pointer defining window left
    int required = t.length();    // Master character checklist count remaining
    int minLen = INT_MAX;         // Current minimal window length tracked
    int resLeft = 0;              // Pointer marker where sub answer begins

    // Loop driving the Fast Pointer 'right' to expand window
    for (int right = 0; right < s.length(); ++right) {
        if (target_map[s[right]] > 0) {
            required--; // Valid char required from 't' is found in s
        }
        target_map[s[right]]--; // Tracking it inside the window count (non-t chars go negative)

        // Valid condition: when our window houses ALL chars required from t
        while (required == 0) {
            int currentLen = right - left + 1;
            if (currentLen < minLen) {
                minLen = currentLen;
                resLeft = left; // Capture where answer substring begins
            }

            target_map[s[left]]++; // Moving 'left' out of the window
            if (target_map[s[left]] > 0) {
                required++; // Lost a needed 't' character, so required goes up again
            }
            left++; // Shaking off left side
        }
    }

    return minLen == INT_MAX ? "" : s.substr(resLeft, minLen); // Time Complexity: O(|S| + |T|)
}
```

---

### 9. 3Sum
*Find all unique triplets in an array that sum to zero.*

```cpp
#include <vector>
#include <algorithm>

using namespace std;

vector<vector<int>> threeSum(vector<int>& nums) {
    vector<vector<int>> res;
    if (nums.size() < 3) return res;

    sort(nums.begin(), nums.end()); // Step 1: Pre-sort the array for binary two-pointing search

    for (int i = 0; i < nums.size() - 2; ++i) {
        // Skip Duplicate elements to ensure unique triplets answers
        if (i > 0 && nums[i] == nums[i - 1]) continue;

        int left = i + 1;
        int right = nums.size() - 1;

        while (left < right) {
            int sum = nums[i] + nums[left] + nums[right];

            if (sum == 0) {
                res.push_back({nums[i], nums[left], nums[right]});

                // Exhaust left duplicates
                while (left < right && nums[left] == nums[left + 1]) left++;
                // Exhaust right duplicates
                while (left < right && nums[right] == nums[right - 1]) right--;

                left++;
                right--;
            } else if (sum < 0) {
                left++; // Too small, increment left for larger value
            } else {
                right--; // Too large, decrement right for smaller value
            }
        }
    }
    return res; // Time Complexity: O(N²), Space: O(sort recursion state stack space)
}
```

---

# 🔗 Category 3: Linked Lists & Stacks (Pointer Logic)

### 10. Detect Cycle in Linked List (Floyd’s tortoise & hare)

```cpp
// Definition for singly-linked list.
struct ListNode {
    int val;
    ListNode *next;
    ListNode(int x) : val(x), nextw(nullptr) {}
};

class Solution {
public:
    bool hasCycle(ListNode *head) {
        if (!head || !head->next) return false;

        ListNode *slow = head; // 1-hop
        ListNode *fast = head; // 2-hop

        while (fast && fast->next) {
            slow = slow->next;
            fast = fast->next->next;

            if (slow == fast) {
                return true; // Fast pointer loops around to catch the slow one
            }
        }
        return false; // Fast reached terminal null node; no cycles
    }
    // Time Complexity: O(N), Space Complexity: O(1)
};
```

---

### 11. Merge Two Sorted Lists

```cpp
struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

class Solution {
public:
    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {
        ListNode dummy(0); // Standard dummy-node sentinel trick
        ListNode* tail = &dummy;

        while (list1 && list2) {
            if (list1->val < list2->val) {
                tail->next = list1;
                list1 = list1->next;
            } else {
                tail->next = list2;
                list2 = list2->next;
            }
            tail = tail->next;
        }

        // Clean up remaining nodes left on the uncompleted list
        if (list1) tail->next = list1;
        if (list2) tail->next = list2;

        return dummy.next;
    }
};
```

---

### 12. Next Greater Element
*Using a monotonic stack.*

```cpp
#include <vector>
#include <unordered_map>
#include <stack>

using namespace std;

class Solution {
public:
    vector<int> nextGreaterElement(vector<int>& nums1, vector<int>& nums2) {
        unordered_map<int, int> nextMap;
        stack<int> s; // A Decreasing Monotonic Stack (Holds elements waiting for the 'Greater element' challenge)

        for (int num : nums2) {
            // While we see an upcoming element bigger than what we are holding,
            // we update the map for everything the upcoming number overcomes.
            while (!s.empty() && s.top() < num) {
                nextMap[s.top()] = num;
                s.pop();
            }
            s.push(num); // Add our upcoming element to our waiter's line.
        }

        // Remaining elements have no NGE to its right, defaulting -1
        while (!s.empty()) {
            nextMap[s.top()] = -1;
            s.pop();
        }

        vector<int> res(nums1.size());
        for (int i = 0; i < nums1.size(); ++i) {
            res[i] = nextMap[nums1[i]];
        }
        return res; // Time Complexity: O(N + M), Space Complexity: O(M)
    }
};
```

---

### 13. Implement Queue using Stacks

```cpp
#include <stack>

using namespace std;

class MyQueue {
    stack<int> in_stack; // Buffer for push ops
    stack<int> out_stack; // Buffer for pop and peek ops

    // Lazy load utility: Transfer all in_stack over to out_stack so ordering flips naturally FIFO.
    void transfer() {
        if (out_stack.empty()) {
            while (!in_stack.empty()) {
                out_stack.push(in_stack.top());
                in_stack.pop();
            }
        }
    }

public:
    MyQueue() {}

    void push(int x) {
        in_stack.push(x); // Always O(1)
    }

    int pop() {
        transfer();
        int val = out_stack.top();
        out_stack.pop();
        return val; // Amortized O(1)
    }

    int peek() {
        transfer();
        return out_stack.top(); // Amortized O(1)
    }

    bool empty() {
        return in_stack.empty() && out_stack.empty();
    }
};
```

---

# 🌳 Category 4: Trees & Graphs

### 14. Invert Binary Tree
*(The famous "Homebrew" question)*

```cpp
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};

class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if (!root) return nullptr; // DFS Tree base-state

        TreeNode* temp = root->left; // Binary tree pointer swap 
        root->left = root->right;
        root->right = temp;`

        invertTree(root->left);  // Invert downstream subtrees
        invertTree(root->right);

        return root; // Time Complexity: O(N), Space Complexity: O(Tree-height Call-stack)
    }
};
```

---

### 15. Maximum Depth of Binary Tree

```cpp
#include <algorithm>

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
};

class Solution {
public:
    int maxDepth(TreeNode* root) {
        if (!root) return 0; // Empty depth

        int leftD = maxDepth(root->left);
        int rightD = maxDepth(root->right);

        return std::max(leftD, rightD) + 1; // Bubble height plus node level (+1)
    }
    // Time Complexity: O(N)
};
```

---

### 16. Level Order Traversal
*Using BFS.*

```cpp
#include <vector>
#include <queue>

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
};

using namespace std;

class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        if (!root) return {};
        vector<vector<int>> res;

        queue<TreeNode*> q; // Using FIFO for Standard Level BFS Search 
        q.push(root);

        while (!q.empty()) {
            int levelSize = q.size();
            vector<int> levelValues;

            for (int i = 0; i < levelSize; i++) {
                TreeNode* node = q.front();
                q.pop();

                levelValues.push_back(node->val);

                if (node->left) q.push(node->left); // Enqueue left and right next-states
                if (node->right) q.push(node->right);
            }
            res.push_back(levelValues);
        }
        return res; // Time Complexity: O(N), Space Complexity: O(Width of tree)
    }
};
```

---

### 17. Path Sum

```cpp
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
};

class Solution {
public:
    bool hasPathSum(TreeNode* root, int targetSum) {
        if (!root) return false; // Found empty leaf before resolving condition

        // Standard Leaf node checklist resolve
        if (!root->left && !root->right) {
            return targetSum - root->val == 0;
        }

        // Decrease targets downward to find base zeroes
        bool leftSide = hasPathSum(root->left, targetSum - root->val);
        bool rightSide = hasPathSum(root->right, targetSum - root->val);

        return leftSide || rightSide; // If any true leaf sum was solved
    }
};
```

---

### 18. Number of Islands
*Classic DFS on a 2D grid.*

```cpp
#include <vector>

using namespace std;

class Solution {
private:
    void dfs(vector<vector<char>>& grid, int r, int c) {
        // Base fail bounds check OR checked grid check
        if (r < 0 || c < 0 || r >= grid.size() || c >= grid[0].size() || grid[r][c] == '0') {
            return;
        }

        grid[r][c] = '0'; // Sink current node and sink neighbor island chunks to avoid re-visiting. Optimal in-place track.

        dfs(grid, r + 1, c);
        dfs(grid, r - 1, c);
        dfs(grid, r, c + 1);
        dfs(grid, r, c - 1);
    }

public:
    int numIslands(vector<vector<char>>& grid) {
        int islandsCount = 0;

        for (int i = 0; i < grid.size(); i++) {
            for (int j = 0; j < grid[0].size(); j++) {
                if (grid[i][j] == '1') {
                    islandsCount++;
                    dfs(grid, i, j); // Trace DFS from fresh 1 chunk and flood other nearby '1' elements
                }
            }
        }
        return islandsCount; // Time Complexity: O(M * N), Space Complexity: O(Recursive graph stack states)
    }
};
```

---

# 🔁 Category 5: Recursion & Backtracking

### 19. Subsets
*Generate all possible subsets of a set.*

```cpp
#include <vector>

using namespace std;

class Solution {
private:
    void backtrack(vector<vector<int>>& res, vector<int>& subset, vector<int>& nums, int startIdx) {
        res.push_back(subset); // Choose: Add current valid subset state

        for (int i = startIdx; i < nums.size(); ++i) {
            subset.push_back(nums[i]); // Choose i
            
            backtrack(res, subset, nums, i + 1); // Explore subsets further than i
            
            subset.pop_back(); // Un-choose i (backtrack out and test branch without i state)
        }
    }

public:
    vector<vector<int>> subsets(vector<int>& nums) {
        vector<vector<int>> res;
        vector<int> subset;

        backtrack(res, subset, nums, 0);

        return res; // Time Complexity: O(N * 2^N), Space Complexity: O(N)
    }
};
```

---

### 20. Permutations
*Return all possible permutations.*

```cpp
#include <vector>

using namespace std;

class Solution {
private:
    void backtrack(vector<vector<int>>& res, vector<int>& nums, int beginIdx) {
        if (beginIdx >= nums.size()) {
            res.push_back(nums);
            return;
        }

        for (int i = beginIdx; i < nums.size(); ++i) {
            swap(nums[beginIdx], nums[i]); // In-place Choosing by swapping current index place. Best In-Place Space Optimizer.
            
            backtrack(res, nums, beginIdx + 1);
            
            swap(nums[beginIdx], nums[i]); // Swap it back (un-choose backtrack reset)
        }
    }

public:
    vector<vector<int>> permute(vector<int>& nums) {
        vector<vector<int>> res;
        
        backtrack(res, nums, 0);

        return res; // Time Complexity: O(N * N!), Space Complexity: O(1 auxiliary, N! stack total state tree depth)
    }
};
```

---

### 21. Letter Combinations of a Phone Number

```cpp
#include <vector>
#include <string>

using namespace std;

class Solution {
private:
    // Simple keyboard index mappings. Indices represent 0-9
    vector<string> mapping = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    void backtrack(vector<string>& res, string& currentStr, string& digits, int digitIdx) {
        if (digitIdx == digits.length()) {
            res.push_back(currentStr); // Choose state terminal path reach
            return;
        }

        string chars = mapping[digits[digitIdx] - '0'];
        for (char c : chars) {
            currentStr.push_back(c); // Add letter choices
            
            backtrack(res, currentStr, digits, digitIdx + 1); // explore downwards next digit indices
            
            currentStr.pop_back(); // remove it (Backtrack undo)
        }
    }

public:
    vector<string> letterCombinations(string digits) {
        if (digits.empty()) return {};

        vector<string> res;
        string currentStr = "";

        backtrack(res, currentStr, digits, 0);

        return res; // Time Complexity: O(4^N * N) (4 bounds 'pqrs' key cap), Space: O(N)
    }
};
```

---

# 🧠 Category 6: Dynamic Programming (The "Dreaded" Section)

### 22. Climbing Stairs

```cpp
#include <vector>

using namespace std;

class Solution {
public:
    int climbStairs(int n) {
        if (n <= 2) return n;

        int prev_two = 1; // Equivalent to DP Base Case state for n=1
        int prev_one = 2; // Equivalent to DP Base Case state for n=2

        for (int i = 3; i <= n; i++) {
            int currentSteps = prev_one + prev_two; // Fib recurrence
            prev_two = prev_one;
            prev_one = currentSteps; // Scroll space optimization. Keep O(1) state.
        }

        return prev_one; // Time Complexity: O(N), Space Complexity: O(1)
    }
};
```

---

### 23. Coin Change

```cpp
#include <vector>
#include <algorithm>

using namespace std;

class Solution {
public:
    int coinChange(vector<int>& coins, int amount) {
        // Build table tracking least count for amounts 0 - amount. Amount + 1 sits as dummy Inf.
        vector<int> dp(amount + 1, amount + 1); 
        dp[0] = 0; // making 0 requires exactly zero coin weights.

        for (int i = 1; i <= amount; i++) {
            for (int coin : coins) {
                if (i - coin >= 0) {
                    // Update table knapsack states
                    dp[i] = min(dp[i], 1 + dp[i - coin]); 
                }
            }
        }

        return dp[amount] > amount ? -1 : dp[amount]; // Returns table result. If Inf it was unsolvable (-1)
    }
    // Time Complexity: O(Amount * CoinsCount), Space Complexity: O(Amount table track)
};
```

---

### 24. Longest Increasing Subsequence (LIS)
*Find the length of the longest subsequence.*

```cpp
#include <vector>
#include <algorithm>

using namespace std;

class Solution {
public:
    int lengthOfLIS(vector<int>& nums) {
        vector<int> tails; // Contains the smallest tails ending increasing subsets. 
        // Applying classic Patience Sorting / Binary Search + DP. Is highly optimal compared to double-loop.

        for (int x : nums) {
            auto it = lower_bound(tails.begin(), tails.end(), x);

            if (it == tails.end()) {
                tails.push_back(x); // Append if the tail is greater than what we've previously recorded
            } else {
                *it = x; // Over-writing index with a tighter/smaller upper-bound threshold
            }
        }
        return tails.size(); // Time Complexity: O(N log N), Space Complexity: O(N)
    }
};
```

---

### 25. House Robber

```cpp
#include <vector>
#include <algorithm>

using namespace std;

class Solution {
public:
    int rob(vector<int>& nums) {
        if (nums.empty()) return 0;

        int rob_current_prev = 0; // representing (i - 2) rob money
        int skip_current_prev = 0; // representing (i - 1) rob money

        for (int n : nums) {
            // Can we take house + i-2 wealth, OR should we take skip it and carry i-1 wealth?
            int currentMax = max(rob_current_prev + n, skip_current_prev);

            rob_current_prev = skip_current_prev;
            skip_current_prev = currentMax; // Slide tracking variables down the DP list state for O(1) space.
        }

        return skip_current_prev; // Time Complexity: O(N), Space Complexity: O(1)
    }
};
```

Of course. Here is a curated list of optimal C++ solutions for the advanced problems you've listed. Each solution is heavily commented to explain the "how" and "why" of the implementation, line by line, and includes a note about alternative optimal approaches where applicable.

---

# ⚔️ Category 1: Advanced Array & String (Harder)

### 26. Trapping Rain Water
*Given an elevation map, compute how much water it can trap after raining.*

```cpp
#include <vector>
#include <algorithm>

using namespace std;

int trap(vector<int>& height) {
    if (height.empty()) return 0;
    
    // --- Two-Pointer Approach (O(N) Time, O(1) Space) ---
    
    // Initialize pointers at the far left and right ends of the map
    int left = 0, right = height.size() - 1;
    
    // Initialize variables to track the max height seen from each side
    int leftMax = 0, rightMax = 0;
    
    int totalWater = 0;

    // Process the array inwards from both ends
    while (left < right) {
        // If the left wall is shorter or equal to the right wall
        if (height[left] <= height[right]) {
            // Check if the current left wall is the highest we've seen from the left
            if (height[left] >= leftMax) {
                // If yes, it becomes the new water-containing wall. No water can be trapped *at* this wall.
                leftMax = height[left];
            } else {
                // If no, wthe current wall is shorter than the max-left wall.
                // This means water is trapped here, and the level is determined by `leftMax`.
                // (We already know `rightMax` is >= `leftMax` because `height[right] >= height[left]`).
                totalWater += leftMax - height[left];
            }
            // Move the left pointer inwards
            left++;
        } 
        // If the right wall is shorter than the left wall
        else {
            // Symmetric logic for the right side
            if (height[right] >= rightMax) {
                // This is a new containing wall from the right.
                rightMax = height[right];
            } else {
                // Water is trapped, and the level is determined by `rightMax`.
                totalWater += rightMax - height[right];
            }
            // Move the right pointer inwards
            right--;
        }
    }
    
    return totalWater;
}
/*
*   Alternative Approaches:
*   1. Dynamic Programming (O(N) Time, O(N) Space): Pre-compute `leftMax` and `rightMax` arrays for each index.
*   2. Monotonic Stack (O(N) Time, O(N) Space): A more complex but valid approach where the stack tracks decreasing bar heights.
*/
```

---

### 27. Longest Palindromic Substring
*Find the longest substring that is a palindrome.*

```cpp
#include <string>
#include <algorithm>

using namespace std;

string longestPalindrome(string s) {
    if (s.length() < 2) return s;

    // --- Expand Around Center Approach (O(N^2) Time, O(1) Space) ---
    
    int start = 0, maxLen = 0;

    // Helper lambda function to perform the expansion
    auto expand = [&](int l, int r) {
        // Expand outwards as long as the pointers are in bounds and characters match
        while (l >= 0 && r < s.length() && s[l] == s[r]) {
            l--;
            r++;
        }
        // After the loop, the actual palindrome is from l+1 to r-1
        int currentLen = (r - 1) - (l + 1) + 1;
        if (currentLen > maxLen) {
            maxLen = currentLen;
            start = l + 1; // Record the starting position of this new longest palindrome
        }
    };
    
    // Iterate through each character as a potential center
    for (int i = 0; i < s.length(); ++i) {
        // Case 1: Odd-length palindrome, centered at 'i' (e.g., "racecar")
        expand(i, i);
        
        // Case 2: Even-length palindrome, centered between 'i' and 'i+1' (e.g., "aabbaa")
        expand(i, i + 1);
    }
    
    return s.substr(start, maxLen);
}
/*
*   Alternative Approaches:
*   1. Dynamic Programming (O(N^2) Time, O(N^2) Space): `dp[i][j]` is true if `s[i...j]` is a palindrome. Less efficient on space.
*   2. Manacher's Algorithm (O(N) Time, O(N) Space): A very complex but linear-time algorithm specifically for this problem. Not typically expected in interviews unless for very senior roles.
*/
```

---

### 28. Minimum Window Substring
*Find the smallest substring in S that contains all characters of T.*

```cpp
#include <string>
#include <vector>
#include <climits>

using namespace std;

string minWindow(string s, string t) {
    if (t.empty() || s.length() < t.length()) return "";

    // --- Sliding Window with Frequency Map (O(|S|+|T|) Time, O(Alphabet Size) Space) ---
    
    // Frequency map for characters in 't' (ASCII size 128 is robust)
    vector<int> t_map(128, 0);
    for (char c : t) {
        t_map[c]++;
    }
    
    int left = 0;              // Left pointer of the window
    int required = t.length(); // A counter for total required characters still needed in the window
    int minLen = INT_MAX;      // Length of the best window found
    int minLeft = 0;           // Starting index of the best window

    // 'right' pointer expands the window
    for (int right = 0; right < s.length(); ++right) {
        char r_char = s[right];
        
        // If the char entering the window is one we need, decrement our 'required' count.
        if (t_map[r_char] > 0) {
            required--;
        }
        // Decrement the char's count. Non-t chars will become negative.
        t_map[r_char]--;

        // When 'required' hits 0, the window is valid. Now, we must try to shrink it.
        while (required == 0) {
            // Update our best result if this window is smaller.
            if (right - left + 1 < minLen) {
                minLen = right - left + 1;
                minLeft = left;
            }
            
            char l_char = s[left];
            
            // Put the character back as we slide 'left' past it.
            t_map[l_char]++;
            // If its count becomes positive again, it means we just lost a required char.
            // Increment 'required' to break the while loop and continue expanding 'right'.
            if (t_map[l_char] > 0) {
                required++;
            }
            
            left++; // Shrink the window
        }
    }
    
    return minLen == INT_MAX ? "" : s.substr(minLeft, minLen);
}
/*
*   No other "optimal" approaches exist; this sliding window technique is the definitive solution.
*/
```

---

### 29. Edit Distance
*Find the minimum operations to convert one string to another.*

```cpp
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int minDistance(string word1, string word2) {
    int m = word1.length();
    int n = word2.length();
    
    // --- 2D Dynamic Programming (O(M*N) Time, O(M*N) Space) ---
    
    // dp[i][j]: minimum distance between the first 'i' chars of word1
    // and the first 'j' chars of word2.
    vector<vector<int>> dp(m + 1, vector<int>(n + 1));
    
    // Base cases: distance from an empty string to another is just its length.
    for (int i = 0; i <= m; ++i) dp[i][0] = i; // 'i' deletions
    for (int j = 0; j <= n; ++j) dp[0][j] = j; // 'j' insertions
    
    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= n; ++j) {
            // If the last characters match, no operation is needed.
            // The cost is the same as the cost for the strings without these chars.
            if (word1[i - 1] == word2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1];
            } else {
                // If they don't match, we take the minimum of the three possible operations:
                // 1. Replace: Cost is 1 + dp[i-1][j-1]
                // 2. Delete (from word1): Cost is 1 + dp[i-1][j]
                // 3. Insert (into word1): Cost is 1 + dp[i][j-1]
                dp[i][j] = 1 + min({dp[i - 1][j - 1], dp[i - 1][j], dp[i][j - 1]});
            }
        }
    }
    
    return dp[m][n];
}
/*
*   Alternative Approaches:
*   1. Space-Optimized DP (O(M*N) Time, O(min(M,N)) Space): Since dp[i][j] only depends on the previous
*      row and column, you can optimize the DP table to use only two rows (or even one).
*/
```

---

### 30. Product of Array Except Self
*Solve it in O(N) without using the division operator.*

```cpp
#include <vector>

using namespace std;

vector<int> productExceptSelf(vector<int>& nums) {
    int n = nums.size();
    
    // --- Two-Pass O(N) Time, O(1) Auxiliary Space ---
    
    vector<int> result(n);
    
    // --- Pass 1: Left Pass ---
    // `result[i]` will store the product of all elements to the left of `i`.
    // We use a `prefix` variable to keep track of the running product.
    int prefix = 1;
    for (int i = 0; i < n; ++i) {
        result[i] = prefix;
        prefix *= nums[i];
    }
    
    // --- Pass 2: Right Pass ---
    // We use a `postfix` variable for the running product from the right.
    // We multiply the existing `result[i]` (which has the prefix product)
    // with the postfix product to get the final answer.
    int postfix = 1;
    for (int i = n - 1; i >= 0; --i) {
        result[i] *= postfix;
        postfix *= nums[i];
    }
    
    return result;
}
/*
*   Alternative Approaches:
*   1. Using two arrays for prefix and postfix products (O(N) Time, O(N) Space): This is more intuitive
*      but uses extra space. The implemented solution is the optimal O(1) auxiliary space one.
*/
```

---

# 🧠 Category 7: Advanced DP ("Company Filter" Questions)

### 31. Longest Common Subsequence (LCS)

```cpp
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int longestCommonSubsequence(string text1, string text2) {
    int m = text1.length();
    int n = text2.length();
    
    // --- 2D Dynamic Programming (O(M*N) Time, O(M*N) Space) ---
    
    // dp[i][j]: LCS of text1's prefix of length i and text2's prefix of length j
    vector<vector<int>> dp(m + 1, vector<int>(n + 1, 0));
    
    for (int i = 1; i <= m; ++i) {
        for (int j = 1; j <= n; ++j) {
            // If the characters match...
            if (text1[i - 1] == text2[j - 1]) {
                // ...the LCS length is 1 + the LCS of the strings without these characters.
                dp[i][j] = 1 + dp[i - 1][j - 1];
            } else {
                // If they don't match, the LCS is the best we can do by either
                // ignoring the last character of text1 OR ignoring the last char of text2.
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1]);
            }
        }
    }
    
    return dp[m][n];
}
/*
*   Alternative Approaches:
*   1. Space-Optimized DP (O(M*N) Time, O(min(M,N)) Space): Can be optimized to use only two rows of the DP table.
*/
```

---

### 32. 0/1 Knapsack Problem

*(This is a classic problem, often given with item structs or separate arrays. Here's a common formulation.)*

```cpp
#include <vector>
#include <algorithm>

using namespace std;

// weights: array of item weights
// values: array of item values
// W: knapsack capacity
int knapsack(vector<int>& weights, vector<int>& values, int W) {
    int n = weights.size();
    
    // --- 1D DP Space Optimization (O(N*W) Time, O(W) Space) ---
    
    // dp[w]: the maximum value that can be achieved with a knapsack of capacity `w`.
    vector<int> dp(W + 1, 0);

    // Iterate through each item
    for (int i = 0; i < n; ++i) {
        // Iterate backwards over capacities. This is CRUCIAL for 0/1 knapsack
        // to ensure we don't use the same item multiple times in one knapsack.
        for (int w = W; w >= weights[i]; --w) {
            // For each capacity `w`, we decide:
            // 1. Don't take item `i`: The value is still `dp[w]`.
            // 2. Take item `i`: The value is `values[i]` + the best we could do
            //    with the remaining capacity `dp[w - weights[i]]`.
            dp[w] = max(dp[w], values[i] + dp[w - weights[i]]);
        }
    }
    
    return dp[W];
}
```

---

### 33. Partition Equal Subset Sum

```cpp
#include <vector>
#include <numeric>

using namespace std;

bool canPartition(vector<int>& nums) {
    // --- 0/1 Knapsack DP (O(N*Sum) Time, O(Sum) Space) ---
    
    int totalSum = accumulate(nums.begin(), nums.end(), 0);
    
    // If the total sum is odd, it's impossible to partition into two equal halves.
    if (totalSum % 2 != 0) return false;
    
    int target = totalSum / 2;
    
    // dp[j] will be true if a subset with sum `j` can be formed.
    vector<bool> dp(target + 1, false);
    
    // Base case: a sum of 0 is always possible (the empty subset).
    dp[0] = true;
    
    // For each number in the input...
    for (int num : nums) {
        // ...iterate backwards from the target.
        for (int j = target; j >= num; --j) {
            // A sum `j` is possible if it was already possible, OR if we can
            // form `j - num` and we add the current `num` to that subset.
            dp[j] = dp[j] || dp[j - num];
        }
    }
    
    // The final answer is whether we could form the target sum.
    return dp[target];
}
```

---

### 34. Word Break

```cpp
#include <string>
#include <vector>
#include <unordered_set>

using namespace std;

bool wordBreak(string s, vector<string>& wordDict) {
    int n = s.length();
    // Convert dictionary to a hash set for O(1) average-time lookups.
    unordered_set<string> dict(wordDict.begin(), wordDict.end());
    
    // --- 1D DP (O(N^2) Time, O(N) Space) ---
    
    // dp[i] will be true if the prefix s[0...i-1] can be segmented.
    vector<bool> dp(n + 1, false);
    
    // Base case: an empty string can always be segmented.
    dp[0] = true;
    
    // 'i' is the length of the prefix we are trying to segment.
    for (int i = 1; i <= n; ++i) {
        // 'j' is a split point. We check if s[0...j-1] is valid (dp[j])
        // AND if the remaining part s[j...i-1] is a dictionary word.
        for (int j = 0; j < i; ++j) {
            if (dp[j]) {
                string sub = s.substr(j, i - j);
                if (dict.count(sub)) {
                    // If we found one valid split, this prefix is valid.
                    dp[i] = true;
                    break; // Move on to the next prefix length 'i'
                }
            }
        }
    }
    
    return dp[n];
}
```

---

### 35. Decode Ways

```cpp
#include <string>
#include <vector>

using namespace std;

int numDecodings(string s) {
    if (s.empty() || s[0] == '0') return 0;
    
    // --- 1D DP with Space Optimization (O(N) Time, O(1) Space) ---
    
    // `two_back` is like dp[i-2], `one_back` is like dp[i-1]
    int two_back = 1; // Represents the one way to decode an empty prefix
    int one_back = 1; // Represents the one way to decode the first char (if valid)
    
    for (int i = 1; i < s.length(); ++i) {
        int current_ways = 0;
        
        // --- Check one-digit decoding ---
        // If current digit is not '0', it can be decoded by itself.
        // We carry forward the number of ways from the previous state (one_back).
        if (s[i] != '0') {
            current_ways += one_back;
        }

        // --- Check two-digit decoding ---
        // Form the two-digit number from s[i-1] and s[i].
        int two_digit = (s[i-1] - '0') * 10 + (s[i] - '0');
        // If it's a valid letter code (10-26)...
        if (two_digit >= 10 && two_digit <= 26) {
            // ...we can also form decodings from two steps back (two_back).
            current_ways += two_back;
        }
        
        // Slide our state variables forward
        two_back = one_back;
        one_back = current_ways;
    }
    
    return one_back;
}
```

---

### 36. Coin Change II
*Total number of ways to make change.*

```cpp
#include <vector>

using namespace std;

int change(int amount, vector<int>& coins) {
    // --- 1D DP (O(N*Amount) Time, O(Amount) Space) ---
    // dp[j] = number of ways to make sum 'j'.
    vector<int> dp(amount + 1, 0);
    
    // Base case: There is exactly one way to make amount 0 (by choosing no coins).
    dp[0] = 1;

    // The order of loops is CRUCIAL here to count COMBINATIONS, not permutations.
    // By iterating through coins first, we build up the solution for each coin
    // without double-counting (e.g., 1+2 and 2+1).
    for (int coin : coins) {
        // For each amount `j`...
        for (int j = coin; j <= amount; ++j) {
            // ...the number of ways to make `j` is increased by the number of ways
            // we could make `j - coin` (since we can now add the current `coin` to each of those ways).
            dp[j] += dp[j - coin];
        }
    }
    
    return dp[amount];
}
```

---

### 37. Unique Paths
*With obstacles.*

```cpp
#include <vector>

using namespace std;

int uniquePathsWithObstacles(vector<vector<int>>& obstacleGrid) {
    int m = obstacleGrid.size();
    int n = obstacleGrid[0].size();

    // If starting cell is an obstacle, no paths are possible.
    if (obstacleGrid[0][0] == 1) return 0;
    
    // --- In-place 2D DP (O(M*N) Time, O(1) Auxiliary Space) ---
    
    // dp[i][j] will store the number of paths to reach (i, j).
    // We will use a vector of long to avoid overflow before final casting.
    vector<vector<long>> dp(m, vector<long>(n, 0));
    
    // Base case: one way to reach the starting cell
    dp[0][0] = 1;

    // Fill the first row
    for (int j = 1; j < n; ++j) {
        if (obstacleGrid[0][j] == 0) dp[0][j] = dp[0][j - 1];
    }
    // Fill the first column
    for (int i = 1; i < m; ++i) {
        if (obstacleGrid[i][0] == 0) dp[i][0] = dp[i - 1][0];
    }
    
    for (int i = 1; i < m; ++i) {
        for (int j = 1; j < n; ++j) {
            if (obstacleGrid[i][j] == 0) {
                // Number of paths to (i,j) is sum of paths from cell above and cell to the left.
                dp[i][j] = dp[i - 1][j] + dp[i][j - 1];
            }
            // If obstacleGrid[i][j] == 1, dp[i][j] remains 0 (no paths can pass through it).
        }
    }

    return (int)dp[m - 1][n - 1];
}
```

---

# 📈 Category 8: Advanced Graphs & Trees

### 38. Course Schedule (Cycle Detection)
*Using Kahn's Algorithm (BFS-based Topological Sort).*

```cpp
#include <vector>
#include <queue>

using namespace std;

bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
    // --- Kahn's Algorithm (O(V+E) Time, O(V+E) Space) ---
    
    vector<vector<int>> adj(numCourses);
    vector<int> in_degree(numCourses, 0);

    // Build the graph and in-degree counts
    for (const auto& pre : prerequisites) {
        // Edge from prerequisite (pre[1]) to course (pre[0])
        adj[pre[1]].push_back(pre[0]);
        in_degree[pre[0]]++;
    }
    
    // Queue for nodes with an in-degree of 0 (courses with no prerequisites)
    queue<int> q;
    for (int i = 0; i < numCourses; ++i) {
        if (in_degree[i] == 0) {
            q.push(i);
        }
    }

    int courses_taken = 0;
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        courses_taken++;

        // For each neighbor (course that depends on `u`)...
        for (int v : adj[u]) {
            in_degree[v]--;
            // ...if it now has no prerequisites, add it to the queue.
            if (in_degree[v] == 0) {
                q.push(v);
            }
        }
    }
    
    // If we were able to "take" all courses, there was no cycle.
    return courses_taken == numCourses;
}
/*
*   Alternative Approaches:
*   1. DFS-based Cycle Detection: A standard DFS traversal keeping track of the recursion
*      stack to see if we visit a node currently being explored.
*/
```

---

### 39. Lowest Common Ancestor (LCA)
*Find the lowest common ancestor of two nodes in a Binary Tree.*

```cpp
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
};

class Solution {
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        // --- Recursive Post-order Traversal (O(N) Time, O(H) Space) ---
        
        // Base case: if we hit null, or we find p or q, we bubble up that node.
        if (root == nullptr || root == p || root == q) {
            return root;
        }

        // Recursively search in the left and right subtrees.
        TreeNode* left = lowestCommonAncestor(root->left, p, q);
        TreeNode* right = lowestCommonAncestor(root->right, p, q);

        // --- Analysis Step ---
        // If both left and right are non-null, it means p and q were found on
        // opposite sides of the current `root`. This `root` is the LCA.
        if (left && right) {
            return root;
        }

        // If only one side found a node, it means both p and q are in that subtree.
        // The node returned from that side (left or right) is the LCA from deeper
        // in the tree, or one of p/q itself. We just pass it up the call stack.
        return left ? left : right;
    }
};
/*
*   Alternative Approaches:
*   1. Iterative with Parent Pointers (O(N) Time, O(N) Space): First traverse to build a map
*      of parent pointers for each node, then trace paths upwards from p and q.
*   2. Binary Lifting (Advanced): O(N log N) preprocess, O(log N) per query. Best for many queries on a static tree.
*/
```

---

### 40. Binary Tree Maximum Path Sum

```cpp
#include <algorithm>
#include <climits>

using namespace std;

struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
};

class Solution {
private:
    int maxSum;
    // Helper returns the max "straight-down" path sum,
    // and updates a global maxSum with any "bending" paths.
    int dfs(TreeNode* node) {
        if (!node) return 0;
        
        // Recursively get the max gain from left and right children.
        // Use max(0, ...) to discard negative path contributions.
        int leftGain = max(0, dfs(node->left));
        int rightGain = max(0, dfs(node->right));
        
        // Update the global answer by checking the "bending" path at this node.
        maxSum = max(maxSum, node->val + leftGain + rightGain);
        
        // Return the max "straight" path for the parent node to use.
        // A path cannot bend and then continue upwards.
        return node->val + max(leftGain, rightGain);
    }

public:
    int maxPathSum(TreeNode* root) {
        // Initialize global max to a very small number, as nodes can be negative.
        maxSum = INT_MIN;
        dfs(root);
        return maxSum; // O(N) Time, O(H) Space for recursion stack
    }
};
```

---

### 41. Word Ladder
*BFS for shortest path.*

```cpp
#include <string>
#include <vector>
#include <queue>
#include <unordered_set>
#include <unordered_map>

using namespace std;

int ladderLength(string beginWord, string endWord, vector<string>& wordList) {
    // --- Breadth-First Search (BFS) for Shortest Path in Graph (O(M * N * L)) ---
    // N = num words, L = length of words
    
    // Hash set for O(1) average-time word lookups
    unordered_set<string> dict(wordList.begin(), wordList.end());
    if (dict.find(endWord) == dict.end()) return 0; // Target word not in list
    
    queue<string> q;
    q.push(beginWord);
    
    int level = 1;
    
    while(!q.empty()){
        int levelSize = q.size();
        for(int i = 0; i < levelSize; ++i) {
            string currentWord = q.front();
            q.pop();

            if (currentWord == endWord) return level;
            
            // --- Generate all possible next "neighbor" words ---
            for(int j = 0; j < currentWord.length(); ++j) {
                char originalChar = currentWord[j];
                for(char c = 'a'; c <= 'z'; ++c) {
                    currentWord[j] = c;
                    // If the new word is in our dictionary...
                    if(dict.count(currentWord)) {
                        q.push(currentWord);
                        // ...remove it from the dictionary to avoid cycles and redundant processing.
                        dict.erase(currentWord);
                    }
                }
                currentWord[j] = originalChar; // Restore the word
            }
        }
        level++;
    }
    
    return 0; // Path not found
}
/*
*   Alternative Approaches:
*   1. Bidirectional BFS: Search from both `beginWord` and `endWord` simultaneously. Often faster in practice.
*/
```

---

### 42. Clone Graph

```cpp
#include <vector>
#include <unordered_map>

class Node {
public:
    int val;
    vector<Node*> neighbors;
    // ... constructor
};

using namespace std;

class Solution {
private:
    // A hash map to store: {original_node -> cloned_node}
    // This serves as both a "visited" set and a way to get the clone of a node.
    unordered_map<Node*, Node*> oldToNew;

public:
    Node* cloneGraph(Node* node) {
        if (!node) return nullptr;
        
        // If we have already cloned this node, return the existing clone.
        if (oldToNew.count(node)) {
            return oldToNew[node];
        }

        // --- DFS Approach (O(V+E) Time, O(V) Space for map/stack) ---
        
        // 1. Create a clone of the current node and map it.
        Node* clone = new Node(node->val);
        oldToNew[node] = clone;
        
        // 2. Recursively clone all of the original node's neighbors.
        for (Node* neighbor : node->neighbors) {
            // The clone's neighbor list gets populated with the *clones* of the neighbors.
            clone->neighbors.push_back(cloneGraph(neighbor));
        }
        
        return clone;
    }
};
/*
*   Alternative Approaches:
*   1. BFS Approach: Use an explicit queue to manage nodes to visit instead of recursion.
*      The logic remains very similar, using the hash map to track cloned nodes.
*/
```

---

# 🛠️ Category 9: Heaps & Backtracking (Optimization)

### 43. Merge k Sorted Lists

```cpp
#include <vector>
#include <queue>

using namespace std;

struct ListNode {
    int val;
    ListNode *next;
};

class Solution {
public:
    ListNode* mergeKLists(vector<ListNode*>& lists) {
        // --- Min-Heap Approach (O(N log K) Time, O(K) Space) ---
        // N = total number of nodes, K = number of lists
        
        // Custom comparator for the min-heap to sort nodes by value
        auto cmp = [](const ListNode* a, const ListNode* b) {
            return a->val > b->val;
        };
        
        priority_queue<ListNode*, vector<ListNode*>, decltype(cmp)> pq(cmp);

        // Seed the heap with the head of each non-empty list
        for (ListNode* head : lists) {
            if (head) {
                pq.push(head);
            }
        }

        ListNode dummy(0);
        ListNode* tail = &dummy;

        while (!pq.empty()) {
            // Get the smallest node from across all lists
            ListNode* minNode = pq.top();
            pq.pop();

            // Append it to our result list
            tail->next = minNode;
            tail = tail->next;
            
            // If the list this node came from has a next element, add it to the heap.
            if (minNode->next) {
                pq.push(minNode->next);
            }
        }
        
        return dummy.next;
    }
};
/*
*   Alternative Approaches:
*   1. Divide and Conquer (O(N log K) Time, O(log K) Space for recursion): Repeatedly
*      merge pairs of lists until only one remains.
*/
```

---

### 44. Find Median from Data Stream

```cpp
#include <vector>
#include <queue>
#include <functional>

using namespace std;

class MedianFinder {
private:
    // Max-heap for the smaller half of the numbers
    priority_queue<int> lower_half;

    // Min-heap for the larger half of the numbers
    priority_queue<int, vector<int>, greater<int>> upper_half;

public:
    // O(log N)
    void addNum(int num) {
        // 1. Add to the lower half (max-heap)
        lower_half.push(num);
        
        // 2. Balance Values: move the largest from the low-half to the high-half.
        upper_half.push(lower_half.top());
        lower_half.pop();

        // 3. Balance Sizes: The lower_half must be the same size or have one more element.
        if (lower_half.size() < upper_half.size()) {
            lower_half.push(upper_half.top());
            upper_half.pop();
        }
    }
    
    // O(1)
    double findMedian() {
        if (lower_half.size() > upper_half.size()) {
            // Odd number of elements: median is the top of the larger heap.
            return lower_half.top();
        } else {
            // Even number: median is the average of the two middle elements.
            return (double)(lower_half.top() + upper_half.top()) / 2.0;
        }
    }
};
```

---

### 45. Palindromic Partitioning

```cpp
#include <string>
#include <vector>

using namespace std;

class Solution {
private:
    // Helper to check if a substring is a palindrome
    bool isPalindrome(const string& s, int start, int end) {
        while (start < end) {
            if (s[start++] != s[end--]) {
                return false;
            }
        }
        return true;
    }

    // --- Backtracking Helper Function ---
    void backtrack(vector<vector<string>>& res, vector<string>& currentPartition, const string& s, int startIdx) {
        // Base case: If we've reached the end of the string, we have a valid partition.
        if (startIdx == s.length()) {
            res.push_back(currentPartition);
            return;
        }

        // Explore choices: Try to make a palindromic cut at every possible position.
        for (int i = startIdx; i < s.length(); ++i) {
            // If the substring from `startIdx` to `i` is a palindrome...
            if (isPalindrome(s, startIdx, i)) {
                
                // --- Choose ---
                // Add this valid palindromic substring to our current partition.
                currentPartition.push_back(s.substr(startIdx, i - startIdx + 1));
                
                // --- Explore ---
                // Recursively search for the rest of the partitions from the next index.
                backtrack(res, currentPartition, s, i + 1);
                
                // --- Un-choose (Backtrack) ---
                // Remove the last choice to explore other partitioning possibilities.
                currentPartition.pop_back();
            }
        }
    }
public:
    vector<vector<string>> partition(string s) {
        vector<vector<string>> res;
        vector<string> currentPartition;
        backtrack(res, currentPartition, s, 0);
        return res; // Time: O(N * 2^N), Space: O(N) auxiliary space
    }
};
/*
*   Alternative Approaches:
*   1. Backtracking with DP: You can pre-compute a DP table `dp[i][j]` that tells you
*      if `s[i...j]` is a palindrome. This makes the `isPalindrome` check in the
*      backtracking O(1), but doesn't change the overall exponential time complexity.
*/
```