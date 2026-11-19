n = int(input())
while(n):
    n-=1
    m=int(input())
    s=input()
    gc=0    
    count =0

    for i in range(len(s)):
        if s[i] == '*':
            gc = max(gc,count)
            count=0
        else:
            count+=1
    gc = max(gc,count)
    if(gc==0):
        print(0)
    elif(gc==1):
        print(1)
    else:
        print(int((gc+1)//2))
