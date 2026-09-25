0  BEGIN PGM contour-outer-x MM 
1  BLK FORM 0.1 Z  X+0  Y-122  Z-50
2  BLK FORM 0.2  X+122  Y+0  Z+0
3  ;-------------------------------------
4  ;T6 D=+7.96 CR=+0 - ZMIN=-41.5 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour3 (26)
10 TOOL CALL 6 Z S8000
11 L M140 MB MAX
12 M3
13 L  X+61.796  Y-127.368 R0 FMAX
14 L  Z+25 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-30 FMAX
19 L  Z-40.704 F1059
20 CC  Y-126.572  Z-40.704
21 CP IPA+90 DR+ F3177
22 L  Y-125.776  Z-41.5
23 CC  X+61  Y-125.776
24 CP IPA+90 DR+
25 L  X+1  Y-124.98
26 CC  X+1  Y-121
27 CP IPA-90 DR-
28 L  X-2.98  Y-1
29 CC  X+1  Y-1
30 CP IPA-90 DR-
31 L  X+121  Y+2.98
32 CC  X+121  Y-1
33 CP IPA-90 DR-
34 L  X+124.98  Y-121
35 CC  X+121  Y-121
36 CP IPA-90 DR-
37 L  X+56  Y-124.98
38 L  Z+25 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM contour-outer-x MM 
