cmake_minimum_required(VERSION <%= executable('cmake') ? split(systemlist('cmake --version')[0], ' ')[2] : '2.8' %>)

include_directories(../)
include_directories(${GTEST_INCLUDE_DIRS})

if(NOT GTEST_FOUND)
  link_directories(${GTEST_LINK_DIRS})
endif()

file(GLOB SRCS *.cpp *.cxx *.cc)
add_executable(mytest
  ${SRCS})
<+CURSOR+>

find_package(Threads REQUIRED)

target_link_libraries(mytest
  ${GTEST_BOTH_LIBRARIES}
  Threads::Threads)

add_test(
  NAME mytest
  COMMAND $<TARGET_FILE:mytest>)

set_property(
  TEST mytest
  PROPERTY LABELS lib test)
