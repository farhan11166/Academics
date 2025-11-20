// user/twostriketest.c (Fragment for Q1)
#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  printf(1, "Enabling two-strike mode. Spinning... try killing me with Ctrl+C\n");

  // BLANK 6: Call the system call to enable the feature
  twostrike(1);

  // BLANK 7: Create a busy loop condition (always true)
  while (1) {
    // Spin/Busy Wait
  }

  exit();
}
