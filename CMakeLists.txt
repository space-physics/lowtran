cmake_minimum_required(VERSION 2.8.12)
project(lowtran Fortran)

add_compile_options(-ffpe-trap=invalid,zero,overflow -g -fbacktrace)
# -fdefault-real-8 -fno-align-commons)


add_executable(testlowtran reference/lowtran_driver.f lowtran7.f)
