
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  list(APPEND CMAKE_Fortran_FLAGS -mtune=native)
  set(old_flags -std=legacy)
endif()
