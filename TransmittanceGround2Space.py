#!/usr/bin/env python
from matplotlib.pyplot import show
from argparse import ArgumentParser
import lowtran
from lowtran.plots import plottrans


def main():
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z', '--obsalt', help='altitude of observer [km]', type=float, default=0.)
    p.add_argument('-a', '--zenang', help='observer zenith angle [deg]', type=float, nargs='+', default=[0, 60, 80])
    p.add_argument('-s', '--short', help='shortest wavelength nm ', type=float, default=200)
    p.add_argument('-l', '--long', help='longest wavelength cm^-1 ', type=float, default=30000)
    p.add_argument('-step', help='wavelength step size cm^-1', type=float, default=20)
    p.add_argument('--model', help='0-6, see Card1 "model" reference. 5=subarctic winter', type=int, default=5)
    P = p.parse_args()

    c1 = {'model': P.model,
          'h1': P.obsalt,
          'angle': P.zenang,
          'wlshort': P.short,
          'wllong': P.long,
          'wlstep': P.step,
          }

    TR = lowtran.transmittance(c1)

    plottrans(TR, c1)

    show()


if __name__ == '__main__':
    main()
