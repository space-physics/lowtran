cmake_minimum_required(VERSION 3.7)
project(lowtran Fortran)
enable_testing()

if(CMAKE_BUILD_TYPE STREQUAL Debug)
  add_compile_options(-g -O0)
else()
  add_compile_options(-O3)
endif()

if(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  list(APPEND FFLAGS -mtune=native -ffpe-trap=invalid,zero,overflow -fbacktrace)
  # -fdefault-real-8 -fno-align-commons)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL PGI)
  list(APPEND FFLAGS -Mallocatable=03)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang)
  list(APPEND FFLAGS -Mallocatable=03)
  link_libraries(-static-flang-libs)
endif()


# --- assert lib
add_library(assert assert.f90)
target_compile_options(assert PRIVATE ${FFLAGS})

set(okcomp GNU Intel)
if(CMAKE_Fortran_COMPILER_ID IN_LIST okcomp)
 target_sources(assert PRIVATE error2008.f90)
else()  # non-Fortran 2008 compilers
  target_sources(assert PRIVATE error2003.f90)
endif()
# ---
add_executable(testlowtran reference/lowtran_driver.f90 lowtran7.f)
target_link_libraries(testlowtran PRIVATE assert)
target_compile_options(testlowtran PRIVATE ${FFLAGS})

# ----- tests
add_test(NAME FortranObs2space COMMAND testlowtran obs2space)
add_test(NAME FortranSolarRadiance COMMAND testlowtran solarrad)


find_package(PythonInterp)
if(PYTHON_VERSION_MAJOR GREATER_EQUAL 3)
  if(UNIX)
    add_test(NAME Python COMMAND pytest -v
         WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
  endif()
endif()



