0  BEGIN PGM contour-right MM 
1  BLK FORM 0.1 Z  X-60  Y-60  Z-10
2  BLK FORM 0.2  X+0  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-12 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour15
9  M5
10 TOOL CALL 27 Z S9702
11 L M140 MB MAX
12 M3
13 L  X-69.95  Y-4.65 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+1 F1350
20 L  Z-10.6
21 CC  X-68.55  Z-10.6
22 CP IPA-90 DR- F4051
23 L  X-67.15  Z-12
24 CC  X-67.15  Y-3.25
25 CP IPA+90 DR+
26 CC  X-56.75  Y-3.25
27 CP IPA-90 DR-
28 L  X-3.25  Y+5.75
29 CC  X-3.25  Y-3.25
30 CP IPA-90 DR-
31 L  X+5.75  Y-56.75
32 CC  X-3.25  Y-56.75
33 CP IPA-90 DR-
34 L  X-56.75  Y-65.75
35 CC  X-56.75  Y-56.75
36 CP IPA-90 DR-
37 CC  X-67.15  Y-56.75
38 CP IPA+90 DR+
39 L  X-68.55  Y-55.35
40 CC  X-68.55  Z-10.6
41 CP IPA+90 DR+
42 L  X-69.95  Z+15 FMAX
43 M9
44 M5
45 L M140 MB MAX
46 M30
47 END PGM contour-right MM 
