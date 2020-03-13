include(CMakeParseArguments)

set(VERSIONRC_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_DIR}")

# You can specify resource strings in arguments:
#   NAME                      - Name of executable
#   PRODUCT_NAME              - Name of product (${NAME} is default)
#   FILE_DESCRIPTION          - ${NAME} is default
#   VERSION_MAJOR             - Default: ${PROJECT_VERSION_MAJOR} if defined, otherwise 1.
#   VERSION_MINOR             - Default: ${PROJECT_VERSION_MINOR} if defined, otherwise 0.
#   VERSION_PATCH             - Default: ${PROJECT_VERSION_PATCH} if defined, otherwise 0.
#   VERSION_TWEAK             - Default: ${PROJECT_VERSION_TWEAK} if defined, otherwise 0.
#   FILE_VERSION_MAJOR        - Default: ${VERSION_MAJOR}
#   FILE_VERSION_MINOR        - Default: ${VERSION_MINOR}
#   FILE_VERSION_PATCH        - Default: ${VERSION_PATCH}
#   FILE_VERSION_TWEAK        - Default: ${VERSION_TWEAK}
#   PRODUCT_VERSION_MAJOR     - Default: ${VERSION_MAJOR}
#   PRODUCT_VERSION_MINOR     - Default: ${VERSION_MINOR}
#   PRODUCT_VERSION_PATCH     - Default: ${VERSION_PATCH}
#   PRODUCT_VERSION_TWEAK     - Default: ${VERSION_TWEAK}
#   COMPANY_NAME              - Your company name (no defaults)
#   COMPANY_COPYRIGHT         - Default: Copyright (C) ${CURRENT_YEAR} ${COMPANY_NAME} is default if ${COMPANY_NAME} is defined, otherwise "".
#   COMMENTS                  - Default: ${NAME} v${VERSION_MAJOR}.${VERSION_MINOR} is default
#   ORIGINAL_FILENAME         - Default: ${NAME} is default
#   INTERNAL_NAME             - Default: ${NAME} is default
#   FILEFLAGS                 - Default: "VS_FF_DEBUG" if {CMAKE_BUILD_TYPE} is "Debug" or "RelWithDebInfo", otherwise 0x0L.
#   FILETYPE                  - Default: "VFT_APP"
#   FILESUBTYPE               - Default: "0x0L"
function(generate_version_rcfile rcfile)
  set(options)
  set(oneValueArgs
    NAME
    PRODUCT_NAME
    FILE_DESCRIPTION
    VERSION_MAJOR
    VERSION_MINOR
    VERSION_PATCH
    VERSION_TWEAK
    FILE_VERSION_MAJOR
    FILE_VERSION_MINOR
    FILE_VERSION_PATCH
    FILE_VERSION_TWEAK
    PRODUCT_VERSION_MAJOR
    PRODUCT_VERSION_MINOR
    PRODUCT_VERSION_PATCH
    PRODUCT_VERSION_TWEAK
    COMPANY_NAME
    COMPANY_COPYRIGHT
    COMMENTS
    ORIGINAL_FILENAME
    INTERNAL_NAME
    DEBUG_BUILD
    FILEFLAGS
    FILETYPE
    FILESUBTYPE)
  cmake_parse_arguments(VERSIONRC "${options}" "${oneValueArgs}" "" ${ARGN})

  if(NOT DEFINED VERSIONRC_PRODUCT_NAME)
    if(DEFINED PROJECT_NAME)
      set(VERSIONRC_PRODUCT_NAME "${PROJECT_NAME}")
    else()
      set(VERSIONRC_PRODUCT_NAME "${VERSIONRC_NAME}")
    endif()
  endif()
  if(NOT DEFINED VERSIONRC_FILE_DESCRIPTION)
    if(DEFINED PROJECT_DESCRIPTION)
      set(VERSIONRC_FILE_DESCRIPTION "${PROJECT_DESCRIPTION}")
    else()
      set(VERSIONRC_FILE_DESCRIPTION "${VERSIONRC_NAME}")
    endif()
  endif()

  # Version (Default value for file version and product version)
  if(DEFINED PROJECT_VERSION
      AND NOT DEFINED VERSIONRC_VERSION_MAJOR
      AND NOT DEFINED VERSIONRC_VERSION_MINOR
      AND NOT DEFINED VERSIONRC_VERSION_PATCH
      AND NOT DEFINED VERSIONRC_VERSION_TWEAK)
    if(DEFINED PROJECT_VERSION_MAJOR AND NOT "${PROJECT_VERSION_MAJOR}" STREQUAL "")
      set(VERSIONRC_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
    else()
      set(VERSIONRC_VERSION_MAJOR 1)
    endif()
    if(DEFINED PROJECT_VERSION_MINOR AND NOT "${PROJECT_VERSION_MINOR}" STREQUAL "")
      set(VERSIONRC_VERSION_MINOR ${PROJECT_VERSION_MINOR})
    else()
      set(VERSIONRC_VERSION_MINOR 0)
    endif()
    if(DEFINED PROJECT_VERSION_PATCH AND NOT "${PROJECT_VERSION_PATCH}" STREQUAL "")
      set(VERSIONRC_VERSION_PATCH ${PROJECT_VERSION_PATCH})
    else()
      set(VERSIONRC_VERSION_PATCH 0)
    endif()
    if(DEFINED PROJECT_VERSION_TWEAK AND NOT "${PROJECT_VERSION_TWEAK}" STREQUAL "")
      set(VERSIONRC_VERSION_TWEAK ${PROJECT_VERSION_TWEAK})
    else()
      set(VERSIONRC_VERSION_TWEAK 0)
    endif()
  else()
    if(NOT DEFINED VERSIONRC_VERSION_MAJOR)
      set(VERSIONRC_VERSION_MAJOR 1)
    endif()
    if(NOT DEFINED VERSIONRC_VERSION_MINOR)
      set(VERSIONRC_VERSION_MINOR 0)
    endif()
    if(NOT DEFINED VERSIONRC_VERSION_PATCH)
      set(VERSIONRC_VERSION_PATCH 0)
    endif()
    if(NOT DEFINED VERSIONRC_VERSION_TWEAK)
      set(VERSIONRC_VERSION_TWEAK 0)
    endif()
  endif()

  # File version
  if(NOT DEFINED VERSIONRC_FILE_VERSION_MAJOR
      AND NOT DEFINED VERSIONRC_FILE_VERSION_MINOR
      AND NOT DEFINED VERSIONRC_FILE_VERSION_PATCH
      AND NOT DEFINED VERSIONRC_FILE_VERSION_TWEAK)
    set(VERSIONRC_FILE_VERSION_MAJOR ${VERSIONRC_VERSION_MAJOR})
    set(VERSIONRC_FILE_VERSION_MINOR ${VERSIONRC_VERSION_MINOR})
    set(VERSIONRC_FILE_VERSION_PATCH ${VERSIONRC_VERSION_PATCH})
    set(VERSIONRC_FILE_VERSION_TWEAK ${VERSIONRC_VERSION_TWEAK})
  else()
    if(NOT DEFINED VERSIONRC_FILE_VERSION_MAJOR)
      set(VERSIONRC_FILE_VERSION_MAJOR 1)
    endif()
    if(NOT DEFINED VERSIONRC_FILE_VERSION_MINOR)
      set(VERSIONRC_FILE_VERSION_MINOR 0)
    endif()
    if(NOT DEFINED VERSIONRC_FILE_VERSION_PATCH)
      set(VERSIONRC_FILE_VERSION_PATCH 0)
    endif()
    if(NOT DEFINED VERSIONRC_FILE_VERSION_TWEAK)
      set(VERSIONRC_FILE_VERSION_TWEAK 0)
    endif()
  endif()

  # Product version
  if(NOT DEFINED VERSIONRC_PRODUCT_VERSION_MAJOR
      AND NOT DEFINED VERSIONRC_PRODUCT_VERSION_MINOR
      AND NOT DEFINED VERSIONRC_PRODUCT_VERSION_PATCH
      AND NOT DEFINED VERSIONRC_PRODUCT_VERSION_TWEAK)
    set(VERSIONRC_PRODUCT_VERSION_MAJOR ${VERSIONRC_VERSION_MAJOR})
    set(VERSIONRC_PRODUCT_VERSION_MINOR ${VERSIONRC_VERSION_MINOR})
    set(VERSIONRC_PRODUCT_VERSION_PATCH ${VERSIONRC_VERSION_PATCH})
    set(VERSIONRC_PRODUCT_VERSION_TWEAK ${VERSIONRC_VERSION_TWEAK})
  else()
    if(NOT DEFINED VERSIONRC_PRODUCT_VERSION_MAJOR)
      set(VERSIONRC_PRODUCT_VERSION_MAJOR 1)
    endif()
    if(NOT DEFINED VERSIONRC_PRODUCT_VERSION_MINOR)
      set(VERSIONRC_PRODUCT_VERSION_MINOR 0)
    endif()
    if(NOT DEFINED VERSIONRC_PRODUCT_VERSION_PATCH)
      set(VERSIONRC_PRODUCT_VERSION_PATCH 0)
    endif()
    if(NOT DEFINED VERSIONRC_PRODUCT_VERSION_TWEAK)
      set(VERSIONRC_PRODUCT_VERSION_TWEAK 0)
    endif()
  endif()

  if(NOT DEFINED VERSIONRC_COMPANY_COPYRIGHT
      AND DEFINED VERSIONRC_COMPANY_NAME)
    string(TIMESTAMP VERSIONRC_CURRENT_YEAR "%Y")
    set(VERSIONRC_COMPANY_COPYRIGHT "Copyright (C) ${VERSIONRC_CURRENT_YEAR} ${VERSIONRC_COMPANY_NAME} All Rights Reserverd.")
  endif()
  if(NOT DEFINED VERSIONRC_COMMENTS
      AND DEFINED VERSIONRC_NAME)
    set(VERSIONRC_COMMENTS "${VERSIONRC_NAME} v${VERSIONRC_VERSION_MAJOR}.${VERSIONRC_VERSION_MINOR}")
  endif()
  if(NOT DEFINED VERSIONRC_ORIGINAL_FILENAME
      AND DEFINED VERSIONRC_NAME)
    set(VERSIONRC_ORIGINAL_FILENAME "${VERSIONRC_NAME}")
  endif()
  if(NOT DEFINED VERSIONRC_INTERNAL_NAME
      AND DEFINED VERSIONRC_NAME)
    set(VERSIONRC_INTERNAL_NAME "${VERSIONRC_NAME}")
  endif()

  if(CMAKE_GENERATOR MATCHES "Visual Studio")
    if("${VERSIONRC_FILEFLAGS}" STREQUAL "")
      set(VERSIONRC_FILEFLAGS_DECL "#ifdef _DEBUG\n FILEFLAGS VS_FF_DEBUG\n#else\n FILEFLAGS 0x0L\n#endif")
    else()
      set(VERSIONRC_FILEFLAGS_DECL "#ifdef _DEBUG\n FILEFLAGS VS_FF_DEBUG | ${VERSIONRC_FILEFLAGS}\n#else\n FILEFLAGS ${VERSIONRC_FILEFLAGS}\n#endif")
    endif()
  else()
    if("${VERSIONRC_FILEFLAGS}" STREQUAL "")
      if("${CMAKE_BUILD_TYPE}" STREQUAL "Debug" OR "${CMAKE_BUILD_TYPE}" STREQUAL "RelWithDebInfo")
        set(VERSIONRC_FILEFLAGS "VS_FF_DEBUG")
      else()
        set(VERSIONRC_FILEFLAGS "0x0L")
      endif()
      set(VERSIONRC_FILEFLAGS_DECL " FILEFLAGS ${VERSIONRC_FILEFLAGS}")
    endif()
  endif()
  if("${VERSIONRC_FILETYPE}" STREQUAL "")
    set(VERSIONRC_FILETYPE "VFT_APP")
  endif()
  if("${VERSIONRC_FILESUBTYPE}" STREQUAL "")
    set(VERSIONRC_FILESUBTYPE "0x0L")
  endif()

  configure_file(
    ${VERSIONRC_CURRENT_LIST_DIR}/cmake/templates/VersionInfo.rc.in
    ${rcfile}
    @ONLY)
  message(STATUS "Configure done. Output file: ${rcfile}")
endfunction()
