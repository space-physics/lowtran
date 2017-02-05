#!/usr/bin/env python
import setuptools #enables develop

try:
    import conda.cli
    conda.cli.main('install','--file','requirements.txt')
except Exception as e:
    print(e)
    import pip
    pip.main(['install','-r','requirements.txt'])

#%% install
from numpy.distutils.core import setup,Extension

setup(name='lowtran',
      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
                    f2py_options=['--quiet'])]
	  )
