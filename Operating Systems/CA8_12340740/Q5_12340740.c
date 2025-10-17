#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#define N 5
int count = 0;
pthread_mutex_t mutex;
sem_t barrier1, barrier2;
void* thread_func(void* arg)
{
    int id = *(int*)arg;
    printf("Thread %d reached barrier 1\n", id);
    pthread_mutex_lock(&mutex);
    count++;
    if (count == N) 
    {
        sem_wait(&barrier2);
        sem_post(&barrier1); // Only one thread is signaled!
    }
    pthread_mutex_unlock(&mutex);
    sem_wait(&barrier1); // All threads wait, but only one is signaled
    sem_post(&barrier1);
    printf("Thread %d passed barrier 1\n", id);
    printf("Thread %d reached barrier 2\n", id);
    pthread_mutex_lock(&mutex);
    count--;
    if (count == 0){
        sem_wait(&barrier1);
        sem_post(&barrier2);
    }
    pthread_mutex_unlock(&mutex);
    sem_wait(&barrier2);
    sem_post(&barrier2);
    printf("Thread %d passed barrier 2\n", id);
    return NULL;
}
int main() {
    pthread_t threads[N];
    int ids[N];
    pthread_mutex_init(&mutex, NULL);
    sem_init(&barrier1, 0, 0);
    sem_init(&barrier2, 0, 1);
    for (int i = 0; i < N; i++) {
        ids[i] = i + 1;
        pthread_create(&threads[i], NULL, thread_func, &ids[i]);
    }
    for (int i = 0; i < N; i++) {
        pthread_join(threads[i], NULL);
    }
    pthread_mutex_destroy(&mutex);
    sem_destroy(&barrier1);
    sem_destroy(&barrier2);
    return 0;
}