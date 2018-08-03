#!/usr/bin/env python
import lowtran
import pytest
from numpy.testing import assert_allclose


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


if __name__ == '__main__':
    pytest.main(['-x', __file__])
