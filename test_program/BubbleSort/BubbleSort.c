#include <stdio.h>

int main() {
    int n = 7;
    int array[] = {10,5,7,3,4,2,1};
    for (int i = 0; i < n - 1; i++) {
        for (int j = i; j < n - 1; j++) {
            if (array[j] < array[j+1]) {
                int temp = array[j+1];
                array[j+1] = array[j];
                array[j] = temp;
            }
        }
    }
    return 0;
}