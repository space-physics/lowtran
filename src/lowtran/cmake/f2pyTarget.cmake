include(${CMAKE_CURRENT_LIST_DIR}/f2py.cmake)


function(f2py_target module_name module_src out_dir)

set(f2py_bin "${CMAKE_CURRENT_BINARY_DIR}/${module_name}${f2py_suffix}")

# Workaround for f2py/meson not handling spaces in paths correctly:
# Create a copy/symlink in build directory and use relative path when source path contains spaces
string(FIND "${module_src}" " " _has_space)
if(_has_space GREATER -1)
  get_filename_component(_src_name "${module_src}" NAME)
  set(_src_link "${CMAKE_CURRENT_BINARY_DIR}/${_src_name}")
  # On Windows, symlinks require admin privileges, so use copy instead
  # On Unix, symlink is preferred to avoid duplication
  if(WIN32)
    configure_file("${module_src}" "${_src_link}" COPYONLY)
  else()
    file(CREATE_LINK "${module_src}" "${_src_link}" COPY_ON_ERROR SYMBOLIC)
  endif()
  set(_f2py_src "${_src_name}")
else()
  set(_f2py_src "${module_src}")
endif()

set(f2py_arg -m ${module_name} -c ${_f2py_src} --backend meson)
if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  if(WIN32)
    list(APPEND f2py_arg --fcompiler=intelvem)
  else()
    list(APPEND f2py_arg --fcompiler=intelem)
  endif()
endif()

add_custom_command(
OUTPUT "${f2py_bin}"
COMMAND "${f2py}" ${f2py_arg}
WORKING_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}"
VERBATIM
DEPENDS "${module_src}"
)

add_custom_target(${module_name} ALL DEPENDS "${f2py_bin}")

# Install the built Python extension into the wheel/lib directory during
# `cmake --install`, letting the build backend collect it. This avoids copying
# artifacts into the source tree.
if(DEFINED SKBUILD_PLATLIB_DIR)
  set(_dest "${SKBUILD_PLATLIB_DIR}/lowtran")
else()
  # Fallback: install under Python site-packages/lib directory name
  include(GNUInstallDirs)
  set(_dest "${CMAKE_INSTALL_LIBDIR}/lowtran")
endif()

install(FILES "${f2py_bin}" DESTINATION "${_dest}")

endfunction(f2py_target)
