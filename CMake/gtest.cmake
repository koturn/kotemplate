cmake_minimum_required(VERSION 2.8)

include(ExternalProject)

ExternalProject_Add(
  GoogleTest
  GIT_REPOSITORY https://github.com/google/googletest
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/lib
  INSTALL_COMMAND ""
  LOG_DOWNLOAD ON)

ExternalProject_Get_Property(GoogleTest source_dir)
include_directories(${source_dir}/googletest/include)
include_directories(${source_dir}/googlemock/include)

if(MSVC)
  ExternalProject_Get_Property(GoogleTest binary_dir)
  add_library(gtest STATIC IMPORTED)
  set_property(
    TARGET gtest
    PROPERTY IMPORTED_LOCATION ${binary_dir}/lib/gtest.lib)

  add_library(gtest_main STATIC IMPORTED)
  set_property(
    TARGET gtest_main
    PROPERTY IMPORTED_LOCATION ${binary_dir}/lib/gtest_main.lib)
elseif()
  ExternalProject_Get_Property(GoogleTest binary_dir)
  add_library(gtest STATIC IMPORTED)
  set_property(
    TARGET gtest
    PROPERTY IMPORTED_LOCATION ${binary_dir}/lib/libgtest.a)

  add_library(gtest_main STATIC IMPORTED)
  set_property(
    TARGET gtest_main
    PROPERTY IMPORTED_LOCATION ${binary_dir}/lib/libgtest_main.a)
endif()

