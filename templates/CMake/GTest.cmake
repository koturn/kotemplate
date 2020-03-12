cmake_minimum_required(VERSION <%= executable('cmake') ? split(systemlist('cmake --version')[0], ' ')[2] : '2.8' %>)

option(PREFER_TO_USE_INSTALLED_GTEST "Use gtest which is installed into your system." ON)
if(PREFER_TO_USE_INSTALLED_GTEST)
  find_package(GTest)
else()
  set(GTEST_FOUND FALSE)
endif()

if(GTEST_FOUND)
  include_directories(GTEST_INCLUDE_DIRS)
else()
  include(ExternalProject)

  ExternalProject_Add(
    GoogleTest
    GIT_REPOSITORY https://github.com/google/googletest
    CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=Release
    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/lib
    INSTALL_COMMAND ""
    LOG_DOWNLOAD ON)

  ExternalProject_Get_Property(GoogleTest SOURCE_DIR)
  ExternalProject_Get_Property(GoogleTest BINARY_DIR)

  set(GTEST_INCLUDE_DIRS "${SOURCE_DIR}/googletest/include")
  set(GTEST_LIBRARIES "gtest")
  set(GTEST_MAIN_LIBRARIES "gtest_main")
  set(GTEST_BOTH_LIBRARIES "${GTEST_LIBRARIES};${GTEST_MAIN_LIBRARIES}")
  set(GTEST_LINK_DIRS "${BINARY_DIR}/lib")

  if(MSVC)
    add_library(gtest STATIC IMPORTED)
    set_property(
      TARGET gtest
      PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/gtest.lib)

    add_library(gtest_main STATIC IMPORTED)
    set_property(
      TARGET gtest_main
      PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/gtest_main.lib)
  elseif()
    add_library(gtest STATIC IMPORTED)
    set_property(
      TARGET gtest
      PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/libgtest.a)

    add_library(gtest_main STATIC IMPORTED)
    set_property(
      TARGET gtest_main
      PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/libgtest_main.a)
  endif()
endif()

message(STATUS "GTest Variables")
foreach(VARNAME
    PREFER_TO_USE_INSTALLED_GTEST
    GTEST_FOUND
    GTEST_INCLUDE_DIRS
    GTEST_LINK_DIRS
    GTEST_LIBRARIES
    GTEST_MAIN_LIBRARIES
    GTEST_BOTH_LIBRARIES)
  message(STATUS "${VARNAME}: ${${VARNAME}}")
endforeach(VARNAME)
