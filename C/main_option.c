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
#include <getopt.h>


static void
parse_arguments(int argc, char *argv[]);

static void
show_usage(const char *progname);

static void
showVersion(void);


#define VERSION "0.1"
#define AUTHOR "<+AUTHOR+>"


/*!
 * @brief Entry point of the program
 * @param [in] argc  A number of command-line arguments
 * @param [in] argv  Command line arguments
 * @return  Exit-status
 */
int
main(int argc, char *argv[])
{
  parse_arguments(argc, argv);
  <+CURSOR+>
  return EXIT_SUCCESS;
}


/*!
 * @brief Parse argument
 * @param [in]     argc  A number of command-line arguments
 * @param [in,out] argv  Command line arguments
 */
static void
parse_arguments(int argc, char *argv[])
{
#define N_REQUIRED_REMAININGS 1
  int i, ret, optidx;
  static const struct option OPTIONS[] = {
    {"apple",   no_argument,       NULL, 'a'},
    {"banana",  required_argument, NULL, 'b'},
    {"cake",    optional_argument, NULL, 'c'},
    {"help",    no_argument,       NULL, 'h'},
    {"version", no_argument,       NULL, 'v'},
    {NULL, 0, NULL, '\0'}  /* must be filled with zero */
  };

  printf("[Specified options]\n");
  while ((ret = getopt_long(argc, argv, "ab:c:hv", OPTIONS, &optidx)) != -1) {
    switch (ret) {
      case 'a':  /* -a, --apple */
        printf("  -a, --apple\n");
        break;
      case 'b':  /* -b, --banana */
        printf("  -b, --banana: %s\n", optarg);
        break;
      case 'c':  /* -c, --cake */
        printf("  -c, --cake: %s\n", optarg);
        break;
      case 'h':  /* -h, --help */
        show_usage(argv[0]);
        exit(EXIT_SUCCESS);
      case 'v':  /* -v, --version */
        showVersion();
        exit(EXIT_SUCCESS);
      case '?':  /* unknown option */
        show_usage(argv[0]);
        exit(EXIT_FAILURE);
    }
  }
  putchar('\n');

  printf(
      "[optind, argc]\n"
      "  optind = %d\n"
      "  argc   = %d\n\n", optind, argc);
  if (optind > argc - N_REQUIRED_REMAININGS) {
    fprintf(stderr, "Please specify file one or more\n");
    exit(EXIT_FAILURE);
  }
  printf("[Remaining arguments]\n");
  for (i = optind; i < argc; i++) {
    printf("  %s", argv[i]);
  }
  putchar('\n');
#undef N_REQUIRED_REMAININGS
}


/*!
 * @brief Show usage of this program
 * @param [in] progname  Name of this program
 */
static void
show_usage(const char *progname)
{
  printf(
      "[Usage]\n"
      "  $ %s [options] FILE\n\n", progname);
  printf(
      "[Options]\n"
      "  -a, --apple\n"
      "    apple apple apple\n"
      "  -b BANANA, --banana=BANANA\n"
      "    banana banana banana\n"
      "  -c [CAKE], --cake[=CAKE]\n"
      "    cake cake cake\n"
      "  -h, --help\n"
      "    Show help of this program\n"
      "  -v, --version\n"
      "    Show version of this program\n");
}


/*!
 * @brief Show version of this program
 */
static void
showVersion(void)
{
  printf(
      "Version: " VERSION "\n"
      "Build date: " __DATE__ ", " __TIME__ "\n"
      "Compiled by: " AUTHOR "\n");
}
