#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_LOGS 10

char *log_buffer[MAX_LOGS];
int count = 0;

// ADD YOUR CODE HERE
// Synchronization Primitives
pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t not_full = PTHREAD_COND_INITIALIZER;  // Condition for producers (workers)
pthread_cond_t not_empty = PTHREAD_COND_INITIALIZER; // Condition for consumer (logger)


void *worker(void *id) {
    for (int i = 0; i < 3; i++) {
        char msg[64];
        sprintf(msg, "Worker %ld message %d", (long)id, i);
        
        // ADD YOUR CODE HERE (Producer Logic)
        pthread_mutex_lock(&lock);
        
        // 1. Wait if the buffer is full
        while (count == MAX_LOGS) {
            printf("Worker %ld: Buffer full, waiting.\n", (long)id);
            pthread_cond_wait(&not_full, &lock);
        }

        // 2. Produce item (log message)
        log_buffer[count++] = strdup(msg);
        printf("Worker %ld queued log. (count=%d)\n", (long)id, count);
        
        // 3. Signal the consumer that the buffer is not empty
        pthread_cond_signal(&not_empty);
        
        pthread_mutex_unlock(&lock);
        // ADD YOUR CODE HERE
        
        usleep(100000); 
    }
    return NULL;
}

void *logger(void *arg) {
    FILE *f = fopen("log.txt", "w");
    if (!f) {
        perror("fopen");
        return NULL;
    }

    while (1) {
        // ADD YOUR CODE HERE (Consumer Logic)
        pthread_mutex_lock(&lock);
        
        // 1. Wait if the buffer is empty
        while (count == 0) {
            printf("Logger: Buffer empty, waiting.\n");
            pthread_cond_wait(&not_empty, &lock);
        }
        
        // 2. Consume item (log message)
        char *msg = log_buffer[--count];
        // ADD YOUR CODE HERE
        
        // 3. Signal the producer that the buffer is not full
        pthread_cond_signal(&not_full);
        
        pthread_mutex_unlock(&lock);
        
        // Write outside the critical section (optional, but good practice)
        fprintf(f, "%s\n", msg);
        fflush(f);
        printf("Logger wrote: %s\n", msg);

        free(msg);
        usleep(50000); 
    }

    fclose(f);
    return NULL;
}

int main() {
    pthread_t log_thread, workers[3];
    pthread_create(&log_thread, NULL, logger, NULL);
    for (long i = 0; i < 3; i++)
        pthread_create(&workers[i], NULL, worker, (void *)i);

    for (int i = 0; i < 3; i++)
        pthread_join(workers[i], NULL);

    sleep(1);

    // Cancel and join the logger thread after all workers are done
    pthread_cancel(log_thread); 
    pthread_join(log_thread, NULL);

    // Clean up synchronization primitives (Good practice)
    pthread_mutex_destroy(&lock);
    pthread_cond_destroy(&not_full);
    pthread_cond_destroy(&not_empty);

    printf("\nAll workers finished. Check 'log.txt' for output.\n");
    return 0;
}