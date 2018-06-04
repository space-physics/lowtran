#!/usr/bin/env python
"""
Horizontal cases are for special use by advanced users.

lowtran manual p.36 specify height H1 and RANGE

Pressure [millibar]
temperature [Kelvin]
"""
from matplotlib.pyplot import show
#
import lowtran
from lowtran.plots import plothoriz

if __name__ == '__main__':

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z', '--obsalt', help='altitude of bother observers on horizontal path [km]', type=float, default=0.3)
    p.add_argument('-r', '--range_km', help='range between observers on horizontal path [km]', type=float, default=1.0)
    p.add_argument('-a', '--zenang', help='zenith angle [deg]  can be single value or list of values', type=float, default=0.)
    p.add_argument('-w', '--wavelen', help='wavelength range nm (start,stop)', type=float, nargs=2, default=(200, 30000))
    P = p.parse_args()

    c1 = {'zmdl': P.obsalt,
          'h1': P.obsalt,
          'range_km': P.range_km,
          'wlnmlim': P.wavelen,
          }

    atmos = {'p': 949., 't': 283.8, 'wmol': [93.96, 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]}

    c1.update(atmos)

    TR = lowtran.userhoriztrans(c1).squeeze()

    plothoriz(TR, c1)

    show()
