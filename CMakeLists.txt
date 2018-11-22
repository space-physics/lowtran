cmake_minimum_required(VERSION 3.7)
project(lowtran Fortran)
enable_testing()

include(cmake/compilers.cmake)

add_executable(testlowtran src/lowtran_driver.f90 src/lowtran7.f src/assert.f90)
if(f2008)
 target_sources(testlowtran PRIVATE src/error2008.f90)
else()  
  target_sources(testlowtran PRIVATE src/error2003.f90)
endif()
target_link_libraries(testlowtran PRIVATE ${FLIBS})
target_compile_options(testlowtran PRIVATE ${FFLAGS})

add_test(NAME FortranObs2space COMMAND testlowtran obs2space)
add_test(NAME FortranSolarRadiance COMMAND testlowtran solarrad)

