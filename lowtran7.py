#!/usr/bin/env python3
"""
Michael Hirsch
GPLv3+
Python wrapper of the venerable LOWTRAN7 atmospheric absorption and solar transmission
model circa 1994.
"""
from __future__ import division,print_function,absolute_import
from matplotlib.pyplot import figure,show

import lowtran

def golowtran(obsalt,zenang):

    lowtran.card3.h1 = obsalt
    lowtran.card3.angle=zenang

if __name__=='__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0)
    p.add_argument('-a','--zenang',help='zenith angle [deg]',type=float,default=0)
    p=p.parse_args()

    golowtran(p.obsalt,p.zenang)