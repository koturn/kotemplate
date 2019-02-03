cmake_minimum_required(VERSION 2.8)
project (ProjectName)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 14)
# set(CMAKE_CXX_STANDARD_REQUIRED ON)
# set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(main
  main.cpp
  hoge.cpp)
# find_package(X11 REQUIRED)
# target_link_libraries(main)

if(MSVC)
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

  foreach(flag_var
      CMAKE_CXX_FLAGS
      CMAKE_CXX_FLAGS_DEBUG
      CMAKE_CXX_FLAGS_RELEASE
      CMAKE_CXX_FLAGS_MINSIZEREL
      CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    STRING (REGEX REPLACE "/RTC[^ ]*" "" ${flag_var} "${${flag_var}}")
  endforeach(flag_var)

  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Oi /Ot /Ox /Oy")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Oi /Ot /Ox /Oy /GL")
  # set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} /Os")
elseif(CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wall -Wextra")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wabi")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wcast-align")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wcast-qual")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wconversion")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wdisabled-optimization")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wdouble-promotion")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wfloat-equal")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wformat=2")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Winit-self")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Winline")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wlogical-op")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wmissing-declarations")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wno-return-local-addr")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wpointer-arith")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wredundant-decls")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wstrict-aliasing=2")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wsuggest-attribute=const")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wsuggest-attribute=format")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wsuggest-attribute=noreturn")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wsuggest-attribute=pure")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wsuggest-final-methods")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wsuggest-final-types")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wswitch-enum")
  # set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wundef")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wunsafe-loop-optimizations")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wunreachable-code")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wvector-operation-performance")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wwrite-strings")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -Wno-unknown-pragmas")
  set(C_CXX_COMMON_WARNING_FLAGS "${C_CXX_COMMON_WARNING_FLAGS} -pedantic")

  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${C_CXX_COMMON_WARNING_FLAGS}")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wc++-compat")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wbad-function-cast")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wmissing-prototypes")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wunsuffixed-float-constants")

  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${C_CXX_COMMON_WARNING_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wc++11-compat")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wc++14-compat")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Weffc++")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Woverloaded-virtual")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wsign-promo")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wstrict-null-sentinel")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wsuggest-override")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wuseless-cast")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wzero-as-null-pointer-constant")

  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g3 -O0 -pg -ftrapv -fstack-protector-all")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -mtune=native -march=native -s")
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g3 -Og -pg")
  set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL} -Os -s -mtune=native -march=native")

  set(CMAKE_INSTALL_PREFIX "/usr/local/")

  if (CMAKE_BUILD_TYPE MATCHES Debug)
    add_definitions(-D_FORTIFY_SOURCE=2 -D_GLIBCXX_DEBUG)
  endif()

  install(TARGETS main
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib/static)
endif()

if (NOT CMAKE_BUILD_TYPE MATCHES Debug)
  add_definitions(-DNDEBUG)
endif()

# tests
if(ENABLE_TESTING)
  enable_testing()
  include(cmake/gtest.cmake)
  add_subdirectory(test)
endif()


# Version Requirements
# if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
#   # require at least gcc 4.8
#   if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.8)
#     message(FATAL_ERROR "GCC version must be at least 4.8!")
#   endif()
# elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
#   # require at least clang 3.2
#   if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.2)
#     message(FATAL_ERROR "Clang version must be at least 3.2!")
#   endif()
# else()
#   message(WARNING "You are using an unsupported compiler! Compilation has only been tested with Clang and GCC.")
# endif()

