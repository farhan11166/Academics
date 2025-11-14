#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

sem_t aArrived,bArrived;
void* threadA(void *arg){

    printf("This is A1\n");
    sem_post(&aArrived);
    sem_wait(&bArrived);

    printf("This is A2\n");

    return NULL;

}
void* threadB(void *arg){

    printf("This is B1\n");
    sem_wait(&aArrived);
    sem_post(&bArrived);

    printf("This is B2\n");
    
    return NULL;

}
int main(){
    pthread_t tA, tB;
    sem_init(&aArrived, 0, 0);
    sem_init(&bArrived, 0, 0);
    pthread_create(&tA, NULL, threadA, NULL);
    pthread_create(&tB, NULL, threadB, NULL);
     pthread_join(tA, NULL);
    pthread_join(tB, NULL);
    sem_destroy(&aArrived);
    sem_destroy(&bArrived);
}

