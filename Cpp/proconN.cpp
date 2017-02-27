#include <cstdlib>
#include <iostream>


int
main()
{
  std::cin.tie(nullptr);
  std::ios::sync_with_stdio(false);

  int n;
  std::cin >> n;
  <+CURSOR+>
  std::vector<int> vct;
  for (auto&& e : vct) {
    std::cin >> e;
  }

  return EXIT_SUCCESS;
}
