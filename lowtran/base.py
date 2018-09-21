from typing import Dict, Any
import logging
import xarray
import numpy as np
from typing import Tuple
try:
    import lowtran7  # don't use dot in front, it's linking to .dll, .pyd, or .so
except ImportError as e:
    raise ImportError(f'you must compile the Fortran code first. f2py -m lowtran7 -c lowtran7.f  {e}')


def nm2lt7(short_nm: float, long_nm: float, step_cminv: float = 20) -> Tuple[float, float, float]:
    """converts wavelength in nm to cm^-1
    minimum meaningful step is 20, but 5 is minimum before crashing lowtran

    short: shortest wavelength e.g. 200 nm
    long: longest wavelength e.g. 30000 nm
    step: step size in cm^-1 e.g. 20

    output in cm^-1
    """
    short = 1e7 / short_nm
    long = 1e7 / long_nm

    N = int(np.ceil((short-long) / step_cminv)) + 1  # yes, ceil

    return short, long, N


def loopuserdef(c1: Dict[str, Any]) -> xarray.DataArray:
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

        TR = TR.merge(golowtran(c))

    #   TR = TR.sort_index(axis=0) # put times in order, sometimes CSV is not monotonic in time.

    return TR


def loopangle(c1: Dict[str, Any]) -> xarray.Dataset:
    """
    loop over "ANGLE"
    """
    angles = np.atleast_1d(c1['angle'])
    TR = xarray.Dataset(coords={'wavelength_nm': None, 'angle_deg': angles})

    for a in angles:
        c = c1.copy()
        c['angle'] = a
        TR = TR.merge(golowtran(c))

    return TR


def golowtran(c1: Dict[str, Any]) -> xarray.Dataset:
    """directly run Fortran code"""
# %% default parameters
    c1.setdefault('time', None)

    defp = ('h1', 'h2', 'angle', 'im', 'iseasn', 'ird1', 'range_km', 'zmdl', 'p', 't')
    for p in defp:
        c1.setdefault(p, 0)

    c1.setdefault('wmol', [0]*12)
# %% input check
    assert len(c1['wmol']) == 12, 'see Lowtran user manual for 12 values of WMOL'
    assert np.isfinite(c1['h1']), 'per Lowtran user manual Table 14, H1 must always be defined'
# %% setup wavelength
    c1.setdefault('wlstep', 20)
    if c1['wlstep'] < 5:
        logging.critical('minimum resolution 5 cm^-1, specified resolution 20 cm^-1')

    wlshort, wllong, nwl = nm2lt7(c1['wlshort'], c1['wllong'], c1['wlstep'])

    if not 0 < wlshort and wllong <= 50000:
        logging.critical('specified model range 0 <= wavelength [cm^-1] <= 50000')
# %% invoke lowtran
    """
    Note we invoke case "3a" from table 14, only observer altitude and apparent
    angle are specified
    """
    Tx, V, Alam, trace, unif, suma, irrad, sumvv = lowtran7.lwtrn7(
        True, nwl, wllong, wlshort, c1['wlstep'],
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
