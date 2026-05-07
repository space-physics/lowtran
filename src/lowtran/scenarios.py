from __future__ import annotations
from pathlib import Path
from pandas import read_csv
from dateutil.parser import parse
from typing import Any
import numpy as np

from .base import loopangle, loopuserdef, golowtran


def scatter(c1: dict[str, Any]):
    # %% low-level Lowtran configuration for this scenario, don't change
    c1.update(
        {
            "itype": 3,  # 3: observer to space
            "iemsct": 2,  # 2: radiance model
        }
    )
    # %% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    return loopangle(c1)


def irradiance(c1: dict[str, Any]):
    c1.update(
        {
            "itype": 3,  # 3: observer to space
            "iemsct": 3,  # 3: solar irradiance
        }
    )

    return loopangle(c1)


def radiance(c1: dict[str, Any]):

    c1.update(
        {
            "itype": 3,  # 3: observer to space
            "iemsct": 1,  # 1: thermal radiance model  2: radiance model
        }
    )
    # %% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    return loopangle(c1)


def transmittance(c1: dict[str, Any]):

    c1.update(
        {
            "itype": 3,  # 3: observer to space
            "iemsct": 0,  # 0: transmittance
        }
    )

    return loopangle(c1)


def horizrad(infn: Path, outfn: Path, c1: dict[str, Any]):
    """
    read CSV, simulate, write, plot
    """
    if infn is not None:
        infn = Path(infn).expanduser()

        if infn.suffix == ".h5":
            raise NotImplementedError("HDF5 loading is no longer supported. Use numpy .npz format instead.")

    c1.update(
        {
            "model": 0,  # 0: user meterological data
            "itype": 1,  # 1: horizontal path
            "iemsct": 1,  # 1: radiance model
            "im": 1,  # 1: for horizontal path (see Lowtran manual p.42)
            "ird1": 1,  # 1: use card 2C2)
        }
    )
    # %% read csv file
    if not infn:  # demo mode
        c1["p"] = [949.0, 959.0]
        c1["t"] = [283.8, 285.0]
        c1["wmol"] = [
            [93.96, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            [93.96, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        ]
        c1["time"] = [parse("2017-04-05T12"), parse("2017-04-05T18")]
    else:  # read csv, normal case
        PTdata = read_csv(infn)
        c1["p"] = PTdata["p"]
        c1["t"] = PTdata["Ta"]
        c1["wmol"] = np.zeros((PTdata.shape[0], 12))
        c1["wmol"][:, 0] = PTdata["RH"]
        c1["time"] = [parse(t) for t in PTdata["time"]]
    # %% TR is 3-D array with axes: time, wavelength, and [transmission,radiance]
    TR = loopuserdef(c1)

    return TR


def horiztrans(c1: dict[str, Any]):

    c1.update(
        {
            "model": 5,  # 5: subartic winter
            "itype": 1,  # 1: horizontal path
            "iemsct": 0,  # 0: transmittance model
            "im": 0,  # 1: for user-defined atmosphere on horizontal path (see Lowtran manual p.42)
            "ird1": 0,  # 1: use card 2C2
        }
    )

    return golowtran(c1)


def userhoriztrans(c1: dict[str, Any]):

    c1.update(
        {
            "model": 0,  # 0: user meterological data
            "itype": 1,  # 1: horizontal path
            "iemsct": 0,  # 0: transmittance model
            "im": 1,  # 1: for user-defined atmosphere on horizontal path (see Lowtran manual p.42)
            "ird1": 1,  # 1: use card 2C2
        }
    )

    return golowtran(c1)
