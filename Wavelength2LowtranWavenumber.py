#!/usr/bin/env python
"""
convert wavelength (nm) to wavenumber (cm^-1) with step size for input to Lowtran
"""
from lowtran import nm2lt7
#
from argparse import ArgumentParser
p = ArgumentParser()
p.add_argument('wlnm', help='wavelength [nm]', nargs='+', type=float)
P = p.parse_args()

print(nm2lt7(P.wlnm)[0])
