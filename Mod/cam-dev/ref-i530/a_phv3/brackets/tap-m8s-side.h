0  BEGIN PGM tap-m8s-side MM 
1  BLK FORM 0.1 Z  X+0  Y-30  Z-119.432
2  BLK FORM 0.2  X+148.401  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #8 D=8 - ZMIN=-34 - ZMAX=+15 - right hand tap
6  ;-------------------------------------
7  ;
8  * - spot (34)
9  M5
10 TOOL CALL 8 Z S2911
11 L M140 MB MAX
12 M3
13 L  X+41.209  Y-7.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-34   ;DEPTH OF THREAD ~
    Q239=+1.27 ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE
19 L FMAX M99
20 L  Y-22.5 FMAX M99
21 L  X+71.209 FMAX M99
22 L  Y-7.5 FMAX M99
23 L  Z+15 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM tap-m8s-side MM 
