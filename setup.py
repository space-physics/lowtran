#!/usr/bin/env python
import setuptools #enables develop

#%% Monkey patch necessary since setup_requires is not adequate
import pip
pip.main(['install','numpy'])
#%% install
from numpy.distutils.core import setup,Extension

req=['python-dateutil','pytz','nose','numpy','xarray','matplotlib','seaborn']

setup(name='lowtran',
      author='Michael Hirsch, Ph.D',
      install_requires=req,
      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
                    f2py_options=['--quiet'])]
	  )
