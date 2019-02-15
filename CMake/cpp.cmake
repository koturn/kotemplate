cmake_minimum_required(VERSION <%= executable('cmake') ? split(systemlist('cmake --version')[0], ' ')[2] : '3.1' %>)
project(CMakeProject C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(DEFAULT_BUILD_TYPE "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Version Requirements
if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.4)
    message(FATAL_ERROR "GCC version must be at least 4.4!")
  endif()
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.1)
    message(FATAL_ERROR "Clang version must be at least 3.1!")
  endif()
endif()


file(GLOB SRCS *.c *.cpp *.cxx *.cc)
add_executable(<+CURSOR+>
  ${SRCS})

# include_directories(${CMAKE_SOURCE_DIR})

# find_package(Threads REQUIRED)
# target_link_libraries(main m Threads::Threads)

if(NOT CMAKE_BUILD_TYPE MATCHES Debug)
  add_definitions(-DNDEBUG)
endif()


if(MSVC)
  set(CMAKE_USE_RELATIVE_PATHS "ON")
  if(CMAKE_C_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
  else()
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W4")
  endif()
  if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
  else()
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4")
  endif()
  add_definitions(
    -DWIN32_LEAN_AND_MEAN
    -DNOMINMAX
    -D_USE_MATH_DEFINES
    -D_CRT_NONSTDC_NO_WARNINGS
    -D_CRT_SECURE_NO_WARNINGS)

  foreach(FLAG_VAR
      CMAKE_C_FLAGS
      CMAKE_C_FLAGS_DEBUG
      CMAKE_C_FLAGS_RELEASE
      CMAKE_C_FLAGS_MINSIZEREL
      CMAKE_C_FLAGS_RELWITHDEBINFO
      CMAKE_CXX_FLAGS
      CMAKE_CXX_FLAGS_DEBUG
      CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_MINSIZEREL
      CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    string(REGEX REPLACE "/RTC[^ ]*" "" ${FLAG_VAR} "${${FLAG_VAR}}")
  endforeach(FLAG_VAR)

  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /Oi /Ot /Ox /Oy")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Oi /Ot /Ox /Oy /GL")
  # set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}")
  set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} /Os")

  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Oi /Ot /Ox /Oy")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Oi /Ot /Ox /Oy /GL")
  # set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /Os")
else()
  foreach(WARNING_FLAG
      -Wall
      -Wextra
      -Wabi
      -Wcast-align
      -Wcast-qual
      -Wconversion
      -Wdisabled-optimization
      -Wfloat-equal
      -Wformat=2
      -Winit-self
      -Winvalid-pch
      -Wmissing-declarations
      -Wpointer-arith
      -Wredundant-decls
      -Wstack-protector
      -Wstrict-aliasing=2
      -Wstrict-overflow=5
      -Wswitch-enum
      -Wswitch-default
      -Wunknown-pragmas
      -Wunreachable-code
      -Wwrite-strings
      -pedantic)
    set(GNU_CLANG_COMMON_WARNING_FLAGS "${GNU_CLANG_COMMON_WARNING_FLAGS} ${WARNING_FLAG}")
  endforeach(WARNING_FLAG)

  option(ENABLE_ADDITIONAL_WARNING_FLAGS "Enable additional warning flags." OFF)
  if(ENABLE_ADDITIONAL_WARNING_FLAGS)
    set(GNU_CLANG_COMMON_WARNING_FLAGS "${GNU_CLANG_COMMON_WARNING_FLAGS} -Winline -Wsign-conversion")
  endif()

  set(GNU_COMMON_WARNING_FLAGS "${GNU_CLANG_COMMON_WARNING_FLAGS} -Wlogical-op")
  if(ENABLE_ADDITIONAL_WARNING_FLAGS)
    set(GNU_COMMON_WARNING_FLAGS "${GNU_CLANG_COMMON_WARNING_FLAGS} -Wunsafe-loop-optimizations")
  endif()

  set(CLANG_COMMON_WARNING_FLAGS "${GNU_CLANG_COMMON_WARNING_FLAGS} -Wsign-promo")

  if(CMAKE_COMPILER_IS_GNUCC)
    set(C_WARNING_FLAGS "${GNU_COMMON_WARNING_FLAGS}")
    foreach(WARNING_FLAG
        -Wc++-compat
        -Wbad-function-cast
        -Wmissing-prototypes
        -Wnested-externs
        -Wold-style-definition
        -Wstrict-prototypes)
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
    endforeach(WARNING_FLAG)

    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 4.5 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 4.5)
      message("-- Add warning flags implemented in gcc 4.5")
      foreach(WARNING_FLAG
          -Wjump-misses-init
          -Wunsuffixed-float-constants)
        set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 4.6 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 4.6)
      message("-- Add warning flags implemented in gcc 4.6")
      foreach(WARNING_FLAG
          -Wdouble-promotion
          -Wsuggest-attribute=const
          -Wsuggest-attribute=noreturn
          -Wsuggest-attribute=pure
          -Wtrampolines)
        set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 4.7 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 4.7)
      message("-- Add warning flags implemented in gcc 4.7")
      foreach(WARNING_FLAG
          -Wno-return-local-addr
          -Wvector-operation-performance)
        set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 4.8 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 4.8)
      message("-- Add warning flags implemented in gcc 4.8")
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} -Wsuggest-attribute=format")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 5.1 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 5.1)
      message("-- Add warning flags implemented in gcc 5.1")
      foreach(WARNING_FLAG
          -Wformat-signedness
          -Wsuggest-final-methods
          -Wsuggest-final-types)
        set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 6.0 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 6.0)
      message("-- Add warning flags implemented in gcc 6.0")
      foreach(WARNING_FLAG
          -Wduplicated-cond
          -Wshift-overflow=2)
        set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 7.0 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 7.0)
      message("-- Add warning flags implemented in gcc 7.0")
      string(REGEX REPLACE "-Wabi" "-Wabi=11" C_WARNING_FLAGS "${C_WARNING_FLAGS}")
      foreach(WARNING_FLAG
          -Walloc-zero
          -Wduplicated-branches
          -Wformat-overflow=2
          -Wformat-truncation=2
          -Wrestrict
          -Wshadow-local
          -Wstringop-overflow=4)
        set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 8.0 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 8.0)
      message("-- Add warning flags implemented in gcc 8.0")
      string(REGEX REPLACE "-Wcast-align" "-Wcast-align=strict" C_WARNING_FLAGS "${C_WARNING_FLAGS}")
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} -Wsuggest-attribute=malloc")
    endif()
  elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
    set(C_WARNING_FLAGS "${CLANG_COMMON_WARNING_FLAGS}")
    foreach(WARNING_FLAG
        -Wc++-compat
        -Wbad-function-cast
        -Wmissing-prototypes)
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
    endforeach(WARNING_FLAG)

    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 3.5 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 3.5)
      message("-- Add warning flags implemented in clang 3.5")
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} -Wc++14-compat")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 3.8 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 3.8)
      message("-- Add warning flags implemented in clang 3.8")
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} -Wdouble-promotion")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER 5.0 OR CMAKE_C_COMPILER_VERSION VERSION_EQUAL 5.0)
      message("-- Add warning flags implemented in clang 5.0")
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} -Wzero-as-null-pointer-constant")
    endif()
  endif()

  if(CMAKE_COMPILER_IS_GNUCXX)
    set(CXX_WARNING_FLAGS "${GNU_COMMON_WARNING_FLAGS}")
    foreach(WARNING_FLAG
        -Weffc++
        -Wctor-dtor-privacy
        -Wnon-virtual-dtor
        -Wold-style-cast
        -Woverloaded-virtual
        -Wreorder
        -Wsign-promo
        -Wstrict-null-sentinel)
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
    endforeach(WARNING_FLAG)

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.3 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.3)
      message("-- Add warning flags implemented in g++ 4.3")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wc++0x-compat")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.6 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.6)
      message("-- Add warning flags implemented in g++ 4.6")
      foreach(WARNING_FLAG
          -Wdouble-promotion
          -Wnoexcept
          -Wsuggest-attribute=const
          -Wsuggest-attribute=noreturn
          -Wsuggest-attribute=pure
          -Wtrampolines)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.7 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.7)
      message("-- Add warning flags implemented in g++ 4.7")
      string(REGEX REPLACE "-Wc\\+\\+0x-compat" "-Wc++11-compat" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      foreach(WARNING_FLAG
          -Wdelete-non-virtual-dtor
          -Wvector-operation-performance
          -Wno-return-local-addr
          -Wzero-as-null-pointer-constant)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.8 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.8)
      message("-- Add warning flags implemented in g++ 4.8")
      foreach(WARNING_FLAG
          -Wsuggest-attribute=format
          -Wuseless-cast)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.9 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.9)
      message("-- Add warning flags implemented in g++ 4.9")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wconditionally-supported")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.1 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 5.1)
      message("-- Add warning flags implemented in g++ 5.1")
      foreach(WARNING_FLAG
          -Wc++14-compat
          -Wformat-signedness
          -Wsuggest-final-methods
          -Wsuggest-final-types
          -Wsuggest-override)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 6.0 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 6.0)
      message("-- Add warning flags implemented in g++ 6.0")
      foreach(WARNING_FLAG
          -Wduplicated-cond
          -Wplacement-new=2
          -Wshift-overflow=2)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 7.0 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 7.0)
      message("-- Add warning flags implemented in g++ 7.0")
      string(REGEX REPLACE "-Wabi" "-Wabi=11" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      foreach(WARNING_FLAG
          -Wc++17-compat
          -Walloc-zero
          -Wduplicated-branches
          -Wformat-overflow=2
          -Wformat-truncation=2
          -Wregister
          -Wrestrict
          -Wshadow-local
          -Wstringop-overflow=4)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 8.0 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 8.0)
      message("-- Add warning flags implemented in g++ 8.0")
      string(REGEX REPLACE "-Wcast-align" "-Wcast-align=strict" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wsuggest-attribute=malloc")
    endif()
  else()
    set(CXX_WARNING_FLAGS "${CLANG_COMMON_WARNING_FLAGS}")
    foreach(WARNING_FLAG
        -Wc++11-compat
        -Weffc++
        -Wctor-dtor-privacy
        -Wdelete-non-virtual-dtor
        -Wnon-virtual-dtor
        -Wold-style-cast
        -Woverloaded-virtual
        -Wreorder)
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
    endforeach(WARNING_FLAG)

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.5 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 3.5)
      message("-- Add warning flags implemented in clang++ 3.5")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wc++14-compat")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.8 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 3.8)
      message("-- Add warning flags implemented in clang++ 3.8")
      foreach(WARNING_FLAG
          -Wc++1z-compat
          -Wdouble-promotion)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.0 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 5.0)
      message("-- Add warning flags implemented in clang++ 5.0")
      string(REGEX REPLACE "-Wc\\+\\+1z-compat" "-Wc++17-compat" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wzero-as-null-pointer-constant")
    endif()
  endif()

  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COMMON_WARNING_FLAGS} ${C_WARNING_FLAGS}")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g3 -O0 -ftrapv -fstack-protector-all")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -mtune=native -march=native")
  set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -g3 -Og")
  set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -Os -mtune=native -march=native")

  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COMMON_WARNING_FLAGS} ${CXX_WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g3 -O0 -ftrapv -fstack-protector-all")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -mtune=native -march=native")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g3 -Og")
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -mtune=native -march=native")

  set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -s")
  set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL "${CMAKE_EXE_LINKER_FLAGS_MINSIZEREL} -s")


  if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_definitions(-D_FORTIFY_SOURCE=2 -D_GLIBCXX_DEBUG)
  endif()

  install(TARGETS main
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib/static)

  add_custom_target(uninstall xargs rm < install_manifest.txt)
endif()


string(REGEX REPLACE "^ +" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
string(REGEX REPLACE "^ +" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")


option(ENABLE_TESTING "Enable testing with Google Test." OFF)
if(ENABLE_TESTING)
  enable_testing()
  include(cmake/gtest.cmake)
  add_subdirectory(test)
endif()

option(ENABLE_DOXYGEN "Enable to generate document with Doxygen." OFF)
if(ENABLE_DOXYGEN)
  include(cmake/doxygen.cmake)
  add_doxygen(main)
endif()


message(STATUS "Variables")

foreach(VARNAME
    CMAKE_SYSTEM_NAME
    CMAKE_SOURCE_DIR
    CMAKE_BINARY_DIR
    CMAKE_BUILD_TYPE
    CMAKE_CONFIGURATION_TYPES
    CMAKE_COMPILER_IS_GNUCC
    CMAKE_COMPILER_IS_GNUCXX
    CMAKE_C_FLAGS
    CMAKE_C_FLAGS_DEBUG
    CMAKE_C_FLAGS_RELEASE
    CMAKE_C_FLAGS_RELWITHDEBINFO
    CMAKE_C_FLAGS_MINSIZEREL
    CMAKE_CXX_FLAGS
    CMAKE_CXX_FLAGS_DEBUG
    CMAKE_CXX_FLAGS_RELEASE
    CMAKE_CXX_FLAGS_RELWITHDEBINFO
    CMAKE_CXX_FLAGS_MINSIZEREL
    CMAKE_EXE_LINKER_FLAGS
    CMAKE_EXE_LINKER_FLAGS_DEBUG
    CMAKE_EXE_LINKER_FLAGS_RELEASE
    CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO
    CMAKE_EXE_LINKER_FLAGS_MINSIZEREL)
  message(STATUS "${VARNAME}: ${${VARNAME}}")
endforeach(VARNAME)
