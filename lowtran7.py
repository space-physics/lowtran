#!/usr/bin/env python3
"""
Michael Hirsch
GPLv3+
Python wrapper of the venerable LOWTRAN7 atmospheric absorption and solar transmission
model circa 1994.
"""
from __future__ import division,print_function,absolute_import
from matplotlib.pyplot import figure,show
from numpy import asarray,float32

import lowtran7 as lt7

def golowtran(obsalt,zenang,wlnm):
    wlcminvstep = 500
    wlnm= asarray(wlnm).astype(float32)
    wlcminv = 1e7/wlnm
    nwl = int((wlcminv[0]-wlcminv[1])/wlcminvstep)+1



    #TX,V,ALAM,TRACE,UNIF,SUMA = lt7.lwtrn7(True,nwl)
    TX,V,ALAM = lt7.lwtrn7(True,nwl,wlcminv[1],wlcminv[0],wlcminvstep,
                           5,3,0,
                           float32(obsalt),float32(0.),float32(zenang))[:3]
    return TX[:,9],ALAM
if __name__=='__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.)
    p.add_argument('-a','--zenang',help='zenith angle [deg]',type=float,default=0.)
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(300,1200))
    p=p.parse_args()

    trans,wlnm = golowtran(p.obsalt,p.zenang,p.wavelen)

    print(trans)

    ax = figure().gca()
    ax.plot(wlnm*1e3,trans)
    ax.set_xlabel('wavelength [nm]')
    show()