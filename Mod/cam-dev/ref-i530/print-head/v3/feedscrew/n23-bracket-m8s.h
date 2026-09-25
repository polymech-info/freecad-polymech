0  BEGIN PGM n23-bracket-m8s MM 
1  BLK FORM 0.1 Z  X+0  Y-60  Z-20
2  BLK FORM 0.2  X+80  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #5 D=8 TAPER=90deg - ZMIN=-21 - ZMAX=+15 - spot drill
6  ;-------------------------------------
7  ;
8  * - Drill1 (2)
9  M5
10 TOOL CALL 5 Z S10000
11 L M140 MB MAX
12 M3
13 L  X+72.5  Y-12.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-21   ;DEPTH ~
    Q206=+30   ;FEED RATE FOR PLNGNG ~
    Q202=+6    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  Y-47.5 FMAX M99
21 L  X+7.5  Y-12.5 FMAX M99
22 L  Y-47.5 FMAX M99
23 L  Z+15 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM n23-bracket-m8s MM 
