0  BEGIN PGM probe_rack MM 
1  BLK FORM 0.1 Z  X-90  Y-139  Z-12
2  BLK FORM 0.2  X+90  Y+54  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #100 D=6 CR=3 - ZMIN=-6 - ZMAX=+55 - probe
6  ;    Stock Haas Probe
7  ;    Renishaw
8  ;    OMP40-2
9  ;-------------------------------------
10 ;
11 * - Probe WCS4
12 M5
13 TOOL CALL 100 Z S50
14 ;Stock Haas Probe
15 L M140 MB MAX
16 L  X+0  Y+0 R0 FMAX
17 L  Z+55 R0 FMAX
18 CYCL DEF 32.0 TOLERANCE
19 CYCL DEF 32.1
20 TCH PROBE 412 DATUM INSIDE CIRCLE ~
    Q321=+0    ;CENTER IN 1ST AXIS ~
    Q322=+0    ;CENTER IN 2ND AXIS ~
    Q262=+25   ;NOMINAL DIAMETER ~
    Q325=+0    ;STARTING ANGLE ~
    Q247=+90   ;STEPPING ANGLE ~
    Q261=-3    ;MEASURING HEIGHT ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q301=+1    ;MOVE TO CLEARANCE ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q331=+0    ;DATUM ~
    Q332=+0    ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER ~
    Q381=+0    ;PROBE IN TS AXIS ~
    Q382=+0    ;1ST CO. FOR TS AXIS ~
    Q383=+0    ;2ND CO. FOR TS AXIS ~
    Q384=+0    ;3RD CO. FOR TS AXIS ~
    Q333=+0    ;DATUM ~
    Q423=+4    ;NO. OF MEAS. POINTS ~
    Q365=+1    ;TYPE OF TRAVERSE
21 L  Z+55 FMAX
22 M5
23 L M140 MB MAX
24 M30
25 END PGM probe_rack MM 
