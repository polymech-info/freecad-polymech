0  BEGIN PGM bearing-seats MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-30
2  BLK FORM 0.2  X+320  Y+0  Z+0
3  ;-------------------------------------
4  ;T27 D=+13.97 CR=+0 - ZMIN=-28.5 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour3
10 TOOL CALL 27 Z S9702
11 L M140 MB MAX
12 M3
13 L  X+87.115  Y-40 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-28.5 F1069
20 CC  X+68.1  Y-40
21 CP IPA+390.132 DR+ F3206
22 L  X+84.546  Y-30.455  Z+5 FMAX
23 L  X+270.915  Y-40 FMAX
24 L  Z-28.5 F1069
25 CC  X+251.9  Y-40
26 CP IPA+390.132 DR+ F3206
27 L  X+268.346  Y-30.455  Z+15 FMAX
28 ;-------------------------------------
29 * - 2D Contour3
30 M3
31 L  X+417.115  Y-40 R0 FMAX
32 L  Z+15 R0 FMAX
33 L  Z+5 FMAX
34 L  Z-28.5 F1069
35 CC  X+398.1  Y-40
36 CP IPA+390.132 DR+ F3206
37 L  X+414.546  Y-30.455  Z+5 FMAX
38 L  X+600.915  Y-40 FMAX
39 L  Z-28.5 F1069
40 CC  X+581.9  Y-40
41 CP IPA+390.132 DR+ F3206
42 L  X+598.346  Y-30.455  Z+15 FMAX
43 M9
44 M5
45 L M140 MB MAX
46 M30
47 END PGM bearing-seats MM 
