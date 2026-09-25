0  BEGIN PGM contour MM 
1  BLK FORM 0.1 Z  X+0  Y-500  Z-30
2  BLK FORM 0.2  X+951.6  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #21 D=20 - ZMIN=-32 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (2)
9  M5
10 TOOL CALL 21 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-2  Y+16 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-30 F333
20 CC  Y+14  Z-30
21 CP IPA-90 DR- F1000
22 L  Y+12  Z-32
23 CC  X+0  Y+12
24 CP IPA+90 DR+
25 L  X+951.6  Y+10
26 CC  X+951.6  Y+0
27 CP IPA-90 DR-
28 L  X+961.6  Y-500
29 CC  X+951.6  Y-500
30 CP IPA-90 DR-
31 L  X+0  Y-510
32 CC  X+0  Y-500
33 CP IPA-90 DR-
34 L  X-10  Y+0
35 CC  X+0  Y+0
36 CP IPA-90 DR-
37 CC  X+0  Y+12
38 CP IPA+90 DR+
39 L  X+2  Y+14
40 CC  Y+14  Z-30
41 CP IPA+90 DR+
42 L  Y+16  Z+15 FMAX
43 M9
44 M5
45 L M140 MB MAX
46 M30
47 END PGM contour MM 
