0  BEGIN PGM pilot-m20s-14 MM 
1  BLK FORM 0.1 Z  X+0  Y-118  Z-40
2  BLK FORM 0.2  X+118  Y+0  Z+0
3  ;-------------------------------------
4  ;T27 D=+14 CR=+0 - ZMIN=-42 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Drill2
10 TOOL CALL 27 Z S2274
11 L M140 MB MAX
12 M3
13 L  X+89  Y-84 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-42   ;DEPTH ~
    Q206=+67   ;FEED RATE FOR PLNGNG ~
    Q202=+10   ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+1    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  Y-34 FMAX M99
21 L  X+29 FMAX M99
22 L  Y-84 FMAX M99
23 L  Z+15 FMAX
24 M9
25 M5
26 L M140 MB MAX
27 M30
28 END PGM pilot-m20s-14 MM 
