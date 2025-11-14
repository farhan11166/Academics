#include <pthread.h>
#include <stdio.h>
int myidg=22;
void* print_id(void* arg){
    int id =*(int*)arg;
    printf("Address of global variable is %p in thread function\n ",&myidg);
    printf("Address of local variable is %p in thread function \n",&arg);

    return NULL;
}
int main(){
    pthread_t tid1,tid2;
    int myid=42;
    pthread_create(&tid1,NULL,print_id,&myid);
    pthread_create(&tid2,NULL,print_id,&myid);
    pthread_join(tid1,NULL);
    pthread_join(tid2,NULL);//function would not execute without this
    printf("Address of global variable is %p in main function \n",&myidg);
    printf("Address of local variable is %p in main function \n",&myid);

    return 0;
}