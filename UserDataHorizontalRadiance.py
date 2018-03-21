#!/usr/bin/env python
"""
Horizontal cases are for special use by advanced users.

"""
from pathlib import Path
from numpy import zeros
from dateutil.parser import parse
from pandas import read_csv,read_hdf
from matplotlib.pyplot import show
#
import lowtran
from lowtran.plots import plotradtime

def horizrad(infn,outfn,c1):
    """
    read CSV, simulate, write, plot
    """
    if infn is not None:
        infn = Path(infn).expanduser()

        if infn.suffix=='.h5':
            TR = read_hdf(infn).to_xarray()
            return TR
#%% read csv file
    if not infn: # demo mode
        c1['p']=[949., 959.]
        c1['t']=[283.8, 285.]
        c1['wmol']=[[93.96,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.],
                    [93.96,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.]]
        c1['time']=['2017-04-05T12',
                    '2017-04-05T18']
    else: # read csv, normal case
        PTdata = read_csv(infn)
        c1['p'] = PTdata['p']
        c1['t'] = PTdata['Ta']
        c1['wmol'] = zeros((PTdata.shape[0], 12))
        c1['wmol'][:,0] = PTdata['RH']
        c1['time'] = [parse(t) for t in PTdata['time']]
#%% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    TR = lowtran.loopuserdef(c1)
#%% write to HDF5
    if p.outfn:
        outfn = Path(p.outfn).expanduser()
        print('writing', outfn)
        TR.to_pandas().to_hdf(str(outfn), TR.name)

    return TR


if __name__=='__main__':

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('ptfn',help='csv file with time,relative humidity [%],ambient temperature [K], total pressure (millibar)',nargs='?')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.05)
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,30000))
    p.add_argument('-o','--outfn',help='HDF5 file to write')
    p=p.parse_args()

    #%% low-level Lowtran configuration for this scenario, don't change
    c1={'model':0,  # 0: user meterological data
        'itype':1,  # 1: horizontal path
        'iemsct':1, # 1: radiance model
        'im': 1,    # 1: for horizontal path (see Lowtran manual p.42)
        'ird1': 1,  # 1: use card 2C2
        'range_km':p.obsalt,
        'zmdl':p.obsalt,
        'h1':p.obsalt,
        'wlnmlim': p.wavelen,
        }

    TR = horizrad(p.ptfn,p.outfn,c1)

    plotradtime(TR, c1)

    show()
