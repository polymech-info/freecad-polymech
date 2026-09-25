0  BEGIN PGM probe_z MM 
1  BLK FORM 0.1 Z  X-80  Y-80  Z-24.7
2  BLK FORM 0.2  X+80  Y+80  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #100 D=6 CR=3 - ZMIN=+0 - ZMAX=+55 - probe
6  ;    Stock Haas Probe
7  ;    Renishaw
8  ;    OMP40-2
9  ;-------------------------------------
10 ;
11 * - Probe WCS3
12 M5
13 TOOL CALL 100 Z S50
14 ;Stock Haas Probe
15 L M140 MB MAX
16 L  X+0  Y+50.25 R0 FMAX
17 L  Z+55 R0 FMAX
18 CYCL DEF 32.0 TOLERANCE
19 CYCL DEF 32.1
20 TCH PROBE 417 DATUM IN TS AXIS ~
    Q263=+0    ;1ST POINT 1ST AXIS ~
    Q264=+50.25 ;1ST POINT 2ND AXIS ~
    Q294=+0    ;1ST POINT 3RD AXIS ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q333=+0    ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER
21 L  Z+55 FMAX
22 M5
23 L M140 MB MAX
24 M30
25 END PGM probe_z MM 
