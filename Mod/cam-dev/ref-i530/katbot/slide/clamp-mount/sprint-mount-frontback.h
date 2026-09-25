0  BEGIN PGM sprint-mount-frontback MM 
1  BLK FORM 0.1 Z  X+0  Y-68  Z-68
2  BLK FORM 0.2  X+70  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=5 TAPER=118deg - ZMIN=-20 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill3 (3)
9  M5
10 TOOL CALL 7 Z S624
11 L M140 MB MAX
12 M3
13 L  X+35  Y-34 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-20   ;DEPTH ~
    Q206=+1000 ;FEED RATE FOR PLNGNG ~
    Q202=+20   ;PLUNGING DEPTH ~
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
25 END PGM sprint-mount-frontback MM 
