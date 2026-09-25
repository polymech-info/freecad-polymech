0  BEGIN PGM face-top-x MM 
1  BLK FORM 0.1 Z  X+0  Y-145  Z-25
2  BLK FORM 0.2  X+300  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.4 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face3
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+351.892  Y-148.02 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.6 FMAX
19 CC  X+343.892  Z+7.6
20 CP IPA+90 DR+ F1000
21 L  X+342  Z-0.4
22 L  X-42
23 CC  X-42  Y-129.76
24 CP IPA-180 DR-
25 L  X+342  Y-111.5
26 CC  X+342  Y-93.24
27 CP IPA+180 DR+
28 L  X-42  Y-74.98
29 CC  X-42  Y-56.72
30 CP IPA-180 DR-
31 L  X+342  Y-38.46
32 CC  X+342  Z+7.6
33 CP IPA-90 DR-
34 L  X+350  Z+15 FMAX
35 M9
36 M5
37 L M140 MB MAX
38 M30
39 END PGM face-top-x MM 
