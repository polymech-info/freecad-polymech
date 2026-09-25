0  BEGIN PGM face-top-1 MM 
1  BLK FORM 0.1 Z  X+0  Y-68  Z-8
2  BLK FORM 0.2  X+210  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face3 (7)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+298  Y-34 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7 FMAX
19 CC  X+290  Z+7
20 CP IPA+90 DR+ F1000
21 L  X-80  Z-1
22 CC  X-80  Z+7
23 CP IPA+90 DR+
24 L  X-88  Z+15 FMAX
25 M9
26 M5
27 L M140 MB MAX
28 M30
29 END PGM face-top-1 MM 
