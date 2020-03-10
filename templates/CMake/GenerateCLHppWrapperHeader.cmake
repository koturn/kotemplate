include(CMakeParseArguments)

function(generate_clhpp_wrapper_header header_file_path)
  set(options)
  set(oneValueArgs
    HEADER_VERSION
    ENABLE_EXCEPTIONS
    MINIMUM_OPENCL_VERSION
    TARGET_OPENCL_VERSION
    SILENCE_DEPRECATION)
  cmake_parse_arguments(CL_HPP "${options}" "${oneValueArgs}" "" ${ARGN})

  if(NOT DEFINED CL_HPP_HEADER_VERSION)
    set(CL_HPP_HEADER_VERSION "2")
  endif()

  if(CL_HPP_SILENCE_DEPRECATION)
    set(CL_SILENCE_DEPRECATION ON)
  endif()

  get_filename_component(CL_HPP_INCLUDE_GUARD_MACRO "${header_file_path}" NAME)
  string(REGEX REPLACE "[^0-9A-Za-z_]" "_" CL_HPP_INCLUDE_GUARD_MACRO "${CL_HPP_INCLUDE_GUARD_MACRO}")
  string(TOUPPER ${CL_HPP_INCLUDE_GUARD_MACRO} CL_HPP_INCLUDE_GUARD_MACRO)

  if(CL_HPP_HEADER_VERSION EQUAL 1)
    if(CL_HPP_ENABLE_EXCEPTIONS)
      set(__CL_ENABLE_EXCEPTIONS ON)
    endif()
    if(CL_HPP_MINIMUM_OPENCL_VERSION LESS_EQUAL 100)
      set(CL_USE_DEPRECATED_OPENCL_1_0_APIS ON)
    endif()
    if(CL_HPP_MINIMUM_OPENCL_VERSION LESS_EQUAL 110)
      set(CL_USE_DEPRECATED_OPENCL_1_1_APIS ON)
    endif()
    if(CL_HPP_MINIMUM_OPENCL_VERSION LESS_EQUAL 120)
      set(CL_USE_DEPRECATED_OPENCL_1_2_APIS ON)
    endif()
    if(CL_HPP_MINIMUM_OPENCL_VERSION LESS_EQUAL 200)
      set(CL_USE_DEPRECATED_OPENCL_2_0_APIS ON)
    endif()
    if(CL_HPP_MINIMUM_OPENCL_VERSION LESS_EQUAL 210)
      set(CL_USE_DEPRECATED_OPENCL_2_1_APIS ON)
    endif()
    if(CL_HPP_MINIMUM_OPENCL_VERSION LESS_EQUAL 220)
      set(CL_USE_DEPRECATED_OPENCL_2_2_APIS ON)
    endif()
    configure_file(
      ${CMAKE_SOURCE_DIR}/cmake/templates/clWrapper.hpp.in
      ${header_file_path}
      @ONLY)
  elseif(CL_HPP_HEADER_VERSION EQUAL 2)
    configure_file(
      ${CMAKE_SOURCE_DIR}/cmake/templates/cl2Wrapper.hpp.in
      ${header_file_path}
      @ONLY)
  else()
    message(FATAL_ERROR "Specified HEADER_VERSION is ${CL_HPP_HEADER_VERSION}, but it must be 1 or 2")
  endif()

  message(STATUS "Configure done. Output file: ${header_file_path}")
endfunction()
