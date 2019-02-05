#include <iostream>

#if defined(__GNUC__) && !defined(__clang__)
#  pragma GCC optimize("Ofast")
#  pragma GCC target("sse4.2", "tune=native")
#endif


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
}
