0  BEGIN PGM spot-bf MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-14
2  BLK FORM 0.2  X+100  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=5 TAPER=90deg - ZMIN=-4 - ZMAX=+15 - spot drill
6  ;-------------------------------------
7  ;
8  * - Drill6 (2)
9  M5
10 TOOL CALL 7 Z S1746
11 L M140 MB MAX
12 M3
13 L  X+27  Y-60 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-4    ;DEPTH ~
    Q206=+131  ;FEED RATE FOR PLNGNG ~
    Q202=+4    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  X+50  Y-40 FMAX M99
21 L  X+73  Y-60 FMAX M99
22 L  Z+15 FMAX
23 M9
24 M5
25 L M140 MB MAX
26 M30
27 END PGM spot-bf MM 
