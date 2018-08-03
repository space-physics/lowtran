#!/usr/bin/env python
import numpy as np
from numpy.testing import assert_allclose
import pytest
#
import lowtran


def test_fortran():

    c1 = {'h1': 0., 'angle': 0, 'wlnmlim': (500, 900), 'model': 5, 'itype': 3, 'iemsct': 0, 'im': 0,
          'iseasn': 0, 'ird1': 0, 'range_km': 0, 'zmdl': 0, 'p': 0, 't': 0,
          'wmol': [0]*12}

    TR = lowtran._golowtran(c1)

    assert_allclose(TR.wavelength_nm[[0, -1]],
                    [900.090027,  500.])
    assert_allclose(TR['transmission'][0, [0, -1], 0],
                    [0.87720001, 0.85709256])


def test_userfail():
    vlim = (200, 30000)
    c1 = {'zmdl': 0.3,
          'h1': 0.3,
          'range_km': 1.,
          'wlnmlim': vlim,
          }

    TR = lowtran.userhoriztrans(c1)

    assert np.isnan(TR['transmission']).all()


if __name__ == '__main__':
    pytest.main(['-x', __file__])
