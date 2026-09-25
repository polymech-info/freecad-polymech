0  BEGIN PGM mount-bar-contours MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-10
2  BLK FORM 0.2  X+202  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #21 D=20 - ZMIN=-12 - ZMAX=+110 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (5)
9  M5
10 TOOL CALL 21 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+217  Y+2 R0 FMAX
14 L  Z+110 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-10 F333
20 CC  X+215  Z-10
21 CP IPA+90 DR+ F1000
22 L  X+213  Z-12
23 CC  X+213  Y+0
24 CP IPA+90 DR+
25 L  X+211  Y-80
26 CC  X+213  Y-80
27 CP IPA+90 DR+
28 L  X+215  Y-82
29 CC  X+215  Z-10
30 CP IPA-90 DR-
31 L  X+217  Z+100 FMAX
32 L  X-15 FMAX
33 L  Z+5 FMAX
34 L  Z-10 F333
35 CC  X-13  Z-10
36 CP IPA-90 DR- F1000
37 L  X-11  Z-12
38 CC  X-11  Y-80
39 CP IPA+90 DR+
40 L  X-9  Y+0
41 CC  X-11  Y+0
42 CP IPA+90 DR+
43 L  X-13  Y+2
44 CC  X-13  Z-10
45 CP IPA+90 DR+
46 L  X-15  Z+110 FMAX
47 M9
48 M5
49 L M140 MB MAX
50 M30
51 END PGM mount-bar-contours MM 
