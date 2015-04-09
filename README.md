# lowtran
LOWTRAN7 FORTRAN77 atmospheric absportion extinction model--now in Python!

[LOWTRAN7 User manual](www.dtic.mil/dtic/tr/fulltext/u2/a206773.pdf) -- you may refer to this to understand what parameters I've set to default. Currently I don't have any aerosols enabled for example, though it's trivial to add.

Updated by Michael Hirsch to compile in modern compilers and to be easily accessible from Python.

Right now a lot of features aren't implemented, please request those you want.

![Lowtran7 example output](http://blogs.bu.edu/mhirsch/files/2015/04/lowtran.png "Lowtran7 absorption")

Linux compile:
-------------------
```
f2py3 -m lowtran7 -c lowtran7.f
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
