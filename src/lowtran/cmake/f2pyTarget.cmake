include(${CMAKE_CURRENT_LIST_DIR}/f2py.cmake)

function(f2py_target module_name module_src out_dir)

set(out ${CMAKE_CURRENT_BINARY_DIR}/${module_name}${f2py_suffix})

add_custom_command(
  OUTPUT ${out}
  COMMAND ${f2py} --quiet -m ${module_name} -c ${module_src}
  )

add_custom_target(${module_name} ALL DEPENDS ${out})

add_custom_command(
  TARGET ${module_name} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy ${out} ${out_dir}/
  )

endfunction(f2py_target)
