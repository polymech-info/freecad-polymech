0  BEGIN PGM spot-bores MM 
1  BLK FORM 0.1 Z  X+0  Y-38  Z-48
2  BLK FORM 0.2  X+60  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #2 D=7 TAPER=118deg - ZMIN=-10 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill1 (2)
9  M5
10 TOOL CALL 2 Z S1247
11 L M140 MB MAX
12 M3
13 L  X+13  Y-13.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-10   ;DEPTH ~
    Q206=+131  ;FEED RATE FOR PLNGNG ~
    Q202=+10   ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  X+30  Y-14 FMAX M99
21 L  X+47  Y-13.5 FMAX M99
22 L  Z+15 FMAX
23 M9
24 M5
25 L M140 MB MAX
26 M30
27 END PGM spot-bores MM 
