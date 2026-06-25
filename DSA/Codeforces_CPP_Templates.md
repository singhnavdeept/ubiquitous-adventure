# Codeforces C++ Templates Master Sheet

This cheat sheet serves as a companion to your Codeforces Master Tracker. These templates are optimized for competitive programming (CP), focusing on speed, brevity, and correctness.

---

## 🚀 0. The Ultimate CP Boilerplate
Every Codeforces solution should start with this to optimize I/O speed and define standard macros.

```cpp
#include <bits/stdc++.h>
using namespace std;

#define fastio ios_base::sync_with_stdio(false); cin.tie(NULL); cout.tie(NULL)
#define ll long long
#define pb push_back
#define all(x) (x).begin(), (x).end()

const int MOD = 1e9 + 7;
const ll INF = 1e18;

void solve() {
    // Write your logic here
}

int main() {
    fastio;
    int t = 1;
    cin >> t; // Remove if single test case
    while (t--) {
        solve();
    }
    return 0;
}
```

---

## 🔢 1. Math & Number Theory

### Sieve of Eratosthenes (Primes)
```cpp
const int N = 100005;
vector<bool> is_prime(N + 1, true);
void sieve() {
    is_prime[0] = is_prime[1] = false;
    for (int i = 2; i * i <= N; i++) {
        if (is_prime[i]) {
            for (int j = i * i; j <= N; j += i)
                is_prime[j] = false;
        }
    }
}
```

### Modular Exponentiation ($a^b \pmod m$)
```cpp
ll power(ll base, ll exp) {
    ll res = 1;
    base %= MOD;
    while (exp > 0) {
        if (exp % 2 == 1) res = (res * base) % MOD;
        base = (base * base) % MOD;
        exp /= 2;
    }
    return res;
}
```

---

## 🔍 2. Binary Search

### Binary Search on Answer (Parametric Search)
```cpp
bool check(int mid) {
    // Condition logic goes here
    return true; 
}

int binarySearchOnAnswer(int low, int high) {
    int ans = -1;
    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (check(mid)) {
            ans = mid;     // Record answer
            low = mid + 1; // Try to find a larger/smaller valid mid
        } else {
            high = mid - 1;
        }
    }
    return ans;
}
```

---

## 🧮 3. Prefix Sums & Difference Arrays

### 1D Difference Array (Range Updates)
Used for $O(1)$ range additions: `add(L, R, X)`
```cpp
vector<int> diff(n + 2, 0);

// Add val to range [L, R]
void add(int L, int R, int val) {
    diff[L] += val;
    diff[R + 1] -= val;
}

// Reconstruct original array after all updates
void build() {
    for (int i = 1; i <= n; i++) {
        diff[i] += diff[i - 1];
    }
}
```

### 2D Prefix Sums
```cpp
// Building
for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= m; j++) {
        pref[i][j] = grid[i][j] + pref[i-1][j] + pref[i][j-1] - pref[i-1][j-1];
    }
}

// Query sum of rectangle from (r1, c1) to (r2, c2)
ll query(int r1, int c1, int r2, int c2) {
    return pref[r2][c2] - pref[r1-1][c2] - pref[r2][c1-1] + pref[r1-1][c1-1];
}
```

---

## 🧱 4. Stacks & Queues

### Monotonic Stack (Next Greater Element)
```cpp
vector<int> nextGreaterElement(vector<int>& arr) {
    int n = arr.size();
    vector<int> nge(n, -1);
    stack<int> st; // Stores indices
    
    for (int i = 0; i < n; i++) {
        while (!st.empty() && arr[st.top()] < arr[i]) {
            nge[st.top()] = arr[i];
            st.pop();
        }
        st.push(i);
    }
    return nge;
}
```

---

## 🌲 5. Trees

### Lowest Common Ancestor (Binary Lifting)
```cpp
const int LOG = 20;
vector<int> depth(N);
int up[N][LOG]; // up[v][j] is 2^j-th ancestor of v

void dfs(int u, int p) {
    up[u][0] = p;
    for (int j = 1; j < LOG; j++) {
        up[u][j] = up[ up[u][j-1] ][j-1];
    }
    for (int v : adj[u]) {
        if (v != p) {
            depth[v] = depth[u] + 1;
            dfs(v, u);
        }
    }
}

int getLCA(int u, int v) {
    if (depth[u] < depth[v]) swap(u, v);
    int k = depth[u] - depth[v];
    for (int j = LOG - 1; j >= 0; j--) {
        if (k & (1 << j)) u = up[u][j];
    }
    if (u == v) return u;
    for (int j = LOG - 1; j >= 0; j--) {
        if (up[u][j] != up[v][j]) {
            u = up[u][j];
            v = up[v][j];
        }
    }
    return up[u][0];
}
```

---

## 🌳 6. Segment Trees & BIT

### Fenwick Tree (Binary Indexed Tree)
For Point Update and Range Query.
```cpp
struct BIT {
    int n;
    vector<ll> tree;
    BIT(int n) { this->n = n; tree.assign(n + 1, 0); }
    
    void add(int i, ll delta) {
        for (; i <= n; i += i & -i) tree[i] += delta;
    }
    
    ll query(int i) {
        ll sum = 0;
        for (; i > 0; i -= i & -i) sum += tree[i];
        return sum;
    }
};
```

### Segment Tree (Point Update)
```cpp
struct SegTree {
    int n;
    vector<ll> tree;
    SegTree(int n) { this->n = n; tree.assign(4 * n, 0); }
    
    void update(int node, int start, int end, int idx, ll val) {
        if (start == end) { tree[node] = val; return; }
        int mid = (start + end) / 2;
        if (start <= idx && idx <= mid)
            update(2 * node, start, mid, idx, val);
        else
            update(2 * node + 1, mid + 1, end, idx, val);
        tree[node] = tree[2 * node] + tree[2 * node + 1]; // Combine operation
    }
    
    ll query(int node, int start, int end, int l, int r) {
        if (r < start || end < l) return 0; // Identity value
        if (l <= start && end <= r) return tree[node];
        int mid = (start + end) / 2;
        ll p1 = query(2 * node, start, mid, l, r);
        ll p2 = query(2 * node + 1, mid + 1, end, l, r);
        return p1 + p2; // Combine operation
    }
};
```

---

## 🔤 7. Strings

### Z-Function (Pattern Matching)
Computes $z[i]$, the length of the longest substring starting at $i$ which is also a prefix of $S$.
```cpp
vector<int> z_function(string s) {
    int n = s.length();
    vector<int> z(n);
    for (int i = 1, l = 0, r = 0; i < n; ++i) {
        if (i <= r) z[i] = min(r - i + 1, z[i - l]);
        while (i + z[i] < n && s[z[i]] == s[i + z[i]]) ++z[i];
        if (i + z[i] - 1 > r) {
            l = i; r = i + z[i] - 1;
        }
    }
    return z;
}
```

---

## 🔄 8. Disjoint Set Union (DSU)

```cpp
struct DSU {
    vector<int> parent, size;
    DSU(int n) {
        parent.resize(n); size.assign(n, 1);
        for (int i = 0; i < n; i++) parent[i] = i;
    }
    int find(int x) {
        if (parent[x] == x) return x;
        return parent[x] = find(parent[x]); // Path compression
    }
    bool unite(int x, int y) {
        int rx = find(x), ry = find(y);
        if (rx == ry) return false;
        if (size[rx] < size[ry]) swap(rx, ry);
        parent[ry] = rx;
        size[rx] += size[ry];
        return true;
    }
};
```

---

## 📐 9. Geometry

### Cross Product / Orientation
```cpp
struct Point {
    ll x, y;
};

// Returns > 0 if CCW, < 0 if CW, 0 if collinear
ll crossProduct(Point a, Point b, Point c) {
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
}
```
