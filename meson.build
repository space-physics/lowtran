project('lowtran', 'fortran',
  default_options : ['default_library=static', 'buildtype='release'])

lowtran_exe = executable('testlowtran', 'src/lowtran_driver.f90', 'src/lowtran7.f', 'src/assert.f90')

test('Obs2space', lowtran_exe, args: 'obs2space')
test('SolarRadiance', lowtran_exe, args: 'solarrad')
