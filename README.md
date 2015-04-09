# lowtran
LOWTRAN FORTRAN77 atmospheric absportion extinction model--now in Python!

Updated by Michael Hirsch to compile in modern compilers and to be easily accessible from Python.

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
