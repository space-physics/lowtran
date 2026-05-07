from __future__ import annotations
import logging
import numpy as np
from typing import Any
from pathlib import Path
import importlib.util
import sysconfig
import os
from types import ModuleType


class LowtranResult:
    """Structured container for Lowtran atmospheric model results.

    Attributes:
        transmission: (time, wavelength, angle) transmission values
        radiance: (time, wavelength, angle) radiance values
        irradiance: (time, wavelength, angle) irradiance values
        pathscatter: (time, wavelength, angle) path scatter values
        time: time coordinates
        wavelength_nm: wavelength coordinates in nm
        angle_deg: angle coordinates in degrees
    """
    __slots__ = ('transmission', 'radiance', 'irradiance', 'pathscatter',
                 'time', 'wavelength_nm', 'angle_deg')

    def __init__(self, transmission: np.ndarray, radiance: np.ndarray,
                 irradiance: np.ndarray, pathscatter: np.ndarray,
                 time: np.ndarray, wavelength_nm: np.ndarray, angle_deg: np.ndarray):
        self.transmission = transmission
        self.radiance = radiance
        self.irradiance = irradiance
        self.pathscatter = pathscatter
        self.time = time
        self.wavelength_nm = wavelength_nm
        self.angle_deg = angle_deg

    def __getitem__(self, key: str) -> np.ndarray:
        """Dictionary-style access for backward compatibility."""
        return getattr(self, key)

    def __repr__(self) -> str:
        return (f"LowtranResult(shape={self.transmission.shape}, "
                f"wavelength=[{self.wavelength_nm[0]:.1f}, {self.wavelength_nm[-1]:.1f}] nm)")

    def squeeze(self):
        """Return a new result with singleton dimensions removed."""
        return LowtranResult(
            transmission=self.transmission.squeeze(),
            radiance=self.radiance.squeeze(),
            irradiance=self.irradiance.squeeze(),
            pathscatter=self.pathscatter.squeeze(),
            time=self.time.squeeze() if self.time.ndim > 0 else self.time,
            wavelength_nm=self.wavelength_nm,
            angle_deg=self.angle_deg.squeeze() if self.angle_deg.ndim > 0 else self.angle_deg
        )


def check() -> ModuleType:
    """Import the lowtran7 extension module.

    The extension should be built with Meson and installed alongside this package.
    """
    lowtran7 = import_f2py_mod("lowtran7")
    return lowtran7


def import_f2py_mod(name: str) -> ModuleType:

    if os.name == "nt":
        # https://github.com/space-physics/lowtran/issues/19
        # code inspired by scipy._distributor_init.py for loading DLLs on Windows

        # First, try to use bundled DLLs (installed alongside the package)
        bundled_libs = Path(__file__).parent / "libs"
        if bundled_libs.is_dir():
            logging.info(f"Adding {bundled_libs} to DLL search path (bundled runtime)")
            os.add_dll_directory(str(bundled_libs))  # type: ignore
        else:
            # Fallback: look for mingw64/bin for gfortran runtime DLLs
            mingw_paths = [
                Path("C:/mingw64/bin"),
                Path("C:/msys64/mingw64/bin"),
                Path("C:/msys64/ucrt64/bin"),
            ]
            for mingw_path in mingw_paths:
                if mingw_path.is_dir():
                    logging.info(f"Adding {mingw_path} to DLL search path for Fortran runtime")
                    os.add_dll_directory(str(mingw_path))  # type: ignore
                    break

    mod_name = name + sysconfig.get_config_var("EXT_SUFFIX")  # type: ignore
    mod_file = Path(__file__).parent / mod_name
    if not mod_file.is_file():
        # Editable installs with meson-python keep the built .pyd in
        # the build tree rather than next to __init__.py. Walk up to
        # the repo root and search ``build/*/src/lowtran/fortran/``
        # before giving up.
        for candidate in Path(__file__).resolve().parents:
            hit = sorted(candidate.glob(f'build/*/src/lowtran/fortran/{mod_name}'))
            if hit:
                mod_file = hit[-1]
                break
        if not mod_file.is_file():
            raise ModuleNotFoundError(mod_file)
    spec = importlib.util.spec_from_file_location(name, mod_file)
    if spec is None:
        raise ModuleNotFoundError(f"{name} not found in {mod_file}")
    mod = importlib.util.module_from_spec(spec)
    if mod is None:
        raise ImportError(f"could not import {name} from {mod_file}")
    spec.loader.exec_module(mod)  # type: ignore

    return mod


def nm2lt7(short_nm: float, long_nm: float, step_cminv: float = 20) -> tuple[float, float, float]:
    """converts wavelength in nm to cm^-1
    minimum meaningful step is 20, but 5 is minimum before crashing lowtran

    short: shortest wavelength e.g. 200 nm
    long: longest wavelength e.g. 30000 nm
    step: step size in cm^-1 e.g. 20

    output in cm^-1
    """
    short = 1e7 / short_nm
    long = 1e7 / long_nm

    N = int(np.ceil((short - long) / step_cminv)) + 1
    # yes, ceil

    return short, long, N


def loopuserdef(c1: dict[str, Any]):
    """
    golowtran() is for scalar parameters only
    (besides vector of wavelength, which Lowtran internally loops over)

    wmol, p, t must all be vector(s) of same length
    """

    wmol = np.atleast_2d(c1["wmol"])
    P = np.atleast_1d(c1["p"])
    T = np.atleast_1d(c1["t"])
    time = np.atleast_1d(c1["time"])

    assert (
        wmol.shape[0] == len(P) == len(T) == len(time)
    ), "WMOL, P, T,time must be vectors of equal length"

    N = len(P)
    # %% accumulate results
    results = []

    for i in range(N):
        c = c1.copy()
        c["wmol"] = wmol[i, :]
        c["p"] = P[i]
        c["t"] = T[i]
        c["time"] = time[i]

        results.append(golowtran(c))

    # Concatenate along time axis
    return LowtranResult(
        transmission=np.concatenate([r.transmission for r in results], axis=0),
        radiance=np.concatenate([r.radiance for r in results], axis=0),
        irradiance=np.concatenate([r.irradiance for r in results], axis=0),
        pathscatter=np.concatenate([r.pathscatter for r in results], axis=0),
        time=time,
        wavelength_nm=results[0].wavelength_nm,
        angle_deg=results[0].angle_deg,
    )


def loopangle(c1: dict[str, Any]):
    """
    loop over "ANGLE"
    """
    angles = np.atleast_1d(c1["angle"])
    results = []

    for a in angles:
        c = c1.copy()
        c["angle"] = a
        results.append(golowtran(c))

    # Concatenate along angle axis
    return LowtranResult(
        transmission=np.concatenate([r.transmission for r in results], axis=2),
        radiance=np.concatenate([r.radiance for r in results], axis=2),
        irradiance=np.concatenate([r.irradiance for r in results], axis=2),
        pathscatter=np.concatenate([r.pathscatter for r in results], axis=2),
        time=results[0].time,
        wavelength_nm=results[0].wavelength_nm,
        angle_deg=angles,
    )


def golowtran(c1: dict[str, Any]):
    """directly run Fortran code"""
    # %% default parameters
    c1.setdefault("time", None)

    defp = ("h1", "h2", "angle", "im", "iseasn", "ird1", "range_km", "zmdl", "p", "t")
    for p in defp:
        c1.setdefault(p, 0)

    c1.setdefault("wmol", [0] * 12)
    # %% input check
    assert len(c1["wmol"]) == 12, "see Lowtran user manual for 12 values of WMOL"
    assert np.isfinite(c1["h1"]), "per Lowtran user manual Table 14, H1 must always be defined"
    # %% setup wavelength
    c1.setdefault("wlstep", 20)
    if c1["wlstep"] < 5:
        logging.critical("minimum resolution 5 cm^-1, specified resolution 20 cm^-1")

    wlshort, wllong, nwl = nm2lt7(c1["wlshort"], c1["wllong"], c1["wlstep"])

    if not 0 < wlshort and wllong <= 50000:
        logging.critical("specified model range 0 <= wavelength [cm^-1] <= 50000")
    # %% invoke lowtran
    """
    Note we invoke case "3a" from table 14, only observer altitude and apparent
    angle are specified
    """

    lowtran7 = check()

    Tx, V, Alam, trace, unif, suma, irrad, sumvv = lowtran7.lwtrn7(
        True,
        nwl,
        wllong,
        wlshort,
        c1["wlstep"],
        c1["model"],
        c1["itype"],
        c1["iemsct"],
        c1["im"],
        c1["iseasn"],
        c1["ird1"],
        c1["zmdl"],
        c1["p"],
        c1["t"],
        c1["wmol"],
        c1["h1"],
        c1["h2"],
        c1["angle"],
        c1["range_km"],
    )

    return LowtranResult(
        transmission=Tx[:, 9][None, :, None],
        radiance=sumvv[None, :, None],
        irradiance=irrad[:, 0][None, :, None],
        pathscatter=irrad[:, 2][None, :, None],
        time=np.array([c1["time"]]),
        wavelength_nm=Alam * 1e3,
        angle_deg=np.array([c1["angle"]]),
    )
