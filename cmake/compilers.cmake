
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  list(APPEND FFLAGS -mtune=native)
  if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND FFLAGS -ffpe-trap=invalid,zero,overflow)
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Flang)

endif()
