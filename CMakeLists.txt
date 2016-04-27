cmake_minimum_required(VERSION 2.8.12)
project( lowtran Fortran )

add_compile_options(-mtune=native -ffast-math -Warray-bounds -fexceptions -fstack-protector-all)

add_executable(testlowtran reference/lowtran_driver.f)
target_sources(testlowtran PRIVATE lowtran7.f)
