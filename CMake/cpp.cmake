cmake_minimum_required(VERSION <%= executable('cmake') ? split(systemlist('cmake --version')[0], ' ')[2] : '3.1' %>)
project(CMakeProject)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(DEFAULT_BUILD_TYPE "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# Version Requirements
# if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
#   if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.4)
#     message(FATAL_ERROR "GCC version must be at least 4.4!")
#   endif()
# elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
#   if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.1)
#     message(FATAL_ERROR "Clang version must be at least 3.1!")
#   endif()
# else()
#   message(WARNING "You are using an unsupported compiler! Compilation has only been tested with Clang and GCC.")
# endif()


add_executable(<+CURSOR+>)
# find_package(Threads REQUIRED)
# target_link_libraries(main Threads::Threads)

if(NOT CMAKE_BUILD_TYPE MATCHES Debug)
  add_definitions(-DNDEBUG)
endif()

if(MSVC)
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
      -Wcast-align
      -Wcast-qual
      -Wconversion
      -Wdisabled-optimization
      -Wfloat-equal
      -Wformat=2
      -Winit-self
      -Winline
      -Wlogical-op
      -Wmissing-declarations
      -Wpointer-arith
      -Wredundant-decls
      -Wstrict-aliasing=2
      -Wswitch-enum
      -Wundef
      -Wunsafe-loop-optimizations
      -Wunreachable-code
      -Wwrite-strings
      -Wno-unknown-pragmas
      -pedantic)
    set(GNU_COMMON_WARNING_FLAGS "${GNU_COMMON_WARNING_FLAGS} ${WARNING_FLAG}")
  endforeach(WARNING_FLAG)

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
      -Winline
      -Wmissing-declarations
      -Wpointer-arith
      -Wredundant-decls
      -Wstrict-aliasing=2
      -Wswitch-enum
      -Wundef
      -Wunreachable-code
      -Wwrite-strings
      -pedantic
      -Wc++-compat
      -Wbad-function-cast
      -Wmissing-prototypes
      -Wc++11-compat
      -Weffc++
      -Woverloaded-virtual
      -Wsign-promo)
    set(CLANG_COMMON_WARNING_FLAGS "${CLANG_COMMON_WARNING_FLAGS} ${WARNING_FLAG}")
  endforeach(WARNING_FLAG)

  if(CMAKE_COMPILER_IS_GNUCC)
    set(C_WARNING_FLAGS "${GNU_COMMON_WARNING_FLAGS}")
    foreach(WARNING_FLAG
        -Wc++-compat
        -Wbad-function-cast
        -Wmissing-prototypes
        -Wunsuffixed-float-constants)
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
          -Wsuggest-attribute=pure)
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
          -Wsuggest-final-methods
          -Wsuggest-final-types)
        set(C_WARNING_FLAGS "${C_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_LESS 7.0)
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} -Wabi")
    else()
      set(C_WARNING_FLAGS "${C_WARNING_FLAGS} -Wabi=11")
    endif()
  elseif("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang")
    set(C_WARNING_FLAGS "${CLANG_COMMON_WARNING_FLAGS}")
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
        -Woverloaded-virtual
        -Wsign-promo
        -Wstrict-null-sentinel)
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
    endforeach(WARNING_FLAG)
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.6 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.6)
      message("-- Add warning flags implemented in g++ 4.6")
      foreach(WARNING_FLAG
          -Wdouble-promotion
          -Wsuggest-attribute=const
          -Wsuggest-attribute=noreturn
          -Wsuggest-attribute=pure)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach()
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 4.7 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 4.7)
      message("-- Add warning flags implemented in g++ 4.7")
      foreach(WARNING_FLAG
          -Wvector-operation-performance
          -Wno-return-local-addr
          -Wc++11-compat
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
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.1 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 5.1)
      message("-- Add warning flags implemented in g++ 5.1")
      foreach(WARNING_FLAG
          -Wsuggest-final-methods
          -Wsuggest-final-types
          -Wsuggest-override
          -Wc++14-compat)
        set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} ${WARNING_FLAG}")
      endforeach(WARNING_FLAG)
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 7.0)
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wabi")
    else()
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wabi=11")
    endif()
  else()
    set(CXX_WARNING_FLAGS "${CLANG_COMMON_WARNING_FLAGS}")
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.5 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 3.5)
      message("-- Add warning flags implemented in clang++ 3.5")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wc++14-compat")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 3.8 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 3.8)
      message("-- Add warning flags implemented in clang++ 3.8")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wdouble-promotion")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 5.0 OR CMAKE_CXX_COMPILER_VERSION VERSION_EQUAL 5.0)
      message("-- Add warning flags implemented in clang++ 5.0")
      set(CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS} -Wzero-as-null-pointer-constant")
    endif()
  endif()

  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${COMMON_WARNING_FLAGS} ${C_WARNING_FLAGS}")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g3 -O0 -pg -ftrapv -fstack-protector-all")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -mtune=native -march=native")
  set(CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} -g3 -Og -pg")
  set(CMAKE_C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} -Os -mtune=native -march=native")

  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${COMMON_WARNING_FLAGS} ${CXX_WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g3 -O0 -pg -ftrapv -fstack-protector-all")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -mtune=native -march=native")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g3 -Og -pg")
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -mtune=native -march=native")

  if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_definitions(-D_FORTIFY_SOURCE=2 -D_GLIBCXX_DEBUG)
  endif()

  if(CMAKE_BUILD_TYPE STREQUAL Release OR CMAKE_BUILD_TYPE STREQUAL MinSizeRel)
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -s")
  endif()

  set(CMAKE_INSTALL_PREFIX "/usr/local/")

  install(TARGETS main
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib/static)

  add_custom_target(uninstall xargs rm < install_manifest.txt)
endif()

if(ENABLE_TESTING)
  enable_testing()
  include(cmake/gtest.cmake)
  add_subdirectory(test)
endif()


message(STATUS "Variables")

message(STATUS "CMAKE_SYSTEM_NAME: ${CMAKE_SYSTEM_NAME}")
message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")
message(STATUS "CMAKE_BINARY_DIR: ${CMAKE_BINARY_DIR}")
message(STATUS "CMAKE_BUILD_TYPE: ${CMAKE_BUILD_TYPE}")
message(STATUS "CMAKE_CONFIGURATION_TYPES: ${CMAKE_CONFIGURATION_TYPES}")
message(STATUS "CMAKE_COMPILER_IS_GNUCC: ${CMAKE_COMPILER_IS_GNUCC}")
message(STATUS "CMAKE_COMPILER_IS_GNUCXX: ${CMAKE_COMPILER_IS_GNUCXX}")

message(STATUS "CMAKE_C_FLAGS: ${CMAKE_C_FLAGS}")
message(STATUS "CMAKE_C_FLAGS_DEBUG: ${CMAKE_C_FLAGS_DEBUG}")
message(STATUS "CMAKE_C_FLAGS_RELEASE: ${CMAKE_C_FLAGS_RELEASE}")
message(STATUS "CMAKE_C_FLAGS_RELWITHDEBINFO: ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
message(STATUS "CMAKE_C_FLAGS_MINSIZEREL: ${CMAKE_C_FLAGS_MINSIZEREL}")

message(STATUS "CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")
message(STATUS "CMAKE_CXX_FLAGS_DEBUG: ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "CMAKE_CXX_FLAGS_RELEASE: ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "CMAKE_CXX_FLAGS_RELWITHDEBINFO: ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
message(STATUS "CMAKE_CXX_FLAGS_MINSIZEREL: ${CMAKE_CXX_FLAGS_MINSIZEREL}")
