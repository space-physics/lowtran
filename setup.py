#!/usr/bin/env python
install_requires=['python-dateutil','numpy','xarray']
tests_require=['pytest','nose','coveralls']
# %%
from setuptools import find_packages
from numpy.distutils.core import setup,Extension

ext = [Extension(name='lowtran7',
                 sources=['lowtran7.f'],
                 f2py_options=['--quiet'])]

setup(name='lowtran',
      packages=find_packages(),
      author='Michael Hirsch, Ph.D',
      description='Model of Earth atmosphere absorption and transmission vs. wavelength and location on Earth.',
      long_description=open('README.rst').read(),
      version='2.3.2',
      url='https://github.com/scivision/lowtran',
      classifiers=[
      'Development Status :: 4 - Beta',
      'Environment :: Console',
      'Intended Audience :: Science/Research',
      'License :: OSI Approved :: MIT License',
      'Operating System :: OS Independent',
      'Programming Language :: Python :: 3',
      'Topic :: Scientific/Engineering :: Atmospheric Science',
      ],
      ext_modules=ext,
      install_requires=install_requires,
      python_requires='>=3.6',
      extras_require={'plot':['matplotlib','seaborn'],
                      'tests':tests_require},
      tests_require=tests_require,
      scripts=['ScatterRadiance.py','SolarIrradiance.py','ThermalRadiance.py',
               'TransmittanceGround2Space.py','UserDataHorizontalRadiance.py',
               'HorizontalTransmittance.py','Wavelength2LowtranWavenumber.py',
               'UserHorizontalTransmittance.py'
               ],
      include_package_data=True,
	  )
