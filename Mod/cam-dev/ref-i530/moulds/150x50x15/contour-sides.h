0  BEGIN PGM contour-sides MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-10
2  BLK FORM 0.2  X+180  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-15 - ZMAX=+20 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (12)
9  M5
10 TOOL CALL 27 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+9.4  Y-91.2 R0 FMAX
14 L  Z+20 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+4 FMAX
19 L  Z-13.6 F184
20 CC  Y-89.8  Z-13.6
21 CP IPA+90 DR+ F551
22 L  Y-88.4  Z-15
23 CC  X+8  Y-88.4
24 CP IPA+90 DR+
25 CC  X+8  Y-72
26 CP IPA-90 DR-
27 L  X-7  Y-8
28 CC  X+8  Y-8
29 CP IPA-90 DR-
30 CC  X+8  Y+8.4
31 CP IPA+90 DR+
32 L  X+9.4  Y+9.8
33 CC  Y+9.8  Z-13.6
34 CP IPA+90 DR+
35 L  Y+11.2  Z+5 FMAX
36 L  X+170.6 FMAX
37 L  Z+4 FMAX
38 L  Z-13.6 F184
39 CC  Y+9.8  Z-13.6
40 CP IPA-90 DR- F551
41 L  Y+8.4  Z-15
42 CC  X+172  Y+8.4
43 CP IPA+90 DR+
44 CC  X+172  Y-8
45 CP IPA-90 DR-
46 L  X+187  Y-72
47 CC  X+172  Y-72
48 CP IPA-90 DR-
49 CC  X+172  Y-88.4
50 CP IPA+90 DR+
51 L  X+170.6  Y-89.8
52 CC  Y-89.8  Z-13.6
53 CP IPA-90 DR-
54 L  Y-91.2  Z+20 FMAX
55 M9
56 M5
57 L M140 MB MAX
58 M30
59 END PGM contour-sides MM 
