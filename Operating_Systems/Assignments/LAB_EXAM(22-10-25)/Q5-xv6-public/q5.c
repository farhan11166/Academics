#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(){
    char *p=malloc(1024*16 +4 );
    if(p==NULL){
        perror("malloc");
        return 1;
    }
    printf("Allocated 16KB of memory at address : %p \n",(void*)p);
    printf("Process ID : %d\n",getpid());
    printf("Press ENter to exit\n ");

    p[0]='a';
    for(int i=0;i<4;i++){
        p[i]='a';
    }
    getchar();
    free(p);
    return 0;
    






















}