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


def test_scatter():
    vlim = (400, 700)
    angles = 60

    c1 = {'model': 5,
          'h1': 0,  # of observer
          'angle': angles,  # of observer
          'wlnmlim': vlim,
          }
# %%
    TR = lowtran.scatter(c1)

    assert_allclose(TR.wavelength_nm[[0, -1]], (700.035, 400.), rtol=1e-6)
    assert_allclose(TR['transmission'][0, [0, -1], 0],
                    [0.876713, 0.4884], rtol=1e-6)
    assert_allclose(TR['pathscatter'][0, [-10, -1], 0],
                    [0.005259, 0.005171], rtol=1e-4)


def test_irradiance():
    vlim = (200, 25000)
    angles = 60

    c1 = {'model': 5,
          'h1': 0,  # of observer
          'angle': angles,  # of observer
          'wlnmlim': vlim,
          }
# %%
    TR = lowtran.irradiance(c1)

    assert_allclose(vlim[::-1], TR.wavelength_nm[[0, -1]])
    assert_allclose(TR['transmission'][0, [0, 100], 0],
                    [1.675140e-04, 0.9388928], rtol=1e-6)
    assert_allclose(TR['irradiance'][0, [100, 1000], 0],
                    [1.489084e-05, 3.904406e-05])


def test_radiance():
    vlim = (200, 25000)
    angles = 60

    c1 = {'model': 5,
          'h1': 0,  # of observer
          'angle': angles,  # of observer
          'wlnmlim': vlim,
          }
# %%
    TR = lowtran.radiance(c1)

    assert_allclose(vlim[::-1], TR.wavelength_nm[[0, -1]])
    assert_allclose(TR['transmission'][0, [0, 100], 0],
                    [1.675140e-04, 0.9388928], rtol=1e-6)
    assert_allclose(TR['radiance'][0, [10, 200], 0],
                    [0.000191, 0.000261], rtol=0.01)


def test_transmittance():
    vlim = (200, 30000)
    angles = 60

    c1 = {'model': 5,
          'h1': 0,  # of observer
          'angle': angles,  # of observer
          'wlnmlim': vlim,
          }
# %%
    TR = lowtran.transmittance(c1)

    assert_allclose(TR.wavelength_nm[[0, -1]],
                    (30303.03, 200), rtol=1e-6)
    assert_allclose(TR['transmission'][0, [1000, 1200], 0],
                    [0.002074, 0.924557], rtol=0.001)


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


def test_userfail():
    vlim = (200, 30000)
    c1 = {'zmdl': 0.3,
          'h1': 0.3,
          'range_km': 1.,
          'wlnmlim': vlim,
          }

    TR = lowtran.userhoriztrans(c1)

    assert np.isnan(TR['transmission']).all()


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
    pytest.main()
