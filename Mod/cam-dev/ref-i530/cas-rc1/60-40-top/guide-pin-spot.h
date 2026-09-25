0  BEGIN PGM guide-pin-spot MM 
1  BLK FORM 0.1 Z  X+0  Y-82  Z-45
2  BLK FORM 0.2  X+142  Y+0  Z+0
3  ;-------------------------------------
4  ;T3 D=+7 CR=+0 TAPER=118deg - ZMIN=-15 - drill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Drill1 (13)
10 TOOL CALL 3 Z S1247
11 L M140 MB MAX
12 M3
13 L  X+71  Y-13 R0 FMAX
14 L  Z+35 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 203 UNIVERSAL DRILLING ~
    Q200=+25   ;SET-UP CLEARANCE ~
    Q201=-15   ;DEPTH ~
    Q206=+131  ;FEED RATE FOR PLNGNG ~
    Q202=+4    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+25   ;2ND SET-UP CLEARANCE ~
    Q212=+0    ;DECREMENT ~
    Q213=+1    ;NR OF BREAKS ~
    Q205=+4    ;MIN. PLUNGING DEPTH ~
    Q211=+0    ;DWELL TIME AT DEPTH ~
    Q208= MAX ;RETRACTION FEED RATE ~
    Q256=+2    ;DIST FOR CHIP BRKNG
19 L FMAX M99
20 L  Z+35 FMAX
21 M9
22 M5
23 L M140 MB MAX
24 M30
25 END PGM guide-pin-spot MM 
