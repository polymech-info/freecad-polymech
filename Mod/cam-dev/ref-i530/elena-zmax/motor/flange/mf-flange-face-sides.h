0  BEGIN PGM mf-flange-face-sides MM 
1  BLK FORM 0.1 Z  X+0  Y-176  Z-30
2  BLK FORM 0.2  X+218  Y+0  Z+0
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
13 L  X-7  Y-135 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-30 F333
20 CC  X-5  Z-30
21 CP IPA-90 DR- F1000
22 L  X-3  Z-32
23 CC  X-3  Y-133
24 CP IPA+90 DR+
25 L  X-1  Y-43
26 CC  X-3  Y-43
27 CP IPA+90 DR+
28 L  X-5  Y-41
29 CC  X-5  Z-30
30 CP IPA+90 DR+
31 L  X-7  Z+50 FMAX
32 L  X+225 FMAX
33 L  Z+5 FMAX
34 L  Z-30 F333
35 CC  X+223  Z-30
36 CP IPA+90 DR+ F1000
37 L  X+221  Z-32
38 CC  X+221  Y-43
39 CP IPA+90 DR+
40 L  X+219  Y-133
41 CC  X+221  Y-133
42 CP IPA+90 DR+
43 L  X+223  Y-135
44 CC  X+223  Z-30
45 CP IPA-90 DR-
46 L  X+225  Z+60 FMAX
47 M9
48 M5
49 L M140 MB MAX
50 M30
51 END PGM mf-flange-face-sides MM 
