0  BEGIN PGM probe-140 MM 
1  BLK FORM 0.1 Z  X-70  Y-70  Z-20
2  BLK FORM 0.2  X+70  Y+70  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #100 D=6 CR=3 - ZMIN=-6 - ZMAX=+55 - probe
6  ;    Renishaw
7  ;    A-5000-4160
8  ;-------------------------------------
9  ;
10 * - Probe WCS1
11 M5
12 TOOL CALL 100 Z S50
13 L M140 MB MAX
14 L  X+0  Y+0 R0 FMAX
15 L  Z+55 R0 FMAX
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 TCH PROBE 413 DATUM OUTSIDE CIRCLE ~
    Q321=+0    ;CENTER IN 1ST AXIS ~
    Q322=+0    ;CENTER IN 2ND AXIS ~
    Q262=+140  ;NOMINAL DIAMETER ~
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
19 L  Z+55 FMAX
20 M5
21 L M140 MB MAX
22 M30
23 END PGM probe-140 MM 
