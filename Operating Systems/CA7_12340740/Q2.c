#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
void* myfunc(void* arg){
    int id =*(int*)arg;
    printf("Thread %d is running\n",id);
    return NULL;
}
int main(){
  pthread_t tid[10];
  for(int i=0;i<10;i++){
    int *p_id = malloc(sizeof(int));
    *p_id=i;
    pthread_create(&tid[i],NULL,myfunc,p_id);
  }
  for(int i=0;i<10;i++){
    pthread_join(tid[i],NULL);
  }
  return 0;
}
