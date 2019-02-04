cmake_minimum_required(VERSION 2.8)

include_directories(../)
add_executable(test
  test.cpp)
target_link_libraries(test
  gtest
  gtest_main)

add_test(
  NAME test
  COMMAND $<TARGET_FILE:test>)

set_property(
  TEST test
  PROPERTY LABELS lib test)
