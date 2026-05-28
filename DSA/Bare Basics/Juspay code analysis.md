## Code Analysis: Locking Tree

### Problem Context

This implements a **tree locking system** with three operations — Lock, Unlock, Upgrade — where the core constraint is: _a node can only be locked if no ancestor and no descendant is locked._

---

### Design Choices & Motivation

#### 1. `locked_descendant_count` on every node

**What:** Each node maintains a running count of locked nodes in its subtree.

**Why:** The naive alternative is a full subtree DFS on every `lock()` call to check for locked descendants — O(n) per operation. With this counter, checking descendants is O(1). The tradeoff is that you pay O(depth) to update ancestors on every lock/unlock, which is acceptable since trees are rarely deeper than O(log n) in balanced cases.

**Hidden assumption:** You're betting that depth << subtree size, which is generally true.

---

#### 2. `has_locked_ancestor` walks up the parent chain

**Why not cache this too?** Because ancestor state changes propagate downward (every descendant is affected), making a cache expensive to maintain. Walking up the parent chain is O(depth) and clean.

---

#### 3. `collect_locked_descendants` uses a **pruned DFS**

```python
if child.locked_descendant_count > 0:
    stack.append(child)
```

**Why:** Instead of visiting every node in the subtree, it skips subtrees with `locked_descendant_count == 0`. This is the key optimization — you only traverse "hot paths" toward locked nodes.

**Subtle bug here** (see Issues below).

---

#### 4. Two-pass approach in `upgrade`

First pass: validate all locked descendants belong to `uid`. Second pass: unlock them.

**Why:** Atomicity. If you unlock-as-you-go and then find a foreign uid halfway through, you've already mutated state. Two passes keep it all-or-nothing.

---

### Issues / Bugs

#### 🔴 Bug in `collect_locked_descendants`

```python
for child in current.children:
    if child.is_locked:
        locked.append(child)
    if child.locked_descendant_count > 0:
        stack.append(child)
```

**Problem:** If a child is locked AND has locked descendants, it gets added to `locked` but **not** to the stack — so its subtree's locked nodes are missed.

**Fix:**

```python
for child in current.children:
    if child.is_locked:
        locked.append(child)
    if child.locked_descendant_count > 0:  # should be elif? No — both can be true
        stack.append(child)
```

Change the second `if` to handle both conditions — a locked node can itself have locked descendants below it... wait, actually it **can't** (locking prevents it). So this bug only surfaces if the tree state is somehow inconsistent. Under correct usage this is safe, but it's fragile — a locked node with locked descendants would mean the invariant was already violated. **Still worth noting.**

Actually, re-examining: the real subtle issue is that the initial call does `stack = [node]` but then only iterates over `current.children`, so the **node itself** is never checked for being locked — correct, since you're collecting descendants only.

#### 🟡 `collect_locked_descendants` doesn't add locked children to stack

If a child is locked, it won't be pushed to the stack, so **its** locked descendants (which can't exist due to locking invariant, but still) are skipped. Safe under invariant, but coupling your correctness to an invariant without asserting it is risky.

#### 🟡 No error handling on `self.nodes[name]`

If an invalid name is passed, you get a `KeyError`. In a production system or under adversarial test inputs, this crashes.

---

### Complexity Summary

|Operation|Time|Why|
|---|---|---|
|`lock`|O(depth)|ancestor walk + ancestor update|
|`unlock`|O(depth)|ancestor update|
|`upgrade`|O(locked_descendants + depth)|pruned DFS + updates|

---

### Further Questions You Can Expect

**Clarification / edge cases:**

- What if `upgrade` is called on a leaf with no descendants? _(Handled — returns False if `locked_descendant_count == 0`)_
- Can the same user lock multiple nodes? _(Yes, nothing prevents it)_
- What if a node is its own ancestor? _(Impossible in a tree, but worth stating)_

**Optimization challenges:**

- Can you make `has_locked_ancestor` O(1)? _(You'd need an "ancestor locked count" field, similar to `locked_descendant_count`, updated on every lock/unlock — O(subtree size) update cost, bad tradeoff)_
- What if the tree is a DAG instead of a tree? _(Parent chain walking breaks, multiple paths to root)_

**Design extensions:**

- Add a `lock_with_timeout` — how does expiry interact with the `locked_descendant_count`?
- Support **shared locks** (multiple users can read-lock) vs **exclusive locks**
- How would you persist this tree and its lock state?
- Thread safety: what happens with concurrent `lock()` calls?

**Stress/invariant questions:**

- Prove that `locked_descendant_count` is always consistent. _(Induction: correct on leaf, updates propagate on every state change)_
- Under what conditions can `upgrade` leave the tree in a partially mutated state? _(None, due to two-pass — but the interviewer wants you to articulate this)_
- 