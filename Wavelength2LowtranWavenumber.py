#!/usr/bin/env python
"""
convert wavelength (nm) to wavenumber (cm^-1) with step size for input to Lowtran
"""
from lowtran import nm2lt7
from argparse import ArgumentParser


def main():
    p = ArgumentParser()
    p.add_argument('-s', '--short', help='shortest wavelength nm ', type=float, default=200)
    p.add_argument('-l', '--long', help='longest wavelength nm ', type=float, default=30000)
    p.add_argument('-step', help='wavelength step size cm^-1', type=float, default=20)
    P = p.parse_args()

    w = nm2lt7(P.short, P.long, P.step)
    print(f'{w[0]:.2f} cm^-1 to {w[1]:.2f} cm^-1, comprising {w[2]} wavelength steps')


if __name__ == '__main__':
    main()
