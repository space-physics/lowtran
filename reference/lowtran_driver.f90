! Comments by Michael Hirsch, Ph.D. https://www.scivision.co
! p. = page, s. = section of Lowtran7 user manual
! p. 19(28) s. 3.1 begins to describe the Card format

Program LowtranDemo

implicit none

integer :: imodel=0,argc,i
character(8) :: argv
integer :: model,itype,iemsct,im
integer :: iseasn,ird1
integer :: iday,ro,isourc
real :: angle,h1,range,v1,v2,dv

!     Python .true.:   Use common blocks (from f2py)
!     Python .false.: Read the Tape5 file (like it's the 1960s again)
logical, parameter :: Python= .true.

! Model bounds and resolution (can't increase resolution beyond model limits)
integer, Parameter :: nwl = 51  ! number of wavelengths
integer, Parameter :: ncol = 63  ! number of columns in output
! currently unused variables (don't have to be parameter)
real, parameter :: H2=0. ! only used for IEMSCT 1 or 2

! these are ignored for auroral case
integer, parameter ::  ml=1 !1: one level of horiz atmosphere (as per lowtran manual for this sim)
real :: ZMDL(ml),P(ml),T(ml), WMOL(12)

real :: TXPy(nwl,ncol), VPy(nwl), ALAMPy(nwl), TRACEPy(nwl), UNIFPy(nwl), SUMAPy(nwl), IrradPy(nwl,3), SumVVPy(nwl)

! Model configuration, see Lowtran manual p. 21(30) s. 3.2

! Command line selection

argc = command_argument_count()
do i=1,argc
  select case (i)
   case(1)
    call GET_COMMAND_ARGUMENT(i,argv); read(argv,'(I1)') imodel
   case default
    error stop 'more arguments than expected'
  end select
enddo

!      print*,imodel
 
select case (imodel)
 case(0)
  v1=8333.; v2=33333. ! frequency cm^-1 bounds
  dv=500. ! DV: frequency cm^1 step (lower limit 5. per Card 4 p.40)

!!! Auroral oval Model e.g. central Alaska !!!
  model =5 ! 5: subarctic winter
  itype=3 ! 3: vertical or slant path to space
  iemsct=0! 0: transmittance model
  im=0 !0: normal operation (no custom user conditions)

  iseasn=0 ! 0: default for this type redirects to 1: spring/summer
  IRD1=0 !0: not used

  ! ZMDL, P, T not used -- don't care about uninitialized value

  ANGLE=0. ! initial zenith angle; in Python set to camera boresight angle (for our cameras typically magnetic inclination of E-layer ionosphere, e.g. angle is about 12.5 at Poker Flat Research Range)
  h1=0. ! our cameras are at ground level (kilometers)
! in lowtran7.f, I set M1-M6, MDEF all =0 per p.21
  range=0. ! not used
 case(1)
!!! Horizontal model (only way to use meterological data) !!!
  v1=714.2857; v2=1250. ! frequency cm^-1 bounds
  dv=13.  ! DV: frequency cm^1 step (lower limit 5. per Card 4 p.40)

  model=0 ! 0: Specify meterological data (horiz path)
  itype=1 ! 1: Horizontal, constant pressure path
  iemsct=0 ! 0: transmittance model
  im=1 ! 1: horizontal path: p.42 of manual

  iseasn=0 !0: default for this type redirects to 1: spring/summer
  ird1=1 !1: use card 2C2

! TODO M1-M6=0 to use JCHAR of card 2C.1 (p.22)
  h1 = 0.05  !(kilometers altitude of horizontal path)
  angle = 0. ! TODO truthfully it's 90. for horizontal path, have to check/test to see if Lowtran uses this value for model=0 horiz. path.
  range=h1
  zmdl(1) = h1
  P(1) = 949 ! millibar
  T(1) = 283.8 ! Kelvin
  WMOL = [93.96,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.]
 case(2)
!!! Solar irradiance !!!
  v1=714.2857; v2=1250. ! frequency cm^-1 bounds
  dv=13.  ! DV: frequency cm^1 step (lower limit 5. per Card 4 p.40)

  model = 2 ! 2: midlatitude summer, 3: mid latitude winter
  itype = 3 ! 3: slant to space (required by iemsct=3)
  iemsct = 3 !3: directly transmitted solar irradiance, 2: scattered radiance,...
  im=0

  iseasn=0
  ird1=0

  h1 = 0.05
  angle = 0. ! arbitrary, zenith angle
  iday = 0 ! 0: use mean earth-sun distance
  ro = 0 ! 0: use model earth radius
  isourc = 0 ! 0: sun, 1: moon

  ! Cards 3A, 3B not used for irradiance
 case(3)
!!! Solar radiance !!!
  v1=714.2857; v2=1250. ! frequency cm^-1 bounds
  dv=13.  ! DV: frequency cm^1 step (lower limit 5. per Card 4 p.40)

  model=0 ! 0: Specify meterological data (horiz path)
  itype=1 ! 1: Horizontal, constant pressure path
  iemsct=1 ! 1: single radiance model
  im=1 ! 1: horizontal path: p.42 of manual

  iseasn=0 !0: default for this type redirects to 1: spring/summer
  ird1=1 !1: use card 2C2 (where atmospheric measurments are input for Model=0

! TODO M1-M6=0 to use JCHAR of card 2C.1 (p.22)
  h1 = 0.05  !(kilometers altitude of horizontal path)
  angle = 0. ! TODO truthfully it's 90. for horizontal path, have to check/test to see if Lowtran uses this value for model=0 horiz. path.
  range=h1
  zmdl(1) = h1
  P(1) = 949 ! millibar
  T(1) = 283.8 ! Kelvin
  WMOL = [93.96,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0.]
 case default
  error stop 'unknown model selection'
end select
!-------- END model config -----------------
!-------- END command line parse ------------

call LWTRN7(Python,nwl,V1,V2,DV,TXPy,VPy,ALAMPy,TRACEPy,UNIFPy, SUMAPy,irradpy,sumVVPy, &
  MODEL,ITYPE,IEMSCT,IM, ISEASN,ML,IRD1, ZMDL,P,T,WMOL, H1,H2,ANGLE,range)
!--- friendly output
  
select case (imodel)
 case (0,1)
  print *,'wavelength [nm]   transmission' 
  do i = 1,nwl
    print '(F7.1,F20.5)', 1e3*ALAMPy(i), TXPy(i,9)
  enddo
 case(2)
  print *,'wavelength [nm]  transmission   TransIrradiance  ETIrr'
  do i = 1,nwl
    print '(F7.1,F19.5,ES18.5,ES15.3)', 1e3*ALAMPy(i), TXPy(i,9),IrradPy(i,1),irradpy(i,2)
  enddo
 case(3)
  print *,'wavelength [nm]   transmission    Radiance'
  do i = 1,nwl
    print '(F7.1,F20.5,ES18.3)', 1e3*ALAMPy(i), TXPy(i,9),SumVVPy(i)
  enddo
 case default
  print *,'imodel',imodel
  error stop 'unknown imodel'
end select

end program

! 
!------------ obsolete ------------
!        Block Data setcards
!        Integer   MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,M4,M5,M6,MDEF
!     &    IRD1,IRD2
!        Real      TBOUND,SALB,H1,H2,ANGLE,RANGE,BETA,RE
!
!        Common /CARD1/MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,TBOUND,SALB
!        Data Model/5/, ITYPE/3/, IEMSCT/0/, M1/0/,M2/0/,M3/0/,NOPRT/0/,
!     &       TBOUND/0/,SALB/0/
!
!        COMMON /CARD1A/ M4,M5,M6,MDEF,        IRD1,IRD2
!        Data M4/0/,M5/0/,M6/0/,MDEF/0/ !No need to init IRD1,IRD2
!
!        COMMON /CARD2/ IHAZE,ISEASN,IVULCN,ICSTL,ICLD,IVSA,VIS,WSS,WHH,
!     &    RAINRT
!        DATA IHAZE/0/  !no need for the rest
!
!        COMMON /CARD3/ H1,H2,ANGLE,RANGE,BETA,RE,LEN
!        Data H1/0./,H2/0./,Angle/0./
!
!       COMMON /CARD4/ V1,V2,DV
!        Data V1/8333./, V2/33333./, DV/500./
!
!        End Block Data setcards
