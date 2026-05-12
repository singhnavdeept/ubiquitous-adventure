#include<string>
#include<iostream>
using namespace std;
int main(){
    string word1 = "";
    string  word2 = "";
    int m =word1.length();
        int n= word2.length();
        string res ="";
        int i ,j=0;
        while(i<m || j<n){
            if(i<m){
                res+= word1[i++];
            }
            if(j<n){
                res+=word2[j++];
            }
        }
    cout<<res;
    return 0;
}