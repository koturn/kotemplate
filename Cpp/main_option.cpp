/*!
 * @brief Template C++-source file
 *
 * This is a template C++-source file
 * @author  <+AUTHOR+>
 * @date    <+DATE+>
 * @file    <+FILE+>
 * @version 0.1
 */
#include <cstdlib>
#include <iostream>
#include <getopt.h>


static void
parseArguments(int argc, char* argv[]);

static void
showUsage(const char* progname);

static void
showVersion();


static const char* VERSION = "0.1";
static const char* AUTHOR = "<+AUTHOR+>";


/*!
 * @brief Entry point of the program
 * @param [in] argc  A number of command-line arguments
 * @param [in] argv  Command line arguments
 * @return  Exit-status
 */
int
main(int argc, char* argv[])
{
  parseArguments(argc, argv);
  <+CURSOR+>
  return EXIT_SUCCESS;
}


/*!
 * @brief Parse argument
 * @param [in]     argc  A number of command-line arguments
 * @param [in,out] argv  Command line arguments
 */
static void
parseArguments(int argc, char* argv[])
{
  static const struct option OPTIONS[] = {
    {"apple",   no_argument,       NULL, 'a'},
    {"banana",  required_argument, NULL, 'b'},
    {"cake",    optional_argument, NULL, 'c'},
    {"help",    no_argument,       NULL, 'h'},
    {"version", no_argument,       NULL, 'v'},
    {NULL, 0, NULL, '\0'}  // must be filled with zero
  };
  static const int N_REQUIRED_REMAININGS = 1;

  std::cout << "[Specified options]\n";
  int ret, optidx;
  while ((ret = getopt_long(argc, argv, "ab:c:hv", OPTIONS, &optidx)) != -1) {
    switch (ret) {
      case 'a':  // -a, --apple
        std::cout << "  -a, --apple\n";
        break;
      case 'b':  // -b, --banana
        std::cout << "  -b, --banana: " << optarg << "\n";
        break;
      case 'c':  // -c, --cake
        std::cout << "  -c, --cake: " << optarg << "\n";
        break;
      case 'h':  // -h, --help
        showUsage(argv[0]);
        std::exit(EXIT_SUCCESS);
      case 'v':  // -v, --version
        showVersion();
        std::exit(EXIT_SUCCESS);
      case '?':  // unknown option
        showUsage(argv[0]);
        std::exit(EXIT_FAILURE);
    }
  }
  std::cout.put('\n');

  std::cout << "[optind, argc]\n"
               "  optind = " << optind << "\n"
            << "  argc   = " << argc << "\n";
  if (optind > argc - N_REQUIRED_REMAININGS) {
    std::cerr << "Please specify file one or more\n" << std::endl;
    std::exit(EXIT_FAILURE);
  }
  std::cout << "[Remaining arguments]\n";
  for (int i = optind; i < argc; i++) {
    std::cout << "  " << argv[i];
  }
  std::cout << std::endl;
}


/*!
 * @brief Show usage of this program
 * @param [in] progname  Name of this program
 */
static void
showUsage(const char* progname)
{
  std::cout << "[Usage]\n"
               "  $ " << progname << " [options] FILE\n\n"
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
               "    Show version of this program"
            << std::endl;
}


/*!
 * @brief Show version of this program
 */
static void
showVersion()
{
  std::cout << "Version: " << VERSION << "\n"
               "Build date: " __DATE__ ", " __TIME__ "\n"
               "Compiled by: " << AUTHOR
            << std::endl;
}
