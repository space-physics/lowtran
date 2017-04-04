"""
Michael Hirsch
Python wrapper of the venerable LOWTRAN7 atmospheric absorption and solar transmission
model circa 1992.

Note: specified Lowtran7 model limitations include
wlcminvstep >= 20 cm^-1
0 <= wlcminv <= 50000

historical note:
developed on CDC CYBER, currently runs on 32-bit single float--this can cause loss of numerical
precision, future would like to ensure full LOWTRAN7 code can run at 64-bit double float.

user manual:
www.dtic.mil/dtic/tr/fulltext/u2/a206773.pdf

"""
import logging
from xarray import DataArray
from numpy import asarray,atleast_1d,ceil,isfinite,empty
#
try:
    import lowtran7   #don't use dot in front, it's linking to .dll, .pyd, or .so
except ImportError as e:
    raise ImportError(f'you must compile the Fortran code first. f2py -m lowtran7 -c lowtran7.f  {e} ')

def golowtran(obsalt_km,zenang_deg,wlnm,c1):# -> DataArray:
#%% default parameters
    defp = ('im','iseasn','ird1','range_km','zmdl','p','t')
    for p in defp:
        if p not in c1:
            c1[p] =  0

    if 'wmol' not in c1:
        c1['wmol']=[0]*12
        
    assert len(c1['wmol']) == 12,'see Lowtran user manual for 12 values of WMOL'
    
#%% altitude
    obsalt_km = atleast_1d(obsalt_km)
    if obsalt_km.size>1:
        obsalt_km = obsalt_km[0]
        logging.error(f'for now I only handle single altitudes. Using first value of {obsalt_km} [km]')
#%% zenith angle
    zenang_deg=atleast_1d(zenang_deg)
#%% input check
    if not (isfinite(obsalt_km).all() and isfinite(zenang_deg).all() and isfinite(wlnm).all()):
        logging.critical('NaN or Inf detected in input, skipping LOWTRAN')
        return
#%% setup wavelength
    wlcminv,wlcminvstep,nwl =nm2lt7(wlnm)
    if wlcminvstep<5:
        logging.error('minimum resolution 5 cm^-1, specified resolution 20 cm^-1')
    if not ((0<=wlcminv) & (wlcminv<=50000)).all():
       logging.error('specified model range 0 <= wlcminv <= 50000')
    #TX,V,ALAM,TRACE,UNIF,SUMA = lowtran7.lwtrn7(True,nwl)
    T = DataArray(data=empty((nwl,)), dims=['wavelength_nm'])
#%% invoke lowtran
    """
    Note we invoke case "3a" from table 14, only observer altitude and apparent
    angle are specified
    """
    Tx,V,Alam,trace,unif,suma,irrad = lowtran7.lwtrn7(
                            True, nwl, wlcminv[1], wlcminv[0], wlcminvstep,
                            c1['model'], c1['itype'], c1['iemsct'], c1['im'],
                            c1['iseasn'], c1['ird1'],
                            c1['zmdl'], c1['p'], c1['t'], c1['wmol'],
                            obsalt_km, 0, zenang_deg, c1['range_km'])
    T = DataArray(data=Tx[:,9], dims=['wavelength_nm'])
#%% collect results
    T['wavelength_nm']=Alam*1e3
    
    if c1['iemsct'] != 3:
        Irrad=None
    else:
        Irrad = DataArray(data=irrad[:,0],dims=['wavelength_nm'])
        Irrad['wavelength_nm']=T.wavelength_nm

    return T,Irrad

def nm2lt7(wlnm):
    """converts wavelength in nm to cm^-1"""
    wlcminvstep = 5 # minimum meaningful step is 20, but 5 is minimum before crashing lowtran
    wlnm= asarray(wlnm,dtype=float) #for proper division
    wlcminv = 1.e7/wlnm
    nwl = int(ceil((wlcminv[0]-wlcminv[1])/wlcminvstep))+1 #yes, ceil
    return wlcminv,wlcminvstep,nwl
