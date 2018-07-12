#!/usr/bin/env python
import setuptools  # noqa: F401
from numpy.distutils.core import setup, Extension

ext = [Extension(name='lowtran7',
                 sources=['lowtran7.f'],
                 f2py_options=['--quiet'])]

setup(ext_modules=ext)
