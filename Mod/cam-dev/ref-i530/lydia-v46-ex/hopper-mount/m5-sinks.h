0  BEGIN PGM m5-sinks MM 
1  BLK FORM 0.1 Z  X+0  Y-85  Z-30
2  BLK FORM 0.2  X+115  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=8 TAPER=118deg - ZMIN=-8 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill6
9  M5
10 TOOL CALL 12 Z S4158
11 L M140 MB MAX
12 M3
13 L  X+37.5  Y-77.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-8    ;DEPTH ~
    Q206=+437  ;FEED RATE FOR PLNGNG ~
    Q202=+8    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  X+77.5 FMAX M99
21 L  Y-7.5 FMAX M99
22 L  X+37.5 FMAX M99
23 L  Z+15 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM m5-sinks MM 
