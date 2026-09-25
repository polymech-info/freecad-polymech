0  BEGIN PGM tap-m8-1 MM 
1  BLK FORM 0.1 Z  X-35  Y-30  Z-20
2  BLK FORM 0.2  X+35  Y+30  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=8 - ZMIN=-25 - ZMAX=+10 - right hand tap
6  ;-------------------------------------
7  ;
8  * - Drill2
9  M5
10 TOOL CALL 7 Z S3638
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+10 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-25   ;DEPTH OF THREAD ~
    Q239=+1.25 ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE
18 L FMAX M99
19 L  Z+10 FMAX
20 M5
21 L M140 MB MAX
22 M30
23 END PGM tap-m8-1 MM 
