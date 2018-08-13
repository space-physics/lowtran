#!/usr/bin/env python
"""
Horizontal cases are for special use by advanced users.
"""
from pathlib import Path
from matplotlib.pyplot import show
from argparse import ArgumentParser
import lowtran
from lowtran.plots import plotradtime


def main():
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument(
        'ptfn', help='csv file with time,relative humidity [%],ambient temperature [K], total pressure (millibar)', nargs='?')
    p.add_argument('-z', '--obsalt', help='altitude of observer [km]', type=float, default=0.05)
    p.add_argument('-s', '--short', help='shortest wavelength nm ', type=float, default=200)
    p.add_argument('-l', '--long', help='longest wavelength nm ', type=float, default=30000)
    p.add_argument('-step', help='wavelength step size cm^-1', type=float, default=20)
    p.add_argument('-o', '--outfn', help='HDF5 file to write')
    P = p.parse_args()

# %% low-level Lowtran configuration for this scenario, don't change
    c1 = {'range_km': P.obsalt,
          'zmdl': P.obsalt,
          'h1': P.obsalt,
          'wlshort': P.short,
          'wllong': P.long,
          'wlstep': P.step,
          }

    TR = lowtran.horizrad(P.ptfn, P.outfn, c1)

# %% write to HDF5
    if P.outfn:
        outfn = Path(P.outfn).expanduser()
        print('writing', outfn)
        TR.to_netcdf(outfn)

    plotradtime(TR, c1)

    show()


if __name__ == '__main__':
    main()
