cmake_minimum_required(VERSION 3.17...3.25)
# 3.17+ for Python_SOABI

project(lowtran
LANGUAGES Fortran
VERSION 3.0.0)

enable_testing()

include(cmake/options.cmake)
include(cmake/compilers.cmake)

add_library(lowtran fortran/lowtran7.f)
target_compile_options(lowtran PRIVATE ${old_flags})

install(TARGETS lowtran)

include(cmake/f2pyTarget.cmake)

if(NOT f2py)
  message(FATAL_ERROR "f2py is not found")
endif()

f2py_target(lowtran7 ${CMAKE_CURRENT_SOURCE_DIR}/fortran/lowtran7.f ${CMAKE_CURRENT_SOURCE_DIR})
