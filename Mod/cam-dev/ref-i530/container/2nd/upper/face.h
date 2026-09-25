0  BEGIN PGM face MM 
1  BLK FORM 0.1 Z  X+0  Y-146.6  Z-22.01
2  BLK FORM 0.2  X+298  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-0.3 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (2)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+350  Y-136.9 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7.7 FMAX
19 CC  X+342  Z+7.7
20 CP IPA+90 DR+ F1000
21 L  X+298  Z-0.3
22 L  X+0
23 CC  X+0  Z+7.7
24 CP IPA+90 DR+
25 L  X+350  Y-87.7  Z+7.7 FMAX
26 CC  X+342  Z+7.7
27 CP IPA+90 DR+ F1000
28 L  X+298  Z-0.3
29 L  X+0
30 CC  X+0  Z+7.7
31 CP IPA+90 DR+
32 L  X+350  Y-38.5  Z+7.7 FMAX
33 CC  X+342  Z+7.7
34 CP IPA+90 DR+ F1000
35 L  X+298  Z-0.3
36 L  X+0
37 CC  X+0  Z+7.7
38 CP IPA+90 DR+
39 L  X-8  Z+15 FMAX
40 M9
41 M5
42 L M140 MB MAX
43 M30
44 END PGM face MM 
