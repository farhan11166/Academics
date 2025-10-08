#include <pthread.h>
#include <stdio.h>
int x=0;
void* myfunc(void* arg){
    for(int i=0;i<1000000;i++){
        x=x+1;
    }
    return NULL;
}
int main(){
pthread_t tid[10];
  for(int i=0;i<10;i++){
    pthread_create(&tid[i],NULL,myfunc,NULL);
  }
  for(int i=0;i<10;i++){
    pthread_join(tid[i],NULL);
  }
  printf("%d",x);
  return 0;
}