import java.io.*;
import java.util.*;

public class Apartments{
    public static void main(String[] args)throws IOException{
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());
        int n = Integer.parseInt(st.nextToken());
        int m = Integer.parseInt(st.nextToken());
        int k = Integer.parseInt(st.nextToken());


        long[] applicants = new long[n];
        long[] available = new long[m];
        st = new StringTokenizer(br.readLine());
        for(int i =0;i<n;i++){
            applicants[i] = Long.parseLong(st.nextToken());

        }
        st = new StringTokenizer(br.readLine());
        for(int i = 0;i<m;i++){
            available[i]=Long.parseLong(st.nextToken());
        }
        int count =0;
        int i =0;
        int j =0;
        Arrays.sort(applicants);
        Arrays.sort(available);
        while(i<n && j<m){
            long lower = applicants[i]-k;
            long upper = applicants[i]+k;
            if(available[j] <lower){
                j++;
            }
            else if(available[j]>upper){
                i++;
            }else{
                count++;
                i++;
                j++;
            }
        }
        System.out.println(count);
    }
}