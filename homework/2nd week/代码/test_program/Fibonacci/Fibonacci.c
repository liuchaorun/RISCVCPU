#include <stdio.h>

int ReFib(int n){
    if(n == 1) return 0;
    if(n == 2) return 1;
    return ReFib(n-1) + ReFib(n-2);
}

int ItFib(int n){
    if(n == 1) return 0;
    if(n == 2) return 1;

    int i = 0;
    int j = 1;
    int k, fib;
    for(k = 3; k <= n; k++){
        fib = i + j;
        i = j;
        j = fib;
    }
    return fib;
}

int main(){
    int n = 5;

    int ReFibN = ReFib(n);

    int ItFibN = ItFib(n);

    printf("（递归）第%d个斐波那契数为：%d\n", n, ReFibN);
    printf("（迭代）第%d个斐波那契数为：%d\n", n, ItFibN);
}