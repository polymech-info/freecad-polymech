0  BEGIN PGM tap-m6s MM 
1  BLK FORM 0.1 Z  X-60  Y-12.5  Z-25
2  BLK FORM 0.2  X+60  Y+12.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=6 - ZMIN=-23.5 - ZMAX=+15 - right hand tap
6  ;-------------------------------------
7  ;
8  * - Drill1 (2)
9  M5
10 TOOL CALL 7 Z S1746
11 L M140 MB MAX
12 M3
13 L  X-52  Y+0 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-21   ;DEPTH OF THREAD ~
    Q239=+1    ;THREAD PITCH ~
    Q203=-2.5  ;SURFACE COORDINATE ~
    Q204=+7.5  ;2ND SET-UP CLEARANCE
19 L FMAX M99
20 L  Z+15 FMAX
21 M9
22 M5
23 L M140 MB MAX
24 M30
25 END PGM tap-m6s MM 
