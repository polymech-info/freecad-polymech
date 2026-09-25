0  BEGIN PGM probe-xy MM 
1  BLK FORM 0.1 Z  X-70  Y-65  Z-59.5
2  BLK FORM 0.2  X+70  Y+0  Z+19
3  ;-------------------------------------
4  ;T100 D=+6 CR=+3 - ZMIN=+13 - probe
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - Probe WCS7 (2)
10 TOOL CALL 100 Z S50
11 L M140 MB MAX
12 L  X+0  Y-3.029 R0 FMAX
13 L  Z+74 R0 FMAX
14 CYCL DEF 32.0 TOLERANCE
15 CYCL DEF 32.1
16 TCH PROBE 409 RIDGE CENTER REF PT ~
    Q321=+0    ;CENTER IN 1ST AXIS ~
    Q322=-3.029 ;CENTER IN 2ND AXIS ~
    Q311=+55.893 ;RIDGE WIDTH ~
    Q272=+1    ;MEASURING AXIS ~
    Q261=+16   ;MEASURING HEIGHT ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+24   ;CLEARANCE HEIGHT ~
    Q305=+1    ;NUMBER IN TABLE ~
    Q405=+0    ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER ~
    Q381=+0    ;PROBE IN TS AXIS ~
    Q382=+0    ;1ST CO. FOR TS AXIS ~
    Q383=+0    ;2ND CO. FOR TS AXIS ~
    Q384=+0    ;3RD CO. FOR TS AXIS ~
    Q333=+0    ;DATUM
17 L  Z+74 FMAX
18 M5
19 L M140 MB MAX
20 M30
21 END PGM probe-xy MM 
