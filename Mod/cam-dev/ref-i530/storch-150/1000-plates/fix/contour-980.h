0  BEGIN PGM contour-980 MM 
1  BLK FORM 0.1 Z  X-966.8  Y-501  Z-30
2  BLK FORM 0.2  X-13.2  Y+1  Z+1
3  ;-------------------------------------
4  ;Tools
5  ;  #21 D=20 - ZMIN=-30 - ZMAX=+16 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 21 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+1.8  Y+2 R0 FMAX
14 L  Z+16 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+6 FMAX
19 L  Z-28 F333
20 CC  X-0.2  Z-28
21 CP IPA+90 DR+ F1000
22 L  X-2.2  Z-30
23 CC  X-2.2  Y+0
24 CP IPA+90 DR+
25 L  X-4.2  Y-500
26 CC  X-14.2  Y-500
27 CP IPA-90 DR-
28 L  X-965.8  Y-510
29 CC  X-965.8  Y-500
30 CP IPA-90 DR-
31 L  X-975.8  Y+0
32 CC  X-977.8  Y+0
33 CP IPA+90 DR+
34 L  X-979.8  Y+2
35 CC  X-979.8  Z-28
36 CP IPA+90 DR+
37 L  X-981.8  Z+16 FMAX
38 M9
39 M5
40 L M140 MB MAX
41 M30
42 END PGM contour-980 MM 
