
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-mtune=native)

  set(CMAKE_Fortran_FLAGS_DEBUG "-ffpe-trap=invalid,zero,overflow ")
endif()
