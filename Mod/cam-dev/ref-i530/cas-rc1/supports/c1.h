0  BEGIN PGM c1 MM 
1  BLK FORM 0.1 Z  X-150  Y-80  Z-8
2  BLK FORM 0.2  X+0  Y+0  Z+0
3  ;-------------------------------------
4  ;T6 D=+8 CR=+0 - ZMIN=-10 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour14 (3)
10 TOOL CALL 6 Z S6064
11 L M140 MB MAX
12 M3
13 L  X-56.737  Y-83.077 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-10 F184
20 L  X-56.734  Y-78.077 F552
21 L  X-31.217  Y-78.094
22 CC  X-20.208  Y-61.397
23 CP IPA+246.718 DR+
24 L  X-56.71  Y-44.667
25 L  X-56.707  Y-40.333
26 L  X-56.71  Y-35.333
27 L  X-31.194  Y-35.315
28 CC  X-20.208  Y-18.603
29 CP IPA+246.718 DR+
30 L  X-56.734  Y-1.923
31 L  Z+15 FMAX
32 M9
33 M5
34 L M140 MB MAX
35 M30
36 END PGM c1 MM 
