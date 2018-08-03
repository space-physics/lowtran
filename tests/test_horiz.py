#!/usr/bin/env python
import pytest
import lowtran
from numpy.testing import assert_allclose


def test_horiz():
    vlim = (200, 30000)
    c1 = {'zmdl': 0.3,
          'h1': 0.3,
          'range_km': 1.,
          'wlnmlim': vlim,
          }

    TR = lowtran.horiztrans(c1)

    assert_allclose(TR.wavelength_nm[[0, -1]],
                    (30303.03, 200), rtol=1e-6)
    assert_allclose(TR['transmission'][0, [1000, 1200], 0],
                    [0.118356, 0.980377], rtol=0.001)


def test_userhoriz():
    vlim = (200, 30000)

    c1 = {'zmdl': 0.3,
          'h1': 0.3,
          'range_km': 1.,
          'wlnmlim': vlim,
          }

    atmos = {'p': 949., 't': 283.8, 'wmol': [93.96, 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]}

    c1.update(atmos)

    TR = lowtran.userhoriztrans(c1)

    assert_allclose(TR.wavelength_nm[[0, -1]],
                    (30303.03, 200), rtol=1e-6)
    assert_allclose(TR['transmission'][0, [1000, 1200], 0],
                    [3.395577e-04, 9.921151e-01], rtol=0.001)


if __name__ == '__main__':
    pytest.main(['-x', __file__])
