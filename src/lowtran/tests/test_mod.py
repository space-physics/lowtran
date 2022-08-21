import numpy as np
from pytest import approx

#
import lowtran


def test_fortran():

    c1 = {
        "h1": 0.0,
        "angle": 0,
        "wlshort": 500.0,
        "wllong": 900.0,
        "model": 5,
        "itype": 3,
        "iemsct": 0,
        "im": 0,
        "iseasn": 0,
        "ird1": 0,
        "range_km": 0,
        "zmdl": 0,
        "p": 0,
        "t": 0,
        "wmol": [0] * 12,
    }

    TR = lowtran.golowtran(c1)

    assert TR.wavelength_nm[[0, -1]].values == approx([900.0900, 500.0], rel=0.001)
    assert TR["transmission"][0, [0, -1], 0].values == approx([0.8772, 0.8569779])


def test_userfail():
    c1 = {
        "zmdl": 0.3,
        "h1": 0.3,
        "range_km": 1.0,
        "wlshort": 200.0,
        "wllong": 30000.0,
        "wlstep": 20.0,
    }

    TR = lowtran.userhoriztrans(c1)

    assert np.isnan(TR["transmission"]).all()
