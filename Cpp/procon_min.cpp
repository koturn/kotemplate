#include <cstdlib>
#include <iostream>


int
main(void)
{
  std::cin.tie(0);
  std::ios::sync_with_stdio(false);

  int n;
  while (std::cin >> n) {
    std::cout << n << std::endl;
  }
  return EXIT_SUCCESS;
}
