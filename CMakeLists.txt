cmake_minimum_required(VERSION 3.7)
project(lowtran Fortran)

add_compile_options(-ffpe-trap=invalid,zero,overflow -g -fbacktrace)
# -fdefault-real-8 -fno-align-commons)

add_executable(testlowtran reference/lowtran_driver.f90 lowtran7.f)

enable_testing()

add_test(NAME Fortran COMMAND testlowtran)

find_package(PythonInterp)
if(PYTHON_VERSION_MAJOR GREATER_EQUAL 3)
  if(DEFINED ENV{APPVEYOR})
    message(INFO TODO:check plain Fortran output)
  else()
    add_test(NAME Python COMMAND pytest -v
         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  endif()
endif()
