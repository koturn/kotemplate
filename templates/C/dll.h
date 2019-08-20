/*!
 * @brief Template C-header file for DLL
 *
 * This is a template C-header file for DLL.
 * @author  <+AUTHOR+>
 * @date    <+DATE+>
 * @file    <+FILE+>
 * @version 0.1
 */
#ifndef <+FILE_CAPITAL+>_H
#define <+FILE_CAPITAL+>_H

#if defined(_WIN32) || defined(__CYGWIN__)
#  define <+FILE_CAPITAL+>_API_IMPORT __declspec(dllimport)
#  define <+FILE_CAPITAL+>_API_EXPORT __declspec(dllexport)
#  define <+FILE_CAPITAL+>_API_LOCAL
#elif defined(__GNUC__) && __GNUC__ >= 4
#  define <+FILE_CAPITAL+>_API_IMPORT __attribute__((visibility("default")))
#  define <+FILE_CAPITAL+>_API_EXPORT __attribute__((visibility("default")))
#  define <+FILE_CAPITAL+>_API_LOCAL  __attribute__((visibility("hidden")))
#else
#  define <+FILE_CAPITAL+>_API_IMPORT
#  define <+FILE_CAPITAL+>_API_EXPORT
#  define <+FILE_CAPITAL+>_API_LOCAL
#endif  /* defined(_WIN32) || defined(__CYGWIN__) */

#ifdef <+FILE_CAPITAL+>_DLL
#  ifdef <+FILE_CAPITAL+>_EXPORTS
#    define <+FILE_CAPITAL+>_API <+FILE_CAPITAL+>_API_EXPORT
#  else
#    define <+FILE_CAPITAL+>_API <+FILE_CAPITAL+>_API_IMPORT
#  endif  /* <+FILE_CAPITAL+>_EXPORTS */
#  define <+FILE_CAPITAL+>_LOCAL <+FILE_CAPITAL+>_API_LOCAL
#else
#  define <+FILE_CAPITAL+>_API
#  define <+FILE_CAPITAL+>_LOCAL
#endif  /* <+FILE_CAPITAL+>_DLL */


#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */


<+CURSOR+>


#ifdef __cplusplus
}  /* extern "C" */
#endif  /* __cplusplus */


#undef <+FILE_CAPITAL+>_API_IMPORT
#undef <+FILE_CAPITAL+>_API_EXPORT
#undef <+FILE_CAPITAL+>_API_LOCAL
#undef <+FILE_CAPITAL+>_API
#undef <+FILE_CAPITAL+>_LOCAL


#endif  /* <+FILE_CAPITAL+>_H */
