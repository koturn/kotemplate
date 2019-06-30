function(generate_gch_sources source_file header_file)
  execute_process(
    COMMAND git rev-parse HEAD
    OUTPUT_VARIABLE GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  get_filename_component(GCH_HEADER_FILENAME "${header_file}" NAME)
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/GitCommitHash.c.in
    ${source_file})

  string(REGEX REPLACE "[^0-9A-Za-z_]" "_" GCH_INCLUDE_GUARD_MACRO "${GCH_HEADER_FILENAME}")
  string(TOUPPER ${GCH_INCLUDE_GUARD_MACRO} GCH_INCLUDE_GUARD_MACRO)
  configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/templates/GitCommitHash.h.in
    ${header_file})
endfunction()
