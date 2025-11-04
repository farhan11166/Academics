#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <stdlib.h>

#define MAX_JOBS 5
#define NUM_WORKERS 3
#define TOTAL_JOBS 10

int jobs[MAX_JOBS];
int count = 0;
int done = 0;  // Flag to indicate dispatcher is finished

// Synchronization primitives
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t not_full = PTHREAD_COND_INITIALIZER;
pthread_cond_t not_empty = PTHREAD_COND_INITIALIZER;

void *dispatcher(void *arg) {
    int job_id = 1;

    while (job_id <= TOTAL_JOBS) {
        pthread_mutex_lock(&lock);

        // Wait if buffer is full
        while (count == MAX_JOBS) {
            printf("Dispatcher: Buffer full, waiting.\n");
            pthread_cond_wait(&not_full, &lock);
        }

        // Produce a job
        jobs[count++] = job_id;
        printf("Dispatcher added job %d (count=%d)\n", job_id, count);

        // Signal that the buffer is not empty
        pthread_cond_signal(&not_empty);

        pthread_mutex_unlock(&lock);

        job_id++;
        usleep(100000); // Simulate time between dispatching jobs
    }

    // Mark as done
    pthread_mutex_lock(&lock);
    done = 1;
    pthread_cond_broadcast(&not_empty); // Wake up all waiting workers
    pthread_mutex_unlock(&lock);

    printf("Dispatcher finished dispatching %d jobs.\n", TOTAL_JOBS);
    return NULL;
}

void *worker(void *arg) {
    long id = (long)arg;

    while (1) {
        pthread_mutex_lock(&lock);

        // Wait while buffer is empty and dispatcher not done
        while (count == 0 && !done) {
            printf("Worker %ld: Buffer empty, waiting.\n", id);
            pthread_cond_wait(&not_empty, &lock);
        }

        // If no jobs and dispatcher done, exit
        if (count == 0 && done) {
            pthread_mutex_unlock(&lock);
            printf("Worker %ld: No more jobs, exiting.\n", id);
            break;
        }

        // Consume a job
        int job = jobs[--count];
        printf("Worker %ld processing job %d (remaining=%d)\n", id, job, count);

        // Signal that the buffer is not full
        pthread_cond_signal(&not_full);

        pthread_mutex_unlock(&lock);

        usleep(200000); // Simulate job processing time
    }

    return NULL;
}

int main() {
    pthread_t disp, workers[NUM_WORKERS];

    // Create dispatcher and worker threads
    pthread_create(&disp, NULL, dispatcher, NULL);
    for (long i = 0; i < NUM_WORKERS; i++)
        pthread_create(&workers[i], NULL, worker, (void *)i);

    // Wait for dispatcher to finish
    pthread_join(disp, NULL);

    // Wait for all workers to finish gracefully
    for (int i = 0; i < NUM_WORKERS; i++)
        pthread_join(workers[i], NULL);

    // Cleanup
    pthread_mutex_destroy(&lock);
    pthread_cond_destroy(&not_full);
    pthread_cond_destroy(&not_empty);

    printf("All jobs processed. Exiting...\n");
    return 0;
}
