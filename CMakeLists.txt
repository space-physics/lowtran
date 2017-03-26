cmake_minimum_required(VERSION 2.8.12)
project(lowtran Fortran)

add_compile_options(-ffpe-trap=invalid,zero,overflow -g -fbacktrace)

add_executable(testlowtran reference/lowtran_driver.f lowtran7.f)
