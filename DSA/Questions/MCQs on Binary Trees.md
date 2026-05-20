Here’s a set of **MCQs on Binary Trees** covering the topics you listed. Each question includes the correct answer and a brief explanation to reinforce concepts.

---

## 1. Types of Binary Trees

**Q1:** A binary tree in which every node has either 0 or 2 children is called a:  
A) Complete binary tree  
B) Full binary tree  
C) Perfect binary tree  
D) Degenerate tree  

<details>
<summary>Answer & Explanation</summary>

**Answer: B) Full binary tree**  
A *full binary tree* (also called proper or strict) has every node with 0 or 2 children.  
- *Complete*: all levels filled except possibly last, filled left to right.  
- *Perfect*: all internal nodes have 2 children and all leaves at same level.  
- *Degenerate*: each node has only one child (like a linked list).
</details>

---

## 2. Insertion in a Binary Tree (Level Order)

**Q2:** When inserting a new node in a binary tree (not BST) using level order traversal, where is the new node placed?  
A) At the first available position from left to right in the first empty spot found in level order  
B) As the right child of the first leaf  
C) As the left child of the deepest node  
D) At the root if root is null, otherwise as right child of the root  

<details>
<summary>Answer & Explanation</summary>

**Answer: A)**  
In a binary tree (not BST), insertion is typically done using a queue to find the first null child (left or right) in level order. The new node is placed there.
</details>

---

## 3. Deletion in a Binary Tree

**Q3:** To delete a given node `X` from a binary tree (not BST), the common strategy is:  
A) Delete `X` and promote its left child  
B) Find the deepest node, replace `X` with that node, then delete the deepest node  
C) Swap `X` with its inorder successor then delete  
D) Remove `X` and reattach its children to the root  

<details>
<summary>Answer & Explanation</summary>

**Answer: B)**  
We replace `X` with the value of the deepest (rightmost) node to maintain structure, then delete that deepest node. This avoids breaking the tree shape.
</details>

---

## 4. Tree Traversals – Inorder, Preorder, Postorder

**Q4:** Given the inorder traversal as `[D, B, E, A, F, C]` and preorder as `[A, B, D, E, C, F]`, what is the postorder traversal?  
A) `[D, E, B, F, C, A]`  
B) `[D, E, B, F, A, C]`  
C) `[D, E, F, B, C, A]`  
D) `[D, B, E, F, C, A]`  

<details>
<summary>Answer & Explanation</summary>

**Answer: A) [D, E, B, F, C, A]**  
- Preorder first node `A` is root.  
- Inorder: left subtree = [D,B,E], right = [F,C].  
- Recursively build: left root = B (from preorder after A), then D and E; right root = C, then F.  
Postorder = left subtree postorder + right subtree postorder + root = D,E,B,F,C,A.
</details>

---

## 5. Inorder Traversal Without Recursion

**Q5:** Which data structure is used to implement iterative inorder traversal of a binary tree?  
A) Queue  
B) Stack  
C) Priority queue  
D) Deque  

<details>
<summary>Answer & Explanation</summary>

**Answer: B) Stack**  
We push left nodes onto a stack, then pop and process, then move to the right child – classic iterative DFS.
</details>

---

## 6. Print Postorder from Given Inorder and Preorder

**Q6:** The algorithm to print postorder directly from inorder and preorder arrays (without constructing the tree) uses:  
A) Recursively identify root from preorder, find root index in inorder, then recurse left, then right, then print root  
B) Build tree then do postorder  
C) Use a queue to simulate postorder  
D) Use a hashmap to store postorder indices  

<details>
<summary>Answer & Explanation</summary>

**Answer: A)**  
We don’t need to construct the tree; we can print in postorder order by recursing on left and right subtrees first using index ranges, then printing the root.
</details>

---

## 7. Level Order Tree Traversal

**Q7:** Level order traversal uses which data structure?  
A) Stack  
B) Priority queue  
C) Queue  
D) Array  

<details>
<summary>Answer & Explanation</summary>

**Answer: C) Queue**  
BFS uses a queue to process nodes level by level.
</details>

---

## 8. Populate Inorder Successor for All Nodes

**Q8:** To set the `next` pointer of each node to its inorder successor, the most efficient approach is:  
A) Perform reverse inorder traversal and keep track of the previously visited node  
B) Use level order traversal and link siblings  
C) Use a hashmap to map nodes to successors  
D) Perform preorder traversal and store nodes in a list  

<details>
<summary>Answer & Explanation</summary>

**Answer: A)**  
Reverse inorder traversal (right → root → left) allows you to set the current node’s next pointer to the previously visited node (the successor).
</details>

---

## 9. Find n-th Node of Inorder Traversal

**Q9:** How can you find the n-th node in inorder traversal efficiently (without full traversal)?  
A) Perform Morris traversal and count  
B) Use a stack and stop at n  
C) Augment each node with left subtree size and do recursive search  
D) Perform level order and index  

<details>
<summary>Answer & Explanation</summary>

**Answer: C)**  
By storing the size of the left subtree in each node, you can decide whether the n-th node lies in left, current, or right in O(log n) time if balanced. Otherwise, iterative inorder with counter works in O(n).
</details>

---

## 10. Level Order Traversal in Spiral Form (Zigzag)

**Q10:** To print level order in spiral order (alternating left-to-right, right-to-left), we can use:  
A) Two stacks  
B) One queue and one stack  
C) Two queues  
D) One deque  

<details>
<summary>Answer & Explanation</summary>

**Answer: A) Two stacks**  
One stack for current level, another for next level; flag to reverse direction each level. Alternatively, a deque with a flag also works.
</details>

---

## 11. Boundary Traversal of Binary Tree

**Q11:** Which of the following is NOT part of boundary traversal (anti‑clockwise starting from root)?  
A) Left boundary without leaves  
B) All leaves in left‑to‑right order  
C) Right boundary in reverse order without leaves  
D) All internal nodes in any order  

<details>
<summary>Answer & Explanation</summary>

**Answer: D)**  
Boundary traversal includes: 1) left boundary (excluding leaf), 2) all leaves, 3) right boundary (excluding root and leaf) in reverse order. Internal nodes that are not on boundary are excluded.
</details>

---

## 12. Finding Lowest Common Ancestor (LCA)

**Q12:** In a binary tree (not necessarily BST), the LCA of two nodes `p` and `q` can be found by:  
A) Comparing root values with p and q  
B) Recursively finding LCA in left and right subtrees; if both return non‑null, current node is LCA  
C) Climbing up using parent pointers stored in a hashmap  
D) Performing level order until both are found  

<details>
<summary>Answer & Explanation</summary>

**Answer: B)**  
The classic recursive solution: if root == p or root == q, return root; else search left and right; if both sides return non‑null, root is LCA.
</details>

---

## 13. Sum of Nodes Having Only Left Child

**Q13:** Given a binary tree, the sum of all nodes that have **only a left child** (and no right child) can be computed by:  
A) BFS and check each node for left child exist and right child null  
B) Preorder traversal and accumulate value if condition holds  
C) Both A and B are correct  
D) Only postorder works  

<details>
<summary>Answer & Explanation</summary>

**Answer: C)**  
Any traversal (DFS or BFS) works: visit each node, check if `node.left != null && node.right == null`, then add `node.val`.
</details>

---

## 14. Diameter of a Tree

**Q14:** The diameter of a binary tree is defined as:  
A) The number of nodes on the longest path between any two leaves  
B) The number of edges on the longest path between any two nodes  
C) The height of the left subtree + height of the right subtree  
D) The maximum distance from root to the deepest leaf  

<details>
<summary>Answer & Explanation</summary>

**Answer: B)**  
Diameter = number of **edges** on the longest path between any two nodes. Some definitions use nodes; typical LeetCode definition (543) uses edges. The value is `max(height_left + height_right)` over all nodes.
</details>

---

## 15. Determine if Binary Tree is Height Balanced

**Q15:** A binary tree is height‑balanced if for every node:  
A) The left subtree has same height as right subtree  
B) The difference between heights of left and right subtree is at most 1  
C) All leaves are at the same level  
D) The number of nodes in left and right differ by at most 1  

<details>
<summary>Answer & Explanation</summary>

**Answer: B)**  
Definition of a balanced binary tree (AVL style): for every node, |height(left) – height(right)| ≤ 1. Option C describes a perfect tree.
</details>

---

## 16. Convert Binary Search Tree to Min Heap

**Q16:** To convert a BST to a Min Heap (with the condition that the tree structure remains complete or the shape is fixed), the typical steps are:  
A) Perform inorder traversal to get sorted array, then fill nodes in level order  
B) Perform preorder traversal and replace node values with sorted array  
C) Perform postorder traversal and rebuild  
D) Use a stack to convert to heap directly  

<details>
<summary>Answer & Explanation</summary>

**Answer: A)**  
Inorder of BST gives sorted order. Place these sorted values into the tree using level order (BFS) to satisfy min‑heap property (parent ≤ children). This also maintains the complete tree shape if we rearrange nodes accordingly.
</details>

---

These MCQs cover all the topics you listed. Would you like me to add more questions on any specific subtopic, or provide a full answer key with detailed step‑by‑step solutions for the trickier ones?