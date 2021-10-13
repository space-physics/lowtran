cmake_minimum_required(VERSION 3.17...3.22)

project(lowtran
  LANGUAGES Fortran
  VERSION 2.5.1)

include(CTest)

include(cmake/compilers.cmake)

add_library(lowtran_lib OBJECT src/lowtran7.f)
target_compile_options(lowtran_lib PRIVATE ${old_flags})

add_executable(testlowtran src/lowtran_driver.f90 src/assert.f90)
target_link_libraries(testlowtran lowtran_lib)

add_test(NAME Obs2space COMMAND $<TARGET_FILE:testlowtran> obs2space 8333 33333 ${CMAKE_CURRENT_SOURCE_DIR}/src/lowtran/tests/testfort_trans.asc)
set_tests_properties(Obs2space PROPERTIES REQUIRED_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/lowtran/tests/testfort_trans.asc)

add_test(NAME SolarRadiance COMMAND $<TARGET_FILE:testlowtran> solarrad 749.5 1250 ${CMAKE_CURRENT_SOURCE_DIR}/src/lowtran/tests/testfort_solarrad.asc)
set_tests_properties(SolarRadiance PROPERTIES REQUIRED_FILES ${CMAKE_CURRENT_SOURCE_DIR}/src/lowtran/tests/testfort_solarrad.asc)

add_test(NAME SolarIrradiance COMMAND $<TARGET_FILE:testlowtran> solarirrad 749.5 1250 "")
add_test(NAME UserHoriz COMMAND $<TARGET_FILE:testlowtran> userhoriz 714.2857 1250 "")

include(cmake/f2py.cmake)
