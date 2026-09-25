0  BEGIN PGM tap-m8s-support MM 
1  BLK FORM 0.1 Z  X-227.566  Y-115  Z-30
2  BLK FORM 0.2  X+422.434  Y+115  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #8 D=8 - ZMIN=-36 - ZMAX=+15 - right hand tap
6  ;-------------------------------------
7  ;
8  * - spot (22)
9  M5
10 TOOL CALL 8 Z S2911
11 L M140 MB MAX
12 M3
13 L  X+234.904  Y+82.344 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-36   ;DEPTH OF THREAD ~
    Q239=+1.27 ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE
19 L FMAX M99
20 L  X+156.269 FMAX M99
21 L  Y-82.344 FMAX M99
22 L  X+234.904 FMAX M99
23 L  Z+15 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM tap-m8s-support MM 
