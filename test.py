#!/usr/bin/env python
from pylowtran7 import golowtran
from numpy.testing import assert_array_almost_equal

T = golowtran(0,0,[500,500.5])

assert_array_almost_equal([500.500488,500],T.index)
assert_array_almost_equal([0.85731113, 0.85709256],T.values.squeeze())