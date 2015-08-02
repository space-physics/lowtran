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

--------
Card 1:
     MODEL=0 IF METEOROLOGICAL DATA ARE SPECIFIED(HORIZONTAL PATH ONLY)
           1 TROPICAL ATMOSPHERE
           2 MIDLATITUDE SUMMER
           3 MIDLATITUDE WINTER
           4 SUBARCTIC   SUMMER
           5 SUBARCTIC   WINTER
           6 1976 U.S. STANDARD ATMOSPHERE

     ITYPE=1 FOR A HORIZONTAL (CONSTANT-PRESSURE) PATH
           2 VERTICAL OR SLANT PATH BETWEEN TWO ALTITUDES
           3 FOR A VERTICAL OR SLANT PATH TO SPACE

     IEMSCT=0    PROGRAM EXECUTION IN TRANSMITTANCE MODE.
            1    PROGRAM EXECUTION IN RADIANCE MODE.
            2    PROGRAM EXECUTION IN RADIANCE MODE WITH SOLAR/LUNAR SCATTERED RADIANCE INCLUDED.
            3    DIRECT SOLAR IRRADIANCE

CARD2:
     IHAZE=0  NO AEROSOL ATTENUATION INCLUDED IN CALCULATION.
          =1  RURAL EXTINCTION, 23-KM VIS.
          =2  RURAL EXTINCTION, 5-KM VIS.
          =3  NAVY MARITIME EXTINCTION,SETS OWN VIS.
          =4  MARITIME EXTINCTION, 23-KM VIS.    (LOWTRAN 5 MODEL)
          =5  URBAN EXTINCTION, 5-KM VIS.
          =6  TROPOSPHERIC EXTINCTION, 50-KM VIS.
          =7  USER DEFINED  AEROSOL EXTINCTION COEFFICIENTS
              TRIGGERS READING IREG FOR UP TO 4 REGIONS OF
              USER DEFINED EXTINCTION ABSORPTION AND ASYMMETRY
          =8  FOG1 (ADVECTIVE FOG) EXTINCTION, 0.2-KM VIS.
          =9  FOG2 (RADIATIVE FOG) EXTINCTION, 0.5-KM VIS.
          =10 DESERT EXTINCTION  SETS OWN VISIBILITY FROM WIND SPEED

"""
from __future__ import division,print_function,absolute_import
from warnings import warn
from pandas import DataFrame
from numpy import asarray,atleast_1d,ceil,isfinite
from os import mkdir
#
try:
    import lowtran7 as lt7   #don't use dot in front, it's linking to .dll, .pyd, or .so
except ImportError as e:
    warn('you must compile the Fortran code first. f2py -m lowtran7 -c lowtran7.f  {}'.format(e))
    raise

def golowtran(obsalt_km,zenang_deg,wlnm,c1):
#%% altitude
    obsalt_km = atleast_1d(obsalt_km)
    if obsalt_km.size>1:
        obsalt_km = obsalt_km[0]
        warn('for now I only handle single altitudes. Using first value of {} [km]'.format(obsalt_km))
#%% zenith angle
    zenang_deg=atleast_1d(zenang_deg)
#%% input check
    if not (isfinite(obsalt_km).all() and isfinite(zenang_deg).all() and isfinite(wlnm).all()):
        warn('NaN or Inf detected in input, skipping LOWTRAN')
        return None
#%% setup wavelength
    wlcminv,wlcminvstep,nwl =nm2lt7(wlnm)
    if wlcminvstep<5:
        warn('minimum resolution 5 cm^-1, specified resolution 20 cm^-1')
    if not ((0<=wlcminv) & (wlcminv<=50000)).all():
        warn('** LOWTRAN7: specified model range 0 <= wlcminv <= 50000')
    #TX,V,ALAM,TRACE,UNIF,SUMA = lt7.lwtrn7(True,nwl)
    T = DataFrame(columns=zenang_deg)
#%% invoke lowtran
    """
    Note we invoke case "3a" from table 14, only observer altitude and apparent
    angle are specified
    """
    for za in zenang_deg:
        Tx,V,Alam = lt7.lwtrn7(True,nwl,wlcminv[1],wlcminv[0],wlcminvstep,
                               c1['model'],c1['itype'],c1['iemsct'],
                               obsalt_km,0,za)[:3]
        T[za]= Tx[:,9]
#%% collect results
    T.index=Alam*1e3

    return T

def nm2lt7(wlnm):
    """converts wavelength in nm to cm^-1"""
    wlcminvstep = 5
    wlnm= asarray(wlnm,dtype=float) #for proper division
    wlcminv = 1.e7/wlnm
    nwl = int(ceil((wlcminv[0]-wlcminv[1])/wlcminvstep))+1 #yes, ceil
    return wlcminv,wlcminvstep,nwl

def plottrans(trans,zenang,log):
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
            ax.set_ylim(1e-5,1)
        ax.invert_xaxis()
        ax.set_xlim(left=trans.index[0], right=trans.index[-1])
    except Exception as e:
        warn('trouble plotting   {}'.format(e))

if __name__=='__main__':
    try:
        from matplotlib.pyplot import figure,show
    except ImportError as e:
        warn('lowtran: matplotlib not available. Plots disabled.  {}'.format(e))

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.)
    p.add_argument('-a','--zenang',help='zenith angle [deg]  can be single value or list of values',type=float,nargs='+',default=[0])
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,2500))
    p.add_argument('--model',help='0-6, see Card1 "model" reference. 5=subarctic winter',type=int,default=5)
    p.add_argument('--itype',help='1-3, see Card1 "itype". 3=path to space',type=int,default=3)
    p.add_argument('--iemsct',help='0-3, 0=transmittance',type=int,default=0)

    p=p.parse_args()

    c1={'model':p.model,'itype':p.itype,'iemsct':p.iemsct}

    try:
        mkdir('out')
    except OSError:
        pass

    trans = golowtran(p.obsalt,p.zenang,p.wavelen,c1)

    try:
        plottrans(trans,p.zenang,False)
        plottrans(trans,p.zenang,True)
        show()
    except ImportError as e:
        warn('could not plot results. {}'.format(e))
