0  BEGIN PGM contour MM 
1  BLK FORM 0.1 Z  X+0  Y-120  Z-8
2  BLK FORM 0.2  X+120  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #12 D=10 - ZMIN=-9 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1
9  M5
10 TOOL CALL 12 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+82.15  Y-61 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-8 F184
20 CC  X+83.15  Z-8
21 CP IPA-90 DR- F551
22 L  X+84.15  Z-9
23 CC  X+84.15  Y-60
24 CP IPA+90 DR+
25 L  X+85.15  Y-36.85
26 L  Y-34.85 F138
27 L  X+36.85 F551
28 L  X+34.85 F138
29 L  Y-83.15 F551
30 L  Y-85.15 F138
31 L  X+83.15 F551
32 L  X+85.15 F138
33 L  Y-60 F551
34 CC  X+84.15  Y-60
35 CP IPA+90 DR+
36 L  X+83.15  Y-59
37 CC  X+83.15  Z-8
38 CP IPA+90 DR+
39 L  X+82.15  Z+15 FMAX
40 M9
41 M5
42 L M140 MB MAX
43 M30
44 END PGM contour MM 
