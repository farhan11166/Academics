#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
int N =102;  // number of cycles

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

int turn = 0; // 0 -> A, 1 -> B, 2 -> C

void *printA(void *arg) {
    for (int i = 0; i < N; i++) {
        pthread_mutex_lock(&lock);
        while (turn != 0) {
            //ADD YOUR CODE HERE
            // Wait while it's not A's turn (turn != 0)
            pthread_cond_wait(&cond, &lock);
        }
        printf("A ");
        fflush(stdout);
       //ADD YOUR CODE HERE
        turn =1; // Hand over to B
        pthread_cond_signal(&cond); // Signal a waiting thread
        
        pthread_mutex_unlock(&lock);
        
    }
    return NULL;
}

void *printB(void *arg) {
    for (int i = 0; i < N; i++) {
        pthread_mutex_lock(&lock);
        //ADD YOUR CODE HERE
        // Wait while it's not B's turn (turn != 1)
        while(turn!=1){
            pthread_cond_wait(&cond, &lock);
        }
        printf("B ");
        fflush(stdout);
        //ADD YOUR CODE HERE
        turn = 2; // Hand over to C
        pthread_cond_signal(&cond); // Signal a waiting thread
        
        pthread_mutex_unlock(&lock);
    }
    return NULL;
}

void *printC(void *arg) {
    for (int i = 0; i < N; i++) {
        pthread_mutex_lock(&lock);
        //ADD YOUR CODE HERE
        // Wait while it's not C's turn (turn != 2)
        while(turn!=2){
            pthread_cond_wait(&cond, &lock);
        }
        printf("C\n");
        fflush(stdout);
        //ADD YOUR CODE HERE
        turn = 0; // Hand over to A
        pthread_cond_signal(&cond); // Signal a waiting thread
        pthread_mutex_unlock(&lock);
    }
    return NULL;
}

int main() {
    pthread_t tA, tB, tC;
    pthread_create(&tA, NULL, printA, NULL);
    pthread_create(&tB, NULL, printB, NULL);
    pthread_create(&tC, NULL, printC, NULL);

    pthread_join(tA, NULL);
    pthread_join(tB, NULL);
    pthread_join(tC, NULL);
    return 0;
}
