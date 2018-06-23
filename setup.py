#!/usr/bin/env python
from pathlib import Path
from setuptools import find_packages
from numpy.distutils.core import setup, Extension

install_requires = ['python-dateutil', 'numpy', 'xarray']
tests_require = ['pytest', 'coveralls', 'flake8', 'mypy']

ext = [Extension(name='lowtran7',
                 sources=['lowtran7.f'],
                 f2py_options=['--quiet'])]

scripts = [s.name for s in Path(__file__).parent.glob('*.py') if not s.name == 'setup.py']

setup(name='lowtran',
      packages=find_packages(),
      author='Michael Hirsch, Ph.D',
      description='Model of Earth atmosphere absorption and transmission vs. wavelength and location.',
      long_description=open('README.md').read(),
      long_description_content_type="text/markdown",
      version='2.3.3a',
      url='https://github.com/scivision/lowtran',
      classifiers=[
          'Development Status :: 4 - Beta',
          'Environment :: Console',
          'Intended Audience :: Science/Research',
          'License :: OSI Approved :: MIT License',
          'Operating System :: OS Independent',
          'Programming Language :: Fortran',
          'Programming Language :: Python :: 3.6',
          'Programming Language :: Python :: 3.7',
          'Topic :: Scientific/Engineering :: Atmospheric Science',
      ],
      ext_modules=ext,
      install_requires=install_requires,
      python_requires='>=3.6',
      extras_require={'plot': ['matplotlib', 'seaborn'],
                      'tests': tests_require},
      tests_require=tests_require,
      scripts=scripts,
      include_package_data=True,
      )
