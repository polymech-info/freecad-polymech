0  BEGIN PGM cyl_probe_z_cyl_contour2 MM 
1  BLK FORM 0.1 Z  X-35  Y-35  Z-50
2  BLK FORM 0.2  X+35  Y+35  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #5 D=10 - ZMIN=-2 - ZMAX=+15 - flat end mill
6  ;  #100 D=6 CR=3 - ZMIN=-3 - ZMAX=+155 - probe
7  ;    Stock Haas Probe
8  ;    Renishaw
9  ;    OMP40-2
10 ;-------------------------------------
11 ;
12 * - Probe WCS3 (2)
13 M5
14 TOOL CALL 100 Z S50
15 ;Stock Haas Probe
16 TOOL DEF 5
17 L M140 MB MAX
18 L  X-16.021  Y+1.631 R0 FMAX
19 L  Z+155 R0 FMAX
20 CYCL DEF 32.0 TOLERANCE
21 CYCL DEF 32.1
22 TCH PROBE 417 DATUM IN TS AXIS ~
    Q263=-16.021 ;1ST POINT 1ST AXIS ~
    Q264=+1.631 ;1ST POINT 2ND AXIS ~
    Q294=+0    ;1ST POINT 3RD AXIS ~
    Q320=+12   ;SET-UP CLEARANCE ~
    Q260=+5    ;CLEARANCE HEIGHT ~
    Q305=+0    ;NUMBER IN TABLE ~
    Q333=+0    ;DATUM ~
    Q303=+1    ;MEAS. VALUE TRANSFER
23 L  Z+155 FMAX
24 * - Probe WCS2 (2)
25 L  X+0  Y+0 R0 FMAX
26 L  Z+55 R0 FMAX
27 TCH PROBE 413 DATUM OUTSIDE CIRCLE ~
    Q321=+0    ;CENTER IN 1ST AXIS ~
    Q322=+0    ;CENTER IN 2ND AXIS ~
    Q262=+65   ;NOMINAL DIAMETER ~
    Q325=+0    ;STARTING ANGLE ~
    Q247=+90   ;STEPPING ANGLE ~
    Q261=+0    ;MEASURING HEIGHT ~
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
28 L  Z+55 FMAX
29 L M140 MB MAX
30 * - 2D Contour3
31 M5
32 TOOL CALL 5 Z S9700
33 TOOL DEF 100
34 L M140 MB MAX
35 M3
36 L  X+1  Y-40.5 R0 FMAX
37 L  Z+15 R0 FMAX
38 M8
39 FN 0: Q52 =+2328 ; Finish
40 FN 0: Q53 =+2328 ; Entry
41 FN 0: Q54 =+2328 ; Exit
42 FN 0: Q58 =+30 ; Plunge
43 L  Z+5 FMAX
44 L  Z-1 FQ58
45 CC  Y-39.5  Z-1
46 CP IPA+90 DR+ FQ53
47 L  Y-38.5  Z-2
48 CC  X+0  Y-38.5
49 CP IPA+90 DR+
50 CC  X+0  Y+0
51 CP IPA-360 DR- FQ52
52 CC  X+0  Y-38.5
53 CP IPA+90 DR+ FQ54
54 L  X-1  Y-39.5
55 CC  Y-39.5  Z-1
56 CP IPA-90 DR-
57 L  Y-40.5  Z+15 FMAX
58 M9
59 M5
60 L M140 MB MAX
61 M30
62 END PGM cyl_probe_z_cyl_contour2 MM 
