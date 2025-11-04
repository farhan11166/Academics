#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <stdlib.h> // Needed for pthread_mutex_destroy/pthread_cond_destroy (good practice)

#define NTHREADS 3

struct thread_event {
    pthread_mutex_t m;
    pthread_cond_t c;
    int awake;
};

struct thread_event events[NTHREADS];

void *sleeper(void *id) {
    long tid = (long)id;
    pthread_mutex_lock(&events[tid].m);

    while (!events[tid].awake) {
        printf("Thread %ld sleeping...\n", tid);
        //ADD YOUR CODE
        // Atomically releases the mutex and waits on the condition variable.
        // When signaled, it re-acquires the mutex and checks the 'while' condition.
        pthread_cond_wait(&events[tid].c, &events[tid].m);
    }

    printf("Thread %ld woke up!\n", tid);

    pthread_mutex_unlock(&events[tid].m);
    return NULL;
}

void *waker(void *arg) {
    sleep(2);  

    printf("Waker: waking all threads...\n");

    
    for (int i = 0; i < NTHREADS; i++) {
        //ADD YOUR CODE
        // 1. Lock the mutex to safely modify the shared 'awake' flag
        pthread_mutex_lock(&events[i].m);
        
        // 2. Set the flag that will satisfy the sleeper's 'while' loop
        events[i].awake = 1;
        
        // 3. Signal the waiting thread (sleeper) on the condition variable
        pthread_cond_signal(&events[i].c);
        
        // 4. Unlock the mutex
        pthread_mutex_unlock(&events[i].m);
    }

    return NULL;
}

int main() {
    pthread_t t[NTHREADS], w;

    for (int i = 0; i < NTHREADS; i++) {
        events[i].awake = 0;
        pthread_mutex_init(&events[i].m, NULL);
        pthread_cond_init(&events[i].c, NULL);
        pthread_create(&t[i], NULL, sleeper, (void *)(long)i);
    }

    pthread_create(&w, NULL, waker, NULL);
    pthread_join(w, NULL);

    for (int i = 0; i < NTHREADS; i++)
        pthread_join(t[i], NULL);
    
    // Clean up resources (good practice)
    for (int i = 0; i < NTHREADS; i++) {
        pthread_mutex_destroy(&events[i].m);
        pthread_cond_destroy(&events[i].c);
    }

    printf("All threads finished.\n");
    return 0;
}