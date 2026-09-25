0  BEGIN PGM lathe-handle-cleanup MM 
1  BLK FORM 0.1 Z  X+0  Y-99  Z-100
2  BLK FORM 0.2  X+99  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #18 D=14 - ZMIN=-20 - ZMAX=+40 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 18 Z S4043
11 L M140 MB MAX
12 M3
13 L  X-1.2  Y-50.9 R0 FMAX
14 L  Z+40 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+11 FMAX
19 L  Z-8.6 F165
20 CC  X+0.2  Z-8.6
21 CP IPA-90 DR- F495
22 L  X+1.6  Z-10
23 CC  X+1.6  Y-49.5
24 CP IPA+90 DR+
25 CC  X+49.5  Y-49.5
26 CP IPA-360 DR-
27 CC  X+1.6  Y-49.5
28 CP IPA+90 DR+
29 L  X+0.2  Y-48.1
30 CC  X+0.2  Z-8.6
31 CP IPA+90 DR+
32 L  X-1.2  Z+20 FMAX
33 L  Y-50.9 FMAX
34 L  Z+5 FMAX
35 L  Z-18.6 F165
36 CC  X+0.2  Z-18.6
37 CP IPA-90 DR- F495
38 L  X+1.6  Z-20
39 CC  X+1.6  Y-49.5
40 CP IPA+90 DR+
41 CC  X+49.5  Y-49.5
42 CP IPA-360 DR-
43 CC  X+1.6  Y-49.5
44 CP IPA+90 DR+
45 L  X+0.2  Y-48.1
46 CC  X+0.2  Z-18.6
47 CP IPA+90 DR+
48 L  X-1.2  Z+40 FMAX
49 M9
50 M5
51 L M140 MB MAX
52 M30
53 END PGM lathe-handle-cleanup MM 
