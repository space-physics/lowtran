from matplotlib.pyplot import figure


def plottrans(trans,log):
    ax = figure().gca()
    for tran in trans.T:
        ax.plot(tran.wavelength_nm,tran,label=str(tran.zenith_angle.values))
    ax.set_xlabel('wavelength [nm]')
    ax.set_ylabel('transmission (unitless)')
    ax.set_title('zenith angle [deg] = '+str(trans.zenith_angle.values))
    ax.legend(loc='best')
    ax.grid(True)
    if log:
        ax.set_yscale('log')
        ax.set_ylim(1e-5,1)
    ax.invert_xaxis()
    ax.autoscale(True,axis='x',tight=True)