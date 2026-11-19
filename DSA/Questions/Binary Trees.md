Here are the top 5 most frequently asked **binary tree** interview questions, with complete C++ solutions and explanations.

---

## 1. Maximum Depth (Height) of Binary Tree

**Problem:** Given the root of a binary tree, return its maximum depth (number of nodes along the longest path from root to farthest leaf).

### Recursive Solution (Most Common)
```cpp
class Solution {
public:
    int maxDepth(TreeNode* root) {
        if (root == nullptr) return 0;
        
        int leftDepth = maxDepth(root->left);
        int rightDepth = maxDepth(root->right);
        
        return 1 + max(leftDepth, rightDepth);
    }
};
```

### Iterative BFS (Level Order)
```cpp
class Solution {
public:
    int maxDepth(TreeNode* root) {
        if (!root) return 0;
        
        queue<TreeNode*> q;
        q.push(root);
        int depth = 0;
        
        while (!q.empty()) {
            int levelSize = q.size();
            for (int i = 0; i < levelSize; i++) {
                TreeNode* node = q.front();
                q.pop();
                if (node->left) q.push(node->left);
                if (node->right) q.push(node->right);
            }
            depth++;
        }
        return depth;
    }
};
```

---

## 2. Invert Binary Tree

**Problem:** Invert a binary tree (swap every left and right child). *Famous because of Google/Hiring mishap.*

```cpp
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if (root == nullptr) return nullptr;
        
        // Swap children
        TreeNode* temp = root->left;
        root->left = root->right;
        root->right = temp;
        
        // Recursively invert subtrees
        invertTree(root->left);
        invertTree(root->right);
        
        return root;
    }
};
```

### Iterative BFS Version
```cpp
class Solution {
public:
    TreeNode* invertTree(TreeNode* root) {
        if (!root) return nullptr;
        
        queue<TreeNode*> q;
        q.push(root);
        
        while (!q.empty()) {
            TreeNode* node = q.front();
            q.pop();
            
            // Swap children
            swap(node->left, node->right);
            
            if (node->left) q.push(node->left);
            if (node->right) q.push(node->right);
        }
        
        return root;
    }
};
```

---

## 3. Binary Tree Level Order Traversal

**Problem:** Return the level order traversal of a binary tree (left to right, level by level). Each level as a separate vector.

```cpp
class Solution {
public:
    vector<vector<int>> levelOrder(TreeNode* root) {
        vector<vector<int>> result;
        if (!root) return result;
        
        queue<TreeNode*> q;
        q.push(root);
        
        while (!q.empty()) {
            int levelSize = q.size();
            vector<int> currentLevel;
            
            for (int i = 0; i < levelSize; i++) {
                TreeNode* node = q.front();
                q.pop();
                currentLevel.push_back(node->val);
                
                if (node->left) q.push(node->left);
                if (node->right) q.push(node->right);
            }
            result.push_back(currentLevel);
        }
        
        return result;
    }
};
```

**Output Example:**
```
Input:     3
         / \
        9  20
          /  \
         15   7

Output: [[3], [9,20], [15,7]]
```

---

## 4. Lowest Common Ancestor (LCA) in a Binary Tree

**Problem:** Given a binary tree and two nodes p and q, find their lowest common ancestor (the deepest node that has both p and q as descendants).

```cpp
class Solution {
public:
    TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
        // Base cases
        if (root == nullptr) return nullptr;
        if (root == p || root == q) return root;
        
        // Search left and right subtrees
        TreeNode* leftLCA = lowestCommonAncestor(root->left, p, q);
        TreeNode* rightLCA = lowestCommonAncestor(root->right, p, q);
        
        // If both sides return non-null, current root is LCA
        if (leftLCA && rightLCA) return root;
        
        // Otherwise, return the non-null side
        return leftLCA != nullptr ? leftLCA : rightLCA;
    }
};
```

**Optimization for Binary Search Tree (BST):**
```cpp
// When tree is a BST
TreeNode* lowestCommonAncestorBST(TreeNode* root, TreeNode* p, TreeNode* q) {
    if (root->val > p->val && root->val > q->val)
        return lowestCommonAncestorBST(root->left, p, q);
    
    if (root->val < p->val && root->val < q->val)
        return lowestCommonAncestorBST(root->right, p, q);
    
    return root;  // root is between p and q
}
```

---

## 5. Diameter of Binary Tree

**Problem:** Given the root of a binary tree, return the length of the diameter (the longest path between any two nodes, measured by number of edges).

```cpp
class Solution {
public:
    int diameterOfBinaryTree(TreeNode* root) {
        int diameter = 0;
        height(root, diameter);
        return diameter;
    }
    
private:
    int height(TreeNode* node, int& diameter) {
        if (node == nullptr) return 0;
        
        int leftHeight = height(node->left, diameter);
        int rightHeight = height(node->right, diameter);
        
        // Update diameter: path through current node
        diameter = max(diameter, leftHeight + rightHeight);
        
        // Return height of current node
        return 1 + max(leftHeight, rightHeight);
    }
};
```

**Example:**
```
        1
       / \
      2   3
     / \
    4   5

Diameter = 3 (path: 4 -> 2 -> 1 -> 3 or 5 -> 2 -> 1 -> 3)
```

---

## Bonus: Binary Tree Inorder Traversal (Often Asked)

```cpp
// Recursive
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> result;
        inorder(root, result);
        return result;
    }
    
    void inorder(TreeNode* node, vector<int>& result) {
        if (!node) return;
        inorder(node->left, result);
        result.push_back(node->val);
        inorder(node->right, result);
    }
};

// Iterative (Stack) - Most common interview follow-up
class Solution {
public:
    vector<int> inorderTraversal(TreeNode* root) {
        vector<int> result;
        stack<TreeNode*> stk;
        TreeNode* curr = root;
        
        while (curr != nullptr || !stk.empty()) {
            // Go to leftmost node
            while (curr != nullptr) {
                stk.push(curr);
                curr = curr->left;
            }
            
            curr = stk.top();
            stk.pop();
            result.push_back(curr->val);
            
            // Move to right subtree
            curr = curr->right;
        }
        
        return result;
    }
};
```

---

## TreeNode Definition for Testing

```cpp
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode() : val(0), left(nullptr), right(nullptr) {}
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
    TreeNode(int x, TreeNode *left, TreeNode *right) : val(x), left(left), right(right) {}
};

// Helper to create a sample tree
TreeNode* createSampleTree() {
    TreeNode* root = new TreeNode(3);
    root->left = new TreeNode(9);
    root->right = new TreeNode(20);
    root->right->left = new TreeNode(15);
    root->right->right = new TreeNode(7);
    return root;
}
```

---

## Complexity Summary

| Problem | Time Complexity | Space Complexity |
|---------|----------------|------------------|
| Maximum Depth | O(n) | O(n) worst (skewed), O(log n) balanced |
| Invert Binary Tree | O(n) | O(n) |
| Level Order Traversal | O(n) | O(n) |
| Lowest Common Ancestor | O(n) | O(n) |
| Diameter of Binary Tree | O(n) | O(n) |

---

## Quick Reference Cheat Sheet

| Problem | Key Insight |
|---------|--------------|
| Max Depth | Post-order recursion |
| Invert Tree | Swap children at each node |
| Level Order | BFS with queue |
| LCA | Recursive search returning first match |
| Diameter | Height + track max(left+right) at each node |

These five problems cover the essential binary tree patterns: **DFS (pre/in/post-order), BFS (level order), recursion with return values, and two-pointer/heights tracking**.