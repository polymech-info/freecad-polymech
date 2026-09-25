0  BEGIN PGM cutoff-left MM 
1  BLK FORM 0.1 Z  X-300  Y-101.5  Z-30
2  BLK FORM 0.2  X+350  Y+101.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-31 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour5 (12)
9  M5
10 TOOL CALL 27 Z S8085
11 L M140 MB MAX
12 M3
13 L  X-110  Y-97 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-31 F1068
20 L  X-290 F3203
21 CC  X-290  Y-90
22 CP IPA-90 DR-
23 L  X-297  Y+90
24 CC  X-290  Y+90
25 CP IPA-90 DR-
26 L  X-110  Y+97
27 L  Z+15 FMAX
28 * - 2D Contour5 (13)
29 M3
30 L  X-103  Y+90 R0 FMAX
31 L  Z+15 R0 FMAX
32 L  Z+5 FMAX
33 L  Z-31 F1068
34 L  Y-90 F3203
35 L  Z+15 FMAX
36 M9
37 M5
38 L M140 MB MAX
39 M30
40 END PGM cutoff-left MM 
