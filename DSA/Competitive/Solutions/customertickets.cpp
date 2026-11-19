#include <bits/stdc++.h>
using namespace std;

int main() {
    int n, m;
    cin >> n >> m;

    multiset<int> tickets;

    for (int i = 0; i < n; i++) {
        int x;
        cin >> x;
        tickets.insert(x);
    }

    while (m--) {
        int customer;
        cin >> customer;

        auto it = tickets.upper_bound(customer);

        if (it == tickets.begin()) {
            cout << -1 << "\n";
        } else {
            --it;
            cout << *it << "\n";
            tickets.erase(it);
        }
    }

    return 0;
}