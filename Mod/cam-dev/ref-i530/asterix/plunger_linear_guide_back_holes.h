0  BEGIN PGM plunger_linear_guide_back_holes MM 
1  BLK FORM 0.1 Z  X+0  Y-30  Z-6
2  BLK FORM 0.2  X+44  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=5 TAPER=118deg - ZMIN=-8 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill1 (2)
9  M5
10 TOOL CALL 7 Z S873
11 L M140 MB MAX
12 M3
13 L  X+31.965  Y-25 R0 FMAX
14 L  Z+15 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-8    ;DEPTH ~
    Q206=+65   ;FEED RATE FOR PLNGNG ~
    Q202=+8    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
18 L FMAX M99
19 L  X+12.035 FMAX M99
20 L  Y-5 FMAX M99
21 L  X+31.965 FMAX M99
22 L  Z+15 FMAX
23 M5
24 L M140 MB MAX
25 M30
26 END PGM plunger_linear_guide_back_holes MM 
