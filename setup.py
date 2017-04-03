#!/usr/bin/env python
import setuptools #enables develop
from numpy.distutils.core import setup,Extension

req=['python-dateutil','pytz','nose','numpy','xarray','matplotlib','seaborn']

setup(name='lowtran',
      packages=['lowtran'],
      author='Michael Hirsch, Ph.D',
      description='Model of Earth atmosphere absorption and transmission vs. wavelength and location on Earth.',
      version='2.0.0',
      url = 'https://github.com/scivision/lowtran',
      classifiers=[
      'Intended Audience :: Science/Research',
      'Development Status :: 3 - Alpha',
      'License :: OSI Approved :: MIT License',
      'Programming Language :: Python :: 3.6',
      ],
      install_requires=req,
      ext_modules=[Extension(name='lowtran7',sources=['lowtran7.f'],
                    f2py_options=['--quiet'])]
	  )
