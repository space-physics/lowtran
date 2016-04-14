cmake_minimum_required(VERSION 2.8)
project( lowtran Fortran )

set(CMAKE_VERBOSE_MAKEFILE OFF) # see what the individual compiler commands are
# ------------ Build mode selections ---------------------------------
set(CMAKE_BUILD_TYPE Release) #invokes (some) compiler optimizations
#set(CMAKE_BUILD_TYPE Debug) # no optimizations, (some) debug flags on, injects debugging symbols
#-------- compiler versions -------------------
add_compile_options(-std=gnu -mtune=native -fexceptions -fstack-protector-all)

# https://gcc.gnu.org/onlinedocs/gcc-5.3.0/gcc/Debugging-Options.html
if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_compile_options(-fsanitize=address)
endif()
#--------------- targets ---------------------------------
add_executable(testlowtran reference/lowtran_driver.f)
#------------------- HLE program ---------------------------------
target_sources(testlowtran
PRIVATE 
lowtran7.f
)
