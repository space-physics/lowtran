if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
# mtune instead of march for better CPU compatibility
  add_compile_options(-mtune=native)
  set(old_flags -std=legacy -w)
elseif(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
  add_compile_options($<IF:$<BOOL:${WIN32}>,/QxHost,-xHost>)
  set(old_flags -w)
endif()
