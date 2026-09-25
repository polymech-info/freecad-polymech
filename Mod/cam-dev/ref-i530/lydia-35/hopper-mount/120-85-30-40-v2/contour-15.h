0  BEGIN PGM contour-15 MM 
1  BLK FORM 0.1 Z  X+0  Y-123  Z-30
2  BLK FORM 0.2  X+650  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-15 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (6)
9  M5
10 TOOL CALL 27 Z S6064
11 L M140 MB MAX
12 M3
13 L  X+651.4  Y-132.7 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-13.6 F184
20 CC  Y-131.3  Z-13.6
21 CP IPA+90 DR+ F552
22 L  Y-129.9  Z-15
23 CC  X+650  Y-129.9
24 CP IPA+90 DR+
25 L  X+0  Y-128.5
26 CC  X+0  Y-129.9
27 CP IPA+90 DR+
28 L  X-1.4  Y-131.3
29 CC  Y-131.3  Z-13.6
30 CP IPA-90 DR-
31 L  Y-132.7  Z+5 FMAX
32 L  Y+9.7 FMAX
33 L  Z-13.6 F184
34 CC  Y+8.3  Z-13.6
35 CP IPA-90 DR- F552
36 L  Y+6.9  Z-15
37 CC  X+0  Y+6.9
38 CP IPA+90 DR+
39 L  X+650  Y+5.5
40 CC  X+650  Y+6.9
41 CP IPA+90 DR+
42 L  X+651.4  Y+8.3
43 CC  Y+8.3  Z-13.6
44 CP IPA+90 DR+
45 L  Y+9.7  Z+15 FMAX
46 M9
47 M5
48 L M140 MB MAX
49 M30
50 END PGM contour-15 MM 
