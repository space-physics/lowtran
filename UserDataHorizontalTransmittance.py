#!/usr/bin/env python
"""
Horizontal cases are for special use by advanced users.

"""
from matplotlib.pyplot import show
#
import lowtran
from lowtran.plots import plothoriz

if __name__=='__main__':

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.05)
    p.add_argument('-a','--zenang',help='zenith angle [deg]  can be single value or list of values',type=float,default=0.)
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,30000))
    p=p.parse_args()

    c1={'model':0, # 0: user meterological data
        'itype':1, # 1: horizontal path
        'iemsct':0, # 0: transmittance model
        'im': 1, # 1: for horizontal path (see Lowtran manual p.42)
        'ird1': 1, # 1: use card 2C2
        'range_km':p.obsalt,
        'zmdl':p.obsalt,
        'h1': p.obsalt,
        'wlnmlim': p.wavelen,
        'p':949.,
        't':283.8,
        'wmol':[93.96,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.]
        }

    TR = lowtran.golowtran(c1)

    plothoriz(TR, c1, False)

    show()
