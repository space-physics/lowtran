if(CMAKE_BUILD_TYPE STREQUAL Debug)
  add_compile_options(-g -O0)
else()
  add_compile_options(-O3)
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  list(APPEND FFLAGS -mtune=native)
  if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND FFLAGS -ffpe-trap=invalid,zero,overflow)
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Flang)
  list(APPEND FFLAGS -Mallocatable=03)
  list(APPEND FLIBS -static-flang-libs)
endif()

# ---

include(CheckFortranSourceCompiles)

check_fortran_source_compiles("program es; error stop; end" f2008
                              SRC_EXT f90)

