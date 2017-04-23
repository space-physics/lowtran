from datetime import datetime
from xarray import DataArray
from matplotlib.pyplot import figure,subplots
#
h = 6.62607004e-34
c = 299792458

def plotradiance(irrad:DataArray, log:bool, c1:dict):

    fg,axs = subplots(2,1,sharex=True)

    transtxt = 'Transmittance Observer to Space'

    ax = axs[0]
    ax.plot(irrad.wavelength_nm,irrad.loc[:,'transmission'])
    ax.set_title(transtxt)
    ax.set_ylabel('Transmission (unitless)')
    ax.grid(True)

    Np = (irrad.loc[:,'radiance']*10000) * (irrad.wavelength_nm*1e9)/(h*c)

    ax = axs[1]
    #ax.plot(irrad.wavelength_nm, irrad.loc[:,'radiance'])
    #ax.set_ylabel('Radiance [W cm^-2 ster^-1 micron^-1]')
    ax.plot(irrad.wavelength_nm, Np)
    ax.set_ylabel('Photons ster$^{-1}$ cm$^{-2}$ s$^{-1}$ micron$^{-1}$')
    ax.set_xlabel('wavelength [nm]')
    ax.set_title('Single-scatter Solar Radiance')
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)
    ax.grid(True)

    if log:
        ax.set_yscale('log')
#        ax.set_ylim(1e-8,1)

    try:
        fg.suptitle(str(datetime.utcfromtimestamp(irrad.time.item()/1e9)))
    except (AttributeError,TypeError):
        pass

def plotradtime(TR:DataArray, zenang_deg:float, c1:dict) -> None:
    """
    make one plot per time for now.

    TR: 3-D Panel: time, wavelength, [transmittance, radiance]

    radiance is currently single-scatter solar
    """
    assert isinstance(TR,DataArray)

    for tr in TR: # for each time
        plotirrad(tr,False,c1)


def plottrans(trans,zenang_deg,log) -> None:
    ax = figure().gca()

    ax.plot(trans.wavelength_nm, trans.loc[:,'transmission'], label=str(zenang_deg))

    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('transmission (unitless)')
    ax.set_title(f'Transmittance Ground-Space: zenith angle {zenang_deg} deg.')
    #ax.legend(loc='best')
    ax.grid(True)
    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-5,1)
    else:
        ax.set_ylim(0,1)
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)

def plotirrad(irrad,log,c1):

    fg,ax = subplots(2,1,sharex=True)

    if c1['iemsct'] == 3:
        key='irradiance'
        transtxt = 'Transmittance Observer to Space'
    elif c1['iemsct'] == 1:
        key='radiance'
        transtxt = 'Transmittance Observer to Observer'


    ax[0].plot(irrad.wavelength_nm,irrad.loc[:,'transmission'])
    ax[1].plot(irrad.wavelength_nm,irrad.loc[:,key])


    ax[1].set_xlabel('wavelength [nm]')
    if c1['iemsct'] == 3:
        ttxt= 'Solar Irradiance '
        ax[1].set_ylabel('Solar Irradiance [W cm^-2 ster^-1 micron^-1]')
        ax[1].set_title(ttxt)
    elif c1['iemsct'] ==1:
        ttxt = 'Single-scatter Solar Radiance '
        ax[1].set_ylabel('Radiance [W cm^-2 ster^-1 micron^-1]')
        ax[1].set_title(ttxt)

    ax[0].set_title(transtxt)
    ax[0].set_ylabel('Transmission (unitless)')

    ax[0].grid(True)
    ax[1].grid(True)

    if log:
        ax[1].set_yscale('log')
        ax[1].set_ylim(1e-8,1)

    ax[1].invert_xaxis()
    ax[1].autoscale(True,axis='x',tight=True)

    try:
        fg.suptitle(str(datetime.utcfromtimestamp(irrad.time.item()/1e9)))
    except (AttributeError,TypeError):
        pass

def plothoriz(trans,zenang_deg,c1,log):
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
