#include <cstdlib>
#include <iostream>


int
main()
{
  std::cin.tie(0);
  std::ios::sync_with_stdio(false);

  int n;
  std::cin >> n;
  <+CURSOR+>
  std::vector<int> vct;
  for (int i = 0; i < n; i++) {
    std::cin >> vct[i];
  }

  return EXIT_SUCCESS;
}
