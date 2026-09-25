0  BEGIN PGM m6s-post MM 
1  BLK FORM 0.1 Z  X+0  Y-44  Z-40
2  BLK FORM 0.2  X+100  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #2 D=5 TAPER=90deg - ZMIN=-28.5 - ZMAX=+15 - spot drill
6  ;-------------------------------------
7  ;
8  * - Drill18 (2)
9  M5
10 TOOL CALL 2 Z S1746
11 L M140 MB MAX
12 M3
13 L  X+26.5  Y-22 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-28.5 ;DEPTH ~
    Q206=+131  ;FEED RATE FOR PLNGNG ~
    Q202=+28.5 ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  X+73.5 FMAX M99
21 L  Z+15 FMAX
22 M9
23 M5
24 L M140 MB MAX
25 M30
26 END PGM m6s-post MM 
