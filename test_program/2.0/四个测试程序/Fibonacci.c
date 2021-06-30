#include <stdio.h>

int main(){
    int n = 5;
    int fib = 0;
    
    if(n == 1) fib = 0;
    else if(n == 2) fib = 1;
    else {
        int i = 0;
        int j = 1;
        int k;
        for(k = 3; k <= n; k++){
            fib = i + j;
            i = j;
            j = fib;
        }
    }

    printf("The %d of fobonacci is：%d.\n", n, fib);
}