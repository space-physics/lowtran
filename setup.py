#!/usr/bin/env python3

from setuptools import setup
from numpy.distutils.core import Extension

with open('README.rst') as f:
	long_description = f.read()
    
#%% compile f2py fortran module    
from subprocess import Popen,PIPE
sysCall = ['f2py', '--quiet', '-m', 'lowtran7', '-c', 'lowtran7.f']
procout = Popen(sysCall,stdout=PIPE, shell=False)
sout,serr = procout.communicate() #timeout is incompatible with Python 2.7
print(sout.decode('utf8')) # works for python 2 and 3
#note: serr always seems to be None even if real error

#%% install
setup(name='lowtran',
      version='0.1',
	  description='Python wrapper for LOWTRAN7 atmosphere transmission model',
	  long_description=long_description,
	  author='Michael Hirsch',
	  author_email='hirsch617@gmail.com',
	  url='https://github.com/scienceopen/lowtran',
	  install_requires=['numpy','six','nose','pytz','pandas'],
      packages=['lowtran'],
#      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
#                    f2py_options=['quiet'])]
	  )
  	  