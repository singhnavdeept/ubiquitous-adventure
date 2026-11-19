#include<bits/stdc++.h>
using namespace std;
int main (){
    int n;
    cin>>n;
    int k ;
    cin>>k;
    double r = ceil(double(k)/double(n));
    int a1=INT_MIN;
    int a2=INT_MAX;
    while(n--){
        int ele;
        cin>>ele;
        a1= max(a1,ele);
        a2=min(a2,ele);
    }
    
    cout<<a2+r<<" "<<a1+k;
    return 0;
}