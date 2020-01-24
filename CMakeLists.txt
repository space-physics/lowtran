cmake_minimum_required(VERSION 3.12)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()
project(Lowtran7 LANGUAGES Fortran)
enable_testing()

include(cmake/compilers.cmake)

set(lowtran_src ${CMAKE_CURRENT_SOURCE_DIR}/src/lowtran7.f)

if(SKBUILD)
  add_subdirectory(lowtran)
  return()
endif()

add_library(lowtran7 ${lowtran_src})
target_compile_options(lowtran7 PRIVATE ${old_flags})

add_executable(testlowtran src/lowtran_driver.f90 src/assert.f90)
target_link_libraries(testlowtran lowtran7)

add_test(NAME FortranObs2space COMMAND $<TARGET_FILE:testlowtran> obs2space)
add_test(NAME FortranSolarRadiance COMMAND $<TARGET_FILE:testlowtran> solarrad)
