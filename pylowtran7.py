#!/usr/bin/env python3
"""
Michael Hirsch
GPLv3+
Python wrapper of the venerable LOWTRAN7 atmospheric absorption and solar transmission
model circa 1994.
For now, assumes arctic environment

Note: specified Lowtran7 model limitations include
wlcminvstep >= 20 cm^-1
0 <= wlcminv <= 50000

historical note:
developed on CDC CYBER, currently runs on 32-bit single float--this can cause loss of numerical
precision, future would like to ensure full LOWTRAN7 code can run at 64-bit double float.

user manual:
www.dtic.mil/dtic/tr/fulltext/u2/a206773.pdf

Right now a lot of features are not implemented, please submit a request for more!
"""
from __future__ import division,print_function,absolute_import
try:
    from matplotlib.pyplot import figure,show
except ImportError as e:
    print('lowtran: matplotlib not available. Plots disabled.  {}'.format(e))
from pandas import DataFrame
from numpy import asarray,arange,atleast_1d,ceil,isfinite
from os import mkdir
from warnings import warn

import lowtran7 as lt7

def golowtran(obsalt_km,zenang_deg,wlnm):
    obsalt_km = atleast_1d(obsalt_km)
    if obsalt_km.size>1:
        obsalt_km = obsalt_km[0]
        warn('** LOWTRAN7: for now I only handle single altitudes. Using first value of {} [km]'.format(obsalt_km))

    zenang_deg=atleast_1d(zenang_deg)

    if not (isfinite(obsalt_km).all() and isfinite(zenang_deg).all() and isfinite(wlnm).all()):
        warn('** LOWTRAN7: NaN or Inf detected in input, exiting...')
        return None
    wlcminv,wlcminvstep,nwl =nm2lt7(wlnm)
    if wlcminvstep<5:
        warn('** LOWTRAN7: minimum resolution 5 cm^-1, specified resolution 20 cm^-1')
    if not ((0<=wlcminv) & (wlcminv<=50000)).all():
        warn('** LOWTRAN7: specified model range 0 <= wlcminv <= 50000')
    #TX,V,ALAM,TRACE,UNIF,SUMA = lt7.lwtrn7(True,nwl)
    T = []
    for za in zenang_deg:
        TX,V,ALAM = lt7.lwtrn7(True,nwl,wlcminv[1],wlcminv[0],wlcminvstep,
                           5,3,0,
                          obsalt_km,0,za)[:3]
        T.append(TX[:,9])
    T = asarray(T).T

    Tdf = DataFrame(data=T,columns=zenang_deg,index=ALAM*1e3)

    return Tdf

def nm2lt7(wlnm):
    """converts wavelength in nm to cm^-1"""
    wlcminvstep = 20
    wlnm= asarray(wlnm,dtype=float) #for proper division
    wlcminv = 1.e7/wlnm
    nwl = int(ceil((wlcminv[0]-wlcminv[1])/wlcminvstep))+1 #yes, ceil
    return wlcminv,wlcminvstep,nwl

def plottrans(trans,log):
    try:
        ax = figure().gca()
        for za,t in zip(zenang,trans):
            ax.plot(trans.index,trans[t],label=str(za))
        ax.set_xlabel('wavelength [nm]')
        ax.set_ylabel('transmission (unitless)')
        ax.set_title('zenith angle [deg] = '+str(zenang),fontsize=16)
        ax.legend(loc='best')
        ax.grid(True)
        if log:
            ax.set_yscale('log')
            ax.set_ylim(1e-6,1)
        ax.invert_xaxis()
        ax.set_xlim(left=trans.index[0])
    except Exception as e:
        print('trouble plotting   {}'.format(e))
        
if __name__=='__main__':
    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.)
    p.add_argument('-a','--zenang',help='zenith angle [deg] (start,stop,step)',type=float,nargs='+',default=(0,75+12.5,12.5))
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,2500))
    p=p.parse_args()


    try:
        mkdir('out')
    except OSError:
        pass
    zenang = arange(p.zenang[0],p.zenang[1],p.zenang[2])

    trans = golowtran(p.obsalt,zenang,p.wavelen)

    try:
        plottrans(trans,False)
        plottrans(trans,True)
        show()
    except ImportError as e:
        print('could not plot results. {}'.format(e))