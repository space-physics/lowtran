#!/usr/bin/env python
import setuptools  # noqa: F401
from numpy.distutils.core import setup, Extension


ext = [Extension(name='lowtran7',
                 sources=['src/lowtran7.f'],
                 f2py_options=['--quiet'],
                 extra_f77_compile_args=['-w'])]

setup(ext_modules=ext)
