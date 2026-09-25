0  BEGIN PGM cutout-100-32 MM 
1  BLK FORM 0.1 Z  X-90  Y-40  Z-10
2  BLK FORM 0.2  X+90  Y+40  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-10 - ZMAX=+20 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour1 (18)
9  M5
10 TOOL CALL 27 Z S4851
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+4 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-10 F551
19 CC  X+0  Y+0.7
20 CP IPA+90 DR+
21 L  X+0.7  Y+8.55
22 CC  X+0  Y+8.55
23 CP IPA+90 DR+
24 L  X-40.2  Y+9.25
25 L  X-43 F138
26 L  Y-6.45 F551
27 L  Y-9.25 F138
28 L  X+40.2 F551
29 L  X+43 F138
30 L  Y+6.45 F551
31 L  Y+9.25 F138
32 L  X-10 F551
33 CC  X-10  Y+7.85
34 CP IPA+90 DR+
35 L  X-11.4  Y+6.45
36 CC  Y+6.45  Z-8.6
37 CP IPA-90 DR-
38 L  Y+5.05  Z+20 FMAX
39 M9
40 M5
41 L M140 MB MAX
42 M30
43 END PGM cutout-100-32 MM 
