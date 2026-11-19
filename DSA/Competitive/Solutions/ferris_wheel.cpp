#include<bits/stdc++.h>
using namespace std;
int main(){
    int n ;
    cin>>n;
    int m ;
    cin>>m;
    vector<int>v(n);
    for(int i =0;i<n;i++){
        cin>>v[i];
    }
    int l=0;
    int r = n-1;
    int noofboat=0;
    sort(v.begin(),v.end());
    while(l<r){
        if(v[l]+v[r]<=m){
            noofboat++;
            l++;
            r--;
        }
        else{
            noofboat++;
            r--;
        }
    }
    if (l==r){
        noofboat++;
    }
    cout<<noofboat;
    return 0;
}