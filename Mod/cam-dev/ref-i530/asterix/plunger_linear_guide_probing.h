0  BEGIN PGM plunger_linear_guide_probing MM 
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
16 L  X-22.5  Y+0 R0 FMAX
17 L  Z+55 R0 FMAX
18 CYCL DEF 32.0 TOLERANCE
19 CYCL DEF 32.1
20 TCH PROBE 417 DATUM IN TS AXIS ~
    Q263=-22.5 ;1ST POINT 1ST AXIS ~
    Q264=+0    ;1ST POINT 2ND AXIS ~
    Q294=+0    ;1ST POINT 3RD AXIS ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q333=+0    ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER
21 L  Z+55 FMAX
22 * - Probe WCS2
23 L  X-55  Y+0 R0 FMAX
24 L  Z+55 R0 FMAX
25 TCH PROBE 419 DATUM IN ONE AXIS ~
    Q263=-55   ;1ST POINT 1ST AXIS ~
    Q264=+0    ;1ST POINT 2ND AXIS ~
    Q261=-4    ;MEASURING HEIGHT ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q272=+1    ;MEASURING AXIS ~
    Q267=+1    ;TRAVERSE DIRECTION ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q333=-40   ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER
26 L  Z+55 FMAX
27 * - Probe WCS2 (2)
28 L  X-22.5  Y+45 R0 FMAX
29 L  Z+55 R0 FMAX
30 TCH PROBE 419 DATUM IN ONE AXIS ~
    Q263=-22.5 ;1ST POINT 1ST AXIS ~
    Q264=+45   ;1ST POINT 2ND AXIS ~
    Q261=-4    ;MEASURING HEIGHT ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q272=+2    ;MEASURING AXIS ~
    Q267=-1    ;TRAVERSE DIRECTION ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q333=+30   ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER
31 L  Z+55 FMAX
32 M5
33 L M140 MB MAX
34 M30
35 END PGM plunger_linear_guide_probing MM 
