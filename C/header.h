/*!
 * @brief Template C-header file
 *
 * This is a template C-header file
 * @author  <+AUTHOR+>
 * @date    <+DATE+>
 * @file    <+FILE+>
 * @version 0.1
 */
#ifndef <+FILE_CAPITAL+>_H
#define <+FILE_CAPITAL+>_H

#if defined(_MSC_VER)
#  define <+FILE_CAPITAL+>_DLLEXPORT  __declspec(dllexport)
#elif defined(__GNUC__)
#  define <+FILE_CAPITAL+>_DLLEXPORT  __attribute__((dllexport))
#else
#  define <+FILE_CAPITAL+>_DLLEXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */


<+CURSOR+>




#ifdef __cplusplus
}  /* extern "C" */
#endif  /* __cplusplus */
#undef <+FILE_CAPITAL+>_DLLEXPORT
#endif  /* <+FILE_CAPITAL+>_H */
