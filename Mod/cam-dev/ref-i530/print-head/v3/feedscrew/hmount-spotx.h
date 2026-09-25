0  BEGIN PGM hmount-spotx MM 
1  BLK FORM 0.1 Z  X+0  Y-50  Z-20
2  BLK FORM 0.2  X+115  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=5 TAPER=90deg - ZMIN=-6 - ZMAX=+21 - spot drill
6  ;-------------------------------------
7  ;
8  * - Drill1 (8)
9  M5
10 TOOL CALL 7 Z S10000
11 L M140 MB MAX
12 M3
13 L  X+25  Y-7.5 R0 FMAX
14 L  Z+21 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-6    ;DEPTH ~
    Q206=+30   ;FEED RATE FOR PLNGNG ~
    Q202=+6    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+11   ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  X+90 FMAX M99
21 L  Y-42.5 FMAX M99
22 L  X+25 FMAX M99
23 L  Z+21 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM hmount-spotx MM 
