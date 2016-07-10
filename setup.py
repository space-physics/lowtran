#!/usr/bin/env python
import os,sys
import setuptools #enables develop
import subprocess

try:
    subprocess.call(['conda','install','--yes','--file','requirements.txt'])
except Exception as e:
    pass

#%% install
from numpy.distutils.core import setup,Extension

setup(name='lowtran',
	  description='Python wrapper for LOWTRAN7 atmosphere transmission model',
	  author='Michael Hirsch',
	  url='https://github.com/scienceopen/lowtran',
      install_requires=['pathlib2'],
      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
                    f2py_options=['--quiet'])]
	  )
