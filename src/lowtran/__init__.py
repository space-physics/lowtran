"""
Python wrapper of the venerable LOWTRAN7 atmospheric absorption and solar transmission
model circa 1992.

Note: specified Lowtran7 model limitations include
wlcminvstep >= 20 cm^-1
0 <= wlcminv <= 50000

historical note:
developed on CDC CYBER, currently runs on 32-bit single float--this can cause loss of numerical
precision, future would like to ensure full LOWTRAN7 code can run at 64-bit double float.

user manual:
www.dtic.mil/dtic/tr/fulltext/u2/a206773.pdf
"""

from pathlib import Path
import os
import logging
import sys

if os.name == 'nt':
    dll_path = (Path(__file__) / "../build/lowtran7/.libs").resolve()
    # https://github.com/space-physics/lowtran/issues/19
    # code inspired by scipy._distributor_init.py for loading DLLs on Windows
    if dll_path.is_dir():
        # add the folder for Python 3.8 and above
        logging.info(f"Adding {dll_path} to DLL search path")
        os.add_dll_directory(dll_path)  # type: ignore
    else:
        logging.info(f"Could not find {dll_path} to add to DLL search path")

from .base import nm2lt7, golowtran
from .scenarios import (
    scatter,
    irradiance,
    radiance,
    transmittance,
    horizrad,
    horiztrans,
    userhoriztrans,
)
