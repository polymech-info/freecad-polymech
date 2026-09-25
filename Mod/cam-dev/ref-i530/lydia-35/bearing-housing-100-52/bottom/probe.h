0  BEGIN PGM probe MM 
1  BLK FORM 0.1 Z  X-50  Y-50  Z-52
2  BLK FORM 0.2  X+50  Y+50  Z+0
3  ;post version: 44126
4  ;post modified: 2024-05-14 14:54:51
5  ;-------------------------------------
6  ;Tools
7  ;"TS640 50X6" D=6 CR=3 - ZMIN=-6 - ZMAX=+55 - probe
8  ;    Heidenhain
9  ;-------------------------------------
10 ;
11 * - Probe WCS7
12 M5
13 ERROR = 13 TOOL CALL "TS640 50X6" Z S50
14 L M140 MB MAX
15 LBL 1
16 CYCL DEF 247 DATUM SETTING ~
    Q339=+1    ;DATUM NUMBER
17 LBL 0
18 L  X+0  Y+0 R0 FMAX
19 L  Z+55 R0 FMAX
20 CYCL DEF 32.0 TOLERANCE
21 CYCL DEF 32.1
22 TCH PROBE 413 DATUM OUTSIDE CIRCLE ~
    Q321=+0    ;CENTER IN 1ST AXIS ~
    Q322=+0    ;CENTER IN 2ND AXIS ~
    Q262=+100  ;NOMINAL DIAMETER ~
    Q325=+0    ;STARTING ANGLE ~
    Q247=+90   ;STEPPING ANGLE ~
    Q261=-3    ;MEASURING HEIGHT ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q301=+1    ;MOVE TO CLEARANCE ~
    Q305=+1    ;NUMBER IN TABLE ~
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
23 L  Z+55 FMAX
24 CALL LBL 1 ;DATUM
25 M5
26 L M140 MB MAX
27 M30
28 END PGM probe MM 
