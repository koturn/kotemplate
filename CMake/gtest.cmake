cmake_minimum_required(VERSION <%= executable('cmake') ? split(systemlist('cmake --version')[0], ' ')[2] : '2.8' %>)

include(ExternalProject)

ExternalProject_Add(
  GoogleTest
  GIT_REPOSITORY https://github.com/google/googletest
  CMAKE_ARGS -DCMAKE_BUILD_TYPE:STRING=Release
  PREFIX ${CMAKE_CURRENT_BINARY_DIR}/lib
  INSTALL_COMMAND ""
  LOG_DOWNLOAD ON)

ExternalProject_Get_Property(GoogleTest SOURCE_DIR)
include_directories(${SOURCE_DIR}/googletest/include)
include_directories(${SOURCE_DIR}/googlemock/include)

if(MSVC)
  ExternalProject_Get_Property(GoogleTest BINARY_DIR)
  add_library(gtest STATIC IMPORTED)
  set_property(
    TARGET gtest
    PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/gtest.lib)

  add_library(gtest_main STATIC IMPORTED)
  set_property(
    TARGET gtest_main
    PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/gtest_main.lib)
elseif()
  ExternalProject_Get_Property(GoogleTest BINARY_DIR)
  add_library(gtest STATIC IMPORTED)
  set_property(
    TARGET gtest
    PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/libgtest.a)

  add_library(gtest_main STATIC IMPORTED)
  set_property(
    TARGET gtest_main
    PROPERTY IMPORTED_LOCATION ${BINARY_DIR}/lib/libgtest_main.a)
endif()
