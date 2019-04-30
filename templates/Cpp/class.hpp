/*!
 * @brief Template C++-header file
 *
 * This is a template C++-header file
 * @author  <+AUTHOR+>
 * @date    <+DATE+>
 * @file    <+FILE+>
 * @version 0.1
 */
#ifndef <+INCLUDE_GUARD+>
#define <+INCLUDE_GUARD+>

#include <iostream>


/*!
 * @brief Template class
 */
class <+FILE_PASCAL+>
{
private:
public:
  // ctor
  <+FILE_PASCAL+>()
  {
    <+CURSOR+>
  }
  // copy-ctor
  <+FILE_PASCAL+>(const <+FILE_PASCAL+>& that)
  {

  }
  // dtor
  ~<+FILE_PASCAL+>()
  {

  }
  // operator=
  <+FILE_PASCAL+>&
  operator=(const <+FILE_PASCAL+>& that)
  {
    return *this;
  }

#if __cplusplus >= 201103L
  // move-ctor
  <+FILE_PASCAL+>(<+FILE_PASCAL+>&& that) = default;
  // move-operator=
  <+FILE_PASCAL+>&
  operator=(<+FILE_PASCAL+>&& that) = default;
#endif

  template<typename CharT, typename Traits>
  friend std::basic_ostream<CharT, Traits>&
  operator<<(std::basic_ostream<CharT, Traits>& os, const <+FILE_PASCAL+>& this_)
  {
    return os;
  }

  template<typename CharT, typename Traits>
  friend std::basic_istream<CharT, Traits>&
  operator>>(std::basic_istream<CharT, Traits>& is, <+FILE_PASCAL+>& this_)
  {
    return is;
  }
};  // class <+FILE_PASCAL+>


#endif  // <+INCLUDE_GUARD+>
