/*!
 * @brief OpenCV Library linker for MSVC
 * @author  <+AUTHOR+>
 * @file    <+FILE+>
 * @version 1.0
 */
#if defined(_MSC_VER) && !defined(CV_PRAGMA_LINK_H)
#define CV_PRAGMA_LINK_H

#include <opencv2/core/version.hpp>


#define CV_VER_STR \
  CVAUX_STR(CV_MAJOR_VERSION) \
  CVAUX_STR(CV_MINOR_VERSION) \
  CVAUX_STR(CV_SUBMINOR_VERSION)

#ifdef _DEBUG
#  define CV_EXT_STR "d.lib"
#else
#  define CV_EXT_STR ".lib"
#endif

#ifndef CV_LIB_ABS_PATH
#  define CV_LIB_ABS_PATH
#endif

#define CV_LIB(libname) \
  CV_LIB_ABS_PATH libname CV_EXT_STR
#define CV_VER_LIB(libname) \
  CV_LIB_ABS_PATH libname CV_VER_STR CV_EXT_STR

#pragma comment(lib, CV_VER_LIB("opencv_calib3d"))
#pragma comment(lib, CV_VER_LIB("opencv_contrib"))
#pragma comment(lib, CV_VER_LIB("opencv_core"))
#pragma comment(lib, CV_VER_LIB("opencv_features2d"))
#pragma comment(lib, CV_VER_LIB("opencv_flann"))
#pragma comment(lib, CV_VER_LIB("opencv_gpu"))
#pragma comment(lib, CV_LIB("opencv_haartraining_engine"))
#pragma comment(lib, CV_VER_LIB("opencv_highgui"))
#pragma comment(lib, CV_VER_LIB("opencv_imgproc"))
#pragma comment(lib, CV_VER_LIB("opencv_legacy"))
#pragma comment(lib, CV_VER_LIB("opencv_ml"))
#pragma comment(lib, CV_VER_LIB("opencv_objdetect"))
#pragma comment(lib, CV_VER_LIB("opencv_ts"))
#pragma comment(lib, CV_VER_LIB("opencv_video"))
<+CURSOR+>


#undef CV_VER_STR
#undef CV_EXT_STR
#undef CV_LIB_ABS_PATH
#undef CV_LIB
#undef CV_VER_LIB


#endif  // defined(_MSC_VER) && !defined(CV_PRAGMA_LINK_H)
