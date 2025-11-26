# f2py

set(Python3_FIND_VIRTUALENV FIRST)
find_package(Python3 COMPONENTS Interpreter NumPy REQUIRED)
message(STATUS "${PYTHON3_EXECUTABLE}")
message(STATUS "${Python3_NumPy_VERSION}")

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
  CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10 AND
  Python3_NumPy_VERSION VERSION_LESS 1.19)
  message(FATAL_ERROR "Numpy >= 1.19 required for GCC >= 10")
endif()

find_program(f2py NAMES f2py REQUIRED)

if(f2py_suffix)
  return()
endif()

execute_process(
COMMAND ${Python3_EXECUTABLE} -c "import sysconfig; x=sysconfig.get_config_var('EXT_SUFFIX'); assert x is not None; print(x)"
OUTPUT_STRIP_TRAILING_WHITESPACE
RESULT_VARIABLE ret
OUTPUT_VARIABLE out
ERROR_VARIABLE err
)


if(NOT ret EQUAL 0)
  message(FATAL_ERROR "${ret}: ${out}: ${err}: could not determine f2py output file suffix")
endif()

set(f2py_suffix ${out} CACHE STRING "f2py file suffix")
