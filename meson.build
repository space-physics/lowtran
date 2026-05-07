project('lowtran',
        ['c', 'fortran'],
        version : '0.1',
        meson_version: '>= 1.1.0',
        default_options : [
                            'warning_level=1',
                            'buildtype=release',
                            #'fortran_args=-Wno-line-truncation -Wno-conversion -Wno-unused-variable -Wno-maybe-uninitialized -Wno-unused-dummy-argument -Wno-compare-reals',
                            'fortran_std=legacy',
                          ],
      )

py_mod = import('python')
py = py_mod.find_installation()
py_dep = py.dependency()
# Get the system-specific include directory

py_include_dir = run_command(py,
    ['-c', 'import sysconfig; print(sysconfig.get_path("include"))'],
    check : true
).stdout().strip()
message('Python include dir', py_include_dir)

py_install_dir = run_command(py,
    ['-c', 'import sysconfig; print(sysconfig.get_path("purelib"))'],
    check : true
).stdout().strip()

message('Meson will install app in', py_install_dir)

subdir('src/lowtran/fortran')

py.install_sources(
[
    'src/lowtran/__init__.py', 'src/lowtran/base.py', 'src/lowtran/plot.py', 'src/lowtran/scenarios.py',
  ],
  pure : false,
  subdir : 'lowtran',
#  install_dir: py_install_dir
)

# Install bundled DLLs for Windows (Fortran runtime dependencies)
# DLLs are copied during wheel build process (see .github/workflows/build-wheels.yml)
# For local development, DLLs are not required if mingw64 is in PATH
if host_machine.system() == 'windows'
  dll_files = [
    'src/lowtran/libs/libgfortran-5.dll',
    'src/lowtran/libs/libgcc_s_seh-1.dll',
    'src/lowtran/libs/libquadmath-0.dll',
    'src/lowtran/libs/libwinpthread-1.dll',
  ]

  # Only install DLLs if they exist (e.g., during wheel build)
  dll_list = []
  foreach dll : dll_files
    if import('fs').exists(dll)
      dll_list += [dll]
    endif
  endforeach

  if dll_list.length() > 0
    py.install_sources(
      dll_list,
      pure : false,
      subdir : 'lowtran/libs'
    )
  endif
endif
