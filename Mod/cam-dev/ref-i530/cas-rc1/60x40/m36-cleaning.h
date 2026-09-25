0  BEGIN PGM m36-cleaning MM 
1  BLK FORM 0.1 Z  X+0  Y-40  Z-60
2  BLK FORM 0.2  X+785  Y+0  Z+0
3  ;-------------------------------------
4  ;T27 D=+14 CR=+0 - ZMIN=-16 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour14
10 TOOL CALL 27 Z S6064
11 L M140 MB MAX
12 M3
13 L  X+747  Y-20 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-16 F632
20 L  X+746.986  Y-20.006
21 L  X+746.98  Y-20.02
22 L  Y-30.98
23 L  X+746.986  Y-30.994
24 L  X+747  Y-31
25 CC  X+747  Y-20
26 CP IPA+412.087 DR+
27 L  X+755.678  Y-26.759  Z+5 FMAX
28 L  X+38  Y-20 FMAX
29 L  Z-16 F632
30 L  X+38.014  Y-19.994
31 L  X+38.02  Y-19.98
32 L  Y-9.02
33 L  X+38.014  Y-9.006
34 L  X+38  Y-9
35 CC  X+38  Y-20
36 CP IPA+412.087 DR+
37 L  X+29.322  Y-13.241  Z+15 FMAX
38 M9
39 M5
40 L M140 MB MAX
41 M30
42 END PGM m36-cleaning MM 
