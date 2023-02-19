import subprocess
import shutil
from pathlib import Path
import os
import logging

__all__ = ["build"]


def build(source_dir: Path, build_dir: Path) -> None:
    """build with CMake"""
    cmake = shutil.which("cmake")
    if not cmake:
        raise FileNotFoundError("CMake not found.  Try:\n    pip install cmake")

    gen = os.environ.get("CMAKE_GENERATOR", "")
    if not gen or "Visual Studio" in gen:
        if shutil.which("ninja") or shutil.which("samu") or shutil.which("ninja-build"):
            gen = "Ninja"
        elif os.name == "nt" and shutil.which("mingw32-make"):
            gen = "MinGW Makefiles"
        else:
            gen = "Unix Makefiles"

    # %% Configure
    cmd = [cmake, f"-B{build_dir}", f"-S{source_dir}", f"-G{gen}"]
    logging.info(" ".join(cmd))
    subprocess.check_call(cmd)
    # %% Build
    cmd = [cmake, "--build", str(build_dir), "--parallel"]
    logging.info(" ".join(cmd))
    subprocess.check_call(cmd)
