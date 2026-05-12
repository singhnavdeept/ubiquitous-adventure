#include<bits/stdc++.h>
using namespace std;
#define ll  long long 

int main(){
    int n;
    cin>>n;
    ll count=0;
    ll prev=0;
    for(int i=0;i<n;i++){
        ll curr=0;
        cin>>curr;
        prev = max(prev,curr);
        count += prev-curr;
    }
    cout<<count;
    return 0;

}