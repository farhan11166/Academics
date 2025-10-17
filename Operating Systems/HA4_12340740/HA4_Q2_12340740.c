#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#define ARRAY_SIZE 100
#define SEGMENTS 10
#define SEGMENT_SIZE (ARRAY_SIZE / SEGMENTS)
int arr[ARRAY_SIZE];
typedef struct {
    int* arr;
    int start;
} args;
void* partial_sum(void* arg) {
    args* a = (args*)arg;
    int sum = 0;
    for (int i = a->start; i < a->start + SEGMENT_SIZE; ++i) {
        sum += a->arr[i];
    }
    int* result = (int*)malloc(sizeof(int));
    if (result == NULL) {
        return NULL;
    }
    *result = sum;
    return (void*)result;
}
int main(){
    pthread_t threads[SEGMENTS + 1];
    args thread_args[SEGMENTS]; 
    int ids[SEGMENTS + 1] = {0}; 
    int total_sum = 0;

    for (int i = 0; i < ARRAY_SIZE; i++) {
        arr[i] = i + 1;
    }
    for (int i = 0; i < SEGMENTS; i++) {
        thread_args[i].arr = arr; 
        thread_args[i].start = i * SEGMENT_SIZE;    
        pthread_create(&threads[i], NULL, partial_sum, &thread_args[i]);
    }
    for (int i = 0; i < SEGMENTS; i++){
        void* partial_result_ptr;
        pthread_join(threads[i], &partial_result_ptr);
        ids[i] = *((int*)partial_result_ptr);
        total_sum += ids[i];   
        free(partial_result_ptr);
    }
    ids[SEGMENTS] = total_sum;
    for(int i = 0; i < SEGMENTS; i++){
        printf("Thread %d partial sum is : %d \n", i + 1, ids[i]);

    }
    printf("Final total sum = %d\n", ids[SEGMENTS]);
    printf("Average = %.2f\n", (float)ids[SEGMENTS]/ (float)ARRAY_SIZE);

    
    return 0;
}