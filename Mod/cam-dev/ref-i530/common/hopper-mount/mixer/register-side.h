0  BEGIN PGM register-side MM 
1  BLK FORM 0.1 Z  X+0  Y-85  Z-120
2  BLK FORM 0.2  X+60  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=13.88 - ZMIN=-2.5 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour14 (2)
9  M5
10 TOOL CALL 27 Z S6064
11 L M140 MB MAX
12 M3
13 L  X+30  Y-42.5 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-2.5 F552
20 L  X+30.006  Y-42.514
21 L  X+30.02  Y-42.52
22 L  X+42.04
23 L  X+42.054  Y-42.514
24 L  X+42.06  Y-42.5
25 CC  X+30  Y-42.5
26 CP IPA+407.509 DR+ F800
27 L  X+38.146  Y-33.607  Z+15 FMAX
28 M9
29 M5
30 L M140 MB MAX
31 M30
32 END PGM register-side MM 
