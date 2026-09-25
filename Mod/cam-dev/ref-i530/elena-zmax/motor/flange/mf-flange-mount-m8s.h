0  BEGIN PGM mf-flange-mount-m8s MM 
1  BLK FORM 0.1 Z  X+0  Y-176  Z-30
2  BLK FORM 0.2  X+218  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #5 D=6.8 TAPER=90deg - ZMIN=-33 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill2
9  M5
10 TOOL CALL 5 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+44  Y-88 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 203 UNIVERSAL DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-25   ;DEPTH ~
    Q206=+333  ;FEED RATE FOR PLNGNG ~
    Q202=+8    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=-8    ;SURFACE COORDINATE ~
    Q204=+13   ;2ND SET-UP CLEARANCE ~
    Q212=+0    ;DECREMENT ~
    Q213=+1    ;NR OF BREAKS ~
    Q205=+8    ;MIN. PLUNGING DEPTH ~
    Q211=+0    ;DWELL TIME AT DEPTH ~
    Q208= MAX ;RETRACTION FEED RATE ~
    Q256=+1.36 ;DIST FOR CHIP BRKNG
19 L FMAX M99
20 L  X+174 FMAX M99
21 L  Z+15 FMAX
22 M9
23 M5
24 L M140 MB MAX
25 M30
26 END PGM mf-flange-mount-m8s MM 
