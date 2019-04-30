#include <stdio.h>
#include <stdlib.h>

#define LINE_BUF_SIZE  1024
#define LENGTH(array)  (sizeof(array) / sizeof((array)[0]))


int
main(void)
{
  static char line[LINE_BUF_SIZE];

  while (fgets(line, sizeof(line), stdin) != NULL) {
    int a, b;
    if (sscanf(line, "%d %d", &a, &b) != 2) {
      fputs("sscanf: Convert error\n", stderr);
      return EXIT_FAILURE;
    }
    <+CURSOR+>
  }
  return EXIT_SUCCESS;
}
