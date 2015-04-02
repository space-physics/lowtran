        Program LowtranDemo

        IMPLICIT NONE

c       Python .true.:   Use common blocks (from f2py)
c       Python .false.: Read the Tape5 file (like it's the 1960s again)
        Logical, Parameter :: Python= .True. 
        
        Integer, Parameter :: nwl = 51  ! number of wavelengths
        Integer, Parameter :: ncol = 63  ! number of columns in output
        Real :: TXPy(nwl,ncol), VPy(nwl), ALAMPy(nwl), TRACEPy(nwl),
     &      UNIFPy(nwl), SUMAPy(nwl),H1,H2,ANGLE,V1,V2,DV
        Integer MODEL,ITYPE,IEMSCT

        V1=8333.; V2=33333.; DV=500.; MODEL=5; ITYPE=3;IEMSCT=0
        H1=0.; H2=0.; ANGLE=0.

        call LWTRN7(Python,nwl,V1,V2,DV,
     &  TXPy,VPy,ALAMPy,TRACEPy,UNIFPy, SUMAPy,
     &  MODEL,ITYPE,IEMSCT,
     &  H1,H2,ANGLE)

        Write (*,'(A21/,201F7.0)') 'for wavelengths [nm]:', 1e3*ALAMPy
        Write (*,'(A21/,201F7.3)') 'transmission:',TXPy(1:nwl,9)

        End Program
        
        
c        Block Data setcards
c        Integer   MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,M4,M5,M6,MDEF
c     &    IRD1,IRD2
c        Real      TBOUND,SALB,H1,H2,ANGLE,RANGE,BETA,RE
c        
c        Common /CARD1/MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,TBOUND,SALB
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
