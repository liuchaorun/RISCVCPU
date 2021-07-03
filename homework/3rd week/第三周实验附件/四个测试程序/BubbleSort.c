#include <stdio.h>

int main() {
    int n = 10;
    int array[] = {10, 9, 8, 7, 6, 1, 2 ,3, 4, 5};
    for (int i = 0; i < n - 1; i++) {
        for (int j = i; j < n - 1; j++) {
            if (array[j] >= array[j+1]) {
                int temp = array[j+1];
                array[j+1] = array[j];
                array[j] = temp;
            }
        }
    }
    printf("the first element is %d.\n", array[0]);
    return 0;
}