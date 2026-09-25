0  BEGIN PGM cutoff-right MM 
1  BLK FORM 0.1 Z  X-300  Y-101.5  Z-30
2  BLK FORM 0.2  X+350  Y+101.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-31 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour5 (9)
9  M5
10 TOOL CALL 27 Z S8085
11 L M140 MB MAX
12 M3
13 L  X+297  Y+90 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-31 F1068
20 L  Y-90 F3203
21 L  Z+15 FMAX
22 * - 2D Contour5 (10)
23 M3
24 L  X+290  Y-97 R0 FMAX
25 L  Z+15 R0 FMAX
26 L  Z+5 FMAX
27 L  Z-31 F1068
28 L  X+110 F3203
29 L  Z+5 FMAX
30 L  Y+97 FMAX
31 L  Z-31 F1068
32 L  X+290 F3203
33 L  Z+15 FMAX
34 * - 2D Contour5 (11)
35 M3
36 L  X+103  Y-90 R0 FMAX
37 L  Z+15 R0 FMAX
38 L  Z+5 FMAX
39 L  Z-31 F1068
40 L  Y+90 F3203
41 L  Z+15 FMAX
42 M9
43 M5
44 L M140 MB MAX
45 M30
46 END PGM cutoff-right MM 
