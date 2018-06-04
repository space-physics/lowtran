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

if __name__ == '__main__':

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z', '--obsalt', help='altitude of observer [km]', type=float, default=0.)
    p.add_argument('-a', '--zenang', help='zenith angle [deg]  of sun or moon', nargs='+', type=float, default=[0, 60, 80])
    p.add_argument('-w', '--wavelen', help='wavelength range nm (start,stop)', type=float, nargs=2, default=(200, 25000))
    p.add_argument('--model', help='0-6, see Card1 "model" reference. 5=subarctic winter', type=int, default=5)
    P = p.parse_args()

    c1 = {'model': P.model,
          'h1': P.obsalt,
          'angle': P.zenang,  # zenith angle of sun or moon
          'wlnmlim': P.wavelen,
          }

    irr = lowtran.irradiance(c1)

    plotirrad(irr, c1, True)

    show()
