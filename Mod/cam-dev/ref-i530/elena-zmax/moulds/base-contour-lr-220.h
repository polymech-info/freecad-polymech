0  BEGIN PGM base-contour-lr-220 MM 
1  BLK FORM 0.1 Z  X+0  Y-232  Z-30
2  BLK FORM 0.2  X+232  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #21 D=20 - ZMIN=-32 - ZMAX=+110 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (3)
9  M5
10 TOOL CALL 21 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+242  Y-4 R0 FMAX
14 L  Z+110 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-30 F333
20 CC  X+240  Z-30
21 CP IPA+90 DR+ F1000
22 L  X+238  Z-32
23 CC  X+238  Y-6
24 CP IPA+90 DR+
25 L  X+236  Y-226
26 CC  X+238  Y-226
27 CP IPA+90 DR+
28 L  X+240  Y-228
29 CC  X+240  Z-30
30 CP IPA-90 DR-
31 L  X+242  Z+100 FMAX
32 L  X-10 FMAX
33 L  Z+5 FMAX
34 L  Z-30 F333
35 CC  X-8  Z-30
36 CP IPA-90 DR- F1000
37 L  X-6  Z-32
38 CC  X-6  Y-226
39 CP IPA+90 DR+
40 L  X-4  Y-6
41 CC  X-6  Y-6
42 CP IPA+90 DR+
43 L  X-8  Y-4
44 CC  X-8  Z-30
45 CP IPA+90 DR+
46 L  X-10  Z+110 FMAX
47 M9
48 M5
49 L M140 MB MAX
50 M30
51 END PGM base-contour-lr-220 MM 
