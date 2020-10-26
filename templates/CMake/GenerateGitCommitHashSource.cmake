include(CMakeParseArguments)

set(GCH_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(generate_gch_sources)
  set(options)
  set(oneValueArgs
    SOURCE
    HEADER
    INCLUDE_GUARD_MACRO
    VARNAME)
  cmake_parse_arguments(GCH "${options}" "${oneValueArgs}" "" ${ARGN})

  if(NOT DEFINED GCH_HEADER)
    message(FATAL_ERROR "[generate_gch_sources] You must specify HEADER option")
  endif()

  execute_process(
    COMMAND git rev-parse HEAD
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    OUTPUT_VARIABLE GCH_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE)


  if(NOT DEFINED GCH_VARNAME)
    set(GCH_VARNAME "kCommitHash")
  endif()

  get_filename_component(GCH_HEADER_FILENAME "${GCH_HEADER}" NAME)
  if(NOT DEFINED GCH_INCLUDE_GUARD_MACRO)
    string(REGEX REPLACE "[^0-9A-Za-z_]" "_" GCH_INCLUDE_GUARD_MACRO "${GCH_HEADER_FILENAME}")
    string(TOUPPER ${GCH_INCLUDE_GUARD_MACRO} GCH_INCLUDE_GUARD_MACRO)
  endif()

  if(DEFINED GCH_SOURCE)
    get_filename_component(GCH_SOURCE_DIR "${GCH_SOURCE}" DIRECTORY)
    file(RELATIVE_PATH GCH_HEADER_RELPATH "${GCH_SOURCE_DIR}" "${GCH_HEADER}")

    configure_file(
      ${GCH_CURRENT_LIST_DIR}/templates/GitCommitHash.c.in
      ${GCH_SOURCE}
      @ONLY)
    if("${GCH_SOURCE}" MATCHES "\\.c$")
      configure_file(
        ${GCH_CURRENT_LIST_DIR}/templates/GitCommitHashC.h.in
        ${GCH_HEADER}
        @ONLY)
      message(STATUS "[generate_gch_sources] Generated C source and its header file.")
    else()
      configure_file(
        ${GCH_CURRENT_LIST_DIR}/templates/GitCommitHashCxx.h.in
        ${GCH_HEADER}
        @ONLY)
      message(STATUS "[generate_gch_sources] Generated C++ source and its header file.")
    endif()
    message(STATUS "[generate_gch_sources] Configure done. Output file: ${GCH_SOURCE}")
    message(STATUS "[generate_gch_sources] Configure done. Output file: ${GCH_HEADER}")
  else()
    configure_file(
      ${GCH_CURRENT_LIST_DIR}/templates/GitCommitHash.hpp.in
      ${GCH_HEADER}
      @ONLY)
    message(STATUS "[generate_gch_sources] Generated C++ header file (header only)")
    message(STATUS "[generate_gch_sources] Configure done. Output file: ${GCH_HEADER}")
  endif()
endfunction()
