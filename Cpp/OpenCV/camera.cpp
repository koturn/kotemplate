/*!
 * @brief Simple camera program with OpenCV
 * @author  <+AUTHOR+>
 * @date    <+DATE+>
 * @file    <+FILE+>
 * @version 0.1
 */
#include <cstdlib>
#include <iostream>
#include <opencv/cv.h>
#include <opencv/highgui.h>


/*!
 * @brief Entry point of the program
 * @param [in] argc  A number of command-line arguments
 * @param [in] argv  Command line arguments
 * @return  Exit-status
 */
int
main(int argc, char *argv[])
{
  static const char WINDOW_NAME[] = "<+FILEBASE+>";
  static const int WAIT_TIME = 30;
  static const int CAMERA_NR = 0;

  cv::VideoCapture camera(CAMERA_NR);
  if (!camera.isOpened()) {
    std::cerr << "Unable to open camera device" << std::endl;
    return EXIT_FAILURE;
  }

  cv::Mat frame;
  cv::namedWindow(WINDOW_NAME, CV_WINDOW_AUTOSIZE);
  for (int key = cv::waitKey(WAIT_TIME); key < 0; key = cv::waitKey(WAIT_TIME)) {
    camera >> frame;
    <+CURSOR+>
    cv::imshow(WINDOW_NAME, frame);
  }
  return EXIT_SUCCESS;
}
