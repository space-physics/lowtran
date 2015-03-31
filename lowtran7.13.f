      PROGRAM SCAN                                                      SCA  100                                                         
CCC                                                                     SCA  110                                                         
CCC                                                                     SCA  120                                                         
CCC   *******  LOWTRAN 7  SCANNING FUNCTION                             SCA  130                                                         
CCC                                                                     SCA  140                                                         
CCC   PROGRAM WRITTEN BY                                                SCA  150                                                         
CCC                        FRANCIS X. KNEIZYS     OPI/AFGL              SCA  160                                                         
CCC                        JAMES H. CHETWYND JR.  OPI/AFGL              SCA  170                                                         
CCC                        LEONARD W. ABREU       OPI/AFGL              SCA  180                                                         
CCC                        ERIC P. SHETTLE        OPA/AFGL              SCA  190                                                         
CCC                                                                     SCA  200                                                         
CCC                                                                     SCA  210                                                         
CCC                                                                     SCA  220                                                         
      DIMENSION Y(10000),AA(20),VAR(11)                                 SCA  230                                                         
      OPEN(5,FILE='TAPE5',STATUS='UNKNOWN')                             SCA  240                                                         
      OPEN(6,FILE='TAPE6',STATUS='UNKNOWN')                             SCA  250                                                         
      OPEN(7,FILE='TAPE7',STATUS='UNKNOWN')                             SCA  260                                                         
      OPEN(9,FILE='TAPE9',STATUS='UNKNOWN')                             SCA  270                                                         
CC                                                                      SCA  280                                                         
CC   V1O  FIRST OUTPUT FREQ  CM-1                                       SCA  290                                                         
CC   V2O  LAST  OUTPUT FREQ  CM-1                                       SCA  300                                                         
CC   HWHM  HALF WIDTH AT HALF MAX                                       SCA  310                                                         
CC   IHW   FLAG  0  HALF WIDTH AT HALF MAX  (CM-1)                      SCA  320                                                         
CC   IHW   FLAG  1  HALF WIDTH AT HALF MAX  (MICRONS)                   SCA  330                                                         
CC   [NOTE SET HWVB TO ZERO FOR FIXED HALF WIDTH]                       SCA  340                                                         
CC   NUMFIL                                                             SCA  350                                                         
CC         =  0 USES NEXT FILE                                          SCA  360                                                         
CC         GT 0 USES FILE OF DATA SPECIFIED BY NUMFIL                   SCA  370                                                         
CC   IVAR                                                               SCA  380                                                         
CC   IEMSCT = 0  IVAR 0 TRANSMISSION                                    SCA  390                                                         
CC               IVAR 1 TO 10 H2O TO AER-HYD COMPOIENT TRANSMISSION     SCA  400                                                         
CC                                                                      SCA  410                                                         
CC   IEMSCT = 1  IVAR 0 TRANSMISSION                                    SCA  420                                                         
CC               IVAR 1 ATMOSPHERIC RADIANCE                            SCA  430                                                         
CC                                                                      SCA  440                                                         
CC   IEMSCT = 2  IVAR 0 TRANSMISSION                                    SCA  450                                                         
CC               IVAR 1 ATMOSPHERIC      RADIANCE                       SCA  460                                                         
CC               IVAR 2 PATH SCATTERED   RADIANCE                       SCA  470                                                         
CC               IVAR 3 SINGLE SCATTERED RADIANCE                       SCA  480                                                         
CC               IVAR 4 GROUND REFLECTED RADIANCE                       SCA  490                                                         
CC               IVAR 5 DIRECT           RADIANCE                       SCA  500                                                         
CC               IVAR 6 TOTAL            RADIANCE                       SCA  510                                                         
CC                                                                      SCA  520                                                         
CC               WHEN IMULT = 0 ; IVAR = 2  SAME AS IVAR = 3            SCA  530                                                         
CC               WHEN IMULT = 0 ; IVAR = 4  SAME AS IVAR = 5            SCA  540                                                         
CC                                                                      SCA  550                                                         
CC   IEMSCT = 3  IVAR 0 TRANSMISSION                                    SCA  560                                                         
CC               IVAR 1 TRANMITTED  RADIANCE                            SCA  570                                                         
CC               IVAR 2 SOLAR       RADIANCE                            SCA  580                                                         
CCC                                                                     SCA  590                                                         
      HWVB = 0.                                                         SCA  600                                                         
      READ (5,900) V1O,V2O,HWHM,IHW,NUMFIL,IVAR                         SCA  610                                                         
      WRITE(6,910) V1O,V2O,HWHM,IHW,NUMFIL,IVAR                         SCA  620                                                         
900   FORMAT(3F10.0,3I5)                                                SCA  630                                                         
910   FORMAT(//'  V1O = ',F10.0,' V2O =',F10.0,' HWHM = ',F10.3,        SCA  640                                                         
     X   ' IHW  = ',I5,/,'  NUMFIL = ',I5,' IVAR = ',I5)                SCA  650                                                         
      IF(IHW  .GT. 0 ) THEN                                             SCA  660                                                         
         HWVB = HWHM                                                    SCA  670                                                         
         HWHM =  1.0E-4 * (V1O**2) * HWVB                               SCA  680                                                         
         HWH2 =  1.0E-4 * (V2O**2) * HWVB                               SCA  690                                                         
         PRINT*,' HWHM HWH2 ',HWHM,HWH2                                 SCA  700                                                         
      ENDIF                                                             SCA  710                                                         
      DVO = HWHM/ 2.                                                    SCA  720                                                         
      IF(DVO . LE. 0.) THEN                                             SCA  730                                                         
         PRINT *,'  DVO  ',DVO                                          SCA  740                                                         
         STOP                                                           SCA  750                                                         
      ENDIF                                                             SCA  760                                                         
      IF(DVO .LT. 5.) DVO = 5.                                          SCA  770                                                         
CC                                                                      SCA  780                                                         
      IF(NUMFIL.LT.1) GO TO 12                                          SCA  790                                                         
      REWIND 7                                                          SCA  800                                                         
      NNF=1                                                             SCA  810                                                         
      IF(NUMFIL.EQ.NNF) GO TO 12                                        SCA  820                                                         
8     DO 9 I=1,11                                                       SCA  830                                                         
      READ (7,101) DUMMY                                                SCA  840                                                         
9     CONTINUE                                                          SCA  850                                                         
101   FORMAT(A1)                                                        SCA  860                                                         
11    READ (7,99) DUM                                                   SCA  870                                                         
99    FORMAT(F7.0)                                                      SCA  880                                                         
      IF(DUM.NE.-9999.) GO TO 11                                        SCA  890                                                         
      NNF=NNF+1                                                         SCA  900                                                         
      IF(NUMFIL.EQ.NNF) GO TO 12                                        SCA  910                                                         
      GO TO 8                                                           SCA  920                                                         
12    CONTINUE                                                          SCA  930                                                         
CCC                                                                     SCA  940                                                         
      READ(7,1110)  MODEL,ITYPE,IEMSCT,IMULT,M1,M2,M3,                  SCA  950                                                         
     1 M4,M5,M6,MDEF,IM,NOPRT,TBOUND,SALB                               SCA  960                                                         
1110  FORMAT(13I5,F8.4,F7.2)                                            SCA  970                                                         
      WRITE(  9,1110)MODEL,ITYPE,IEMSCT,IMULT,M1,M2,M3,                 SCA  980                                                         
     1 M4,M5,M6,MDEF,IM,NOPRT,TBOUND,SALB                               SCA  990                                                         
      DO 14 I = 1,10                                                    SCA 1000                                                         
      IF(I.EQ.8) THEN                                                   SCA 1010                                                         
           READ (7,1400) V1I,V2I,DVI                                    SCA 1020                                                         
           WRITE(9,1400) V1I,V2I,DVI                                    SCA 1030                                                         
      ELSE                                                              SCA 1040                                                         
           READ (7,920)    AA                                           SCA 1050                                                         
           WRITE(9,920)    AA                                           SCA 1060                                                         
      ENDIF                                                             SCA 1070                                                         
14    CONTINUE                                                          SCA 1080                                                         
920   FORMAT(20A4)                                                      SCA 1090                                                         
1400  FORMAT(3F10.3)                                                    SCA 1100                                                         
CC                                                                      SCA 1110                                                         
      IF(IEMSCT . EQ. 0) THEN                                           SCA 1120                                                         
         NVAR = 11                                                      SCA 1130                                                         
      ENDIF                                                             SCA 1140                                                         
      IF(IEMSCT . EQ. 1) THEN                                           SCA 1150                                                         
         NVAR = 2                                                       SCA 1160                                                         
      ENDIF                                                             SCA 1170                                                         
      IF(IEMSCT . EQ. 2) THEN                                           SCA 1180                                                         
         NVAR = 9                                                       SCA 1190                                                         
      ENDIF                                                             SCA 1200                                                         
      IF(IEMSCT . EQ. 3) THEN                                           SCA 1210                                                         
         NVAR = 3                                                       SCA 1220                                                         
      ENDIF                                                             SCA 1230                                                         
      ILK = IVAR + 1                                                    SCA 1240                                                         
      IF(ILK . GT. NVAR) ILK = NVAR                                     SCA 1250                                                         
      WIDTH = 2. * HWHM                                                 SCA 1260                                                         
      J = 0                                                             SCA 1270                                                         
200   IF(IEMSCT.GT.0) READ (7,1000) FREQ,(VAR(K),K=1,NVAR)              SCA 1280                                                         
      IF(IEMSCT.EQ.0) READ (7,1100) FREQ,(VAR(K),K=1,NVAR)              SCA 1290                                                         
      IF(FREQ.EQ.-9999.) GO TO 500                                      SCA 1300                                                         
1000  FORMAT(F7.0,F8.4,9E9.2)                                           SCA 1310                                                         
1100  FORMAT(F7.0,11F8.4)                                               SCA 1320                                                         
      IF(FREQ . LT. V1I ) GO TO 200                                     SCA 1330                                                         
      J = J + 1                                                         SCA 1340                                                         
      MAX = J                                                           SCA 1350                                                         
      Y(J) = VAR(ILK)                                                   SCA 1360                                                         
      IF(FREQ. GE. V2I) GO TO 500                                       SCA 1370                                                         
      GO TO 200                                                         SCA 1380                                                         
500   N = (V2O - V1O) /DVO + 1.001                                      SCA 1390                                                         
      DO 520 I = 1,N                                                    SCA 1400                                                         
      VOUT = (I-1) * DVO + V1O                                          SCA 1410                                                         
      IF(HWVB .GT. 0.) THEN                                             SCA 1420                                                         
         WIDTH =  2.0E-4 * (VOUT**2) * HWVB                             SCA 1430                                                         
      ENDIF                                                             SCA 1440                                                         
      DVW = DVI/WIDTH                                                   SCA 1450                                                         
      VLO = VOUT - WIDTH                                                SCA 1460                                                         
      VHI = VOUT + WIDTH                                                SCA 1470                                                         
      JLO = (VLO - V1I) /  DVI  + 1.001                                 SCA 1480                                                         
      JHI = (VHI - V1I) /  DVI  + 1.001                                 SCA 1490                                                         
      Z    = 0.                                                         SCA 1500                                                         
      IF(JLO . LT. 1) GO TO 520                                         SCA 1510                                                         
      DO 510  J = JLO,JHI                                               SCA 1520                                                         
      VIN = (J-1)*DVI + V1I                                             SCA 1530                                                         
      Z    = Z   +Y(J)*DVW*(1.-ABS((VOUT-VIN)/(WIDTH)))                 SCA 1540                                                         
510   CONTINUE                                                          SCA 1550                                                         
      DO 511 K = 1,NVAR                                                 SCA 1560                                                         
511   VAR(K) = 0.                                                       SCA 1570                                                         
      VAR(ILK) = Z                                                      SCA 1580                                                         
      IF(IEMSCT.GT.0) WRITE(9,1001) VOUT,(VAR(K),K=1,NVAR)              SCA 1590                                                         
1001  FORMAT(F7.0,F8.4,1P9E9.2)                                         SCA 1600                                                         
      IF(IEMSCT.EQ.0) WRITE(9,1100) VOUT,(VAR(K),K=1,NVAR)              SCA 1610                                                         
520   CONTINUE                                                          SCA 1620                                                         
      WRITE(9,1200)                                                     SCA 1630                                                         
1200  FORMAT(' -9999.')                                                 SCA 1640                                                         
      END                                                               SCA 1650                                                         
