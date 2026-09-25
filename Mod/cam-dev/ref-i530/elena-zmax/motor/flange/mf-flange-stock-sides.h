0  BEGIN PGM mf-flange-stock-sides MM 
1  BLK FORM 0.1 Z  X-1  Y-70  Z-30
2  BLK FORM 0.2  X+301  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #21 D=20 - ZMIN=-32 - ZMAX=+60 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 21 Z S5000
11 L M140 MB MAX
12 M3
13 L  X-16  Y-72 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z+2 F333
20 L  Z-30
21 CC  X-14  Z-30
22 CP IPA-90 DR- F1000
23 L  X-12  Z-32
24 CC  X-12  Y-70
25 CP IPA+90 DR+
26 L  X-10  Y+0
27 CC  X-12  Y+0
28 CP IPA+90 DR+
29 L  X-14  Y+2
30 CC  X-14  Z-30
31 CP IPA+90 DR+
32 L  X-16  Z+50 FMAX
33 L  X+316 FMAX
34 L  Z+5 FMAX
35 L  Z+2 F333
36 L  Z-30
37 CC  X+314  Z-30
38 CP IPA+90 DR+ F1000
39 L  X+312  Z-32
40 CC  X+312  Y+0
41 CP IPA+90 DR+
42 L  X+310  Y-70
43 CC  X+312  Y-70
44 CP IPA+90 DR+
45 L  X+314  Y-72
46 CC  X+314  Z-30
47 CP IPA-90 DR-
48 L  X+316  Z+60 FMAX
49 M9
50 M5
51 L M140 MB MAX
52 M30
53 END PGM mf-flange-stock-sides MM 
