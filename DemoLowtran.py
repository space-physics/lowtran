#!/usr/bin/env python
from os import makedirs
from matplotlib.pyplot import show
#
from lowtran import golowtran
from lowtran.plots import plottrans

if __name__=='__main__':

    from argparse import ArgumentParser
    p = ArgumentParser(description='Lowtran 7 interface')
    p.add_argument('-z','--obsalt',help='altitude of observer [km]',type=float,default=0.)
    p.add_argument('-a','--zenang',help='zenith angle [deg]  can be single value or list of values',type=float,nargs='+',default=[0])
    p.add_argument('-w','--wavelen',help='wavelength range nm (start,stop)',type=float,nargs=2,default=(200,2500))
    p.add_argument('--model',help='0-6, see Card1 "model" reference. 5=subarctic winter',type=int,default=5)
    p.add_argument('--itype',help='1-3, see Card1 "itype". 3=path to space',type=int,default=3)
    p.add_argument('--iemsct',help='0-3, 0=transmittance',type=int,default=0)

    p=p.parse_args()

    c1={'model':p.model,'itype':p.itype,'iemsct':p.iemsct}

    makedirs('out',exist_ok=True)

    trans = golowtran(p.obsalt,p.zenang,p.wavelen,c1)

    try:
        plottrans(trans,False)
        plottrans(trans,True)
        show()
    except Exception as e:
        print('skipped plotting {}'.format(e))
