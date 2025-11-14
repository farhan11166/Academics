#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

int counter = 0;
pthread_mutex_t lock;

void* increment(void* arg) 
{
  for(int i = 0; i < 1000000; i++) 
  {
    pthread_mutex_lock(&lock);
    counter = counter + 1;
    //printf("Thread %ld: Counter = %d\n", (long)arg, counter);
    pthread_mutex_unlock(&lock);
  }
  return NULL;
}
int main() 
{
  pthread_t t[10];
  
  pthread_mutex_init(&lock, NULL);
  for(int i=0;i<10;i++){
    int k=i+1;
  pthread_create(&t[i], NULL, increment, NULL);
  }
  for(int i=0;i<10;i++){
    pthread_join(t[i], NULL);
  
  }
  printf("the final counter value without mutex is %d \n",counter);
  
  
  return 0;
}