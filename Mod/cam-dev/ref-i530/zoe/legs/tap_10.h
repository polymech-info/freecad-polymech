0  BEGIN PGM tap_10 MM 
1  BLK FORM 0.1 Z  X+0  Y-40  Z-8
2  BLK FORM 0.2  X+125.1  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=10 - ZMIN=-18 - ZMAX=+15 - right hand tap
6  ;-------------------------------------
7  ;
8  * - Drill1 (2)
9  M5
10 TOOL CALL 7 Z S1247
11 L M140 MB MAX
12 M3
13 L  X+20  Y-20 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-18   ;DEPTH OF THREAD ~
    Q239=+1.5  ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE
19 L FMAX M99
20 L  X+61.7 FMAX M99
21 L  X+103.4 FMAX M99
22 L  Z+15 FMAX
23 M9
24 M5
25 L M140 MB MAX
26 M30
27 END PGM tap_10 MM 
