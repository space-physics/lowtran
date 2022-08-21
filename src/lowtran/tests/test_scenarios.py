import lowtran
from pytest import approx


def test_scatter():
    angles = 60

    c1 = {
        "model": 5,
        "h1": 0,  # of observer
        "angle": angles,  # of observer
        "wlshort": 400,
        "wllong": 700,
        "wlstep": 20,
    }
    # %%
    TR = lowtran.scatter(c1)

    assert TR.wavelength_nm[[0, -1]].values == approx((700.035, 400.0), rel=0.001)
    assert TR["transmission"][0, [0, -1], 0].values == approx([0.876713, 0.488109], rel=1e-4)
    assert TR["pathscatter"][0, [-10, -1], 0].values == approx([0.005474, 0.00518], rel=1e-4)


def test_irradiance():
    angles = 60

    c1 = {
        "model": 5,
        "h1": 0,  # of observer
        "angle": angles,  # of observer
        "wlshort": 200,
        "wllong": 25000,
        "wlstep": 20,
    }
    # %%
    TR = lowtran.irradiance(c1)

    assert [c1["wllong"], c1["wlshort"]] == approx(TR.wavelength_nm[[0, -1]].values)
    assert TR["transmission"][0, [0, 100], 0].values == approx([1.675140e-04, 0.2456177], rel=1e-6)
    assert TR["irradiance"][0, [100, 1000], 0].values == approx([0.00019873, 0.14551014], rel=1e-5)


def test_radiance():
    angles = 60

    c1 = {
        "model": 5,
        "h1": 0,  # of observer
        "angle": angles,  # of observer
        "wlshort": 200,
        "wllong": 25000,
        "wlstep": 20,
    }
    # %%
    TR = lowtran.radiance(c1)

    assert [c1["wllong"], c1["wlshort"]] == approx(TR.wavelength_nm[[0, -1]].values)
    assert TR["transmission"][0, [0, 100], 0].values == approx([1.675140e-04, 0.2456177], rel=1e-6)
    assert TR["radiance"][0, [10, 200], 0].values == approx([3.110389e-04, 3.907411e-10], rel=0.01)


def test_transmittance():
    angles = 60

    c1 = {
        "model": 5,
        "h1": 0,  # of observer
        "angle": angles,  # of observer
        "wlshort": 200,
        "wllong": 30000,
        "wlstep": 20,
    }
    # %%
    TR = lowtran.transmittance(c1)

    assert TR.wavelength_nm[[0, -1]].values == approx((30303.03, 200), rel=0.001)
    assert TR["transmission"][0, [1000, 1200], 0].values == approx([0.726516, 0.527192], rel=0.001)
