#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>
#include <limits.h>

#define ARRAY_SIZE 100
#define NUM_WORKER_THREADS 10
#define NUM_TOTAL_THREADS (NUM_WORKER_THREADS + 1)
#define SEGMENT_SIZE (ARRAY_SIZE / NUM_WORKER_THREADS)

int numbers[ARRAY_SIZE];

int segment_maxima[NUM_WORKER_THREADS];

typedef struct {
    int thread_id;
    int start_index;
    int end_index;
} thread_data_t;

void* find_segment_max(void* arg) {
    thread_data_t* data = (thread_data_t*)arg;
    int local_max = INT_MIN;
    
    for (int i = data->start_index; i < data->end_index; i++) {
        if (numbers[i] > local_max) {
            local_max = numbers[i];
        }
    }

    segment_maxima[data->thread_id - 1] = local_max;

    printf("Thread %2d max: %3d (Segment Indices %3d to %3d)\n", 
           data->thread_id, 
           local_max, 
           data->start_index, 
           data->end_index - 1);
           
    pthread_exit(NULL);
}

void* find_overall_max(void* arg) {
    
    int overall_max = INT_MIN;

    for (int i = 0; i < NUM_WORKER_THREADS; i++) {
        if (segment_maxima[i] > overall_max) {
            overall_max = segment_maxima[i];
        }
    }
    
    return (void*)(long)overall_max;
}


int main() {
    pthread_t worker_threads[NUM_WORKER_THREADS];
    pthread_t coordinator_thread;
    thread_data_t worker_data[NUM_WORKER_THREADS];
    
    srand(time(NULL));

    printf("--- Initializing Array with Random Values (1 to 100) ---\n");
    for (int i = 0; i < ARRAY_SIZE; i++) {
        numbers[i] = (rand() % 100) + 1;
    }
    printf("Array initialized. Total size: %d elements.\n\n", ARRAY_SIZE);

    for (int i = 0; i < NUM_WORKER_THREADS; i++) {
        worker_data[i].thread_id = i + 1;
        worker_data[i].start_index = i * SEGMENT_SIZE;
        worker_data[i].end_index = (i + 1) * SEGMENT_SIZE;
        
        pthread_create(&worker_threads[i], 
                       NULL, 
                       find_segment_max, 
                       &worker_data[i]);
    }
    
    for (int i = 0; i < NUM_WORKER_THREADS; i++) {
        pthread_join(worker_threads[i], NULL);
    }
    
    printf("\n--- Worker threads finished and results collected ---\n\n");
    
    void* coordinator_result;
    
    pthread_create(&coordinator_thread, 
                   NULL, 
                   find_overall_max, 
                   NULL);
                   
    pthread_join(coordinator_thread, &coordinator_result);
    
    int overall_max = (int)(long)coordinator_result;

    printf("Overall max: %d\n", overall_max);
    
    return 0;
}
