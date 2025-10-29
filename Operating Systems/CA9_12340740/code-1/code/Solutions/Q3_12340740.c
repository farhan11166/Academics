#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

#define BUFFER_SIZE 5

int buffer[BUFFER_SIZE];
int fill_ptr = 0, use_ptr = 0, item_counter = 0;

sem_t empty;   
sem_t full;    
pthread_mutex_t mutex;

int produce_item() {
    return item_counter++;
}

int consume_item(int item) {
    return item;
}

void* producer(void* arg) {
    int id = *(int*)arg;
    for (int i = 0; i < 10; i++) {
        int item = produce_item();
        sem_wait(&empty);            
        pthread_mutex_lock(&mutex);

        buffer[fill_ptr] = item;
        fill_ptr = (fill_ptr + 1) % BUFFER_SIZE;
        printf("Producer %d produced: %d\n", id, item);

        pthread_mutex_unlock(&mutex);
        sem_post(&full);              
    }
    return NULL;
}

void* consumer(void* arg) {
    int id = *(int*)arg;
    for (int i = 0; i < 10; i++) {
        sem_wait(&full);              
        pthread_mutex_lock(&mutex);

        int item = buffer[use_ptr];
        use_ptr = (use_ptr + 1) % BUFFER_SIZE;
        printf("Consumer %d consumed: %d\n", id, item);

        pthread_mutex_unlock(&mutex);
        sem_post(&empty);             
    }
    return NULL;
}

int main() {
    pthread_t prod1, cons1;
    int prod_id = 1, cons_id = 1;

    sem_init(&empty, 0, BUFFER_SIZE);
    sem_init(&full, 0, 0);
    pthread_mutex_init(&mutex, NULL);

    printf("Starting program WILL DEADLOCK\n");

    pthread_create(&prod1, NULL, producer, &prod_id);
    pthread_create(&cons1, NULL, consumer, &cons_id);

    pthread_join(prod1, NULL);
    pthread_join(cons1, NULL);

    sem_destroy(&empty);
    sem_destroy(&full);
    pthread_mutex_destroy(&mutex);

    printf("Program completed successfully\n");
    return 0;
}
