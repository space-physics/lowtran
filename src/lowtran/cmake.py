from __future__ import annotations
import subprocess
import shutil
from pathlib import Path
import os

__all__ = ["build"]


def build(source_dir: Path, build_dir: Path):
    """build with CMake"""
    cmake = shutil.which("cmake")
    if not cmake:
        raise FileNotFoundError("CMake not found.  Try:\n    pip install cmake")

    if os.name == "nt":
        g = os.environ.get("CMAKE_GENERATOR")
        if not g:
            g = shutil.which("ninja")
            if g:
                os.environ["CMAKE_GENERATOR"] = "Ninja"
            else:
                g = shutil.which("mingw32-make")
                if g:
                    os.environ["CMAKE_GENERATOR"] = "MinGW Makefiles"

    # %% Configure
    cmd = [cmake, f"-B{build_dir}", f"-S{source_dir}"]

    subprocess.check_call(cmd)
    # %% Build
    cmd = [cmake, "--build", str(build_dir), "--parallel"]

    subprocess.check_call(cmd)
