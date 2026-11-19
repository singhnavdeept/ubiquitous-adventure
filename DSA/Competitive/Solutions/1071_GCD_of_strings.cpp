#include<string>
#include<iostream>
#include<numeric>
using namespace std;
int  main(){
    string s = "ABSABS";
    string t = "ABS";
    string res ="";
    if(s+t != t+s){
        cout<<"";
    }
    int l =gcd(s.length(),t.length());

    res=s.substr(0,l);

    cout<<res;
    return 0;
}