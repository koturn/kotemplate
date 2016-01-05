/*!
 * @brief Template C++-header file
 *
 * This is a template C++-header file
 * @author  <+AUTHOR+>
 * @date    <+DATE+>
 * @file    <+FILE+>
 * @version 0.1
 */
#ifndef <+FILE_CAPITAL+>_H
#define <+FILE_CAPITAL+>_H

#include <iostream>


/*!
 * @brief Template class
 */
class <+FILE_PASCAL+>
{
private:
public:
  <+FILE_PASCAL+>();
  <+FILE_PASCAL+>(const <+FILE_PASCAL+>& that);
  ~<+FILE_PASCAL+>();

  <+FILE_PASCAL+>& operator=(const <+FILE_PASCAL+>& that);

  template<typename CharT, typename Traits>
    friend std::basic_ostream<CharT, Traits>&
    operator<<(std::basic_ostream<CharT, Traits>& os, const <+FILE_PASCAL+>& this_);

  template<typename CharT, typename Traits>
    friend std::basic_istream<CharT, Traits>&
    operator>>(std::basic_istream<CharT, Traits>& is, <+FILE_PASCAL+>& this_);
};  // class <+FILE_PASCAL+>


<+FILE_PASCAL+>::<+FILE_PASCAL+>()
{
  <+CURSOR+>
}


<+FILE_PASCAL+>::<+FILE_PASCAL+>(const <+FILE_PASCAL+>& that)
{

}


<+FILE_PASCAL+>::~<+FILE_PASCAL+>()
{

}


<+FILE_PASCAL+>&
<+FILE_PASCAL+>::operator=(const <+FILE_PASCAL+>& that)
{

  return *this;
}


template<typename CharT, typename Traits>
std::basic_ostream<CharT, Traits>&
operator<<(std::basic_ostream<CharT, Traits>& os, const <+FILE_PASCAL+>& this_)
{

  return os;
}


template<typename CharT, typename Traits>
std::basic_istream<CharT, Traits>&
operator>>(std::basic_istream<CharT, Traits>& is, <+FILE_PASCAL+>& this_)
{

  return is;
}


#endif  // <+FILE_CAPITAL+>_H
