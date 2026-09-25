0  BEGIN PGM cutoff-center-sides MM 
1  BLK FORM 0.1 Z  X-300  Y-101.5  Z-30
2  BLK FORM 0.2  X+350  Y+101.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-31 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour5 (14)
9  M5
10 TOOL CALL 27 Z S8085
11 L M140 MB MAX
12 M3
13 L  X-97  Y-90 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-31 F1068
20 L  Y+90 F3203
21 L  Z+5 FMAX
22 L  X+97 FMAX
23 L  Z-31 F1068
24 L  Y-90 F3203
25 L  Z+15 FMAX
26 M9
27 M5
28 L M140 MB MAX
29 M30
30 END PGM cutoff-center-sides MM 
