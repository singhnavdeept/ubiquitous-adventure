Here are the top 5 most frequently asked linked list interview questions, with complete C++ solutions and explanations.

---

## 1. Reverse a Linked List

**Problem:** Given the head of a singly linked list, reverse the list and return its new head.

### Iterative Solution (Most Common)
```cpp
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* curr = head;
        
        while (curr != nullptr) {
            ListNode* nextTemp = curr->next; // store next node
            curr->next = prev;               // reverse current pointer
            prev = curr;                     // move prev forward
            curr = nextTemp;                 // move curr forward
        }
        
        return prev; // new head
    }
};
```

### Recursive Solution
```cpp
class Solution {
public:
    ListNode* reverseList(ListNode* head) {
        if (head == nullptr || head->next == nullptr)
            return head;
        
        ListNode* newHead = reverseList(head->next);
        head->next->next = head;
        head->next = nullptr;
        
        return newHead;
    }
};
```

---

## 2. Detect Cycle (Floyd’s Tortoise and Hare)

**Problem:** Determine if a linked list has a cycle. Return `true` if a cycle exists, otherwise `false`.

```cpp
class Solution {
public:
    bool hasCycle(ListNode *head) {
        if (head == nullptr) return false;
        
        ListNode *slow = head;
        ListNode *fast = head;
        
        while (fast != nullptr && fast->next != nullptr) {
            slow = slow->next;
            fast = fast->next->next;
            
            if (slow == fast)   // cycle detected
                return true;
        }
        
        return false;   // no cycle
    }
};
```

### Find the Start of the Cycle (Follow-up)
```cpp
class Solution {
public:
    ListNode *detectCycle(ListNode *head) {
        ListNode *slow = head, *fast = head;
        
        while (fast && fast->next) {
            slow = slow->next;
            fast = fast->next->next;
            
            if (slow == fast) {
                // cycle found, find the start
                slow = head;
                while (slow != fast) {
                    slow = slow->next;
                    fast = fast->next;
                }
                return slow;
            }
        }
        return nullptr;
    }
};
```

---

## 3. Find Middle of Linked List

**Problem:** Return the middle node of a linked list. If there are two middle nodes, return the second one.

```cpp
class Solution {
public:
    ListNode* middleNode(ListNode* head) {
        ListNode *slow = head;
        ListNode *fast = head;
        
        while (fast != nullptr && fast->next != nullptr) {
            slow = slow->next;
            fast = fast->next->next;
        }
        
        return slow;
    }
};
```

---

## 4. Merge Two Sorted Lists

**Problem:** Merge two sorted linked lists into one sorted list.

### Iterative Solution
```cpp
class Solution {
public:
    ListNode* mergeTwoLists(ListNode* list1, ListNode* list2) {
        // Dummy node to simplify the logic
        ListNode dummy(0);
        ListNode* tail = &dummy;
        
        while (list1 && list2) {
            if (list1->val <= list2->val) {
                tail->next = list1;
                list1 = list1->next;
            } else {
                tail->next = list2;
                list2 = list2->next;
            }
            tail = tail->next;
        }
        
        // Attach the remaining nodes
        tail->next = list1 ? list1 : list2;
        
        return dummy.next;
    }
};
```

### Recursive Solution (Elegant)
```cpp
class Solution {
public:
    ListNode* mergeTwoLists(ListNode* l1, ListNode* l2) {
        if (!l1) return l2;
        if (!l2) return l1;
        
        if (l1->val <= l2->val) {
            l1->next = mergeTwoLists(l1->next, l2);
            return l1;
        } else {
            l2->next = mergeTwoLists(l1, l2->next);
            return l2;
        }
    }
};
```

---

## 5. Remove Nth Node From End of List

**Problem:** Remove the nth node from the end of the list and return its head. (1-indexed, n is valid)

```cpp
class Solution {
public:
    ListNode* removeNthFromEnd(ListNode* head, int n) {
        ListNode dummy(0);
        dummy.next = head;
        
        ListNode* fast = &dummy;
        ListNode* slow = &dummy;
        
        // Move fast ahead by n+1 steps
        for (int i = 0; i <= n; i++) {
            fast = fast->next;
        }
        
        // Move both pointers until fast reaches the end
        while (fast != nullptr) {
            slow = slow->next;
            fast = fast->next;
        }
        
        // Remove the target node
        ListNode* toDelete = slow->next;
        slow->next = slow->next->next;
        delete toDelete;  // optional but prevents memory leak
        
        return dummy.next;
    }
};
```

---

## Helper Code for Testing (ListNode Definition)

```cpp
struct ListNode {
    int val;
    ListNode *next;
    ListNode() : val(0), next(nullptr) {}
    ListNode(int x) : val(x), next(nullptr) {}
    ListNode(int x, ListNode *next) : val(x), next(next) {}
};

// Helper to create a linked list from vector
ListNode* createList(const vector<int>& vals) {
    ListNode dummy(0);
    ListNode* tail = &dummy;
    for (int val : vals) {
        tail->next = new ListNode(val);
        tail = tail->next;
    }
    return dummy.next;
}

// Helper to print linked list
void printList(ListNode* head) {
    while (head) {
        cout << head->val << " -> ";
        head = head->next;
    }
    cout << "nullptr" << endl;
}
```

---

## Complexity Summary

| Problem | Time Complexity | Space Complexity |
|---------|----------------|------------------|
| Reverse Linked List | O(n) | O(1) iterative |
| Detect Cycle | O(n) | O(1) |
| Find Middle | O(n) | O(1) |
| Merge Two Sorted Lists | O(m+n) | O(1) iterative |
| Remove Nth from End | O(n) | O(1) |

These five problems cover the core linked list manipulation patterns (two-pointer, dummy nodes, recursion, cycle detection) that appear in most technical interviews.