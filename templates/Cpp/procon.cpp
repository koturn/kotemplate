#include <cstdint>
#include <algorithm>
#include <iostream>
#include <numeric>
#include <string>
#include <utility>
#include <vector>

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
  while (std::cin >> n) {
    std::cout << n << std::endl;
  }
}
