0  BEGIN PGM contour-900x MM 
1  BLK FORM 0.1 Z  X+0  Y-501.6  Z-30
2  BLK FORM 0.2  X+981.6  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #21 D=20 - ZMIN=-31 - ZMAX=+60 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2
9  M5
10 TOOL CALL 21 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-1.2  Y+15.2 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2 F333
20 L  Z-29
21 CC  Y+13.2  Z-29
22 CP IPA-90 DR- F1000
23 L  Y+11.2  Z-31
24 CC  X+0.8  Y+11.2
25 CP IPA+90 DR+
26 L  X+980.8  Y+9.2
27 CC  X+980.8  Y-0.8
28 CP IPA-90 DR-
29 L  X+990.8  Y-500.8
30 CC  X+980.8  Y-500.8
31 CP IPA-90 DR-
32 L  X+0.8  Y-510.8
33 CC  X+0.8  Y-500.8
34 CP IPA-90 DR-
35 L  X-9.2  Y-0.8
36 CC  X+0.8  Y-0.8
37 CP IPA-90 DR-
38 CC  X+0.8  Y+11.2
39 CP IPA+90 DR+
40 L  X+2.8  Y+13.2
41 CC  Y+13.2  Z-29
42 CP IPA+90 DR+
43 L  Y+15.2  Z+60 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM contour-900x MM 
