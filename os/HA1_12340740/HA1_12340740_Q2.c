#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
int main(){
    pid_t r1=fork();
    pid_t r2=fork();
    if(r1<0){
        fprintf(stderr,"fork 1 failed\n");
    }
    else if(r1==0){
        
        printf("child (fork1) pid : %d \n",getpid());
        printf( "parent pid : %d \n",getppid());
    }
    else{
        wait(NULL);
        
        printf( "parent pid (it is a parent process): %d \n",getpid());

    }
    if(r2<0){
        fprintf(stderr,"fork 2 failed\n");
    }
    else if(r2==0){
        printf("child (fork2) pid : %d \n",getpid());
         printf( "parent pid : %d \n",getppid());
    }
    else{
        wait(NULL);
        printf( "parent pid (it is a parent process): %d \n",getpid());

    }



}