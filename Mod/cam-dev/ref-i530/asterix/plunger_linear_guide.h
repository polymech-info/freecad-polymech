0  BEGIN PGM plunger_linear_guide MM 
1  BLK FORM 0.1 Z  X-40  Y-30  Z-8
2  BLK FORM 0.2  X+40  Y+30  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #100 D=6 CR=3 - ZMIN=-7 - ZMAX=+55 - probe
6  ;    Stock Haas Probe
7  ;    Renishaw
8  ;    OMP40-2
9  ;-------------------------------------
10 ;
11 * - Probe WCS1
12 M5
13 TOOL CALL 100 Z S50
14 ;Stock Haas Probe
15 L M140 MB MAX
16 L  X+22.5  Y+0 R0 FMAX
17 L  Z+55 R0 FMAX
18 CYCL DEF 32.0 TOLERANCE
19 CYCL DEF 32.1
20 TCH PROBE 417 DATUM IN TS AXIS ~
    Q263=+22.5 ;1ST POINT 1ST AXIS ~
    Q264=+0    ;1ST POINT 2ND AXIS ~
    Q294=+0    ;1ST POINT 3RD AXIS ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q333=+0    ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER
21 L  Z+55 FMAX
22 * - Probe WCS2
23 L  X+22.5  Y+0 R0 FMAX
24 L  Z+55 R0 FMAX
25 TCH PROBE 411 DATUM OUTS. RECTAN. ~
    Q321=+22.5 ;CENTER IN 1ST AXIS ~
    Q322=+0    ;CENTER IN 2ND AXIS ~
    Q323=+35   ;FIRST SIDE LENGTH ~
    Q324=+60   ;2ND SIDE LENGTH ~
    Q261=-4    ;MEASURING HEIGHT ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q301=+1    ;MOVE TO CLEARANCE ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q331=+22.5 ;DATUM ~
    Q332=+0    ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER ~
    Q381=+0    ;PROBE IN TS AXIS ~
    Q382=+0    ;1ST CO. FOR TS AXIS ~
    Q383=+0    ;2ND CO. FOR TS AXIS ~
    Q384=+0    ;3RD CO. FOR TS AXIS ~
    Q333=+0    ;DATUM
26 L  Z+55 FMAX
27 M5
28 L M140 MB MAX
29 M30
30 END PGM plunger_linear_guide MM 
