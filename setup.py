#!/usr/bin/env python3
import setuptools #enables develop
import subprocess
from numpy.distutils.core import setup,Extension


with open('README.rst','r') as f:
	long_description = f.read()
	
try:
    subprocess.run(['conda','install','--yes','--quiet','--file','requirements.txt'])
except Exception as e:
    print('you will need to install packages in requirements.txt  {}'.format(e))
    with open('requirements.txt','r') as f:
        print(f.read())

#%% install
setup(name='lowtran',
      version='0.1',
	  description='Python wrapper for LOWTRAN7 atmosphere transmission model',
	  long_description=long_description,
	  author='Michael Hirsch',
	  url='https://github.com/scienceopen/lowtran',
      packages=['lowtran'],
      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
                    f2py_options=['--quiet'])]
	  )
	 
