0  BEGIN PGM m8_tap_up MM 
1  BLK FORM 0.1 Z  X+0  Y-70  Z-20
2  BLK FORM 0.2  X+142  Y+0  Z+0
3  ;-------------------------------------
4  ;Machine
5  ;  vendor: Autodesk
6  ;  model: Generic 3-axis
7  ;  description: This machine has YX axis on the Table and Z axis on the~
 Head
8  ;-------------------------------------
9  ;
10 ;-------------------------------------
11 ;Tools
12 ;  #2 D=8 - ZMIN=-25 - ZMAX=+15 - right hand tap
13 ;-------------------------------------
14 ;
15 * - Drill3
16 M5
17 TOOL CALL 2 Z S4158
18 L M140 MB MAX
19 M3
20 L  X+125.8  Y-60 R0 FMAX
21 L  Z+15 R0 FMAX
22 M8
23 CYCL DEF 32.0 TOLERANCE
24 CYCL DEF 32.1
25 CYCL DEF 207 RIGID TAPPING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-25   ;DEPTH OF THREAD ~
    Q239=+1.25 ;THREAD PITCH ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE
26 L FMAX M99
27 L  Y-10 FMAX M99
28 L  X+8.3 FMAX M99
29 L  Y-60 FMAX M99
30 L  Z+15 FMAX
31 M9
32 M5
33 L M140 MB MAX
34 M30
35 END PGM m8_tap_up MM 
