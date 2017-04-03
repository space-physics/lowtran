#!/usr/bin/env python
"""
convert wavelength (nm) to wavenumber (cm^-1) with step size for input to Lowtran
"""

from lowtran import nm2lt7


wlnm = [8000,14000]

print(nm2lt7(wlnm))
