from datetime import datetime
from xarray import DataArray
from matplotlib.pyplot import figure,subplots
#
h = 6.62607004e-34
c = 299792458
UNITS='ster$^{-1}$ cm$^{-2}$ $\mu$m$^{-1}$]'
plotNp = False

def plotscatter(irrad:DataArray, c1:dict, log:bool=False):

    fg,axs = subplots(2, 1, sharex=True)

    transtxt = 'Transmittance'

    ax = axs[0]
    ax.plot(irrad.wavelength_nm, irrad.loc[...,'transmission'].T)
    ax.set_title(transtxt)
    ax.set_ylabel('Transmission (unitless)')
    ax.grid(True)

    ax = axs[1]
    if plotNp:
        Np = (irrad.loc[...,'pathscatter']*10000) * (irrad.wavelength_nm*1e9)/(h*c)
        ax.plot(irrad.wavelength_nm, Np.T)
        ax.set_ylabel('Photons [s$^{-1}$ '+UNITS)
    else:
        ax.plot(irrad.wavelength_nm, irrad.loc[...,'pathscatter'].T)
        ax.set_ylabel('Radiance [W '+UNITS)

    ax.set_xlabel('wavelength [nm]')
    ax.set_title('Single-scatter Path Radiance')
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)
    ax.grid(True)

    if log:
        ax.set_yscale('log')
#        ax.set_ylim(1e-8,1)

    try:
        fg.suptitle(f'Obs. to Space: zenith angle: {c1["angle"]} deg., ')
        #{datetime.utcfromtimestamp(irrad.time.item()/1e9)}
    except (AttributeError,TypeError):
        pass

def plotradiance(irrad:DataArray, c1:dict, log:bool=False):

    fg,axs = subplots(2, 1, sharex=True)

    transtxt = 'Transmittance Observer to Space'

    ax = axs[0]
    ax.plot(irrad.wavelength_nm, irrad.loc[...,'transmission'].T)
    ax.set_title(transtxt)
    ax.set_ylabel('Transmission (unitless)')
    ax.grid(True)

    ax = axs[1]
    if plotNp:
        Np = (irrad.loc[...,'radiance']*10000) * (irrad.wavelength_nm*1e9)/(h*c)
        ax.plot(irrad.wavelength_nm, Np.T)
        ax.set_ylabel('Photons [s$^{-1}$ '+UNITS)
    else:
        ax.plot(irrad.wavelength_nm, irrad.loc[...,'radiance'].T)
        ax.set_ylabel('Radiance [W '+UNITS)

    ax.set_xlabel('wavelength [nm]')
    ax.set_title('Atmospheric Radiance')
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)
    ax.grid(True)

    if log:
        ax.set_yscale('log')
#        ax.set_ylim(1e-8,1)

    try:
        fg.suptitle(f'Obs. zenith angle: {c1["angle"]} deg., ')
        #{datetime.utcfromtimestamp(irrad.time.item()/1e9)}
    except (AttributeError,TypeError):
        pass

def plotradtime(TR:DataArray, c1:dict, log:bool=False):
    """
    make one plot per time for now.

    TR: 3-D Panel: time, wavelength, [transmittance, radiance]

    radiance is currently single-scatter solar
    """
    assert isinstance(TR,DataArray)

    for tr in TR: # for each time
        plotirrad(tr, c1, False)


def plottrans(trans:DataArray, c1:dict, log:bool=False):
    ax = figure().gca()

    h = ax.plot(trans.wavelength_nm, trans.loc[...,'transmission'].T)

    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('transmission (unitless)')
    ax.set_title(f'Transmittance Ground-Space: Obs. zenith angle {c1["angle"]} deg.')
    #ax.legend(loc='best')
    ax.grid(True)
    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-5,1)
    else:
        ax.set_ylim(0,1)
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)
    ax.legend(h, trans.angle.values.astype(str))


def plotirrad(irrad:DataArray, c1:dict, log:bool=False):

    fg,axs = subplots(2,1,sharex=True)

#    if c1['isourc'] == 0:
    stxt = "Sun's"
#    elif c1['isourc'] == 1:
#        stxt = "Moon's"
#    else:
#        raise ValueError(f'ISOURC={c1["isourc"]} not defined case')

    stxt += f' zenith angle {c1["angle"]} deg., Obs. height {c1["h1"]} km'
    try:
        stxt += str(datetime.utcfromtimestamp(irrad.time.item()/1e9))
    except (AttributeError,TypeError):
        pass

    fg.suptitle(stxt)

    if c1['iemsct'] == 3:
        key='irradiance'
        transtxt = 'Transmittance Observer to Space'
    elif c1['iemsct'] == 1:
        key='radiance'
        transtxt = 'Transmittance Observer to Observer'

    #irrad.loc[...,'transmission'].plot()

    ax = axs[0]
    h = ax.plot(irrad.wavelength_nm, irrad.loc[..., 'transmission'].T)
    ax.set_title(transtxt)
    ax.set_ylabel('Transmission (unitless)')
    ax.grid(True)
    try:
        ax.legend(h, irrad.angle.values.astype(str))
    except AttributeError:
        pass

    ax = axs[1]
    ax.plot(irrad.wavelength_nm, irrad.loc[..., key].T)
    ax.set_xlabel('wavelength [nm]')
    ax.invert_xaxis()
    ax.grid(True)

    if c1['iemsct'] == 3:
        ttxt= 'Irradiance '
        ax.set_ylabel('Solar Irradiance [W '+UNITS)
        ax.set_title(ttxt)
    elif c1['iemsct'] ==1:
        ttxt = 'Single-scatter Radiance '
        ax.set_ylabel('Radiance [W '+UNITS)
        ax.set_title(ttxt)

    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-8,1)

    ax.autoscale(True,axis='x',tight=True)


def plothoriz(trans:DataArray, c1:dict, log:bool=False):
    ax = figure().gca()

    ax.plot(trans.wavelength_nm, trans)

    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('transmission (unitless)')
    ax.set_title(f'Transmittance Horizontal: {c1["range_km"]} km path')
    #ax.legend(loc='best')
    ax.grid(True)
    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-5,1)
    else:
        ax.set_ylim(0,1)
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)
