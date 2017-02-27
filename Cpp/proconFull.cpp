#include <cmath>
#include <cstdio>
#include <cstring>
#include <algorithm>
#include <complex>
#include <iomanip>
#include <iostream>
#include <map>
#include <numeric>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <string>
#include <utility>
#include <vector>

#define DUMP(var)  (cout << #var " = " << var << endl)
#define SQ(n)      ((n) * (n))
#define CUBE(n)    ((n) * (n) * (n))
#define CTOI(c)    ((c) - '0')
#define ISIN(x, a, b)  ((a) <= (x) && (x) <= (b))
#define DEQ(x, y)      ISIN((x), (y) - EPS, (y) + (EPS))
#define DNEQ(x, y)     ((x) < (y) - EPS && (y) + (EPS) < (x))
#define DBL_GT(x, y)      (((x) - (y)) > -(EPS))
#define DBL_GE(x, y)      (((x) - (y)) >  (EPS))
#define DBL_LE(x, y)      (((x) - (y)) <  (EPS))
#define DBL_LT(x, y)      (((x) - (y)) < -(EPS))
#define CLEAR(array)   memset((array), 0, sizeof(array))
#define LENGTH(array)  (sizeof(array) / sizeof((array)[0]))
#define FOR(i, from, to)  for (int i = (from); i < (to); ++i)
#define REP(i, n)         for (unsigned int i = 0; i < (n); ++i)
#define LOOP(n)           REP(__loop_tmp_var__, n)
#if __cplusplus == 201103L || (defined(_MSC_VER) && _MSC_VER >= 1600)
#  define FOREACH(elm, v)  \
     for (auto elm = (v).begin(); elm != (v).end(); ++elm)
#elif defined(__GNUC__)
#  define FOREACH(elm, v)  \
     for (typeof((v).begin()) elm = (v).begin(); elm != (v).end(); ++elm)
#endif


static const double EPS = 10e-9;


typedef long long int          llint;
typedef long long unsigned int lluint;
typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

using namespace std;


int
main()
{
  std::cin.tie(nullptr);
  std::ios::sync_with_stdio(false);
  <+CURSOR+>
  return EXIT_SUCCESS;
}
