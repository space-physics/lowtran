import numpy as np
import xarray
from matplotlib.pyplot import figure
#
h = 6.62607004e-34
c = 299792458
UNITS = 'ster$^{-1}$ cm$^{-2}$ $\mu$m$^{-1}$]'
plotNp = False


def plotscatter(irrad: xarray.Dataset, c1: dict, log: bool=False):

    fg = figure()
    axs = fg.subplots(2, 1, sharex=True)

    transtxt = 'Transmittance'

    ax = axs[0]
    ax.plot(irrad.wavelength_nm, irrad['transmission'].squeeze())
    ax.set_title(transtxt)
    ax.set_ylabel('Transmission (unitless)')
    ax.grid(True)
    ax.legend(irrad.angle_deg.values)

    ax = axs[1]
    if plotNp:
        Np = (irrad['pathscatter']*10000) * (irrad.wavelength_nm*1e9)/(h*c)
        ax.plot(irrad.wavelength_nm, Np)
        ax.set_ylabel('Photons [s$^{-1}$ '+UNITS)
    else:
        ax.plot(irrad.wavelength_nm, irrad['pathscatter'].squeeze())
        ax.set_ylabel('Radiance [W '+UNITS)

    ax.set_xlabel('wavelength [nm]')
    ax.set_title('Single-scatter Path Radiance')
    ax.invert_xaxis()
    ax.autoscale(True, axis='x', tight=True)
    ax.grid(True)

    if log:
        ax.set_yscale('log')
#        ax.set_ylim(1e-8,1)

    try:
        fg.suptitle(f'Obs. to Space: zenith angle: {c1["angle"]} deg., ')
        # {datetime.utcfromtimestamp(irrad.time.item()/1e9)}
    except (AttributeError, TypeError):
        pass


def plotradiance(irrad: xarray.Dataset, c1: dict, log: bool=False):
    fg = figure()
    axs = fg.subplots(2, 1, sharex=True)

    transtxt = 'Transmittance Observer to Space'

    ax = axs[0]
    ax.plot(irrad.wavelength_nm, irrad['transmission'].squeeze())
    ax.set_title(transtxt)
    ax.set_ylabel('Transmission (unitless)')
    ax.grid(True)

    ax = axs[1]
    if plotNp:
        Np = (irrad['radiance']*10000) * (irrad.wavelength_nm*1e9)/(h*c)
        ax.plot(irrad.wavelength_nm, Np)
        ax.set_ylabel('Photons [s$^{-1}$ '+UNITS)
    else:
        ax.plot(irrad.wavelength_nm, irrad['radiance'].squeeze())
        ax.set_ylabel('Radiance [W '+UNITS)

    ax.set_xlabel('wavelength [nm]')
    ax.set_title('Atmospheric Radiance')
    ax.invert_xaxis()
    ax.autoscale(True, axis='x', tight=True)
    ax.grid(True)

    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-8, 1)

    try:
        fg.suptitle(f'Obs. zenith angle: {c1["angle"]} deg., ')
        # {datetime.utcfromtimestamp(irrad.time.item()/1e9)}
    except (AttributeError, TypeError):
        pass


def plotradtime(TR: xarray.Dataset, c1: dict, log: bool=False):
    """
    make one plot per time for now.

    TR: 3-D array: time, wavelength, [transmittance, radiance]

    radiance is currently single-scatter solar
    """

    for t in TR.time:  # for each time
        plotirrad(TR.sel(time=t), c1, log)


def plottrans(T: xarray.Dataset, c1: dict, log: bool=False):
    ax = figure().gca()

    h = ax.plot(T.wavelength_nm, T['transmission'].squeeze())

    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('transmission (unitless)')
    ax.set_title(f'Transmittance Ground-Space: Obs. zenith angle {c1["angle"]} deg.')
    # ax.legend(loc='best')
    ax.grid(True)
    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-5, 1)
    else:
        ax.set_ylim(0, 1)
    ax.invert_xaxis()
    ax.autoscale(True, axis='x', tight=True)
    ax.legend(h, T.angle_deg.values)


def plotirrad(irrad: xarray.Dataset, c1: dict, log: bool=False):
    fg = figure()
    axs = fg.subplots(2, 1, sharex=True)

#    if c1['isourc'] == 0:
    stxt = "Sun's"
#    elif c1['isourc'] == 1:
#        stxt = "Moon's"
#    else:
#        raise ValueError(f'ISOURC={c1["isourc"]} not defined case')

    stxt += f' zenith angle {irrad.angle_deg.values} deg., Obs. height {c1["h1"]} km. '
    try:
        stxt += np.datetime_as_string(irrad.time)[:-10]
    except (AttributeError, TypeError):
        pass

    fg.suptitle(stxt)

    if c1['iemsct'] == 3:
        key = 'irradiance'
        transtxt = 'Transmittance Observer to Space'
    elif c1['iemsct'] == 1:
        key = 'radiance'
        transtxt = 'Transmittance Observer to Observer'

    # irrad.['transmission'].plot()

    ax = axs[0]
    h = ax.plot(irrad.wavelength_nm, irrad['transmission'].squeeze())
    ax.set_title(transtxt)
    ax.set_ylabel('Transmission (unitless)')
    ax.grid(True)
    try:
        ax.legend(h, irrad.angle_deg.values)
    except AttributeError:
        pass

    ax = axs[1]
    ax.plot(irrad.wavelength_nm, irrad[key].squeeze())
    ax.set_xlabel('wavelength [nm]')
    ax.invert_xaxis()
    ax.grid(True)

    if c1['iemsct'] == 3:
        ttxt = 'Irradiance '
        ax.set_ylabel('Solar Irradiance [W '+UNITS)
        ax.set_title(ttxt)
    elif c1['iemsct'] == 1:
        ttxt = 'Single-scatter Radiance '
        ax.set_ylabel('Radiance [W '+UNITS)
        ax.set_title(ttxt)

    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-8, 1)

    ax.autoscale(True, axis='x', tight=True)


def plothoriz(trans: xarray.Dataset, c1: dict, log: bool=False):

    ttxt = f'Transmittance Horizontal \n {c1["range_km"]} km path @ {c1["h1"]} km altitude\n'

    if c1['model'] == 0:
        ttxt += f'User defined atmosphere: pressure: {c1["p"]} mbar, temperature {c1["t"]} K'
    elif c1['model'] == 5:
        ttxt += f'Subarctic winter atmosphere'

    ax = figure().gca()

    ax.plot(trans.wavelength_nm, trans['transmission'].squeeze())

    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('transmission (unitless)')
    ax.set_title(ttxt)
    # ax.legend(loc='best')
    ax.grid(True)
    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-5, 1)
    else:
        ax.set_ylim(0, 1)
    ax.invert_xaxis()
    ax.autoscale(True, axis='x', tight=True)
