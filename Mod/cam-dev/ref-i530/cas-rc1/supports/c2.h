0  BEGIN PGM c2 MM 
1  BLK FORM 0.1 Z  X-150  Y-80  Z-8
2  BLK FORM 0.2  X+0  Y+0  Z+0
3  ;-------------------------------------
4  ;T6 D=+8 CR=+0 - ZMIN=-10 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour14 (4)
10 TOOL CALL 6 Z S6064
11 L M140 MB MAX
12 M3
13 L  X-60.731  Y-74.074 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-10 F184
20 L  X-60.729  Y-71.469 F552
21 L  X-60.726  Y-66.469
22 L  X-60.718  Y-56.269
23 L  X-60.717  Y-53.664
24 L  X-60.713  Y-48.664
25 L  Y-31.336
26 L  X-60.715  Y-28.731
27 L  X-60.718  Y-23.731
28 L  X-60.726  Y-13.531
29 L  X-60.727  Y-10.926
30 L  X-60.731  Y-5.926
31 L  Z+15 FMAX
32 M9
33 M5
34 L M140 MB MAX
35 M30
36 END PGM c2 MM 
