cmake_minimum_required(VERSION 3.7)
project(lowtran Fortran)
enable_testing()

add_compile_options(-mtune=native -g -O3)

if(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  add_compile_options(-ffpe-trap=invalid,zero,overflow -fbacktrace)
  # -fdefault-real-8 -fno-align-commons)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang)
  add_compile_options(-Mallocatable=03)
  link_libraries(-static-flang-libs)
endif()

add_executable(testlowtran reference/lowtran_driver.f90 lowtran7.f assert.f90)

# ----- tests
add_test(NAME FortranObs2space COMMAND testlowtran obs2space)
add_test(NAME FortranSolarRadiance COMMAND testlowtran solarrad)


find_package(PythonInterp)
if(PYTHON_VERSION_MAJOR GREATER_EQUAL 3)
  if(DEFINED ENV{APPVEYOR})
    message(INFO TODO:check plain Fortran output)
  else()
    add_test(NAME Python COMMAND pytest -v
         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  endif()
endif()



