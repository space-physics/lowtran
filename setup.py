#!/usr/bin/env python3
import os,sys
import setuptools #enables develop
import subprocess

exepath = os.path.dirname(sys.executable)
try:
    subprocess.call([os.path.join(exepath,'conda'),'install','--yes','--file','requirements.txt'])
except Exception as e:
    print('tried conda in {}, but you will need to install packages in requirements.txt  {}'.format(exepath,e))


with open('README.rst','r') as f:
	long_description = f.read()
	

#%% install
from numpy.distutils.core import setup,Extension

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
	 
