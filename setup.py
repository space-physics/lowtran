#!/usr/bin/env python3
import sys
#from setuptools import setup
from numpy.distutils.core import setup,Extension


with open('README.rst') as f:
	long_description = f.read()

#%% install
setup(name='lowtran',
      version='0.1',
	  description='Python wrapper for LOWTRAN7 atmosphere transmission model',
	  long_description=long_description,
	  author='Michael Hirsch',
	  author_email='hirsch617@gmail.com',
	  url='https://github.com/scienceopen/lowtran',
	  install_requires=['numpy','six','pytz','pandas'],
      packages=['lowtran'],
      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
                    f2py_options=['quiet'])]
	  )
  	  