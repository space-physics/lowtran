from __future__ import annotations
import logging
import xarray
import numpy as np
from typing import Any
import importlib
import sysconfig
import os
import sys
from pathlib import Path
from types import ModuleType


def check() -> ModuleType:
    """Ensure the compiled lowtran7 extension is available.

    With scikit-build-core, the extension is built at install time and shipped in the wheel.
    If it's missing, prompt the user to install the package (e.g., `pip install .`).
    """

    try:
        return import_f2py_mod("lowtran7")
    except ImportError as e:
        raise ImportError(
            "lowtran7 extension not found. Please install the package so the Fortran "
            "extension is built (e.g., `pip install .` or `pip install lowtran`)."
        ) from e


def import_f2py_mod(name: str) -> ModuleType:
    lib_name = name + sysconfig.get_config_var("EXT_SUFFIX")
    lib_path = importlib.resources.files(__package__) / lib_name

    if not lib_path.is_file():
        # Assume editable install: navigate up to find the build directory
        src_dir = Path(__file__).parent
        project_root = src_dir.parent.parent  # Assuming src/lowtran structure

        # scikit-build-core build directory pattern
        build_base = project_root / "build"

        if build_base.exists():
            # Recursively search for the library file
            matches = list(build_base.rglob(lib_name))
            if matches:
                lib_path = matches[0]  # Use the first match

    if not lib_path.is_file():
        raise ModuleNotFoundError(f"Module not found: {lib_path}")

    # On Windows, add DLL search directories to fix loading issues
    dll_dirs: list[Any] = []
    if sys.platform == "win32" and hasattr(os, 'add_dll_directory'):
        # Add common locations where your dependencies might be, i.e., system PATH and module dir
        search_paths = os.environ.get('PATH', '').split(os.pathsep)
        search_paths.append(os.fspath(lib_path.parent))

        for path in search_paths:
            try:
                dll_dirs.append(os.add_dll_directory(path))
            except OSError:
                pass
    try:
        # Load the module from file path
        spec = importlib.util.spec_from_file_location(name, lib_path)
        if spec is None or spec.loader is None:
            raise ImportError(f"Cannot load module from {lib_path}")

        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        return mod
    finally:
        # Clean up DLL directories
        for dll_dir in dll_dirs:
            dll_dir.close()


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
    # %% 3-D array indexed by metadata
    TR = xarray.Dataset(coords={"time": time, "wavelength_nm": None, "angle_deg": None})

    for i in range(N):
        c = c1.copy()
        c["wmol"] = wmol[i, :]
        c["p"] = P[i]
        c["t"] = T[i]
        c["time"] = time[i]

        TR = TR.merge(golowtran(c))

    #   TR = TR.sort_index(axis=0) # put times in order, sometimes CSV is not monotonic in time.

    return TR


def loopangle(c1: dict[str, Any]):
    """
    loop over "ANGLE"
    """
    angles = np.atleast_1d(c1["angle"])
    TR = xarray.Dataset(coords={"wavelength_nm": None, "angle_deg": angles})

    for a in angles:
        c = c1.copy()
        c["angle"] = a
        TR = TR.merge(golowtran(c))

    return TR


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

    dims = ("time", "wavelength_nm", "angle_deg")
    TR = xarray.Dataset(
        {
            "transmission": (dims, Tx[:, 9][None, :, None]),
            "radiance": (dims, sumvv[None, :, None]),
            "irradiance": (dims, irrad[:, 0][None, :, None]),
            "pathscatter": (dims, irrad[:, 2][None, :, None]),
        },
        coords={
            "time": [c1["time"]],
            "wavelength_nm": Alam * 1e3,
            "angle_deg": [c1["angle"]],
        },
    )

    return TR
