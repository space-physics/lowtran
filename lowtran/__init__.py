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
import numpy as np
#
try:
    import lowtran7   #don't use dot in front, it's linking to .dll, .pyd, or .so
except ImportError as e:
    raise ImportError(f'you must compile the Fortran code first. f2py -m lowtran7 -c lowtran7.f  {e} ')
    
def looplowtran(obsalt_km,zenang_deg,wlnm,c1):
    """
    golowtran() is for scalar parameters only 
    (besides vector of wavelength, which Lowtran internally loops over)
    You are welcome to call golowtran() directly if you don't need looping.
    
    wmol, p, t must all be vector(s) of same length
    """
    
    wmol = np.atleast_2d(c1['wmol'])
    P = c1['p']
    T = c1['t']
    time = c1['time']

    assert wmol.shape[0] == len(P) == len(T) == len(time),'WMOL, P, T,time must be vectors of equal length'
    
    N = len(P)
#%% preassign wavelengths for indexing
    wlcminv,wlcminvstep,nwl = nm2lt7(wlnm)
    wl_nm = 1e7 / np.arange(wlcminv[1],wlcminv[0]+wlcminvstep,wlcminvstep)
#%% Panel is a 3-D array indexed by metadata
    TR = DataArray(data=np.empty((N,wl_nm.size,3)),
                   coords={'time':time,
                           'wavelength_nm':wl_nm,
                           'sim':['transmission','radiance','irradiance']},
                   dims=['time','wavelength_nm','sim'],
                   name='LowtranSim')
        
    for i in range(N):
        c1['wmol'] = wmol[i,:]
        c1['p'] = P[i]
        c1['t'] = T[i]
        
        tr = golowtran(obsalt_km, zenang_deg, wlnm, c1)
        TR.loc[time[i],...] = tr
    
 #   TR = TR.sort_index(axis=0) # put times in order, sometimes CSV is not monotonic in time.
    
    return TR

def golowtran(obsalt_km,zenang_deg, wlnm,c1):# -> DataArray:
#%% default parameters
    defp = ('im','iseasn','ird1','range_km','zmdl','p','t')
    for p in defp:
        if p not in c1:
            c1[p] =  0

    if 'wmol' not in c1:
        c1['wmol']=[0]*12
        
    assert len(c1['wmol']) == 12,'see Lowtran user manual for 12 values of WMOL'
    
#%% altitude
    obsalt_km = np.atleast_1d(obsalt_km)
    if obsalt_km.size>1:
        obsalt_km = obsalt_km[0]
        logging.error(f'for now I only handle single altitudes. Using first value of {obsalt_km} [km]')
#%% zenith angle
    zenang_deg = np.atleast_1d(zenang_deg)
#%% input check
    if not (np.isfinite(obsalt_km).all() and np.isfinite(zenang_deg).all() and np.isfinite(wlnm).all()):
        logging.critical('NaN or Inf detected in input, skipping LOWTRAN')
        return
#%% setup wavelength
    wlcminv,wlcminvstep,nwl = nm2lt7(wlnm)
    if wlcminvstep<5:
        logging.critical('minimum resolution 5 cm^-1, specified resolution 20 cm^-1')
    if not ((0<=wlcminv) & (wlcminv<=50000)).all():
       logging.critical('specified model range 0 <= wlcminv <= 50000')

#%% invoke lowtran
    """
    Note we invoke case "3a" from table 14, only observer altitude and apparent
    angle are specified
    """
    Tx,V,Alam,trace,unif,suma,irrad,sumvv = lowtran7.lwtrn7(
                            True, nwl, wlcminv[1], wlcminv[0], wlcminvstep,
                            c1['model'], c1['itype'], c1['iemsct'], c1['im'],
                            c1['iseasn'], c1['ird1'],
                            c1['zmdl'], c1['p'], c1['t'], c1['wmol'],
                            obsalt_km, 0, zenang_deg, c1['range_km'])
    TR = DataArray(np.column_stack((Tx[:,9],sumvv,irrad[:,0])),
                   coords={'wavelength_nm':Alam*1e3,
                           'sim':['transmission','radiance','irradiance']},
                     dims = ['wavelength_nm','sim'])
#%% collect results
    return TR

def nm2lt7(wlnm):
    """converts wavelength in nm to cm^-1"""
    wlcminvstep = 5 # minimum meaningful step is 20, but 5 is minimum before crashing lowtran
    wlnm= np.asarray(wlnm,dtype=float) #for proper division
    wlcminv = 1.e7/wlnm
    nwl = int(np.ceil((wlcminv[0]-wlcminv[1])/wlcminvstep))+1 #yes, ceil
    return wlcminv,wlcminvstep,nwl
