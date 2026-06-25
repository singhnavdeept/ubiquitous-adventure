# Tree Algorithms Masterclass (C++)

This is the ultimate reference guide for Binary Trees and N-ary Trees. It covers tree representations, recursive traversals, iterative level-order traversals, core metrics (like diameter and height), and Lowest Common Ancestor (LCA)—complete with production-grade C++ implementations and Leetcode solutions.

---

## 1. Tree Representation

There are two primary ways to represent trees depending on whether you are doing standard Leetcode-style Binary Trees, or Competitive Programming (CP) style N-ary trees.

### A. Binary Tree Struct (Leetcode / OOP Style)
Used when every node has at most two children.
```cpp
#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

struct TreeNode {
    int val;
    TreeNode* left;
    TreeNode* right;
    
    // Constructors
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};
```

### B. Adjacency List (Competitive Programming / N-ary Style)
Used when a tree is just an undirected graph with $V$ vertices and $V-1$ edges (no cycles).
```cpp
// V is the number of vertices.
vector<vector<int>> adj(V);

// To add an undirected edge between u and v
void addEdge(int u, int v) {
    adj[u].push_back(v);
    adj[v].push_back(u);
}
```

---

## 2. Depth-First Traversals (Recursive)

DFS on trees relies heavily on the Call Stack. The order in which you process the current node determines the traversal name.
*   **Time Complexity**: $O(N)$ for all traversals.
*   **Space Complexity**: $O(H)$ where $H$ is the height of the tree (due to recursion stack). In the worst case (skewed tree), $O(N)$.

### Pre-Order (Root, Left, Right)
Used to create a copy of the tree or evaluate expression trees.
```cpp
void preOrder(TreeNode* root) {
    if (!root) return;
    cout << root->val << " "; // PROCESS ROOT
    preOrder(root->left);     // TRAVERSE LEFT
    preOrder(root->right);    // TRAVERSE RIGHT
}
```

### In-Order (Left, Root, Right)
Extremely important for **Binary Search Trees (BST)** because it visits nodes in **sorted, ascending order**.
```cpp
void inOrder(TreeNode* root) {
    if (!root) return;
    inOrder(root->left);      // TRAVERSE LEFT
    cout << root->val << " "; // PROCESS ROOT
    inOrder(root->right);     // TRAVERSE RIGHT
}
```

### Post-Order (Left, Right, Root)
Used to safely delete a tree (since you must delete children before the parent).
```cpp
void postOrder(TreeNode* root) {
    if (!root) return;
    postOrder(root->left);    // TRAVERSE LEFT
    postOrder(root->right);   // TRAVERSE RIGHT
    cout << root->val << " "; // PROCESS ROOT
}
```

---

## 3. Breadth-First Traversal (Iterative)

### Level-Order Traversal
Explores the tree level-by-level using a **Queue**. 
*   **Time Complexity**: $O(N)$
*   **Space Complexity**: $O(W)$ where $W$ is the maximum width of the tree. In the worst case (perfect binary tree), the bottom level has $N/2$ nodes, making space $O(N)$.

```cpp
vector<vector<int>> levelOrder(TreeNode* root) {
    vector<vector<int>> result;
    if (!root) return result;
    
    queue<TreeNode*> q;
    q.push(root);
    
    while (!q.empty()) {
        int levelSize = q.size();
        vector<int> currentLevel;
        
        // Process all nodes exactly at the current level
        for (int i = 0; i < levelSize; i++) {
            TreeNode* currentNode = q.front();
            q.pop();
            
            currentLevel.push_back(currentNode->val);
            
            if (currentNode->left) q.push(currentNode->left);
            if (currentNode->right) q.push(currentNode->right);
        }
        result.push_back(currentLevel);
    }
    return result;
}
```

---

## 4. Core Tree Metrics

### A. Maximum Depth / Height of a Tree
The height of a tree is the number of nodes along the longest path from the root node down to the farthest leaf node.
*   **Time Complexity**: $O(N)$
*   **Space Complexity**: $O(H)$

```cpp
int maxDepth(TreeNode* root) {
    if (!root) return 0;
    
    int leftDepth = maxDepth(root->left);
    int rightDepth = maxDepth(root->right);
    
    return max(leftDepth, rightDepth) + 1; // +1 includes the current node
}
```

### B. Diameter of a Binary Tree (Leetcode 543)
The diameter is the length of the *longest path between any two nodes* in a tree. This path may or may not pass through the root.
**Approach**: The diameter passing through any node is `Height(Left) + Height(Right)`. We calculate the height recursively and update a global maximum diameter along the way.
*   **Time Complexity**: $O(N)$
*   **Space Complexity**: $O(H)$

```cpp
class Solution {
    int maxDiameter = 0;
    
    int height(TreeNode* node) {
        if (!node) return 0;
        
        int leftH = height(node->left);
        int rightH = height(node->right);
        
        // Update global max diameter: Path through current node = leftH + rightH
        maxDiameter = max(maxDiameter, leftH + rightH);
        
        // Return height of current node to its parent
        return max(leftH, rightH) + 1;
    }
    
public:
    int diameterOfBinaryTree(TreeNode* root) {
        height(root);
        return maxDiameter;
    }
};
```

---

## 5. Lowest Common Ancestor (LCA)

### LCA of a Binary Tree (Leetcode 236)
**Problem**: Find the lowest common ancestor of two nodes `p` and `q`.
**Logic**: 
1. If the current root is `p` or `q`, return root.
2. Recursively search left and right.
3. If both left and right return a non-null node, it means `p` and `q` are split across the left and right subtrees of the current node. Therefore, the current node is the LCA!
4. If only one side returns a node, pass that node up.

*   **Time Complexity**: $O(N)$
*   **Space Complexity**: $O(H)$

```cpp
TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
    // Base Case: If we hit a null, or find either p or q
    if (!root || root == p || root == q) {
        return root;
    }
    
    // Recursively look for p and q in left and right subtrees
    TreeNode* leftLCA = lowestCommonAncestor(root->left, p, q);
    TreeNode* rightLCA = lowestCommonAncestor(root->right, p, q);
    
    // If both left and right returned a node, the current root IS the LCA
    if (leftLCA && rightLCA) {
        return root;
    }
    
    // Otherwise, return whichever side successfully found a target
    return leftLCA ? leftLCA : rightLCA;
}
```

---

## 6. Advanced Tree Views

### Binary Tree Right Side View (Leetcode 199)
**Problem**: Imagine standing on the *right side* of the tree. Return the values of the nodes you can see from top to bottom.
**Approach**: Use Level-Order Traversal (BFS). For every level, grab the *last* node processed.

*   **Time Complexity**: $O(N)$
*   **Space Complexity**: $O(D)$ where $D$ is the tree diameter (queue size).

```cpp
class Solution {
public:
    vector<int> rightSideView(TreeNode* root) {
        vector<int> view;
        if (!root) return view;
        
        queue<TreeNode*> q;
        q.push(root);
        
        while (!q.empty()) {
            int levelSize = q.size();
            
            for (int i = 0; i < levelSize; i++) {
                TreeNode* curr = q.front();
                q.pop();
                
                // If this is the LAST node in the current level, add to view!
                if (i == levelSize - 1) {
                    view.push_back(curr->val);
                }
                
                if (curr->left) q.push(curr->left);
                if (curr->right) q.push(curr->right);
            }
        }
        return view;
    }
};
```

---

## 7. Foundational Practice Questions

### Question A: Invert Binary Tree (Leetcode 226) - The classic!
**Approach**: Post-order traversal. Swap the left and right pointers of every node.
*   **Time Complexity**: $O(N)$
*   **Space Complexity**: $O(H)$
```cpp
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if (!root) return nullptr;
        
        // Invert children first
        TreeNode* left = invertTree(root->left);
        TreeNode* right = invertTree(root->right);
        
        // Swap them at the current root
        root->left = right;
        root->right = left;
        
        return root;
    }
};
```

### Question B: Balanced Binary Tree (Leetcode 110)
**Approach**: Calculate height. If at any point the absolute difference between `leftHeight` and `rightHeight` is $> 1$, return `-1` to flag it as unbalanced.
*   **Time Complexity**: $O(N)$ (We calculate height bottom-up in a single pass)
*   **Space Complexity**: $O(H)$
```cpp
class Solution {
    int checkHeight(TreeNode* root) {
        if (!root) return 0;
        
        int leftH = checkHeight(root->left);
        if (leftH == -1) return -1; // Propagate the unbalanced flag up
        
        int rightH = checkHeight(root->right);
        if (rightH == -1) return -1; // Propagate the unbalanced flag up
        
        // Check if the current node violates the balance rule
        if (abs(leftH - rightH) > 1) return -1;
        
        return max(leftH, rightH) + 1;
    }
    
public:
    bool isBalanced(TreeNode* root) {
        return checkHeight(root) != -1;
    }
};
```
