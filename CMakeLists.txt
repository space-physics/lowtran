cmake_minimum_required(VERSION 3.17...3.25)
# 3.17+ for Python_SOABI

project(lowtran LANGUAGES Fortran)

enable_testing()

option(BUILD_TESTING "Build testing tools" ON)
option(matlab "build matlab interface")

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

add_subdirectory(src/lowtran)


if(BUILD_TESTING)

add_executable(lowtran_cli test/lowtran_driver.f90 test/assert.f90)
target_link_libraries(lowtran_cli PRIVATE lowtran)

add_test(NAME Obs2space COMMAND lowtran_cli obs2space 8333 33333 ${CMAKE_CURRENT_SOURCE_DIR}/test/testfort_trans.asc)
set_property(TEST Obs2space PROPERTY REQUIRED_FILES ${CMAKE_CURRENT_SOURCE_DIR}/test/testfort_trans.asc)

add_test(NAME SolarRadiance COMMAND lowtran_cli solarrad 749.5 1250 ${CMAKE_CURRENT_SOURCE_DIR}/test/testfort_solarrad.asc)
set_property(TEST SolarRadiance PROPERTY REQUIRED_FILES ${CMAKE_CURRENT_SOURCE_DIR}/test/testfort_solarrad.asc)

add_test(NAME SolarIrradiance COMMAND lowtran_cli solarirrad 749.5 1250 "")
add_test(NAME UserHoriz COMMAND lowtran_cli userhoriz 714.2857 1250 "")

endif(BUILD_TESTING)


if(matlab)

find_package(Matlab COMPONENTS MAIN_PROGRAM REQUIRED)

add_test(NAME MatlabNumpy COMMAND matlab -batch "py.numpy.arange(1);")
set_property(TEST MatlabNumpy PROPERTY FIXTURES_SETUP MatlabNumpy)

add_test(NAME MatlabLowtran
COMMAND ${Matlab_MAIN_PROGRAM} -batch "r = runtests('lowtran'); assertSuccess(r)"
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
set_property(TEST MatlabLowtran PROPERTY FIXTURES_REQUIRED MatlabNumpy)

set(property TEST MatlabNumpy MatlabLowtran PROPERTY TIMEOUT 90)

endif()
