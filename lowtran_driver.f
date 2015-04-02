        Program LowtranDemo

        IMPLICIT NONE

c       Python .true.:   Use common blocks (from f2py)
c       Python .false.: Read the Tape5 file (like it's the 1960s again)
        Logical, Parameter :: Python= .true. 
        
        Integer, Parameter :: nwl = 201  ! number of wavelengths
        Integer, Parameter :: ncol = 63  ! number of columns in output
        Real :: TXPy(nwl,ncol), VPy(nwl), ALAMPy(nwl), TRACEPy(nwl),
     &      UNIFPy(nwl), SUMAPy(nwl)

        call LWTRN7(Python,
     &   nwl,TXPy,VPy,ALAMPy,TRACEPy,UNIFPy, SUMAPy)

        Write (*,'(A21/,201F7.0)') 'for wavelengths [nm]:', 1e3*ALAMPy
        Write (*,'(A21/,201F7.3)') 'transmission:',TXPy(1:nwl,9)

        End Program
        
        Block Data setcards
        Integer   MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,M4,M5,M6,MDEF
     &    IRD1,IRD2
        Real      TBOUND,SALB,H1,H2,ANGLE,RANGE,BETA,RE
        
        Common /CARD1/MODEL,ITYPE,IEMSCT,M1,M2,M3,IM,NOPRT,TBOUND,SALB
        Data Model/5/, ITYPE/3/, IEMSCT/0/, M1/0/,M2/0/,M3/0/,NOPRT/0/,
     &       TBOUND/0/,SALB/0/

        COMMON /CARD1A/ M4,M5,M6,MDEF,        IRD1,IRD2
        Data M4/0/,M5/0/,M6/0/,MDEF/0/ !No need to init IRD1,IRD2
        
        COMMON /CARD2/ IHAZE,ISEASN,IVULCN,ICSTL,ICLD,IVSA,VIS,WSS,WHH,
     &    RAINRT
        DATA IHAZE/0/  !no need for the rest
        
        COMMON /CARD3/ H1,H2,ANGLE,RANGE,BETA,RE,LEN
        Data H1/0./,H2/0./,Angle/0./
        
        COMMON /CARD4/ V1,V2,DV
        Data V1/10000./, V2/20000./, DV/50./
        
        End Block Data setcards
