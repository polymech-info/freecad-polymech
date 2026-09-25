0  BEGIN PGM tap-m8s-top-single MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-80
2  BLK FORM 0.2  X+155  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #8 D=8 - ZMIN=-31 - ZMAX=+15 - right hand tap
6  ;-------------------------------------
7  ;
8  * - Drill3 (6)
9  M5
10 TOOL CALL 8 Z S4158
11 L M140 MB MAX
12 M3
13 LBL 1
14 CYCL DEF 247 DATUM SETTING ~
    Q339=+1    ;DATUM NUMBER
15 LBL 0
16 L  X+74.4  Y-8.25 R0 FMAX
17 L  Z+15 R0 FMAX
18 M8
19 CYCL DEF 32.0 TOLERANCE
20 CYCL DEF 32.1
21 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-31   ;DEPTH OF THREAD ~
    Q239=+1.25 ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE
22 L FMAX M99
23 L  Y-51.75 FMAX M99
24 L  X+25.4 FMAX M99
25 L  Y-8.25 FMAX M99
26 L  Z+15 FMAX
27 M9
28 M5
29 L M140 MB MAX
30 M30
31 END PGM tap-m8s-top-single MM 
