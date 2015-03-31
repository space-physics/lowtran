      PROGRAM LOWFIL                                                    LFIL 100                                                         
C                                                                       LFIL 110                                                         
C                                                                       LFIL 120                                                         
C     LOWTRAN7  FILTER FUNCTION PROGRAM                                 LFIL 130                                                         
C                                                                       LFIL 140                                                         
C      PROGRAM WRITTEN BY                                               LFIL 150                                                         
C                                                                       LFIL 160                                                         
C                           ERIC P SHETTLE    OPA/AFGL                  LFIL 170                                                         
C                           JOHN O WISE       OPA/AFGL                  LFIL 180                                                         
C                           LEONARD W ABREU   OPI/AFGL                  LFIL 190                                                         
C                                                                       LFIL 200                                                         
C                                                                       LFIL 210                                                         
C------FILTER FUNCTION CONTROL INPUTS---------------------------------  LFIL 220                                                         
C      1.) CARD 1 NF,NEW,IFT,TEMP,IPRINT,NLOW (3I5, F10.2, 2I5)         LFIL 230                                                         
C           NF = NUMBER OF FILTERS (I5)                                 LFIL 240                                                         
C             IF NF > 0  READ IN NF FILTERS (NF<=15)                    LFIL 250                                                         
C             IF NF = 0  USE PRECEDING FILTERS AND LOWTRAN OUTPUT,WITH  LFIL 260                                                         
C               OPTION TO CHANGE BLACKBODY TEMPERATURE.                 LFIL 270                                                         
C             IF(NF < 0) STOP FILTER PROGRAM                            LFIL 280                                                         
C           NEW = OPTION TO USE SAME LOWTRAN DATA SET FOR NEXT FILTER-- LFIL 290                                                         
C             0=NO, 1=YES--REWINDS LOWTRAN FILE (I5)                    LFIL 300                                                         
C           IFT = OPTION TO ENTER BLACKBODY TEMPERATURE                 LFIL 310                                                         
C             0=NO BLACKBODY, 1=FOLD IN BLACKBODY TEMPERATURE (I5)      LFIL 320                                                         
C           TEMP = BLACKBODY TEMPERATURE IN DEGREES KELVIN (F10.2)      LFIL 330                                                         
C           IPRINT = DATA PRINT CONTROL (I5)                            LFIL 340                                                         
C             IF IPRINT>=10, PRINT LOWTRAN TRANSMITTANCES AND INFO      LFIL 350                                                         
C                 BELOW                                                 LFIL 360                                                         
C             IF IPRINT>=5, PRINT FILTER FUNCTION WITH BLACKBODY        LFIL 370                                                         
C                 FUNCTION FOLDED IN.                                   LFIL 380                                                         
C             IF IPRINT<5, ONLY PRINT FINAL TRANSMITTANCES.             LFIL 390                                                         
C           NLOW = NUMBER OF LOWTRAN FILES TO BE READ (I5)              LFIL 400                                                         
C                                                                       LFIL 410                                                         
C     REPEAT CARDS 2 AND 3 NF TIMES                                     LFIL 420                                                         
C      2.) CARD 2 IDFIL,KODE,IFWV,NW (2A10, 3I5)                        LFIL 430                                                         
C           IDFIL = FILTER IDENTIFICATION (2A10)                        LFIL 440                                                         
C           KODE = FILTER NUMBER (I5)                                   LFIL 450                                                         
C           IFWV = OPTION TO CONVERT FROM WAVELENGTH TO WAVENUMBER--    LFIL 460                                                         
C             0=YES, 1=NO (I5)                                          LFIL 470                                                         
C           NW = NUMBER OF WAVELENGTHS FOR THE FILTER (I5) (NW<=80)     LFIL 480                                                         
C                                                                       LFIL 490                                                         
C      3.) CARD 3 (WAVE(I), FF(I), I=1,NW) (FREE FORMAT--AS MANY CARDS  LFIL 500                                                         
C       AS NEEDED FOR NW WAVELENGTHS)                                   LFIL 510                                                         
C           WAVE = WAVELENGTH OR WAVENUMBER                             LFIL 520                                                         
C           FF = CORRESPONDING FILTER FUNCTION                          LFIL 530                                                         
C      PROGRAM ASSUMES FILTER FUNCTION INPUTS ARE ON TAPE5 AND          LFIL 540                                                         
C        LOWTRAN OUTPUT FILES ARE ON TAPE7.                             LFIL 550                                                         
C---------------------------------------------------------------------- LFIL 560                                                         
C                                                                       LFIL 570                                                         
      DIMENSION IVF(15), IVL(15), VF(15), NVL(15)                       LFIL 580                                                         
      DIMENSION BIGF(15),TRRDNO(12,15)                                  LFIL 590                                                         
      DIMENSION IDFIL(5,15), KODE(15), IFWV(15)                         LFIL 600                                                         
      DIMENSION NW(15)                                                  LFIL 610                                                         
      DIMENSION FILT(2300), TRNRD(12,15)                                LFIL 620                                                         
      DIMENSION ACRD2A(20),ACRD2B(20),ACRD2C(20),ACD3A1(20),ACD3A2(20)  LFIL 630                                                         
      DIMENSION  WAVE(200,15),FF(200,15),RST(2300,11),VNU(2300),        LFIL 640                                                         
     X  ALAM(2300)                                                      LFIL 642                                                         
      DIMENSION  WTRN(990), GTRN(990)                                   LFIL 644                                                         
      COMMON/ATM/VIS,TMP,DP,RANGE                                       LFIL 650                                                         
      OPEN (  5,FILE='TAPE5',STATUS='UNKNOWN')                          LFIL 660                                                         
      OPEN (  6,FILE='TAPE6',STATUS='UNKNOWN')                          LFIL 670                                                         
      OPEN (  7,FILE='TAPE7',STATUS='UNKNOWN')                          LFIL 680                                                         
C                                                                       LFIL 690                                                         
 1    READ(5,910)    NF, NEW, IFT, TEMP, IPRINT, NLOW                   LFIL 700                                                         
      WRITE (6,915)  NF, NEW, IFT, TEMP, IPRINT, NLOW                   LFIL 710                                                         
      IF(NF .GT. 0) NFIL = NF                                           LFIL 720                                                         
      IF(NF .EQ. 0) GO TO 140                                           LFIL 730                                                         
      IF(NF .LT. 0) GO TO 801                                           LFIL 740                                                         
C                                                                       LFIL 750                                                         
      DO 120 L=1,NFIL                                                   LFIL 760                                                         
      READ(5,920) (IDFIL(I,L),I=1,5), KODE(L), IFWV(L), NW(L)           LFIL 770                                                         
      NT = NW(L)                                                        LFIL 780                                                         
      READ(5,*) (WAVE(K,L), FF(K,L), K=1,NT)                            LFIL 790                                                         
      IF(IFWV(L).EQ.1) GO TO 50                                         LFIL 800                                                         
      WRITE (6,930)  (IDFIL(I,L), I=1,5), KODE(L), IFWV(L), NW(L),      LFIL 810                                                         
     + (WAVE(K,L), FF(K,L), K=1,NT)                                     LFIL 820                                                         
C                                                                       LFIL 830                                                         
C        CONVERT FROM WAVELENGTH TO WAVENUMBER IF NECESSARY.            LFIL 840                                                         
C        REVERSE ORDER OF FILTER FUNCTIONS AND WAVENUMBERS TO BE        LFIL 850                                                         
C        COMPATIBLE WITH LOWTRAN.                                       LFIL 860                                                         
C                                                                       LFIL 870                                                         
       CALL WAVEN(WAVE(1,L), FF(1,L),NT)                                LFIL 880                                                         
   50 CONTINUE                                                          LFIL 890                                                         
      WRITE (6,940)  (IDFIL(I,L), I=1,5), KODE(L), IFWV(L), NW(L),      LFIL 900                                                         
     +(WAVE(K,L), FF(K,L), K=1,NT)                                      LFIL 910                                                         
  120 CONTINUE                                                          LFIL 920                                                         
C      IF NEW GE 1 USE PRECEDING LOWTRAN DATA READ                      LFIL 930                                                         
  140 IF(NEW .GE. 1) REWIND 7                                           LFIL 940                                                         
C                                                                       LFIL 950                                                         
C      *************** READ IN LOWTRAN DATA FILE ********************** LFIL 960                                                         
C                                                                       LFIL 970                                                         
C        READ LOWTRAN HEADER CARDS                                      LFIL 980                                                         
C        READ IN LOWTRAN DATA FILE FROM TAPE--WAVENUMBER VS             LFIL 990                                                         
C        TRANSMITTANCE FOR THE NINE MOLECULAR AND AEROSOL COMPONENTS    LFIL1000                                                         
      DO 400 KK=1,NLOW                                                  LFIL1010                                                         
C                                                                       LFIL1020                                                         
      WRITE (6,945)                                                     LFIL1030                                                         
      READ(  7,1950)MODEL,ITYPE,IEMSCT,IMULT,M1,M2,M3,                  LFIL1040                                                         
     1 M4,M5,M6,MDEF,IM,NOPRT,TBOUND,SALB                               LFIL1050                                                         
      WRITE (6,950) MODEL,ITYPE,IEMSCT,IMULT,M1,M2,M3,                  LFIL1060                                                         
     1 M4,M5,M6,MDEF,IM,NOPRT,TBOUND,SALB                               LFIL1070                                                         
      READ  (7,952) IHAZE,ISEASN,IVULCN,ICSTL,ICIR,IVSA,                LFIL1080                                                         
     +VIS,WSS,WHH,RAINRT,GNDALT                                         LFIL1090                                                         
      WRITE (6,952) IHAZE,ISEASN,IVULCN,ICSTL,ICIR,IVSA,                LFIL1100                                                         
     +VIS,WSS,WHH,RAINRT,GNDALT                                         LFIL1110                                                         
      READ  (7,954) ACRD2A                                              LFIL1120                                                         
      WRITE (6,954) ACRD2A                                              LFIL1130                                                         
      READ  (7,954) ACRD2B                                              LFIL1140                                                         
      WRITE (6,954) ACRD2B                                              LFIL1150                                                         
      READ  (7,954) ACRD2C                                              LFIL1160                                                         
      WRITE (6,954) ACRD2C                                              LFIL1170                                                         
      IF(MODEL.NE.0) READ  (7,956) H1,H2,ANGLE,RANGE,BETA,RO,LEN        LFIL1180                                                         
      IF(MODEL.NE.0) WRITE (6,956) H1,H2,ANGLE,RANGE,BETA,RO,LEN        LFIL1190                                                         
      IF(MODEL.EQ.0) READ  (7,958) H1,P,T,DP,RH,WH,WO,RANGE             LFIL1200                                                         
      IF(MODEL.EQ.0) WRITE (6,958) H1,P,T,DP,RH,WH,WO,RANGE             LFIL1210                                                         
      READ  (7,954) ACD3A1                                              LFIL1220                                                         
      WRITE (6,954) ACD3A1                                              LFIL1230                                                         
      READ  (7,954) ACD3A2                                              LFIL1240                                                         
      WRITE (6,954) ACD3A2                                              LFIL1250                                                         
      READ  (7,960) V1,V2,DV                                            LFIL1260                                                         
      WRITE (6,960) V1,V2,DV                                            LFIL1270                                                         
      READ  (7,954) ACRD2C                                              LFIL1160                                                         
CC    READ  (7,962) IRPT                                                LFIL1280                                                         
      IRPT = 1                                                          LFIL1282                                                         
      WRITE (6,962) IRPT                                                LFIL1290                                                         
      READ  (7,954) ACRD2A                                              LFIL1300                                                         
      NP = INT((V2 - V1)/DV) + 1                                        LFIL1310                                                         
      IF(IPRINT.LT.10) GO TO 145                                        LFIL1320                                                         
      IF(IEMSCT.EQ.0) WRITE (6,968)                                     LFIL1330                                                         
      IF(IEMSCT.GT.0) WRITE (6,969)     ACRD2A                          LFIL1340                                                         
  145 CONTINUE                                                          LFIL1350                                                         
      IF(IEMSCT . EQ. 0) THEN                                           LFIL1360                                                         
         NVAR = 11                                                      LFIL1370                                                         
      ENDIF                                                             LFIL1380                                                         
      IF(IEMSCT . EQ. 1) THEN                                           LFIL1390                                                         
         NVAR = 2                                                       LFIL1400                                                         
      ENDIF                                                             LFIL1410                                                         
      IF(IEMSCT . EQ. 2) THEN                                           LFIL1420                                                         
         NVAR = 7                                                       LFIL1430                                                         
      ENDIF                                                             LFIL1440                                                         
      IF(IEMSCT . EQ. 3) THEN                                           LFIL1450                                                         
         NVAR = 3                                                       LFIL1460                                                         
      ENDIF                                                             LFIL1470                                                         
      DO 150 J=1,NP                                                     LFIL1480                                                         
      IF(IEMSCT.EQ.0) READ  (7,964) VNU(J), (RST(J,I),I=1,NVAR)         LFIL1490                                                         
      IF(IEMSCT.GT.0) READ  (7,966) VNU(J), (RST(J,I),I=1,NVAR)         LFIL1500                                                         
      IF(VNU(J) .LT. 0.)THEN                                            LFIL1502                                                         
             NP = J - 1                                                 LFIL1504                                                         
             GO TO 150                                                  LFIL1506                                                         
      ENDIF                                                             LFIL1508                                                         
      ALAM(J)=1.0E+4/VNU(J)                                             LFIL1510                                                         
      IF(VNU(J).LE.0.) ALAM(J)=1.0E+32                                  LFIL1520                                                         
      IF(IPRINT .LT. 10) GO TO 150                                      LFIL1530                                                         
      IF(IEMSCT.EQ.0) WRITE (6,965) VNU(J), (RST(J,I),I=1,NVAR)         LFIL1540                                                         
      IF(IEMSCT.GT.0) WRITE (6,967) VNU(J), (RST(J,I),I=1,NVAR)         LFIL1550                                                         
  150 CONTINUE                                                          LFIL1560                                                         
C                                                                       LFIL1570                                                         
C     +++++++++++++++ CALCULATE WEIGHTED TRANSMITTANCES ++++++++++++++  LFIL1580                                                         
C                                                                       LFIL1590                                                         
C        THIS PART OF THE PROGRAM NOW LOOPS OVER EACH OF THE LOWTRAN    LFIL1600                                                         
C        TRANSMITTANCES, CALCULATING WEIGHTED TRANSMITANCES FOR EACH    LFIL1610                                                         
C        MOLECULAR OR AEROSOL COMPONENT                                 LFIL1620                                                         
      DO 300 L=1,NF                                                     LFIL1630                                                         
      NT = NW(L)                                                        LFIL1640                                                         
C                                                                       LFIL1650                                                         
C        FIND ARRAY IN LOWTRAN WAVENUMBERS WHICH BRACKETS THE FILTER    LFIL1660                                                         
C        FUNCTION WAVENUMBERS.                                          LFIL1670                                                         
C                                                                       LFIL1680                                                         
      CALL BRACK(V1, WAVE(1,L), NT, DV, IVF(L), IVL(L), NVL(L))         LFIL1690                                                         
      IA = IVF(L)                                                       LFIL1700                                                         
      IB = IVL(L)                                                       LFIL1710                                                         
      VF(L) = VNU(IA)                                                   LFIL1720                                                         
      WRITE (6,970)  KODE(L), (IDFIL(J,L), J=1,5)                       LFIL1730                                                         
      IF(IPRINT.GE.5)                                                   LFIL1740                                                         
     +WRITE (6,972)  IA, IB, NVL(L), VNU(IA), VNU(IB)                   LFIL1750                                                         
C                                                                       LFIL1760                                                         
C        INTERPOLATE IN INPUT FILTER FUNCTION RESPONSES TO GET FILTER   LFIL1770                                                         
C        FUNCTIONS FOR LOWTRAN WAVENUMBERS.                             LFIL1780                                                         
C                                                                       LFIL1790                                                         
      CALL INTLOG(FF(1,L), WAVE(1,L), NT, FILT, VNU(IA), NVL(L))        LFIL1800                                                         
C                                                                       LFIL1810                                                         
C     CHECK INTERPOLATED FILTER VALUES                                  LFIL1820                                                         
C     IF ANY ARE NEGATIVE RESET TO ZERO                                 LFIL1830                                                         
C                                                                       LFIL1840                                                         
      N=NVL(L)                                                          LFIL1850                                                         
      DO 210 I=1,N                                                      LFIL1860                                                         
      IF(FILT(I).LT.0) FILT(I)=0.                                       LFIL1870                                                         
  210 CONTINUE                                                          LFIL1880                                                         
      CALL BIGFIL(FILT,NVL(L),BIGF(L))                                  LFIL1890                                                         
      IE = 1                                                            LFIL1900                                                         
      IF (IPRINT .LT. 5) GO TO 250                                      LFIL1910                                                         
      WRITE (6,976)  (VNU(M), FILT(M-IA+1), RST(M,IE), M=IA,IB)         LFIL1920                                                         
  250 CONTINUE                                                          LFIL1930                                                         
      IF(IEMSCT.LT.1) GO TO 270                                         LFIL1940                                                         
      IF(IEMSCT.EQ.2) GO TO 260                                         LFIL1950                                                         
C                                                                       LFIL1960                                                         
C     IEMSCT=1  STANDARD EMISSION RUN                                   LFIL1970                                                         
C     INTEGRATE THE PATH RADIANCE AND TOTAL TRANS.                      LFIL1980                                                         
C                                                                       LFIL1990                                                         
C     OR IEMSCT =3  DIRECT SOLAR                                        LFIL2000                                                         
C     INTEGRATE THE TRANSMITTED IRRADIANCE AND TOTAL TRANSMITTANCE      LFIL2010                                                         
C                                                                       LFIL2020                                                         
      DO 255 J = 2,NVAR                                                 LFIL2022                                                         
      I = J-1                                                           LFIL2024                                                         
      CALL INTRAD(FILT,RST(IA,2),NVL(L),DV,TRNRD(I,L))                  LFIL2030                                                         
      TRRDNO(I,L)=TRNRD(I,L)/BIGF(L)                                    LFIL2040                                                         
255   CONTINUE                                                          LFIL2042                                                         
      IF(IFT.EQ.1) CALL BLKBDY(TEMP,FILT,NVL(L),VNU(IA))                LFIL2050                                                         
      IF(IPRINT.GE.5 .AND. IFT.EQ.1) WRITE (6,975)                      LFIL2060                                                         
      IF(IPRINT.GE.5 .AND. IFT.EQ.1)                                    LFIL2070                                                         
     +WRITE (6,976) (VNU(M),FILT(M-IA+1),RST(M,IE),M=IA,IB)             LFIL2080                                                         
      CALL INTGRT(FILT,RST(IA,IE),NVL(L),TRNRD(9,L))                    LFIL2090                                                         
      GO TO 280                                                         LFIL2100                                                         
  260 CONTINUE                                                          LFIL2110                                                         
C                                                                       LFIL2120                                                         
C     IEMSCT=2  EMISSION WITH SCATTERING                                LFIL2130                                                         
C     INTEGRATE THE PATH RADIANCE,SCATTERED RADIANCE,REFLECTED RADIANCE LFIL2140                                                         
C     TOTAL RADIANCE AND TOTAL TRANS.                                   LFIL2150                                                         
C                                                                       LFIL2160                                                         
      DO 265 J=2,NVAR                                                   LFIL2170                                                         
      I = J-1                                                           LFIL2180                                                         
      CALL INTRAD(FILT,RST(IA,J),NVL(L),DV,TRNRD(I,L))                  LFIL2190                                                         
      TRRDNO(I,L)=TRNRD(I,L)/BIGF(L)                                    LFIL2200                                                         
  265 CONTINUE                                                          LFIL2210                                                         
      IF(IFT.EQ.1) CALL BLKBDY(TEMP,FILT,NVL(L),VNU(IA))                LFIL2220                                                         
      IF(IPRINT.GE.5 .AND. IFT.EQ.1) WRITE (6,975)                      LFIL2230                                                         
      IF(IPRINT.GE.5 .AND. IFT.EQ.1)                                    LFIL2240                                                         
     +WRITE (6,976) (VNU(M),FILT(M-IA+1),RST(M,IE),M=IA,IB)             LFIL2250                                                         
      CALL INTGRT(FILT,RST(IA,IE),NVL(L),TRNRD(9,L))                    LFIL2260                                                         
      GO TO 290                                                         LFIL2270                                                         
  270 CONTINUE                                                          LFIL2280                                                         
C                                                                       LFIL2290                                                         
C     IEMSCT=0  STANDARD TRANSMISSION RUN                               LFIL2300                                                         
C     INTEGRATE ALL MOLECULES                                           LFIL2310                                                         
C                                                                       LFIL2320                                                         
C        MERGE WATER CONTINUUM WITH WATER BAND TO GET AVERAGE WATER     LFIL2330                                                         
C        TRANSMITTANCE (WATAV).  MERGE GASES TO GET UNIFORMLY MIXED     LFIL2340                                                         
C        GASES TRANSMITTANCE (GASAV).                                   LFIL2350                                                         
C                                                                       LFIL2360                                                         
      IF(IFT.EQ.1) CALL BLKBDY(TEMP,FILT,NVL(L),VNU(IA))                LFIL2370                                                         
      IF(IPRINT.GE.5 .AND. IFT.EQ.1) WRITE (6,975)                      LFIL2380                                                         
      IF(IPRINT.GE.5 .AND. IFT.EQ.1)                                    LFIL2390                                                         
     +WRITE (6,976) (VNU(M),FILT(M-IA+1),RST(M,IE),M=IA,IB)             LFIL2400                                                         
      CALL COMBT(FILT, RST, NVL(L), IA, WATAV, GASAV)                   LFIL2410                                                         
      DO 275 I=1,10                                                     LFIL2420                                                         
      CALL INTGRT(FILT,RST(IA,I), NVL(L), TRNRD(I,L))                   LFIL2430                                                         
  275 CONTINUE                                                          LFIL2440                                                         
      WRITE (6,977)                                                     LFIL2450                                                         
      WRITE (6,978)  (I, TRNRD(I,L), I=1,10)                            LFIL2460                                                         
      TWGA=WATAV*GASAV*TRNRD(9,L)                                       LFIL2470                                                         
      T2TO10=TRNRD(2,L)*TRNRD(3,L)*TRNRD(4,L)*TRNRD(5,L)*TRNRD(6,L)*    LFIL2480                                                         
     + TRNRD(7,L)*TRNRD(8,L)*TRNRD(9,L)*TRNRD(10,L)                     LFIL2490                                                         
      WRITE (6,980)  T2TO10,TWGA                                        LFIL2500                                                         
      IF(MODEL.EQ.0) WRITE (6,982)  VIS, T, DP, P, RANGE, TEMP,         LFIL2510                                                         
     +TRNRD(1,L),WATAV,GASAV, TRNRD(9,L), KODE(L), (IDFIL(I,L), I=1,5)  LFIL2520                                                         
      IF(MODEL.NE.0) WRITE (6,983) VIS,TEMP,TRNRD(1,L),WATAV,GASAV,     LFIL2530                                                         
     +TRNRD(8,L),KODE(L),(IDFIL(I,L),I=1,5)                             LFIL2540                                                         
      GO TO 300                                                         LFIL2550                                                         
  280 CONTINUE                                                          LFIL2560                                                         
      IF(IEMSCT.EQ.3)THEN                                               LFIL2580                                                         
           WRITE (6,9882)                                               LFIL2570                                                         
           IF(MODEL.EQ.0)THEN                                           LFIL2572                                                         
              WRITE (6,9841)VIS,T,DP,P,RANGE,TEMP,                      LFIL2580                                                         
     +        TRNRD(2,L),TRNRD(9,L),KODE(L),(IDFIL(I,L),I=1,5)          LFIL2590                                                         
           ELSE                                                         LFIL2592                                                         
               WRITE (6,9851)VIS,TEMP,TRNRD(1,L),                       LFIL2594                                                         
     +         TRNRD(2,L),TRNRD(9,L),KODE(L),(IDFIL(I,L),I=1,5)         LFIL2596                                                         
           ENDIF                                                        LFIL2598                                                         
           WRITE (6,9892)                                               LFIL2620                                                         
           WRITE (6,9951)TRRDNO(1,L),TRRDNO(2,L)                        LFIL2630                                                         
       ELSE                                                             LFIL2632                                                         
           IF(IMULT. EQ. 0)WRITE (6,988)                                LFIL2633                                                         
           IF(IMULT. EQ. 1)WRITE (6,9881)                               LFIL2634                                                         
           IF(MODEL.EQ.0)THEN                                           LFIL2635                                                         
              WRITE (6,984) VIS,T,DP,P,RANGE,TEMP,                      LFIL2636                                                         
     +        TRNRD(1,L),TRNRD(9,L),KODE(L),(IDFIL(I,L),I=1,5)          LFIL2637                                                         
           ELSE                                                         LFIL2638                                                         
              WRITE (6,985) VIS,TEMP,TRNRD(1,L),                        LFIL2639                                                         
     +                   TRNRD(9,L),KODE(L),(IDFIL(I,L),I=1,5)          LFIL263A                                                         
           ENDIF                                                        LFIL263B                                                         
           IF(IMULT.EQ.0)WRITE (6,989)                                  LFIL263C                                                         
           IF(IMULT.EQ.1)WRITE (6,9891)                                 LFIL263D                                                         
           WRITE (6,994) TRRDNO(1,L)                                    LFIL263E                                                         
      ENDIF                                                             LFIL263F                                                         
      GO TO 300                                                         LFIL263G                                                         
C                                                                       LFIL263H                                                         
  290 CONTINUE                                                          LFIL2660                                                         
C      SINGLE SCATTERING RESULTS                                        LFIL2662                                                         
      IF(IMULT.EQ. 0)WRITE (6,988)                                      LFIL2670                                                         
      IF(IMULT.EQ. 1)WRITE (6,9881)                                     LFIL2672                                                         
      TOTRAD = TRNRD(1,L) + TRNRD(3,L) + TRNRD(5,L)                     LFIL2674                                                         
      IF(MODEL.EQ.0) WRITE (6,986) VIS,T,DP,P,RANGE,TEMP,               LFIL2680                                                         
     +TRNRD(1,L),TRNRD(3,L),TRNRD(5,L),TOTRAD    ,TRNRD(9,L),           LFIL2690                                                         
     +KODE(L),(IDFIL(I,L),I=1,5)                                        LFIL2700                                                         
      IF(MODEL.NE.0) WRITE (6,987) VIS,TEMP,TRNRD(1,L),TRNRD(3,L),      LFIL2710                                                         
     +TRNRD(5,L),TOTRAD    ,TRNRD(9,L),KODE(L),(IDFIL(I,L),I=1,5)       LFIL2720                                                         
      IF(IMULT.EQ.0)WRITE (6,989)                                       LFIL2730                                                         
      IF(IMULT.EQ.1)WRITE (6,9891)                                      LFIL2732                                                         
      TOTRAD = TRRDNO(1,L) + TRRDNO(3,L) + TRRDNO(5,L)                  LFIL2734                                                         
      IF(MODEL.EQ.0) WRITE (6,996) TRRDNO(1,L),TRRDNO(3,L),TRRDNO(5,L), LFIL2740                                                         
     +TOTRAD                                                            LFIL2750                                                         
      IF(MODEL.NE.0) WRITE (6,997) TRRDNO(1,L),TRRDNO(3,L),TRRDNO(5,L), LFIL2760                                                         
     +TOTRAD                                                            LFIL2770                                                         
C     SINGLE-MULTIPLE SCATTERING                                        LFIL2772                                                         
      IF(IEMSCT.NE.0.AND.IMULT.EQ.1 )THEN                               LFIL2774                                                         
           WRITE (6,9881)                                               LFIL2776                                                         
           TOTRAD = TRRDNO(1,L) + TRRDNO(2,L) + TRRDNO(4,L)             LFIL2778                                                         
           IF(MODEL.EQ.0) WRITE (6,986) VIS,T,DP,P,RANGE,TEMP,          LFIL2779                                                         
     +     TRNRD(1,L),TRNRD(2,L),TRNRD(4,L),TOTRAD,TRNRD(9,L),          LFIL277A                                                         
     +     KODE(L),(IDFIL(I,L),I=1,5)                                   LFIL277B                                                         
           IF(MODEL.NE.0)WRITE(6,987)VIS,TEMP,TRNRD(1,L),TRNRD(2,L),    LFIL277C                                                         
     +     TRNRD(4,L),TOTRAD,TRNRD(9,L),KODE(L),(IDFIL(I,L),I=1,5)      LFIL277D                                                         
      ENDIF                                                             LFIL277E                                                         
  300 CONTINUE                                                          LFIL2780                                                         
C                                                                       LFIL2790                                                         
C        TEST FOR END-OF-FILE.                                          LFIL2800                                                         
C     LOWTRAN 6 SEPARATES FILES WITH A  -9999. CODE IN THE              LFIL2810                                                         
C     FIRST WORD (F7.0) FOLLOWING THE LAST RECORD OF DATA OUTPUT.       LFIL2820                                                         
C                                                                       LFIL2830                                                         
      READ (7,999) DUM                                                  LFIL2840                                                         
      IF (DUM.EQ.-9999.) GO TO 400                                      LFIL2850                                                         
  310 WRITE (6,998)                                                     LFIL2860                                                         
      STOP                                                              LFIL2870                                                         
  400 CONTINUE                                                          LFIL2880                                                         
      GO TO 1                                                           LFIL2890                                                         
  801 CONTINUE                                                          LFIL2900                                                         
      STOP                                                              LFIL2910                                                         
C                                                                       LFIL2920                                                         
C     ************************** FORMATS ****************************** LFIL2930                                                         
C                                                                       LFIL2940                                                         
  910 FORMAT(3I5, F10.2, 2I5)                                           LFIL2950                                                         
  915 FORMAT(21H1 NUMBER OF FILTERS= , I5, 2X, 4HNEW=, I5, 2X, 4HIFT=,  LFIL2960                                                         
     +I5,2X, 12HTEMPERATURE=, F10.2, 2X, 7HIPRINT=,I5,2X,5HNLOW=, I5)   LFIL2970                                                         
  920 FORMAT(5A4, 3I5)                                                  LFIL2980                                                         
  930 FORMAT(//1H0,2X,12H FILTER NAME,10X,5HFILT#,2X,8HIFWV  NW,        LFIL2990                                                         
     +/2X,5A4,2X,3I5/1X,9(14H WAVEL    FF  )/9(F8.3,F6.2))              LFIL3000                                                         
  940 FORMAT(2X,12H FILTER NAME,10X,5HFILT#,2X,8HIFWV  NW,              LFIL3010                                                         
     +/2X,5A4,2X,3I5/1X,9(14H WAVEN    FF  )/9(F8.1,F6.2))              LFIL3020                                                         
  945 FORMAT(//1H0, 2X,10(4H****), 22H LOWTRAN CONTROL DATA ,           LFIL3030                                                         
     + 10(4H****))                                                      LFIL3040                                                         
 1950 FORMAT(1X,I4,12I5,F8.3,F7.2)                                      LFIL3050                                                         
  950 FORMAT(13I5,F8.3,F7.2)                                            LFIL3050                                                         
  952 FORMAT(6I5,5F10.3)                                                LFIL3060                                                         
  954 FORMAT(20A4)                                                      LFIL3070                                                         
  956 FORMAT(6F10.3,I5)                                                 LFIL3080                                                         
  958 FORMAT(3F10.3,2F5.1,2E10.3,F10.3)                                 LFIL3090                                                         
  960 FORMAT(3F10.3)                                                    LFIL3100                                                         
  962 FORMAT(I5)                                                        LFIL3110                                                         
  963 FORMAT(A1)                                                        LFIL3120                                                         
  964 FORMAT(F7.0,11F8.4)                                               LFIL3130                                                         
  965 FORMAT(2X,F7.0,11F8.4)                                            LFIL3140                                                         
  966 FORMAT(F7.0,F8.4,9E9.2)                                           LFIL3150                                                         
  967 FORMAT(2X,F7.0,F8.4,1P9E9.2)                                      LFIL3160                                                         
  968 FORMAT(/5X,42H LOWTRAN TAPE 7 OUTPUT   TRANSMISSION CASE  ,       LFIL3170                                                         
     +/2X,45H WAVEN     TOT TRN    H2O     CO2+      O3       ,         LFIL3180                                                         
     +43H N2 CONT  H2O CONT MOL SCT  AEROSOL   HNO3    ,//)             LFIL3190                                                         
  969 FORMAT(/5X,42H LOWTRAN TAPE 7 OUTPUT    EMISSION CASE   ,/,       LFIL3200                                                         
     + 20A4,//)                                                         LFIL3210                                                         
  970 FORMAT(//18X,30HSUMMARY OF CALCULATIONS WITH  ,7HFILTER#, I3,     LFIL3220                                                         
     + 2X, 12HFILTER NAME , 5A4/)                                       LFIL3230                                                         
  972 FORMAT(2X, 15H IVF, IVL, NVL=, 3I5,  2X,                          LFIL3240                                                         
     +24HLOWTRAN WAVENUMBERS FROM, F10.2, 2X, 2HTO, F10.2,              LFIL3250                                                         
     + /30X,41HFILTER RESPONSES AND TOTAL TRANSMITTANCES/)              LFIL3260                                                         
  975 FORMAT(/30X,42HFILTER RESPONSES WITH BLACKBODY EMISSIVITY/)       LFIL3270                                                         
  976 FORMAT( 1X, 5(25HWAVE    RESP        T    ,1X), /                 LFIL3280                                                         
     + 5(F7.0, 1PE9.2, 0PF7.3,3X))                                      LFIL3290                                                         
  977 FORMAT(//36X,39H SENSOR WEIGHTED AVERAGE TRANSMITTANCES,          LFIL3300                                                         
     +/21X,9HTOT TRANS,12H   H2O BAND ,9H   CO2   ,9H  OZONE  ,         LFIL3310                                                         
     +2X,9H   TRACE ,2X,9H N2 CONT ,2X,9HH20 CONT ,9H MOL SCT ,         LFIL3320                                                         
     +2X,9HAER TRANS,2X,9H  HNO3   )                                    LFIL3330                                                         
  978 FORMAT(21H  CONSTITUENT TRANS.=,10(I3, 1X, F5.3,1H,))             LFIL3340                                                         
  980 FORMAT(2X, 8H T2TO10=,F6.3, 4X, 6HTWGA= , F6.3,4X)                LFIL3350                                                         
  982 FORMAT(/41H   VIS   T     DP    P      RANGE BBTEMP ,             LFIL3360                                                         
     +32HTTOT TH2O TGAS TAER FILT#   NAME, /,                           LFIL3370                                                         
     +F5.1, 2F6.1, F6.0, F10.3, F6.0, 2F5.3,1X,2F5.3, I5, 5A4)          LFIL3380                                                         
  983 FORMAT(/49H   VIS   BBTEMP TTOT TH2O TGAS TAER FILT#    NAME,/,   LFIL3390                                                         
     +3X,F5.1,1X,F6.0,4F5.3,1X,I5,5A4)                                  LFIL3400                                                         
  984 FORMAT(/41H    VIS   T     DP    P      RANGE BBTEMP,             LFIL3410                                                         
     +32H EMIT RAD  TOT TRNS FILT#   NAME,                              LFIL3420                                                         
     +/,F5.1,2F6.1,F6.0,F10.3,F6.0,1PE10.3,0PF10.3,I5,5A4)              LFIL3430                                                         
 9841 FORMAT(/'   VIS   T     DP    P      RANGE BBTEMP,FILT#',         LFIL3432                                                         
     +'    NAME',                                                       LFIL3434                                                         
     +/,1X,        '(KM)        IRRAD     IRRAD',                       LFIL3436                                                         
     +/,1X,        '            (W/CM**2) (W/CM**2) ',                  LFIL3438                                                         
     +/,F5.1,1X,F6.0,1PE10.3,1X,E10.3,0PF10.3,I5,5A4)                   LFIL3450                                                         
  985 FORMAT(/45H VIS   BBTEMP EMIT RAD  TOT TRNS FILT#   NAME,         LFIL3452                                                         
     +/,F5.1,1X,F6.0,1PE10.3,0PF10.3,I5,5A4)                            LFIL3454                                                         
 9851 FORMAT(/,'VIS   BBTEMP DIR SOL   EXO SOL   TOT TRNS FILT#',       LFIL3456                                                         
     +'    NAME',                                                       LFIL3458                                                         
     +/,1X,        '(KM)        IRRAD     IRRAD',                       LFIL3459                                                         
     +/,1X,        '            (W/CM**2) (W/CM**2) ',                  LFIL345A                                                         
     +/,F5.1,1X,F6.0,1PE10.3,1X,E10.3,0PF10.3,I5,5A4)                   LFIL345B                                                         
  986 FORMAT(/41H    VIS   T     DP    P      RANGE BBTEMP,             LFIL3460                                                         
     +62H EMIT RAD  SCAT RAD  REFL RAD  TOT RAD   TOT TRNS FILT#   NAME,LFIL3470                                                         
     +/,F5.1,2F6.1,F6.0,F10.3,F6.0,1P4E10.3,0PF10.3,I5,5A4)             LFIL3480                                                         
  987 FORMAT(/13H VIS   BBTEMP,                                         LFIL3490                                                         
     +'EMIT RAD  SCAT RAD   REFL RAD   TOT RAD   TOT TRNS FILT#',       LFIL3500                                                         
     +'  NAME',                                                         LFIL3502                                                         
     +/,12X,        '(W/CM2/SR) (W/CM2/SR)  (W/CM2/SR)         ',       LFIL3504                                                         
     +/1X,F5.1,1X,F5.0,1P4E11.3,0PF9.3,I5,5A4)                          LFIL3510                                                         
  988 FORMAT(//8X,38H SENSOR WEIGHTED INTEGRATED RADIANCES ,            LFIL3520                                                         
     +              /10X,'(SINGLE SCATTERING)')                         LFIL3522                                                         
 9881 FORMAT(//8X,38H SENSOR WEIGHTED INTEGRATED RADIANCES ,            LFIL3524                                                         
     +              /10X,'(SINGLE+MULTIPLE SCATTERING)')                LFIL3526                                                         
 9882 FORMAT(//8X,38H SENSOR WEIGHTED INTEGRATED RADIANCES )            LFIL3528                                                         
  989 FORMAT(//16X,28H FILTER NORMALIZED RADIANCES         ,            LFIL3530                                                         
     +              /10X,'(SINGLE SCATTERING)')                         LFIL3532                                                         
 9891 FORMAT(//16X,28H FILTER NORMALIZED RADIANCES         ,            LFIL3534                                                         
     +              /10X,'(SINGLE+MULTIPLE SCATTERING)')                LFIL3536                                                         
 9892 FORMAT(//16X,28H FILTER NORMALIZED RADIANCES         )            LFIL3538                                                         
  994 FORMAT(/41X,9H EMIT RAD,/,41X,1PE10.3)                            LFIL3540                                                         
  995 FORMAT(/18X,9H EMIT RAD,/,18X,1PE10.3)                            LFIL3550                                                         
 9951 FORMAT(/18X,'DIR SOL    EXO SOL',                                 LFIL3550                                                         
     +      /,18X,'IRRAD      IRRAD',                                   LFIL3552                                                         
     +      /,18X,'(W/CM**2)  (W/CM**2)',                               LFIL3554                                                         
     +      /,17X,1P,2(E10.3,1X))                                       LFIL3556                                                         
 9952 FORMAT(/18X,'DIR SOL       EXO SOL',                              LFIL3558                                                         
     +      /,18X,'IRRAD         IRRAD',                                LFIL3559                                                         
     +      /,18X,'(W/CM**2)     (W/CM**2)',                            LFIL355A                                                         
     +      /,17X,1P,2(E10.3,4X))                                       LFIL355B                                                         
  996 FORMAT(/41X,39H EMIT RAD  SCAT RAD  REFL RAD   TOT RAD,           LFIL3560                                                         
     +/,41X,1P4E10.3)                                                   LFIL3570                                                         
  997 FORMAT(/,12X,  ' EMIT RAD  SCAT RAD  REFL RAD   TOT RAD',         LFIL3580                                                         
     +       /,12X,'(W/CM2/SR)(W/CM2/SR)(W/CM2/SR) (W/CM2/SR)',         LFIL3582                                                         
     +/,11X,1P3E10.3,1X,E11.3)                                          LFIL3590                                                         
 9971 FORMAT(/,'    EMIT RAD     SCAT RAD     REFL RAD     TOT RAD',    LFIL3592                                                         
     +/,'  (W/CM2/UM)    (W/CM2/UM)   (W/CM2/UM)   (W/CM2/UM)',         LFIL3594                                                         
     +/,1X,1P,4(E12.3,2X))                                              LFIL3590                                                         
  998 FORMAT(36H  ERROR--END OF FILE NOT ENCOUNTERED)                   LFIL3600                                                         
  999 FORMAT(F7.0)                                                      LFIL3610                                                         
      END                                                               LFIL3620                                                         
      SUBROUTINE INTGRT(F, T, N, TRANS)                                 INTG 100                                                         
C                                                                       INTG 110                                                         
C     THIS SUBROUTINE COMPUTES A TRAPEZOIDAL INTEGRATION, WITH          INTG 120                                                         
C      FUNCTION "F" BEING INTEGRATED ALONG THE "T" AXIS.                INTG 130                                                         
C                                                                       INTG 140                                                         
      DIMENSION F(N), T(N)                                              INTG 150                                                         
      TSUM = ((F(1)*T(1)) + (F(N)*T(N)))/2.0                            INTG 160                                                         
      SUM =(F(1) + F(N))/2.0                                            INTG 170                                                         
      NUM=N-1                                                           INTG 180                                                         
      DO 200 I=2,NUM                                                    INTG 190                                                         
      TSUM = TSUM + F(I)*T(I)                                           INTG 200                                                         
      SUM = SUM + F(I)                                                  INTG 210                                                         
  200 CONTINUE                                                          INTG 220                                                         
      TRANS = TSUM/SUM                                                  INTG 230                                                         
      RETURN                                                            INTG 240                                                         
      END                                                               INTG 250                                                         
      SUBROUTINE INTRAD(F,T,N,DV,TRANS)                                 INTR 100                                                         
C                                                                       INTR 110                                                         
C     THIS SUBROUTINE PERFORMS AN INTEGRATION FOR F(FILTER FUNCTION)    INTR 120                                                         
C     AND T(RADIANCE) ALONG THE T AXIS                                  INTR 130                                                         
C                                                                       INTR 140                                                         
      DIMENSION F(N),T(N)                                               INTR 150                                                         
      RSUM=((F(1)*T(1))+(F(N)*T(N)))/2.0                                INTR 160                                                         
      NUM=N-1                                                           INTR 170                                                         
      DO 200 I=2,NUM                                                    INTR 180                                                         
      RSUM=RSUM+F(I)*T(I)                                               INTR 190                                                         
  200 CONTINUE                                                          INTR 200                                                         
      TRANS=RSUM*DV                                                     INTR 210                                                         
      RETURN                                                            INTR 220                                                         
      END                                                               INTR 230                                                         
      SUBROUTINE BIGFIL(F,N,BIG)                                        BIGF 100                                                         
CCC                                                                     BIGF 110                                                         
CCC   ROUTINE TO CHOOSE LARGEST FILTER VALUE                            BIGF 120                                                         
CCC   TO APPLY TO NORMALIZATION OF RADIANCE RESULT                      BIGF 130                                                         
CCC   OBTAINED FROM SUBROUTINE INTRAD                                   BIGF 140                                                         
CCC                                                                     BIGF 150                                                         
      DIMENSION F(N)                                                    BIGF 160                                                         
      BIG=1.0E-14                                                       BIGF 170                                                         
      DO 10 I=1,N                                                       BIGF 180                                                         
      IF(F(I) .GT. BIG) BIG=F(I)                                        BIGF 190                                                         
   10 CONTINUE                                                          BIGF 200                                                         
      RETURN                                                            BIGF 210                                                         
      END                                                               BIGF 220                                                         
      SUBROUTINE INTLOG(XA, YA, NA,  XB, YB, NB)                        INTL 100                                                         
C                                                                       INTL 110                                                         
C    THIS TAKES A SET OF DATA POINTS XA(I) VS YA(I) (I=1,..,NA)         INTL 120                                                         
C      AND GIVEN ANOTHER SET OF Y VALUES@D  YB(I) ,  J=1,..,NB           INTL 130                                                        
C      FINDS THE CORRESPONDING X VALUES@D  XB(J).                        INTL 140                                                        
C                                                                       INTL 150                                                         
C     INTERPOLATES UNDER THE ASSUMPTION@D  X = X0*EXP(-Y/H)              INTL 160                                                        
C                                                                       INTL 170                                                         
C    NOTE@D  MUST HAVE YA(1) .LE. YB(1)&  YA(NA) .GE. YB(NB)             INTL 180                                                        
C        WHERE THE Y'S ARE IN ASCENDING ORDER                           INTL 190                                                         
C                                                                       INTL 200                                                         
      DIMENSION XA(NA), YA(NA),  XB(NB), YB(NB)                         INTL 210                                                         
C                                                                       INTL 220                                                         
      I = 1                                                             INTL 230                                                         
      DO 50 J = 1,NB                                                    INTL 240                                                         
    5 IF(I. GE. NA) I = NA                                              INTL*242                                                         
      IF(YB(J)-YA(I) ) 20, 40, 10                                       INTL*250                                                         
   10 IF(I .EQ. NA) GO TO 25                                            INTL 260                                                         
      I = I + 1                                                         INTL 270                                                         
      IF(YB(J) .GT. YA(I) ) GO TO 5                                     INTL 280                                                         
      GO TO 25                                                          INTL 290                                                         
   20 IF(I .EQ. 1) I = 2                                                INTL 300                                                         
   25 II = I - 1                                                        INTL 310                                                         
      IF(XA(I)*XA(II) .LE. 0. ) GO TO 30                                INTL 320                                                         
      Z = XA(I)/XA(II)                                                  INTL 330                                                         
      IF( ABS(Z-1.) .LT. 0.1 ) GO TO 30                                 INTL 340                                                         
      H = (YA(I) -YA(II) )/ALOG(Z)                                      INTL 350                                                         
      TEST =  (YB(J)-YA(II) )/H                                         INTL 352                                                         
      IF( TEST .GT. 200.) GO TO 30                                      INTL 354                                                         
CC     TEST MACJHINE DEPENDENT                                          INTL 356                                                         
C                                                                       INTL 358                                                         
      XB(J) = XA(II)*EXP( TEST)                                         INTL*360                                                         
      GO TO 50                                                          INTL 370                                                         
   30 XB(J) = XA(II) + (XA(I)-XA(II) )*(YB(J)-YA(II) )/(YA(I)-YA(II) )  INTL 380                                                         
      GO TO 50                                                          INTL 390                                                         
   40 XB(J) = XA(I)                                                     INTL 400                                                         
      I = I + 1                                                         INTL 410                                                         
   50 CONTINUE                                                          INTL 420                                                         
      RETURN                                                            INTL 430                                                         
      END                                                               INTL 440                                                         
      SUBROUTINE WAVEN(WAVE, FF, NW)                                    WAVN 100                                                         
      DIMENSION WAVE(NW), FF(NW)                                        WAVN 110                                                         
C                                                                       WAVN 120                                                         
C        THIS SUBROUTINE CONVERTS AN  ARRAY OF WAVELENGTHS TO           WAVN 130                                                         
C        AN ARRAY OF WAVENUMBERS, REVERSING THE ORDER OF THE WAVENUMBERSWAVN 140                                                         
C        IN THE PROCESS.                                                WAVN 150                                                         
C                                                                       WAVN 160                                                         
      M = NW/2                                                          WAVN 170                                                         
      DO 200 I=1,M                                                      WAVN 180                                                         
      K = NW-I+1                                                        WAVN 190                                                         
      FREQ = 1.E4/WAVE(I)                                               WAVN 200                                                         
      WAVE(I) = 1.E4/WAVE(K)                                            WAVN 210                                                         
      WAVE(K) = FREQ                                                    WAVN 220                                                         
      FS = FF(I)                                                        WAVN 230                                                         
      FF(I) = FF(K)                                                     WAVN 240                                                         
      FF(K) = FS                                                        WAVN 250                                                         
  200 CONTINUE                                                          WAVN 260                                                         
      L = 2*M                                                           WAVN 270                                                         
      IF(L .LT. NW) GO TO 300                                           WAVN 280                                                         
      GO TO 400                                                         WAVN 290                                                         
  300 WAVE(I) = 1.E4/WAVE(I)                                            WAVN 300                                                         
  400 RETURN                                                            WAVN 310                                                         
      END                                                               WAVN 320                                                         
      SUBROUTINE BRACK(WVN1, VIN, NW, DV, IFRST, LAST, NUMBER)          BRAC 100                                                         
      DIMENSION VIN(NW)                                                 BRAC 110                                                         
C                                                                       BRAC 120                                                         
C        PICKS OUT THE APPROPRIATE INDEXES OF A LARGER ARRAY            BRAC 130                                                         
C        CORRESPONDING TO THE POSITIONING OF A SMALLER ARRAY.           BRAC 140                                                         
C                                                                       BRAC 150                                                         
      IFRST = INT((VIN(1) - WVN1)/DV) + 1                               BRAC 160                                                         
      LAST = INT((VIN(NW) - WVN1)/DV) + 2                               BRAC 170                                                         
      IF(IFRST .LT. 1)IFRST = 1                                                                                                          
      NUMBER = LAST - IFRST + 1                                         BRAC 180                                                         
      PRINT*,' IFRST LAST NUMBER ',IFRST,LAST,NUMBER                                                                                     
      RETURN                                                            BRAC 190                                                         
      END                                                               BRAC 200                                                         
      SUBROUTINE BLKBDY(TEMP, FF, NW, WAVE)                             BB   100                                                         
C                                                                       BB   110                                                         
C     THIS SUBROUTINE MODIFIES THE FUNCTION "FF" BY INCORPORATING THE   BB   120                                                         
C      ASSOCIATED WAVENUMBER ARRAY AND A FIXED BLACKBODY TEMPERATURE    BB   130                                                         
C      INTO THE BLACKBODY EQUATION.                                     BB   140                                                         
C                                                                       BB   150                                                         
      DIMENSION FF(NW), WAVE(NW)                                        BB   160                                                         
      IF(TEMP.LE.0.0) GO TO 301                                         BB   170                                                         
      DO 200 I=1,NW                                                     BB   180                                                         
      FF(I) = (1.190956E-12*WAVE(I)**3)/(EXP(1.43879*WAVE(I)/TEMP) - 1.)BB   190                                                         
     + *FF(I)                                                           BB   200                                                         
  200 CONTINUE                                                          BB   210                                                         
      RETURN                                                            BB   220                                                         
  301 WRITE (6,901)                                                     BB   230                                                         
  901 FORMAT(/5X,48HNO BLACKBODY CALCULATION AS TEMP IS ZERO OR LESS/,  BB   240                                                         
     +5X,32HTEMP SHOULD BE IN DEGREES KELVIN/)                          BB   250                                                         
      RETURN                                                            BB   260                                                         
      END                                                               BB   270                                                         
      SUBROUTINE COMBT(F, T, N, IA, WAT, GAS)                           COMT 100                                                         
C                                                                       COMT 110                                                         
C        THIS SUBROUTINE COMBINES THE WATER BAND AND WATER CONTINUUM TO COMT 120                                                         
C        GET THE WATER TRANSMITTANCE, COMBINES THE GAS TRANSMITTANCES TOCOMT 130                                                         
C        GET THE UNIFORMLY MIXED GASES TRANSMITTANCE, THEN INTEGRATES   COMT 140                                                         
C        BOTH TRANSMITTANCES WITH THE FILTER RESPONSES TO GET THE       COMT 150                                                         
C        WEIGHTED GAS AND WATER TRANSMITTANCE                           COMT 160                                                         
C                                                                       COMT 170                                                         
      DIMENSION F(2300), T(2300,11), WTRN(990), GTRN(990)               COMT 180                                                         
      IB = IA + N                                                       COMT 190                                                         
      DO 200 L=IA, IB                                                   COMT 200                                                         
      LL=L-IA+1                                                         COMT 210                                                         
      WTRN(LL) = T(L,7)*T(L,2)                                          COMT 220                                                         
      GTRN(LL) = T(L,3)*T(L,4)*T(L,5)*T(L,6)*T(L,8)*T(L,10)             COMT 230                                                         
  200 CONTINUE                                                          COMT 240                                                         
      CALL INTGRT(F, WTRN, N, WAT)                                      COMT 250                                                         
      CALL INTGRT(F, GTRN, N, GAS)                                      COMT 260                                                         
      RETURN                                                            COMT 270                                                         
      END                                                               COMT 280                                                         
