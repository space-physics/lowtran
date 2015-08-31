.. image:: https://codeclimate.com/github/scienceopen/lowtran/badges/gpa.svg
   :target: https://codeclimate.com/github/scienceopen/lowtran
   :alt: Code Climate

.. image:: https://travis-ci.org/scienceopen/lowtran.svg?branch=master
    :target: https://travis-ci.org/scienceopen/lowtran
.. image:: https://coveralls.io/repos/scienceopen/lowtran/badge.svg?branch=master
    :target: https://coveralls.io/r/scienceopen/lowtran?branch=master
=======
Lowtran
=======
LOWTRAN7 FORTRAN77 atmospheric absportion extinction model--now in Python!
Updated by Michael Hirsch to compile in modern compilers and to be easily accessible from Python.

:Python API Author: Michael Hirsch
:License: Affero GPLv3+

.. image:: http://blogs.bu.edu/mhirsch/files/2015/04/lowtran.png
    :alt: "Lowtran7 absorption"

Installation
-------------
In Terminal, type::

  git clone --depth 1 https://github.com/scienceopen/lowtran
  conda install --file requirements.txt
  python setup.py develop

Note: ``python setup.py develop`` will not work due to the need to compile the lowtran7.f as part of the setup.py functionality


Example Use:
-------------
From Terminal::

  python pylowtran7.py -a 0 12.5 25

should generate the plot shown above on your screen.


Notes
-----
`LOWTRAN7 User manual <http://www.dtic.mil/dtic/tr/fulltext/u2/a206773.pdf>`_ -- you may refer to this to understand what parameters I've set to default. Currently I don't have any aerosols enabled for example, though it's trivial to add.

Right now a lot of features aren't implemented, please request those you want.


Windows compiler
----------------
(this is handled automatically by setup.py, noted here for debugging)

Yes, even though you're `using a 64-bit compiler <https://scivision.co/f2py-running-fortran-code-in-python-on-windows/>`_::

  f2py --compiler=mingw32 -m lowtran7 -c lowtran7.f

Tested with Gfortran 4.6-5.1.0 and MinGW.

Reference
---------
`Original 1994 Lowtran7 Code <http://www1.ncdc.noaa.gov/pub/data/software/lowtran/>`_
