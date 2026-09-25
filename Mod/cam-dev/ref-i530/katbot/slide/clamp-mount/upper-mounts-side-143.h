0  BEGIN PGM upper-mounts-side-143 MM 
1  BLK FORM 0.1 Z  X-14  Y-68  Z-65
2  BLK FORM 0.2  X+54  Y+0  Z+5
3  ;-------------------------------------
4  ;Tools
5  ;  #7 D=5 TAPER=118deg - ZMIN=-8 - ZMAX=+20 - drill
6  ;-------------------------------------
7  ;
8  * - Drill3 (2)
9  M5
10 TOOL CALL 7 Z S624
11 L M140 MB MAX
12 M3
13 L  X+20  Y-27.051 R0 FMAX
14 L  Z+20 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-8    ;DEPTH ~
    Q206=+1000 ;FEED RATE FOR PLNGNG ~
    Q202=+8    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+10   ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
19 L FMAX M99
20 L  Y-41.351 FMAX M99
21 L  Z+20 FMAX
22 M9
23 M5
24 L M140 MB MAX
25 M30
26 END PGM upper-mounts-side-143 MM 
