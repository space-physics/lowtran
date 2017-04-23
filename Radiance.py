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
#
import lowtran
from lowtran.plots import plotradiance

def radiance(outfn, obsalt, zenang, wlnm, c1:dict):
#%% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    TR = lowtran.golowtran(obsalt, zenang, wlnm, c1)
#%% write to HDF5
    if p.outfn:
        outfn = Path(p.outfn).expanduser()
        print('writing',outfn)
        TR.to_pandas().to_hdf(str(outfn), TR.name)

    return TR

if __name__=='__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.05)
    p.add_argument('-a','--zenang',help='zenith angle [deg]  can be single value or list of values',type=float,default=0.)
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,30000))
    p.add_argument('-o','--outfn',help='HDF5 file to write')
    p.add_argument('--model',help='0-6, see Card1 "model" reference. 5=subarctic winter',type=int,default=5)

    p=p.parse_args()

    #%% low-level Lowtran configuration for this scenario, don't change
    c1={'model':p.model,
        'itype':  3,  # 3: observer to space
        'iemsct': 2,  # 1: thermal radiance model  2: radiance model
        'range_km':  p.obsalt,
        'zmdl':      p.obsalt,
        }

    TR = radiance(p.outfn, p.obsalt, p.zenang, p.wavelen, c1)

    plotradiance(TR, True, c1)

    show()
