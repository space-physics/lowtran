cmake_minimum_required(VERSION 3.7)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(lowtran
  LANGUAGES Fortran)
enable_testing()

include(cmake/compilers.cmake)

add_executable(testlowtran src/lowtran_driver.f90 src/lowtran7.f src/assert.f90)

add_test(NAME FortranObs2space COMMAND testlowtran obs2space)
add_test(NAME FortranSolarRadiance COMMAND testlowtran solarrad)

