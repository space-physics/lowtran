#!/usr/bin/env python
import setuptools  # noqa: F401
from numpy.distutils.core import setup, Extension
import os
from pathlib import Path


if os.name == 'nt':
    sfn = Path(__file__).parent / 'setup.cfg'
    stxt = sfn.read_text()
    if '[build_ext]' not in stxt:
        with sfn.open('a') as f:
            f.write("[build_ext]\ncompiler = mingw32")

ext = [Extension(name='lowtran7',
                 sources=['src/lowtran7.f'],
                 f2py_options=['--quiet'])]

setup(ext_modules=ext)
