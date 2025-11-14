#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main() {
    pid_t pid1, pid2;
    int total_processes = 1; 

    printf("Parent PID: %d\n", getpid());
    printf("I am Farhan Alam (Parent)\n");

  
    pid1 = fork();
    if(pid1 < 0) {
        perror("fork");
        exit(1);
    } else if(pid1 == 0) {
        
        printf("First Child PID: %d, Parent PID: %d\n", getpid(), getppid());
        printf("I am first child\n");
        exit(0);
    } else {
        total_processes++; 

    
        wait(NULL);

        
        pid2 = fork();
        if(pid2 < 0) {
            perror("fork");
            exit(1);
        } else if(pid2 == 0) {
           
            printf("Second Child PID: %d, Parent PID: %d\n", getpid(), getppid());
            printf("I am second child\n");
            exit(0);
        } else {
            total_processes++; 
            wait(NULL);

            printf("Total processes run: %d\n", total_processes);
        }
    }

    return 0;
}
