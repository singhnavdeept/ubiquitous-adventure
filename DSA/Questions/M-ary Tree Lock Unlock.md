
---

# Step 1 — Problem Statement

You are given an M-ary tree.

Support:

```python
lock(node, uid)
unlock(node, uid)
upgrade(node, uid)
```

Rules:

## lock(node, uid)

Allowed only if:

- node itself unlocked
    
- no locked ancestor
    
- no locked descendant
    

---

## unlock(node, uid)

Allowed only if:

- node locked
    
- same uid locked it
    

---

## upgrade(node, uid)

Allowed only if:

- node unlocked
    
- has at least one locked descendant
    
- all locked descendants belong to same uid
    
- no locked ancestors
    

Then:

- unlock all descendants
    
- lock current node
    

---

# PHASE 1 — Brute Force Solution

---

# Core Idea

For every operation:

- walk upward for ancestors
    
- DFS downward for descendants
    

Simple but slower.

---

# Brute Force Node Structure

```python
class Node:
    def __init__(self, name):
        self.name = name
        self.parent = None
        self.children = []

        self.is_locked = False
        self.uid = -1
```

---

# Full Brute Force Implementation

```python
class Node:
    def __init__(self, name):
        self.name = name
        self.parent = None
        self.children = []

        self.is_locked = False
        self.uid = -1


class LockingTree:

    def __init__(self, root):
        self.root = root
        self.nodes = {}

    def add_node(self, node):
        self.nodes[node.name] = node

    # -----------------------------
    # CHECK LOCKED ANCESTOR
    # -----------------------------
    def has_locked_ancestor(self, node):

        current = node.parent

        while current:

            if current.is_locked:
                return True

            current = current.parent

        return False

    # -----------------------------
    # CHECK LOCKED DESCENDANT
    # -----------------------------
    def has_locked_descendant(self, node):

        stack = [node]

        while stack:

            current = stack.pop()

            for child in current.children:

                if child.is_locked:
                    return True

                stack.append(child)

        return False

    # -----------------------------
    # LOCK
    # -----------------------------
    def lock(self, name, uid):

        node = self.nodes[name]

        if node.is_locked:
            return False

        if self.has_locked_ancestor(node):
            return False

        if self.has_locked_descendant(node):
            return False

        node.is_locked = True
        node.uid = uid

        return True

    # -----------------------------
    # UNLOCK
    # -----------------------------
    def unlock(self, name, uid):

        node = self.nodes[name]

        if not node.is_locked:
            return False

        if node.uid != uid:
            return False

        node.is_locked = False
        node.uid = -1

        return True

    # -----------------------------
    # GET LOCKED DESCENDANTS
    # -----------------------------
    def get_locked_descendants(self, node):

        locked = []

        stack = [node]

        while stack:

            current = stack.pop()

            for child in current.children:

                if child.is_locked:
                    locked.append(child)

                stack.append(child)

        return locked

    # -----------------------------
    # UPGRADE
    # -----------------------------
    def upgrade(self, name, uid):

        node = self.nodes[name]

        if node.is_locked:
            return False

        if self.has_locked_ancestor(node):
            return False

        locked_descendants = self.get_locked_descendants(node)

        if len(locked_descendants) == 0:
            return False

        for descendant in locked_descendants:

            if descendant.uid != uid:
                return False

        for descendant in locked_descendants:

            descendant.is_locked = False
            descendant.uid = -1

        node.is_locked = True
        node.uid = uid

        return True
```

---

# Complexity Analysis (Brute Force)

|Operation|Complexity|
|---|---|
|lock|O(N)|
|unlock|O(1)|
|upgrade|O(N)|

Why?

- descendant traversal may scan subtree
    

---

# Common Bugs Here

## Bug 1

Forgetting to check ancestor lock.

---

## Bug 2

Unlocking descendants before validation completes.

BAD:

```python
unlock first
then validate
```

If validation fails:

- state corrupted.
    

---

## Bug 3

Using recursion carelessly.

Deep trees can cause recursion depth issues.

Prefer iterative DFS.

---

# PHASE 2 — Optimized Solution

Now we evolve like an interviewer expects.

---

# Optimization Insight

Checking descendants repeatedly is expensive.

So maintain:

```python
locked_descendant_count
```

for each node.

---

# Optimized Node

```python
class Node:

    def __init__(self, name):

        self.name = name
        self.parent = None
        self.children = []

        self.is_locked = False
        self.uid = -1

        self.locked_descendant_count = 0
```

---

# Important Invariant

For every node:

```text
locked_descendant_count
=
number of locked nodes in subtree
excluding itself
```

---

# Updating Ancestors

Whenever locking:

```python
current = node.parent

while current:
    current.locked_descendant_count += 1
    current = current.parent
```

Whenever unlocking:  
decrement similarly.

---

# FULL OPTIMIZED IMPLEMENTATION

```python
class Node:

    def __init__(self, name):

        self.name = name
        self.parent = None
        self.children = []

        self.is_locked = False
        self.uid = -1

        self.locked_descendant_count = 0


class LockingTree:

    def __init__(self, root):

        self.root = root
        self.nodes = {}

    def add_node(self, node):
        self.nodes[node.name] = node

    # -------------------------
    # CHECK ANCESTOR
    # -------------------------
    def has_locked_ancestor(self, node):

        current = node.parent

        while current:

            if current.is_locked:
                return True

            current = current.parent

        return False

    # -------------------------
    # UPDATE ANCESTORS
    # -------------------------
    def update_ancestors(self, node, value):

        current = node.parent

        while current:

            current.locked_descendant_count += value

            current = current.parent

    # -------------------------
    # LOCK
    # -------------------------
    def lock(self, name, uid):

        node = self.nodes[name]

        if node.is_locked:
            return False

        if self.has_locked_ancestor(node):
            return False

        if node.locked_descendant_count > 0:
            return False

        node.is_locked = True
        node.uid = uid

        self.update_ancestors(node, 1)

        return True

    # -------------------------
    # UNLOCK
    # -------------------------
    def unlock(self, name, uid):

        node = self.nodes[name]

        if not node.is_locked:
            return False

        if node.uid != uid:
            return False

        node.is_locked = False
        node.uid = -1

        self.update_ancestors(node, -1)

        return True

    # -------------------------
    # COLLECT LOCKED DESCENDANTS
    # -------------------------
    def collect_locked_descendants(self, node):

        locked = []

        stack = [node]

        while stack:

            current = stack.pop()

            for child in current.children:

                if child.is_locked:
                    locked.append(child)

                if child.locked_descendant_count > 0:
                    stack.append(child)

        return locked

    # -------------------------
    # UPGRADE
    # -------------------------
    def upgrade(self, name, uid):

        node = self.nodes[name]

        if node.is_locked:
            return False

        if self.has_locked_ancestor(node):
            return False

        if node.locked_descendant_count == 0:
            return False

        locked_descendants = self.collect_locked_descendants(node)

        for descendant in locked_descendants:

            if descendant.uid != uid:
                return False

        for descendant in locked_descendants:

            descendant.is_locked = False
            descendant.uid = -1

            self.update_ancestors(descendant, -1)

        node.is_locked = True
        node.uid = uid

        self.update_ancestors(node, 1)

        return True
```

---

# Complexity Analysis (Optimized)

|Operation|Complexity|
|---|---|
|lock|O(height)|
|unlock|O(height)|
|upgrade|O(locked descendants + height)|

Massive improvement.

---

# Interviewer Follow-Up Questions

---

# Q1

Why not use DFS every time?

Answer:

```text
Repeated subtree traversal becomes expensive.
Maintaining metadata converts repeated O(N)
checks into O(height).
```

---

# Q2

Why parent pointers?

Answer:

```text
Efficient upward traversal for ancestor checks
and metadata propagation.
```

---

# Q3

Can locked_descendant_count become inconsistent?

Answer:

```text
Yes, if updates are not symmetric during
lock/unlock/upgrade.
```

This is important.

---

# PHASE 3 — Thread Safety Discussion

Now comes the scary part.

---

# Problem

Two threads may simultaneously execute:

```python
lock(A)
lock(B)
```

and violate invariants.

---

# Example Race Condition

Thread 1:

```text
checks ancestor
```

Thread 2:

```text
locks ancestor
```

Thread 1:

```text
locks child
```

Broken state.

---

# What Interviewers Expect

Not production perfection.

They want:

- awareness
    
- reasoning
    
- tradeoffs
    

---

# Discussion Points

---

# Solution 1 — Global Lock

Simplest.

```python
tree_mutex.acquire()

perform operation

tree_mutex.release()
```

Pros:

- easy
    
- safe
    

Cons:

- poor parallelism
    

---

# Solution 2 — Node-Level Locks

Each node has mutex.

Need careful ordering:

- always lock top → down
    

Otherwise deadlock possible.

---

# Deadlock Example

Thread A:

```text
locks parent
waiting child
```

Thread B:

```text
locks child
waiting parent
```

Deadlock.

---

# Prevention

Always acquire locks in deterministic order.

Usually:

```text
root → target
```

---

# Important Terms To Know

|Term|Meaning|
|---|---|
|race condition|state depends on timing|
|deadlock|threads wait forever|
|starvation|thread never gets CPU/resource|
|critical section|code needing synchronization|
|atomicity|indivisible execution|

---

# Mock Interview Simulation

---

# Interviewer

Why optimize descendants instead of ancestors?

---

# Good Answer

```text
Ancestor traversal is bounded by tree height,
but descendant traversal may become O(N).
So optimizing descendant checks gives better gain.
```

---

# Interviewer

Can upgrade become inconsistent?

---

# Good Answer

```text
Yes.
If descendant unlocking partially succeeds
before validation completes,
tree invariants may break.
Validation should finish before mutation begins.
```

---

# Interviewer

Can multiple upgrades happen simultaneously?

---

# Good Answer

```text
Yes, which can cause race conditions
while reading/updating metadata.
Synchronization is needed around validation
and mutation phases.
```

---

# Most Important Engineering Insight

Separate:

```text
VALIDATION
```

from:

```text
STATE MUTATION
```

This prevents half-broken states.

Interviewers LOVE this.

---

# Stress Test Cases

---

# Case 1

```text
lock(A,1)
lock(A,2)
```

Expected:

```text
True
False
```

---

# Case 2

```text
lock(B,1)
lock(parent(B),1)
```

Expected:

```text
True
False
```

---

# Case 3

```text
lock(C,1)
upgrade(parent(C),1)
```

Expected:

```text
True
True
```

---

# Case 4

Mixed ownership:

```text
lock(D,1)
lock(E,2)
upgrade(parent,1)
```

Expected:

```text
False
```

---

# Coding Advice During Interview

---

# DO

- explain invariants
    
- explain metadata
    
- start brute force
    
- optimize gradually
    
- narrate debugging
    

---

# DON’T

- jump to overengineering
    
- silently code
    
- ignore edge cases
    
- mutate before validation
    

---

# Final High-Value Insight

This interview is less about:

```text
competitive programming tricks
```

and more about:

```text
maintaining consistent state under evolving constraints
```

That’s why strong debugging and systems thinkers often outperform pure LeetCode grinders here.


Yes.  
And this is actually the smartest thing to prepare now.

For Juspay, once you finish the base implementation, interviewers usually branch into:

- optimization
    
- concurrency
    
- edge cases
    
- redesign
    
- debugging
    
- scalability
    

Below is a VERY realistic list of questions they can ask.

---

# SECTION 1 — Core Tree Questions

These are almost guaranteed.

---

# Q1 — Explain Your Approach

They want:

- invariants
    
- metadata
    
- complexity
    

Good answer structure:

```text
1. Explain constraints
2. Explain brute force
3. Explain bottleneck
4. Explain optimization
5. Explain complexity
```

---

# Q2 — Why Store Parent Pointer?

Expected answer:

```text
Efficient ancestor traversal and metadata propagation.
Without parent pointers,
ancestor checks become expensive.
```

---

# Q3 — Why locked_descendant_count?

Expected:

```text
It avoids repeated DFS traversal for descendant checks.
```

---

# Q4 — Complexity Analysis

You should know instantly:

|Operation|Complexity|
|---|---|
|lock|O(height)|
|unlock|O(height)|
|upgrade|O(k + height)|

where:

```text
k = number of locked descendants
```

---

# Q5 — Why Upgrade Is Difficult?

Expected:

```text
Because it requires validation across descendants
before mutating tree state.
```

---

# SECTION 2 — Edge Cases

VERY common.

---

# Q6 — Upgrade on Locked Node?

Expected:

```text
False
```

---

# Q7 — Unlock by Different User?

Expected:

```text
False
```

---

# Q8 — No Locked Descendants During Upgrade?

Expected:

```text
False
```

---

# Q9 — Mixed UserIDs in Descendants?

Expected:

```text
Upgrade should fail.
```

---

# Q10 — Can Root Be Locked?

Expected:

```text
Yes, if descendants are unlocked.
```

---

# SECTION 3 — Optimization Questions

These are VERY likely.

---

# Q11 — Can Upgrade Be Faster?

Expected discussion:

```text
Maintain direct references to locked descendants.
Tradeoff:
more memory + update complexity.
```

---

# Q12 — Why Not Use Recursion?

Expected:

```text
Deep trees can cause stack overflow / recursion depth issues.
Iterative traversal is safer.
```

---

# Q13 — Can You Reduce Memory?

Expected:

```text
Possible by avoiding extra metadata,
but operations become slower.
```

---

# Q14 — What Happens in Skewed Tree?

Expected:

```text
Height becomes O(N),
so ancestor operations degrade.
```

---

# Q15 — Can You Make Ancestor Check Faster?

Possible discussion:

- binary lifting
    
- Euler tour
    
- segment tree
    

BUT:  
usually overkill unless interviewer pushes hard.

---

# SECTION 4 — Concurrency / Threading Questions

THIS is Round 2 territory.

---

# Q16 — What Race Conditions Exist?

Critical answer:

```text
Validation and mutation are separate steps.
Another thread may change tree state between them.
```

---

# Q17 — What Must Be Atomic?

Expected:

```text
Entire lock/unlock/upgrade operations.
```

---

# Q18 — Simplest Thread-Safe Design?

Expected:

```python
global_mutex
```

Protect all operations.

---

# Q19 — Why Is Global Lock Bad?

Expected:

|Good|Bad|
|---|---|
|easy correctness|poor concurrency|
|simple|blocks whole tree|

---

# Q20 — Better Alternative?

Expected:

```text
Node-level locking.
```

---

# Q21 — What Deadlock Can Happen?

Classic answer:

Thread A:

```text
locks parent
waiting child
```

Thread B:

```text
locks child
waiting parent
```

---

# Q22 — How Avoid Deadlock?

Expected:

```text
Acquire locks in deterministic order.
Example: root → leaf.
```

---

# Q23 — Can Metadata Become Inconsistent?

Expected:

```text
Yes.
If ancestor updates are interrupted or partial.
```

---

# Q24 — Can Two Threads Upgrade Same Subtree?

Expected:

```text
Yes, causing race conditions without synchronization.
```

---

# SECTION 5 — Debugging Questions

VERY important.

---

# Q25 — Find Bug in This Code

They may intentionally:

- forget ancestor update
    
- mutate before validation
    
- forget unlock propagation
    

You must spot invariant violation.

---

# Q26 — Why Is This Failing Randomly?

Usually:

```text
metadata inconsistency
```

or:

```text
race condition
```

---

# Q27 — Add Logging Strategy

Expected:

- operation tracing
    
- lock owner logging
    
- ancestor state logging
    

---

# SECTION 6 — Design Evolution Questions

Very Juspay-like.

---

# Q28 — Support Read Locks + Write Locks

Now discuss:

- shared locks
    
- exclusive locks
    
- reader-writer model
    

---

# Q29 — Distributed Tree?

Now discuss:

- consistency
    
- distributed locking
    
- leader coordination
    

Usually conceptual only.

---

# Q30 — Millions of Nodes?

Expected discussion:

- memory optimization
    
- compressed representation
    
- lazy loading
    

---

# Q31 — Persist Locks Across Restarts?

Expected:

- database
    
- WAL
    
- snapshots
    

---

# SECTION 7 — Coding Variants They Can Ask

These are EXTREMELY possible.

---

# Variant 1 — Return Number of Locked Descendants

Add API:

```python
countLocked(node)
```

Easy with metadata.

---

# Variant 2 — Lock Entire Subtree

New operation:

```python
lockSubtree(node)
```

Need careful propagation.

---

# Variant 3 — Time-Based Expiry

Locks auto-expire after timeout.

Need:

```python
timestamp
```

---

# Variant 4 — Priority Users

Admins override locks.

Need:

```python
role-based rules
```

---

# Variant 5 — Rollback Failed Upgrade

Transactional thinking.

---

# SECTION 8 — VERY Important Interview Sentences

These make you sound strong immediately.

---

# Sentence 1

```text
The critical invariant is that
no locked node may have a locked ancestor or descendant.
```

---

# Sentence 2

```text
Validation should complete before state mutation begins.
```

---

# Sentence 3

```text
The bottleneck is repeated subtree traversal.
```

---

# Sentence 4

```text
Synchronization is needed because validation and mutation are not atomic.
```

---

# Sentence 5

```text
Global locking is simpler,
but finer-grained locking improves concurrency.
```

---

# MOST IMPORTANT THING

They are NOT testing:

```text
competitive programming memorization
```

They ARE testing:

```text
Can this person maintain correctness
while constraints evolve?
```

That’s the entire spirit of the Juspay hackathon rounds.