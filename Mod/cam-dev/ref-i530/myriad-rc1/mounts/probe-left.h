0  BEGIN PGM probe-left MM 
1  BLK FORM 0.1 Z  X+0  Y-140  Z-8
2  BLK FORM 0.2  X+195  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #100 D=6 CR=3 - ZMIN=-6 - ZMAX=+55 - probe
6  ;    Heidenhain
7  ;-------------------------------------
8  ;
9  * - Probe WCS1
10 M5
11 TOOL CALL 100 Z S50
12 L M140 MB MAX
13 L  X+17.5  Y-122.5 R0 FMAX
14 L  Z+55 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 TCH PROBE 412 DATUM INSIDE CIRCLE ~
    Q321=+17.5 ;CENTER IN 1ST AXIS ~
    Q322=-122.5 ;CENTER IN 2ND AXIS ~
    Q262=+24   ;NOMINAL DIAMETER ~
    Q325=+0    ;STARTING ANGLE ~
    Q247=+90   ;STEPPING ANGLE ~
    Q261=-3    ;MEASURING HEIGHT ~
    Q320=+5    ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q301=+1    ;MOVE TO CLEARANCE ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q331=+17.5 ;DATUM ~
    Q332=-122.5 ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER ~
    Q381=+0    ;PROBE IN TS AXIS ~
    Q382=+0    ;1ST CO. FOR TS AXIS ~
    Q383=+0    ;2ND CO. FOR TS AXIS ~
    Q384=+0    ;3RD CO. FOR TS AXIS ~
    Q333=+0    ;DATUM ~
    Q423=+4    ;NO. OF MEAS. POINTS ~
    Q365=+1    ;TYPE OF TRAVERSE
18 L  Z+55 FMAX
19 M5
20 L M140 MB MAX
21 M30
22 END PGM probe-left MM 
