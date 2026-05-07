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

from .base import check, golowtran, nm2lt7, LowtranResult
from .scenarios import (
    scatter,
    irradiance,
    radiance,
    transmittance,
    horizrad,
    horiztrans,
    userhoriztrans,
)

__all__ = [
    "check",
    "golowtran",
    "nm2lt7",
    "LowtranResult",
    "scatter",
    "irradiance",
    "radiance",
    "transmittance",
    "horizrad",
    "horiztrans",
    "userhoriztrans",
]
