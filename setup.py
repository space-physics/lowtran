#!/usr/bin/env python
req=['python-dateutil','pytz','nose','numpy','xarray','matplotlib','seaborn']
# %%
try:
    import conda.cli
    conda.cli.main('install',*req)
except Exception as e:
    import pip
    pip.main(['install',*req])
# %%
import setuptools #enables develop
from numpy.distutils.core import setup,Extension

setup(name='lowtran',
      packages=['lowtran'],
      author='Michael Hirsch, Ph.D',
      description='Model of Earth atmosphere absorption and transmission vs. wavelength and location on Earth.',
      version='2.2.0',
      url = 'https://github.com/scivision/lowtran',
      classifiers=[
      'Intended Audience :: Science/Research',
      'Development Status :: 4 - Beta',
      'License :: OSI Approved :: MIT License',
      'Topic :: Scientific/Engineering :: Atmospheric Science',
      'Programming Language :: Python :: 3.6',
      ],
      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
                    f2py_options=['--quiet'])]
	  )
