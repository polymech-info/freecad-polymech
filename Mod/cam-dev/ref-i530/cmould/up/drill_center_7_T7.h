0  BEGIN PGM drill_center_7_T7 MM 
1  BLK FORM 0.1 Z  X+0  Y-300  Z-25
2  BLK FORM 0.2  X+300  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=7 TAPER=118deg - ZMIN=-30.103 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill1
9  M5
10 TOOL CALL 7 Z S4158
11 L M140 MB MAX
12 M3
13 L  X+150  Y-150 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-30.103 ;DEPTH ~
    Q206=+437  ;FEED RATE FOR PLNGNG ~
    Q202=+30.103 ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  Z+15 FMAX
21 M9
22 M5
23 L M140 MB MAX
24 M30
25 END PGM drill_center_7_T7 MM 
