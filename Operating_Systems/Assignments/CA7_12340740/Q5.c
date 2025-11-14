#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
void* myfunc(void* arg){
    int x=*(int*)arg;
    int* result=malloc(sizeof(int));
    *result=x*x;
    return result;
}
int main(){
    int n;
    n=5;
    pthread_t tid[n];
    
    for(int i=0;i<n;i++){
         int *p_id = malloc(sizeof(int));
        *p_id=i+1;
        pthread_create(&tid[i],NULL,myfunc,p_id);
    }
    int sum=0;
    for(int i=0;i<n;i++){
        void* result;
        pthread_join(tid[i],&result);
        int final_answer = *(int*)result;
        printf("thread %d returned %d\n",i+1,final_answer) ;
        sum=sum+final_answer;
    }
    printf("all threads completed\n");
    printf("the sum is %d\n",sum);

}