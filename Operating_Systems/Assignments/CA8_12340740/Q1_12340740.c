#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

sem_t sem1,sem2;

void* threadA(void* arg) 
{
  printf("Hello from A\n");
  sem_post(&sem1);
  return NULL;
}
void* threadB(void* arg) 
{
  sem_wait(&sem1);
  printf("Hello from B\n");
  sem_post(&sem2);
  return NULL;
  
}
void* threadC(void* arg) 
{
  sem_wait(&sem2);
  printf("Hello from C\n");
  return NULL;
}
int main()
{
  pthread_t tA, tB,tC;
  
  sem_init(&sem1, 0, 0);
  sem_init(&sem2, 0, 0);
  
  pthread_create(&tA, NULL, threadA, NULL);
  pthread_create(&tB, NULL, threadB, NULL);
  pthread_create(&tC, NULL, threadC, NULL);
  
  
  pthread_join(tA, NULL);
  pthread_join(tB, NULL);
  pthread_join(tC, NULL);


  
  sem_destroy(&sem1);
  sem_destroy(&sem2);

  return 0;
}
