0  BEGIN PGM tb-countour-left-4w MM 
1  BLK FORM 0.1 Z  X+4  Y-207.8  Z-30
2  BLK FORM 0.2  X+482.9  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=16 - ZMIN=-31.9 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 27 Z S6000
11 L M140 MB MAX
12 M3
13 L  X-10.5  Y-209.4 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-30.3 F402
20 CC  X-8.9  Z-30.3
21 CP IPA-90 DR- F1206
22 L  X-7.3  Z-31.9
23 CC  X-7.3  Y-207.8
24 CP IPA+90 DR+
25 L  X-5.7  Y+0
26 CC  X-7.3  Y+0
27 CP IPA+90 DR+
28 L  X-8.9  Y+1.6
29 CC  X-8.9  Z-30.3
30 CP IPA+90 DR+
31 L  X-10.5  Z+5 FMAX
32 L  X-8.9  Y-209.4 FMAX
33 L  Z-30.3 F402
34 CC  X-7.3  Z-30.3
35 CP IPA-90 DR- F1206
36 L  X-5.7  Z-31.9
37 CC  X-5.7  Y-207.8
38 CP IPA+90 DR+
39 L  X-4.1  Y+0
40 CC  X-5.7  Y+0
41 CP IPA+90 DR+
42 L  X-7.3  Y+1.6
43 CC  X-7.3  Z-30.3
44 CP IPA+90 DR+
45 L  X-8.9  Z+15 FMAX
46 M9
47 M5
48 L M140 MB MAX
49 M30
50 END PGM tb-countour-left-4w MM 
