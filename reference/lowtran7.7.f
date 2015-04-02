      PROGRAM LOWPLT                                                    LPL  100                                                         
CCC                                                                     LPL  110                                                         
CCC                                                                     LPL  120                                                         
CCC   *******  LOWTRAN 7 PLOT PROGRAM  ***********************          LPL  130                                                         
CCC                                                                     LPL  140                                                         
CCC   PROGRAM WRITTEN BY                                                LPL  150                                                         
CCC                        FRANCIS X. KNEIZYS     OPI/AFGL              LPL  160                                                         
CCC                        JAMES H. CHETWYND JR.  OPI/AFGL              LPL  170                                                         
CCC                        LEONARD W. ABREU       OPI/AFGL              LPL  180                                                         
CCC                        ERIC P. SHETTLE        OPA/AFGL              LPL  190                                                         
CCC                                                                     LPL  200                                                         
CCC                                                                     LPL  210                                                         
CCC   THE PLOT PROGRAM WILL PLOT SEVERAL FILES OF OUTPUT DATA FROM      LPL  220                                                         
CCC   TAPE 7 AS OUTPUT FROM  LOWTRAN 7 RUNS.                            LPL  230                                                         
CCC   TO INITIATE PROGRAM AN IDENTIFICATION CARD OF 30 HOLERITH         LPL  240                                                         
CCC   CHARACTERS IS READ IN FOLLOWED BY TWO CARDS DEFINING THE          LPL  250                                                         
CCC   AXIS,WAVELENGTHS,DELTA,LENGTH OF X AXIS AND Y AXIS AND            LPL  260                                                         
CCC   TYPE OF PLOT DESIRED.                                             LPL  270                                                         
CCC   THE FOURTH INPUT CARD IS READ IN SUBROUTINE PLTDTA                LPL  280                                                         
CCC   AND IT CONTROLS THE PLOTTING OF THE VARIOUS VARIABLES             LPL  290                                                         
CCC   OUTPUT BY LOWTRAN SIX                                             LPL  300                                                         
CCC   THE FIFTH INPUT CARD IS READ AFTER PLOTTING AND                   LPL  310                                                         
CCC   IT DETERMINES WHETHER PLOTTING ON THE SAME PLOT IS DESIRED        LPL  320                                                         
CCC   AND ALSO DETERMINES WHETHER TO REWIND AND PLOT THE SAME FILE      LPL  330                                                         
CCC                                                                     LPL  340                                                         
CCC   TO PLOT MULTIPLE FILES FROM TAPE 7;                               LPL  350                                                         
CCC   THE FOUR INPUT CARDS MUST BE INPUT FOR EACH FILE TO BE PLOTTED    LPL  360                                                         
CCC                                                                     LPL  370                                                         
CCC   TO END PLOTS;                                                     LPL  380                                                         
CCC   SET XSIZE=NEGATIVE ON LAST INPUT CARD.                            LPL  390                                                         
CCC                                                                     LPL  400                                                         
CCC   ***********************************************************       LPL  410                                                         
CCC                                                                     LPL  420                                                         
CCC                                                                     LPL  430                                                         
      COMMON /IFIL/ IRD,IPR,IPU,IMULT                                   LPL  440                                                         
      COMMON /DXDY/ DX,ADY,PFRBEG,YRMIN,IXAXIS,IYAXIS,PFREND,YRMAX,     LPL  450                                                         
     C ITYP,IYPWR,IEMSCT                                                LPL  460                                                         
      CHARACTER PROGID*30,ATIT*8,V1V2DV*8                               LPL  470                                                         
      CHARACTER ACRD1*80,ACRD2*80,ACRD2A*80,ACRD2B*80,ACRD2C*80         LPL  480                                                         
      CHARACTER ACRD3*80,ACRD3O*80,ACD3A1*80,ACD3A2*80,ACRD4*80         LPL  490                                                         
      CHARACTER DUMMY*80                                                LPL  500                                                         
      CHARACTER RADC*40,RADM*40,RADCLG*30,RADMLG*30,WAVL*20             LPL  510                                                         
      CHARACTER RADMD*40,RADMDL*30,RADCD*40,RADCDL*30                   LPL  520                                                         
      CHARACTER WAVN*20,TRAN*20                                         LPL  530                                                         
      CHARACTER CARD1*68,CARD2*61,CARD2A*21,CARD2B*20,CARD3*30          LPL  540                                                         
      CHARACTER CARD3O*30,CRD3A1*30,CRD3A2*50                           LPL  550                                                         
      DATA RADC/'RADIANCE(WATTS/CM2-STER-CM-1)'/                        LPL  560                                                         
      DATA RADM/'RADIANCE(WATTS/CM2-STER-MICR)'/                        LPL  570                                                         
      DATA RADCLG/'RADIANCE(WATTS/CM2-STER-CM-1)'/                      LPL  580                                                         
      DATA RADMLG/'RADIANCE(WATTS/CM2-STER-MICR)'/                      LPL  590                                                         
      DATA RADMD/'IRRADIANCE(WATTS/CM2-MICR)' /                         LPL  600                                                         
      DATA RADMDL/'IRRADIANCE(WATTS/CM2-MICR)'/                         LPL  610                                                         
      DATA RADCD/'IRRADIANCE(WATTS/CM2-CM-1)'/                          LPL  620                                                         
      DATA RADCDL/'IRRADIANCE(WATTS/CM2-CM-1)'/                         LPL  630                                                         
      DATA WAVL/'WAVELENGTH (MICRON)' /                                 LPL  640                                                         
      DATA WAVN/'WAVENUMBER  (CM-1)'  /                                 LPL  650                                                         
      DATA TRAN/'TRANSMITTANCE'/                                        LPL  660                                                         
      DATA CARD1/'MODEL,ITYPE,IEMSCT,IMULT,M1,M2,M3,M4,M5,M6,MDEF,IM,NOPLPL  670                                                         
     1RT,TBOUND,SALB '/                                                 LPL  680                                                         
      DATA CARD2                                                        LPL  690                                                         
     X/'IHAZE,ISEASN,IVULCN,ICSTL,ICLD,IVSA,VIS,WSS,WHH,RAINRT,GNDALT'/ LPL  700                                                         
C                                                                       LPL  710                                                         
      DATA CARD2A/'CTHIK,CALT,CEXT,ISEED'/                              LPL  720                                                         
      DATA CARD2B/'ZCVSA,ZTVSA,ZINVSA'/                                 LPL  730                                                         
      DATA CARD3/'H1,H2,ANGLE,RANGE,BETA,RO,LEN'/                       LPL  740                                                         
      DATA CARD3O/'H1,P,T,H2O,CO2,O3,AHAZE,RANGE'/                      LPL  750                                                         
      DATA CRD3A1/'IPARM,IPH,IDAY,ISOURC '/                             LPL  760                                                         
      DATA CRD3A2/'PARM1,PARM2,PARM3,PARM4,TIME,PSIPO,ANGLEM,G'/        LPL  770                                                         
CCC                                                                     LPL  780                                                         
CCC   ITYP=0     RADIANCE PER MICRON VS MICRONS                         LPL  790                                                         
CCC   ITYP=1     RADIANCE PER CM-1 VS CM-1                              LPL  800                                                         
CCC   ITYP=2     TRANSMITTANCE VS MICRONS                               LPL  810                                                         
CCC   ITYP=3     TRANSMITTANCE VS CM-1                                  LPL  820                                                         
CCC                                                                     LPL  830                                                         
CCC   IXAXIS=0     X-AXIS WILL BE LINEAR                                LPL  840                                                         
CCC   IXAXIS=1     X-AXIS WILL BE LOG10                                 LPL  850                                                         
CCC   IYAXIS=0     Y-AXIS WILL BE LINEAR                                LPL  860                                                         
CCC   IYAXIS=1     Y-AXIS WILL BE LOG10                                 LPL  870                                                         
CCC                                                                     LPL  880                                                         
      IRD = 5                                                           LPL  890                                                         
      IPR = 6                                                           LPL  900                                                         
      IPU = 7                                                           LPL  910                                                         
      OPEN(IRD,FILE='TAPE5',STATUS='UNKNOWN')                           LPL  920                                                         
      OPEN(IPR,FILE='TAPE6',STATUS='UNKNOWN')                           LPL  930                                                         
      OPEN(IPU,FILE='TAPE7',STATUS='UNKNOWN')                           LPL  940                                                         
      IEOF=0                                                            LPL  950                                                         
      ISAMPT=0                                                          LPL  960                                                         
      IRPT=1                                                            LPL  970                                                         
      READ (IRD,80)   PROGID,SCALE                                      LPL  980                                                         
      WRITE (IPR,85)  PROGID,SCALE                                      LPL  990                                                         
      CALL PLTID3(PROGID,900.0,11.0,SCALE)                              LPL 1000                                                         
CC    CALL PLOTS                                                        LPL 1010                                                         
CC    CALL PLOT(0., 0., 999)                                            LPL 1020                                                         
      CALL PLOT(1.0,1.0,-3)                                             LPL 1030                                                         
CCC                                                                     LPL 1040                                                         
CCC   XSIZE=LENGTH OF X-AXIS IN INCHES                                  LPL 1050                                                         
CCC   PFRBEG=BEGINNING FREQUENCY ON PLOT IN CM-1 OR MICRONS             LPL 1060                                                         
CCC   PFREND=ENDING FREQUENCY ON PLOT IN CM-1 OR MICRONS                LPL 1070                                                         
CCC   IF PLOTTING X AXIS LOGARITHMICALLY THEN PFRBEG AND PFREND         LPL 1080                                                         
CCC   BECOME LOGARITHMS BASE 10 OF MIN AND MAX FOR FREQUENCY SCALE      LPL 1090                                                         
CCC   DX=(PFREND-PFRBEG)/XSIZE                                          LPL 1100                                                         
CCC   ADV=NO. OF DIVISIONS IN TEN INCHES OF PAPER                       LPL 1110                                                         
CCC    YRMIN AND YRMAX ARE LOGARITHMS BASE 10 OF MINIMUM AND MAXIMUM    LPL 1120                                                         
CCC   RADIATION VALUES WHICH CAN BE PLOTTED                             LPL 1130                                                         
CCC   IN PLOTTING TRANSMITTANCE OR RADIANCE LINEARLY                    LPL 1140                                                         
CCC   YRMIN AND YRMAX BECOME THE LIMITING VALUES OF THE YAXIS.          LPL 1150                                                         
CCC   NMYDEC SPECIFIES THE NUMBER OF DECIMAL PLACES ON A LINEAR YAXIS   LPL 1160                                                         
CCC                                                                     LPL 1170                                                         
        REWIND 7                                                        LPL 1180                                                         
5     READ (IRD,88) XSIZE,PFRBEG,PFREND,DELTAX,ITYP,IXAXIS,NUMFIL       LPL 1190                                                         
      IF(XSIZE.LE.0.) GO TO 999                                         LPL 1200                                                         
      WRITE (IPR,90) XSIZE,PFRBEG,PFREND,DELTAX,ITYP,IXAXIS,NUMFIL      LPL 1210                                                         
      DX=(PFREND-PFRBEG)/XSIZE                                          LPL 1220                                                         
      ANUMX=(PFREND-PFRBEG)/DELTAX                                      LPL 1230                                                         
       NUMX=ANUMX+.5                                                    LPL 1240                                                         
      DIVLX=XSIZE/ANUMX                                                 LPL 1250                                                         
       READ (IRD,89) YSIZE,YRMIN,YRMAX,DELTAY,ICRV,IYAXIS,NMYDEC        LPL 1260                                                         
      IF(DELTAY .LE. 0.0) DELTAY=1.0                                    LPL 1270                                                         
      ADY =(YRMAX-YRMIN)/YSIZE                                          LPL 1280                                                         
      ANUMY=(YRMAX-YRMIN)/DELTAY                                        LPL 1290                                                         
       NUMY=ANUMY+.5                                                    LPL 1300                                                         
      DIVLY=YSIZE/ANUMY                                                 LPL 1310                                                         
      WRITE (IPR,92) YSIZE,YRMIN,YRMAX,DELTAY,ICRV,IYAXIS,NMYDEC        LPL 1320                                                         
CCC                                                                     LPL 1330                                                         
CCC   NUMFIL CONTROLS SPECIFIC FILE NO. OF LOWTRAN TAPE 7 DATA          LPL 1340                                                         
CCC   TO BE PLOTTED.                                                    LPL 1350                                                         
CCC                                                                     LPL 1360                                                         
CCC   IF NUMFIL=0      IT WILL PLOT THE NEXT AVAILABLE FILE OF DATA.    LPL 1370                                                         
CCC   IF NUMFIL>0 IT WILL PLOT FROM THE NUMBERED FILE                   LPL 1380                                                         
CCC   SPECIFIED BY NUMFIL.                                              LPL 1390                                                         
CCC                                                                     LPL 1400                                                         
      IF(NUMFIL.GT.0) IEOF=NUMFIL-1                                     LPL 1410                                                         
      IF(NUMFIL.LT.1) GO TO 12                                          LPL 1420                                                         
      REWIND 7                                                          LPL 1430                                                         
      NNF=1                                                             LPL 1440                                                         
      IF(NUMFIL.EQ.NNF) GO TO 12                                        LPL 1450                                                         
8     DO 9 I=1,11                                                       LPL 1460                                                         
      READ (7,101) DUMMY                                                LPL 1470                                                         
9     CONTINUE                                                          LPL 1480                                                         
11    READ (7,99) DUM                                                   LPL 1490                                                         
      IF(DUM.NE.-9999.) GO TO 11                                        LPL 1500                                                         
      NNF=NNF+1                                                         LPL 1510                                                         
      IF(NUMFIL.EQ.NNF) GO TO 12                                        LPL 1520                                                         
      GO TO 8                                                           LPL 1530                                                         
12    CONTINUE                                                          LPL 1540                                                         
CCC                                                                     LPL 1550                                                         
CCC   THE LOWTRAN 7 PLOT PROGRAM EXPECTS TEN INPUT CARDS ON TAPE 7      LPL 1560                                                         
CCC   WHICH WAS GENERATED FROM A LOWTRAN RUN.                           LPL 1570                                                         
CCC   THERE CAN BE SEVERAL SETS OF DATA AND INPUT CARDS SEPERATED BY    LPL 1580                                                         
CCC   AN END OF FILE, WHICH IS CODED -9999. IN COL. 1-6                 LPL 1590                                                         
CCC   THE INPUT CARDS ARE AS LISTED IN THE LOWTRAN INSTRUCTIONS         LPL 1600                                                         
CCC   THE MANDATORY CARDS OUTPUT TO TAPE 7 ARE                          LPL 1610                                                         
CCC   CARD1,CARD2,CARD2A,CARD2B,CARD2C,CARD3, OR OPTIONAL CARD3         LPL 1620                                                         
CCC   (MODEL=0), CARD3A1,CARD3A2,CARD4 AND CARD5.                       LPL 1630                                                         
CCC   IN A GIVEN RUN SEVERAL OF THESE CARDS MAY NOT BE UTILIZED         LPL 1640                                                         
CCC   IN THAT EVENT THEIR VARIABLES WILL BE REPRESENTED BY -99          LPL 1650                                                         
CCC                                                                     LPL 1660                                                         
CCC   IN THE OUTPUT DATA ON TAPE 7 DURING A NORMAL EMISSION RUN FOR     LPL 1670                                                         
CCC   EXAMPLE SEVERAL OF THE VARIABLES ARE NOT UTILIZED IN THIS CASE    LPL 1680                                                         
CCC   THEIR VARIABLES WILL BE REPRESENTED BY -99 ALSO.                  LPL 1690                                                         
CCC                                                                     LPL 1700                                                         
CCC                                                                     LPL 1710                                                         
CCC   READING AND WRITING INPUT CARDS TO THE PLOT                       LPL 1720                                                         
CCC                                                                     LPL 1730                                                         
CCC                                                                     LPL 1740                                                         
      IF(ISAMPT.GT.0) GO TO 13                                          LPL 1750                                                         
      READ(7,1110)  MODEL,ITYPE,IEMSCT,IMULT,M1,M2,M3,                  LPL 1760                                                         
     1 M4,M5,M6,MDEF,IM,NOPRT,TBOUND,SALB                               LPL 1770                                                         
1110  FORMAT(13I5,F8.3,F7.2)                                            LPL 1780                                                         
      BACKSPACE 7                                                       LPL 1790                                                         
      READ (7,101) ACRD1                                                LPL 1800                                                         
      IF(IEMSCT.EQ.0) WRITE (IPR,102)                                   LPL 1810                                                         
      IF(IEMSCT.EQ.1) WRITE (IPR,103)                                   LPL 1820                                                         
      IF(IEMSCT.EQ.2) WRITE (IPR,104)                                   LPL 1830                                                         
      IF(IEMSCT.EQ.3) WRITE (IPR,105)                                   LPL 1840                                                         
      WRITE(IPR,1110) MODEL,ITYPE,IEMSCT,IMULT,M1,M2,M3,                LPL 1850                                                         
     1 M4,M5,M6,MDEF,IM,NOPRT,TBOUND,SALB                               LPL 1860                                                         
      YT=7.0                                                            LPL 1870                                                         
      XT=1.                                                             LPL 1880                                                         
      CALL SYMBOL(XT,YT,0.12,     CARD1 ,0.0,68)                        LPL 1890                                                         
      YT=YT-0.2                                                         LPL 1900                                                         
      CALL SYMBOL(XT ,YT,0.12,     ACRD1 ,0.0,80)                       LPL 1910                                                         
      READ (7,101 ) ACRD2                                               LPL 1920                                                         
      WRITE (IPR,101) ACRD2                                             LPL 1930                                                         
      YT=YT-0.4                                                         LPL 1940                                                         
      CALL SYMBOL(XT,YT,0.12,     CARD2 ,0.0,61)                        LPL 1950                                                         
      YT=YT-0.2                                                         LPL 1960                                                         
      CALL SYMBOL(XT,YT,0.12,     ACRD2 ,0.0,80)                        LPL 1970                                                         
      READ (7,101 ) ACRD2A                                              LPL 1980                                                         
      WRITE (IPR,101) ACRD2A                                            LPL 1990                                                         
      YT=YT-0.4                                                         LPL 2000                                                         
      CALL SYMBOL(XT,YT,0.12,     CARD2A ,0.0,21)                       LPL 2010                                                         
      YT=YT-0.2                                                         LPL 2020                                                         
      CALL SYMBOL(XT,YT,0.12,     ACRD2A ,0.0,80)                       LPL 2030                                                         
      READ (7,101 ) ACRD2B                                              LPL 2040                                                         
      WRITE (IPR,101) ACRD2B                                            LPL 2050                                                         
      YT=YT-0.4                                                         LPL 2060                                                         
      CALL SYMBOL(XT,YT,0.12,     CARD2B ,0.0,18)                       LPL 2070                                                         
      YT=YT-0.2                                                         LPL 2080                                                         
      CALL SYMBOL(XT,YT,0.12,     ACRD2B ,0.0,80)                       LPL 2090                                                         
      READ (7,101 ) ACRD2C                                              LPL 2100                                                         
      WRITE (IPR,101) ACRD2C                                            LPL 2110                                                         
      YT=YT-0.4                                                         LPL 2120                                                         
      ATIT = 'ML,TITLE'                                                 LPL 2130                                                         
      CALL SYMBOL(XT,YT,0.12,     ATIT ,0.0,8)                          LPL 2140                                                         
      YT=YT-0.2                                                         LPL 2150                                                         
      CALL SYMBOL(XT,YT,0.12,     ACRD2C ,0.0,80)                       LPL 2160                                                         
      IF(MODEL.NE.0) READ (7,101 ) ACRD3                                LPL 2170                                                         
      IF(MODEL.NE.0) WRITE (IPR,101) ACRD3                              LPL 2180                                                         
      IF(MODEL.EQ.0) READ (7,101 ) ACRD3O                               LPL 2190                                                         
      IF(MODEL.EQ.0) WRITE (IPR,101) ACRD3O                             LPL 2200                                                         
      YT=YT-0.4                                                         LPL 2210                                                         
      IF(MODEL.NE.0) CALL SYMBOL(XT,YT,0.12,     CARD3 ,0.0,29)         LPL 2220                                                         
      IF(MODEL.EQ.0) CALL SYMBOL(XT,YT,0.12,     CARD3O ,0.0,24)        LPL 2230                                                         
      YT=YT-0.2                                                         LPL 2240                                                         
      IF(MODEL.NE.0) CALL SYMBOL(XT,YT,0.12,     ACRD3 ,0.0,80)         LPL 2250                                                         
      IF(MODEL.EQ.0) CALL SYMBOL(XT,YT,0.12,     ACRD3O ,0.0,80)        LPL 2260                                                         
      READ (7,101 ) ACD3A1                                              LPL 2270                                                         
      WRITE (IPR,101) ACD3A1                                            LPL 2280                                                         
      YT=YT-0.4                                                         LPL 2290                                                         
      CALL SYMBOL(XT,YT,0.12,     CRD3A1 ,0.0,21)                       LPL 2300                                                         
      YT=YT-0.2                                                         LPL 2310                                                         
      CALL SYMBOL(XT,YT,0.12,     ACD3A1 ,0.0,80)                       LPL 2320                                                         
      READ (7,101 ) ACD3A2                                              LPL 2330                                                         
      WRITE (IPR,101) ACD3A2                                            LPL 2340                                                         
      YT=YT-0.4                                                         LPL 2350                                                         
      CALL SYMBOL(XT,YT,0.12,     CRD3A2 ,0.0,43)                       LPL 2360                                                         
      YT=YT-0.2                                                         LPL 2370                                                         
      CALL SYMBOL(XT,YT,0.12,     ACD3A2 ,0.0,80)                       LPL 2380                                                         
      READ (7,101 ) ACRD4                                               LPL 2390                                                         
      WRITE (IPR,101) ACRD4                                             LPL 2400                                                         
      YT=YT-0.4                                                         LPL 2410                                                         
      V1V2DV = 'V1,V2,DV'                                               LPL 2420                                                         
      CALL SYMBOL(XT,YT,0.12,     V1V2DV ,0.0,8)                        LPL 2430                                                         
      YT=YT-0.2                                                         LPL 2440                                                         
      CALL SYMBOL(XT,YT,0.12,     ACRD4 ,0.0,80)                        LPL 2450                                                         
      READ (7,500 ) IRPT                                                LPL 2460                                                         
      BACKSPACE 7                                                       LPL 2470                                                         
      READ (7,501 ) ACRD5                                               LPL 2480                                                         
      WRITE (IPR,501) ACRD5                                             LPL 2490                                                         
      YT=YT-0.4                                                         LPL 2500                                                         
      AIRPT = 4HIRPT                                                    LPL 2510                                                         
      CALL SYMBOL(XT,YT,0.12,     AIRPT ,0.0,4)                         LPL 2520                                                         
      YT=YT-0.2                                                         LPL 2530                                                         
      CALL SYMBOL(XT,YT,0.12,     ACRD5 ,0.0,5)                         LPL 2540                                                         
CCC                                                                     LPL 2550                                                         
CCC   SET UP TO PLOT                                                    LPL 2560                                                         
CCC                                                                     LPL 2570                                                         
      CALL PLOT(18.0,0.0,-3)                                            LPL 2580                                                         
CC    CALL PLOT(0. ,0., 999)                                            LPL 2590                                                         
CC    CALL PLOT(1. ,1.0, -3)                                            LPL 2600                                                         
      CALL PLOT(0.0,YSIZE,3)                                            LPL 2610                                                         
      CALL PLOT(XSIZE,YSIZE,2)                                          LPL 2620                                                         
      CALL PLOT(XSIZE,0.0,2)                                            LPL 2630                                                         
      CALL PLOT(0.,0.,2)                                                LPL 2640                                                         
      CALL PLOT(0.,YSIZE,2)                                             LPL 2650                                                         
      CALL PLOT(0.,YSIZE,3)                                             LPL 2660                                                         
CCC                                                                     LPL 2670                                                         
CCC   SET UP TO DRAW AXIS                                               LPL 2680                                                         
CCC                                                                     LPL 2690                                                         
      IYPWR=ALOG10(DELTAY)                                              LPL 2700                                                         
      NDECX = 1                                                         LPL 2710                                                         
      IF(DELTAX .LT.  0.1) NDECX = 2                                    LPL 2720                                                         
      IF(DELTAX .LT. 0.01) NDECX = 3                                    LPL 2730                                                         
       UMCX=PFREND-PFRBEG                                               LPL 2740                                                         
      CYCLX=XSIZE/UMCX                                                  LPL 2750                                                         
      NUMCX=UMCX                                                        LPL 2760                                                         
      CYCLX=XSIZE/FLOAT(NUMCX)                                          LPL 2770                                                         
      NUMCY=YRMAX-YRMIN                                                 LPL 2780                                                         
      IF(IYAXIS . GE. 1) THEN                                           LPL 2790                                                         
           CYCLY=YSIZE/FLOAT(NUMCY)                                     LPL 2800                                                         
      ENDIF                                                             LPL 2810                                                         
      IF((ITYP.EQ.0.OR.ITYP.EQ.2) .AND. IXAXIS.EQ.0)                    LPL 2820                                                         
     XCALL AXISL (0.0,0.0,WAVL,-20,NUMX,DIVLX,1,                        LPL 2830                                                         
     X PFRBEG,DELTAX,NDECX,0.,.125,1,0,0,0,0)                           LPL 2840                                                         
      IF((ITYP.EQ.0.OR.ITYP.EQ.2) .AND. IXAXIS.EQ.1)                    LPL 2850                                                         
     XCALL AXLOG(0.0,0.0,WAVL,-20,NUMCX,CYCLX,                          LPL 2860                                                         
     X PFRBEG,0.0,0.125,1,0,0,0,0)                                      LPL 2870                                                         
      IF((ITYP.EQ.1.OR.ITYP.EQ.3) .AND. IXAXIS.EQ.0)                    LPL 2880                                                         
     XCALL AXISL(0.0,0.0,WAVN,-20,NUMX,DIVLX,1,                         LPL 2890                                                         
     X PFRBEG,DELTAX,-1,0.,.125,1,0,0,0,0)                              LPL 2900                                                         
      IF((ITYP.EQ.1.OR.ITYP.EQ.3) .AND. IXAXIS.EQ.1)                    LPL 2910                                                         
     XCALL AXLOG(0.0,0.0,WAVN,-20,NUMCX,CYCLX,                          LPL 2920                                                         
     X PFRBEG,0.0,0.125,1,0,0,0,0)                                      LPL 2930                                                         
      IF(IEMSCT.EQ.3) GO TO 111                                         LPL 2940                                                         
      IF(ITYP.EQ.0 .AND. IYAXIS.EQ.0)                                   LPL 2950                                                         
     XCALL AXISL(0.,0.,RADM,29,NUMY,                                    LPL 2960                                                         
     XDIVLY,  5,YRMIN    ,DELTAY    ,NMYDEC,90.,0.15,1,1,0,0,0)         LPL 2970                                                         
      IF(ITYP.EQ.0 .AND. IYAXIS.EQ.1)                                   LPL 2980                                                         
     X   CALL AXLOG(0.,0.,RADMLG,29,NUMCY,CYCLY,                        LPL 2990                                                         
     X          YRMIN,90.,0.15,1,1,2,0,0)                               LPL 3000                                                         
      IF(ITYP.EQ.1 .AND. IYAXIS.EQ.0)                                   LPL 3010                                                         
     XCALL AXISL(0.,0.,RADC,29,NUMY,                                    LPL 3020                                                         
     XDIVLY,  5,YRMIN    ,DELTAY    ,NMYDEC,90.,0.15,1,1,0,0,0)         LPL 3030                                                         
      IF(ITYP .EQ.1 .AND. IYAXIS.EQ.1)                                  LPL 3040                                                         
     X   CALL AXLOG(0.,0.,RADCLG,29,NUMCY,CYCLY,                        LPL 3050                                                         
     X          YRMIN,90.,.15,1,1,2,0,0)                                LPL 3060                                                         
      IF((ITYP .EQ.2.OR.ITYP .EQ.3) .AND. IYAXIS.EQ.0)                  LPL 3070                                                         
     X  CALL AXISL(0.,0.,TRAN,13,NUMY,DIVLY,5,YRMIN,DELTAY,             LPL 3080                                                         
     XNMYDEC,90.0,.125,1,1,2,0,0)                                       LPL 3090                                                         
      IF((ITYP .EQ.2.OR.ITYP .EQ.3) .AND. IYAXIS.EQ.1)                  LPL 3100                                                         
     X    CALL AXLOG(0.,0.,TRAN,13,NUMCY,CYCLY,YRMIN,                   LPL 3110                                                         
     X 90.0,.125,1,1,0,0,0)                                             LPL 3120                                                         
      IF(ITYP .EQ.0 .AND. IYAXIS.EQ.0)                                  LPL 3130                                                         
     XCALL AXISL(XSIZE,0.,RADM,-29,                                     LPL 3140                                                         
     XNUMY, DIVLY,5,YRMIN    ,DELTAY    ,NMYDEC,90.,.15,1,1,0,0,0)      LPL 3150                                                         
      IF(ITYP .EQ.0 .AND. IYAXIS.EQ.1)                                  LPL 3160                                                         
     X    CALL AXLOG(XSIZE,0.,RADMLG,-29,NUMCY,                         LPL 3170                                                         
     X  CYCLY,YRMIN,90.,.15,1,1,2,0,0)                                  LPL 3180                                                         
      IF(ITYP .EQ.1 .AND. IYAXIS.EQ.0)                                  LPL 3190                                                         
     XCALL AXISL(XSIZE,0.,RADC,-29,                                     LPL 3200                                                         
     XNUMY, DIVLY,5,YRMIN    ,DELTAY    ,NMYDEC,90.,.15,1,1,0,0,0)      LPL 3210                                                         
      IF(ITYP .EQ.1 .AND. IYAXIS.EQ.1)                                  LPL 3220                                                         
     X     CALL AXLOG(XSIZE,0.,RADCLG,-29,NUMCY,                        LPL 3230                                                         
     X  CYCLY,YRMIN,90.,.15,1,1,2,0,0)                                  LPL 3240                                                         
      IF((ITYP .EQ.2.OR.ITYP .EQ.3) .AND. IYAXIS.EQ.0)                  LPL 3250                                                         
     X  CALL AXISL(XSIZE,0.,TRAN,-13,NUMY,DIVLY,5,YRMIN,                LPL 3260                                                         
     XDELTAY,NMYDEC,90.0,.125,1,1,2,0,0)                                LPL 3270                                                         
      IF((ITYP .EQ.2.OR.ITYP .EQ.3) .AND. IYAXIS.EQ.1)                  LPL 3280                                                         
     X    CALL AXLOG(XSIZE,0.,TRAN,-13,NUMCY,CYCLY,YRMIN,               LPL 3290                                                         
     X 90.0,.125,1,1,0,0,0)                                             LPL 3300                                                         
      GO TO 16                                                          LPL 3310                                                         
111   IF(ITYP.EQ.0 .AND. IYAXIS.EQ.0)                                   LPL 3320                                                         
     XCALL AXISL(0.,0.,RADMD,27,NUMY,                                   LPL 3330                                                         
     XDIVLY,  5,YRMIN    ,DELTAY    ,NMYDEC,90.,0.15,1,1,0,0,0)         LPL 3340                                                         
      IF(ITYP.EQ.0 .AND. IYAXIS.EQ.1)                                   LPL 3350                                                         
     XCALL AXLOG(0.,0.,RADMDL,26,NUMCY,CYCLY,                           LPL 3360                                                         
     X          YRMIN,90.,0.15,1,1,2,0,0)                               LPL 3370                                                         
      IF(ITYP.EQ.1 .AND. IYAXIS.EQ.0)                                   LPL 3380                                                         
     XCALL AXISL(0.,0.,RADCD,27,NUMY,                                   LPL 3390                                                         
     XDIVLY,  5,YRMIN    ,DELTAY    ,NMYDEC,90.,0.15,1,1,0,0,0)         LPL 3400                                                         
      IF(ITYP .EQ.1 .AND. IYAXIS.EQ.1)                                  LPL 3410                                                         
     XCALL AXLOG(0.,0.,RADCDL,26,NUMCY,CYCLY,                           LPL 3420                                                         
     X          YRMIN,90.,.15,1,1,2,0,0)                                LPL 3430                                                         
      IF(ITYP .EQ.0 .AND. IYAXIS.EQ.0)                                  LPL 3440                                                         
     XCALL AXISL(XSIZE,0.,RADMD,-27,                                    LPL 3450                                                         
     XNUMY, DIVLY,5,YRMIN    ,DELTAY    ,NMYDEC,90.,.15,1,1,0,0,0)      LPL 3460                                                         
      IF(ITYP .EQ.0 .AND. IYAXIS.EQ.1)                                  LPL 3470                                                         
     XCALL AXLOG(XSIZE,0.,RADMDL,-26,NUMCY,                             LPL 3480                                                         
     X  CYCLY,YRMIN,90.,.15,1,1,2,0,0)                                  LPL 3490                                                         
      IF(ITYP .EQ.1 .AND. IYAXIS.EQ.0)                                  LPL 3500                                                         
     XCALL AXISL(XSIZE,0.,RADCD,-27,                                    LPL 3510                                                         
     XNUMY, DIVLY,5,YRMIN    ,DELTAY    ,NMYDEC,90.,.15,1,1,0,0,0)      LPL 3520                                                         
      IF(ITYP .EQ.1 .AND. IYAXIS.EQ.1)                                  LPL 3530                                                         
     XCALL AXLOG(XSIZE,0.,RADCDL,-26,NUMCY,                             LPL 3540                                                         
     X  CYCLY,YRMIN,90.,.15,1,1,2,0,0)                                  LPL 3550                                                         
      GO TO 16                                                          LPL 3560                                                         
CCC                                                                     LPL 3570                                                         
CCC   READ AROUND HEADER RECORDS AS FILE IS PLOTTED ON SAME PLOT        LPL 3580                                                         
CCC                                                                     LPL 3590                                                         
13    DO 14 I=1,10                                                      LPL 3600                                                         
      READ (7,101) DUMMY                                                LPL 3610                                                         
      WRITE (IPR,101) DUMMY                                             LPL 3620                                                         
14    CONTINUE                                                          LPL 3630                                                         
16    CONTINUE                                                          LPL 3640                                                         
CCC                                                                     LPL 3650                                                         
CCC   READ IN DATA TO BE PLOTTED                                        LPL 3660                                                         
CCC                                                                     LPL 3670                                                         
CCC   ITRP CONTROLS THE PLOT OF TRANSMISSION VARIABLES                  LPL 3680                                                         
CCC   ITRP=0  PLOTS TOTAL TRANSMISSION                                  LPL 3690                                                         
CCC   ITRP=1-7 PLOTS H2O,CO2,OZONE,N2CONT,H2OCONT,MOLSCT,AERTRN         LPL 3700                                                         
CCC                                                                     LPL 3710                                                         
       XT=0.                                                            LPL 3720                                                         
CCC                                                                     LPL 3730                                                         
CCC   SUBROUTINE PLTDTA IS CALLED  TO IMPLEMENT THE READING             LPL 3740                                                         
CCC   IN AND PLOTTING OF TRANSMISSION AND OR EMISSION VALUES            LPL 3750                                                         
CCC   FROM TAPE7.                                                       LPL 3760                                                         
CCC                                                                     LPL 3770                                                         
      CALL PLTDTA(ICRV,IEOF)                                            LPL 3780                                                         
CCC                                                                     LPL 3790                                                         
CCC   ISAMFL=0  NORMAL ADVANCE TO NEXT FILE                             LPL 3800                                                         
CCC   ISAMFL=1  REWIND AND GO TO SAME FILE                              LPL 3810                                                         
CCC                                                                     LPL 3820                                                         
CCC   ISAMPT=0  NORMAL ADVANCE TO NEXT PLOT                             LPL 3830                                                         
CCC   ISAMPT=1  PLOT ON SAME PLOT                                       LPL 3840                                                         
CCC                                                                     LPL 3850                                                         
CCC   ISAMFL AND ISAMPT ARE SET TO HANDLE THE NEXT FILE OF DATA         LPL 3860                                                         
CCC   TO BE PLOTTED.                                                    LPL 3870                                                         
CCC                                                                     LPL 3880                                                         
      READ (IRD,94) ISAMFL,ISAMPT                                       LPL 3890                                                         
      WRITE (IPR,94) ISAMFL,ISAMPT                                      LPL 3900                                                         
      IF(ISAMFL.GT.0) GO TO 63                                          LPL 3910                                                         
61    IF(ISAMPT.GT.0) GO TO 62                                          LPL 3920                                                         
      XT=XSIZE+2.0                                                      LPL 3930                                                         
      CALL PLOT(XT,0.0,-3)                                              LPL 3940                                                         
62    CONTINUE                                                          LPL 3950                                                         
CCC                                                                     LPL 3960                                                         
CCC   RECYCYCLE TO PLOT THE NEXT FILE OF DATA                           LPL 3970                                                         
CCC                                                                     LPL 3980                                                         
      GO TO 5                                                           LPL 3990                                                         
63    CONTINUE                                                          LPL 4000                                                         
      IF(IEOF.NE.1) GO TO 64                                            LPL 4010                                                         
      REWIND 7                                                          LPL 4020                                                         
      GO TO 61                                                          LPL 4030                                                         
64    NEOF=1                                                            LPL 4040                                                         
      REWIND 7                                                          LPL 4050                                                         
65    DO 66 I=1,11                                                      LPL 4060                                                         
      READ (7,101) DUMMY                                                LPL 4070                                                         
66    CONTINUE                                                          LPL 4080                                                         
67    READ (7,99) DUM                                                   LPL 4090                                                         
      IF(DUM.NE.-9999.) GO TO 67                                        LPL 4100                                                         
      NEOF=NEOF+1                                                       LPL 4110                                                         
      IF(IEOF.EQ.NEOF) GO TO 69                                         LPL 4120                                                         
      GO TO 65                                                          LPL 4130                                                         
69    IEOF=IEOF-1                                                       LPL 4140                                                         
      GO TO 61                                                          LPL 4150                                                         
CCC                                                                     LPL 4160                                                         
CCC   PLOTTING OVER GO TO END                                           LPL 4170                                                         
CCC                                                                     LPL 4180                                                         
999   CONTINUE                                                          LPL 4190                                                         
      CALL PLOT(XT,0.0,-3)                                              LPL 4200                                                         
CCC                                                                     LPL 4210                                                         
CCC                                                                     LPL 4220                                                         
80    FORMAT(A30,F10.4)                                                 LPL 4230                                                         
85    FORMAT(1H1,5X,A30,F10.4//)                                        LPL 4240                                                         
88    FORMAT(4F10.4,3I5)                                                LPL 4250                                                         
89    FORMAT(F10.4,3E10.2,3I5)                                          LPL 4260                                                         
90    FORMAT(//4F10.4,3I5)                                              LPL 4270                                                         
92    FORMAT(F10.4,3E10.2,3I5//)                                        LPL 4280                                                         
94    FORMAT(2I5)                                                       LPL 4290                                                         
99    FORMAT(F7.0)                                                      LPL 4300                                                         
100   FORMAT(8I5,2F10.3)                                                LPL 4310                                                         
101   FORMAT(A80)                                                       LPL 4320                                                         
102   FORMAT(10X,14H TRANSMISSION //)                                   LPL 4330                                                         
103   FORMAT(10X,10H RADIANCE //)                                       LPL 4340                                                         
104   FORMAT(10X,32H RADIANCE WITH SOLAR SCATTERING //)                 LPL 4350                                                         
105   FORMAT(10X,25H DIRECT SOLAR IRRADIANCE //)                        LPL 4360                                                         
500   FORMAT(I5)                                                        LPL 4370                                                         
501   FORMAT(A5)                                                        LPL 4380                                                         
      CALL ENDPLT                                                       LPL 4390                                                         
      STOP                                                              LPL 4400                                                         
      END                                                               LPL 4410                                                         
      SUBROUTINE PLTDTA(ICRV,IEOF)                                      PDA  100                                                         
CCC                                                                     PDA  110                                                         
CCC   ROUTINE TO READ TAPE7 EMISSIONS AND TRANSMISSIONS                 PDA  120                                                         
CCC   AND PLOT VARIOUS VALUES.                                          PDA  130                                                         
CCC   ITRP=0 PLOTS TOTAL TRANSMISSION                                   PDA  140                                                         
CCC   ITRP=1-7 PLOTS H2O,CO2,OZONE,N2CONT,H2OCONT,MOLSCT,AERTRN         PDA  150                                                         
CCC   ITRP=8-10 PLOTS HNO3,AERABS OR INTEG. ABS                         PDA  160                                                         
CCC                                                                     PDA  170                                                         
      COMMON /IFIL/ IRD,IPR,IPU,IMULT                                   PDA  180                                                         
      COMMON /DXDY/ DX,ADY,PFRBEG,YRMIN,IXAXIS,IYAXIS,PFREND,YRMAX,     PDA  190                                                         
     C ITYP,IYPWR,IEMSCT                                                PDA  200                                                         
      DIMENSION RAD(400),V(400),TRM(10),RADVAL(9)                       PDA  210                                                         
CCC                                                                     PDA  220                                                         
CC   IPOS                                                               PDA  230                                                         
CC   IEMSCT = 0  IPOS 0 TRANSMISSION                                    PDA  240                                                         
CC               IPOS 1 TO 10 H2O TO AER-HYD COMPOIENT TRANSMISSION     PDA  250                                                         
CC                                                                      PDA  260                                                         
CC   IEMSCT = 1  IPOS 0 TRANSMISSION                                    PDA  270                                                         
CC               IPOS 1 ATMOSPHERIC RADIANCE IN UNITS BY ITYP           PDA  280                                                         
CC                                                                      PDA  290                                                         
CC   IEMSCT = 2  IPOS 0 TRANSMISSION                                    PDA  300                                                         
CC               IPOS 1 ATMOSPHERIC      RADIANCE IN UNITS BY ITYP      PDA  310                                                         
CC               IPOS 2 PATH SCATTERED   RADIANCE IN UNITS BY ITYP      PDA  320                                                         
CC               IPOS 3 SINGLE SCATTERED RADIANCE IN UNITS BY ITYP      PDA  330                                                         
CC               IPOS 4 GROUND REFLECTED RADIANCE IN UNITS BY ITYP      PDA  340                                                         
CC               IPOS 5 DIRECT           RADIANCE IN UNITS BY ITYP      PDA  350                                                         
CC               IPOS 6 TOTAL            RADIANCE IN UNITS BY ITYP      PDA  360                                                         
CC                                                                      PDA  370                                                         
CC               WHEN IMULT = 0 ; IPOS = 2  SAME AS IPOS = 3            PDA  380                                                         
CC               WHEN IMULT = 0 ; IPOS = 4  SAME AS IPOS = 5            PDA  390                                                         
CC                                                                      PDA  400                                                         
CC   IEMSCT = 3  IPOS 0 TRANSMISSION                                    PDA  410                                                         
CC               IPOS 1 TRANMITTED  RADIANCE IN UNITS BY ITYP           PDA  420                                                         
CC               IPOS 2 SOLAR       RADIANCE IN UNITS BY ITYP           PDA  430                                                         
CCC                                                                     PDA  440                                                         
      TRANS=0.                                                          PDA  450                                                         
      READ (IRD,94) IPOS                                                PDA  460                                                         
      WRITE (IPR,94) IPOS                                               PDA  470                                                         
      READ(7,990)                                                       PDA  480                                                         
990   FORMAT(A1)                                                        PDA  490                                                         
      J=1                                                               PDA  500                                                         
20    IF(IEMSCT.GT.0)READ(7,1000,END=50) FREQ,TRANS,(RADVAL(K),K=1,8)   PDA  510                                                         
      IF(IEMSCT.EQ.0)READ(7,1100,END=50) FREQ,TRANS,(TRM(I),I=1,10)     PDA  520                                                         
      IF(FREQ.EQ.-9999.) GO TO 50                                       PDA  530                                                         
      IF(IMULT.EQ.1) THEN                                               PDA  540                                                         
          RADVAL(5) = RADVAL(3) + RADVAL(5)                             PDA  550                                                         
      ENDIF                                                             PDA  560                                                         
      JWT=J                                                             PDA  570                                                         
      JFNU=J                                                            PDA  580                                                         
CCC   V(J)=ALAM                                                         PDA  590                                                         
      IF(ITYP .EQ. 0 .OR. ITYP .EQ. 1) THEN                             PDA  600                                                         
           IF(IPOS .EQ. 0) IPOS = 1                                     PDA  610                                                         
           IF(IEMSCT. EQ. 0) IPOS = 1                                   PDA  620                                                         
           IF(IEMSCT. EQ. 3) THEN                                       PDA  630                                                         
              IF(IPOS .GT. 2) IPOS = 2                                  PDA  640                                                         
            ENDIF                                                       PDA  650                                                         
           RADS =RADVAL(IPOS)                                           PDA  660                                                         
      ENDIF                                                             PDA  670                                                         
      IF(ITYP .EQ. 1 ) THEN                                             PDA  680                                                         
            RAD(J) = RADS                                               PDA  690                                                         
      ENDIF                                                             PDA  700                                                         
      IF(ITYP .EQ. 0 ) THEN                                             PDA  710                                                         
            RAD(J) = RADS / (FREQ**2/1.0E+4)                            PDA  730                                                         
      ENDIF                                                             PDA  740                                                         
      IF(ITYP .EQ. 2 .OR. ITYP .EQ. 3) THEN                             PDA  750                                                         
            RAD(J)=TRANS                                                PDA  760                                                         
            IF(IPOS .GT. 0) RAD(J)=TRM(IPOS)                            PDA  770                                                         
      ENDIF                                                             PDA  780                                                         
      IF(ITYP.EQ.1.OR.ITYP.EQ.3) THEN                                   PDA  790                                                         
            V(J)=FREQ                                                   PDA  800                                                         
      ELSE                                                              PDA  810                                                         
            V(J)=1.0E+4/FREQ                                            PDA  820                                                         
            IF(FREQ .LE.0.) V(J)=1.0E+32                                PDA  830                                                         
      ENDIF                                                             PDA  840                                                         
1900  FORMAT(F15.8,G20.8)                                               PDA  850                                                         
      IF(IXAXIS.EQ.0 .AND. V(J).LT.PFRBEG) GO TO 20                     PDA  860                                                         
      IF(IXAXIS.EQ.0 .AND. V(J).GT.PFREND) GO TO 20                     PDA  870                                                         
      V10 =  -1000.                                                                                                                      
      IF(V(J). GT. 0.) V10 = ALOG10(V(J))                                                                                                
      IF(IXAXIS.EQ.1 .AND. V10         .LT.PFRBEG) GO TO 20             PDA  880                                                         
      IF(IXAXIS.EQ.1 .AND. V10         .GT.PFREND) GO TO 20             PDA  890                                                         
CCC   IF(IEMSCT.GT.0 .AND. IRAD.GT.0) RAD(J)=RADVAL(IRAD)               PDA  900                                                         
      IF(J.GE.399) GO TO 40                                             PDA  910                                                         
      J=J+1                                                             PDA  920                                                         
       GO TO 20                                                         PDA  930                                                         
CCC                                                                     PDA  940                                                         
CCC   PLOT DATA                                                         PDA  950                                                         
CCC                                                                     PDA  960                                                         
CCC   TYPE OF LINE PLOTTED IS CONTROLLED BY THE VALUE OF ICRV           PDA  970                                                         
CCC   SUBROUTINE DRAW EXPLAINS THE USE OF ICRV IN OBTAINING             PDA  980                                                         
CCC   VARIOUS TYPES OF PLOTTED LINES                                    PDA  990                                                         
CCC                                                                     PDA 1000                                                         
40    CALL DRAW(V,RAD,JFNU,ICRV)                                        PDA 1010                                                         
      WRITE (IPR,2000) V(1),RAD(1),V(JFNU),RAD(JFNU)                    PDA 1020                                                         
      IF(J.LT.399) GO TO 60                                             PDA 1030                                                         
      V(1)=V(399)                                                       PDA 1040                                                         
      RAD(1)=RAD(399)                                                   PDA 1050                                                         
      J=2                                                               PDA 1060                                                         
      GO TO 20                                                          PDA 1070                                                         
50    CONTINUE                                                          PDA 1080                                                         
      IEOF=IEOF+1                                                       PDA 1090                                                         
       JWT=J-1                                                          PDA 1100                                                         
       JFNU=J-1                                                         PDA 1110                                                         
      IF(JWT.LE.1) GO TO 60                                             PDA 1120                                                         
      GO TO 40                                                          PDA 1130                                                         
60    CONTINUE                                                          PDA 1140                                                         
94    FORMAT(5I5)                                                       PDA 1150                                                         
900   FORMAT(2F9.4)                                                     PDA 1160                                                         
1000  FORMAT(F7.0,F8.4,9E9.2,F8.4)                                      PDA 1170                                                         
1100  FORMAT(F7.0,F8.4,11F8.4,F12.4)                                    PDA 1180                                                         
2000  FORMAT(2(F10.3,E10.3))                                            PDA 1190                                                         
      RETURN                                                            PDA 1200                                                         
      END                                                               PDA 1210                                                         
      SUBROUTINE AXISL(X, Y, BCD, N, NUMDIV, DIVLEN, NUMSUB, BEGNUM,    AXL  100                                                         
     1  DELNUM, NUMDEC, THETA, HEIGHT, NRPT,NTURN , NOEND, LSUPR, LTURN)AXL  110                                                         
C                                                                       AXL  120                                                         
C   MODIFIED VERSION OF AXISL                                           AXL  130                                                         
C                                                                       AXL  140                                                         
C   WRITTEN BY RICHARD L. TAYLOR   RADC/ET   EEC   NOVEMBER 1980        AXL  150                                                         
C                                                                       AXL  160                                                         
C   ROUTINE TO PLOT A LABELLED LINEAR AXIS                              AXL  170                                                         
C                                                                       AXL  180                                                         
C                                                                       AXL  190                                                         
C   X AND Y ARE THE STARTING COORDINATES OF THE AXIS RELATIVE TO THE    AXL  200                                                         
C                                                                       AXL  210                                                         
C        CURRENT ORIGIN                                                 AXL  220                                                         
C                                                                       AXL  230                                                         
C   BCD IS THE LABEL OF THE AXIS EXPRESSED AS A HOLLERITH CONSTANT      AXL  240                                                         
C                                                                       AXL  250                                                         
C   N IS THE NUMBER OF CHARACTERS IN THE LABEL                          AXL  260                                                         
C                                                                       AXL  270                                                         
C        NEGATIVE N PLACES THE LABEL ON THE CLOCKWISE SIDE OF THE AXIS  AXL  280                                                         
C                                                                       AXL  290                                                         
C        POSITIVE N PLACES THE LABEL ON THE COUNTERCLOCKWISE SIDE       AXL  300                                                         
C                                                                       AXL  310                                                         
C   NUMDIV IS THE NUMBER OF MAJOR DIVISIONS                             AXL  320                                                         
C                                                                       AXL  330                                                         
C   DIVLEN IS THE LENGTH IN INCHES OF A MAJOR DIVISION                  AXL  340                                                         
C                                                                       AXL  350                                                         
C   NUMSUB IS THE NUMBER OF MINOR DIVISIONS PER MAJOR DIVISION          AXL  360                                                         
C                                                                       AXL  370                                                         
C        1 GIVES NO SUBDIVISION TICS, 2 GIVES ONE SUBDIVISION TIC, ETC. AXL  380                                                         
C                                                                       AXL  390                                                         
C   BEGNUM IS THE NUMBER FOR THE BEGINNING OF THE AXIS                  AXL  400                                                         
C                                                                       AXL  410                                                         
C   DELNUM IS THE DELTA NUMBER FOR A MAJOR DIVISION                     AXL  420                                                         
C                                                                       AXL  430                                                         
C   NUMDEC IS THE NUMBER OF DECIMAL PLACES DESIRED                      AXL  440                                                         
C                                                                       AXL  450                                                         
C        NUMDEC EQUAL TO -1 SUPPRESSES THE DECIMAL POINT                AXL  460                                                         
C                                                                       AXL  470                                                         
C   THETA IS THE ANGLE OF THE AXIS IN DEGREES  (0.0 FOR X, 90.0 FOR Y)  AXL  480                                                         
C                                                                       AXL  490                                                         
C   HEIGHT IS THE HEIGHT OF THE NUMBERS IN INCHES                       AXL  500                                                         
C                                                                       AXL  510                                                         
C   NRPT IS THE REPEAT FACTOR FOR THE SCALE NUMBERS (USUALLY INTEGER 1) AXL  520                                                         
C                                                                       AXL  530                                                         
C        WHEN NRPT IS ZERO THE SCALE NUMBERS WILL BE SUPPRESSED;        AXL  540                                                         
C                                                                       AXL  550                                                         
C        WHEN NRPT = 2, EVERY 2ND SCALE NUMBER WILL BE PRODUCED; ETC.   AXL  560                                                         
C                                                                       AXL  570                                                         
C   NTURN EQUAL TO 1 TURNS THE AXIS NUMBERS BY 90 DEGREES CLOCKWISE,    AXL  580                                                         
C        -1 TURNS NUMBERS BY 90 DEGREES COUNTERCLOCKWISE, 0 FOR NO TURN AXL  590                                                         
C                                                                       AXL  600                                                         
C   NOEND EQUAL TO 1 SUPPRESSES THE NUMBERS AT EITHER END OF THE AXIS,  AXL  610                                                         
C                                                                       AXL  620                                                         
C        2 SUPPRESSES THE BEGINNING NUMBER, 3 THE ENDING NUMBER         AXL  630                                                         
C                                                                       AXL  640                                                         
C   LSUPR EQUAL TO 1 SUPPRESSES THE LABEL                               AXL  650                                                         
C    LTURN NOT USED                                                     AXL  660                                                         
C                                                                       AXL  670                                                         
      COMMON/TITLOC/XPOS, YPOS                                          AXL  680                                                         
      COMMON /DXDY/ DX,ADY,PFRBEG,YRMIN,IXAXIS,IYAXIS,PFREND,YRMAX,     AXL  690                                                         
     C ITYP,IYPWR,IEMSCT                                                AXL  700                                                         
      DIMENSION  BCD(1)                                                 AXL  710                                                         
      THETA1=THETA-90.*NTURN                                            AXL  720                                                         
      PI = 2. * ASIN(1.)                                                AXL  730                                                         
      ANGLE = (PI/180.) * THETA                                         AXL  740                                                         
      SINANG = SIN(ANGLE)                                               AXL  750                                                         
      COSANG = COS(ANGLE)                                               AXL  760                                                         
      SIGNAX = FLOAT(ISIGN(1,N))                                        AXL  770                                                         
      SIZMAJ = 0.25 * HEIGHT + 0.05                                     AXL  780                                                         
      OFFST=HEIGHT*1.5                                                  AXL  790                                                         
      DXMAJ = -SIZMAJ * SINANG * SIGNAX                                 AXL  800                                                         
      DYMAJ =  SIZMAJ * COSANG * SIGNAX                                 AXL  810                                                         
      DXMIN = 0.5 * DXMAJ                                               AXL  820                                                         
      DYMIN = 0.5 * DYMAJ                                               AXL  830                                                         
      NSUB = NUMSUB                                                     AXL  840                                                         
      IF(NUMSUB .LT. 1)  NSUB = 1                                       AXL  850                                                         
      SUBDIV = DIVLEN / FLOAT(NSUB)                                     AXL  860                                                         
      BCDSIZ = 1.25 * HEIGHT                                            AXL  870                                                         
      YBIAS = (-0.50 + SIGN(1.25, SIGNAX)) * HEIGHT + DYMAJ             AXL  880                                                         
      NABS = IABS(N)                                                    AXL  890                                                         
      BCDLEN = (FLOAT(NABS) - 0.4) * BCDSIZ                             AXL  900                                                         
      S = DIVLEN * FLOAT(NUMDIV)                                        AXL  910                                                         
      DIVCOS = DIVLEN * COSANG                                          AXL  920                                                         
      DIVSIN = DIVLEN * SINANG                                          AXL  930                                                         
      SIZMAX = HEIGHT                                                   AXL  940                                                         
C                                                                       AXL  950                                                         
C                                                                       AXL  960                                                         
C   DRAW DIVISION NUMBERS                                               AXL  970                                                         
C                                                                       AXL  980                                                         
C                                                                       AXL  990                                                         
      NDIV = 0                                                          AXL 1000                                                         
   10 DIGITS = 0.0                                                      AXL 1010                                                         
      XTIC = X + DIVCOS*FLOAT(NDIV)                                     AXL 1020                                                         
      YTIC = Y + DIVSIN*FLOAT(NDIV)                                     AXL 1030                                                         
      IF(NRPT .EQ. 0)  GO TO 20                                         AXL 1040                                                         
      NSUPR = NDIV - (NDIV/NRPT)*NRPT                                   AXL 1050                                                         
      IF(NSUPR .NE. 0)  GO TO 20                                        AXL 1060                                                         
      IF((NOEND .EQ. 1  .OR.  NOEND .EQ. 2)  .AND.  NDIV .EQ. 0)        AXL 1070                                                         
     1     GO TO 20                                                     AXL 1080                                                         
      IF((NOEND .EQ. 1  .OR.  NOEND .EQ. 3)  .AND.  NDIV .EQ. NUMDIV)   AXL 1090                                                         
     1     GO TO 20                                                     AXL 1100                                                         
      DIVNUM = BEGNUM + DELNUM*FLOAT(NDIV)                              AXL 1110                                                         
      IF(ABS(DIVNUM) .GE. 10.0)  DIGITS = ALOG10(ABS(DIVNUM))           AXL 1120                                                         
      DIGITS = AINT(DIGITS + 1.0E-12)                                   AXL 1130                                                         
      IF(DIVNUM .LT. 0.0)  DIGITS = DIGITS + 1.0                        AXL 1140                                                         
      SIZNUM = (DIGITS + FLOAT(NUMDEC) + 1.7)*HEIGHT                    AXL 1150                                                         
      XBIAS = -0.5*SIZNUM                                               AXL 1160                                                         
      XBIAS1=0.                                                         AXL 1170                                                         
      YBIAS1=0.                                                         AXL 1180                                                         
      IF(NTURN.EQ.0) GO TO 15                                           AXL 1190                                                         
      YBIAS1=YBIAS-SIZNUM-OFFST                                         AXL 1200                                                         
      IF(N.LT.0)YBIAS1=YBIAS+OFFST                                      AXL 1210                                                         
      XBIAS1=XBIAS+HEIGHT*0.5                                           AXL 1220                                                         
15    XPOS = XTIC - YBIAS*SINANG + XBIAS*COSANG                         AXL 1230                                                         
     C +YBIAS1*SINANG-XBIAS1*COSANG                                     AXL 1240                                                         
      YPOS = YTIC + YBIAS*COSANG  + XBIAS*SINANG                        AXL 1250                                                         
     C -XBIAS1*SINANG-YBIAS1*COSANG                                     AXL 1260                                                         
      CALL NUMBER(XPOS, YPOS, HEIGHT, DIVNUM, THETA1,NUMDEC)            AXL 1270                                                         
      IF(SIZMAX .LT. SIZNUM)  SIZMAX = SIZNUM                           AXL 1280                                                         
   20 CONTINUE                                                          AXL 1290                                                         
C                                                                       AXL 1300                                                         
C                                                                       AXL 1310                                                         
C   DRAW TIC MARKS                                                      AXL 1320                                                         
C                                                                       AXL 1330                                                         
C                                                                       AXL 1340                                                         
      CALL PLOT(XTIC      , YTIC      , 3)                              AXL 1350                                                         
      CALL PLOT(XTIC+DXMAJ, YTIC+DYMAJ, 2)                              AXL 1360                                                         
      IF(NDIV .EQ. NUMDIV)  GO TO 50                                    AXL 1370                                                         
      IF(NUMSUB .LE. 1)  GO TO 40                                       AXL 1380                                                         
      DO 30  J=2,NUMSUB                                                 AXL 1390                                                         
      SUBLEN = SUBDIV*FLOAT(J-1)                                        AXL 1400                                                         
      XSTIC = XTIC + SUBLEN * COSANG                                    AXL 1410                                                         
      YSTIC = YTIC + SUBLEN * SINANG                                    AXL 1420                                                         
      CALL PLOT(XSTIC+DXMIN, YSTIC+DYMIN, 3)                            AXL 1430                                                         
      CALL PLOT(XSTIC, YSTIC, 2)                                        AXL 1440                                                         
   30 CONTINUE                                                          AXL 1450                                                         
   40 NDIV = NDIV + 1                                                   AXL 1460                                                         
      GO TO 10                                                          AXL 1470                                                         
C                                                                       AXL 1480                                                         
C                                                                       AXL 1490                                                         
C   DRAW AXIS                                                           AXL 1500                                                         
C                                                                       AXL 1510                                                         
C                                                                       AXL 1520                                                         
   50 CALL PLOT(XTIC, YTIC, 3)                                          AXL 1530                                                         
      CALL PLOT(X, Y, 2)                                                AXL 1540                                                         
C                                                                       AXL 1550                                                         
C                                                                       AXL 1560                                                         
C   DRAW LABEL                                                          AXL 1570                                                         
C                                                                       AXL 1580                                                         
C                                                                       AXL 1590                                                         
      IF(LSUPR .EQ. 1  .OR.  NABS .EQ. 0)  RETURN                       AXL 1600                                                         
      XBIAS1=0                                                          AXL 1610                                                         
      YBIAS1=-SIZNUM-OFFST                                              AXL 1620                                                         
      IF(N.LT.0)YBIAS1=-YBIAS1                                          AXL 1630                                                         
      IF(NTURN.EQ.0) YBIAS1=0                                           AXL 1640                                                         
      XBIAS = 0.5*(S - BCDLEN)                                          AXL 1650                                                         
      YBIAS = (-0.50 + SIGN(3.25, SIGNAX)) * BCDSIZ                     AXL 1660                                                         
      XPOS = X - YBIAS*SINANG + XBIAS*COSANG                            AXL 1670                                                         
     C +YBIAS1*SINANG-XBIAS1*COSANG                                     AXL 1680                                                         
      YPOS = Y + YBIAS*COSANG + XBIAS*SINANG                            AXL 1690                                                         
     C -XBIAS1*SINANG-YBIAS1*COSANG                                     AXL 1700                                                         
      CALL SYMBOL(XPOS, YPOS, BCDSIZ, BCD, THETA, NABS)                 AXL 1710                                                         
   60 CONTINUE                                                          AXL 1720                                                         
      RETURN                                                            AXL 1730                                                         
      END                                                               AXL 1740                                                         
      SUBROUTINE AXLOG(X, Y, BCD, N, NUMCYC, CYCLEN, BEGEXP,            ALG  100                                                         
     1     THETA, HEIGHT, NRPT, NTURN, NOEND, LSUPR, LTURN)             ALG  110                                                         
C                                                                       ALG  120                                                         
C                                                                       ALG  130                                                         
C   WRITTEN BY RICHARD L. TAYLOR   RADC/ET   EEC   NOVEMBER 1980        ALG  140                                                         
C                                                                       ALG  150                                                         
C                                                                       ALG  160                                                         
C                                                                       ALG  170                                                         
C   ROUTINE TO PLOT A LABELLED LOGARITHMIC AXIS                         ALG  180                                                         
C                                                                       ALG  190                                                         
C                                                                       ALG  200                                                         
C                                                                       ALG  210                                                         
C                                                                       ALG  220                                                         
C   X AND Y ARE THE STARTING COORDINATES OF THE AXIS RELATIVE TO THE    ALG  230                                                         
C                                                                       ALG  240                                                         
C        CURRENT ORIGIN                                                 ALG  250                                                         
C                                                                       ALG  260                                                         
C   BCD IS THE LABEL OF THE AXIS EXPRESSED AS A HOLLERITH CONSTANT      ALG  270                                                         
C                                                                       ALG  280                                                         
C   N IS THE NUMBER OF CHARACTERS IN THE LABEL                          ALG  290                                                         
C                                                                       ALG  300                                                         
C        NEGATIVE N PLACES THE LABEL ON THE CLOCKWISE SIDE OF THE AXIS  ALG  310                                                         
C                                                                       ALG  320                                                         
C        POSITIVE N PLACES THE LABEL ON THE COUNTERCLOCKWISE SIDE       ALG  330                                                         
C                                                                       ALG  340                                                         
C   NUMCYC IS THE NUMBER OF CYCLES DESIRED                              ALG  350                                                         
C                                                                       ALG  360                                                         
C   CYCLEN IS THE LENGTH OF ONE CYCLE IN INCHES                         ALG  370                                                         
C                                                                       ALG  380                                                         
C   BEGEXP IS THE EXPONENT FOR THE BEGINNING OF THE AXIS                ALG  390                                                         
C                                                                       ALG  400                                                         
C   THETA IS THE ANGLE OF THE AXIS IN DEGREES  (0.0 FOR X, 90.0 FOR Y)  ALG  410                                                         
C                                                                       ALG  420                                                         
C   HEIGHT IS THE HEIGHT IN INCHES OF THE TENS                          ALG  430                                                         
C                                                                       ALG  440                                                         
C   NRPT IS THE REPEAT FACTOR FOR THE SCALE NUMBERS (USUALLY INTEGER 1) ALG  450                                                         
C                                                                       ALG  460                                                         
C        WHEN NRPT IS ZERO THE SCALE NUMBERS WILL BE SUPPRESSED;        ALG  470                                                         
C                                                                       ALG  480                                                         
C        WHEN NRPT = 2, EVERY 2ND SCALE NUMBER WILL BE PRODUCED;        ALG  490                                                         
C                                                                       ALG  500                                                         
C        WHEN NRPT = 3, EVERY 3RD SCALE NUMBER WILL BE PRODUCED; ETC.   ALG  510                                                         
C                                                                       ALG  520                                                         
C    NTURN EQUAL TO 1 TURNS THE AXIS NUMBERS BY 90 DEGREES CLOCKWISE,   ALG  530                                                         
C         -1 TURNS NUMBERS BY 90 DEGREES COUNTERCLOCKWISE, 0 FOR NO TURNALG  540                                                         
C                                                                       ALG  550                                                         
C   NOEND EQUAL TO 1 SUPPRESSES THE NUMBERS AT EITHER END OF THE AXIS,  ALG  560                                                         
C                                                                       ALG  570                                                         
C        NOEND EQUAL TO 2 SUPPRESSES ONLY THE STARTING NUMBER, AND NOENDALG  580                                                         
C                                                                       ALG  590                                                         
C        EQUAL TO 3 SUPPRESSES ONLY THE ENDING NUMBER                   ALG  600                                                         
C                                                                       ALG  610                                                         
C   LSUPR EQUAL TO 1 SUPPRESSES THE LABEL                               ALG  620                                                         
C                                                                       ALG  630                                                         
C    LTURN EQUAL TO 1 TURNS THE LABEL BY 90 DEGREES CLOCKWISE,          ALG  640                                                         
C         -1 TURNS LABEL BY 90 DEGREES COUNTERCLOCKWISE, 0 FOR NO TURN  ALG  650                                                         
C                                                                       ALG  660                                                         
C                                                                       ALG  670                                                         
      COMMON/TITLOC/XPOS, YPOS                                          ALG  680                                                         
      COMMON /DXDY/ DX,ADY,PFRBEG,YRMIN,IXAXIS,IYAXIS,PFREND,YRMAX,     ALG  690                                                         
     C ITYP,IYPWR,IEMSCT                                                ALG  700                                                         
      DIMENSION  BCD(1), SUBDIV(10), DIVLOG(8)                          ALG  710                                                         
      DATA   DIVLOG / 0.301029995664, 0.477121254720, 0.602059991328,   ALG  720                                                         
     1                0.698970004336, 0.778151250384, 0.845098040014,   ALG  730                                                         
     2                0.903089986992, 0.954242509439/                   ALG  740                                                         
      THETA1=THETA-90.*NTURN                                            ALG  750                                                         
      PI = 2. * ASIN(1.)                                                ALG  760                                                         
      ANGLE = (PI/180.) * THETA                                         ALG  770                                                         
      SINANG = SIN(ANGLE)                                               ALG  780                                                         
      COSANG = COS(ANGLE)                                               ALG  790                                                         
      SIGNAX = FLOAT(ISIGN(1, N))                                       ALG  800                                                         
      SIZMAJ = 0.25 * HEIGHT + 0.05                                     ALG  810                                                         
      OFFST=HEIGHT*1.5                                                  ALG  820                                                         
      DXMAJ = -SIZMAJ * SINANG * SIGNAX                                 ALG  830                                                         
      DYMAJ =  SIZMAJ * COSANG * SIGNAX                                 ALG  840                                                         
      DXMIN = 0.5 * DXMAJ                                               ALG  850                                                         
      DYMIN = 0.5 * DYMAJ                                               ALG  860                                                         
      BCDSIZ = 1.25 * HEIGHT                                            ALG  870                                                         
      ENLARG=1.5                                                        ALG  880                                                         
      EXPSIZ = 0.60 * HEIGHT *ENLARG                                    ALG  890                                                         
      NABS = IABS(N)                                                    ALG  900                                                         
      BCDLEN = (FLOAT(NABS) - 0.4) * BCDSIZ                             ALG  910                                                         
      S = CYCLEN * FLOAT(NUMCYC)                                        ALG  920                                                         
      NUMTIC = 2 - MIN1(1.0, CYCLEN)                                    ALG  930                                                         
      NUMLOG = 8 / NUMTIC                                               ALG  940                                                         
      XBIAS = 1.85*HEIGHT *ENLARG                                       ALG  950                                                         
      YBIAS = 0.70*HEIGHT *ENLARG                                       ALG  960                                                         
      EXPBX = -YBIAS*SINANG + XBIAS*COSANG                              ALG  970                                                         
      EXPBY =  YBIAS*COSANG + XBIAS*SINANG                              ALG  980                                                         
      IF (NTURN .EQ. 0) GO TO 5                                         ALG  990                                                         
      EXPBX = XBIAS * SINANG + YBIAS * COSANG                           ALG 1000                                                         
      EXPBY = YBIAS * SINANG - XBIAS * COSANG                           ALG 1010                                                         
    5 DO 10  I=2,9                                                      ALG 1020                                                         
      SUBDIV(I) = DIVLOG(I-1)*CYCLEN                                    ALG 1030                                                         
   10 CONTINUE                                                          ALG 1040                                                         
      NNUMB = NUMCYC + 1                                                ALG 1050                                                         
      SIZMAX = EXPSIZ                                                   ALG 1060                                                         
      EXP = BEGEXP                                                      ALG 1070                                                         
      DO 20  I=1,NNUMB                                                  ALG 1080                                                         
      DIGITS = 0.0                                                      ALG 1090                                                         
      IF(ABS(EXP) .GE. 10.0)  DIGITS = ALOG10( ABS(EXP) )               ALG 1100                                                         
      DIGITS = AINT(DIGITS + 1.0E-12) + 0.7                             ALG 1110                                                         
      IF(EXP .LT. 0.0)  DIGITS = DIGITS + 1.0                           ALG 1120                                                         
      SIZNUM = DIGITS * EXPSIZ                                          ALG 1130                                                         
      IF(SIZMAX .LT. SIZNUM)  SIZMAX = SIZNUM                           ALG 1140                                                         
   20 EXP = EXP + 1.0                                                   ALG 1150                                                         
      SIZNUM = SIZMAX + 2.0*HEIGHT                                      ALG 1160                                                         
C                                                                       ALG 1170                                                         
C                                                                       ALG 1180                                                         
C   DRAW CYCLE NUMBERS AND EXPONENTS                                    ALG 1190                                                         
C                                                                       ALG 1200                                                         
C                                                                       ALG 1210                                                         
      NCYCLE = 0                                                        ALG 1220                                                         
      EXP = BEGEXP                                                      ALG 1230                                                         
      XBIAS = -0.7*HEIGHT                                               ALG 1240                                                         
      YBIAS = (-0.50 + SIGN(1.25, SIGNAX)) * HEIGHT                     ALG 1250                                                         
      XBIAS1=0.                                                         ALG 1260                                                         
      YBIAS1=0.                                                         ALG 1270                                                         
      IF(NTURN.EQ.0) GO TO 25                                           ALG 1280                                                         
      XBIAS1=XBIAS+HEIGHT*0.5                                           ALG 1290                                                         
      YBIAS1=YBIAS1-OFFST-SIZNUM                                        ALG 1300                                                         
      IF(N.LT.0) YBIAS1 = YBIAS+OFFST                                   ALG 1310                                                         
25    TENBX = -YBIAS*SINANG + XBIAS*COSANG                              ALG 1320                                                         
     C +YBIAS1*SINANG - XBIAS1*COSANG                                   ALG 1330                                                         
      TENBY =  YBIAS*COSANG + XBIAS*SINANG                              ALG 1340                                                         
     C -YBIAS1*COSANG -XBIAS1*SINANG                                    ALG 1350                                                         
   30 XTIC = X + FLOAT(NCYCLE)*CYCLEN*COSANG                            ALG 1360                                                         
      YTIC = Y + FLOAT(NCYCLE)*CYCLEN*SINANG                            ALG 1370                                                         
      IF(NRPT .EQ. 0)  GO TO 40                                         ALG 1380                                                         
      NSUPR = NCYCLE - (NCYCLE/NRPT)*NRPT                               ALG 1390                                                         
      IF(NSUPR .NE. 0)  GO TO 40                                        ALG 1400                                                         
      IF((NOEND .EQ. 1  .OR.  NOEND .EQ. 2)  .AND.  NCYCLE .EQ. 0)      ALG 1410                                                         
     1     GO TO 40                                                     ALG 1420                                                         
      IF((NOEND .EQ. 1  .OR.  NOEND .EQ. 3)  .AND.  NCYCLE .EQ. NUMCYC) ALG 1430                                                         
     1     GO TO 40                                                     ALG 1440                                                         
      XPOS = XTIC + TENBX                                               ALG 1450                                                         
      YPOS = YTIC + TENBY                                               ALG 1460                                                         
      AH10 = 2H10                                                       ALG 1470                                                         
      CALL SYMBOL(XPOS, YPOS, HEIGHT,      AH10 , THETA1, 2)            ALG 1480                                                         
      CALL NUMBER((XPOS+EXPBX), (YPOS+EXPBY), EXPSIZ, EXP, THETA1, -1)  ALG 1490                                                         
   40 CONTINUE                                                          ALG 1500                                                         
C                                                                       ALG 1510                                                         
C                                                                       ALG 1520                                                         
C   DRAW TIC MARKS                                                      ALG 1530                                                         
C                                                                       ALG 1540                                                         
C                                                                       ALG 1550                                                         
      CALL PLOT(XTIC      , YTIC      , 3)                              ALG 1560                                                         
      CALL PLOT(XTIC+DXMAJ, YTIC+DYMAJ, 2)                              ALG 1570                                                         
      IF(NCYCLE .EQ. NUMCYC)  GO TO 70                                  ALG 1580                                                         
      IF(NRPT .LT. 0)  GO TO 60                                         ALG 1590                                                         
      DO 50  ILOG=1,NUMLOG                                              ALG 1600                                                         
      I = ILOG*NUMTIC + 1/NUMTIC                                        ALG 1610                                                         
      XLOG = XTIC + SUBDIV(I)*COSANG                                    ALG 1620                                                         
      YLOG = YTIC + SUBDIV(I)*SINANG                                    ALG 1630                                                         
      CALL PLOT(XLOG+DXMIN, YLOG+DYMIN, 3)                              ALG 1640                                                         
      CALL PLOT(XLOG, YLOG, 2)                                          ALG 1650                                                         
   50 CONTINUE                                                          ALG 1660                                                         
   60 NCYCLE = NCYCLE + 1                                               ALG 1670                                                         
      EXP = EXP + 1.0                                                   ALG 1680                                                         
      GO TO 30                                                          ALG 1690                                                         
C                                                                       ALG 1700                                                         
C                                                                       ALG 1710                                                         
C   DRAW AXIS                                                           ALG 1720                                                         
C                                                                       ALG 1730                                                         
C                                                                       ALG 1740                                                         
   70 CALL PLOT(XTIC, YTIC, 3)                                          ALG 1750                                                         
      CALL PLOT(X, Y, 2)                                                ALG 1760                                                         
C                                                                       ALG 1770                                                         
C                                                                       ALG 1780                                                         
C   DRAW LABEL                                                          ALG 1790                                                         
C                                                                       ALG 1800                                                         
C                                                                       ALG 1810                                                         
      IF(LSUPR .EQ. 1  .OR.  NABS .EQ. 0)  RETURN                       ALG 1820                                                         
      XBIAS = 0.5*(S - BCDLEN)                                          ALG 1830                                                         
      YBIAS = (-0.50 + SIGN(3.25, SIGNAX)) * BCDSIZ                     ALG 1840                                                         
      THETA2 = THETA - 90. * LTURN                                      ALG 1850                                                         
      XBIAS2=0.                                                         ALG 1860                                                         
      OFFST=HEIGHT*2.5                                                  ALG 1870                                                         
      YBIAS2= -SIZNUM-OFFST                                             ALG 1880                                                         
      IF (N .LT. 0) YBIAS2=OFFST                                        ALG 1890                                                         
      IF (LTURN .EQ. 0) GO TO 80                                        ALG 1900                                                         
      XBIAS2 = XBIAS -0.5*(S-HEIGHT)                                    ALG 1910                                                         
   80 XPOS = X - YBIAS*SINANG + XBIAS*COSANG                            ALG 1920                                                         
     C +YBIAS2*SINANG - XBIAS2*COSANG                                   ALG 1930                                                         
      YPOS = Y + YBIAS*COSANG + XBIAS*SINANG                            ALG 1940                                                         
     C -YBIAS2*COSANG -XBIAS2*SINANG                                    ALG 1950                                                         
      IF(N.LT.0) CALL SYMBOL((XPOS+0.5),YPOS,BCDSIZ,BCD,THETA2,NABS)    ALG 1960                                                         
      IF(N.GT.0) CALL SYMBOL(XPOS, YPOS, BCDSIZ, BCD, THETA2, NABS)     ALG 1970                                                         
      RETURN                                                            ALG 1980                                                         
      END                                                               ALG 1990                                                         
      SUBROUTINE DRAW(X,Y,NPT,ICURVE)                                   DRW  100                                                         
C          DRAWS DIFFERENT KINDS OF CURVES FOR  Y VS X                  DRW  110                                                         
C                                                                       DRW  120                                                         
C  X = XARRAY TO BE PLOTTED                                             DRW  130                                                         
C  Y = YARRAY TO BE PLOTTED                                             DRW  140                                                         
C  NPT = NUMBER OF POINTS TO BE PLOTTED                                 DRW  150                                                         
C  ICURVE INDICATES THE TYPE OF CURVE DRAWN                             DRW  160                                                         
C       ICURVE = 1  SOLID LINE WITHOUT SYMBOLS                          DRW  170                                                         
C       ICURVE = 2  DASHED LINE WITHOUT SYMBOLS                         DRW  180                                                         
C       ICURVE = 3  DOTTED LINE WITHOUT SYMBOLS                         DRW  190                                                         
C       ICURVE = 4  ALTERNATING DASHES & DOTS WITHOUT SYMBOLS           DRW  200                                                         
C       ICURVE = 5  ALTERNATING DASHES & 2 DOTS WITHOUT SYMBOLS         DRW  210                                                         
C       ICURVE = 6 TO 10 SAME AS 1 TO 5 WITH SYMBOLS AT EVERY POINT     DRW  220                                                         
C       THE SYMBOL CHOSEN IN THIS PROGRAM IS NO. 2 OF                   DRW  230                                                         
C        THE LIST OF SYMBOLS AVAILABLE IN THE CALCOMP SYSTEM            DRW  240                                                         
C       ICURVE .GT. 10 ALTERNATING DASHES OF DIFFERENT LENGTHS          DRW  250                                                         
C          (THE ONES' DIGIT)*0.1 INCHES  WITH  (THE TENS' DIGIT)*0.1 INCDRW  260                                                         
C       ICURVE .LT. 0  DATA POINTS ONLY,  WITH ABS(ICURVE) = SYMBOL NUMBDRW  270                                                         
C                                                                       DRW  280                                                         
      COMMON /DXDY/ DX,DY, XMIN,YMIN, LOGLNX,LOGLNY, XMAXVL,YMAXVL      DRW  290                                                         
      DIMENSION X(NPT), Y(NPT), XT(100), YT(100)                        DRW  300                                                         
      DATA KSYM, J, SIZ/2, 1, 0.05/                                     DRW  310                                                         
      KT = KSYM                                                         DRW  320                                                         
      IF(ICURVE .LE. -1) KT = -ICURVE                                   DRW  330                                                         
CCC                                                                     DRW  340                                                         
CCC   IF ICURVE IS INPUT AS 0 RESET TO 1 TO PLOT LINE                   DRW  350                                                         
CCC                                                                     DRW  360                                                         
      IF(ICURVE.EQ.0) ICURVE=1                                          DRW  370                                                         
C        PLOT THE  X, Y  PAIRS IN GROUPS OF 100 POINTS                  DRW  380                                                         
      NEXT = 1                                                          DRW  390                                                         
    5 LAST = NEXT + 99                                                  DRW  400                                                         
      IF(LAST .LE. NPT) N = 100                                         DRW  410                                                         
      IF(LAST .GT. NPT) N = NPT - NEXT + 1                              DRW  420                                                         
      IF(LAST .GT. NPT) LAST = NPT                                      DRW  430                                                         
C                                                                       DRW  440                                                         
      DO 10 M = NEXT,LAST                                               DRW  450                                                         
      I = M + 1 - NEXT                                                  DRW  460                                                         
C        IF DOING LOG OR SEMI-LOG PLOT - CONVERT X AND/OR Y TO LOG(X)   DRW  470                                                         
      IF( LOGLNX .EQ. 0) XT(I) = X(M)                                   DRW  480                                                         
      IF( LOGLNX .EQ. 1 .AND. X(M) .GT. 0.) XT(I) = ALOG10(X(M))        DRW  490                                                         
      IF( LOGLNX .EQ. 1 .AND. X(M) .LE. 0.) XT(I) = XMIN                DRW  500                                                         
      IF( LOGLNY .EQ. 0) YT(I) = Y(M)                                   DRW  510                                                         
      IF( LOGLNY .EQ. 1 .AND. Y(M) .GT. 0.) YT(I) = ALOG10(Y(M))        DRW  520                                                         
      IF( LOGLNY .EQ. 1 .AND. Y(M) .LE. 0.) YT(I) = YMIN                DRW  530                                                         
C          &   IF X OR Y OUTSIDE OF PLOT FORCE TO NEAREST EDGE OF PLOT  DRW  540                                                         
      IF(XT(I) .LT. XMIN) XT(I) = XMIN                                  DRW  550                                                         
      IF(XT(I) .GT. XMAXVL) XT(I) = XMAXVL                              DRW  560                                                         
      IF(YT(I) .GT. YMAXVL ) YT(I) = YMAXVL                             DRW  570                                                         
      IF(YT(I) .LT. YMIN ) YT(I) = YMIN                                 DRW  580                                                         
   10 CONTINUE                                                          DRW  590                                                         
C        CHOOSE TYPE OF CURVE PLOTTED DEPENDING ON ICURVE               DRW  600                                                         
      IF(ICURVE .LE.-1) CALL LIN1 (XT,YT,N,1,-1,KT,XMIN,DX,YMIN,DY,SIZ) DRW  610                                                         
      IF(ICURVE .EQ. 1) CALL LIN1 (XT,YT,N,1,0,KT,XMIN,DX,YMIN,DY,.08)  DRW  620                                                         
      IF(ICURVE .EQ. 2)CALL DASH2(XT,YT,N,1,0,KT,XMIN,DX,YMIN,DY,.1,1,1)DRW  630                                                         
      IF(ICURVE .EQ. 3) CALL DOT(XT,YT,N,1,0,KT,XMIN,DX,YMIN,DY,.08)    DRW  640                                                         
      IF(ICURVE .EQ. 4)CALL DSHDOT(XT,YT,N,1,0,KT,XMIN,DX,YMIN,DY,.08)  DRW  650                                                         
      IF(ICURVE .EQ. 5)CALL DSHDT2(XT,YT,N,1,0,KT,XMIN,DX,YMIN,DY,.08)  DRW  660                                                         
      IF(ICURVE .EQ. 6) CALL LIN1(XT,YT,N,1,J,KT,XMIN,DX,YMIN,DY, SIZ)  DRW  670                                                         
      IF(ICURVE .EQ.7)CALL DASH2(XT,YT,N,1,J,KT,XMIN,DX,YMIN,DY,SIZ,1,1)DRW  680                                                         
      IF(ICURVE .EQ. 8) CALL DOT(XT,YT,N,1,J,KT,XMIN,DX,YMIN,DY, SIZ)   DRW  690                                                         
      IF(ICURVE .EQ. 9)CALL DSHDOT(XT,YT,N,1,J,KT,XMIN,DX,YMIN,DY, SIZ) DRW  700                                                         
      IF(ICURVE .EQ. 10)CALL DSHDT2(XT,YT,N,1,J,KT,XMIN,DX,YMIN,DY,SIZ) DRW  710                                                         
      IF(ICURVE .LE. 10) GO TO 20                                       DRW  720                                                         
C        FOR ICURVE .GT. 10,  DETERMINE LENGTH OF DASHES                DRW  730                                                         
      LDASH1 = ICURVE/10                                                DRW  740                                                         
      LDASH2 = ICURVE-10*LDASH1                                         DRW  750                                                         
      CALL DASH2(XT,YT,N,1,0,0,XMIN,DX,YMIN,DY,.08,LDASH1,LDASH2)       DRW  760                                                         
   20 CONTINUE                                                          DRW  770                                                         
      NEXT = LAST                                                       DRW  780                                                         
      IF(LAST .LT. NPT) GO TO 5                                         DRW  790                                                         
C                                                                       DRW  800                                                         
      RETURN                                                            DRW  810                                                         
      END                                                               DRW  820                                                         
      SUBROUTINE DOT(X,Y,N,K,NUMSYM,JSYM,XMIN,DX,YMIN,DY,SYMSZE)        DOT  100                                                         
CCC                                                                     DOT  110                                                         
CCC   DRAWS A DOTTED LINE                                               DOT  120                                                         
CCC                                                                     DOT  130                                                         
      DIMENSION X(N),Y(N),XD(200),YD(200)                               DOT  140                                                         
      COMMON/XXDYYD/XD,YD                                               DOT  150                                                         
      DATA ISYMB,NUMDOT,DOTSIZ,DOTLEN/5, -1, 0.03, 0.09/                DOT  160                                                         
      IF (NUMSYM .LT. 0) GO TO 250                                      DOT  170                                                         
      XDOT = DX * DOTLEN                                                DOT  180                                                         
      YDOT = DY * DOTLEN                                                DOT  190                                                         
      RESID = DOTLEN                                                    DOT  200                                                         
      MB = K+1                                                          DOT  210                                                         
      DO 200 I = MB,N,K                                                 DOT  220                                                         
      XLEN = (X(I)-X(I-K))/DX                                           DOT  230                                                         
      YLEN = (Y(I) - Y(I-K))/DY                                         DOT  240                                                         
      SLEN = SQRT(XLEN **2 + YLEN **2)                                  DOT  250                                                         
      IF(SLEN .LE. 0.) GO TO 200                                        DOT  260                                                         
      TLEN = SLEN + RESID                                               DOT  270                                                         
      NDOT = 0                                                          DOT  280                                                         
      IF ( TLEN .LT. DOTLEN ) GO TO 150                                 DOT  290                                                         
      NDOT = INT(TLEN / DOTLEN)                                         DOT  300                                                         
      XSTEP = XDOT * XLEN/SLEN                                          DOT  310                                                         
      YSTEP = YDOT * YLEN/SLEN                                          DOT  320                                                         
      SS = 1. - RESID/DOTLEN                                            DOT  330                                                         
      YD(1) = SS * YSTEP + Y(I-K)                                       DOT  340                                                         
      XD(1) = SS * XSTEP + X(I-K)                                       DOT  350                                                         
      IF ( NDOT .LT. 2 ) GO TO 20                                       DOT  360                                                         
      DO 10 J = 2,NDOT                                                  DOT  370                                                         
      XD(J) = XD(J-1) + XSTEP                                           DOT  380                                                         
      YD(J) = YD(J-1) + YSTEP                                           DOT  390                                                         
   10 CONTINUE                                                          DOT  400                                                         
   20 CONTINUE                                                          DOT  410                                                         
      CALL LIN1 (XD,YD,NDOT,1,NUMDOT,ISYMB,XMIN,DX,YMIN,DY,DOTSIZ)      DOT  420                                                         
  150 RESID = TLEN - NDOT * DOTLEN                                      DOT  430                                                         
  200 CONTINUE                                                          DOT  440                                                         
250    CONTINUE                                                         DOT  450                                                         
      IF(NUMSYM .EQ. 0) GO TO 300                                       DOT  460                                                         
      IF(NUMSYM .LT. 0) NUMSYM = IABS(NUMSYM)                           DOT  470                                                         
      DO 40 MN = 1,N,NUMSYM                                             DOT  480                                                         
      CALL SYMBOL((X(MN)-XMIN)/DX,(Y(MN)-YMIN)/DY,SYMSZE,JSYM,0.0,-1)   DOT  490                                                         
 40   CONTINUE                                                          DOT  500                                                         
300   CONTINUE                                                          DOT  510                                                         
      RETURN                                                            DOT  520                                                         
      END                                                               DOT  530                                                         
      SUBROUTINE DSHDT2(X,Y,N,K,NUMSYM,JSYM,XMIN,DX,YMIN,DY,SYMSZE)     DH2  100                                                         
CCC                                                                     DH2  110                                                         
CCC   DRAWS A LINE WITH ALTERNATING DASH AND 2 DOTS                     DH2  120                                                         
CCC                                                                     DH2  130                                                         
      DIMENSION X(N),Y(N),XD(200),YD(200)                               DH2  140                                                         
      COMMON/XXDYYD/XD,YD                                               DH2  150                                                         
      DATA DOTLEN/0.09/                                                 DH2  160                                                         
      KPT = 0                                                           DH2  170                                                         
      IF (NUMSYM .LT. 0) GO TO 250                                      DH2  180                                                         
      XDOT = DX * DOTLEN                                                DH2  190                                                         
      YDOT = DY * DOTLEN                                                DH2  200                                                         
      RESID = DOTLEN                                                    DH2  210                                                         
      MB = K+1                                                          DH2  220                                                         
      DO 200 I = MB,N,K                                                 DH2  230                                                         
      XLEN = (X(I)-X(I-K))/DX                                           DH2  240                                                         
      YLEN = (Y(I) - Y(I-K))/DY                                         DH2  250                                                         
      SLEN = SQRT(XLEN **2 + YLEN **2)                                  DH2  260                                                         
      IF(SLEN .LE. 0.) GO TO 200                                        DH2  270                                                         
      TLEN = SLEN + RESID                                               DH2  280                                                         
      NDOT = 0                                                          DH2  290                                                         
      IF ( TLEN .LT. DOTLEN ) GO TO 150                                 DH2  300                                                         
      NDOT = INT(TLEN / DOTLEN)                                         DH2  310                                                         
      XSTEP = XDOT * XLEN/SLEN                                          DH2  320                                                         
      YSTEP = YDOT * YLEN/SLEN                                          DH2  330                                                         
      SS = 1. - RESID/DOTLEN                                            DH2  340                                                         
      YD(1) = SS * YSTEP + Y(I-K)                                       DH2  350                                                         
      XD(1) = SS * XSTEP + X(I-K)                                       DH2  360                                                         
      IF ( NDOT .LT. 2 ) GO TO 20                                       DH2  370                                                         
      DO 10 J = 2,NDOT                                                  DH2  380                                                         
      XD(J) = XD(J-1) + XSTEP                                           DH2  390                                                         
      YD(J) = YD(J-1) + YSTEP                                           DH2  400                                                         
   10 CONTINUE                                                          DH2  410                                                         
   20 CONTINUE                                                          DH2  420                                                         
       DO 30 L = 1,NDOT                                                 DH2  430                                                         
       KPT = KPT + 1                                                    DH2  440                                                         
       IF(KPT .EQ. 1) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,3)      DH2  450                                                         
       IF(KPT .EQ. 5) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,2)      DH2  460                                                         
       IF(KPT .EQ. 6)                                                   DH2  470                                                         
     +CALL SYMBOL((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,.03,5,0.0,-1)         DH2  480                                                         
       IF(KPT .EQ. 7)                                                   DH2  490                                                         
     +CALL SYMBOL((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,.03,5,0.0,-1)         DH2  500                                                         
       IF(KPT .EQ. 7) KPT = 0                                           DH2  510                                                         
30     CONTINUE                                                         DH2  520                                                         
       IF(KPT .GE. 1 .AND. KPT .LE.4)                                   DH2  530                                                         
     +CALL PLOT((X(I)-XMIN)/DX,(Y(I)-YMIN)/DY,2)                        DH2  540                                                         
  150 RESID = TLEN - NDOT * DOTLEN                                      DH2  550                                                         
  200 CONTINUE                                                          DH2  560                                                         
250    CONTINUE                                                         DH2  570                                                         
      IF(NUMSYM .EQ. 0) GO TO 300                                       DH2  580                                                         
      IF(NUMSYM .LT. 0) NUMSYM = IABS(NUMSYM)                           DH2  590                                                         
      DO 40 MN = 1,N,NUMSYM                                             DH2  600                                                         
      CALL SYMBOL((X(MN)-XMIN)/DX,(Y(MN)-YMIN)/DY,SYMSZE,JSYM,0.0,-1)   DH2  610                                                         
 40   CONTINUE                                                          DH2  620                                                         
300   CONTINUE                                                          DH2  630                                                         
      RETURN                                                            DH2  640                                                         
      END                                                               DH2  650                                                         
      SUBROUTINE DSHDOT(X,Y,N,K,NUMSYM,JSYM,XMIN,DX,YMIN,DY,SYMSZE)     DDT  100                                                         
CCC                                                                     DDT  110                                                         
CCC   DRAWS A LINE WITH ALTERNATING DASHES AND DOTS                     DDT  120                                                         
CCC                                                                     DDT  130                                                         
      DIMENSION X(N),Y(N),XD(200),YD(200)                               DDT  140                                                         
      COMMON/XXDYYD/XD,YD                                               DDT  150                                                         
      DATA DOTLEN/0.09/                                                 DDT  160                                                         
      KPT = 0                                                           DDT  170                                                         
      IF (NUMSYM .LT. 0) GO TO 250                                      DDT  180                                                         
      XDOT = DX * DOTLEN                                                DDT  190                                                         
      YDOT = DY * DOTLEN                                                DDT  200                                                         
      RESID = DOTLEN                                                    DDT  210                                                         
      MB = K+1                                                          DDT  220                                                         
      DO 200 I = MB,N,K                                                 DDT  230                                                         
      XLEN = (X(I)-X(I-K))/DX                                           DDT  240                                                         
      YLEN = (Y(I) - Y(I-K))/DY                                         DDT  250                                                         
      SLEN = SQRT(XLEN **2 + YLEN **2)                                  DDT  260                                                         
      IF(SLEN .LE. 0.) GO TO 200                                        DDT  270                                                         
      TLEN = SLEN + RESID                                               DDT  280                                                         
      NDOT = 0                                                          DDT  290                                                         
      IF ( TLEN .LT. DOTLEN ) GO TO 150                                 DDT  300                                                         
      NDOT = INT(TLEN / DOTLEN)                                         DDT  310                                                         
      XSTEP = XDOT * XLEN/SLEN                                          DDT  320                                                         
      YSTEP = YDOT * YLEN/SLEN                                          DDT  330                                                         
      SS = 1. - RESID/DOTLEN                                            DDT  340                                                         
      YD(1) = SS * YSTEP + Y(I-K)                                       DDT  350                                                         
      XD(1) = SS * XSTEP + X(I-K)                                       DDT  360                                                         
      IF ( NDOT .LT. 2 ) GO TO 20                                       DDT  370                                                         
      DO 10 J = 2,NDOT                                                  DDT  380                                                         
      XD(J) = XD(J-1) + XSTEP                                           DDT  390                                                         
      YD(J) = YD(J-1) + YSTEP                                           DDT  400                                                         
   10 CONTINUE                                                          DDT  410                                                         
   20 CONTINUE                                                          DDT  420                                                         
       DO 30 L = 1,NDOT                                                 DDT  430                                                         
       KPT = KPT + 1                                                    DDT  440                                                         
       IF(KPT .EQ. 1) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,3)      DDT  450                                                         
       IF(KPT .EQ. 3) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,2)      DDT  460                                                         
       IF(KPT .EQ. 4)                                                   DDT  470                                                         
     +CALL SYMBOL((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,.03,5,0.0,-1)         DDT  480                                                         
       IF(KPT .EQ. 4) KPT = 0                                           DDT  490                                                         
30     CONTINUE                                                         DDT  500                                                         
       IF(KPT .GE. 1 .AND. KPT .LE.2)                                   DDT  510                                                         
     +CALL PLOT((X(I)-XMIN)/DX,(Y(I)-YMIN)/DY,2)                        DDT  520                                                         
  150 RESID = TLEN - NDOT * DOTLEN                                      DDT  530                                                         
  200 CONTINUE                                                          DDT  540                                                         
250    CONTINUE                                                         DDT  550                                                         
      IF(NUMSYM .EQ. 0) GO TO 300                                       DDT  560                                                         
      IF(NUMSYM .LT. 0) NUMSYM = IABS(NUMSYM)                           DDT  570                                                         
      DO 40 MN = 1,N,NUMSYM                                             DDT  580                                                         
      CALL SYMBOL((X(MN)-XMIN)/DX,(Y(MN)-YMIN)/DY,SYMSZE,JSYM,0.0,-1)   DDT  590                                                         
 40   CONTINUE                                                          DDT  600                                                         
300   CONTINUE                                                          DDT  610                                                         
      RETURN                                                            DDT  620                                                         
      END                                                               DDT  630                                                         
      SUBROUTINE DASH2(X,Y,N,K,NUMSYM,JSYM,XMIN,DX,YMIN,DY,SYMSZE,      SH2  100                                                         
     +LDASH1,LDASH2)                                                    SH2  110                                                         
CCC                                                                     SH2  120                                                         
CCC   VARIABLE LENGTH DASH ROUTINE                                      SH2  130                                                         
CCC                                                                     SH2  140                                                         
      DIMENSION X(N),Y(N),XD(200),YD(200)                               SH2  150                                                         
      COMMON/XXDYYD/XD,YD                                               SH2  160                                                         
      DATA DOTLEN/0.1/                                                  SH2  170                                                         
      KPT = 0                                                           SH2  180                                                         
      IF (NUMSYM .LT. 0) GO TO 250                                      SH2  190                                                         
      M1 = 1 + LDASH1                                                   SH2  200                                                         
      MS2 = M1 + 1                                                      SH2  210                                                         
      M2 = MS2 + LDASH2                                                 SH2  220                                                         
      XDOT = DX * DOTLEN                                                SH2  230                                                         
      YDOT = DY * DOTLEN                                                SH2  240                                                         
      RESID = DOTLEN                                                    SH2  250                                                         
      MB = K+1                                                          SH2  260                                                         
      DO 200 I = MB,N,K                                                 SH2  270                                                         
      XLEN = (X(I)-X(I-K))/DX                                           SH2  280                                                         
      YLEN = (Y(I) - Y(I-K))/DY                                         SH2  290                                                         
      SLEN = SQRT(XLEN **2 + YLEN **2)                                  SH2  300                                                         
      IF(SLEN .LE. 0.) GO TO 200                                        SH2  310                                                         
      TLEN = SLEN + RESID                                               SH2  320                                                         
      NDOT = 0                                                          SH2  330                                                         
      IF ( TLEN .LT. DOTLEN ) GO TO 150                                 SH2  340                                                         
      NDOT = INT(TLEN / DOTLEN)                                         SH2  350                                                         
      XSTEP = XDOT * XLEN/SLEN                                          SH2  360                                                         
      YSTEP = YDOT * YLEN/SLEN                                          SH2  370                                                         
      SS = 1. - RESID/DOTLEN                                            SH2  380                                                         
      YD(1) = SS * YSTEP + Y(I-K)                                       SH2  390                                                         
      XD(1) = SS * XSTEP + X(I-K)                                       SH2  400                                                         
      IF ( NDOT .LT. 2 ) GO TO 20                                       SH2  410                                                         
      DO 10 J = 2,NDOT                                                  SH2  420                                                         
      XD(J) = XD(J-1) + XSTEP                                           SH2  430                                                         
      YD(J) = YD(J-1) + YSTEP                                           SH2  440                                                         
   10 CONTINUE                                                          SH2  450                                                         
   20 CONTINUE                                                          SH2  460                                                         
       DO 30 L = 1,NDOT                                                 SH2  470                                                         
       KPT = KPT + 1                                                    SH2  480                                                         
       IF(KPT .EQ. 1) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,3)      SH2  490                                                         
       IF(KPT .EQ. M1) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,2)     SH2  500                                                         
       IF(KPT .EQ. MS2) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,3)    SH2  510                                                         
       IF(KPT .EQ. M2 ) CALL PLOT((XD(L)-XMIN)/DX,(YD(L)-YMIN)/DY,2)    SH2  520                                                         
      IF(KPT .EQ. M2) KPT = 0                                           SH2  530                                                         
30     CONTINUE                                                         SH2  540                                                         
      IF(KPT .GE. 1 .AND. KPT .LT. M1)                                  SH2  550                                                         
     +CALL PLOT((X(I)-XMIN)/DX,(Y(I)-YMIN)/DY,2)                        SH2  560                                                         
      IF(KPT .GE. MS2 .AND. KPT .LT. M2)                                SH2  570                                                         
     +CALL PLOT((X(I)-XMIN)/DX,(Y(I)-YMIN)/DY,2)                        SH2  580                                                         
  150 RESID = TLEN - NDOT * DOTLEN                                      SH2  590                                                         
  200 CONTINUE                                                          SH2  600                                                         
250    CONTINUE                                                         SH2  610                                                         
      IF(NUMSYM .EQ. 0) GO TO 300                                       SH2  620                                                         
      IF(NUMSYM .LT. 0) NUMSYM = IABS(NUMSYM)                           SH2  630                                                         
      DO 40 MN = 1,N,NUMSYM                                             SH2  640                                                         
      CALL SYMBOL((X(MN)-XMIN)/DX,(Y(MN)-YMIN)/DY,SYMSZE,JSYM,0.0,-1)   SH2  650                                                         
 40   CONTINUE                                                          SH2  660                                                         
300   CONTINUE                                                          SH2  670                                                         
      RETURN                                                            SH2  680                                                         
      END                                                               SH2  690                                                         
      SUBROUTINE LIN1 (XD,YD,NDOT,J,K,L,                                LN1  100                                                         
     X                 XMIN,DX,YMIN,DY,DOTSIZ)                          LN1  110                                                         
       DIMENSION XD(*),YD(*)                                            LN1  120                                                         
CC>    XD(NDOT+1) = XMIN                                                LN1  130                                                         
CC>    YD(NDOT+1) = YMIN                                                LN1  140                                                         
CC>    XD(NDOT+2) = DX                                                  LN1  150                                                         
CC>    YD(NDOT+2) = DY                                                  LN1  160                                                         
CC>    CALL LINE(XD,YD,NDOT,J,K,L)                                      LN1  170                                                         
C                                                                       LN1  180                                                         
C                                                                       LN1  190                                                         
C                                                                       LN1  200                                                         
       CALL LINE (XD,YD,NDOT,J,K,L,XMIN,DX,YMIN,DY,DOTSIZ)              LN1  210                                                         
       RETURN                                                           LN1  220                                                         
       END                                                              LN1  230                                                         
