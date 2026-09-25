0  BEGIN PGM 2D Contour2 MM 
1  BLK FORM 0.1 Z  X+0  Y-130  Z-20
2  BLK FORM 0.2  X+130  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=+0 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+63.6  Y+11.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2 F333
20 L  Z+1.4
21 CC  Y+9.8  Z+1.4
22 CP IPA-90 DR- F1000
23 L  Y+8.4  Z+0
24 CC  X+65  Y+8.4
25 CP IPA+90 DR+
26 L  X+122  Y+7
27 CC  X+122  Y-8
28 CP IPA-90 DR-
29 L  X+137  Y-122
30 CC  X+122  Y-122
31 CP IPA-90 DR-
32 L  X+8  Y-137
33 CC  X+8  Y-122
34 CP IPA-90 DR-
35 L  X-7  Y-8
36 CC  X+8  Y-8
37 CP IPA-90 DR-
38 L  X+65  Y+7
39 CC  X+65  Y+8.4
40 CP IPA+90 DR+
41 L  X+66.4  Y+9.8
42 CC  Y+9.8  Z+1.4
43 CP IPA+90 DR+
44 L  Y+11.2  Z+15 FMAX
45 M9
46 M5
47 L M140 MB MAX
48 M30
49 END PGM 2D Contour2 MM 
