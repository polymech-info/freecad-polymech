0  BEGIN PGM probe MM 
1  BLK FORM 0.1 Z  X-300  Y-101.5  Z-30
2  BLK FORM 0.2  X+350  Y+101.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #100 D=6 CR=3 - ZMIN=-6 - ZMAX=+55 - probe
6  ;    Heidenhain
7  ;-------------------------------------
8  ;
9  * - Probe WCS2 (8)
10 M5
11 TOOL CALL 100 Z S50
12 L M140 MB MAX
13 L  X+0  Y+0 R0 FMAX
14 L  Z+55 R0 FMAX
15 CYCL DEF 32.0 TOLERANCE
16 CYCL DEF 32.1
17 TCH PROBE 410 DATUM INSIDE RECTAN. ~
    Q321=+0    ;CENTER IN 1ST AXIS ~
    Q322=+0    ;CENTER IN 2ND AXIS ~
    Q323=+130  ;FIRST SIDE LENGTH ~
    Q324=+130  ;2ND SIDE LENGTH ~
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
    Q333=+0    ;DATUM
18 L  Z+55 FMAX
19 M5
20 L M140 MB MAX
21 M30
22 END PGM probe MM 
