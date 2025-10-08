#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
void* compute_square(void* arg){
    int number=*(int*)arg;
    int* result=malloc(sizeof(int));
    *result=number*number;
    return result;
}
int main(){
pthread_t tid;
int x=10;
pthread_create(&tid,NULL,compute_square,&x);
void* result;
pthread_join(tid,&result);
int final_answer = *(int*)result; 
printf("The square of %d is: %d\n", x, final_answer);
return 0;
}