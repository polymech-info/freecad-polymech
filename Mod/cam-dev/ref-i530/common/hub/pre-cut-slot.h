0  BEGIN PGM pre-cut-slot MM 
1  BLK FORM 0.1 Z  X-35  Y-35  Z-32
2  BLK FORM 0.2  X+35  Y+35  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 TAPER=179deg - ZMIN=-32.5 - ZMAX=+15 - drill
6  ;-------------------------------------
7  ;
8  * - Drill3 (2)
9  M5
10 TOOL CALL 12 Z S4158
11 L M140 MB MAX
12 M3
13 L  X+0  Y+11.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 203 UNIVERSAL DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-32.5 ;DEPTH ~
    Q206=+437  ;FEED RATE FOR PLNGNG ~
    Q202=+5    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q212=+0    ;DECREMENT ~
    Q213=+5    ;NR OF BREAKS ~
    Q205=+5    ;MIN. PLUNGING DEPTH ~
    Q211=+0    ;DWELL TIME AT DEPTH ~
    Q208= MAX ;RETRACTION FEED RATE ~
    Q256=+2    ;DIST FOR CHIP BRKNG
19 L FMAX M99
20 L  Z+15 FMAX
21 M9
22 M5
23 L M140 MB MAX
24 M30
25 END PGM pre-cut-slot MM 
