#!/usr/bin/env python
import pytest
import lowtran
from numpy.testing import assert_allclose


def test_horiz():
    c1 = {'zmdl': 0.3,
          'h1': 0.3,
          'range_km': 1.,
          'wlshort': 200.,
          'wllong': 30000.,
          'wlstep': 20.,
          }

    TR = lowtran.horiztrans(c1)

    assert_allclose(TR.wavelength_nm[[0, -1]],
                    (30303.03, 200), rtol=0.001)
    assert_allclose(TR['transmission'][0, [1000, 1200], 0],
                    [0.980679, 0.959992], rtol=0.001)


def test_userhoriz():

    c1 = {'zmdl': 0.3,
          'h1': 0.3,
          'range_km': 1.,
          'wlshort': 200.,
          'wllong': 30000.,
          'wlstep': 20.,
          }

    atmos = {'p': 949., 't': 283.8, 'wmol': [93.96, 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0.]}

    c1.update(atmos)

    TR = lowtran.userhoriztrans(c1)

    assert_allclose(TR.wavelength_nm[[0, -1]], (30303.03, 200), rtol=0.001)
    assert_allclose(TR['transmission'][0, [1000, 1200], 0],
                    [0.982909, 0.9645], rtol=0.001)


if __name__ == '__main__':
    pytest.main(['-x', __file__])
