0  BEGIN PGM spot-m7sx MM 
1  BLK FORM 0.1 Z  X-40  Y-30  Z-20
2  BLK FORM 0.2  X+40  Y+30  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=5 TAPER=90deg - ZMIN=-7 - ZMAX=+21 - spot drill
6  ;-------------------------------------
7  ;
8  * - Drill1 (10)
9  M5
10 TOOL CALL 7 Z S10000
11 L M140 MB MAX
12 M3
13 L  X+32.5  Y+17.5 R0 FMAX
14 L  Z+21 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-7    ;DEPTH ~
    Q206=+30   ;FEED RATE FOR PLNGNG ~
    Q202=+7    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+11   ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  Y-17.5 FMAX M99
21 L  X-32.5 FMAX M99
22 L  Z+21 FMAX
23 M9
24 M5
25 L M140 MB MAX
26 M30
27 END PGM spot-m7sx MM 
