0  BEGIN PGM m8s-tap MM 
1  BLK FORM 0.1 Z  X+0  Y-30  Z-207.8
2  BLK FORM 0.2  X+478.9  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=8 - ZMIN=-32 - ZMAX=+15 - right hand tap
6  ;-------------------------------------
7  ;
8  * - mmount (5)
9  M5
10 TOOL CALL 7 Z S500
11 L M140 MB MAX
12 M3
13 L  X+140  Y-15 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-32   ;DEPTH OF THREAD ~
    Q239=+1.25 ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE
19 L FMAX M99
20 L  X+185 FMAX M99
21 L  X+230 FMAX M99
22 L  X+275 FMAX M99
23 L  X+320 FMAX M99
24 L  Z+15 FMAX
25 M9
26 M5
27 L M140 MB MAX
28 M30
29 END PGM m8s-tap MM 
