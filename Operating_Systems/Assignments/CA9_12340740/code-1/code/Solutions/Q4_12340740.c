#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

sem_t roomEmpty;
pthread_mutex_t mutex;
int readers = 0;
int shared_data = 0;

void* reader(void* arg) {
    int id = *(int*)arg;
    for (int i = 0; i < 50; i++) {
        pthread_mutex_lock(&mutex);
        readers++;
        if (readers == 1) {
            sem_wait(&roomEmpty);
        }
        pthread_mutex_unlock(&mutex);

        // Read section
        printf("Reader %d reads: %d (readers=%d)\n", id, shared_data, readers);
        usleep(10000);

        pthread_mutex_lock(&mutex);
        readers--;
        if (readers == 0) {
            sem_post(&roomEmpty);
        }
        pthread_mutex_unlock(&mutex);
        usleep(10000);
    }
    return NULL;
}

void* writer(void* arg) {
    int id = *(int*)arg;
    for (int i = 0; i < 20; i++) {
        sem_wait(&roomEmpty);
        shared_data++;
        printf("Writer %d writes: %d\n", id, shared_data);
        sem_post(&roomEmpty);
        usleep(50000);
    }
    return NULL;
}

int main() {
    pthread_t readers_t[4], writers_t[2];
    int reader_ids[4] = {1, 2, 3, 4};
    int writer_ids[2] = {1, 2};

    sem_init(&roomEmpty, 0, 1);
    pthread_mutex_init(&mutex, NULL);

    printf("=== FIXED VERSION - No anomalies ===\n");

    for (int i = 0; i < 4; i++) pthread_create(&readers_t[i], NULL, reader, &reader_ids[i]);
    for (int i = 0; i < 2; i++) pthread_create(&writers_t[i], NULL, writer, &writer_ids[i]);

    for (int i = 0; i < 4; i++) pthread_join(readers_t[i], NULL);
    for (int i = 0; i < 2; i++) pthread_join(writers_t[i], NULL);

    sem_destroy(&roomEmpty);
    pthread_mutex_destroy(&mutex);

    printf("\nAll threads completed. Final shared_data = %d\n", shared_data);
    return 0;
}
