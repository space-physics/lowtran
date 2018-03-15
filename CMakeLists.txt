cmake_minimum_required(VERSION 3.7)
project(lowtran Fortran)

add_compile_options(-ffpe-trap=invalid,zero,overflow -g -fbacktrace)
# -fdefault-real-8 -fno-align-commons)

add_executable(testlowtran reference/lowtran_driver.f90 lowtran7.f)


