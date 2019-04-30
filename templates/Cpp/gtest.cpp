#if (defined(__GNUC__) && (__GNUC__ > (major) || __GNUC__ == (major) && __GNUC_MINOR__ >= (minor)))
#  define <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA
#endif

#ifdef <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA
#  pragma GCC diagnostic push
#  pragma GCC diagnostic ignored "-Weffc++"
#  if __cplusplus >= 201103L
#    pragma GCC diagnostic ignored "-Wsuggest-override"
#    pragma GCC diagnostic ignored "-Wzero-as-null-pointer-constant"
#  endif  // __cplusplus >= 201103L
#endif  // <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA
#include <gtest/gtest.h>
#ifdef <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA
#  pragma GCC diagnostic pop
#endif  // <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA


#ifdef <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA
#  if __cplusplus >= 201103L
#    pragma GCC diagnostic ignored "-Wsuggest-override"
#    pragma GCC diagnostic ignored "-Wzero-as-null-pointer-constant"
#  endif  // __cplusplus >= 201103L
#endif  // <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA




TEST(<+FILE_PASCAL+>, Test01) {
  <+CURSOR+>
  EXPECT_EQ(1, 1);
}




#ifdef <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA
#  pragma GCC diagnostic pop
#endif  // <+FILE_CAPITAL+>_AVAILABLE_GCC_WARNING_PRAGMA
