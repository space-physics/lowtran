! Comments by Michael Hirsch, Ph.D. https://www.scivision.co
! p. = page, s. = section of Lowtran7 user manual
! p. 19(28) s. 3.1 begins to describe the Card format
! Remember that:
!  * Fortran is case-insensitive:   XY = xy = Xy = xY
!  * Fortran ignores spaces, punctuation is all that matters.
!  * Fortran 77 can only have program text in columns 7..72
!  * Fortran 77 comments must start in column 1 or >= 7
!  * Fortran 77 columns 2-5 for line numbers, column 6 for continuation symbol
        Program LowtranDemo

        implicit none

!       Python .true.:   Use common blocks (from f2py)
!       Python .false.: Read the Tape5 file (like it's the 1960s again)
        logical, parameter :: Python= .true.

! Model bounds and resolution (can't increase resolution beyond model limits)
      integer, Parameter :: nwl = 51  ! number of wavelengths
      integer, Parameter :: ncol = 63  ! number of columns in output
      real, Parameter :: v1=8333., v2=33333. ! frequency cm^-1 bounds
      ! DV: frequency cm^1 step (lower limit 5. per Card 4 p.40)
      real, parameter :: dv=500. 
! currently unused variables (don't have to be parameter)
      real, parameter :: H2=0. ! only for IEMSCT 1 or 2

! Model configuration, see Lowtran manual p. 21(30) s. 3.2
! Use only one of the following model scenarios

!!! Auroral oval Model e.g. central Alaska !!!
      integer, parameter :: model=5 ! 5: subarctic winter
      integer, parameter :: itype=3 ! 3: vertical or slant path to space
      integer, parameter :: iemsct=0! 0: transmittance model
      real, parameter :: ANGLE=0. ! initial zenith angle; in Python set to camera boresight angle (for our cameras typically magnetic inclination of E-layer ionosphere, e.g. angle is about 12.5 at Poker Flat Research Range)
      
      real, parameter :: h1=0. ! our cameras are at ground level (kilometers)
! in lowtran7.f, I set M1-M6, MDEF all =0 per p.21

!!! Horizontal model (only way to use meterological data) !!!
!      integer, parameter :: model=0 ! 0: Specify meterological data (horiz path)
!      integer, parameter :: itype=1 ! 1: Horizontal, constant pressure path
!      integer, parameter :: iemsct=0! 0: transmittance model
! TODO M1-M6=0 to use JCHAR of card 2C.1 (p.22)

!      real, parameter :: h1 = 0.05  (kilometers altitude of horizontal path)
!      real, parameter :: angle = 0. ! TODO truthfully it's 90. for horizontal path, have to check/test to see if Lowtran uses this value for model=0
!-------- END model config -----------------

!-------- array assignments --------
        Real :: TXPy(nwl,ncol), VPy(nwl), ALAMPy(nwl), TRACEPy(nwl),
     &      UNIFPy(nwl), SUMAPy(nwl)

        call LWTRN7(Python,nwl,V1,V2,DV,
     &  TXPy,VPy,ALAMPy,TRACEPy,UNIFPy, SUMAPy,
     &  MODEL,ITYPE,IEMSCT,
     &  H1,H2,ANGLE)

        print *, 'for wavelengths [nm]:', 1e3*ALAMPy
        print *, 'transmission:',TXPy(1:nwl,9)

        end program

! 
!------------ obsolete ------------
!        Block Data setcards
!        Integer   MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,M4,M5,M6,MDEF
!     &    IRD1,IRD2
!        Real      TBOUND,SALB,H1,H2,ANGLE,RANGE,BETA,RE
!
!        Common /CARD1/MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,TBOUND,SALB
c        Data Model/5/, ITYPE/3/, IEMSCT/0/, M1/0/,M2/0/,M3/0/,NOPRT/0/,
c     &       TBOUND/0/,SALB/0/
c
c        COMMON /CARD1A/ M4,M5,M6,MDEF,        IRD1,IRD2
c        Data M4/0/,M5/0/,M6/0/,MDEF/0/ !No need to init IRD1,IRD2
c
c        COMMON /CARD2/ IHAZE,ISEASN,IVULCN,ICSTL,ICLD,IVSA,VIS,WSS,WHH,
c     &    RAINRT
c        DATA IHAZE/0/  !no need for the rest
c
c        COMMON /CARD3/ H1,H2,ANGLE,RANGE,BETA,RE,LEN
c        Data H1/0./,H2/0./,Angle/0./
c
c       COMMON /CARD4/ V1,V2,DV
c        Data V1/8333./, V2/33333./, DV/500./
c
c        End Block Data setcards
