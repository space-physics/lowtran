[![Code Climate](https://codeclimate.com/github/scienceopen/lowtran/badges/gpa.svg)](https://codeclimate.com/github/scienceopen/lowtran)
[![Build Status](https://travis-ci.org/scienceopen/lowtran.svg?branch=master)](https://travis-ci.org/scienceopen/lowtran)
[![Coverage Status](https://coveralls.io/repos/scienceopen/lowtran/badge.svg?branch=master)](https://coveralls.io/r/scienceopen/lowtran?branch=master)

# lowtran
LOWTRAN7 FORTRAN77 atmospheric absportion extinction model--now in Python!

[LOWTRAN7 User manual](http://www.dtic.mil/dtic/tr/fulltext/u2/a206773.pdf) -- you may refer to this to understand what parameters I've set to default. Currently I don't have any aerosols enabled for example, though it's trivial to add.

Updated by Michael Hirsch to compile in modern compilers and to be easily accessible from Python.

Right now a lot of features aren't implemented, please request those you want.

![Lowtran7 example output](http://blogs.bu.edu/mhirsch/files/2015/04/lowtran.png "Lowtran7 absorption")

Linux compile:
-------------------
```
make -f Makefile.f2py
```

Windows compile:
-----------------
Yes, even though you're[ using a 64-bit compiler](http://blogs.bu.edu/mhirsch/2015/04/f2py-running-fortran-code-in-python-on-windows/).
```
f2py --compiler=mingw32 -m lowtran7 -c lowtran7.f
```

Prereqs:
--------
```
pip install -r requirements.txt
```

Tested with Gfortran 4.6-4.9.2 and MinGW. 
