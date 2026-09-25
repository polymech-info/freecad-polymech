0  BEGIN PGM cab-mount-holes-left-M8 MM 
1  BLK FORM 0.1 Z  X+0  Y+0  Z-200
2  BLK FORM 0.2  X+300  Y+150  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #5 D=6.8 TAPER=118deg - ZMIN=-10 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill1
9  M5
10 TOOL CALL 5 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+50  Y+35 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-10   ;DEPTH ~
    Q206=+45   ;FEED RATE FOR PLNGNG ~
    Q202=+10   ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  X+250 FMAX M99
21 L  Z+15 FMAX
22 M9
23 M5
24 L M140 MB MAX
25 M30
26 END PGM cab-mount-holes-left-M8 MM 
