from matplotlib.pyplot import figure


def plottrans(trans,zenang_deg,log):
    ax = figure().gca()
    
    ax.plot(trans.wavelength_nm, trans, label=str(zenang_deg))
    
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
    
def plotirrad(irrad,log):
    ax = figure().gca()
    
    ax.plot(irrad.wavelength_nm,irrad)
        
    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('Solar Irradiance [W cm^-2 per micron]')
    ax.set_title('Solar Irradiance')
    ax.grid(True)
    
    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-8,1)
        
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)
    
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