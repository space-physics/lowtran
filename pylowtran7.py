#!/usr/bin/env python3
"""
Michael Hirsch
GPLv3+
Python wrapper of the venerable LOWTRAN7 atmospheric absorption and solar transmission
model circa 1994.
"""
from __future__ import division,print_function,absolute_import
from matplotlib.pyplot import figure,show
from pandas import DataFrame
from numpy import asarray,arange,atleast_1d

import lowtran7 as lt7

def golowtran(obsalt,zenang,wlnm):
    zenang=atleast_1d(zenang)
    wlcminv,wlcminvstep,nwl =nm2lt7(wlnm)
    #TX,V,ALAM,TRACE,UNIF,SUMA = lt7.lwtrn7(True,nwl)
    T = []
    for za in zenang:
        TX,V,ALAM = lt7.lwtrn7(True,nwl,wlcminv[1],wlcminv[0],wlcminvstep,
                           5,3,0,
                          obsalt,0,za)[:3]
        T.append(TX[:,9])
    T = asarray(T).T

    Tdf = DataFrame(data=T,columns=zenang,index=ALAM*1e3)

    return Tdf

def nm2lt7(wlnm):
    """converts wavelength in nm to cm^-1"""
    wlcminvstep = 20
    wlnm= asarray(wlnm)
    wlcminv = 1e7/wlnm
    nwl = int((wlcminv[0]-wlcminv[1])/wlcminvstep)+1
    return wlcminv,wlcminvstep,nwl

def plottrans(trans,log):
    ax = figure().gca()
    for za,t in zip(zenang,trans):
        ax.plot(trans.index,trans[t],label=str(za))
    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('transmission (unitless)')
    ax.set_title('zenith angle [deg] = '+str(zenang))
    ax.legend(loc='best')
    ax.grid(True)
    if log:
        ax.set_yscale('log')
        ax.set_ylim(bottom=1e-5)
    ax.invert_xaxis()
    ax.set_xlim(left=trans.index[0])

if __name__=='__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.)
    p.add_argument('-a','--zenang',help='zenith angle [deg] (start,stop,step)',type=float,nargs='+',default=(0,25+12.5,12.5))
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,1500))
    p=p.parse_args()

    zenang = arange(p.zenang[0],p.zenang[1],p.zenang[2])

    trans = golowtran(p.obsalt,zenang,p.wavelen)

    plottrans(trans,False)
    plottrans(trans,True)


    show()