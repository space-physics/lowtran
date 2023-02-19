import subprocess
import shutil
from pathlib import Path
import os

__all__ = ["build"]


def build(source_dir: Path, build_dir: Path) -> None:
    """build with CMake"""
    cmake = shutil.which("cmake")
    if not cmake:
        raise FileNotFoundError("CMake not found.  Try:\n    pip install cmake")

    env = os.environ.copy()
    if os.name == "nt" and "CMAKE_GENERATOR" not in env:
        if shutil.which("ninja"):
            env["CMAKE_GENERATOR"] = "Ninja"
        elif shutil.which("mingw32-make"):
            env["CMAKE_GENERATOR"] = "MinGW Makefiles"

    # %% Configure
    cmd = [cmake, f"-B{build_dir}", f"-S{source_dir}"]

    subprocess.check_call(cmd)
    # %% Build
    cmd = [cmake, "--build", str(build_dir), "--parallel"]

    subprocess.check_call(cmd, env=env)
