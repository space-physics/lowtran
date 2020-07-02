# f2py
if(CMAKE_VERSION VERSION_LESS 3.17)
  message(WARNING "CMake >= 3.17 required for f2py")
  return()
endif()

find_package(Python3 COMPONENTS Interpreter NumPy)
if(NOT Python3_FOUND)
  return()
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU AND
  CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10 AND
  Python3_NumPy_VERSION VERSION_LESS 1.19)
  message(WARNING "Numpy >= 1.19 required for GCC >= 10")
  return()
endif()

find_program(_f2py NAMES f2py)
if(NOT _f2py)
  return()
endif()

if(WIN32)
  set(_f2py_suffix .pyd)
else()
  set(_f2py_suffix ${CMAKE_SHARED_LIBRARY_SUFFIX})
endif()

set(_f2py_modname lowtran7)
set(_f2py_outfile ${CMAKE_CURRENT_BINARY_DIR}/${_f2py_modname}.${Python3_SOABI}${_f2py_suffix})
set(_f2py_src ${CMAKE_CURRENT_SOURCE_DIR}/src/lowtran7.f)


add_custom_command(
  OUTPUT ${_f2py_outfile}
  COMMAND ${_f2py} --quiet -m ${_f2py_modname} -c ${_f2py_src}
  COMMENT "f2py building Python module ${_f2py_modname}")

add_custom_target(${_f2py_modname} ALL DEPENDS ${_f2py_outfile})

add_custom_command(
  TARGET ${_f2py_modname} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy
    ${_f2py_outfile}
    ${CMAKE_CURRENT_SOURCE_DIR}/)
