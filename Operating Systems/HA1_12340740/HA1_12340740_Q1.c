#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>
#include <fcntl.h>
#include <string.h>
int x=10;
//int *y=&x;
int main(){
    
    pid_t rc =fork();
    if(rc<0){
        fprintf(stderr,"fork failed \n");
    }
    else if(rc==0){
        x=x+10;
        printf("child process \n");
        printf("%d\n",x);
    }
    else{
        wait(NULL);
        x=x+5;
        printf("parent process \n");
        printf("%d\n",x);


    }
}