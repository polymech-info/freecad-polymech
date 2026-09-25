0  BEGIN PGM contour MM 
1  BLK FORM 0.1 Z  X+0  Y-85  Z-30
2  BLK FORM 0.2  X+120  Y+0  Z+0
3  ;-------------------------------------
4  ;T27 D=+14 CR=+0 - ZMIN=-27 - flat end mill
5  ;-------------------------------------
6  TOOL CALL  Z ;SET TOOL AXIS FOR M140
7  L M140 MB MAX
8  ;-------------------------------------
9  * - 2D Contour3
10 TOOL CALL 27 Z S8000
11 L M140 MB MAX
12 M3
13 L  X-11.2  Y-43.9 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+5 FMAX
19 L  Z-25.6 F1059
20 CC  X-9.8  Z-25.6
21 CP IPA-90 DR- F3177
22 L  X-8.4  Z-27
23 CC  X-8.4  Y-42.5
24 CP IPA+90 DR+
25 L  X-7  Y+0
26 CC  X+0  Y+0
27 CP IPA-90 DR-
28 L  X+120  Y+7
29 CC  X+120  Y+0
30 CP IPA-90 DR-
31 L  X+127  Y-85
32 CC  X+120  Y-85
33 CP IPA-90 DR-
34 L  X+0  Y-92
35 CC  X+0  Y-85
36 CP IPA-90 DR-
37 L  X-7  Y-32.5
38 CC  X-8.4  Y-32.5
39 CP IPA+90 DR+
40 L  X-9.8  Y-31.1
41 CC  X-9.8  Z-25.6
42 CP IPA+90 DR+
43 L  X-11.2  Z+15 FMAX
44 M9
45 M5
46 L M140 MB MAX
47 M30
48 END PGM contour MM 
