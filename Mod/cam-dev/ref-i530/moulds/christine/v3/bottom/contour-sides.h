0  BEGIN PGM contour-sides MM 
1  BLK FORM 0.1 Z  X+0  Y-120  Z-28
2  BLK FORM 0.2  X+120  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-11 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (2)
9  M5
10 TOOL CALL 27 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+61.4  Y-131.2 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+1 F333
20 L  Z-9.6
21 CC  Y-129.8  Z-9.6
22 CP IPA+90 DR+ F1000
23 L  Y-128.4  Z-11
24 CC  X+60  Y-128.4
25 CP IPA+90 DR+
26 L  X+0  Y-127
27 CC  X+0  Y-120
28 CP IPA-90 DR-
29 L  X-7  Y+0
30 CC  X+0  Y+0
31 CP IPA-90 DR-
32 L  X+120  Y+7
33 CC  X+120  Y+0
34 CP IPA-90 DR-
35 L  X+127  Y-120
36 CC  X+120  Y-120
37 CP IPA-90 DR-
38 L  X+60  Y-127
39 CC  X+60  Y-128.4
40 CP IPA+90 DR+
41 L  X+58.6  Y-129.8
42 CC  Y-129.8  Z-9.6
43 CP IPA-90 DR-
44 L  Y-131.2  Z+15 FMAX
45 M9
46 M5
47 L M140 MB MAX
48 M30
49 END PGM contour-sides MM 
