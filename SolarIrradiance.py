#!/usr/bin/env python
"""
For Irradiance, the zenith angle is locked to the zenith angle of the sun.
Implicitly, your sensor is looking at the sun and that's the only choice per
Lowtran manual p. 36 s3.2.3.1
"""
from matplotlib.pyplot import show
#
import lowtran
from lowtran.plots import plotirrad

if __name__=='__main__':

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]', type=float, default=0.)
    p.add_argument('-a','--zenang',help='zenith angle [deg]  can be single value or list of values',type=float,default=0.)
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,15000))
    p.add_argument('--model',help='0-6, see Card1 "model" reference. 5=subarctic winter',type=int,default=5)
    p=p.parse_args()

    c1={'model':p.model,
        'itype':3, # 3: observer to space
        'iemsct':3 # 3: solar irradiance
        }

    TR = lowtran.golowtran(p.obsalt, p.zenang, p.wavelen, c1)

    plotirrad(TR, True, c1)

    show()
