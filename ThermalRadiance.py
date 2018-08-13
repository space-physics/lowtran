#!/usr/bin/env python
"""

Total Radiance = atmosphere rad. or boundary rad. + atm. scat. or boundary refl.

Lowtran outputs W cm^-2 ster^-1 micron^-1
we want photons cm^-2 s^-1 ster^-1 micron^-1
1 W cm^-2 = 10000 W m^-2

h = 6.62607004e-34 m^2 kg s^-1
I: irradiance
Np: numer of photons
Np = (Ilowtran*10000)*lambda_m/(h*c)
"""
from pathlib import Path
from matplotlib.pyplot import show
from argparse import ArgumentParser
import lowtran
from lowtran.plots import plotradiance


def main():
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z', '--obsalt', help='altitude of observer [km]', type=float, default=0.)
    p.add_argument('-a', '--zenang', help='Observer zenith angle [deg] ', nargs='+', type=float, default=[0., 60, 80])
    p.add_argument('-s', '--short', help='shortest wavelength nm ', type=float, default=200)
    p.add_argument('-l', '--long', help='longest wavelength nm ', type=float, default=30000)
    p.add_argument('-step', help='wavelength step size cm^-1', type=float, default=20)
    p.add_argument('-o', '--outfn', help='HDF5 file to write')
    p.add_argument('--model', help='0-6, see Card1 "model" reference. 5=subarctic winter', type=int, default=5)

    P = p.parse_args()

    c1 = {'model': P.model,
          'h1': P.obsalt,  # of observer
          'angle': P.zenang,  # of observer
          'wlshort': P.short,
          'wllong': P.long,
          'wlstep': P.step,
          }

    TR = lowtran.radiance(c1)
# %%
    if P.outfn:
        outfn = Path(P.outfn).expanduser()
        print('writing', outfn)
        TR.to_netcdf(outfn)

    plotradiance(TR, c1, True)

    show()


if __name__ == '__main__':
    main()
