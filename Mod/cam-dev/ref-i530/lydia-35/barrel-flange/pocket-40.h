0  BEGIN PGM pocket-40 MM 
1  BLK FORM 0.1 Z  X-50  Y-50  Z-25
2  BLK FORM 0.2  X+50  Y+50  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-27 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (8)
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+5 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-27 F550
19 CC  X-0.7  Y+0
20 CP IPA+90 DR+
21 L  X-1.9  Y+0.7
22 CC  X-1.9  Y+0
23 CP IPA+90 DR+
24 CC  X+0  Y+0
25 CP IPA+360 DR+
26 CC  X+1.5  Y+0
27 CP IPA+180 DR+
28 CC  X+0  Y+0
29 CP IPA+180 DR+
30 CC  X+1.5  Y+0
31 CP IPA+180 DR+
32 CC  X+0  Y+0
33 CP IPA+180 DR+
34 CC  X+1.5  Y+0
35 CP IPA+180 DR+
36 CC  X+0  Y+0
37 CP IPA+180 DR+
38 CC  X+0.7  Y+0
39 CP IPA+180 DR+
40 CC  X+0  Y+0
41 CP IPA+720 DR+
42 CC  X+11.6  Y+0
43 CP IPA+90 DR+
44 L  X+10.2  Y+1.4
45 CC  X+10.2  Z-25.6
46 CP IPA+90 DR+
47 L  X+8.8  Z+15 FMAX
48 M9
49 M5
50 L M140 MB MAX
51 M30
52 END PGM pocket-40 MM 
