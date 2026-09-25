0  BEGIN PGM tap-m8s MM 
1  BLK FORM 0.1 Z  X+0  Y-122  Z-40
2  BLK FORM 0.2  X+122  Y+0  Z+0
3  ;-------------------------------------
4  ;T8 D=+8 CR=+0 - ZMIN=-38 - right hand tap
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Drill1 (22)
10 TOOL CALL 8 Z S4158
11 L M140 MB MAX
12 M3
13 L  X+20  Y-102 R0 FMAX
14 L  Z+80 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 207 RIGID TAPPING ~
    Q200=+25   ;SET-UP CLEARANCE ~
    Q201=-38   ;DEPTH OF THREAD ~
    Q239=+1.25 ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+40   ;2ND SET-UP CLEARANCE
19 L FMAX M99
20 L  X+102 FMAX M99
21 L  Y-20 FMAX M99
22 L  X+20 FMAX M99
23 L  Z+80 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM tap-m8s MM 
