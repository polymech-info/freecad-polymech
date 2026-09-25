0  BEGIN PGM face-2 MM 
1  BLK FORM 0.1 Z  X+0  Y-120  Z-25
2  BLK FORM 0.2  X+120  Y+0  Z+0
3  ;-------------------------------------
4  ;Tools
5  ;  #23 D=80 - ZMIN=-1 - ZMAX=+15 - face mill
6  ;-------------------------------------
7  ;
8  * - Face1 (2)
9  M5
10 TOOL CALL 23 Z S5000
11 L M140 MB MAX
12 M3
13 L  X+178.01  Y-99 R0 FMAX
14 L  Z+15 R0 FMAX
15 M8
16 CYCL DEF 32.0 TOLERANCE
17 CYCL DEF 32.1
18 L  Z+7 FMAX
19 CC  X+170.01  Z+7
20 CP IPA+90 DR+ F1000
21 L  X-50.01  Z-1
22 CC  X-50.01  Z+7
23 CP IPA+90 DR+
24 L  X+178.01  Y-38.7  Z+7 FMAX
25 CC  X+170.01  Z+7
26 CP IPA+90 DR+ F1000
27 L  X-50.01  Z-1
28 CC  X-50.01  Z+7
29 CP IPA+90 DR+
30 L  X-58.01  Z+15 FMAX
31 M9
32 M5
33 L M140 MB MAX
34 M30
35 END PGM face-2 MM 
