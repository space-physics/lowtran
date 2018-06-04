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
from typing import Tuple
from pathlib import Path
from pandas import read_csv
from dateutil.parser import parse
import logging
import xarray
import numpy as np
#
try:
    import lowtran7  # don't use dot in front, it's linking to .dll, .pyd, or .so
except ImportError as e:
    raise ImportError('you must compile the Fortran code first. f2py -m lowtran7 -c lowtran7.f {}'.format(e))


def loopuserdef(c1: dict) -> xarray.DataArray:
    """
    golowtran() is for scalar parameters only
    (besides vector of wavelength, which Lowtran internally loops over)

    wmol, p, t must all be vector(s) of same length
    """

    wmol = np.atleast_2d(c1['wmol'])
    P = np.atleast_1d(c1['p'])
    T = np.atleast_1d(c1['t'])
    time = np.atleast_1d(c1['time'])

    assert wmol.shape[0] == len(P) == len(T) == len(time), 'WMOL, P, T,time must be vectors of equal length'

    N = len(P)
# %% 3-D array indexed by metadata
    TR = xarray.Dataset(coords={'time': time, 'wavelength_nm': None, 'angle_deg': None})

    for i in range(N):
        c = c1.copy()
        c['wmol'] = wmol[i, :]
        c['p'] = P[i]
        c['t'] = T[i]
        c['time'] = time[i]

        TR = TR.merge(_golowtran(c))

    #   TR = TR.sort_index(axis=0) # put times in order, sometimes CSV is not monotonic in time.

    return TR


def loopangle(c1: dict) -> xarray.Dataset:
    """
    loop over "ANGLE"
    """
    angles = np.atleast_1d(c1['angle'])
    TR = xarray.Dataset(coords={'wavelength_nm': None, 'angle_deg': angles})

    for a in angles:
        c = c1.copy()
        c['angle'] = a
        TR = TR.merge(_golowtran(c))

    return TR


def _golowtran(c1: dict) -> xarray.Dataset:
    """directly run Fortran code"""
# %% default parameters
    if 'time' not in c1:
        c1['time'] = None

    defp = ('h1', 'h2', 'angle', 'im', 'iseasn', 'ird1', 'range_km', 'zmdl', 'p', 't')
    for p in defp:
        if p not in c1:
            c1[p] = 0

    if 'wmol' not in c1:
        c1['wmol'] = [0]*12
# %% input check
    assert len(c1['wmol']) == 12, 'see Lowtran user manual for 12 values of WMOL'
    assert np.isfinite(c1['h1']), 'per Lowtran user manual Table 14, H1 must always be defined'
# %% setup wavelength
    wlcminv, wlcminvstep, nwl = nm2lt7(c1['wlnmlim'])
    if wlcminvstep < 5:
        logging.critical('minimum resolution 5 cm^-1, specified resolution 20 cm^-1')
    if not ((0 <= wlcminv) & (wlcminv <= 50000)).all():
        logging.critical('specified model range 0 <= wlcminv <= 50000')
# %% invoke lowtran
    """
    Note we invoke case "3a" from table 14, only observer altitude and apparent
    angle are specified
    """
    Tx, V, Alam, trace, unif, suma, irrad, sumvv = lowtran7.lwtrn7(
        True, nwl, wlcminv[1], wlcminv[0], wlcminvstep,
        c1['model'], c1['itype'], c1['iemsct'], c1['im'],
        c1['iseasn'], c1['ird1'],
        c1['zmdl'], c1['p'], c1['t'], c1['wmol'],
        c1['h1'], c1['h2'], c1['angle'], c1['range_km'])

    dims = ('time', 'wavelength_nm', 'angle_deg')
    TR = xarray.Dataset({'transmission': (dims, Tx[:, 9][None, :, None]),
                         'radiance': (dims, sumvv[None, :, None]),
                         'irradiance': (dims, irrad[:, 0][None, :, None]),
                         'pathscatter': (dims, irrad[:, 2][None, :, None])},
                        coords={'time': [c1['time']],
                                'wavelength_nm': Alam*1e3,
                                'angle_deg': [c1['angle']]})

    return TR


def nm2lt7(wlnm: np.ndarray) -> Tuple[np.ndarray, float, float]:
    """converts wavelength in nm to cm^-1"""
    wlcminvstep = 5  # minimum meaningful step is 20, but 5 is minimum before crashing lowtran
    wlnm = np.asarray(wlnm, dtype=float)  # for proper division
    wlcminv = 1.e7/wlnm
    nwl = int(np.ceil((wlcminv[0]-wlcminv[1])/wlcminvstep))+1  # yes, ceil

    return wlcminv, wlcminvstep, nwl


def scatter(c1: dict) -> xarray.Dataset:
    # %% low-level Lowtran configuration for this scenario, don't change
    c1.update({
        'itype':  3,  # 3: observer to space
        'iemsct': 2,  # 2: radiance model
    })
# %% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    return loopangle(c1)


def irradiance(c1: dict) -> xarray.Dataset:
    c1.update({
        'itype': 3,   # 3: observer to space
        'iemsct': 3,  # 3: solar irradiance
    })

    return loopangle(c1)


def radiance(c1: dict) -> xarray.Dataset:

    c1.update({
        'itype':  3,  # 3: observer to space
        'iemsct': 1,  # 1: thermal radiance model  2: radiance model
    })
# %% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    return loopangle(c1)


def transmittance(c1: dict) -> xarray.Dataset:

    c1.update({
        'itype': 3,   # 3: observer to space
        'iemsct': 0,  # 0: transmittance
    })

    return loopangle(c1)


def horizrad(infn: Path, outfn: Path, c1: dict) -> xarray.Dataset:
    """
    read CSV, simulate, write, plot
    """
    if infn is not None:
        infn = Path(infn).expanduser()

        if infn.suffix == '.h5':
            TR = xarray.open_dataset(infn)
            return TR

    c1.update({'model': 0,  # 0: user meterological data
               'itype': 1,  # 1: horizontal path
               'iemsct': 1,  # 1: radiance model
               'im': 1,    # 1: for horizontal path (see Lowtran manual p.42)
               'ird1': 1,  # 1: use card 2C2)
               })
# %% read csv file
    if not infn:  # demo mode
        c1['p'] = [949., 959.]
        c1['t'] = [283.8, 285.]
        c1['wmol'] = [[93.96, 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.],
                      [93.96, 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]]
        c1['time'] = [parse('2017-04-05T12'),
                      parse('2017-04-05T18')]
    else:  # read csv, normal case
        PTdata = read_csv(infn)
        c1['p'] = PTdata['p']
        c1['t'] = PTdata['Ta']
        c1['wmol'] = np.zeros((PTdata.shape[0], 12))
        c1['wmol'][:, 0] = PTdata['RH']
        c1['time'] = [parse(t) for t in PTdata['time']]
# %% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    TR = loopuserdef(c1)

    return TR


def horiztrans(c1: dict) -> xarray.Dataset:

    c1.update({'model': 5,  # 5: subartic winter
               'itype': 1,  # 1: horizontal path
               'iemsct': 0,  # 0: transmittance model
               'im': 0,  # 1: for user-defined atmosphere on horizontal path (see Lowtran manual p.42)
               'ird1': 0,  # 1: use card 2C2
               })

    return _golowtran(c1)


def userhoriztrans(c1: dict) -> xarray.Dataset:

    c1.update({'model': 0,  # 0: user meterological data
               'itype': 1,  # 1: horizontal path
               'iemsct': 0,  # 0: transmittance model
               'im': 1,  # 1: for user-defined atmosphere on horizontal path (see Lowtran manual p.42)
               'ird1': 1,  # 1: use card 2C2
               })

    return _golowtran(c1)
