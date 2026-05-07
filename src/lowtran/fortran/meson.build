fc = meson.get_compiler('fortran')

incdir_numpy = run_command(py,
  ['-c', 'import numpy; print(numpy.get_include());'],
  check : true
).stdout().strip()
message('incdir_numpy', incdir_numpy)

incdir_f2py = run_command(py,
    ['-c', 'import numpy.f2py; print(numpy.f2py.get_include())'],
    check : true
).stdout().strip()
message('incdir_f2py', incdir_f2py)

lowtran7_source = custom_target('lowtran7module.c',
                                input: ['lowtran7.f'],
                                output: ['lowtran7module.c', 'lowtran7-f2pywrappers.f'],
                                command: [py, '-m', 'numpy.f2py', '@INPUT@', '-m', 'lowtran7', '--lower', '--build-dir', '@BUILD_ROOT@/src/lowtran/fortran']
                               )

#inc_np = include_directories(incdir_numpy, incdir_f2py,)
#np_dep = declare_dependency(include_directories: inc_np)

#incdir_f2py = incdir_numpy / '..' / '..' / 'f2py' / 'src'
#inc_f2py = include_directories(incdir_f2py)
fortranobject_c = incdir_f2py / 'fortranobject.c'

inc_np = include_directories(incdir_numpy, incdir_f2py)
quadmath_dep = fc.find_library('quadmath', required: false)
#mkl_dep = fc.find_library('mkl_core', required: false)

py.extension_module('lowtran7',
                     sources: ['lowtran7.f', lowtran7_source, fortranobject_c],
                     include_directories: [ inc_np, py_include_dir],
                     dependencies : [py_dep, quadmath_dep,],
                     install : true,
#                     install_dir : py_install_dir
                     subdir: 'lowtran'
                    )
