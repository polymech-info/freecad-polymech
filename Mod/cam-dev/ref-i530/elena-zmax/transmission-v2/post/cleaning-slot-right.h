0  BEGIN PGM cleaning-slot-right MM 
1  BLK FORM 0.1 Z  X-33  Y-35  Z-30
2  BLK FORM 0.2  X+83  Y+35  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 CR=5 - ZMIN=-11 - ZMAX=+15 - ball end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour5 (2)
9  M5
10 TOOL CALL 12 Z S9702
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+5 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-11 F3206
19 CC  X+0  Y+0.5
20 CP IPA+171.476 DR+
21 L  X-26.614  Y+4.994
22 L  X-26.688  Y+5
23 L  X-33
24 CC  X-33  Y+4
25 CP IPA+90 DR+
26 L  X-34  Y+3
27 CC  Y+3  Z-10
28 CP IPA-90 DR-
29 L  Y+2  Z+5
30 L  X+0  Y+0
31 L  Z-11
32 L  X-0.06  Y-0.004
33 L  X-33.06  Y-4.004
34 CC  X-33  Y-4.5
35 CP IPA+173.089 DR+
36 L  X-26.688  Y-5
37 CC  X-26.688  Y-4
38 CP IPA+90 DR+
39 L  X-25.688  Y-3
40 CC  Y-3  Z-10
41 CP IPA+90 DR+
42 L  Y-2  Z+5
43 L  X+0  Y+0
44 L  Z-11
45 CC  X+0.5  Y+0
46 CP IPA+171.476 DR+
47 L  X+4.994  Y+26.614
48 L  X+5  Y+26.688
49 L  Y+35
50 CC  X+4  Y+35
51 CP IPA+90 DR+
52 L  X+3  Y+36
53 CC  X+3  Z-10
54 CP IPA+90 DR+
55 L  X+2  Z+5
56 L  X+0  Y+0
57 L  Z-11
58 L  X-0.003  Y+0.057
59 L  X-4.003  Y+35.057
60 CC  X-4.5  Y+35
61 CP IPA+173.48 DR+
62 L  X-5  Y+26.688
63 CC  X-4  Y+26.688
64 CP IPA+90 DR+
65 L  X-3  Y+25.688
66 CC  X-3  Z-10
67 CP IPA-90 DR-
68 L  X-2  Z+15 FMAX
69 M9
70 M5
71 L M140 MB MAX
72 M30
73 END PGM cleaning-slot-right MM 
