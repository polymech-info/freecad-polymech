0  BEGIN PGM contour-outer MM 
1  BLK FORM 0.1 Z  X+0  Y-126  Z-30
2  BLK FORM 0.2  X+360  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-25 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (16)
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+5  Y+4 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-25 F483
20 L  X+355 F550
21 CC  X+355  Y-3
22 CP IPA-90 DR-
23 L  X+362  Y-123
24 CC  X+355  Y-123
25 CP IPA-90 DR-
26 L  X+5  Y-130
27 CC  X+5  Y-123
28 CP IPA-90 DR-
29 L  X-2  Y-3
30 CC  X+5  Y-3
31 CP IPA-90 DR-
32 L  X+10  Y+4
33 L  Z+15 FMAX
34 M9
35 M5
36 L M140 MB MAX
37 M30
38 END PGM contour-outer MM 
