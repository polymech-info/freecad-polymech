0  BEGIN PGM 27-bore MM 
1  BLK FORM 0.1 Z  X-71.5  Y-71.5  Z-20
2  BLK FORM 0.2  X+71.5  Y+71.5  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #27 D=14 - ZMIN=-19 - ZMAX=+15 - flat end mill
6  ;-------------------------------------
7  ;
8  * - 2D Contour2 (6)
9  M5
10 TOOL CALL 27 Z S4043
11 L M140 MB MAX
12 M3
13 L  X+0  Y+0 R0 FMAX
14 L  Z+5 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z-19 F550
19 CC  X-0.7  Y+0
20 CP IPA+90 DR+
21 L  X-1.4  Y+0.7
22 CC  X-1.4  Y+0
23 CP IPA+90 DR+
24 CC  X+0  Y+0
25 CP IPA+360 DR+
26 CC  X+1.5  Y+0
27 CP IPA+180 DR+
28 CC  X+0  Y+0
29 CP IPA+180 DR+
30 CC  X+0.7  Y+0
31 CP IPA+180 DR+
32 CC  X+0  Y+0
33 CP IPA+720 DR+
34 CC  X+5.1  Y+0
35 CP IPA+90 DR+
36 L  X+3.7  Y+1.4
37 CC  X+3.7  Z-17.6
38 CP IPA+90 DR+
39 L  X+2.3  Z+15 FMAX
40 M9
41 M5
42 L M140 MB MAX
43 M30
44 END PGM 27-bore MM 
