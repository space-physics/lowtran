# f2py

find_package(Python COMPONENTS Interpreter NumPy)
if(NOT Python_FOUND)
  return()
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
  CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10 AND
  Python_NumPy_VERSION VERSION_LESS 1.19)
  message(WARNING "Numpy >= 1.19 required for GCC >= 10")
  return()
endif()

find_program(f2py NAMES f2py)
if(NOT f2py)
  message(STATUS "f2py not found")
  return()
endif()
