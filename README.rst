.. image:: https://travis-ci.org/scienceopen/lowtran.svg?branch=master
    :target: https://travis-ci.org/scienceopen/lowtran
.. image:: https://codeclimate.com/github/scienceopen/lowtran/badges/gpa.svg
   :target: https://codeclimate.com/github/scienceopen/lowtran
   :alt: Code Climate
.. image:: https://coveralls.io/repos/scienceopen/lowtran/badge.svg?branch=master
    :target: https://coveralls.io/r/scienceopen/lowtran?branch=master
=======
Lowtran
=======
LOWTRAN7 atmospheric absportion extinction model.
Updated by Michael Hirsch to be platform independent and easily accessible from Python.

:Python API Author: Michael Hirsch
:License: MIT

.. contents::

.. image:: http://blogs.bu.edu/mhirsch/files/2015/04/lowtran.png
    :alt: "Lowtran7 absorption"
    :scale: 25%



Installation
============
::

  python setup.py develop

Examples
========

Python
------
::

  python DemoLowtran.py -a 0 12.5 25

should generate the plot shown above on your screen.

Fortran (optional)
-------------------
::

    cd bin
    cmake ..
    make
    ./testlowtran

should generate `this text output <https://gist.github.com/scienceopen/89ef2060d8f15b0a60914d13a61e33ab>`_.

Notes
-----
`LOWTRAN7 User manual <http://www.dtic.mil/dtic/tr/fulltext/u2/a206773.pdf>`_ -- you may refer to this to understand what parameters I've set to default. Currently I don't have any aerosols enabled for example, though it's trivial to add.

Right now a lot of features aren't implemented, please request those you want.


Windows f2py
----------------
(this is handled automatically by setup.py, noted here for debugging)

Yes, even though you're `using a 64-bit compiler <https://scivision.co/f2py-running-fortran-code-in-python-on-windows/>`_::

  f2py --compiler=mingw32 -m lowtran7 -c lowtran7.f

Tested with Gfortran 4.6-5.3 and MinGW.

Reference
---------
`Original 1994 Lowtran7 Code <http://www1.ncdc.noaa.gov/pub/data/software/lowtran/>`_
