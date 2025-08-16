#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <string.h>

int main() {
    int fd = open("q3.txt", O_CREAT | O_WRONLY | O_TRUNC, 0644);
    pid_t r1 = fork();

    if (r1 < 0) {
        fprintf(stderr, "fork 1 failed\n");
        exit(1);
    } else if (r1 == 0) {
        
        if (fd < 0) { perror("open"); exit(1); }
        write(fd, "12340740\n", strlen("12340740\n"));
        //close(fd);
        exit(0);
    } else {
        wait(NULL);  // wait for child
        
        if (fd < 0) { perror("open"); exit(1); }
        write(fd, "Farhan Alam\n", strlen("Farhan Alam\n" ));
        
    }
    close(fd);

    return 0;
}


