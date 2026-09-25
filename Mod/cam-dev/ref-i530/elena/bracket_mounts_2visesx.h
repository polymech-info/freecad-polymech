0  BEGIN PGM bracket_mounts_2visesx MM 
1  BLK FORM 0.1 Z  X+0  Y-70  Z-20
2  BLK FORM 0.2  X+125  Y+0  Z+0
3  ;-------------------------------------
4  ;Machine
5  ;  vendor: Autodesk
6  ;  model: Generic 3-axis
7  ;  description: This machine has YX axis on the Table and Z axis on the~
 Head
8  ;-------------------------------------
9  ;
10 ;-------------------------------------
11 ;Tools
12 ;  #5 D=8 TAPER=118deg - ZMIN=-24.403 - ZMAX=+15 - drill
13 ;-------------------------------------
14 ;
15 * - Drill7
16 M5
17 TOOL CALL 5 Z S1247
18 L M140 MB MAX
19 M3
20 LBL 1
21 CYCL DEF 247 DATUM SETTING ~
    Q339=+1    ;DATUM NUMBER
22 LBL 0
23 L  X+115  Y-10 R0 FMAX
24 L  Z+15 R0 FMAX
25 M8
26 CYCL DEF 32.0 TOLERANCE
27 CYCL DEF 32.1
28 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-24.403 ;DEPTH ~
    Q206=+131  ;FEED RATE FOR PLNGNG ~
    Q202=+4    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
29 L FMAX M99
30 L  Y-60 FMAX M99
31 L  X+10 FMAX M99
32 L  Y-10 FMAX M99
33 L  Z+15 FMAX
34 L M140 MB MAX
35 * - Drill7
36 M3
37 LBL 2
38 CYCL DEF 247 DATUM SETTING ~
    Q339=+2    ;DATUM NUMBER
39 LBL 0
40 L  X+115  Y-10 R0 FMAX
41 L  Z+15 R0 FMAX
42 CYCL DEF 200 DRILLING ~
    Q200=+5    ;SET-UP CLEARANCE ~
    Q201=-24.403 ;DEPTH ~
    Q206=+131  ;FEED RATE FOR PLNGNG ~
    Q202=+4    ;PLUNGING DEPTH ~
    Q210=+0    ;DWELL TIME AT TOP ~
    Q203=+0    ;SURFACE COORDINATE ~
    Q204=+5    ;2ND SET-UP CLEARANCE ~
    Q211=+0    ;DWELL TIME AT DEPTH
43 L FMAX M99
44 L  Y-60 FMAX M99
45 L  X+10 FMAX M99
46 L  Y-10 FMAX M99
47 L  Z+15 FMAX
48 M9
49 M5
50 L M140 MB MAX
51 M30
52 END PGM bracket_mounts_2visesx MM 
