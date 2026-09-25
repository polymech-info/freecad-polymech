0  BEGIN PGM contour-up MM 
1  BLK FORM 0.1 Z  X+0  Y-121.5  Z-30
2  BLK FORM 0.2  X+650  Y+1.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-17 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (7)
9  M5
10 TOOL CALL 27 Z S6064
11 L M140 MB MAX
12 M3
13 L  X+651.4  Y-131.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-15.6 F184
20 CC  Y-129.8  Z-15.6
21 CP IPA+90 DR+ F552
22 L  Y-128.4  Z-17
23 CC  X+650  Y-128.4
24 CP IPA+90 DR+
25 L  X+0  Y-127
26 CC  X+0  Y-128.4
27 CP IPA+90 DR+
28 L  X-1.4  Y-129.8
29 CC  Y-129.8  Z-15.6
30 CP IPA-90 DR-
31 L  Y-131.2  Z+5 FMAX
32 L  Y+11.2 FMAX
33 L  Z-15.6 F184
34 CC  Y+9.8  Z-15.6
35 CP IPA-90 DR- F552
36 L  Y+8.4  Z-17
37 CC  X+0  Y+8.4
38 CP IPA+90 DR+
39 L  X+650  Y+7
40 CC  X+650  Y+8.4
41 CP IPA+90 DR+
42 L  X+651.4  Y+9.8
43 CC  Y+9.8  Z-15.6
44 CP IPA+90 DR+
45 L  Y+11.2  Z+15 FMAX
46 M9
47 M5
48 L M140 MB MAX
49 M30
50 END PGM contour-up MM 
