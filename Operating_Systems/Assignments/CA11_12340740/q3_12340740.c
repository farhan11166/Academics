#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <string.h>
#include <errno.h>

#define BUF_SIZE 4096

int copy_file(const char *src, const char *dest) {
    int src_fd, dest_fd;
    struct stat src_stat;
    char buffer[BUF_SIZE];
    ssize_t bytes_read, bytes_written;

    src_fd = open(src, O_RDONLY);
    if (src_fd < 0) { perror("open source"); return -1; }

    if (stat(src, &src_stat) < 0) {
        perror("stat");
        close(src_fd);
        return -1;
    }

    dest_fd = open(dest, O_WRONLY | O_CREAT | O_TRUNC, src_stat.st_mode);
    if (dest_fd < 0) {
        perror("open destination");
        close(src_fd);
        return -1;
    }

    // ADD YOUR CODE HERE: Copy loop
    while ((bytes_read = read(src_fd, buffer, BUF_SIZE)) > 0) {
        bytes_written = write(dest_fd, buffer, bytes_read);
        if (bytes_written != bytes_read) {
            perror("write");
            close(src_fd);
            close(dest_fd);
            return -1;
        }
    }

    if (bytes_read < 0) perror("read");

    close(src_fd);
    close(dest_fd);
    return 0;
}

int move_file(const char *src, const char *dest) {
    // ADD YOUR CODE HERE:
    // First try rename(): works for same filesystem
    if (rename(src, dest) == 0)
        return 0;

    // If rename fails (EXDEV — cross filesystem): do copy + unlink
    if (errno == EXDEV) {
        if (copy_file(src, dest) == 0) {
            if (unlink(src) == 0)
                return 0;
            else {
                perror("unlink");
                return -1;
            }
        } else {
            fprintf(stderr, "Copy during move failed.\n");
            return -1;
        }
    }

    perror("rename");
    return -1;
}

int main(int argc, char *argv[]) {
    const char *prog;
    const char *src;
    const char *dest;

    if (argc == 3) {
         // ln -s a.out cp
         // ln -s a.out mv
         // ./cp src dest  or ./mv src dest
        prog = strrchr(argv[0], '/');
        prog = (prog == NULL) ? argv[0] : prog + 1;
        src = argv[1];
        dest = argv[2];
    } else if (argc == 4) {
        // ./a.out cp src dest  or ./a.out mv src dest
        prog = argv[1];
        src = argv[2];
        dest = argv[3];
    } else {
        fprintf(stderr, "Usage:\n");
        fprintf(stderr, "  %s <source> <destination>\n", argv[0]);
        fprintf(stderr, "  %s <cp|mv> <source> <destination>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    if (strcmp(prog, "cp") == 0) {
        if (copy_file(src, dest) == 0)
            printf("File copied successfully from '%s' to '%s'\n", src, dest);
        else
            fprintf(stderr, "Copy failed.\n");
    } 
    else if (strcmp(prog, "mv") == 0) {
        if (move_file(src, dest) == 0)
            printf("File moved successfully from '%s' to '%s'\n", src, dest);
        else
            fprintf(stderr, "Move failed.\n");
    } 
    else {
        fprintf(stderr, "Error: Invalid command name '%s'. Use cp or mv.\n", prog);
        exit(EXIT_FAILURE);
    }

    return 0;
}
