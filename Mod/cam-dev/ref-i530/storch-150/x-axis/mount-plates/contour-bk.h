0  BEGIN PGM contour-bk MM 
1  BLK FORM 0.1 Z  X+0  Y-80  Z-10
2  BLK FORM 0.2  X+365  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-14 - ZMAX=+60 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (2)
9  M5
10 TOOL CALL 27 Z S3465
11 L M140 MB MAX
12 M3
13 L  X+376.2  Y+1.4 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-12.6 F1183
20 CC  X+374.8  Z-12.6
21 CP IPA+90 DR+ F550
22 L  X+373.4  Z-14
23 CC  X+373.4  Y+0
24 CP IPA+90 DR+
25 L  X+372  Y-80
26 CC  X+373.4  Y-80
27 CP IPA+90 DR+
28 L  X+374.8  Y-81.4
29 CC  X+374.8  Z-12.6
30 CP IPA-90 DR-
31 L  X+376.2  Z+50 FMAX
32 L  X-11.2 FMAX
33 L  Z+5 FMAX
34 L  Z-12.6 F1183
35 CC  X-9.8  Z-12.6
36 CP IPA-90 DR- F550
37 L  X-8.4  Z-14
38 CC  X-8.4  Y-80
39 CP IPA+90 DR+
40 L  X-7  Y+0
41 CC  X-8.4  Y+0
42 CP IPA+90 DR+
43 L  X-9.8  Y+1.4
44 CC  X-9.8  Z-12.6
45 CP IPA+90 DR+
46 L  X-11.2  Z+60 FMAX
47 M9
48 M5
49 L M140 MB MAX
50 M30
51 END PGM contour-bk MM 
