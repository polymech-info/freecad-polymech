0  BEGIN PGM contour-left-right-480w MM 
1  BLK FORM 0.1 Z  X+0  Y-207.8  Z-25
2  BLK FORM 0.2  X+494  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-27 - ZMAX=+60 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (3)
9  M5
10 TOOL CALL 27 Z S8000
11 L M140 MB MAX
12 M3
13 L  X+18.2  Y+1.4 R0 FMAX
14 L  Z+60 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-25.6 F1102
20 CC  X+16.8  Z-25.6
21 CP IPA+90 DR+ F1206
22 L  X+15.4  Z-27
23 CC  X+15.4  Y+0
24 CP IPA+90 DR+
25 L  X+14  Y-207.8
26 CC  X+15.4  Y-207.8
27 CP IPA+90 DR+
28 L  X+16.8  Y-209.2
29 CC  X+16.8  Z-25.6
30 CP IPA-90 DR-
31 L  X+18.2  Z+50 FMAX
32 L  X+498.2  Y+1.4 FMAX
33 L  Z+5 FMAX
34 L  Z-25.6 F1102
35 CC  X+496.8  Z-25.6
36 CP IPA+90 DR+ F1206
37 L  X+495.4  Z-27
38 CC  X+495.4  Y+0
39 CP IPA+90 DR+
40 L  X+494  Y-207.8
41 CC  X+495.4  Y-207.8
42 CP IPA+90 DR+
43 L  X+496.8  Y-209.2
44 CC  X+496.8  Z-25.6
45 CP IPA-90 DR-
46 L  X+498.2  Z+60 FMAX
47 M9
48 M5
49 L M140 MB MAX
50 M30
51 END PGM contour-left-right-480w MM 
