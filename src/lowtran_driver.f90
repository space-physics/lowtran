program lowtran_driver
!! Michael Hirsch, Ph.D. https://www.scivision.dev
!! p. = page, s. = section of Lowtran7 user manual
!! p. 19(28) s. 3.1 begins to describe the Card format

use, intrinsic:: iso_fortran_env, only: stderr=>error_unit

implicit none

integer :: argc,i
character(256) :: argv
character(:), allocatable :: cmodel
integer :: model,itype,iemsct,im
integer :: iseasn,ird1
integer :: iday,ro,isourc
real :: angle,h1,range,v1,v2,dv
logical :: verbose = .false.

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
if (argc < 3) error stop 'inputs: model_method v1 v2'
call get_command_argument(1,argv)
cmodel = trim(argv)
call get_command_argument(2,argv)
read(argv,*) v1
call get_command_argument(3,argv)
read(argv,*) v2

if (argc > 3) then
  call GET_COMMAND_ARGUMENT(4,argv); if (argv=='-v') verbose=.true.
endif

select case (cmodel)
 case('obs2space')
  ! v1, v2 frequency cm^-1 bounds
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
 case('userhoriz')
!!! Horizontal model (only way to use meterological data) !!!
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
 case('solarirrad')
!!! Solar irradiance !!!
  ! frequency cm^-1 bounds
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
 case('solarrad')
!!! Solar radiance !!!
! frequency cm^-1 bounds
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

call testself()

if (verbose) call printout()

contains

subroutine printout()

select case (cmodel)
 case ('obs2space','userhoriz')
  print *,'wavelength [nm]   transmission'
  do i = 1,nwl
    print '(F7.1,F20.5)', 1e3*ALAMPy(i), TXPy(i,9)
  enddo
 case('solarirrad')
  print *,'wavelength [nm]  transmission   TransIrradiance  ETIrr'
  do i = 1,nwl
    print '(F9.1,F19.5,ES18.5,ES15.3)', 1e3*ALAMPy(i), TXPy(i,9),IrradPy(i,1),irradpy(i,2)
  enddo
 case('solarrad')
  print *,'wavelength [nm]   transmission    Radiance'
  do i = 1,nwl
    print '(F9.1,F20.5,ES18.3)', 1e3*ALAMPy(i), TXPy(i,9),SumVVPy(i)
  enddo
 case default
  stop 'unknown model selection'
end select

end subroutine printout


subroutine testself()

use assert, only: assert_isclose

real, allocatable ::  dat(:,:)
integer :: u, nline, i
character(1024) :: test_file

call get_command_argument(4, test_file, status=i)
if (i/=0) then
  write(stderr,*) 'please specify test data filename'
  error stop 77
endif

select case (cmodel)
 case ('obs2space')
  open(newunit=u, file=test_file,form='formatted',status='old',action='read')
  read(u,*) nline
  read(u,*) ! discard header line
  allocate(dat(nline,2))
  do i = 1,nline
      read(u,*) dat(i,1), dat(i,2)
  end do

  call assert_isclose(TXPy(:,9), dat(:,2),rtol=1e-4, err_msg='obs2space: transmittance error too large')

  print *,'OK: Lowtran obs2pace'
 case ('solarrad')
  open(newunit=u, file=test_file,form='formatted',status='old',action='read')
  read(u,*) nline
  read(u,*) ! discard header line
  allocate(dat(nline,3))
  do i = 1,nline
      read(u,*) dat(i,1), dat(i,2), dat(i,3)
  end do

  call assert_isclose(SumVVPy, dat(:,3), rtol=1e-3, err_msg='solar radiance error too large')

  print *,'OK: Lowtran solar radiance'

 case default
  write(stderr,*) 'sorry, this case is not yet tested: '//cmodel
 end select

end subroutine testself

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
