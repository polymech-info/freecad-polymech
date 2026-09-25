0  BEGIN PGM contour-left MM 
1  BLK FORM 0.1 Z  X+0  Y-160  Z-30
2  BLK FORM 0.2  X+508  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=13 - ZMIN=-30 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour4 (10)
9  M5
10 TOOL CALL 27 Z S9702
11 L M140 MB MAX
12 M3
13 L  X-10.4  Y-161.3 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-8.7 F1069
20 CC  X-9.1  Z-8.7
21 CP IPA-90 DR- F3206
22 L  X-7.8  Z-10
23 CC  X-7.8  Y-160
24 CP IPA+90 DR+
25 L  X-6.5  Y+0
26 CC  X-7.8  Y+0
27 CP IPA+90 DR+
28 L  X-9.1  Y+1.3
29 CC  X-9.1  Z-8.7
30 CP IPA+90 DR+
31 L  X-10.4  Z+5 FMAX
32 L  Y-161.3 FMAX
33 L  Z-18.7 F1069
34 CC  X-9.1  Z-18.7
35 CP IPA-90 DR- F3206
36 L  X-7.8  Z-20
37 CC  X-7.8  Y-160
38 CP IPA+90 DR+
39 L  X-6.5  Y+0
40 CC  X-7.8  Y+0
41 CP IPA+90 DR+
42 L  X-9.1  Y+1.3
43 CC  X-9.1  Z-18.7
44 CP IPA+90 DR+
45 L  X-10.4  Z+5 FMAX
46 L  Y-161.3 FMAX
47 L  Z-28.7 F1069
48 CC  X-9.1  Z-28.7
49 CP IPA-90 DR- F3206
50 L  X-7.8  Z-30
51 CC  X-7.8  Y-160
52 CP IPA+90 DR+
53 L  X-6.5  Y+0
54 CC  X-7.8  Y+0
55 CP IPA+90 DR+
56 L  X-9.1  Y+1.3
57 CC  X-9.1  Z-28.7
58 CP IPA+90 DR+
59 L  X-10.4  Z+15 FMAX
60 M9
61 M5
62 L M140 MB MAX
63 M30
64 END PGM contour-left MM 
