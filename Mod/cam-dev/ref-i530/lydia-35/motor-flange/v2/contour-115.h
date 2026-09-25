0  BEGIN PGM contour-115 MM 
1  BLK FORM 0.1 Z  X-60  Y-60  Z-20
2  BLK FORM 0.2  X+60  Y+60  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-8 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour4
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X-68.7  Y-1.4 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+1 F183
20 L  Z-6.6
21 CC  X-67.3  Z-6.6
22 CP IPA-90 DR- F550
23 L  X-65.9  Z-8
24 CC  X-65.9  Y+0
25 CP IPA+90 DR+
26 CC  X+0  Y+0
27 CP IPA-360 DR-
28 CC  X-65.9  Y+0
29 CP IPA+90 DR+
30 L  X-67.3  Y+1.4
31 CC  X-67.3  Z-6.6
32 CP IPA+90 DR+
33 L  X-68.7  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM contour-115 MM 
