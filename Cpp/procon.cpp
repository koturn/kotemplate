#include <cstdlib>
#include <iostream>


int
main()
{
  std::cin.tie(nullptr);
  std::ios::sync_with_stdio(false);

  int n;
  while (std::cin >> n) {
    std::cout << n << std::endl;
  }
  return EXIT_SUCCESS;
}
