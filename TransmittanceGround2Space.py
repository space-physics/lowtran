#!/usr/bin/env python
from matplotlib.pyplot import show
#
import lowtran
from lowtran.plots import plottrans

if __name__ == '__main__':

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z', '--obsalt', help='altitude of observer [km]', type=float, default=0.)
    p.add_argument('-a', '--zenang', help='observer zenith angle [deg]', type=float, nargs='+', default=[0, 60, 80])
    p.add_argument('-w', '--wavelen', help='wavelength range nm (start,stop)', type=float, nargs=2, default=(200, 30000))
    p.add_argument('--model', help='0-6, see Card1 "model" reference. 5=subarctic winter', type=int, default=5)
    P = p.parse_args()

    c1 = {'model': P.model,
          'h1': P.obsalt,
          'angle': P.zenang,
          'wlnmlim': P.wavelen,
          }

    TR = lowtran.transmittance(c1)

    plottrans(TR, c1)

    show()
