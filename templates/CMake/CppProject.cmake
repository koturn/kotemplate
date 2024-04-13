cmake_minimum_required(VERSION <%= executable('cmake') ? split(systemlist('cmake --version')[0], ' ')[2] : '3.1' %>)
project(<+DIR+>
  VERSION "1.0.0.0"
  LANGUAGES C CXX)

set(BUILD_TARGET ${PROJECT_NAME}<+CURSOR+>)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_USE_RELATIVE_PATHS ON)


# C Compiler Version Requirements
if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_C_COMPILER_VERSION VERSION_LESS 4.4)
    message(FATAL_ERROR "GCC version must be at least 4.4!")
  endif()
elseif(CMAKE_C_COMPILER_ID STREQUAL "Clang")
  if(CMAKE_C_COMPILER_VERSION VERSION_LESS 3.1)
    message(FATAL_ERROR "Clang version must be at least 3.1!")
  endif()
endif()

# C++ Compiler Version Requirements
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.4)
    message(FATAL_ERROR "GCC version must be at least 4.4!")
  endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 3.1)
    message(FATAL_ERROR "Clang version must be at least 3.1!")
  endif()
endif()


set(DEFAULT_BUILD_TYPE "Release")
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to '${DEFAULT_BUILD_TYPE}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${DEFAULT_BUILD_TYPE}" CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()


file(GLOB SRCS *.c *.cpp *.cxx *.cc *.h *.hpp *.hxx *.hh *.inl)
add_executable(
  ${BUILD_TARGET}
  ${SRCS})

# target_include_directories(${BUILD_TARGET} PRIVATE ${CMAKE_SOURCE_DIR})

# find_package(Threads REQUIRED)
# target_link_libraries(${BUILD_TARGET} PRIVATE m Threads::Threads)

if(CMAKE_SYSTEM_PROCESSOR MATCHES "i686.*|i386.*|x86.*")
  set(SYSTEM_PROCESSOR_IS_X86 TRUE)
endif()
if(CMAKE_SYSTEM_PROCESSOR MATCHES "amd64.*|x86_64.*|AMD64.*")
  set(SYSTEM_PROCESSOR_IS_X64 TRUE)
endif()


if(MSVC OR CYGWIN OR MINGW OR MSYS)
  list(APPEND DEFINES "WIN32_LEAN_AND_MEAN" "NOMINMAX")
endif()
if(MSVC)
  list(APPEND DEFINES "_USE_MATH_DEFINES" "_CRT_NONSTDC_NO_WARNINGS" "_CRT_SECURE_NO_WARNINGS")
  list(APPEND DEFINES_DEBUG "_DEBUG")
  list(APPEND DEFINES_RELWITHDEBINFO "_DEBUG")
else()
  list(APPEND DEFINES_RELEASE "NDEBUG")
  list(APPEND DEFINES_MINSIZEREL "NDEBUG")
  list(APPEND DEFINES_DEBUG "_FORTIFY_SOURCE=2" "_GLIBCXX_DEBUG")
endif()

if(MSVC)
  foreach(TARGET_FLAG
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
    string(REGEX REPLACE "/RTC[^ ]*" "" ${TARGET_FLAG} "${${TARGET_FLAG}}")
    string(REGEX REPLACE "/W[0-4]" "/W4" ${TARGET_FLAG} "${${TARGET_FLAG}}")
  endforeach(TARGET_FLAG)

  # list(APPEND C_FLAGS "/utf-8")
  # list(APPEND C_FLAGS "/source-charset:utf-8")
  # list(APPEND C_FLAGS "/execution-charset:utf-8")
  list(APPEND C_FLAGS_DEBUG "/Oi" "/Oy")
  list(APPEND C_FLAGS_RELEASE "/Ob2" "/Oi" "/Ot" "/Ox" "/Oy" "/GL")
  list(APPEND C_FLAGS_MINSIZEREL "/Os")

  # list(APPEND CXX_FLAGS "/utf-8")
  # list(APPEND CXX_FLAGS "/source-charset:utf-8")
  # list(APPEND CXX_FLAGS "/execution-charset:utf-8")
  list(APPEND CXX_FLAGS_DEBUG "/Oi" "/Oy")
  list(APPEND CXX_FLAGS_RELEASE "/Ob2" "/Oi" "/Ot" "/Ox" "/Oy" "/GL")
  list(APPEND CXX_FLAGS_MINSIZEREL "/Os")

  list(APPEND EXE_LINKER_FLAGS_RELEASE "/LTCG")
else()
  set(GNU_CLANG_COMMON_WARNING_FLAGS
    "-Wall"
    "-Wextra"
    "-Wabi"
    "-Wcast-align"
    "-Wcast-qual"
    "-Wconversion"
    "-Wdisabled-optimization"
    "-Wfloat-equal"
    "-Wformat=2"
    "-Winit-self"
    "-Winvalid-pch"
    "-Wmissing-declarations"
    "-Wpointer-arith"
    "-Wredundant-decls"
    "-Wstack-protector"
    "-Wstrict-aliasing=2"
    "-Wstrict-overflow=5"
    "-Wswitch-enum"
    "-Wswitch-default"
    "-Wunknown-pragmas"
    "-Wunreachable-code"
    "-Wwrite-strings"
    "-pedantic")

  option(ENABLE_ADDITIONAL_WARNING_FLAGS "Enable additional warning flags." OFF)
  if(ENABLE_ADDITIONAL_WARNING_FLAGS)
    list(APPEND GNU_CLANG_COMMON_WARNING_FLAGS "-Winline" "-Wsign-conversion")
  endif()

  set(GNU_COMMON_WARNING_FLAGS "${GNU_CLANG_COMMON_WARNING_FLAGS}" "-Wlogical-op")
  if(ENABLE_ADDITIONAL_WARNING_FLAGS)
    list(APPEND GNU_COMMON_WARNING_FLAGS "-Wunsafe-loop-optimizations")
  endif()

  set(CLANG_COMMON_WARNING_FLAGS "${GNU_CLANG_COMMON_WARNING_FLAGS}" "-Wsign-promo")

  if(CMAKE_COMPILER_IS_GNUCC)
    set(C_WARNING_FLAGS
      "${GNU_COMMON_WARNING_FLAGS}"
      "-Wc++-compat"
      "-Wbad-function-cast"
      "-Wmissing-prototypes"
      "-Wnested-externs"
      "-Wold-style-definition"
      "-Wstrict-prototypes")

    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 4.5)
      message(STATUS "Add warning flags implemented in gcc 4.5")
      list(APPEND C_WARNING_FLAGS
        "-Wjump-misses-init"
        "-Wunsuffixed-float-constants")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 4.6)
      message(STATUS "Add warning flags implemented in gcc 4.6")
      list(APPEND C_WARNING_FLAGS
        "-Wdouble-promotion"
        "-Wsuggest-attribute=const"
        "-Wsuggest-attribute=noreturn"
        "-Wsuggest-attribute=pure"
        "-Wtrampolines")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 4.7)
      message(STATUS "Add warning flags implemented in gcc 4.7")
      list(APPEND C_WARNING_FLAGS
        "-Wno-return-local-addr"
        "-Wvector-operation-performance")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 4.8)
      message(STATUS "Add warning flags implemented in gcc 4.8")
      list(APPEND C_WARNING_FLAGS "-Wsuggest-attribute=format")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 5.1)
      message(STATUS "Add warning flags implemented in gcc 5.1")
      list(APPEND C_WARNING_FLAGS
        "-Wformat-signedness"
        "-Wsuggest-final-methods"
        "-Wsuggest-final-types")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 6.0)
      message(STATUS "Add warning flags implemented in gcc 6.0")
      list(APPEND C_WARNING_FLAGS
        "-Wduplicated-cond"
        "-Wshift-overflow=2")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 7.0)
      message(STATUS "Add warning flags implemented in gcc 7.0")
      string(REGEX REPLACE "-Wabi" "-Wabi=11" C_WARNING_FLAGS "${C_WARNING_FLAGS}")
      list(APPEND C_WARNING_FLAGS
        "-Walloc-zero"
        "-Wduplicated-branches"
        "-Wformat-overflow=2"
        "-Wformat-truncation=2"
        "-Wrestrict"
        "-Wshadow-local"
        "-Wstringop-overflow=4")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 8.0)
      message(STATUS "Add warning flags implemented in gcc 8.0")
      string(REGEX REPLACE "-Wcast-align" "-Wcast-align=strict" C_WARNING_FLAGS "${C_WARNING_FLAGS}")
      list(APPEND C_WARNING_FLAGS "-Wsuggest-attribute=malloc")
    endif()

    set(C_FLAGS "-pipe" "${C_WARNING_FLAGS}")
    set(C_FLAGS_DEBUG "-g3" "-O0" "-ftrapv -fstack-protector-all")
    set(C_FLAGS_RELEASE "-O3")
    set(C_FLAGS_MINSIZEREL "-Os")
    if(SYSTEM_PROCESSOR_IS_X86 OR SYSTEM_PROCESSOR_IS_X64)
      list(APPEND C_FLAGS_RELEASE "-mtune=native" "-march=native")
      set(C_FLAGS_MINSIZEREL "${C_FLAGS_MINSIZEREL}" "-mtune=native" "-march=native")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_LESS 4.8)
      set(C_FLAGS_RELWITHDEBINFO "-g" "-O2")
    else()
      set(C_FLAGS_RELWITHDEBINFO "-g" "-Og")
    endif()
  elseif(CMAKE_C_COMPILER_ID STREQUAL "Clang")
    set(C_WARNING_FLAGS
      "${CLANG_COMMON_WARNING_FLAGS}"
      "-Wc++-compat"
      "-Wbad-function-cast"
      "-Wmissing-prototypes")

    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 3.5)
      message(STATUS "Add warning flags implemented in clang 3.5")
      list(APPEND C_WARNING_FLAGS "-Wc++14-compat")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 3.8)
      message(STATUS "Add warning flags implemented in clang 3.8")
      list(APPEND C_WARNING_FLAGS "-Wdouble-promotion")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_GREATER_EQUAL 5.0)
      message(STATUS "Add warning flags implemented in clang 5.0")
      list(APPEND C_WARNING_FLAGS "-Wzero-as-null-pointer-constant")
    endif()

    set(C_FLAGS "${CMAKE_C_FLAGS}" "-pipe" "${C_WARNING_FLAGS}")
    set(C_FLAGS_DEBUG "-g3" "-O0" "-ftrapv" "-fstack-protector-all")
    set(C_FLAGS_RELEASE "-O3")
    set(C_FLAGS_MINSIZEREL "-s")
    if(SYSTEM_PROCESSOR_IS_X86 OR SYSTEM_PROCESSOR_IS_X64)
      list(APPEND C_FLAGS_RELEASE "-mtune=native" "-march=native")
      list(APPEND C_FLAGS_MINSIZEREL "-mtune=native" "-march=native")
    endif()
    if(CMAKE_C_COMPILER_VERSION VERSION_LESS 4.0)
      set(C_FLAGS_RELWITHDEBINFO "-g" "-O2")
    else()
      set(C_FLAGS_RELWITHDEBINFO "-g" "-Og")
    endif()
  else()
    set(C_FLAGS "${CMAKE_C_FLAGS}")
    set(C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
    set(C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
    set(C_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL}")
    set(C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}")
  endif()

  if(CMAKE_COMPILER_IS_GNUCXX)
    set(CXX_WARNING_FLAGS
      "${GNU_COMMON_WARNING_FLAGS}"
      "-Weffc++"
      "-Wctor-dtor-privacy"
      "-Wnon-virtual-dtor"
      "-Wold-style-cast"
      "-Woverloaded-virtual"
      "-Wreorder"
      "-Wsign-promo"
      "-Wstrict-null-sentinel")

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.3)
      message(STATUS "Add warning flags implemented in g++ 4.3")
      list(APPEND CXX_WARNING_FLAGS "-Wc++0x-compat")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.6)
      message(STATUS "Add warning flags implemented in g++ 4.6")
      list(APPEND CXX_WARNING_FLAGS
        "-Wdouble-promotion"
        "-Wnoexcept"
        "-Wsuggest-attribute=const"
        "-Wsuggest-attribute=noreturn"
        "-Wsuggest-attribute=pure"
        "-Wtrampolines")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.7)
      message(STATUS "Add warning flags implemented in g++ 4.7")
      string(REGEX REPLACE "-Wc\\+\\+0x-compat" "-Wc++11-compat" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      list(APPEND CXX_WARNING_FLAGS
        "-Wdelete-non-virtual-dtor"
        "-Wvector-operation-performance"
        "-Wno-return-local-addr"
        "-Wzero-as-null-pointer-constant")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.8)
      message(STATUS "Add warning flags implemented in g++ 4.8")
      list(APPEND CXX_WARNING_FLAGS
        "-Wsuggest-attribute=format"
        "-Wuseless-cast")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 4.9)
      message(STATUS "Add warning flags implemented in g++ 4.9")
      list(APPEND CXX_WARNING_FLAGS "-Wconditionally-supported")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 5.1)
      message(STATUS "Add warning flags implemented in g++ 5.1")
      list(APPEND CXX_WARNING_FLAGS
        "-Wc++14-compat"
        "-Wformat-signedness"
        "-Wsuggest-final-methods"
        "-Wsuggest-final-types"
        "-Wsuggest-override")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 6.0)
      message(STATUS "Add warning flags implemented in g++ 6.0")
      list(APPEND CXX_WARNING_FLAGS
        "-Wduplicated-cond"
        "-Wplacement-new=2"
        "-Wshift-overflow=2")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 7.0)
      message(STATUS "Add warning flags implemented in g++ 7.0")
      string(REGEX REPLACE "-Wabi" "-Wabi=11" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      list(APPEND CXX_WARNING_FLAGS
        "-Wc++17-compat"
        "-Walloc-zero"
        "-Wduplicated-branches"
        "-Wformat-overflow=2"
        "-Wformat-truncation=2"
        "-Wregister"
        "-Wrestrict"
        "-Wshadow-local"
        "-Wstringop-overflow=4")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 8.0)
      message(STATUS "Add warning flags implemented in g++ 8.0")
      string(REGEX REPLACE "-Wcast-align" "-Wcast-align=strict" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      list(APPEND CXX_WARNING_FLAGS "-Wsuggest-attribute=malloc")
    endif()

    set(CXX_FLAGS "${CMAKE_CXX_FLAGS}" "-pipe" "${CXX_WARNING_FLAGS}")
    set(CXX_FLAGS_DEBUG "-g3" "-O0" "-ftrapv" "-fstack-protector-all")
    set(CXX_FLAGS_RELEASE "-O3")
    set(CXX_FLAGS_MINSIZEREL "-Os")
    if(SYSTEM_PROCESSOR_IS_X86 OR SYSTEM_PROCESSOR_IS_X64)
      list(APPEND CXX_FLAGS_RELEASE "-mtune=native" "-march=native")
      list(APPEND CXX_FLAGS_MINSIZEREL "-mtune=native" "-march=native")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.8)
      set(CXX_FLAGS_RELWITHDEBINFO "-g" "-O2")
    else()
      set(CXX_FLAGS_RELWITHDEBINFO "-g" "-Og")
    endif()
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CXX_WARNING_FLAGS "${CLANG_COMMON_WARNING_FLAGS}")
    list(APPEND CXX_WARNING_FLAGS
      "-Wc++11-compat"
      "-Weffc++"
      "-Wctor-dtor-privacy"
      "-Wdelete-non-virtual-dtor"
      "-Wnon-virtual-dtor"
      "-Wold-style-cast"
      "-Woverloaded-virtual"
      "-Wreorder")

    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.5)
      message(STATUS "Add warning flags implemented in clang++ 3.5")
      list(APPEND CXX_WARNING_FLAGS "-Wc++14-compat")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 3.8)
      message(STATUS "Add warning flags implemented in clang++ 3.8")
      list(APPEND CXX_WARNING_FLAGS
        "-Wc++1z-compat"
        "-Wdouble-promotion")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 5.0)
      message(STATUS "Add warning flags implemented in clang++ 5.0")
      string(REGEX REPLACE "-Wc\\+\\+1z-compat" "-Wc++17-compat" CXX_WARNING_FLAGS "${CXX_WARNING_FLAGS}")
      list(CXX_WARNING_FLAGS "-Wzero-as-null-pointer-constant")
    endif()

    set(CXX_FLAGS "${CMAKE_CXX_FLAGS}" "-pipe" "${CXX_WARNING_FLAGS}")
    set(CXX_FLAGS_DEBUG "-g3" "-O0" "-ftrapv" "-fstack-protector-all")
    set(CXX_FLAGS_RELEASE "-O3")
    set(CXX_FLAGS_MINSIZEREL "-s")
    if(SYSTEM_PROCESSOR_IS_X86 OR SYSTEM_PROCESSOR_IS_X64)
      list(APPEND CXX_FLAGS_RELEASE "-mtune=native" "-march=native")
      list(APPEND CXX_FLAGS_MINSIZEREL "-mtune=native" "-march=native")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.0)
      set(CXX_FLAGS_RELWITHDEBINFO "-g" "-O2")
    else()
      set(CXX_FLAGS_RELWITHDEBINFO "-g" "-Og")
    endif()
  else()
    set(CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    set(CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
    set(CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
    set(CXX_FLAGS_MINSIZEREL "${CMAKE_CXX_FLAGS_MINSIZEREL}")
    set(CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  endif()

  set(EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}" "-s" "-Wl,-O1")
  set(EXE_LINKER_FLAGS_MINSIZEREL "${CMAKE_EXE_LINKER_FLAGS_MINSIZEREL}" "-s")

  install(TARGETS ${BUILD_TARGET}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib/static)

  add_custom_target(uninstall xargs rm < install_manifest.txt)
endif()

target_compile_definitions(
  ${BUILD_TARGET} PRIVATE
  ${DEFINES}
  $<$<CONFIG:Release>:${DEFINES_RELEASE}>
  $<$<CONFIG:Debug>:${DEFINES_DEBUG}>
  $<$<CONFIG:RelWithDebInfo>:${DEFINES_RELWITHDEBINFO}>
  $<$<CONFIG:MinSizeRel>:${DEFINES_MINSIZEREL}>)

get_property(PROJECT_LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)

if("C" IN_LIST PROJECT_LANGUAGES)
  target_compile_options(
    ${BUILD_TARGET} PRIVATE
    $<$<COMPILE_LANGUAGE:C>:
      ${C_FLAGS}
      $<$<CONFIG:Release>:${C_FLAGS_RELEASE}>
      $<$<CONFIG:Debug>:${C_FLAGS_DEBUG}>
      $<$<CONFIG:RelWithDebInfo>:${C_FLAGS_RELWITHDEBINFO}>
      $<$<CONFIG:MinSizeRel>:${C_FLAGS_MINSIZEREL}>
    >)
endif()

if("CXX" IN_LIST PROJECT_LANGUAGES)
  target_compile_options(
    ${BUILD_TARGET} PRIVATE
    $<$<COMPILE_LANGUAGE:CXX>:
      ${CXX_FLAGS}
      $<$<CONFIG:Release>:${CXX_FLAGS_RELEASE}>
      $<$<CONFIG:Debug>:${CXX_FLAGS_DEBUG}>
      $<$<CONFIG:RelWithDebInfo>:${CXX_FLAGS_RELWITHDEBINFO}>
      $<$<CONFIG:MinSizeRel>:${CXX_FLAGS_MINSIZEREL}>
    >)
endif()

if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.13)
  target_link_options(
    ${BUILD_TARGET} PRIVATE
    ${EXE_LINKER_FLAGS}
    $<$<CONFIG:Release>:${EXE_LINKER_FLAGS_RELEASE}>
    $<$<CONFIG:Debug>:${EXE_LINKER_FLAGS_DEBUG}>
    $<$<CONFIG:RelWithDebInfo>:${EXE_LINKER_FLAGS_RELWITHDEBINFO}>
    $<$<CONFIG:MinSizeRel>:${EXE_LINKER_FLAGS_MINSIZEREL}>)
else()
  foreach(TARGET_FLAG
      EXE_LINKER_FLAGS
      EXE_LINKER_FLAGS_DEBUG
      EXE_LINKER_FLAGS_RELEASE
      EXE_LINKER_FLAGS_RELWITHDEBINFO
      EXE_LINKER_FLAGS_MINSIZEREL)
    string(REPLACE ";" " " ${TARGET_FLAG} "${${TARGET_FLAG}}")
    string(REGEX REPLACE "  +" " " "CMAKE_${TARGET_FLAG}" "${${TARGET_FLAG}}")
  endforeach(TARGET_FLAG)
endif()


option(ENABLE_TESTING "Enable testing with Google Test." OFF)
if(ENABLE_TESTING)
  enable_testing()
  include(cmake/gtest.cmake)
  add_subdirectory(test)
endif()

option(ENABLE_DOXYGEN "Enable to generate document with Doxygen." OFF)
if(ENABLE_DOXYGEN)
  include(cmake/doxygen.cmake)
  add_doxygen(${BUILD_TARGET})
endif()


message(STATUS "Variables")

foreach(VARNAME
    CMAKE_SYSTEM_NAME
    CMAKE_SYSTEM_PROCESSOR
    CMAKE_SOURCE_DIR
    CMAKE_BINARY_DIR
    CMAKE_BUILD_TYPE
    CMAKE_CONFIGURATION_TYPES
    CMAKE_COMPILER_IS_GNUCC
    CMAKE_COMPILER_IS_GNUCXX
    CMAKE_C_COMPILER
    CMAKE_C_COMPILER_VERSION
    CMAKE_C_COMPILER_ID
    CMAKE_C_STANDARD
    CMAKE_C_STANDARD_REQUIRED
    CMAKE_C_EXTENSIONS
    CMAKE_C_FLAGS
    CMAKE_C_FLAGS_DEBUG
    CMAKE_C_FLAGS_RELEASE
    CMAKE_C_FLAGS_RELWITHDEBINFO
    CMAKE_C_FLAGS_MINSIZEREL
    CMAKE_CXX_COMPILER
    CMAKE_CXX_COMPILER_VERSION
    CMAKE_CXX_COMPILER_ID
    CMAKE_CXX_STANDARD
    CMAKE_CXX_STANDARD_REQUIRED
    CMAKE_CXX_EXTENSIONS
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
