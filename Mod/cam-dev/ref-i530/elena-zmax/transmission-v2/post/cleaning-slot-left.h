0  BEGIN PGM cleaning-slot-left MM 
1  BLK FORM 0.1 Z  X-33  Y-35  Z-30
2  BLK FORM 0.2  X+83  Y+35  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 CR=5 - ZMIN=-11 - ZMAX=+15 - ball end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour5
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
19 CC  X-0.5  Y+0
20 CP IPA+171.476 DR+
21 L  X-4.994  Y-26.614
22 L  X-5  Y-26.688
23 L  Y-35
24 CC  X-4  Y-35
25 CP IPA+90 DR+
26 L  X-3  Y-36
27 CC  X-3  Z-10
28 CP IPA-90 DR-
29 L  X-2  Z+5
30 L  X+0  Y+0
31 L  Z-11
32 L  X+0.003  Y-0.057
33 L  X+4.003  Y-35.057
34 CC  X+4.5  Y-35
35 CP IPA+173.48 DR+
36 L  X+5  Y-26.688
37 CC  X+4  Y-26.688
38 CP IPA+90 DR+
39 L  X+3  Y-25.688
40 CC  X+3  Z-10
41 CP IPA+90 DR+
42 L  X+2  Z+5
43 L  X+0  Y+0
44 L  Z-11
45 L  X-0.06  Y-0.004
46 L  X-33.06  Y-4.004
47 CC  X-33  Y-4.5
48 CP IPA+173.089 DR+
49 L  X-26.688  Y-5
50 CC  X-26.688  Y-4
51 CP IPA+90 DR+
52 L  X-25.688  Y-3
53 CC  Y-3  Z-10
54 CP IPA+90 DR+
55 L  Y-2  Z+5
56 L  X+0  Y+0
57 L  Z-11
58 CC  X+0  Y+0.5
59 CP IPA+171.476 DR+
60 L  X-26.614  Y+4.994
61 L  X-26.688  Y+5
62 L  X-33
63 CC  X-33  Y+4
64 CP IPA+90 DR+
65 L  X-34  Y+3
66 CC  Y+3  Z-10
67 CP IPA-90 DR-
68 L  Y+2  Z+15 FMAX
69 M9
70 M5
71 L M140 MB MAX
72 M30
73 END PGM cleaning-slot-left MM 
