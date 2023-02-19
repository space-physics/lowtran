cmake_minimum_required(VERSION 3.19...3.26)
# 3.17+ for Python_SOABI

project(lowtran LANGUAGES Fortran)

enable_testing()

include(cmake/options.cmake)
include(cmake/compilers.cmake)

add_library(lowtran fortran/lowtran7.f)

install(TARGETS lowtran)

include(cmake/f2pyTarget.cmake)

f2py_target(lowtran7 ${CMAKE_CURRENT_SOURCE_DIR}/fortran/lowtran7.f ${CMAKE_CURRENT_SOURCE_DIR})
