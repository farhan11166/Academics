CC = gcc
CFLAGS = -Wall -Wextra -g   # enable warnings + debugging info
PROGS = null Q4 Q5 Q6 Q7

# Default target: build all programs
all: $(PROGS)

# Pattern rule: build each program from its .c file
%: %.c
	$(CC) $(CFLAGS) -o $@ $<

# Clean up generated files
clean:
	rm -f $(PROGS) *.o
