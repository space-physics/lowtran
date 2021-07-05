from pathlib import Path
import subprocess
import pytest
import shutil

R = Path(__file__).parent
MATLAB = shutil.which("matlab")


@pytest.mark.skipif(not MATLAB, reason="Matlab not found")
def test_matlab_api():
    subprocess.check_call(
        [MATLAB, "-batch", "r=runtests; exit(any([r.Failed]))"], cwd=R, timeout=60
    )
