#if 0
src=$0
exe=${src%.*}
gcc -s -O3 -pipe -Wall -Wextra -o $exe $src && $exe $@
exit
#endif
/*!
 * @brief Template C-source file
 *
 * This is a template C-source file
 * @author  <+AUTHOR+>
 * @date    <+DATE+>
 * @file    <+FILE+>
 * @version 0.1
 */
#include <stdio.h>
#include <stdlib.h>


/*!
 * @brief Entry point of the program
 * @param [in] argc  A number of command-line arguments
 * @param [in] argv  Command line arguments
 * @return  Exit-status
 */
int
main(int argc, char *argv[])
{
  printf("Hello World!\n");
  <+CURSOR+>
  return EXIT_SUCCESS;
}
