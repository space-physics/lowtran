#!/usr/bin/env python
from numpy.testing import assert_array_almost_equal,run_module_suite
#
import lowtran

def test_atmosphere_transmission():

    c1={'model':5,'itype':3,'iemsct':0,'im':0,
        'iseasn':0,'ird1':0,'range_km':0,'zmdl':0,'p':0,'t':0,
        'wmol':[0]*12}

    T,irrad = lowtran.golowtran(0,0,[500,900],c1)

    assert_array_almost_equal([900.090027,  500.],T.wavelength_nm.values[[0,-1]])
    assert_array_almost_equal([0.87720001, 0.85709256],T.values[[0,-1]].squeeze())

if __name__ == '__main__':
    run_module_suite()
